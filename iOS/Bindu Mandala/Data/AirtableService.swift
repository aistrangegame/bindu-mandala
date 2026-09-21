import Foundation
import SwiftData
import os

private let log = Logger(subsystem: "com.ashrey.bindu-mandala", category: "airtable")

/// Reconciles the local SwiftData store from Airtable for Śaktis, Avaraṇas, and Nityā Devīs,
/// and writes the practice back. Two tables, two roles (ruling of 2026-09-07 — events belong
/// in the ledger; the spine stays the spine): every practice event — a recognition from any
/// screen, a new-deepest ring crossing, the silence dwell, the first letter written — is one
/// row in the shared **App Activity** ledger (`ActivityLedger`) and nowhere else; the
/// **Mandala** table receives only the per-Śakti state PATCHes on the Shakti row (Last Felt,
/// Recognition Count, Status, Letter). The reads follow the writes: Her Moments and both
/// `restore*IfLocalEmpty` read the ledger. The local cache is always the source of truth at
/// read time — Airtable is a quiet background updater. Failures are silent; writes are
/// fire-and-forget behind offline queues that hold without a token and never drop for want
/// of one. The "I feel her" gesture never depends on a successful sync.
@MainActor
final class AirtableService {

    static let shared = AirtableService()

    static let baseId  = "app248ZTWhYJlvQj2"
    static let tableId = "tblrRwXJD0uP8HU8G"

    /// Avaraṇa record-id → ring number (from brief §3, confirmed live May 28, 2026).
    /// The Avaraṇa rows do not carry a Ring Number field, so we identify by record id.
    /// Immutable and Sendable, so `nonisolated` — `ActivityLedger.crossing` reads
    /// its inverse off the main actor.
    nonisolated private static let avaranaRingByRecordId: [String: Int] = [
        "rec0XhDKfxW8UVyaB": 1,
        "recspOpR95DVcOEvn": 2,
        "recp4X5tuGdLuHCVw": 3,
        "reck0o3CUIpc1Fc3p": 4,
        "recXWmYtaMBafQTg0": 5,
        "recAoU8p9NZHlqVBA": 6,
        "recpHi1ydFrb3bLH6": 7,
        "rec3sxt1ZQ3T036sZ": 8,
        "recqdC3D38TWFkf1M": 9,
    ]

    /// Ring number → Avaraṇa record id: the inverse of `avaranaRingByRecordId`,
    /// the `Link to Mandala` of a ledger `Ring Crossed` row. `nil` outside 1…9.
    nonisolated static func avaranaRecordId(forRing ring: Int) -> String? {
        avaranaRingByRecordId.first { $0.value == ring }?.key
    }

    /// PAT loaded from Info.plist (`AIRTABLE_PAT`, fed by `Config.xcconfig`).
    /// Returns nil when missing — sync silently stays on local data.
    var pat: String? {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "AIRTABLE_PAT") as? String,
              !raw.isEmpty,
              raw != "$(AIRTABLE_PAT)" else { return nil }
        return raw
    }

    private let session = URLSession(configuration: .ephemeral)

    /// Re-entrancy latch for `flushPending`. Launch runs it twice concurrently
    /// (RootView's first sync and the scene-phase `.active` hook), and two
    /// drains of the same UserDefaults queue would double-write. Checked and
    /// set on the main actor before the first `await`, so the second caller
    /// always sees it.
    private var flushInProgress = false

    /// Says "Sync disabled by launch flag" once per process, not once per gesture.
    private var loggedSyncDisabled = false

    /// True when this process must never touch Airtable (`AppRuntime.syncDisabled`:
    /// the XCTest host, `SYNC_OFF`, `BINDU_SYNC_OFF=1`). Logs the reason once.
    private func syncIsDisabled() -> Bool {
        guard AppRuntime.syncDisabled else { return false }
        if !loggedSyncDisabled {
            loggedSyncDisabled = true
            log.notice("Sync disabled by launch flag")
        }
        return true
    }

    // MARK: - HTTP plumbing

    /// Throw `AirtableHTTPError` (status + Airtable's error body) unless the
    /// response is 2xx. Every Airtable call site funnels through here so no
    /// failure is ever reduced to a bare "bad server response".
    private static func checkHTTP(_ response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else {
            throw AirtableHTTPError(status: 0, body: "non-HTTP response")
        }
        guard (200..<300).contains(http.statusCode) else {
            throw AirtableHTTPError(status: http.statusCode, data: data)
        }
    }

    /// Log-ready description: status + body for an Airtable HTTP failure,
    /// `localizedDescription` for anything else (transport, decoding).
    private static func describe(_ error: Error) -> String {
        if let http = error as? AirtableHTTPError { return http.description }
        return error.localizedDescription
    }

    // MARK: - Orchestration

    func sync(context: ModelContext) async {
        if syncIsDisabled() { return }
        // Drain any pending recognitions first — they piggyback on every sync.
        // Safe without a token: each queue holds its items and returns.
        await flushPending(context: context)

        guard let token = pat else {
            log.notice("No PAT — local-only mode.")
            return
        }
        do {
            log.notice("[Phase 1] sync starting…")
            async let s: [ShaktiRow]  = fetch(token: token, filter: "{fldw33m8YqrINlvrN}='Shakti'",
                                              sort: [("Khadgamala Position", "asc")])
            async let a: [AvaranaRow] = fetch(token: token, filter: "{fldw33m8YqrINlvrN}='Avarana'",
                                              sort: [])
            async let n: [NityaRow]   = fetch(token: token, filter: "{fldw33m8YqrINlvrN}='Nitya'",
                                              sort: [("Number", "asc")])
            let (sk, av, nt) = try await (s, a, n)

            try reconcileShaktis(sk, context: context)
            try reconcileAvaranas(av, context: context)
            try reconcileNityas(nt, context: context)
            // Union the server's Letter-Written ledger into the local dedup set
            // so a reinstall or second device never re-logs a letter (§0.6).
            await reconcileLedgeredLetters(token: token, shaktis: sk)
            // After the field data is local, rebuild the recognition log if the
            // device has none — the path home after a reinstall/recovery.
            await restoreRecognitionsIfLocalEmpty(context: context)
            await restoreDescentIfLocalEmpty(context: context)
            logVerification(shaktis: sk.count, avaranas: av.count, nityas: nt.count, context: context)
        } catch {
            log.error("Sync failed: \(Self.describe(error), privacy: .public)")
        }
    }

    // MARK: - Generic paged fetch

    /// Every page of `table` (the Mandala table by default) matching `filter`.
    /// The Mandala table is read by field *id* (`returnFieldsByFieldId`); the
    /// App Activity ledger is read by field *name* (`byFieldId: false`),
    /// matching its writes. `fields` narrows the response to those columns
    /// (`fields[]`, in the same addressing); empty returns every field.
    private func fetch<Row: Decodable>(
        token: String,
        table: String? = nil,
        filter: String,
        sort: [(field: String, direction: String)],
        fields: [String] = [],
        byFieldId: Bool = true
    ) async throws -> [Row] {
        var all: [Row] = []
        var offset: String? = nil
        repeat {
            let page: Page<Row> = try await fetchPage(token: token, table: table, filter: filter,
                                                     sort: sort, fields: fields,
                                                     byFieldId: byFieldId, offset: offset)
            all.append(contentsOf: page.records)
            offset = page.offset
        } while offset != nil
        return all
    }

    /// One page (100 rows) of `table` matching `filter`, from `offset`. The
    /// building block of `fetch`; a reader that can stop early (Her Moments)
    /// pages with it directly.
    private func fetchPage<Row: Decodable>(
        token: String,
        table: String?,
        filter: String,
        sort: [(field: String, direction: String)],
        fields: [String],
        byFieldId: Bool,
        offset: String?
    ) async throws -> Page<Row> {
        var comps = URLComponents(string: "https://api.airtable.com/v0/\(Self.baseId)/\(table ?? Self.tableId)")!
        var items: [URLQueryItem] = [
            .init(name: "pageSize", value: "100"),
            .init(name: "filterByFormula", value: filter),
        ]
        if byFieldId { items.append(.init(name: "returnFieldsByFieldId", value: "true")) }
        for f in fields { items.append(.init(name: "fields[]", value: f)) }
        for (i, pair) in sort.enumerated() {
            items.append(.init(name: "sort[\(i)][field]", value: pair.field))
            items.append(.init(name: "sort[\(i)][direction]", value: pair.direction))
        }
        if let offset { items.append(.init(name: "offset", value: offset)) }
        comps.queryItems = items
        var req = URLRequest(url: comps.url!)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: req)
        try Self.checkHTTP(response, data: data)
        return try JSONDecoder().decode(Page<Row>.self, from: data)
    }

    private struct Page<R: Decodable>: Decodable {
        let records: [R]
        let offset: String?
    }

    // MARK: - Row models

    private struct ShaktiRow: Decodable { let id: String; let fields: ShaktiFields }
    private struct ShaktiFields: Decodable {
        let sanskritName: String?
        let devanagari: String?
        let quality: String?
        let qualityDescription: String?
        let clusterGroup: String?
        let esotericTattva: String?
        let somaticSignature: String?
        let bodilyLocation: String?
        let bija: String?
        let fieldConnection: String?
        let status: String?
        let khadgamalaPosition: Int?
        let iconography: String?
        let codexPortrait: String?
        let etymology: String?
        let appreciationPhrase: String?
        let shaktiFunction: String?
        let shaktiFamily: String?
        let lastFelt: String?
        let recognitionCount: Int?
        let letter: String?

        // CodingKeys are Airtable field IDs (verified May 31 2026 via Airtable Omni).
        // Read with `returnFieldsByFieldId=true` so the response is keyed by ID.
        enum CodingKeys: String, CodingKey {
            case sanskritName       = "fldJOatnYrw9l6tff"
            case devanagari         = "fldDhcJ1BJQCM5llO"
            case quality            = "fldnwcu7zv7uV1ta2"
            case qualityDescription = "fldTwrtI5CyUnJV2F"
            case clusterGroup       = "fld1HO6HwMH8fSwS3"
            case esotericTattva     = "fldxylgY985SwqdJE"
            case somaticSignature   = "fld6CylZqbIZQIUOp"
            case bodilyLocation     = "fld6P1u43B0eqKU5e"
            case bija               = "fldnOqkWcvjQNxpWl"
            case fieldConnection    = "fldsk2ATEtTVB87eb"
            case status             = "fldDiihcxC54WKPhT"
            case khadgamalaPosition = "fldI0aV1sfOeNybHI"
            case iconography        = "fldXJEBCQxLdHWGuP"
            case codexPortrait      = "fldlcmg7wtfIxgcZu"   // polymorphic w/ Avaraṇa Personal Connection
            case etymology          = "fldXypzqrhVILCqgh"
            case appreciationPhrase = "fldBqEDpBonMc2s1K"
            case shaktiFunction     = "fldzT3dAhsAK75rKN"
            case shaktiFamily       = "fldYAlclWH7CfJhOg"
            case lastFelt           = "fldWT0dGqdUQrdRGT"
            case recognitionCount   = "flddp0tLpf8iuxyt4"
            case letter             = "fldgASyV031Hr4sHp"
        }
    }

    private struct AvaranaRow: Decodable { let id: String; let fields: AvaranaFields }
    private struct AvaranaFields: Decodable {
        let sanskritName: String?
        let subtitle: String?
        let presidingForm: String?
        let mentalState: String?
        let subtleBodyChakra: String?
        let geometricShape: String?
        let personalConnection: String?
        let yogini: String?

        // CodingKeys are Airtable field IDs (verified May 31 2026 via Airtable Omni).
        enum CodingKeys: String, CodingKey {
            case sanskritName       = "fldJOatnYrw9l6tff"
            case subtitle           = "fldXTUBJTDlkKEzEV"
            case presidingForm      = "fldgHVP1LqoVJsYu8"
            case mentalState        = "fld8p7FtKqEKvSy7P"
            case subtleBodyChakra   = "fld6deGFzModjBmoj"
            case geometricShape     = "fldNqYFRn8x4F9jR0"
            case personalConnection = "fldlcmg7wtfIxgcZu"   // polymorphic w/ Shakti Codex Portrait
            case yogini             = "fldcqAvdN3wcP8BhT"
        }
    }

    private struct NityaRow: Decodable { let id: String; let fields: NityaFields }
    private struct NityaFields: Decodable {
        let sanskritName: String?
        let tithiPosition: Int?
        let quality: String?
        let qualityDescription: String?

        // CodingKeys are Airtable field IDs (verified May 31 2026 via Airtable Omni).
        enum CodingKeys: String, CodingKey {
            case sanskritName       = "fldJOatnYrw9l6tff"
            case tithiPosition      = "fldVWZLCy5YFJMkCp"
            case quality            = "fldnwcu7zv7uV1ta2"
            case qualityDescription = "fldTwrtI5CyUnJV2F"
        }
    }

    // MARK: - Reconcile

    private func reconcileShaktis(_ rows: [ShaktiRow], context: ModelContext) throws {
        let existing = try context.fetch(FetchDescriptor<Shakti>())

        for row in rows {
            guard let kp = row.fields.khadgamalaPosition, (1...102).contains(kp) else { continue }
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            guard ring > 0 else { continue }
            let perRing = KhadgamalaMap.perRingIndex(forKhadgamala: kp)

            let shakti: Shakti
            if let m = existing.first(where: { $0.khadgamalaPosition == kp }) {
                shakti = m
            } else if ring == 2,
                      let legacy = existing.first(where: {
                          $0.position == perRing && $0.ringNumber == nil
                      }) {
                shakti = legacy   // adopt pre-Phase-1 bootstrap row
            } else {
                shakti = Shakti(
                    position: perRing,
                    name: row.fields.sanskritName ?? "",
                    shortName: "",
                    phonetic: "",
                    quality: row.fields.quality ?? "",
                    qualityDescription: row.fields.qualityDescription ?? "",
                    somatic: row.fields.somaticSignature ?? "",
                    somaticPoetry: "",
                    bija: row.fields.bija ?? "",
                    bodilyLocation: row.fields.bodilyLocation ?? "",
                    tattva: row.fields.esotericTattva ?? "",
                    recognitionPhrase: "",
                    cluster: parseCluster(row.fields.clusterGroup) ?? .inner,
                    status: parseStatus(row.fields.status) ?? .mapped
                )
                context.insert(shakti)
            }

            shakti.khadgamalaPosition = kp
            shakti.ringNumber         = ring
            shakti.airtableRecordId   = row.id
            shakti.airtableId         = row.id   // keep legacy field in sync

            if let v = row.fields.sanskritName, !v.isEmpty       { shakti.name = v }
            if let v = row.fields.quality, !v.isEmpty            { shakti.quality = v }
            if let v = row.fields.qualityDescription, !v.isEmpty { shakti.qualityDescription = v }
            // Airtable's `somaticSignature` is poetic signature text (e.g.
            // "Awareness that becomes smaller than thought…"), not a prompt
            // question. It populates Detail's Somatic Signature section
            // (`somaticPoetry`). The prompt (`somatic`, shown in DailyRiteView)
            // is sourced only from the bootstrap and intentionally not
            // overwritten by sync.
            if let v = row.fields.somaticSignature, !v.isEmpty   { shakti.somaticPoetry = v }
            if let v = row.fields.bija, !v.isEmpty               { shakti.bija = v }
            if let v = row.fields.bodilyLocation, !v.isEmpty     { shakti.bodilyLocation = v }
            if let v = row.fields.esotericTattva, !v.isEmpty     { shakti.tattva = v }
            // Field connections (positions 3 / 12 / 14) are practitioner-owned —
            // they're edited locally in Settings. Only seed from Airtable when
            // the local value is empty; never overwrite an existing edit.
            if let v = row.fields.fieldConnection, !v.isEmpty,
               (shakti.fieldName?.isEmpty ?? true) {
                shakti.fieldName = v
            }

            shakti.devanagari         = row.fields.devanagari
            shakti.iconography        = row.fields.iconography
            shakti.codexPortrait      = row.fields.codexPortrait
            shakti.etymology          = row.fields.etymology
            shakti.appreciationPhrase = row.fields.appreciationPhrase
            shakti.shaktiFunction     = row.fields.shaktiFunction
            shakti.shaktiFamilyRaw    = row.fields.shaktiFamily

            shakti.serverRecognitionCount = row.fields.recognitionCount
            if let iso = row.fields.lastFelt {
                shakti.lastFelt = ISO8601DateFormatter().date(from: iso)
            }

            // Status advance-only — never regress past local progression.
            if let remote = parseStatus(row.fields.status) {
                let order: [ShaktiStatus] = [.mapped, .exploring, .active, .embodied]
                let li = order.firstIndex(of: shakti.status) ?? 0
                let ri = order.firstIndex(of: remote) ?? 0
                shakti.status = order[max(li, ri)]
            }

            // Restore her letter from Airtable when none exists locally. Every
            // one of the 102 may be written to now that `ShaktiLetter` is keyed
            // by Khaḍgamālā position, so no ring is gated out. Offline-first:
            // seed only when the practitioner has no local draft — never
            // overwriting a newer local edit.
            if let remoteLetter = row.fields.letter?.trimmingCharacters(in: .whitespacesAndNewlines),
               !remoteLetter.isEmpty {
                seedLetterIfMissing(khadgamalaPosition: kp, body: remoteLetter, context: context)
            }

            shakti.lastSyncedAt = .now
        }
        try context.save()
    }

    /// Restore the server's letter for this Khaḍgamālā position unless the
    /// practitioner has written one — a local draft always wins. A row whose
    /// body is blank is not a draft (a pre-fix build's write-on-open, or a row
    /// migrated from an empty V1 letter): it is filled in place rather than left
    /// to block the restore forever, and never duplicated on the unique key.
    private func seedLetterIfMissing(khadgamalaPosition: Int, body: String, context: ModelContext) {
        let d = FetchDescriptor<ShaktiLetter>(
            predicate: #Predicate { $0.khadgamalaPosition == khadgamalaPosition }
        )
        if let row = (try? context.fetch(d))?.first {
            guard row.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            row.body = body
            row.updatedAt = .now
            return
        }
        context.insert(ShaktiLetter(khadgamalaPosition: khadgamalaPosition, body: body))
    }

    /// Rebuild the local recognition log from the App Activity ledger when it
    /// is empty — the path home after a reinstall or a store recovery. Every
    /// `Shakti Recognized` row comes back as a `.felt` entry and every
    /// `Silence Held` row as `.silence`, her words restored from `Notes`; the
    /// mapping is `ActivityLedger.recognitionEntries` (pure), which tolerates
    /// a legacy milestone that predates `Felt At` (folding it into its
    /// migrated twin when one carries the same day) and skips what it cannot
    /// place. Guarded on emptiness so it can never duplicate existing history.
    /// Silent on any failure.
    func restoreRecognitionsIfLocalEmpty(context: ModelContext) async {
        let existing = (try? context.fetch(FetchDescriptor<RecognitionEntry>())) ?? []
        guard existing.isEmpty else { return }
        guard let token = pat else { return }

        // Airtable record id → (Khaḍgamālā position, ring) from local Shaktis.
        let shaktis = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        var byRecord: [String: (kp: Int, ring: Int)] = [:]
        for s in shaktis {
            guard let rec = s.airtableRecordId, let kp = s.khadgamalaPosition else { continue }
            byRecord[rec] = (kp, s.ringNumber ?? KhadgamalaMap.ringNumber(forKhadgamala: kp))
        }
        guard !byRecord.isEmpty else { return }

        do {
            // The mapper orders oldest-first itself, so no server sort is asked for.
            let rows: [ActivityLedger.Row] = try await fetch(
                token: token,
                table: ActivityLedger.tableId,
                filter: ActivityLedger.restoreRecognitions,
                sort: [],
                fields: Self.restoreRecognitionFields,
                byFieldId: false
            )
            let restored = ActivityLedger.recognitionEntries(from: rows, byRecord: byRecord)
            for r in restored {
                context.insert(RecognitionEntry(
                    timestamp: r.timestamp,
                    khadgamalaPosition: r.kp,
                    ringNumber: r.ring,
                    note: r.note,
                    gesture: r.gesture
                ))
            }
            if !restored.isEmpty { try? context.save() }
            log.notice("Recognition restore: inserted \(restored.count) from the ledger")
        } catch {
            log.error("Recognition restore failed: \(Self.describe(error), privacy: .public)")
        }
    }

    /// The ledger columns the recognition restore reads (`fields[]`, by name).
    private static let restoreRecognitionFields = [
        ActivityLedger.Field.activityType,
        ActivityLedger.Field.activityDate,
        ActivityLedger.Field.feltAt,
        ActivityLedger.Field.notes,
        ActivityLedger.Field.linkToMandala,
    ]

    /// Rebuild the descent timeline from the App Activity ledger when the
    /// local one is empty — the path home for `DescentState.crossings` after a
    /// reinstall/recovery (Ruling 8). Every `Ring Crossed` row with a ring in
    /// 1…9 and a readable `Felt At` counts (`ActivityLedger.crossings`, pure —
    /// a stray row never rewrites a crossing's date). Guarded on empty
    /// crossings so it never overwrites a live timeline; zero rows leave the
    /// bootstrap floor (2/2) untouched.
    func restoreDescentIfLocalEmpty(context: ModelContext) async {
        let states = (try? context.fetch(FetchDescriptor<DescentState>())) ?? []
        guard let state = states.first, state.crossings.isEmpty else { return }
        guard let token = pat else { return }

        do {
            let rows: [ActivityLedger.Row] = try await fetch(
                token: token,
                table: ActivityLedger.tableId,
                filter: ActivityLedger.restoreCrossings,
                sort: [],
                fields: Self.restoreCrossingFields,
                byFieldId: false
            )
            let restored = ActivityLedger.crossings(from: rows)
            guard !restored.isEmpty else { return }   // zero rows → floor untouched
            state.restore(from: restored)
            try? context.save()
            log.notice("Descent restore: rebuilt \(restored.count) crossing(s), deepest ring \(state.deepestReached)")
        } catch {
            log.error("Descent restore failed: \(Self.describe(error), privacy: .public)")
        }
    }

    /// The ledger columns the descent restore reads (`fields[]`, by name).
    private static let restoreCrossingFields = [
        ActivityLedger.Field.activityType,
        ActivityLedger.Field.descentRing,
        ActivityLedger.Field.feltAt,
    ]

    private func reconcileAvaranas(_ rows: [AvaranaRow], context: ModelContext) throws {
        let existing = try context.fetch(FetchDescriptor<Avarana>())

        for row in rows {
            guard let ring = Self.avaranaRingByRecordId[row.id] else { continue }
            let avarana: Avarana
            if let m = existing.first(where: { $0.ringNumber == ring }) {
                avarana = m
            } else {
                avarana = Avarana(
                    ringNumber: ring,
                    airtableRecordId: row.id,
                    sanskritName: row.fields.sanskritName ?? ""
                )
                context.insert(avarana)
            }
            avarana.airtableRecordId   = row.id
            if let v = row.fields.sanskritName, !v.isEmpty { avarana.sanskritName = v }
            avarana.subtitle           = row.fields.subtitle
            avarana.presidingForm      = row.fields.presidingForm
            avarana.mentalState        = row.fields.mentalState
            avarana.subtleBodyChakra   = row.fields.subtleBodyChakra
            avarana.geometricShape     = row.fields.geometricShape
            avarana.personalConnection = row.fields.personalConnection
            avarana.yogini             = row.fields.yogini
            avarana.lastSyncedAt = .now
        }
        try context.save()
    }

    private func reconcileNityas(_ rows: [NityaRow], context: ModelContext) throws {
        let existing = try context.fetch(FetchDescriptor<NityaDevi>())

        for row in rows {
            guard let tp = row.fields.tithiPosition, (1...15).contains(tp) else { continue }
            let nitya: NityaDevi
            if let m = existing.first(where: { $0.tithiPosition == tp }) {
                nitya = m
            } else {
                nitya = NityaDevi(
                    tithiPosition: tp,
                    airtableRecordId: row.id,
                    sanskritName: row.fields.sanskritName ?? ""
                )
                context.insert(nitya)
            }
            nitya.airtableRecordId   = row.id
            if let v = row.fields.sanskritName, !v.isEmpty { nitya.sanskritName = v }
            nitya.quality            = row.fields.quality
            nitya.qualityDescription = row.fields.qualityDescription
            nitya.lastSyncedAt = .now
        }
        try context.save()
    }

    // MARK: - Parsers

    private func parseCluster(_ raw: String?) -> Cluster? {
        guard let r = raw?.lowercased() else { return nil }
        return Cluster.allCases.first { $0.rawValue.lowercased() == r }
    }

    private func parseStatus(_ raw: String?) -> ShaktiStatus? {
        guard let r = raw?.lowercased() else { return nil }
        return ShaktiStatus(rawValue: r)
    }

    // MARK: - Verification (Phase 1 — downgrade after Phase 2 verification passes)

    private func logVerification(shaktis: Int, avaranas: Int, nityas: Int, context: ModelContext) {
        log.notice("[Phase 1] Shaktis fetched: \(shaktis)")
        let allS = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        for s in allS.sorted(by: { ($0.khadgamalaPosition ?? 0) < ($1.khadgamalaPosition ?? 0) }) {
            let portrait = String((s.codexPortrait ?? "").prefix(80))
            // Names/devanāgarī are catalog data; the codex portrait is reflective
            // free-text and stays redacted so it never lands in the unified log.
            log.notice("  \(s.khadgamalaPosition ?? 0) · ring \(s.ringNumber ?? 0) · \(s.name, privacy: .public) · \(s.devanagari ?? "—", privacy: .public) · \(portrait, privacy: .private)")
        }
        log.notice("[Phase 1] Avaranas fetched: \(avaranas)")
        let allA = (try? context.fetch(FetchDescriptor<Avarana>())) ?? []
        for a in allA.sorted(by: { $0.ringNumber < $1.ringNumber }) {
            let conn = String((a.personalConnection ?? "").prefix(80))
            // Personal connection is the practitioner's own reflection — redacted.
            log.notice("  ring \(a.ringNumber) · \(a.sanskritName, privacy: .public) · \(conn, privacy: .private)")
        }
        log.notice("[Phase 1] Nityas fetched: \(nityas)")
        let allN = (try? context.fetch(FetchDescriptor<NityaDevi>())) ?? []
        for n in allN.sorted(by: { $0.tithiPosition < $1.tithiPosition }) {
            log.notice("  \(n.tithiPosition) · \(n.sanskritName, privacy: .public) · \(n.quality ?? "—", privacy: .public)")
        }
    }
}

// MARK: - Her Moments · Recognition reads (App Activity)

/// One `Shakti Recognized` row read from the ledger for a single Śakti's
/// history. `feltAt` is `nil` for a legacy milestone written before `Felt At`
/// existed and not folded into a migrated twin (`ActivityLedger.momentRows`)
/// — Her Moments renders those as a bare "she was felt here".
struct RecognitionAirtableRow: Identifiable, Equatable {
    let id: String
    let feltAt: Date?
    let notes: String?
    let moonPhase: String?
}

extension AirtableService {

    /// Her `limit` most-recent `Shakti Recognized` rows from App Activity,
    /// newest first. The formula narrows by type and by her name in the
    /// link's primary field (`ActivityLedger.moments`; a blank name narrows
    /// nothing); names repeat across rings, so the record-id match stays
    /// client-side, paging by `offset` (100 a page, at most `momentPageCap`
    /// pages) until `limit` timestamped rows link this record. A backfill
    /// milestone beside its migrated twin is one moment, shown once
    /// (`ActivityLedger.momentRows`). Throws on network failure; the caller
    /// keeps local SwiftData.
    func fetchRecognitions(forShaktiRecordId shaktiRecordId: String,
                           name shaktiName: String,
                           limit: Int = 5) async throws -> [RecognitionAirtableRow] {
        guard let token = pat else { return [] }

        var matched: [ActivityLedger.Row] = []
        var timestamped = 0
        var offset: String? = nil
        var pages = 0
        paging: repeat {
            let page: Page<ActivityLedger.Row> = try await fetchPage(
                token: token,
                table: ActivityLedger.tableId,
                filter: ActivityLedger.moments(shaktiName: shaktiName),
                sort: [(ActivityLedger.Field.feltAt, "desc")],
                fields: Self.momentFields,
                byFieldId: false,
                offset: offset
            )
            for row in page.records
            where row.fields.linkToMandala?.contains(shaktiRecordId) == true {
                matched.append(row)
                if ActivityLedger.serverDate(row.fields.feltAt) != nil { timestamped += 1 }
                // `limit` timestamped rows are her newest `limit`; a legacy
                // milestone is older than all of them and would not show.
                if timestamped >= limit { break paging }
            }
            offset = page.offset
            pages += 1
        } while offset != nil && pages < Self.momentPageCap
        return ActivityLedger.momentRows(matched, limit: limit).map { row in
            RecognitionAirtableRow(
                id: row.id,
                feltAt: ActivityLedger.serverDate(row.fields.feltAt),
                notes: row.fields.notes,
                moonPhase: row.fields.moonPhase
            )
        }
    }

    /// The ledger columns Her Moments reads (`fields[]`, by name).
    private static let momentFields = [
        ActivityLedger.Field.feltAt,
        ActivityLedger.Field.activityDate,
        ActivityLedger.Field.notes,
        ActivityLedger.Field.moonPhase,
        ActivityLedger.Field.linkToMandala,
    ]

    /// How far Her Moments will page for one Śakti — 500 name-matched rows is
    /// beyond any practice; past that the newest found are shown.
    private static let momentPageCap = 5
}

// MARK: - Phase 6 · Recognition writes

extension AirtableService {

    /// Where the recognition gesture originated. Maps directly to the ledger's
    /// `Gesture Source` singleSelect (`ActivityLedger.GestureSource`).
    enum RecognitionSource: String {
        case today    = "Today"
        case mandala  = "Mandala"
        case silence  = "Silence"
        case well     = "Well"
    }

    /// One unfulfilled recognition held in UserDefaults until the network returns.
    /// `failCount` is incremented per failed flush; items are dropped after
    /// `PendingQueuePolicy.maxFailures`. With no token nothing is bumped.
    /// The stored shape is build 36's, member for member — a queue written
    /// before the ledger rewire still decodes and drains into App Activity.
    private struct PendingRecognition: Codable, PendingQueueItem, RecognitionMoment {
        var id: String = UUID().uuidString
        let shaktiRecordId: String
        let note: String?
        let source: String
        let feltAt: Date
        let lunarDay: Int
        let moonPhase: String
        var failCount: Int = 0
    }

    private static let pendingKey = "pendingRecognitions"

    // MARK: Shakti-row field names (the per-Śakti state PATCHes; brief §3)
    private static let fldLastFelt         = "Last Felt"
    private static let fldRecognitionCount = "Recognition Count"
    private static let fldStatus           = "Status"

    /// Fire-and-forget. The event lands in App Activity (one `Shakti Recognized`
    /// row, her words in `Notes`), then her Shakti row is read and PATCHed
    /// (Last Felt, Recognition Count). On any failure the item is enqueued in
    /// UserDefaults for retry on the next sync or scene-active transition.
    /// Pre-sync Shaktis (no `airtableRecordId`) silently skip — stays local only.
    func recordRecognition(shakti: Shakti,
                           note: String?,
                           source: RecognitionSource,
                           context: ModelContext) async {
        if syncIsDisabled() { return }
        guard let recordId = shakti.airtableRecordId, !recordId.isEmpty else {
            log.notice("Recognition: no airtableRecordId — skipping Airtable write")
            return
        }
        let item = PendingRecognition(
            shaktiRecordId: recordId,
            note: note,
            source: source.rawValue,
            feltAt: .now,
            lunarDay: LunarPhaseService.currentDay(),
            moonPhase: LunarPhaseService.phaseName()
        )
        let success = await processRecognition(item, context: context)
        if !success {
            enqueuePending(item)
        }
    }

    /// Drain the Recognition and Letter pending queues plus the descent-crossing
    /// and activity-ledger queues. Called at the start of every `sync()` and on
    /// scene-phase `.active`. Items that fail `PendingQueuePolicy.maxFailures`
    /// times in a row are dropped — local SwiftData is already canonical, so the
    /// only loss is the Airtable mirror. Without a token every queue holds.
    /// Re-entrant calls (launch fires this twice at once) skip.
    func flushPending(context: ModelContext) async {
        if syncIsDisabled() { return }
        guard !flushInProgress else {
            log.notice("Flush already in progress — skipping")
            return
        }
        flushInProgress = true
        defer { flushInProgress = false }
        await flushPendingRecognitions(context: context)
        await flushPendingLetters()
        await flushPendingActivities()
        await flushPendingCrossings()
    }

    private func flushPendingRecognitions(context: ModelContext) async {
        let queue = loadPending()
        guard !queue.isEmpty else { return }
        guard pat != nil else {
            // No-PAT mode holds, never drops: the queue is left exactly as it is.
            log.notice("Recognition queue: \(queue.count) waiting for a token")
            return
        }
        log.notice("Recognition queue: flushing \(queue.count) item(s)")
        var succeeded: [Bool] = []
        for item in queue {
            succeeded.append(await processRecognition(item, context: context))
        }
        let update = PendingQueuePolicy.update(queue, hasToken: true, succeeded: succeeded)
        for item in update.dropped {
            log.notice("Recognition dropped after \(item.failCount) failures: \(item.shaktiRecordId, privacy: .public)")
        }
        // Anything enqueued while this drain awaited the network landed in the
        // store behind the snapshot; the save must carry it, not erase it.
        let remaining = PendingQueuePolicy.merge(remaining: update.remaining, drained: queue, stored: loadPending())
        savePending(remaining)
        if remaining.isEmpty {
            log.notice("Recognition queue: drained (\(update.dropped.count) dropped)")
        } else {
            log.notice("Recognition queue: \(remaining.count) still pending (\(update.dropped.count) dropped)")
        }
    }

    // MARK: - The recognition write (ledger row, then the Shakti-row PATCH)

    /// Four round-trips, in this order: (1) is this exact moment already in the
    /// ledger? (2) read her Shakti row's count and Last Felt; (3) POST the
    /// `Shakti Recognized` row — first or "felt again" from the count read,
    /// her words in `Notes` — skipped on a dedup hit; (4) PATCH the Shakti row
    /// and mirror the count locally. A retry after a POST-succeeded /
    /// PATCH-failed split therefore skips only the create — an existing row
    /// says nothing about whether the PATCH or the local mirror ever landed,
    /// and a retry exists precisely because one of them did not.
    private func processRecognition(_ item: PendingRecognition,
                                    context: ModelContext) async -> Bool {
        guard let token = pat else { return false }
        do {
            let exists = await activityExistsOnServer(
                token: token,
                type: ActivityLedger.ActivityType.shaktiRecognized,
                linkRecordId: item.shaktiRecordId,
                feltAt: item.feltAt
            )
            let state = try await readShaktiRecognitionState(token: token, recordId: item.shaktiRecordId)
            // First vs return is decided from the count read *before* this
            // gesture's PATCH — or, on a retry whose PATCH already landed, the
            // count that includes her — so the first row is the milestone,
            // once per Śakti, never twice.
            let isFirst = ActivityLedger.wasFirst(
                serverCount: state.count,
                patchAlreadyLanded: RecognitionDedup.patchAlreadyLanded(lastFelt: state.lastFelt,
                                                                        feltAt: item.feltAt)
            )
            if exists {
                log.notice("Recognition row already on server — skipping create, completing the rest")
            } else {
                let name = shaktiName(recordId: item.shaktiRecordId, context: context)
                try await createActivityRow(
                    token: token,
                    item: ActivityLedger.recognition(item, shaktiName: name, isFirst: isFirst)
                )
            }
            try await patchShaktiAfterRecognition(
                token: token,
                recordId: item.shaktiRecordId,
                feltAt: item.feltAt,
                state: state
            )
            mirrorLocalCount(
                recordId: item.shaktiRecordId,
                increment: 1,
                context: context
            )
            return true
        } catch {
            log.error("Recognition write failed: \(Self.describe(error), privacy: .public)")
            return false
        }
    }

    /// Local Śakti display name for a record id, or a quiet fallback.
    private func shaktiName(recordId: String, context: ModelContext) -> String {
        let all = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        let name = all.first(where: { $0.airtableRecordId == recordId })?.name ?? ""
        return name.isEmpty ? "A Śakti" : name
    }

    /// Her Shakti row's per-Śakti state as the server holds it now: the
    /// `Recognition Count` *before* this recognition (0 ⇒ never felt before)
    /// and `Last Felt` as the API returns it.
    private typealias ShaktiRecognitionState = (count: Int, lastFelt: String?)

    /// GET her Shakti row for its count and Last Felt. Read once per
    /// recognition, before the ledger row is created, so first-vs-return and
    /// the PATCH's idempotency guard see the same state.
    private func readShaktiRecognitionState(token: String,
                                            recordId: String) async throws -> ShaktiRecognitionState {
        var req = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)/\(recordId)")!)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: req)
        try Self.checkHTTP(response, data: data)

        struct GetResponse: Decodable {
            let fields: Fields
            struct Fields: Decodable {
                let recognitionCount: Int?
                let lastFelt: String?
                enum CodingKeys: String, CodingKey {
                    case recognitionCount = "Recognition Count"
                    case lastFelt         = "Last Felt"
                }
            }
        }
        let parsed = try JSONDecoder().decode(GetResponse.self, from: data)
        return (count: parsed.fields.recognitionCount ?? 0, lastFelt: parsed.fields.lastFelt)
    }

    /// PATCH her Shakti row: `Last Felt` = this gesture's second, `Recognition
    /// Count` = the count read + 1 — nothing else. Status is intentionally
    /// **not** touched — readiness is sensed (count grows); advancing is
    /// chosen (deliberate gesture on the Detail status pill, which calls
    /// `advanceStatus` separately). Idempotent on retry: `Last Felt` and the
    /// count go in one PATCH, so a `Last Felt` equal to this gesture's exact
    /// second means that PATCH already landed (its response was lost, not the
    /// write) — counting her again would be a lie, and nothing is written.
    private func patchShaktiAfterRecognition(token: String,
                                              recordId: String,
                                              feltAt: Date,
                                              state: ShaktiRecognitionState) async throws {
        if RecognitionDedup.patchAlreadyLanded(lastFelt: state.lastFelt, feltAt: feltAt) {
            log.notice("Shakti PATCH already landed for this recognition — skipping")
            return
        }
        let writtenFeltAt = RecognitionDedup.writtenFeltAt(feltAt)
        let newCount = state.count + 1

        // PATCH — count + lastFelt only.
        let fields: [String: Any] = [
            Self.fldLastFelt:         writtenFeltAt,
            Self.fldRecognitionCount: newCount
        ]
        let body: [String: Any] = ["fields": fields, "typecast": true]
        let data = try JSONSerialization.data(withJSONObject: body)

        var patchReq = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)/\(recordId)")!)
        patchReq.httpMethod = "PATCH"
        patchReq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        patchReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        patchReq.httpBody = data

        let (patchData, patchResp) = try await session.data(for: patchReq)
        try Self.checkHTTP(patchResp, data: patchData)
    }

    /// Mirror the server's recognitionCount onto the local Shakti so the Detail
    /// screen senses readiness without waiting for the next reconcile.
    private func mirrorLocalCount(recordId: String,
                                   increment: Int,
                                   context: ModelContext) {
        guard let all = try? context.fetch(FetchDescriptor<Shakti>()),
              let local = all.first(where: { $0.airtableRecordId == recordId }) else { return }
        local.serverRecognitionCount = (local.serverRecognitionCount ?? 0) + increment
        local.lastSyncedAt = .now
        try? context.save()
    }

    /// PATCH a new status to Airtable and mirror it locally. Called from the
    /// Detail screen's deliberate "advance" gesture — never automatic.
    /// Advance-only: a request to go backwards is silently ignored.
    func advanceStatus(shakti: Shakti,
                       to newStatus: ShaktiStatus,
                       context: ModelContext) async {
        let order: [ShaktiStatus] = [.mapped, .exploring, .active, .embodied]
        guard let cur = order.firstIndex(of: shakti.status),
              let next = order.firstIndex(of: newStatus),
              next > cur else { return }

        // Update local first so the UI breathes immediately.
        shakti.status = newStatus
        shakti.lastSyncedAt = .now
        try? context.save()

        if syncIsDisabled() { return }
        guard let token = pat,
              let recordId = shakti.airtableRecordId, !recordId.isEmpty else { return }

        let body: [String: Any] = [
            "fields": [Self.fldStatus: newStatus.rawValue.capitalized],
            "typecast": true
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: body) else { return }
        var req = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)/\(recordId)")!)
        req.httpMethod = "PATCH"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = data
        do {
            let (respData, response) = try await session.data(for: req)
            try Self.checkHTTP(response, data: respData)
        } catch {
            // Logged, not retried — the next reconcile will reassert the local
            // advance through the existing advance-only sync rule.
            log.error("Status advance write failed: \(Self.describe(error), privacy: .public)")
        }
    }

    // MARK: - Pending queue (UserDefaults-backed)

    private func loadPending() -> [PendingRecognition] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingKey) else { return [] }
        let (queue, stamped): ([PendingRecognition], Bool) = PendingQueueStorage.decode(data)
        if stamped { savePending(queue) }   // ids must be stable across the next load
        return queue
    }

    private func savePending(_ queue: [PendingRecognition]) {
        if queue.isEmpty {
            UserDefaults.standard.removeObject(forKey: Self.pendingKey)
            return
        }
        if let data = try? JSONEncoder().encode(queue) {
            UserDefaults.standard.set(data, forKey: Self.pendingKey)
        }
    }

    private func enqueuePending(_ item: PendingRecognition) {
        var queue = loadPending()
        queue.append(item)
        savePending(queue)
        log.notice("Recognition queued (queue size: \(queue.count))")
    }

    // MARK: - Living Rite · Descent crossing writes (mirror of DescentState.crossings)

    private struct PendingCrossing: Codable, PendingQueueItem {
        var id: String = UUID().uuidString
        let ring: Int
        let feltAt: Date
        var failCount: Int = 0
    }

    private static let pendingCrossingKey = "pendingCrossings"

    /// Mirror one *new-deepest* descent crossing to the ledger as a `Ring
    /// Crossed` row linked to the Avaraṇa. Called only when
    /// `DescentState.enter(ring:)` returns true, so it fires once per new depth —
    /// not once per ring: a 2→9 plunge crosses seven thresholds but mirrors a
    /// single row for ring 9, and re-entering a shallower ring never fires. The
    /// local `DescentState` is the source of truth; Airtable is the backup that
    /// `restoreDescentIfLocalEmpty` reads. `typecast: true` creates the
    /// `Ring Crossed` Activity-Type option on first write (it is not pre-created).
    func recordCrossing(ring: Int) async {
        if syncIsDisabled() { return }
        let item = PendingCrossing(ring: ring, feltAt: .now)
        if !(await processCrossing(item)) { enqueueCrossing(item) }
    }

    /// One ledger row per crossing. The same create-time check as a
    /// recognition guards the retry path: a queued item repeats the original
    /// `feltAt`, so a row already linking this Avaraṇa at this second *is*
    /// this crossing, and nothing is written twice.
    private func processCrossing(_ item: PendingCrossing) async -> Bool {
        guard let token = pat else { return false }
        let activity = ActivityLedger.crossing(ring: item.ring, feltAt: item.feltAt)
        do {
            if await activityExistsOnServer(token: token,
                                            type: ActivityLedger.ActivityType.ringCrossed,
                                            linkRecordId: activity.linkRecordId,
                                            feltAt: item.feltAt) {
                log.notice("Ring Crossed row already on server — skipping create")
                return true
            }
            try await createActivityRow(token: token, item: activity)
            return true
        } catch {
            log.error("Crossing write failed: \(Self.describe(error), privacy: .public)")
            return false
        }
    }

    private func flushPendingCrossings() async {
        let queue = loadPendingCrossings()
        guard !queue.isEmpty else { return }
        guard pat != nil else {
            // No-PAT mode holds, never drops: the queue is left exactly as it is.
            log.notice("Crossing queue: \(queue.count) waiting for a token")
            return
        }
        log.notice("Crossing queue: flushing \(queue.count) item(s)")
        var succeeded: [Bool] = []
        for item in queue {
            succeeded.append(await processCrossing(item))
        }
        let update = PendingQueuePolicy.update(queue, hasToken: true, succeeded: succeeded)
        for item in update.dropped {
            log.notice("Crossing dropped after \(item.failCount) failures (ring \(item.ring))")
        }
        // Keep anything enqueued behind the snapshot while this drain awaited the network.
        let remaining = PendingQueuePolicy.merge(remaining: update.remaining, drained: queue, stored: loadPendingCrossings())
        savePendingCrossings(remaining)
        if remaining.isEmpty {
            log.notice("Crossing queue: drained (\(update.dropped.count) dropped)")
        } else {
            log.notice("Crossing queue: \(remaining.count) still pending (\(update.dropped.count) dropped)")
        }
    }

    private func loadPendingCrossings() -> [PendingCrossing] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingCrossingKey) else { return [] }
        let (queue, stamped): ([PendingCrossing], Bool) = PendingQueueStorage.decode(data)
        if stamped { savePendingCrossings(queue) }
        return queue
    }

    private func savePendingCrossings(_ queue: [PendingCrossing]) {
        if queue.isEmpty {
            UserDefaults.standard.removeObject(forKey: Self.pendingCrossingKey)
            return
        }
        if let data = try? JSONEncoder().encode(queue) {
            UserDefaults.standard.set(data, forKey: Self.pendingCrossingKey)
        }
    }

    private func enqueueCrossing(_ item: PendingCrossing) {
        var queue = loadPendingCrossings()
        queue.append(item)
        savePendingCrossings(queue)
        log.notice("Crossing queued (queue size: \(queue.count))")
    }

    // MARK: - Phase 8 · Letter writes

    private struct PendingLetter: Codable, PendingQueueItem {
        var id: String = UUID().uuidString
        let shaktiRecordId: String
        let body: String
        let updatedAt: Date
        var failCount: Int = 0
    }

    private static let pendingLetterKey = "pendingLetters"
    private static let fldLetter = "Letter"   // fldgASyV031Hr4sHp

    /// PATCH the Shakti row's `Letter` field. Fire-and-forget. The Well is
    /// offline-first: local SwiftData is the source of truth, Airtable receives
    /// what it can when it can. Pre-sync Shaktis (no `airtableRecordId`) skip
    /// silently per brief §10 Phase 8.
    func saveLetter(shakti: Shakti, body: String) async {
        // The letter is already saved locally by the caller (The Well is
        // offline-first); only the Airtable mirror and the ledger row stop here.
        if syncIsDisabled() { return }
        guard let recordId = shakti.airtableRecordId, !recordId.isEmpty else {
            log.notice("Letter: no airtableRecordId — skipping Airtable write")
            return
        }
        let item = PendingLetter(shaktiRecordId: recordId, body: body, updatedAt: .now)
        let success = await processLetter(item)
        if !success {
            enqueueLetter(item)
        }

        // Threshold crossing for the shared ledger: the first time a letter is
        // written for this Śakti (empty → non-empty). The `ledgeredLetters` set
        // guards it to once per Śakti, so autosaves and later sessions never
        // re-log. The milestone is the act of writing (already saved locally),
        // so it fires regardless of the Airtable letter PATCH result.
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty, !Self.hasLedgeredLetter(recordId) {
            Self.markLetterLedgered(recordId)
            let row = ActivityLedger.letterWritten(shaktiName: shakti.name)
            await logActivity(
                type: ActivityLedger.ActivityType.letterWritten,
                linkedShaktiRecordId: recordId,
                activityName: row.name,
                detail: row.detail
            )
        }
    }

    private func processLetter(_ item: PendingLetter) async -> Bool {
        guard let token = pat else { return false }
        do {
            try await patchLetter(token: token, item: item)
            return true
        } catch {
            log.error("Letter write failed: \(Self.describe(error), privacy: .public)")
            return false
        }
    }

    private func patchLetter(token: String, item: PendingLetter) async throws {
        let fields: [String: Any] = [
            Self.fldLetter: item.body
        ]
        let body: [String: Any] = ["fields": fields, "typecast": true]
        let data = try JSONSerialization.data(withJSONObject: body)

        var req = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)/\(item.shaktiRecordId)")!)
        req.httpMethod = "PATCH"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = data

        let (respData, response) = try await session.data(for: req)
        try Self.checkHTTP(response, data: respData)
    }

    private func flushPendingLetters() async {
        let queue = loadPendingLetters()
        guard !queue.isEmpty else { return }
        guard pat != nil else {
            // No-PAT mode holds, never drops: the queue is left exactly as it is.
            log.notice("Letter queue: \(queue.count) waiting for a token")
            return
        }
        log.notice("Letter queue: flushing \(queue.count) item(s)")
        var succeeded: [Bool] = []
        for item in queue {
            succeeded.append(await processLetter(item))
        }
        let update = PendingQueuePolicy.update(queue, hasToken: true, succeeded: succeeded)
        for item in update.dropped {
            log.notice("Letter dropped after \(item.failCount) failures: \(item.shaktiRecordId, privacy: .public)")
        }
        // Keep anything enqueued behind the snapshot while this drain awaited
        // the network — and, as `enqueueLetter` does, only the newest body per
        // Śakti, so a failed older draft can never be PATCHed over a newer one.
        let merged = PendingQueuePolicy.merge(remaining: update.remaining, drained: queue, stored: loadPendingLetters())
        let remaining = PendingQueuePolicy.latestPerKey(merged, key: \.shaktiRecordId, at: \.updatedAt)
        savePendingLetters(remaining)
        if remaining.isEmpty {
            log.notice("Letter queue: drained (\(update.dropped.count) dropped)")
        } else {
            log.notice("Letter queue: \(remaining.count) still pending (\(update.dropped.count) dropped)")
        }
    }

    private func loadPendingLetters() -> [PendingLetter] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingLetterKey) else { return [] }
        let (queue, stamped): ([PendingLetter], Bool) = PendingQueueStorage.decode(data)
        if stamped { savePendingLetters(queue) }
        return queue
    }

    private func savePendingLetters(_ queue: [PendingLetter]) {
        if queue.isEmpty {
            UserDefaults.standard.removeObject(forKey: Self.pendingLetterKey)
            return
        }
        if let data = try? JSONEncoder().encode(queue) {
            UserDefaults.standard.set(data, forKey: Self.pendingLetterKey)
        }
    }

    /// Deduplicating enqueue — only the latest body per Shakti is preserved,
    /// so replaying an old draft over a newer one can't happen.
    private func enqueueLetter(_ item: PendingLetter) {
        var queue = loadPendingLetters()
        queue.removeAll { $0.shaktiRecordId == item.shaktiRecordId }
        queue.append(item)
        savePendingLetters(queue)
        log.notice("Letter queued for \(item.shaktiRecordId, privacy: .public) (queue size: \(queue.count))")
    }
}

// MARK: - App Activity ledger (the writer)

/// Every practice event is one row in the shared **App Activity** table
/// (`ActivityLedger.tableId`, same base as the Mandala) and nowhere else —
/// recognitions from any screen, new-deepest ring crossings, the silence
/// dwell, the first letter written. Vocabulary, payload and formulas are
/// `ActivityLedger` (pure); this extension owns the HTTP: the one POST every
/// event goes through, the create-time idempotency check, and the
/// offline-first queue shared with the other writes. Fire-and-forget — a
/// ledger failure never affects the gesture.
extension AirtableService {

    private static let pendingActivityKey = "pendingActivities"
    private static let ledgeredLettersKey = "ledgeredLetters"

    /// Write one event to the ledger by its parts — the shape `saveLetter`
    /// uses (and the shape build 36 queued). Fire-and-forget; on failure the
    /// item is queued in UserDefaults and drained by `flushPending`.
    func logActivity(type: String,
                     linkedShaktiRecordId: String,
                     activityName: String,
                     detail: String) async {
        await logActivity(PendingActivity(type: type,
                                          linkRecordId: linkedShaktiRecordId,
                                          name: activityName,
                                          detail: detail,
                                          at: .now))
    }

    /// Write one event to the ledger. Fire-and-forget; on failure the item is
    /// queued in UserDefaults and drained by `flushPending`.
    func logActivity(_ item: PendingActivity) async {
        if syncIsDisabled() { return }
        if await processActivity(item) == false {
            enqueueActivity(item)
        }
    }

    // MARK: The silence dwell (R11)

    /// The R11 dwell: one `Silence Held` row in the ledger, linked to her
    /// Shakti row and carrying how long the silence was held — no Notes, and
    /// **no Shakti-row PATCH** (a silence is held, not counted). Guards as
    /// `recordRecognition` does: nothing when sync is off, nothing for a
    /// pre-sync Śakti (no `airtableRecordId`) — the local `.silence` entry
    /// `SilenceDwell` wrote first stays the record. Rides the activity queue,
    /// so an offline dwell drains with the other events. Zero call sites
    /// until Phase 3.6 wires the dwell.
    func recordSilence(shakti: Shakti, durationSec: Double, at: Date = .now) async {
        if syncIsDisabled() { return }
        guard let recordId = shakti.airtableRecordId, !recordId.isEmpty else {
            log.notice("Silence: no airtableRecordId — skipping Airtable write")
            return
        }
        await logActivity(ActivityLedger.silence(shaktiRecordId: recordId,
                                                 name: shakti.name,
                                                 durationSec: durationSec,
                                                 at: at))
    }

    /// One ledger row per event. A linked item gets the same create-time
    /// check as a recognition or a crossing: a queued retry repeats the
    /// original instant, so a row already linking this record at this second
    /// *is* this event, and nothing is written twice. Fail-open — the check's
    /// own failure never blocks the create.
    private func processActivity(_ item: PendingActivity) async -> Bool {
        guard let token = pat else { return false }
        do {
            if !item.linkRecordId.isEmpty,
               await activityExistsOnServer(token: token,
                                            type: item.type,
                                            linkRecordId: item.linkRecordId,
                                            feltAt: item.at) {
                log.notice("\(item.type, privacy: .public) row already on server — skipping create")
                return true
            }
            try await createActivityRow(token: token, item: item)
            return true
        } catch {
            log.error("Activity write failed: \(Self.describe(error), privacy: .public)")
            return false
        }
    }

    /// The one writer: POST `ActivityLedger.fields(for:)` to App Activity.
    /// `typecast: true` lets a new `Activity Type` or `Gesture Source` option
    /// be born on first write.
    private func createActivityRow(token: String, item: PendingActivity) async throws {
        let body: [String: Any] = ["fields": ActivityLedger.fields(for: item), "typecast": true]
        let data = try JSONSerialization.data(withJSONObject: body)

        var req = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(ActivityLedger.tableId)")!)
        req.httpMethod = "POST"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = data

        let (respData, response) = try await session.data(for: req)
        try Self.checkHTTP(response, data: respData)
    }

    /// Is this exact event already in the ledger? GET the rows of `type`
    /// within ±60 s of `feltAt` (a handful at most) and look for one that
    /// links `linkRecordId` *and* carries this `feltAt` to the second — the
    /// key the create wrote, which a queued retry repeats and a genuine second
    /// event never can. Window, key and match live in `RecognitionDedup` and
    /// `ActivityLedger`, pure and unit-tested. Fail-open: if the check itself
    /// fails, the failure is logged with status + body and the create proceeds
    /// — a broken check must never strand an event the way the July pipe did.
    private func activityExistsOnServer(token: String,
                                        type: String,
                                        linkRecordId: String,
                                        feltAt: Date) async -> Bool {
        do {
            let rows: [ActivityLedger.Row] = try await fetch(
                token: token,
                table: ActivityLedger.tableId,
                filter: ActivityLedger.dedup(type: type, around: feltAt),
                sort: [],
                fields: RecognitionDedup.readFields,
                byFieldId: false
            )
            return rows.contains {
                ActivityLedger.rowMatches($0, linkRecordId: linkRecordId, feltAt: feltAt)
            }
        } catch {
            log.error("Ledger dedup check (\(type, privacy: .public)) failed — proceeding with create: \(Self.describe(error), privacy: .public)")
            return false
        }
    }

    private func flushPendingActivities() async {
        let queue = loadPendingActivities()
        guard !queue.isEmpty else { return }
        guard pat != nil else {
            // No-PAT mode holds, never drops: the queue is left exactly as it is.
            log.notice("Activity queue: \(queue.count) waiting for a token")
            return
        }
        log.notice("Activity queue: flushing \(queue.count) item(s)")
        var succeeded: [Bool] = []
        for item in queue {
            succeeded.append(await processActivity(item))
        }
        let update = PendingQueuePolicy.update(queue, hasToken: true, succeeded: succeeded)
        for item in update.dropped {
            log.notice("Activity dropped after \(item.failCount) failures: \(item.type, privacy: .public)")
        }
        // Keep anything enqueued behind the snapshot while this drain awaited the network.
        let remaining = PendingQueuePolicy.merge(remaining: update.remaining, drained: queue, stored: loadPendingActivities())
        savePendingActivities(remaining)
        if remaining.isEmpty {
            log.notice("Activity queue: drained (\(update.dropped.count) dropped)")
        } else {
            log.notice("Activity queue: \(remaining.count) still pending (\(update.dropped.count) dropped)")
        }
    }

    private func loadPendingActivities() -> [PendingActivity] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingActivityKey) else { return [] }
        let (queue, stamped): ([PendingActivity], Bool) = PendingQueueStorage.decode(data)
        if stamped { savePendingActivities(queue) }
        return queue
    }

    private func savePendingActivities(_ queue: [PendingActivity]) {
        if queue.isEmpty {
            UserDefaults.standard.removeObject(forKey: Self.pendingActivityKey)
            return
        }
        if let data = try? JSONEncoder().encode(queue) {
            UserDefaults.standard.set(data, forKey: Self.pendingActivityKey)
        }
    }

    private func enqueueActivity(_ item: PendingActivity) {
        var queue = loadPendingActivities()
        queue.append(item)
        savePendingActivities(queue)
        log.notice("Activity queued: \(item.type, privacy: .public) (queue size: \(queue.count))")
    }

    // MARK: Letter-Written dedup (once per Śakti, ever)

    static func hasLedgeredLetter(_ recordId: String) -> Bool {
        let ids = UserDefaults.standard.stringArray(forKey: ledgeredLettersKey) ?? []
        return ids.contains(recordId)
    }

    static func markLetterLedgered(_ recordId: String) {
        var ids = UserDefaults.standard.stringArray(forKey: ledgeredLettersKey) ?? []
        guard !ids.contains(recordId) else { return }
        ids.append(recordId)
        UserDefaults.standard.set(ids, forKey: ledgeredLettersKey)
    }

    /// Server-derived Letter-Written dedup (§0.6). The local `ledgeredLetters`
    /// set is per-install, so a reinstall or a second device would re-log
    /// "Letter Written" for a Śakti the ledger already holds. Once per sync,
    /// read the ledger's own view and union it in: a Śakti whose Letter is
    /// non-empty on the server *and* is already linked from a Letter-Written
    /// row is marked ledgered locally. Failure is logged and non-fatal — the
    /// local set still governs.
    private func reconcileLedgeredLetters(token: String, shaktis: [ShaktiRow]) async {
        do {
            let linked = try await fetchLetterWrittenLinks(token: token)
            var marked = 0
            for row in shaktis {
                guard let letter = row.fields.letter?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !letter.isEmpty,
                      linked.contains(row.id),
                      !Self.hasLedgeredLetter(row.id) else { continue }
                Self.markLetterLedgered(row.id)
                marked += 1
            }
            log.notice("Letter ledger: \(linked.count) linked on server, \(marked) newly marked locally")
        } catch {
            log.error("Letter ledger read failed: \(Self.describe(error), privacy: .public)")
        }
    }

    /// One paged GET against App Activity: the Śakti record ids linked from
    /// every `Letter Written` row. The ledger is read by field *name*,
    /// matching its writes, and only the link column comes back.
    private func fetchLetterWrittenLinks(token: String) async throws -> Set<String> {
        let rows: [ActivityLedger.Row] = try await fetch(
            token: token,
            table: ActivityLedger.tableId,
            filter: "{\(ActivityLedger.Field.activityType)}='\(ActivityLedger.ActivityType.letterWritten)'",
            sort: [],
            fields: [ActivityLedger.Field.linkToMandala],
            byFieldId: false
        )
        var linked = Set<String>()
        for r in rows {
            for id in r.fields.linkToMandala ?? [] { linked.insert(id) }
        }
        return linked
    }
}

// MARK: - HTTP error

/// An Airtable HTTP failure that keeps *why*: the status and Airtable's error
/// body (truncated), so the unified log can show e.g. `HTTP 422: {"error":…}`
/// instead of a bare "bad server response". Carries no headers and never the
/// token — only the response body Airtable returned.
struct AirtableHTTPError: Error, CustomStringConvertible, LocalizedError {
    let status: Int
    let body: String

    /// Bodies are clipped so a runaway HTML error page can't flood the log.
    static let bodyLimit = 600

    init(status: Int, body: String) {
        self.status = status
        self.body = String(body.prefix(Self.bodyLimit))
    }

    init(status: Int, data: Data) {
        let text = String(data: data, encoding: .utf8) ?? "<\(data.count) non-UTF8 bytes>"
        self.init(status: status, body: text)
    }

    var description: String { "HTTP \(status): \(body)" }
    var errorDescription: String? { description }
}

// MARK: - Pending-queue policy (pure, shared by every offline queue)

/// Anything held in a UserDefaults queue awaiting Airtable: it carries a stable
/// identity (stamped at enqueue, persisted with the item) so a drain can tell
/// the items it took from any enqueued while it ran, and how many flushes have
/// failed so the policy can retire it.
protocol PendingQueueItem {
    var id: String { get }
    var failCount: Int { get set }
}

/// Decoding for the UserDefaults-backed queues. Items written by a build that
/// predates item ids decode with a fresh id stamped on each, so the queue
/// survives the upgrade instead of failing to decode and vanishing. The caller
/// persists a stamped queue at once — a drain compares ids across two loads,
/// so they must be stable.
enum PendingQueueStorage {
    static func decode<Item: Decodable>(_ data: Data) -> (queue: [Item], stamped: Bool) {
        if let queue = try? JSONDecoder().decode([Item].self, from: data) { return (queue, false) }
        guard var raw = (try? JSONSerialization.jsonObject(with: data)) as? [[String: Any]] else {
            return ([], false)
        }
        var stamped = false
        for i in raw.indices where raw[i]["id"] == nil {
            raw[i]["id"] = UUID().uuidString
            stamped = true
        }
        guard stamped,
              let restamped = try? JSONSerialization.data(withJSONObject: raw),
              let queue = try? JSONDecoder().decode([Item].self, from: restamped) else {
            return ([], false)
        }
        return (queue, true)
    }
}

/// The queue-update decision every flush applies, extracted from the loops so
/// it is testable without a network (§0.6 "make the pipe honest").
///
/// - No token: the queue is **held untouched** — nothing bumps, nothing drops.
///   Items wait for a token.
/// - Success: the item leaves the queue.
/// - Failure: `failCount` bumps; at `maxFailures` the item is dropped (local
///   SwiftData is already canonical, so the only loss is the Airtable mirror).
enum PendingQueuePolicy {

    static let maxFailures = 3

    enum Decision: Equatable {
        /// No token — leave the item exactly as it is.
        case hold
        /// The write succeeded — remove the item.
        case remove
        /// The write failed — keep the item with this bumped fail count.
        case retain(failCount: Int)
        /// The write failed for the last time — drop the item.
        case drop(failCount: Int)
    }

    static func decide(hasToken: Bool,
                       succeeded: Bool,
                       failCount: Int,
                       maxFailures: Int = maxFailures) -> Decision {
        guard hasToken else { return .hold }
        if succeeded { return .remove }
        let bumped = failCount + 1
        return bumped >= maxFailures ? .drop(failCount: bumped) : .retain(failCount: bumped)
    }

    /// Apply `decide` across a whole queue. `succeeded[i]` is the flush result
    /// for `queue[i]` (a missing result counts as a failure); with no token the
    /// results are ignored and the queue comes back exactly as it went in.
    /// Dropped items are returned with their final fail count so the caller
    /// can log them.
    static func update<Item: PendingQueueItem>(
        _ queue: [Item],
        hasToken: Bool,
        succeeded: [Bool],
        maxFailures: Int = maxFailures
    ) -> (remaining: [Item], dropped: [Item]) {
        guard hasToken else { return (queue, []) }
        var remaining: [Item] = []
        var dropped: [Item] = []
        for (i, item) in queue.enumerated() {
            let ok = i < succeeded.count ? succeeded[i] : false
            switch decide(hasToken: true, succeeded: ok,
                          failCount: item.failCount, maxFailures: maxFailures) {
            case .hold:
                remaining.append(item)
            case .remove:
                continue
            case .retain(let n):
                var kept = item
                kept.failCount = n
                remaining.append(kept)
            case .drop(let n):
                var gone = item
                gone.failCount = n
                dropped.append(gone)
            }
        }
        return (remaining, dropped)
    }

    /// A drain works on the snapshot it loaded and awaits the network per item;
    /// anything enqueued meanwhile landed in the store behind it. The final save
    /// is therefore `remaining` (the drain's survivors, in order) followed by
    /// every stored item the drain never saw — never the snapshot alone, which
    /// would erase the newcomers. Items the drain removed or dropped stay gone.
    static func merge<Item: PendingQueueItem>(remaining: [Item],
                                              drained: [Item],
                                              stored: [Item]) -> [Item] {
        let seen = Set(drained.map(\.id))
        return remaining + stored.filter { !seen.contains($0.id) }
    }

    /// Collapse to the newest item per key (first-seen key order kept) — the
    /// letter queue's rule, where only the latest body per Śakti may survive.
    static func latestPerKey<Item: PendingQueueItem, Key: Hashable>(
        _ queue: [Item],
        key: (Item) -> Key,
        at: (Item) -> Date
    ) -> [Item] {
        var order: [Key] = []
        var newest: [Key: Item] = [:]
        for item in queue {
            let k = key(item)
            if let held = newest[k] {
                if at(item) > at(held) { newest[k] = item }
            } else {
                order.append(k)
                newest[k] = item
            }
        }
        return order.compactMap { newest[$0] }
    }
}

// MARK: - Recognition idempotency (pure helpers)

/// Before an event row is created in App Activity, the ledger is asked whether
/// this exact moment is already there — the retry path after a create-succeeded
/// / PATCH-failed split would otherwise write it twice. The key is the one the
/// create wrote: the record id in `Link to Mandala` (her Shakti row; the
/// Avaraṇa row for a crossing) plus `Felt At` to the second. A queued retry
/// carries the original `feltAt`, so it matches; a genuine second recognition
/// of the same Śakti never can (the ceremony alone outlasts a second). The
/// ±60 s window is only the fetch — it keeps the page to a handful of rows;
/// the formula itself is `ActivityLedger.dedup`. The same second-precision key
/// guards the Shakti-row PATCH (`patchAlreadyLanded`). Everything here is pure
/// so it is testable without a network. Nothing here touches Notes — that is
/// the practitioner's text.
enum RecognitionDedup {

    /// Half-width of the fetch window.
    static let windowSeconds: TimeInterval = 60

    /// The two ledger columns the check reads (`fields[]`, by name): the link
    /// and `Felt At` — the whole key, nothing else.
    static let readFields = [ActivityLedger.Field.linkToMandala, ActivityLedger.Field.feltAt]

    /// `Felt At` exactly as the create writes it: second precision, `Z`.
    static func writtenFeltAt(_ feltAt: Date) -> String {
        writtenFormatter().string(from: feltAt)
    }

    /// `Felt At` as the API returns it — `2026-07-13T21:25:33.000Z` (ms) —
    /// brought to the written form so the two compare as strings. `nil` when
    /// it is in neither form: an unreadable timestamp is never a match.
    static func normalizedServerFeltAt(_ raw: String) -> String? {
        let fractional = writtenFormatter()
        fractional.formatOptions.insert(.withFractionalSeconds)
        guard let date = fractional.date(from: raw) ?? writtenFormatter().date(from: raw) else {
            return nil
        }
        return writtenFeltAt(date)
    }

    private static func writtenFormatter() -> ISO8601DateFormatter {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        iso.timeZone = TimeZone(secondsFromGMT: 0)
        return iso
    }

    /// ISO8601 Z bounds of the window: exactly `feltAt ∓ windowSeconds`, in the
    /// same second-precision `…Z` form the create wrote to `Felt At`.
    static func window(around feltAt: Date) -> (lower: String, upper: String) {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        iso.timeZone = TimeZone(secondsFromGMT: 0)
        return (lower: iso.string(from: feltAt.addingTimeInterval(-windowSeconds)),
                upper: iso.string(from: feltAt.addingTimeInterval(windowSeconds)))
    }

    /// Did this gesture's Shakti-row PATCH already land? `Last Felt` and the
    /// count go in one PATCH, so a `Last Felt` equal to this gesture's exact
    /// second means it did (its response was lost, not the write) — and the
    /// count on the row already includes her. An absent or unreadable
    /// `Last Felt` is never a match.
    static func patchAlreadyLanded(lastFelt: String?, feltAt: Date) -> Bool {
        guard let lastFelt, let server = normalizedServerFeltAt(lastFelt) else { return false }
        return server == writtenFeltAt(feltAt)
    }

    /// True only when the row links `linkRecordId` *and* carries this `feltAt`
    /// to the second — the full client key. The same link at another second
    /// is another moment.
    static func rowMatches(links: [String]?,
                           feltAt rowFeltAt: String?,
                           linkRecordId: String,
                           feltAt: Date) -> Bool {
        guard let links, !linkRecordId.isEmpty,
              links.contains(linkRecordId) else { return false }
        guard let raw = rowFeltAt, let server = normalizedServerFeltAt(raw) else { return false }
        return server == writtenFeltAt(feltAt)
    }
}
