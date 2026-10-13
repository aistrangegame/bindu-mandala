import Foundation
import os

private let snapshotLog = Logger(subsystem: "com.ashrey.bindu-mandala", category: "snapshot")

// MARK: - Upgrade U0 · the dated snapshot as the app's source (DEBUG walk only)
//
// `verification.md` V18 / §4: the walk runs against a **dated, read-only,
// verbatim export** of the Mandala table instead of Airtable, and every ledger
// write goes to an in-memory mock — never a live POST or PATCH.
//
// Launch argument `SNAPSHOT=<date>` (e.g. `SNAPSHOT=2026-10-13`) turns it on.
// The files are read from, in order:
//   1. `SNAPSHOT_DIR` in the launch environment — an absolute path to the
//      dated folder. The UI tests pass `…/iOS/Bindu MandalaTests/Snapshot/<date>`
//      from their own `#filePath`; the simulator reads the host's file system.
//   2. `Snapshot/<date>/` inside the app bundle, if a DEBUG build ever copies
//      it there (nothing does in U0 — the snapshot stays out of the app).
//
// While a snapshot is active `AppRuntime.syncDisabled` is true, so every
// network path in `AirtableService` returns before it builds a request; the
// write entry points hand their row to `SnapshotLedger` first. A Release build
// never honours the argument.

enum SnapshotSource {

    static let argumentPrefix = "SNAPSHOT="
    static let directoryEnvironmentKey = "SNAPSHOT_DIR"

    /// The snapshot's date, from `SNAPSHOT=<date>`; nil when no snapshot is asked
    /// for, and always nil in Release.
    static let date: String? = {
        #if DEBUG
        guard let arg = ProcessInfo.processInfo.arguments.last(where: { $0.hasPrefix(argumentPrefix) })
        else { return nil }
        let d = String(arg.dropFirst(argumentPrefix.count))
        return d.isEmpty ? nil : d
        #else
        return nil
        #endif
    }()

    /// True when the app must read the snapshot and write nothing live.
    static var isActive: Bool { date != nil }

    /// The dated folder holding `mandala.json` (and `map.json`,
    /// `bindu-field.json`, `manifest.json`), or nil when it cannot be found.
    static func directory(environment: [String: String] = ProcessInfo.processInfo.environment,
                          bundle: Bundle = .main) -> URL? {
        guard let date else { return nil }
        let fm = FileManager.default
        if let raw = environment[directoryEnvironmentKey], !raw.isEmpty {
            let url = URL(fileURLWithPath: raw, isDirectory: true)
            if fm.fileExists(atPath: url.appendingPathComponent("mandala.json").path) { return url }
            snapshotLog.error("SNAPSHOT_DIR has no mandala.json: \(raw, privacy: .public)")
        }
        if let bundled = bundle.resourceURL?
            .appendingPathComponent("Snapshot", isDirectory: true)
            .appendingPathComponent(date, isDirectory: true),
           fm.fileExists(atPath: bundled.appendingPathComponent("mandala.json").path) {
            return bundled
        }
        snapshotLog.error("Snapshot \(date, privacy: .public) not found — the app stays on local data")
        return nil
    }

    /// The Mandala table's rows of one `Row Type` (`Shakti`, `Avarana`, `Nitya`),
    /// re-shaped into the page the Airtable API returns with
    /// `returnFieldsByFieldId=true` — `{"records":[{"id","fields":{fieldId: value}}]}`
    /// — so `AirtableService` decodes it with its own row models.
    ///
    /// The export writes a select as `{id, name, color}` and a link as
    /// `[{id, name}]`; the API writes a select as its name and a link as an
    /// array of record ids. `normalised` turns the one into the other and
    /// changes nothing else: every string stays byte for byte.
    static func mandalaPage(rowType: String, in directory: URL) throws -> Data {
        let data = try Data(contentsOf: directory.appendingPathComponent("mandala.json"))
        guard let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let records = root["records"] as? [[String: Any]] else {
            throw CocoaError(.fileReadCorruptFile)
        }
        var out: [[String: Any]] = []
        for record in records {
            guard let id = record["id"] as? String,
                  let fields = record["fields"] as? [String: Any] else { continue }
            let typed = normalised(fields[rowTypeFieldId] ?? NSNull()) as? String
            guard typed == rowType else { continue }
            var flat: [String: Any] = [:]
            for (key, value) in fields { flat[key] = normalised(value) }
            out.append(["id": id, "fields": flat])
        }
        return try JSONSerialization.data(withJSONObject: ["records": out])
    }

    /// `Row Type` on the Mandala table (the field `AirtableService.sync` filters on).
    static let rowTypeFieldId = "fldw33m8YqrINlvrN"

    /// Export cell → API cell: a select (`{id: sel…, name, color}`) becomes its
    /// name; a linked record (`{id: rec…, name}`) becomes its id; arrays are
    /// mapped; everything else is returned untouched.
    static func normalised(_ value: Any) -> Any {
        if let array = value as? [Any] { return array.map(normalised) }
        if let dict = value as? [String: Any] {
            let id = dict["id"] as? String ?? ""
            if let name = dict["name"] as? String {
                if dict["color"] != nil || id.hasPrefix("sel") { return name }
                if id.hasPrefix("rec") { return id }
            }
            return dict
        }
        return value
    }
}

// MARK: - The in-memory ledger the snapshot writes to

/// Every write the app would have made while a snapshot is active, held in
/// memory for the walk to read — never sent anywhere. Forgotten on relaunch.
@MainActor
final class SnapshotLedger {

    static let shared = SnapshotLedger()

    /// One intended write: which entry point, which Airtable table it would have
    /// reached, and the row (an activity row in full where there is one).
    struct Write: Equatable {
        let entry: String
        let table: String
        let summary: String
        let activity: PendingActivity?
        let at: Date
    }

    private(set) var writes: [Write] = []

    /// The ledger rows among them (App Activity), in order.
    var activities: [PendingActivity] { writes.compactMap(\.activity) }

    /// Hand a write to the mock when a snapshot is active. Returns true when the
    /// caller must stop (the snapshot took it), false when no snapshot is active.
    @discardableResult
    func divert(entry: String, table: String, summary: String,
                activity: PendingActivity? = nil, at: Date = .now) -> Bool {
        guard SnapshotSource.isActive else { return false }
        writes.append(Write(entry: entry, table: table, summary: summary, activity: activity, at: at))
        snapshotLog.notice("mock write · \(entry, privacy: .public) → \(table, privacy: .public)")
        return true
    }

    func reset() { writes.removeAll() }
}
