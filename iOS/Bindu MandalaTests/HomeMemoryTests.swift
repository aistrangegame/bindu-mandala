import XCTest
import SwiftData
@testable import Bindu_Mandala

/// `homes-memory.js` is the contract and its numbers are law, so these tests
/// are the law written twice: every curve is asserted at the marks Design set,
/// not at values read back out of the Swift.
///
/// The three functions are pure over plain values, so most of this runs without
/// a container at all. The container appears only where the question is about
/// the store — that one room is one row, and that asking never writes.
@MainActor
final class HomeMemoryTests: XCTestCase {

    // MARK: - Compression: her ceremony softens, and never disappears

    func testCompressionSoftensOnReturnAndStopsAtTheFloor() {
        // First meeting: the whole ceremony, at full length.
        XCTAssertEqual(HomeMemory.compression(visits: 0), 1, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.compression(visits: 1), 0.68, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.compression(visits: 2), 0.4624, accuracy: 1e-12)

        // 0.68³ is 0.314432 — below the floor, so the floor is what is felt.
        XCTAssertEqual(HomeMemory.compression(visits: 3), HomeMemory.compressionFloor)
        XCTAssertEqual(HomeMemory.compression(visits: 4), HomeMemory.compressionFloor)

        // min(v, 4): a ninth visit is no faster than a fourth.
        XCTAssertEqual(HomeMemory.compression(visits: 9), HomeMemory.compressionFloor)
        XCTAssertEqual(HomeMemory.compression(visits: 9),
                       HomeMemory.compression(visits: 4),
                       accuracy: 1e-12)
    }

    func testCompressionNeverReachesZero() {
        // The ceremony is never skipped — only written faster. A zero here
        // would mean her name arriving with no writing at all.
        for v in [0, 1, 2, 3, 4, 5, 9, 40, 4_000, Int.max] {
            XCTAssertGreaterThanOrEqual(HomeMemory.compression(visits: v),
                                        HomeMemory.compressionFloor,
                                        "visit \(v) fell through the floor")
            XCTAssertGreaterThan(HomeMemory.compression(visits: v), 0)
        }
        // A count that could not have happened is still a whole ceremony.
        XCTAssertEqual(HomeMemory.compression(visits: -3), 1, accuracy: 1e-12)
    }

    func testCompressionIsMonotonicAndNeverGrows() {
        var previous = HomeMemory.compression(visits: 0)
        for v in 1...12 {
            let c = HomeMemory.compression(visits: v)
            XCTAssertLessThanOrEqual(c, previous, "the ceremony grew longer at visit \(v)")
            previous = c
        }
    }

    // MARK: - Head start: from dwell, never from visit count

    func testHeadStartOpensFromAccumulatedDwell() {
        XCTAssertEqual(HomeMemory.headStart(dwell: 0), 0, accuracy: 1e-12)

        // Under twelve seconds a glance is not a relationship: the room opens
        // at its beginning, however many times it was glanced at.
        XCTAssertEqual(HomeMemory.headStart(dwell: 11), 0, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.headStart(dwell: 11.999), 0, accuracy: 1e-12)

        // At twelve exactly the door moves — 12 × 0.55.
        XCTAssertEqual(HomeMemory.headStart(dwell: 12), 6.6, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.headStart(dwell: 100), 55, accuracy: 1e-12)
    }

    func testHeadStartIsCappedBeforeTheHoldEnds() {
        // 500 × 0.55 = 275, which would carry past the second adaptation.
        XCTAssertEqual(HomeMemory.headStart(dwell: 500), 221, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.headStart(dwell: HomeMemory.dwellCap), 221, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.headStartCap, 221, accuracy: 1e-12)

        // The cap lands six seconds short of the hold's end, so even the most
        // known room still crosses the first adaptation inside the visit.
        XCTAssertLessThan(HomeMemory.headStartCap, HomeMemory.holdEnd)
        XCTAssertGreaterThan(HomeMemory.headStartCap, HomeMemory.firstAdaptation)

        // Just under and just over the cap's crossing (221 ÷ 0.55 = 401.81…).
        XCTAssertEqual(HomeMemory.headStart(dwell: 400), 220, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.headStart(dwell: 402), 221, accuracy: 1e-12)
    }

    // MARK: - The fifth: the ninth world, a very long stay, or a long bond

    func testFifthIsNotGrantedEarlyInAnOrdinaryRoom() {
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 3, elapsed: 30, dwell: 0), 0, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 3, elapsed: 30, dwell: 120), 0, accuracy: 1e-12)
        // Even at the hold's end it has not begun — it begins *after* it.
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 3, elapsed: HomeMemory.holdEnd, dwell: 0),
                       0, accuracy: 1e-12)
    }

    func testTheNinthWorldGrantsTheFifthImmediately() {
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 9, elapsed: 0, dwell: 0), 1, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 9, elapsed: 0.001, dwell: 0), 1, accuracy: 1e-12)
    }

    func testTheFifthIsEarnedByAVeryLongStay() {
        // The chamber clock past the hold, full at the second adaptation's end.
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 5, elapsed: 287, dwell: 0), 0.5, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 5,
                                              elapsed: HomeMemory.secondAdaptationEnd,
                                              dwell: 0),
                       1, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 5, elapsed: 900, dwell: 0), 1, accuracy: 1e-12)
    }

    func testTheFifthIsEarnedByALongRelationship() {
        // Accumulated dwell past three minutes, full five minutes after that —
        // reachable on a visit that has barely begun.
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 1, elapsed: 0, dwell: 180), 0, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 1, elapsed: 0, dwell: 330), 0.5, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 1, elapsed: 0, dwell: 480), 1, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 1, elapsed: 0, dwell: HomeMemory.dwellCap),
                       1, accuracy: 1e-12)
    }

    func testTheFifthTakesWhicheverWayIsFurtherAlong() {
        // Two halves do not add up — the larger is what is granted.
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 4, elapsed: 287, dwell: 330), 0.5, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 4, elapsed: 287, dwell: 480), 1, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.grantsFifth(ring: 4, elapsed: 347, dwell: 0), 1, accuracy: 1e-12)
        // Never outside 0…1, whatever it is handed.
        for elapsed in [-500.0, 0, 100, 227, 347, 10_000] {
            for dwell in [-500.0, 0, 180, 480, 4_000] {
                let f = HomeMemory.grantsFifth(ring: 6, elapsed: elapsed, dwell: dwell)
                XCTAssertGreaterThanOrEqual(f, 0)
                XCTAssertLessThanOrEqual(f, 1)
            }
        }
    }

    // MARK: - Recording a visit

    func testRecordCountsTheVisitAndKeepsTheDwell() {
        let m = HomeMemory(khadgamalaPosition: 44)
        XCTAssertFalse(m.known, "a room never left is not yet known")

        m.record(dwell: 90, at: Date(timeIntervalSince1970: 1_000))

        XCTAssertTrue(m.known)
        XCTAssertEqual(m.visits, 1)
        XCTAssertEqual(m.accumulatedDwell, 90, accuracy: 1e-12)
        XCTAssertEqual(m.lastDwell, 90, accuracy: 1e-12)
        XCTAssertEqual(m.longestDwell, 90, accuracy: 1e-12)
        XCTAssertEqual(m.lastVisit, Date(timeIntervalSince1970: 1_000))
    }

    func testDwellAccumulatesAndStopsAtTheCap() {
        let m = HomeMemory(khadgamalaPosition: 7)

        m.record(dwell: 1_500)
        XCTAssertEqual(m.accumulatedDwell, 1_500, accuracy: 1e-12)
        m.record(dwell: 1_500)
        XCTAssertEqual(m.accumulatedDwell, 3_000, accuracy: 1e-12)

        // Past the ceiling, and staying there — the visit still counts.
        m.record(dwell: 1_500)
        XCTAssertEqual(m.accumulatedDwell, HomeMemory.dwellCap, accuracy: 1e-12)
        m.record(dwell: 9_999)
        XCTAssertEqual(m.accumulatedDwell, HomeMemory.dwellCap, accuracy: 1e-12)
        XCTAssertEqual(m.visits, 4)

        // And the head start stays inside the cap however long the relationship.
        XCTAssertEqual(m.headStart, HomeMemory.headStartCap, accuracy: 1e-12)
    }

    func testANegativeDwellAddsNothing() {
        let m = HomeMemory(khadgamalaPosition: 29)
        m.record(dwell: 100)
        m.record(dwell: -400)

        XCTAssertEqual(m.visits, 2, "the visit happened")
        XCTAssertEqual(m.accumulatedDwell, 100, accuracy: 1e-12, "and took nothing away")
        XCTAssertEqual(m.lastDwell, 0, accuracy: 1e-12)
        XCTAssertEqual(m.longestDwell, 100, accuracy: 1e-12)
    }

    func testTheFourExtrasFollowSeveralVisits() {
        let m = HomeMemory(khadgamalaPosition: 102)
        let t1 = Date(timeIntervalSince1970: 1_000)
        let t2 = Date(timeIntervalSince1970: 2_000)
        let t3 = Date(timeIntervalSince1970: 3_000)
        let t4 = Date(timeIntervalSince1970: 4_000)

        // One: 100 s, opening at the beginning — past the first adaptation.
        m.record(dwell: 100, at: t1)
        XCTAssertEqual(m.longestDwell, 100, accuracy: 1e-12)
        XCTAssertEqual(m.lastDwell, 100, accuracy: 1e-12)
        XCTAssertEqual(m.lastVisit, t1)
        XCTAssertEqual(m.deepestAdaptation, 1)

        // Two: a short stay. The longest holds; the last one follows.
        m.record(dwell: 30, at: t2)
        XCTAssertEqual(m.longestDwell, 100, accuracy: 1e-12, "the long stay is not forgotten")
        XCTAssertEqual(m.lastDwell, 30, accuracy: 1e-12)
        XCTAssertEqual(m.lastVisit, t2)
        XCTAssertEqual(m.deepestAdaptation, 1)

        // Three: 200 s on a clock that opened at 71.5 — past the hold's end,
        // which a first visit of the same length could never have reached.
        m.record(dwell: 200, at: t3)
        XCTAssertEqual(m.longestDwell, 200, accuracy: 1e-12)
        XCTAssertEqual(m.lastDwell, 200, accuracy: 1e-12)
        XCTAssertEqual(m.lastVisit, t3)
        XCTAssertEqual(m.deepestAdaptation, 2, "the second adaptation, reached through relationship")

        // Four: a glance. The high-water mark is a mark, not a reading.
        m.record(dwell: 5, at: t4)
        XCTAssertEqual(m.longestDwell, 200, accuracy: 1e-12)
        XCTAssertEqual(m.lastDwell, 5, accuracy: 1e-12)
        XCTAssertEqual(m.lastVisit, t4)
        XCTAssertEqual(m.deepestAdaptation, 2, "never falls back")

        XCTAssertEqual(m.visits, 4)
        XCTAssertEqual(m.accumulatedDwell, 335, accuracy: 1e-12)
    }

    func testTheSecondAdaptationIsOutOfReachOnAFirstVisit() {
        // 226 seconds on a first visit: the clock opened at zero, so the second
        // adaptation is one second away and stays away.
        let first = HomeMemory(khadgamalaPosition: 3)
        first.record(dwell: 226)
        XCTAssertEqual(first.deepestAdaptation, 1)

        // The same 226 seconds, in a room already stood in for ten minutes.
        let known = HomeMemory(khadgamalaPosition: 4, accumulatedDwell: 600)
        known.record(dwell: 226)
        XCTAssertEqual(known.deepestAdaptation, 2)
    }

    func testTheMarksAreDesignsMarks() {
        XCTAssertEqual(HomeMemory.firstAdaptation, 62, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.holdEnd, 227, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.secondAdaptationEnd, 347, accuracy: 1e-12)
        XCTAssertEqual(HomeMemory.dwellCap, 4_000, accuracy: 1e-12)

        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: 0), 0)
        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: 61.999), 0)
        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: 62), 1)
        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: 226.999), 1)
        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: 227), 2)
        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: 10_000), 2)
    }

    // MARK: - The store: one room, one row, and asking writes nothing

    private func makeContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: HomeMemory.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    func testTheUniqueKeyHoldsAcrossARoundTrip() throws {
        let context = try makeContext()
        let store = HomeMemoryStore(context: context)

        store.record(khadgamalaPosition: 44, dwell: 100, at: Date(timeIntervalSince1970: 1_000))
        store.record(khadgamalaPosition: 44, dwell: 200, at: Date(timeIntervalSince1970: 2_000))
        store.record(khadgamalaPosition: 7, dwell: 12)

        // Two rooms, two rows — and the second visit to 44 landed on the first
        // row, not beside it.
        let all = try context.fetch(FetchDescriptor<HomeMemory>())
        XCTAssertEqual(all.count, 2)
        XCTAssertEqual(all.filter { $0.khadgamalaPosition == 44 }.count, 1,
                       "one room is one row — the unique key must hold")

        let her = try XCTUnwrap(store.existingMemory(for: 44))
        XCTAssertEqual(her.visits, 2)
        XCTAssertEqual(her.accumulatedDwell, 300, accuracy: 1e-12)
        XCTAssertEqual(her.longestDwell, 200, accuracy: 1e-12)
        XCTAssertEqual(her.lastDwell, 200, accuracy: 1e-12)
        XCTAssertEqual(her.lastVisit, Date(timeIntervalSince1970: 2_000))
        // The second visit's clock opened at 55 — 200 seconds later it stood
        // at 255, past the hold's end a first visit could not have reached.
        XCTAssertEqual(her.deepestAdaptation, 2)

        // And every value comes back off a fresh read of the same store.
        let reread = try XCTUnwrap(HomeMemoryStore(context: context).existingMemory(for: 7))
        XCTAssertEqual(reread.visits, 1)
        XCTAssertEqual(reread.accumulatedDwell, 12, accuracy: 1e-12)
    }

    func testAskingWhatARoomRemembersNeverWritesARow() throws {
        let context = try makeContext()
        let store = HomeMemoryStore(context: context)

        XCTAssertNil(store.existingMemory(for: 61))
        _ = store.memory(for: 61)
        XCTAssertEqual(store.compression(for: 61), 1, accuracy: 1e-12)
        XCTAssertEqual(store.headStart(for: 61), 0, accuracy: 1e-12)
        XCTAssertEqual(store.grantsFifth(for: 61, ring: 5, elapsed: 287), 0.5, accuracy: 1e-12)
        try context.save()

        XCTAssertEqual(try context.fetch(FetchDescriptor<HomeMemory>()).count, 0,
                       "a room merely asked about must leave no trace")
    }

    func testTheStoreReadsThroughToTheSameCurves() throws {
        let context = try makeContext()
        let store = HomeMemoryStore(context: context)
        store.record(khadgamalaPosition: 29, dwell: 400)

        XCTAssertEqual(store.compression(for: 29),
                       HomeMemory.compression(visits: 1), accuracy: 1e-12)
        XCTAssertEqual(store.headStart(for: 29),
                       HomeMemory.headStart(dwell: 400), accuracy: 1e-12)
        XCTAssertEqual(store.grantsFifth(for: 29, ring: 2, elapsed: 0),
                       HomeMemory.grantsFifth(ring: 2, elapsed: 0, dwell: 400), accuracy: 1e-12)
        XCTAssertEqual(store.grantsFifth(for: 29, ring: 9, elapsed: 0), 1, accuracy: 1e-12)
    }

    func testHomeMemoryIsInTheVersionTheAppOpens() {
        let listed = BinduSchemaV2.models.contains { ObjectIdentifier($0) == ObjectIdentifier(HomeMemory.self) }
        XCTAssertTrue(listed, "the model must be in the schema the app opens its store with")
        XCTAssertFalse(BinduSchemaV1.models.contains { ObjectIdentifier($0) == ObjectIdentifier(HomeMemory.self) },
                       "V1 stores on disk never held this table")
    }

    // MARK: - The once-per-visit guard (Ruling 11's silence, wired in 3.6)

    func testSilenceIsClaimedOncePerVisitAndOnlyPastTheFirstAdaptation() {
        var visit = HomeVisit(khadgamalaPosition: 70)

        XCTAssertFalse(visit.claimSilence(at: 0))
        XCTAssertFalse(visit.claimSilence(at: 61.999), "not yet — and nothing consumed")
        XCTAssertFalse(visit.silenceHeld)

        XCTAssertTrue(visit.claimSilence(at: HomeMemory.firstAdaptation), "the first tick past the mark")
        XCTAssertTrue(visit.silenceHeld)

        // Every later tick of the same visit answers no, so the dwelling may
        // ask on all of them and still write exactly one entry.
        XCTAssertFalse(visit.claimSilence(at: 63))
        XCTAssertFalse(visit.claimSilence(at: 400))
    }

    func testANewVisitMayHoldItsOwnSilence() {
        var first = HomeVisit(khadgamalaPosition: 70)
        XCTAssertTrue(first.claimSilence(at: 100))

        var second = HomeVisit(khadgamalaPosition: 70)
        XCTAssertFalse(second.silenceHeld, "a visit is a value — leaving ends it")
        XCTAssertTrue(second.claimSilence(at: 100))
    }

    func testTheVisitsChamberClockOpensAtTheHeadStart() {
        let m = HomeMemory(khadgamalaPosition: 44, accumulatedDwell: 600)
        let visit = HomeVisit(memory: m)

        XCTAssertEqual(visit.khadgamalaPosition, 44)
        XCTAssertEqual(visit.headStart, HomeMemory.headStart(dwell: 600), accuracy: 1e-12)
        XCTAssertEqual(visit.chamberClock(atDwell: 0), 221, accuracy: 1e-12)
        XCTAssertEqual(visit.chamberClock(atDwell: 10), 231, accuracy: 1e-12)
        XCTAssertEqual(visit.chamberClock(atDwell: -10), 221, accuracy: 1e-12)

        // A room never stood in opens at its beginning.
        let fresh = HomeVisit(memory: HomeMemory(khadgamalaPosition: 1))
        XCTAssertEqual(fresh.chamberClock(atDwell: 30), 30, accuracy: 1e-12)
    }
}
