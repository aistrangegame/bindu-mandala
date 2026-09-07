import Foundation

/// The editor's view of one letter: the body as last saved, and the body as it
/// stands now. A draft is dirty only when the two differ — so opening a letter
/// (which sets both sides at once) is never an edit, and typing a change then
/// undoing it back to the saved body is not one either. Every autosave and the
/// save-on-dismiss go through `isDirty`, which is what keeps a merely-viewed
/// letter from writing anything, locally or to Airtable.
struct LetterDraft: Equatable {
    /// The body as last persisted — the baseline `isDirty` compares against.
    var saved: String
    /// The body as it currently stands in the editor.
    var text: String

    /// Opening a letter passes only `saved`; `text` starts equal to it.
    init(saved: String = "", text: String? = nil) {
        self.saved = saved
        self.text = text ?? saved
    }

    /// True iff the practitioner has changed the text since it was last saved.
    /// Exact comparison — a whitespace-only difference is still an edit.
    var isDirty: Bool { text != saved }

    /// `text` has been persisted; it becomes the new baseline.
    mutating func markSaved() { saved = text }
}
