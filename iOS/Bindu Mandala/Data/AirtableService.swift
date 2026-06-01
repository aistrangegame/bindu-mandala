import Foundation
import SwiftData
import os

private let log = Logger(subsystem: "com.ashrey.bindu-mandala", category: "airtable")

/// Reconciles the local SwiftData store from Airtable for Śaktis, Avaraṇas, and Nityā Devīs.
/// The local cache is always the source of truth at read time — Airtable is a quiet background
/// updater. Failures are silent. The "I feel her" gesture never depends on a successful sync.
@MainActor
final class AirtableService {

    static let shared = AirtableService()

    static let baseId  = "app248ZTWhYJlvQj2"
    static let tableId = "tblrRwXJD0uP8HU8G"

    /// Avaraṇa record-id → ring number (from brief §3, confirmed live May 28, 2026).
    /// The Avaraṇa rows do not carry a Ring Number field, so we identify by record id.
    private static let avaranaRingByRecordId: [String: Int] = [
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

    /// PAT loaded from Info.plist (`AIRTABLE_PAT`, fed by `Config.xcconfig`).
    /// Returns nil when missing — sync silently stays on local data.
    var pat: String? {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "AIRTABLE_PAT") as? String,
              !raw.isEmpty,
              raw != "$(AIRTABLE_PAT)" else { return nil }
        return raw
    }

    private let session = URLSession(configuration: .ephemeral)

    // MARK: - Orchestration

    func sync(context: ModelContext) async {
        // Drain any pending recognitions first — they piggyback on every sync.
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
            logVerification(shaktis: sk.count, avaranas: av.count, nityas: nt.count, context: context)
        } catch {
            log.error("Sync failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Generic paged fetch

    private func fetch<Row: Decodable>(
        token: String,
        filter: String,
        sort: [(field: String, direction: String)]
    ) async throws -> [Row] {
        var all: [Row] = []
        var offset: String? = nil
        repeat {
            var comps = URLComponents(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)")!
            var items: [URLQueryItem] = [
                .init(name: "pageSize", value: "100"),
                .init(name: "filterByFormula", value: filter),
                .init(name: "returnFieldsByFieldId", value: "true"),
            ]
            for (i, pair) in sort.enumerated() {
                items.append(.init(name: "sort[\(i)][field]", value: pair.field))
                items.append(.init(name: "sort[\(i)][direction]", value: pair.direction))
            }
            if let offset { items.append(.init(name: "offset", value: offset)) }
            comps.queryItems = items
            var req = URLRequest(url: comps.url!)
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let (data, response) = try await session.data(for: req)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let page = try JSONDecoder().decode(Page<Row>.self, from: data)
            all.append(contentsOf: page.records)
            offset = page.offset
        } while offset != nil
        return all
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

    // MARK: - Position helpers

    private func ringNumber(forKhadgamala kp: Int) -> Int {
        switch kp {
        case 1...28:   return 1
        case 29...44:  return 2
        case 45...52:  return 3
        case 53...66:  return 4
        case 67...76:  return 5
        case 77...86:  return 6
        case 87...98:  return 7
        case 99...101: return 8
        case 102:      return 9
        default:       return 0
        }
    }

    private func ringStartOffset(_ ring: Int) -> Int {
        switch ring {
        case 1: return 0
        case 2: return 28
        case 3: return 44
        case 4: return 52
        case 5: return 66
        case 6: return 76
        case 7: return 86
        case 8: return 98
        case 9: return 101
        default: return 0
        }
    }

    // MARK: - Reconcile

    private func reconcileShaktis(_ rows: [ShaktiRow], context: ModelContext) throws {
        let existing = try context.fetch(FetchDescriptor<Shakti>())

        for row in rows {
            guard let kp = row.fields.khadgamalaPosition, (1...102).contains(kp) else { continue }
            let ring = ringNumber(forKhadgamala: kp)
            guard ring > 0 else { continue }
            let perRing = kp - ringStartOffset(ring)

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
            shakti.lastSyncedAt = .now
        }
        try context.save()
    }

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
            log.notice("  \(s.khadgamalaPosition ?? 0) · ring \(s.ringNumber ?? 0) · \(s.name, privacy: .public) · \(s.devanagari ?? "—", privacy: .public) · \(portrait, privacy: .public)")
        }
        log.notice("[Phase 1] Avaranas fetched: \(avaranas)")
        let allA = (try? context.fetch(FetchDescriptor<Avarana>())) ?? []
        for a in allA.sorted(by: { $0.ringNumber < $1.ringNumber }) {
            let conn = String((a.personalConnection ?? "").prefix(80))
            log.notice("  ring \(a.ringNumber) · \(a.sanskritName, privacy: .public) · \(conn, privacy: .public)")
        }
        log.notice("[Phase 1] Nityas fetched: \(nityas)")
        let allN = (try? context.fetch(FetchDescriptor<NityaDevi>())) ?? []
        for n in allN.sorted(by: { $0.tithiPosition < $1.tithiPosition }) {
            log.notice("  \(n.tithiPosition) · \(n.sanskritName, privacy: .public) · \(n.quality ?? "—", privacy: .public)")
        }
    }
}

// MARK: - Phase 10 · Recognition reads (Her Moments)

/// One Recognition row read from Airtable for a single Shakti's history.
struct RecognitionAirtableRow: Identifiable, Equatable {
    let id: String
    let feltAt: Date?
    let notes: String?
    let moonPhase: String?
}

extension AirtableService {

    /// Fetch up to 5 most-recent Recognition rows for a given Shakti.
    /// Strategy: pull the 20 newest Recognitions globally (already filtered by
    /// `Row Type`), then keep only those linking this Shakti. Most practitioners
    /// have < 20 recognitions in any short window so the 5 we need almost
    /// always appear in the first page. Throws on network failure; the caller
    /// should fall back to local SwiftData if this fails.
    func fetchRecognitions(forShaktiRecordId shaktiRecordId: String,
                           limit: Int = 5) async throws -> [RecognitionAirtableRow] {
        guard let token = pat else { return [] }

        struct Row: Decodable {
            let id: String
            let fields: Fields
            struct Fields: Decodable {
                let feltAt: String?
                let notes: String?
                let moonPhase: String?
                let ofShakti: [String]?
                enum CodingKeys: String, CodingKey {
                    case feltAt    = "fldk4BdikzJQOautw"
                    case notes     = "fld1HR38cQAtEicFc"
                    case moonPhase = "fldFZcZ5AVcOWwo6X"
                    case ofShakti  = "fldaDjmaPvu57sJVg"
                }
            }
        }

        var comps = URLComponents(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)")!
        comps.queryItems = [
            .init(name: "pageSize",                value: "20"),
            .init(name: "filterByFormula",         value: "{fldw33m8YqrINlvrN}='Recognition'"),
            .init(name: "returnFieldsByFieldId",   value: "true"),
            .init(name: "sort[0][field]",          value: "fldk4BdikzJQOautw"),
            .init(name: "sort[0][direction]",      value: "desc"),
        ]
        var req = URLRequest(url: comps.url!)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        struct Page: Decodable { let records: [Row] }
        let page = try JSONDecoder().decode(Page.self, from: data)
        let iso = ISO8601DateFormatter()

        let matching: [RecognitionAirtableRow] = page.records.compactMap { row in
            guard let ofShakti = row.fields.ofShakti,
                  ofShakti.contains(shaktiRecordId) else { return nil }
            return RecognitionAirtableRow(
                id: row.id,
                feltAt: row.fields.feltAt.flatMap { iso.date(from: $0) },
                notes: row.fields.notes,
                moonPhase: row.fields.moonPhase
            )
        }
        return Array(matching.prefix(limit))
    }
}

// MARK: - Phase 6 · Recognition writes

extension AirtableService {

    /// Where the recognition gesture originated. Maps directly to the Airtable
    /// `Source` singleSelect. Phase 6 only fires `.today`; others sit ready.
    enum RecognitionSource: String {
        case today    = "Today"
        case mandala  = "Mandala"
        case silence  = "Silence"
        case well     = "Well"
    }

    /// One unfulfilled Recognition write held in UserDefaults until the network returns.
    /// `failCount` is incremented per retry; items are dropped after `maxFailures`.
    private struct PendingRecognition: Codable {
        let shaktiRecordId: String
        let note: String?
        let source: String
        let feltAt: Date
        let lunarDay: Int
        let moonPhase: String
        var failCount: Int = 0
    }

    private static let pendingKey = "pendingRecognitions"
    private static let maxFailures = 3

    // MARK: Field IDs (write contract from brief §3)
    private static let fldRowType          = "Row Type"
    private static let fldOfShakti         = "Of Shakti"
    private static let fldFeltAt           = "Felt At"
    private static let fldNotes            = "Notes"
    private static let fldLunarDay         = "Lunar Day"
    private static let fldMoonPhase        = "Moon Phase"
    private static let fldSource           = "Source"
    private static let fldLastFelt         = "Last Felt"
    private static let fldRecognitionCount = "Recognition Count"
    private static let fldStatus           = "Status"

    /// Fire-and-forget. Two-step Airtable write (create Recognition row, then
    /// GET + PATCH Shakti row). On any failure, the item is enqueued in
    /// UserDefaults for retry on the next sync or scene-active transition.
    /// Pre-sync Shaktis (no `airtableRecordId`) silently skip — stays local only.
    func recordRecognition(shakti: Shakti,
                           note: String?,
                           source: RecognitionSource,
                           context: ModelContext) async {
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

    /// Drain the Recognition, Silence, and Letter pending queues. Called at
    /// the start of every `sync()` and on scene-phase `.active`. Items that
    /// fail `maxFailures` times in a row are dropped silently — local SwiftData
    /// is already canonical, so the only loss is the Airtable mirror.
    func flushPending(context: ModelContext) async {
        await flushPendingRecognitions(context: context)
        await flushPendingSilences()
        await flushPendingLetters()
    }

    private func flushPendingRecognitions(context: ModelContext) async {
        let queue = loadPending()
        guard !queue.isEmpty else { return }
        log.notice("Recognition queue: flushing \(queue.count) item(s)")
        var remaining: [PendingRecognition] = []
        var dropped = 0
        for item in queue {
            let success = await processRecognition(item, context: context)
            if success { continue }
            var bumped = item
            bumped.failCount += 1
            if bumped.failCount >= Self.maxFailures {
                dropped += 1
                log.notice("Recognition dropped after \(bumped.failCount) failures: \(item.shaktiRecordId, privacy: .public)")
            } else {
                remaining.append(bumped)
            }
        }
        savePending(remaining)
        if remaining.isEmpty {
            log.notice("Recognition queue: drained (\(dropped) dropped)")
        } else {
            log.notice("Recognition queue: \(remaining.count) still pending (\(dropped) dropped)")
        }
    }

    // MARK: - Two-step write

    private func processRecognition(_ item: PendingRecognition,
                                    context: ModelContext) async -> Bool {
        guard let token = pat else { return false }
        do {
            try await createRecognitionRow(token: token, item: item)
            let newStatusRaw = try await patchShaktiAfterRecognition(
                token: token,
                shaktiRecordId: item.shaktiRecordId,
                feltAt: item.feltAt
            )
            updateLocalShakti(
                recordId: item.shaktiRecordId,
                statusRaw: newStatusRaw,
                context: context
            )
            return true
        } catch {
            log.error("Recognition write failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    private func createRecognitionRow(token: String, item: PendingRecognition) async throws {
        let iso = ISO8601DateFormatter()
        var fields: [String: Any] = [
            Self.fldRowType:   "Recognition",
            Self.fldOfShakti:  [item.shaktiRecordId],
            Self.fldFeltAt:    iso.string(from: item.feltAt),
            Self.fldLunarDay:  item.lunarDay,
            Self.fldMoonPhase: item.moonPhase,
            Self.fldSource:    item.source
        ]
        if let note = item.note?.trimmingCharacters(in: .whitespacesAndNewlines), !note.isEmpty {
            fields[Self.fldNotes] = note
        }
        let body: [String: Any] = ["fields": fields, "typecast": true]
        let data = try JSONSerialization.data(withJSONObject: body)

        var req = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)")!)
        req.httpMethod = "POST"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = data

        let (_, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    /// GET the Shakti row to read the server's current count + status, compute
    /// new count + status (advance-only), PATCH. Returns the new status rawValue
    /// so the caller can mirror it locally.
    private func patchShaktiAfterRecognition(token: String,
                                              shaktiRecordId: String,
                                              feltAt: Date) async throws -> String {
        // GET
        var getReq = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)/\(shaktiRecordId)")!)
        getReq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (getData, getResp) = try await session.data(for: getReq)
        guard let httpGet = getResp as? HTTPURLResponse, (200..<300).contains(httpGet.statusCode) else {
            throw URLError(.badServerResponse)
        }

        struct GetResponse: Decodable {
            let fields: Fields
            struct Fields: Decodable {
                let recognitionCount: Int?
                let status: String?
                enum CodingKeys: String, CodingKey {
                    case recognitionCount = "Recognition Count"
                    case status           = "Status"
                }
            }
        }
        let parsed = try JSONDecoder().decode(GetResponse.self, from: getData)
        let currentCount = parsed.fields.recognitionCount ?? 0
        let newCount = currentCount + 1

        // Status advance-only against the server's current status
        let order: [ShaktiStatus] = [.mapped, .exploring, .active, .embodied]
        let serverStatus = parseStatus(parsed.fields.status) ?? .mapped
        var newStatus = serverStatus
        if newCount >= 7      { newStatus = .embodied }
        else if newCount >= 3 { newStatus = .active }
        else if newCount >= 1 { newStatus = .exploring }
        let serverIdx = order.firstIndex(of: serverStatus) ?? 0
        let newIdx    = order.firstIndex(of: newStatus) ?? 0
        if newIdx < serverIdx { newStatus = serverStatus }

        // PATCH
        let iso = ISO8601DateFormatter()
        let fields: [String: Any] = [
            Self.fldLastFelt:         iso.string(from: feltAt),
            Self.fldRecognitionCount: newCount,
            Self.fldStatus:           newStatus.rawValue.capitalized
        ]
        let body: [String: Any] = ["fields": fields, "typecast": true]
        let data = try JSONSerialization.data(withJSONObject: body)

        var patchReq = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)/\(shaktiRecordId)")!)
        patchReq.httpMethod = "PATCH"
        patchReq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        patchReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        patchReq.httpBody = data

        let (_, patchResp) = try await session.data(for: patchReq)
        guard let httpPatch = patchResp as? HTTPURLResponse, (200..<300).contains(httpPatch.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return newStatus.rawValue
    }

    /// Mirror the new status onto the local Shakti so the Detail screen reflects
    /// the change without waiting for the next reconcile. Advance-only locally too.
    private func updateLocalShakti(recordId: String,
                                    statusRaw: String,
                                    context: ModelContext) {
        guard let all = try? context.fetch(FetchDescriptor<Shakti>()),
              let local = all.first(where: { $0.airtableRecordId == recordId }) else { return }
        guard let parsed = ShaktiStatus(rawValue: statusRaw.lowercased()) else { return }
        let order: [ShaktiStatus] = [.mapped, .exploring, .active, .embodied]
        let li = order.firstIndex(of: local.status) ?? 0
        let ri = order.firstIndex(of: parsed) ?? 0
        local.status = order[max(li, ri)]
        local.lastSyncedAt = .now
        try? context.save()
    }

    // MARK: - Pending queue (UserDefaults-backed)

    private func loadPending() -> [PendingRecognition] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingKey),
              let queue = try? JSONDecoder().decode([PendingRecognition].self, from: data) else {
            return []
        }
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

    // MARK: - Phase 7 · Silence writes

    private struct PendingSilence: Codable {
        let durationSec: Double
        let feltAt: Date
        var failCount: Int = 0
    }

    private static let pendingSilenceKey = "pendingSilences"
    private static let fldDuration = "Duration (sec)"   // fldlBReoX5yvo1eY7

    /// Fire-and-forget single-row POST. Failure is silent; the item is queued
    /// in UserDefaults for retry. The caller (SilenceView) is responsible for
    /// the 1.0s minimum-duration gate.
    func recordSilence(durationSec: Double) async {
        let item = PendingSilence(durationSec: durationSec, feltAt: .now)
        let success = await processSilence(item)
        if !success {
            enqueueSilence(item)
        }
    }

    private func processSilence(_ item: PendingSilence) async -> Bool {
        guard let token = pat else { return false }
        do {
            try await createSilenceRow(token: token, item: item)
            return true
        } catch {
            log.error("Silence write failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    private func createSilenceRow(token: String, item: PendingSilence) async throws {
        let iso = ISO8601DateFormatter()
        let fields: [String: Any] = [
            Self.fldRowType:  "Silence",
            Self.fldFeltAt:   iso.string(from: item.feltAt),
            Self.fldDuration: item.durationSec,
            Self.fldSource:   "Silence"
        ]
        let body: [String: Any] = ["fields": fields, "typecast": true]
        let data = try JSONSerialization.data(withJSONObject: body)

        var req = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)")!)
        req.httpMethod = "POST"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = data

        let (_, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    private func flushPendingSilences() async {
        let queue = loadPendingSilences()
        guard !queue.isEmpty else { return }
        log.notice("Silence queue: flushing \(queue.count) item(s)")
        var remaining: [PendingSilence] = []
        var dropped = 0
        for item in queue {
            let success = await processSilence(item)
            if success { continue }
            var bumped = item
            bumped.failCount += 1
            if bumped.failCount >= Self.maxFailures {
                dropped += 1
                log.notice("Silence dropped after \(bumped.failCount) failures")
            } else {
                remaining.append(bumped)
            }
        }
        savePendingSilences(remaining)
        if remaining.isEmpty {
            log.notice("Silence queue: drained (\(dropped) dropped)")
        } else {
            log.notice("Silence queue: \(remaining.count) still pending (\(dropped) dropped)")
        }
    }

    private func loadPendingSilences() -> [PendingSilence] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingSilenceKey),
              let queue = try? JSONDecoder().decode([PendingSilence].self, from: data) else {
            return []
        }
        return queue
    }

    private func savePendingSilences(_ queue: [PendingSilence]) {
        if queue.isEmpty {
            UserDefaults.standard.removeObject(forKey: Self.pendingSilenceKey)
            return
        }
        if let data = try? JSONEncoder().encode(queue) {
            UserDefaults.standard.set(data, forKey: Self.pendingSilenceKey)
        }
    }

    private func enqueueSilence(_ item: PendingSilence) {
        var queue = loadPendingSilences()
        queue.append(item)
        savePendingSilences(queue)
        log.notice("Silence queued (queue size: \(queue.count))")
    }

    // MARK: - Phase 8 · Letter writes

    private struct PendingLetter: Codable {
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
        guard let recordId = shakti.airtableRecordId, !recordId.isEmpty else {
            log.notice("Letter: no airtableRecordId — skipping Airtable write")
            return
        }
        let item = PendingLetter(shaktiRecordId: recordId, body: body, updatedAt: .now)
        let success = await processLetter(item)
        if !success {
            enqueueLetter(item)
        }
    }

    private func processLetter(_ item: PendingLetter) async -> Bool {
        guard let token = pat else { return false }
        do {
            try await patchLetter(token: token, item: item)
            return true
        } catch {
            log.error("Letter write failed: \(error.localizedDescription, privacy: .public)")
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

        let (_, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    private func flushPendingLetters() async {
        let queue = loadPendingLetters()
        guard !queue.isEmpty else { return }
        log.notice("Letter queue: flushing \(queue.count) item(s)")
        var remaining: [PendingLetter] = []
        var dropped = 0
        for item in queue {
            let success = await processLetter(item)
            if success { continue }
            var bumped = item
            bumped.failCount += 1
            if bumped.failCount >= Self.maxFailures {
                dropped += 1
                log.notice("Letter dropped after \(bumped.failCount) failures: \(item.shaktiRecordId, privacy: .public)")
            } else {
                remaining.append(bumped)
            }
        }
        savePendingLetters(remaining)
        if remaining.isEmpty {
            log.notice("Letter queue: drained (\(dropped) dropped)")
        } else {
            log.notice("Letter queue: \(remaining.count) still pending (\(dropped) dropped)")
        }
    }

    private func loadPendingLetters() -> [PendingLetter] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingLetterKey),
              let queue = try? JSONDecoder().decode([PendingLetter].self, from: data) else {
            return []
        }
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
