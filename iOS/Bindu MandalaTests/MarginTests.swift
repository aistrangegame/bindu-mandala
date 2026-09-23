import XCTest
import SwiftData
@testable import Bindu_Mandala

// MARK: - The margin
//
// His words are the thing being protected here, so every check below is about
// one of four ways they could be lost — the composer, the store, the ledger, or
// the law — and about the one way they must never be *shown*: as a quantity.

@MainActor
final class MarginNoteStoreTests: XCTestCase {

    private func freshContext() throws -> ModelContext {
        let schema = BinduSchema.makeLatest()
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return ModelContext(try ModelContainer(for: schema, configurations: config))
    }

    /// The letter's hardest-won property, inherited: a composer that is opened
    /// and abandoned leaves the store exactly as it found it.
    func testOpeningTheComposerWritesNothing() throws {
        let ctx = try freshContext()
        let store = MarginNoteStore(context: ctx)
        _ = store.blank()
        XCTAssertTrue(store.all().isEmpty,
                      "a note he never typed into must not exist — a blank row would stand in his list")
    }

    /// One note, one row, however many autosaves.
    func testAutosavingTwiceLeavesOneNote() throws {
        let ctx = try freshContext()
        let store = MarginNoteStore(context: ctx)
        let note = store.blank()
        XCTAssertTrue(store.save(note, body: "the rite"))
        XCTAssertTrue(store.save(note, body: "the rite reads oddly on the SE"))
        let all = store.all()
        XCTAssertEqual(all.map(\.body), ["the rite reads oddly on the SE"],
                       "an autosave must update his note, never start a second one")
    }

    /// Air is not a note — not in the list, and never in the ledger.
    func testABlankNoteIsNeverSaved() throws {
        let ctx = try freshContext()
        let store = MarginNoteStore(context: ctx)
        XCTAssertFalse(store.save(store.blank(), body: "   \n  "))
        XCTAssertTrue(store.all().isEmpty)
    }

    /// A note already in his list is not erased by an edit that empties it.
    func testEmptyingASavedNoteLeavesItStanding() throws {
        let ctx = try freshContext()
        let store = MarginNoteStore(context: ctx)
        let note = store.blank()
        XCTAssertTrue(store.save(note, body: "the way out is hard to find"))
        XCTAssertFalse(store.save(note, body: ""))
        XCTAssertEqual(store.all().map(\.body), ["the way out is hard to find"])
    }

    /// Newest first, which is the only order the list has.
    func testTheListIsNewestFirst() throws {
        let ctx = try freshContext()
        let t0 = Date(timeIntervalSince1970: 1_000_000)
        for (i, words) in ["first", "second", "third"].enumerated() {
            ctx.insert(MarginNote(body: words, createdAt: t0.addingTimeInterval(Double(i) * 60)))
        }
        try ctx.save()
        XCTAssertEqual(MarginNoteStore(context: ctx).all().map(\.body),
                       ["third", "second", "first"])
    }

    // MARK: The queue of record is the note itself

    /// A note whose POST never landed stays in the queue **forever**, oldest
    /// first — it is not a UserDefaults item that retires after three failures.
    func testAnUnledgeredNoteStaysInTheQueue() throws {
        let ctx = try freshContext()
        let t0 = Date(timeIntervalSince1970: 2_000_000)
        let sent = MarginNote(body: "already up", createdAt: t0, ledgeredAt: .now)
        let older = MarginNote(body: "written on the train", createdAt: t0.addingTimeInterval(10))
        let newer = MarginNote(body: "written at the door", createdAt: t0.addingTimeInterval(20))
        for n in [sent, newer, older] { ctx.insert(n) }
        try ctx.save()

        let waiting = MarginNoteStore(context: ctx).awaitingLedger(limit: 20)
        XCTAssertEqual(waiting.map(\.body), ["written on the train", "written at the door"],
                       "only the un-ledgered notes wait, and they wait in the order he wrote them")
    }

    /// The sweep runs on scene-phase `.active` — which is exactly when he comes
    /// back to a composer he left open. It must not post half a sentence and
    /// stamp it, because the stamp is what stops the finished note being sent.
    func testTheSweepSkipsTheNoteHeIsStillTyping() {
        let open = MarginNote(body: "the descent stat")
        let done = MarginNote(body: "the descent stations are unreachable on the SE")
        let air  = MarginNote(body: "  ")
        let sweepable = MarginNoteStore.sweepable([open, done, air], openInComposer: open.noteId)
        XCTAssertEqual(sweepable.map(\.body), ["the descent stations are unreachable on the SE"])
    }

    /// With sync off — the unit-test host, `SYNC_OFF`, a missing token — a note
    /// is not dropped, marked, or mutated in any way. It simply waits.
    func testASuppressedWriteLeavesTheNoteIntactAndWaiting() async throws {
        let ctx = try freshContext()
        let note = MarginNote(body: "the hamburger is off-screen in the Well")
        ctx.insert(note)
        try ctx.save()

        await AirtableService.shared.recordNote(note, context: ctx)

        XCTAssertNil(note.ledgeredAt,
                     "a write that did not happen must never stamp the note as ledgered")
        XCTAssertEqual(note.body, "the hamburger is off-screen in the Well")
        XCTAssertEqual(MarginNoteStore(context: ctx).awaitingLedger(limit: 20).count, 1,
                       "it is still waiting, and the next sync will find it")
    }

    /// The whole sweep, driven, with sync suppressed: nothing is lost and
    /// nothing is stamped.
    func testTheSweepLosesNothingWithoutAToken() async throws {
        let ctx = try freshContext()
        for words in ["one", "two"] { ctx.insert(MarginNote(body: words)) }
        try ctx.save()
        await AirtableService.shared.flushUnledgeredNotes(context: ctx)
        XCTAssertEqual(MarginNoteStore(context: ctx).awaitingLedger(limit: 20).count, 2)
    }
}

// MARK: - The day a note carries

final class MarginDateTests: XCTestCase {

    private var cal: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "America/New_York")!
        c.locale = Locale(identifier: "en_US_POSIX")
        return c
    }

    private func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date {
        cal.date(from: DateComponents(year: y, month: m, day: d, hour: h))!
    }

    func testTodayAndYesterdayAreWords() {
        let now = date(2026, 9, 23)
        XCTAssertEqual(MarginDate.written(date(2026, 9, 23, 8), now: now, calendar: cal), "today")
        XCTAssertEqual(MarginDate.written(date(2026, 9, 22, 8), now: now, calendar: cal), "yesterday")
        XCTAssertEqual(MarginDate.spoken(date(2026, 9, 23, 8), now: now, calendar: cal), "Today")
        XCTAssertEqual(MarginDate.spoken(date(2026, 9, 22, 8), now: now, calendar: cal), "Yesterday")
    }

    func testTheRecentPastIsItsWeekday() {
        let now = date(2026, 9, 23)
        XCTAssertEqual(MarginDate.written(date(2026, 9, 20), now: now, calendar: cal), "sunday")
        XCTAssertEqual(MarginDate.spoken(date(2026, 9, 20), now: now, calendar: cal), "Sunday")
    }

    func testAnOlderNoteIsAMonthAndADay() {
        let now = date(2026, 9, 23)
        XCTAssertEqual(MarginDate.written(date(2026, 8, 21), now: now, calendar: cal), "Aug 21")
        XCTAssertEqual(MarginDate.spoken(date(2026, 8, 21), now: now, calendar: cal),
                       "August the twenty-first")
    }

    /// **The spoken surface of the margin has no numeral in it, on any day of
    /// any year.** §4.4's finding applied to a date: the ink may say "Aug 21",
    /// the voice says the day as a word, through the same ordinal table the
    /// Mandala already speaks a seat with.
    func testNoDayOfAnyYearIsEverSpokenAsADigit() {
        let now = date(2026, 12, 31)
        var day = date(2025, 12, 31)
        var checked = 0
        while day <= now {
            let said = MarginDate.spoken(day, now: now, calendar: cal)
            XCTAssertFalse(said.contains(where: \.isNumber),
                           "\(said) — a numeral reached the spoken surface")
            XCTAssertFalse(said.isEmpty)
            day = cal.date(byAdding: .day, value: 1, to: day)!
            checked += 1
        }
        XCTAssertGreaterThan(checked, 360, "the sweep read almost nothing")
    }
}
