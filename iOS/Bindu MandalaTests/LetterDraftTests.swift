import XCTest
@testable import Bindu_Mandala

/// `LetterDraft.isDirty` is the single gate on every letter save. Opening a
/// letter must never count as an edit; only a real change to the text may.
final class LetterDraftTests: XCTestCase {

    func testLoadWithoutEditIsNotDirty() {
        let d = LetterDraft(saved: "You are the pull toward what I love.")
        XCTAssertFalse(d.isDirty, "merely opening a letter must not mark it dirty")
        XCTAssertEqual(d.text, d.saved)
    }

    func testEmptyLetterLoadedIsNotDirty() {
        let d = LetterDraft(saved: "")
        XCTAssertFalse(d.isDirty)
        XCTAssertTrue(d.text.isEmpty)
    }

    func testEditMarksDirty() {
        var d = LetterDraft(saved: "You are the pull")
        d.text = "You are the pull toward what I love."
        XCTAssertTrue(d.isDirty)
    }

    func testEditBackToOriginalIsNotDirty() {
        var d = LetterDraft(saved: "You are the pull")
        d.text = "You are the pull."
        XCTAssertTrue(d.isDirty)
        d.text = "You are the pull"
        XCTAssertFalse(d.isDirty, "undoing the edit restores the clean state")
    }

    func testMarkSavedClearsDirty() {
        var d = LetterDraft(saved: "")
        d.text = "I feel you when the day turns."
        XCTAssertTrue(d.isDirty)
        d.markSaved()
        XCTAssertFalse(d.isDirty)
        XCTAssertEqual(d.saved, "I feel you when the day turns.", "the saved baseline moves to the new text")
    }

    func testMarkSavedMovesTheBaseline() {
        var d = LetterDraft(saved: "first")
        d.text = "second"
        d.markSaved()
        d.text = "first"
        XCTAssertTrue(d.isDirty, "returning to the old baseline is an edit against the new one")
    }

    func testWhitespaceOnlyDifferenceIsAnEdit() {
        var d = LetterDraft(saved: "She is listening.")
        d.text = "She is listening. "
        XCTAssertTrue(d.isDirty, "a trailing space is an edit")
        d.text = "She is listening.\n"
        XCTAssertTrue(d.isDirty, "a trailing newline is an edit")
        d.text = " She is listening."
        XCTAssertTrue(d.isDirty, "a leading space is an edit")
    }

    func testDefaultInitIsEmptyAndClean() {
        let d = LetterDraft()
        XCTAssertEqual(d.saved, "")
        XCTAssertEqual(d.text, "")
        XCTAssertFalse(d.isDirty)
    }
}
