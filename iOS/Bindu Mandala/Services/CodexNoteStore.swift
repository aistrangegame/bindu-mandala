import Foundation
import Observation

/// Wave 6 · his words sent to the Codex ("leave my own word"), kept on the
/// phone too. The Codex row is written through `AirtableService.writeCodexNote`
/// and its never-drop queue; this store keeps the page for the Book and the
/// Month Mirror. Every note is written to disk the moment it is set down.
@MainActor
@Observable
final class CodexNoteStore {

    static let shared = CodexNoteStore()
    static let fileName = "codex-notes"

    let directory: URL
    private(set) var archive = CodexNoteArchive()

    init(directory: URL = PracticeVault.defaultDirectory) {
        self.directory = directory
        archive = PracticeVault.read(CodexNoteArchive.self, named: Self.fileName, in: directory)
            ?? CodexNoteArchive()
    }

    var notes: [CodexNote] { archive.notes }

    /// Keep the note on the phone. Blank words with no voice keep nothing.
    @discardableResult
    func keep(body: String, spoken: CodexWrite.Spoken, origin: String?,
              voiceFile: String? = nil, at now: Date = .now) -> CodexNote? {
        let t = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return nil }
        let note = CodexNote(id: UUID(), body: t, at: now, spoken: spoken,
                             origin: origin, voiceFile: voiceFile)
        archive.notes.append(note)
        persist()
        return note
    }

    /// Keep it here, and hand it to the Codex. Fire-and-forget: a failed write
    /// waits in the queue for the next sync.
    @discardableResult
    func leave(body: String, spoken: CodexWrite.Spoken, origin: String?,
               voiceFile: String? = nil, at now: Date = .now) -> CodexNote? {
        guard let note = keep(body: body, spoken: spoken, origin: origin,
                              voiceFile: voiceFile, at: now) else { return nil }
        let pending = PendingCodexNote(body: note.body, at: note.at, spoken: spoken)
        Task { await AirtableService.shared.writeCodexNote(pending) }
        return note
    }

    private func persist() {
        try? PracticeVault.write(archive, named: Self.fileName, in: directory)
    }
}
