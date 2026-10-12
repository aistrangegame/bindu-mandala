import XCTest
@testable import Bindu_Mandala

/// Wave 5 · the Well as a river, and the Wager. Sealing with no peek, opening
/// on the day the real moon brings, words kept across launches, and one ledger
/// row per act.
@MainActor
final class TheRiverTests: XCTestCase {

    private var directories: [URL] = []

    override func tearDown() {
        for d in directories { try? FileManager.default.removeItem(at: d) }
        directories = []
        super.tearDown()
    }

    private func freshDirectory() -> URL {
        let d = FileManager.default.temporaryDirectory
            .appendingPathComponent("the-river-\(UUID().uuidString)", isDirectory: true)
        directories.append(d)
        return d
    }

    private func utc(_ y: Int, _ mo: Int, _ d: Int, _ h: Int, _ mi: Int) -> Date {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0)!
        return c.date(from: DateComponents(year: y, month: mo, day: d, hour: h, minute: mi))!
    }

    // MARK: Sealed with no peek

    func testASealedLetterCannotBeOpenedOrReadBeforeItsDay() throws {
        let store = CorrespondenceStore(directory: freshDirectory())
        let written = utc(2026, 10, 12, 14, 0)
        let letter = try XCTUnwrap(store.seal(body: "I will meet you at the full moon.", to: 31,
                                              opening: .purnima, at: written))
        XCTAssertEqual(letter.direction, .forward)
        XCTAssertTrue(letter.isSealed(at: written))
        XCTAssertFalse(letter.isReadable(at: written), "there is no peek")
        XCTAssertFalse(letter.isDue(at: written))
        XCTAssertTrue(store.hasSealed(at: written), "the Portrait's eye is closed")

        let early = letter.addressedTo.addingTimeInterval(-60)
        XCTAssertFalse(store.open(letter.id, at: early), "a minute early is still sealed")

        let onTheDay = letter.addressedTo.addingTimeInterval(60)
        XCTAssertTrue(letter.isDue(at: onTheDay))
        XCTAssertTrue(store.open(letter.id, at: onTheDay))
        let opened = try XCTUnwrap(store.letters.first)
        XCTAssertTrue(opened.isReadable(at: onTheDay))
        XCTAssertFalse(opened.isDue(at: onTheDay))
        XCTAssertFalse(store.hasSealed(at: onTheDay), "and the eye opens again")
    }

    func testBlankWordsSealNothing() {
        let store = CorrespondenceStore(directory: freshDirectory())
        XCTAssertNil(store.seal(body: "  \n ", to: 31, opening: .purnima))
        XCTAssertNil(store.sendBack(body: "", to: 31, moment: .now))
        XCTAssertNil(store.seal(body: "words", to: 0, opening: .purnima), "position is identity, 1–102")
        XCTAssertTrue(store.letters.isEmpty)
    }

    // MARK: Her day, on the real moon

    func testTheFullMoonOpeningIsTheStartOfPurnima() {
        let now = utc(2026, 10, 12, 14, 0)
        let opens = RiverLetter.openingInstant(.purnima, khadgamalaPosition: 31, after: now)
        XCTAssertGreaterThan(opens, now)
        XCTAssertEqual(Ephemeris.elongation(opens), 168, accuracy: 0.05, "Pūrṇimā begins at 168°")
        XCTAssertEqual(Panchanga.tithi(at: opens.addingTimeInterval(60)), 15)
        // The full moon of 2026-10-26 04:12 UT [USNO] closes that tithi; it opens
        // about a day before.
        XCTAssertLessThan(opens, utc(2026, 10, 26, 4, 12))
        XCTAssertGreaterThan(opens, utc(2026, 10, 24, 12, 0))
    }

    func testTheDarkMoonAndTheReturningTithi() {
        let now = utc(2026, 10, 12, 14, 0)
        let dark = RiverLetter.openingInstant(.amavasya, khadgamalaPosition: 31, after: now)
        XCTAssertEqual(Panchanga.tithi(at: dark.addingTimeInterval(60)), 30)
        let back = RiverLetter.openingInstant(.tithiReturns, khadgamalaPosition: 31, after: now)
        XCTAssertEqual(Panchanga.tithi(at: back.addingTimeInterval(60)), Panchanga.tithi(at: now))
        XCTAssertGreaterThan(back.timeIntervalSince(now), 20 * 86_400, "one lunar month on, not today")
    }

    func testHerDayIsTheNextDaySheGreetsHim() {
        let now = utc(2026, 10, 12, 14, 0)
        let kp = 44
        let opens = RiverLetter.openingInstant(.herDay, khadgamalaPosition: kp, after: now)
        XCTAssertGreaterThan(opens, now)
        XCTAssertEqual(DailyEnergyService.todaysPosition(for: opens.addingTimeInterval(3_600)), kp)
    }

    // MARK: Back to a moment

    func testALetterSentBackIsReadableAtOnceAndNeverInTheFuture() throws {
        let store = CorrespondenceStore(directory: freshDirectory())
        let now = utc(2026, 10, 12, 14, 0)
        let past = try XCTUnwrap(store.sendBack(body: "That morning, you were there.", to: 29,
                                                moment: utc(2019, 3, 1, 7, 0), at: now))
        XCTAssertTrue(past.isReadable(at: now))
        XCTAssertFalse(past.isSealed(at: now))
        XCTAssertEqual(past.addressedTo, utc(2019, 3, 1, 7, 0))
        let future = try XCTUnwrap(store.sendBack(body: "x", to: 29, moment: utc(2030, 1, 1, 0, 0), at: now))
        XCTAssertEqual(future.addressedTo, now, "back is never forward")
        XCTAssertTrue(store.unledgeredOpenings().isEmpty, "a letter sent back is not 'opened'")
    }

    // MARK: Kept

    func testTheRiverAndTheDraftSurviveARelaunch() throws {
        let d = freshDirectory()
        let store = CorrespondenceStore(directory: d)
        let draft = RiverDraft(khadgamalaPosition: 40, direction: .forward,
                               body: "half a sentence", opening: .herDay, addressedTo: .now)
        store.saveDraft(draft)
        XCTAssertEqual(CorrespondenceStore(directory: d).draft, draft, "a dismissed sheet loses nothing")

        let letter = try XCTUnwrap(store.seal(body: "whole now", to: 40, opening: .amavasya))
        XCTAssertNil(store.draft, "sealing it clears the draft")
        let again = CorrespondenceStore(directory: d)
        XCTAssertEqual(again.letters, [letter])
        XCTAssertNil(again.draft)
        XCTAssertEqual(again.unledgeredSeals().map(\.id), [letter.id])
        again.markSealLedgered(letter.id)
        XCTAssertTrue(CorrespondenceStore(directory: d).unledgeredSeals().isEmpty)
    }

    func testOldPagesYellowByRealTime() {
        let written = utc(2026, 1, 1, 0, 0)
        let l = RiverLetter(id: UUID(), khadgamalaPosition: 1, direction: .back, body: "b",
                            writtenAt: written, addressedTo: written, opening: nil, openedAt: written,
                            sealLedgeredAt: nil, openLedgeredAt: nil)
        XCTAssertEqual(l.patina(at: written), 0, accuracy: 1e-9)
        let month = l.patina(at: written.addingTimeInterval(30 * 86_400))
        let year = l.patina(at: written.addingTimeInterval(365 * 86_400))
        XCTAssertGreaterThan(month, 0)
        XCTAssertGreaterThan(year, month)
        XCTAssertLessThan(year, 1)
    }

    // MARK: The Wager

    func testAWatchIsAnsweredFromTheEvening() throws {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        func local(_ d: Int, _ h: Int) -> Date {
            cal.date(from: DateComponents(year: 2026, month: 10, day: d, hour: h))!
        }
        let store = WagerStore(directory: freshDirectory())
        let w = store.place(for: 33, at: local(12, 8))
        XCTAssertEqual(store.place(for: 33, at: local(12, 9)).id, w.id, "one open watch for her")
        XCTAssertFalse(WagerStore.canResolve(w, at: local(12, 12), calendar: cal), "not at noon")
        XCTAssertTrue(WagerStore.canResolve(w, at: local(12, 18), calendar: cal), "the evening")
        XCTAssertTrue(WagerStore.canResolve(w, at: local(13, 7), calendar: cal), "or any later day")

        let resolved = try XCTUnwrap(store.resolve(w.id, appeared: false, at: local(12, 19)))
        XCTAssertEqual(resolved.appeared, false)
        XCTAssertNil(store.openWager(for: 33))
        XCTAssertNil(store.resolve(w.id, appeared: true), "answered once")
        XCTAssertEqual(store.unledgered().map(\.id), [w.id])
        XCTAssertNotEqual(store.place(for: 33, at: local(13, 8)).id, w.id, "a new day, a new watch")
    }

    func testTheWagerSurvivesARelaunch() {
        let d = freshDirectory()
        let store = WagerStore(directory: d)
        let w = store.place(for: 50)
        XCTAssertEqual(WagerStore(directory: d).openWager(for: 50)?.id, w.id)
    }

    // MARK: One ledger row per act

    func testTheRiverAndTheWagerSpeakToTheLedgerInItsOwnWords() {
        let at = utc(2026, 10, 12, 14, 0)
        let sealed = ActivityLedger.letterSealed(shaktiRecordId: "recS", name: "Kāmākarṣiṇī", forward: true,
                                                 opensOn: "the full moon · Oct 24, 2026",
                                                 body: "my own words", at: at)
        XCTAssertEqual(sealed.type, "Letter Sealed")
        XCTAssertEqual(sealed.linkRecordId, "recS", "linked, so a retried POST is one row")
        XCTAssertEqual(sealed.notes, "my own words", "his words, and only his, in Notes")
        XCTAssertEqual(sealed.name, "A letter to Kāmākarṣiṇī — sealed")

        let back = ActivityLedger.letterSealed(shaktiRecordId: "recS", name: "", forward: false,
                                               opensOn: nil, body: "b", at: at)
        XCTAssertEqual(back.name, "A letter to a Śakti — sent back")

        let opened = ActivityLedger.letterOpened(shaktiRecordId: "recS", name: "Kāmākarṣiṇī", at: at)
        XCTAssertEqual(opened.type, "Letter Opened")
        XCTAssertNil(opened.notes, "the words went in once, with the seal")

        let drawn = ActivityLedger.portraitDrawn(ring: 2, at: at)
        XCTAssertEqual(drawn.type, "Portrait Drawn")
        XCTAssertEqual(drawn.linkRecordId, AirtableService.avaranaRecordId(forRing: 2))

        let watched = ActivityLedger.wagerResolved(shaktiRecordId: "recS", name: "Smṛti",
                                                   appeared: true, at: at)
        XCTAssertEqual(watched.type, "Wager Resolved")
        XCTAssertTrue(watched.detail.hasPrefix("She appeared"))
        let open = ActivityLedger.wagerResolved(shaktiRecordId: "recS", name: "Smṛti",
                                                appeared: false, at: at)
        XCTAssertTrue(open.detail.hasPrefix("Watched for"), "not this time is not a failure")

        // Nothing composed here measures him: no digit in a name or detail
        // that the instrument wrote (the opening day is his letter's, quoted).
        for row in [back, opened, drawn, watched, open] {
            XCTAssertNil(row.name.rangeOfCharacter(from: .decimalDigits), row.name)
            XCTAssertNil(row.detail.rangeOfCharacter(from: .decimalDigits), row.detail)
        }
        for row in [sealed, back, opened, drawn, watched, open] {
            XCTAssertTrue(ActivityLedger.fields(for: row).keys.contains(ActivityLedger.Field.activityType))
        }
    }
}
