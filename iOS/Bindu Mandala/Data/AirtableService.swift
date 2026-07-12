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
            // After the field data is local, rebuild the recognition log if the
            // device has none — the path home after a reinstall/recovery.
            await restoreRecognitionsIfLocalEmpty(context: context)
            await restoreDescentIfLocalEmpty(context: context)
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

            // Restore a Ring-2 letter from Airtable when none exists locally.
            // The Well is offline-first and Ring-2 only (ShaktiLetter is keyed
            // 1–16), so we seed only when the practitioner has no local draft —
            // never overwriting a newer local edit.
            if ring == 2,
               let remoteLetter = row.fields.letter?.trimmingCharacters(in: .whitespacesAndNewlines),
               !remoteLetter.isEmpty {
                seedLetterIfMissing(position: perRing, body: remoteLetter, context: context)
            }

            shakti.lastSyncedAt = .now
        }
        try context.save()
    }

    /// Insert a `ShaktiLetter` only when the practitioner has none for this
    /// Ring-2 position — the local draft always wins.
    private func seedLetterIfMissing(position: Int, body: String, context: ModelContext) {
        let d = FetchDescriptor<ShaktiLetter>(
            predicate: #Predicate { $0.shaktiPosition == position }
        )
        if let existing = try? context.fetch(d), !existing.isEmpty { return }
        context.insert(ShaktiLetter(shaktiPosition: position, body: body))
    }

    /// Rebuild the local recognition log from Airtable when it is empty — the
    /// path home after a reinstall or a store recovery. Guarded on emptiness so
    /// it can never duplicate existing history. Silent on any failure.
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

        struct RecRow: Decodable {
            let id: String
            let fields: Fields
            struct Fields: Decodable {
                let feltAt: String?
                let notes: String?
                let ofShakti: [String]?
                enum CodingKeys: String, CodingKey {
                    case feltAt   = "fldk4BdikzJQOautw"
                    case notes    = "fld1HR38cQAtEicFc"
                    case ofShakti = "fldaDjmaPvu57sJVg"
                }
            }
        }

        do {
            let rows: [RecRow] = try await fetch(
                token: token,
                filter: "{fldw33m8YqrINlvrN}='Recognition'",
                sort: [("fldk4BdikzJQOautw", "asc")]
            )
            let iso = ISO8601DateFormatter()
            var inserted = 0
            for r in rows {
                guard let rec = r.fields.ofShakti?.first, let map = byRecord[rec] else { continue }
                let ts = r.fields.feltAt.flatMap { iso.date(from: $0) } ?? Date()
                context.insert(RecognitionEntry(
                    timestamp: ts,
                    khadgamalaPosition: map.kp,
                    ringNumber: map.ring,
                    note: r.fields.notes,
                    gesture: .felt
                ))
                inserted += 1
            }
            if inserted > 0 { try? context.save() }
            log.notice("Recognition restore: inserted \(inserted) from Airtable")
        } catch {
            log.error("Recognition restore failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    /// Rebuild the descent timeline from Airtable when the local one is empty —
    /// the path home for `DescentState.crossings` after a reinstall/recovery
    /// (Ruling 8). Guarded on empty crossings so it never overwrites a live
    /// timeline; zero Crossing rows leave the bootstrap floor (2/2) untouched.
    func restoreDescentIfLocalEmpty(context: ModelContext) async {
        let states = (try? context.fetch(FetchDescriptor<DescentState>())) ?? []
        guard let state = states.first, state.crossings.isEmpty else { return }
        guard let token = pat else { return }

        struct CrossRow: Decodable {
            let fields: Fields
            struct Fields: Decodable {
                let ring: Int?
                let feltAt: String?
                enum CodingKeys: String, CodingKey {
                    case ring   = "fld225xgYl2Rs3TP6"   // Descent Ring
                    case feltAt = "fldk4BdikzJQOautw"   // Felt At
                }
            }
        }

        do {
            let rows: [CrossRow] = try await fetch(
                token: token,
                filter: "{fldw33m8YqrINlvrN}='Crossing'",
                sort: [("fldk4BdikzJQOautw", "asc")]
            )
            let iso = ISO8601DateFormatter()
            let restored: [(ring: Int, date: Date)] = rows.compactMap { r in
                guard let ring = r.fields.ring, (1...9).contains(ring) else { return nil }
                let d = r.fields.feltAt.flatMap { iso.date(from: $0) } ?? Date()
                return (ring, d)
            }
            guard !restored.isEmpty else { return }   // zero rows → floor untouched
            state.restore(from: restored)
            try? context.save()
            log.notice("Descent restore: rebuilt \(restored.count) crossing(s), deepest ring \(state.deepestReached)")
        } catch {
            log.error("Descent restore failed: \(error.localizedDescription, privacy: .public)")
        }
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
        await flushPendingActivities()
        await flushPendingCrossings()
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
            let previousCount = try await patchShaktiAfterRecognition(
                token: token,
                shaktiRecordId: item.shaktiRecordId,
                feltAt: item.feltAt
            )
            mirrorLocalCount(
                recordId: item.shaktiRecordId,
                increment: 1,
                context: context
            )
            // Threshold crossing for the shared ledger: the *first* time this
            // Śakti is ever felt. `previousCount` is the server's count read
            // *before* the increment PATCH, so `wasFirst` is per-Śakti — it
            // fires once for each of the 102, not only the first Śakti ever.
            let wasFirst = (previousCount == 0)
            if wasFirst {
                let name = shaktiName(recordId: item.shaktiRecordId, context: context)
                await logActivity(
                    type: Self.activityShaktiRecognized,
                    linkedShaktiRecordId: item.shaktiRecordId,
                    activityName: "\(name) — first recognition",
                    detail: "Felt here for the first time · \(item.moonPhase)"
                )
            }
            return true
        } catch {
            log.error("Recognition write failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    /// Local Śakti display name for a record id, or a quiet fallback.
    private func shaktiName(recordId: String, context: ModelContext) -> String {
        let all = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        let name = all.first(where: { $0.airtableRecordId == recordId })?.name ?? ""
        return name.isEmpty ? "A Śakti" : name
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

    /// GET the Shakti row to read the server's current count, compute the new
    /// count, PATCH. Status is intentionally **not** touched here — readiness
    /// is sensed (count grows); advancing is chosen (deliberate gesture on the
    /// Detail status pill, which calls `advanceStatus` separately).
    /// Returns the server's recognition count *before* this recognition (0 on
    /// the very first felt), so the caller can detect the first-recognition
    /// threshold without a second round-trip.
    @discardableResult
    private func patchShaktiAfterRecognition(token: String,
                                              shaktiRecordId: String,
                                              feltAt: Date) async throws -> Int {
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
                enum CodingKeys: String, CodingKey {
                    case recognitionCount = "Recognition Count"
                }
            }
        }
        let parsed = try JSONDecoder().decode(GetResponse.self, from: getData)
        // The server's count *before* this recognition. 0 ⇒ never felt before.
        let previousCount = parsed.fields.recognitionCount ?? 0
        let newCount = previousCount + 1

        // PATCH — count + lastFelt only.
        let iso = ISO8601DateFormatter()
        let fields: [String: Any] = [
            Self.fldLastFelt:         iso.string(from: feltAt),
            Self.fldRecognitionCount: newCount
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
        return previousCount
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
        _ = try? await session.data(for: req)
        // Failure is silent — the next reconcile will reassert the local
        // advance through the existing advance-only sync rule.
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
    /// in UserDefaults for retry. Retired in the living-Mandala rebuild — the
    /// silence-dwell view was replaced by the Bindu→Lalitā finale, which records
    /// recognition through the explicit "I feel her" path. Kept (uncalled) as a
    /// valid Airtable capability; queued rows still flush. Slated for removal in
    /// the PR-9 cleanup pass.
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

    // MARK: - Living Rite · Descent crossing writes (mirror of DescentState.crossings)

    private struct PendingCrossing: Codable {
        let ring: Int
        let feltAt: Date
        var failCount: Int = 0
    }

    private static let pendingCrossingKey = "pendingCrossings"
    private static let fldDescentRing = "Descent Ring"   // fld225xgYl2Rs3TP6

    /// Mirror one *new-deepest* descent crossing to Airtable. Called only when
    /// `DescentState.enter(ring:)` returns true, so it fires once per ring. The
    /// local `DescentState` is the source of truth; Airtable is the backup that
    /// `restoreDescentIfLocalEmpty` reads. `typecast: true` creates the `Crossing`
    /// Row-Type option on first write (the option is not pre-created — see PR-0).
    func recordCrossing(ring: Int) async {
        let item = PendingCrossing(ring: ring, feltAt: .now)
        if !(await processCrossing(item)) { enqueueCrossing(item) }
    }

    private func processCrossing(_ item: PendingCrossing) async -> Bool {
        guard let token = pat else { return false }
        do {
            try await createCrossingRow(token: token, item: item)
            return true
        } catch {
            log.error("Crossing write failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    private func createCrossingRow(token: String, item: PendingCrossing) async throws {
        let iso = ISO8601DateFormatter()
        let fields: [String: Any] = [
            Self.fldRowType:     "Crossing",
            Self.fldDescentRing: item.ring,
            Self.fldFeltAt:      iso.string(from: item.feltAt),
            Self.fldSource:      "Mandala"
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

    private func flushPendingCrossings() async {
        let queue = loadPendingCrossings()
        guard !queue.isEmpty else { return }
        log.notice("Crossing queue: flushing \(queue.count) item(s)")
        var remaining: [PendingCrossing] = []
        var dropped = 0
        for item in queue {
            if await processCrossing(item) { continue }
            var bumped = item
            bumped.failCount += 1
            if bumped.failCount >= Self.maxFailures {
                dropped += 1
                log.notice("Crossing dropped after \(bumped.failCount) failures (ring \(item.ring))")
            } else {
                remaining.append(bumped)
            }
        }
        savePendingCrossings(remaining)
    }

    private func loadPendingCrossings() -> [PendingCrossing] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingCrossingKey),
              let queue = try? JSONDecoder().decode([PendingCrossing].self, from: data) else {
            return []
        }
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

        // Threshold crossing for the shared ledger: the first time a letter is
        // written for this Śakti (empty → non-empty). The `ledgeredLetters` set
        // guards it to once per Śakti, so autosaves and later sessions never
        // re-log. The milestone is the act of writing (already saved locally),
        // so it fires regardless of the Airtable letter PATCH result.
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty, !Self.hasLedgeredLetter(recordId) {
            Self.markLetterLedgered(recordId)
            let name = shakti.name.isEmpty ? "a Śakti" : shakti.name
            await logActivity(
                type: Self.activityLetterWritten,
                linkedShaktiRecordId: recordId,
                activityName: "A letter to \(name)",
                detail: "First letter written"
            )
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

// MARK: - Cross-app App Activity ledger

/// A milestone written to the shared **App Activity** table (`tblJlBeiHnqGpYrL7`,
/// same base as Mandala). Only genuine threshold crossings land here — the first
/// recognition of a Śakti and the first letter written for her — never per-tap
/// recognitions or silences. Fire-and-forget with the same offline-first queue
/// pattern as the other writes; a ledger failure never affects the gesture.
extension AirtableService {

    // App Activity table + field names (write API accepts field names, matching
    // the existing writes). Values verified live via the Airtable schema.
    private static let activityTableId = "tblJlBeiHnqGpYrL7"
    private static let fldActSourceApp   = "Source App"
    private static let fldActType        = "Activity Type"
    private static let fldActName        = "Activity Name"
    private static let fldActDetail      = "Detail"
    private static let fldActDate        = "Activity Date"
    private static let fldActLinkMandala = "Link to Mandala"

    private static let sourceAppMandala        = "Mandala"
    static let activityShaktiRecognized        = "Shakti Recognized"
    static let activityLetterWritten           = "Letter Written"

    private static let pendingActivityKey = "pendingActivities"
    private static let ledgeredLettersKey = "ledgeredLetters"

    private struct PendingActivity: Codable {
        let type: String
        let linkRecordId: String
        let name: String
        let detail: String
        let at: Date
        var failCount: Int = 0
    }

    /// Write one milestone to the shared ledger. Fire-and-forget; on failure the
    /// item is queued in UserDefaults and drained by `flushPending`.
    func logActivity(type: String,
                     linkedShaktiRecordId: String,
                     activityName: String,
                     detail: String) async {
        let item = PendingActivity(type: type,
                                   linkRecordId: linkedShaktiRecordId,
                                   name: activityName,
                                   detail: detail,
                                   at: .now)
        if await processActivity(item) == false {
            enqueueActivity(item)
        }
    }

    private func processActivity(_ item: PendingActivity) async -> Bool {
        guard let token = pat else { return false }
        do {
            try await createActivityRow(token: token, item: item)
            return true
        } catch {
            log.error("Activity write failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    private func createActivityRow(token: String, item: PendingActivity) async throws {
        let dateFmt = DateFormatter()
        dateFmt.calendar = Calendar(identifier: .gregorian)
        dateFmt.locale = Locale(identifier: "en_US_POSIX")
        dateFmt.dateFormat = "yyyy-MM-dd"

        let fields: [String: Any] = [
            Self.fldActSourceApp:   Self.sourceAppMandala,
            Self.fldActType:        item.type,
            Self.fldActLinkMandala: [item.linkRecordId],
            Self.fldActName:        item.name,
            Self.fldActDetail:      item.detail,
            Self.fldActDate:        dateFmt.string(from: item.at)
        ]
        let body: [String: Any] = ["fields": fields, "typecast": true]
        let data = try JSONSerialization.data(withJSONObject: body)

        var req = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.activityTableId)")!)
        req.httpMethod = "POST"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = data

        let (_, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    private func flushPendingActivities() async {
        let queue = loadPendingActivities()
        guard !queue.isEmpty else { return }
        log.notice("Activity queue: flushing \(queue.count) item(s)")
        var remaining: [PendingActivity] = []
        var dropped = 0
        for item in queue {
            if await processActivity(item) { continue }
            var bumped = item
            bumped.failCount += 1
            if bumped.failCount >= Self.maxFailures {
                dropped += 1
                log.notice("Activity dropped after \(bumped.failCount) failures: \(item.type, privacy: .public)")
            } else {
                remaining.append(bumped)
            }
        }
        savePendingActivities(remaining)
    }

    private func loadPendingActivities() -> [PendingActivity] {
        guard let data = UserDefaults.standard.data(forKey: Self.pendingActivityKey),
              let queue = try? JSONDecoder().decode([PendingActivity].self, from: data) else {
            return []
        }
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
}
