import Foundation
import os

private let vaultLog = Logger(subsystem: "com.ashrey.bindu-mandala", category: "practice-vault")

/// Where Wave 5's practice data lives: his Portrait strokes, his river letters,
/// his wagers. One JSON file each, in Application Support (backed up with the
/// phone, never purged by the system).
///
/// **Why files and not a new SwiftData entity.** `BinduSchema`'s header gives
/// the safe road for a new entity — a new version with a `.lightweight` stage —
/// and that road is safe for *one* branch at a time. Waves 2, 3 and 4 are being
/// built beside this one; if two of them each add a `BinduSchemaV4`, the merge
/// produces two different schemas under one version number, and the launch that
/// meets a store at the "other" V4 takes `PersistenceRecovery`'s preserve path:
/// the whole store moved aside, an empty one opened. That is the one outcome
/// the charter halts for. Files touch no `@Model`, no version and no migration,
/// so nothing any parallel wave does to the schema can reach them, and nothing
/// here can reach the schema.
///
/// **The rules every file here keeps:**
///   • Writes are atomic (`Data.write(options: .atomic)` — written beside and
///     renamed over), so a kill mid-write leaves the last good file whole.
///   • A file that cannot be decoded is never overwritten in place: it is
///     copied aside as `<name>.unreadable-<time>.json` first, so the only copy
///     of his words is never the one a fresh write replaces.
///   • Nothing here ever deletes a record. Things leave the view; they never
///     leave the file.
enum PracticeVault {

    /// `Application Support/Practice/`.
    static var defaultDirectory: URL {
        let fm = FileManager.default
        let base = (try? fm.url(for: .applicationSupportDirectory, in: .userDomainMask,
                                appropriateFor: nil, create: true))
            ?? fm.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory())
        return base.appendingPathComponent("Practice", isDirectory: true)
    }

    static func fileURL(named name: String, in directory: URL) -> URL {
        directory.appendingPathComponent(name + ".json")
    }

    /// The decoded file, or `nil` when there is none yet. A file that exists and
    /// cannot be read is copied aside before `nil` is returned.
    static func read<T: Decodable>(_ type: T.Type, named name: String, in directory: URL) -> T? {
        let url = fileURL(named: name, in: directory)
        guard let data = try? Data(contentsOf: url) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            let stamp = Int(Date().timeIntervalSince1970)
            let aside = directory.appendingPathComponent("\(name).unreadable-\(stamp).json")
            try? FileManager.default.copyItem(at: url, to: aside)
            vaultLog.error("\(name, privacy: .public) could not be read — copied aside to \(aside.lastPathComponent, privacy: .public)")
            return nil
        }
    }

    /// Write atomically, creating the directory on first use.
    static func write<T: Encodable>(_ value: T, named name: String, in directory: URL) throws {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(value)
        try data.write(to: fileURL(named: name, in: directory), options: [.atomic])
    }
}
