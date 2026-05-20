import Foundation
import SwiftData
import os

private let log = Logger(subsystem: "com.ashrey.bindu-mandala", category: "airtable")

/// Fetches Śakti records from Airtable and reconciles into the local SwiftData store.
/// The local cache is always the source of truth at read time — Airtable is a quiet
/// background updater. The "I feel her" gesture never depends on a successful sync.
@MainActor
final class AirtableService {

    static let shared = AirtableService()

    /// Airtable base + table from CLAUDE_CODE_BRIEF.md.
    static let baseId  = "app248ZTWhYJlvQj2"
    static let tableId = "tblrRwXJD0uP8HU8G"

    /// Personal Access Token. Loaded from Info.plist (`AIRTABLE_PAT` key),
    /// which is fed by `Config.xcconfig` (gitignored).
    /// Returns nil when missing — in which case we silently stay on bootstrap data.
    var pat: String? {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "AIRTABLE_PAT") as? String,
              !raw.isEmpty,
              raw != "$(AIRTABLE_PAT)" else { return nil }
        return raw
    }

    private let session = URLSession(configuration: .ephemeral)

    /// Reconcile the SwiftData store from Airtable.
    /// Safe to call repeatedly; failures are silent.
    func sync(context: ModelContext) async {
        guard let token = pat else {
            log.notice("No PAT — skipping sync (local-only mode).")
            return
        }
        do {
            log.notice("Starting sync…")
            let records = try await fetchAllRecords(token: token)
            log.notice("Fetched \(records.count) records from Airtable.")
            try await MainActor.run {
                try reconcile(records: records, context: context)
            }
            log.notice("Reconciled successfully.")
        } catch {
            log.error("Sync failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - REST

    private struct ListResponse: Decodable {
        let records: [RecordRow]
        let offset: String?
    }

    private struct RecordRow: Decodable {
        let id: String
        let fields: Fields
    }

    private struct Fields: Decodable {
        let name: String?
        let sanskritName: String?
        let avarana: String?
        let quality: String?
        let qualityDescription: String?
        let clusterGroup: String?
        let esotericTattva: String?
        let somaticSignature: String?
        let bodilyLocation: String?
        let bija: String?
        let fieldConnection: String?
        let status: String?
        let notes: String?

        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case sanskritName = "Sanskrit Name"
            case avarana = "Avarana"
            case quality = "Quality"
            case qualityDescription = "Quality Description"
            case clusterGroup = "Cluster Group"
            case esotericTattva = "Esoteric Tattva"
            case somaticSignature = "Somatic Signature"
            case bodilyLocation = "Bodily Location"
            case bija = "Bija"
            case fieldConnection = "Field Connection"
            case status = "Status"
            case notes = "Notes"
        }
    }

    private func fetchAllRecords(token: String) async throws -> [RecordRow] {
        var all: [RecordRow] = []
        var offset: String? = nil
        repeat {
            var comps = URLComponents(string: "https://api.airtable.com/v0/\(Self.baseId)/\(Self.tableId)")!
            var items: [URLQueryItem] = [URLQueryItem(name: "pageSize", value: "100")]
            if let offset { items.append(URLQueryItem(name: "offset", value: offset)) }
            comps.queryItems = items
            var req = URLRequest(url: comps.url!)
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let (data, response) = try await session.data(for: req)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let page = try JSONDecoder().decode(ListResponse.self, from: data)
            all.append(contentsOf: page.records)
            offset = page.offset
        } while offset != nil
        return all
    }

    // MARK: - Reconcile

    private func reconcile(records: [RecordRow], context: ModelContext) throws {
        let existing = try context.fetch(FetchDescriptor<Shakti>())
        let byPosition = Dictionary(uniqueKeysWithValues: existing.map { ($0.position, $0) })

        for row in records {
            // Position parsed from Avarana field if present (e.g. "2 · 5"), else
            // resolved by matching Sanskrit name against bootstrap.
            guard let position = resolvePosition(row) else { continue }
            guard let shakti = byPosition[position] else { continue }

            shakti.airtableId = row.id
            if let v = row.fields.sanskritName, !v.isEmpty { shakti.name = v }
            if let v = row.fields.quality, !v.isEmpty { shakti.quality = v }
            if let v = row.fields.qualityDescription, !v.isEmpty { shakti.qualityDescription = v }
            if let v = row.fields.somaticSignature, !v.isEmpty { shakti.somatic = v }
            if let v = row.fields.bija, !v.isEmpty { shakti.bija = v }
            if let v = row.fields.bodilyLocation, !v.isEmpty { shakti.bodilyLocation = v }
            if let v = row.fields.esotericTattva, !v.isEmpty { shakti.tattva = v }
            if let v = row.fields.fieldConnection, !v.isEmpty { shakti.fieldName = v }
            // Status from Airtable is authoritative if user hasn't progressed past it,
            // but local advancement should never regress — take the more advanced of the two.
            if let s = row.fields.status,
               let remote = ShaktiStatus(rawValue: s.lowercased()) {
                let order: [ShaktiStatus] = [.mapped, .exploring, .active, .embodied]
                let localIdx = order.firstIndex(of: shakti.status) ?? 0
                let remoteIdx = order.firstIndex(of: remote) ?? 0
                shakti.status = order[max(localIdx, remoteIdx)]
            }
            shakti.lastSyncedAt = .now
        }
        try context.save()
    }

    private func resolvePosition(_ row: RecordRow) -> Int? {
        // Try Avarana like "2 · 5" → 5
        if let avarana = row.fields.avarana {
            let parts = avarana.split(whereSeparator: { !$0.isNumber })
            if parts.count >= 2, let p = Int(parts[1]) { return p }
            if let last = parts.last, let p = Int(last) { return p }
        }
        // Fallback: match by Sanskrit name against bootstrap
        if let name = row.fields.sanskritName {
            if let m = ShaktiBootstrap.all.first(where: { $0.name == name }) {
                return m.position
            }
        }
        return nil
    }
}
