import Foundation
import Observation

/// Wave 6 · Bindu memory (Codex C-1325, "Road Home Onboarding").
///
/// Before the journey he may enter the name his higher self gave — surfaced
/// with his eyes closed — and it is kept here, in his words, editable, used
/// only as he chooses (a letter may be addressed to it; the Book carries it on
/// its first page). Nothing else in the instrument reads it, and nothing ever
/// sends it anywhere but the one ledger (`Name Kept`, linked to the point).
///
/// Every name he ever kept stays in `history`: a new name is a new line, never
/// an overwrite, so changing it loses nothing.
struct BinduMemoryArchive: Codable, Equatable {
    struct Kept: Codable, Equatable, Identifiable {
        var id: UUID
        var name: String
        var keptAt: Date
        var ledgeredAt: Date?
    }
    var history: [Kept] = []
}

@MainActor
@Observable
final class BinduMemory {

    static let shared = BinduMemory()
    static let fileName = "bindu-memory"

    let directory: URL
    private(set) var archive = BinduMemoryArchive()

    init(directory: URL = PracticeVault.defaultDirectory) {
        self.directory = directory
        archive = PracticeVault.read(BinduMemoryArchive.self, named: Self.fileName, in: directory)
            ?? BinduMemoryArchive()
    }

    /// The name as he last kept it, or nil.
    var higherSelfName: String? {
        archive.history.max { $0.keptAt < $1.keptAt }?.name
    }

    /// Keep a name. Blank words keep nothing; the same name twice is one line.
    @discardableResult
    func keep(name: String, at now: Date = .now) -> BinduMemoryArchive.Kept? {
        let t = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty, t != higherSelfName else { return nil }
        let kept = BinduMemoryArchive.Kept(id: UUID(), name: t, keptAt: now, ledgeredAt: nil)
        archive.history.append(kept)
        persist()
        return kept
    }

    func unledgered() -> [BinduMemoryArchive.Kept] {
        archive.history.filter { $0.ledgeredAt == nil }
    }

    func markLedgered(_ id: UUID, at now: Date = .now) {
        guard let i = archive.history.firstIndex(where: { $0.id == id }) else { return }
        archive.history[i].ledgeredAt = now
        persist()
    }

    /// After a reinstall: the ledger's newest name comes home when this phone
    /// holds none (a name kept here is never replaced by the ledger's).
    func restore(name: String, keptAt: Date, now: Date = .now) {
        guard archive.history.isEmpty else { return }
        let t = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        archive.history.append(.init(id: UUID(), name: t, keptAt: keptAt, ledgeredAt: now))
        persist()
    }

    private func persist() {
        try? PracticeVault.write(archive, named: Self.fileName, in: directory)
    }
}
