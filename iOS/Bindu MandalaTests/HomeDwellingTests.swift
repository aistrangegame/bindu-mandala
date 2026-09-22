import XCTest
import SwiftData
@testable import Bindu_Mandala

// MARK: - Phase 3.6 · the silence wire, and the two ledger events that survive
//
// Three pieces shipped with zero call sites — ``SilenceDwell``, ``HomeVisit``'s
// `claimSilence(at:)` and the milestone writers — and this suite is about the
// thing that now joins them, ``HomeDwelling``.
//
// What is held here:
//
//   1. the silence is claimed **exactly once per visit**, and only at or past
//      the first adaptation; a new visit may claim again
//   2. the first dwelling is asked once, when a second adaptation is reached,
//      and on the mark ``HomeMemory`` itself calls the second adaptation
//   3. the dwell writes a **local `RecognitionEntry`** with `gesture: .silence`
//      and **one ledger row**, and nothing whatever to the Mandala table
//   4. it is **invisible**: the dwelling has nothing a view can read, and the
//      one screen that holds one only starts and stops it
//   5. `Full Circle` fires on the 102nd first-felt and never on the 101st
//   6. neither milestone can be written twice — **including across a reinstall**,
//      which is the guard the letter ledger did not have until §0.6
//   7. `Deepest Ring Reached` does not exist. It was struck, and the reasoning
//      is in `DECISIONS.md`: `Ring Crossed` already fires once per new-deepest
//      ring, so it would have duplicated it exactly
@MainActor
final class HomeDwellingTests: XCTestCase {

    // MARK: fixtures

    /// A dwelling whose marks only count, so the guards can be read without a
    /// store, a token or a network.
    private final class Tally {
        var silences: [TimeInterval] = []
        var dwellings: [TimeInterval] = []
        var marks: HomeDwelling.Marks {
            HomeDwelling.Marks(silenceHeld: { [self] in silences.append($0) },
                               firstDwelling: { [self] in dwellings.append($0) })
        }
    }

    private func shakti(_ kp: Int, recordId: String? = "recBindu") -> Shakti {
        Shakti(position: 1, name: "Test Śakti", shortName: "Test", phonetic: "test",
               quality: "quality", qualityDescription: "", somatic: "", somaticPoetry: "",
               bija: "", bodilyLocation: "heart", tattva: "Ākāśa",
               recognitionPhrase: "", cluster: .inner, status: .mapped,
               khadgamalaPosition: kp,
               ringNumber: KhadgamalaMap.ringNumber(forKhadgamala: kp),
               airtableRecordId: recordId)
    }

    private func context() throws -> ModelContext {
        let container = try ModelContainer(
            for: RecognitionEntry.self, HomeMemory.self, Shakti.self, ShaktiLetter.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        return ModelContext(container)
    }

    private func row(_ type: String) -> ActivityLedger.Row {
        ActivityLedger.Row(id: "rec\(type)", fields: .init(activityType: type))
    }

    // MARK: - 1 · once per visit, and only past the first adaptation

    /// Ruling 11, as the wire now enforces it. The guard is ``HomeVisit``'s and
    /// it was already tested on its own; what is new is that something **asks**
    /// it, and that the asking is idempotent — the dwelling wakes at a mark and
    /// may wake early, late, or twice.
    func testTheSilenceIsClaimedOncePerVisitAndOnlyPastTheFirstAdaptation() {
        let tally = Tally()
        let dwelling = HomeDwelling(visit: HomeVisit(khadgamalaPosition: 102),
                                    marks: tally.marks)

        dwelling.observe(chamberTime: 0, dwell: 0)
        dwelling.observe(chamberTime: HomeMemory.firstAdaptation - 0.001, dwell: 61.9)
        XCTAssertTrue(tally.silences.isEmpty,
                      "a silence was recorded before the first adaptation")

        dwelling.observe(chamberTime: HomeMemory.firstAdaptation, dwell: 62)
        XCTAssertEqual(tally.silences.count, 1, "the first tick past the mark holds the silence")
        XCTAssertEqual(tally.silences.first ?? -1, 62, accuracy: 1e-9,
                       "the row carries the dwell it was held for")

        // Every later tick, including one long past the second adaptation.
        for t in [HomeMemory.firstAdaptation, 63, HomeMemory.holdEnd,
                  HomeMemory.secondAdaptationEnd, 4_000] {
            dwelling.observe(chamberTime: t, dwell: t)
        }
        XCTAssertEqual(tally.silences.count, 1,
                       "the silence was held \(tally.silences.count) times in one visit")

        // A **new visit** may hold one again. A visit is a value; leaving the
        // room and coming back is a new one.
        let second = Tally()
        let again = HomeDwelling(visit: HomeVisit(khadgamalaPosition: 102), marks: second.marks)
        again.observe(chamberTime: HomeMemory.firstAdaptation, dwell: 70)
        XCTAssertEqual(second.silences.count, 1,
                       "a second visit could not hold its own silence")
    }

    /// A dwell that ends before the mark records nothing. *A dwell held* past the
    /// first adaptation is the whole of R11, and leaving is how it is not held.
    func testLeavingBeforeTheMarkRecordsNothing() {
        let tally = Tally()
        let clock = RoomClock(opening: 0)
        let dwelling = HomeDwelling(visit: HomeVisit(khadgamalaPosition: 44), marks: tally.marks)
        dwelling.begin(clock: clock)
        dwelling.end()
        XCTAssertTrue(tally.silences.isEmpty && tally.dwellings.isEmpty,
                      "a stay that ended at once still recorded something")
    }

    /// The chamber clock is the ruling (``HomeDwelling``'s header), and
    /// ``HomeVisit`` carries the head start for it: a returning walker's room
    /// opens where her accumulated dwell has earned, and the marks it has already
    /// carried her past are marks she has reached.
    func testTheChamberClockCarriesTheHeadStart() {
        let visit = HomeVisit(khadgamalaPosition: 44, headStart: 40)
        XCTAssertEqual(visit.chamberClock(atDwell: 30), 70, accuracy: 1e-9)

        let tally = Tally()
        let dwelling = HomeDwelling(visit: visit, marks: tally.marks)
        dwelling.observe(chamberTime: visit.chamberClock(atDwell: 10), dwell: 10)
        XCTAssertTrue(tally.silences.isEmpty, "50 seconds on the chamber clock is not past the mark")
        dwelling.observe(chamberTime: visit.chamberClock(atDwell: 30), dwell: 30)
        XCTAssertEqual(tally.silences.count, 1, "70 seconds on the chamber clock is")
    }

    // MARK: - 2 · the first dwelling

    /// The milestone's mark is ``HomeMemory/adaptation(atChamberTime:)``'s own,
    /// read rather than chosen, so the room and the ledger cannot disagree about
    /// what a second adaptation is.
    func testTheFirstDwellingIsAskedWhenTheSecondAdaptationIsReached() {
        XCTAssertEqual(HomeDwelling.dwellingAt, HomeMemory.holdEnd)
        XCTAssertEqual(HomeDwelling.silenceAt, HomeMemory.firstAdaptation)
        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: HomeDwelling.dwellingAt), 2)
        XCTAssertEqual(HomeMemory.adaptation(atChamberTime: HomeDwelling.dwellingAt - 0.001), 1)

        let tally = Tally()
        let dwelling = HomeDwelling(visit: HomeVisit(khadgamalaPosition: 7), marks: tally.marks)
        dwelling.observe(chamberTime: HomeMemory.holdEnd - 0.001, dwell: 226)
        XCTAssertTrue(tally.dwellings.isEmpty, "the first dwelling was asked before the second adaptation")

        dwelling.observe(chamberTime: HomeMemory.holdEnd, dwell: 227)
        XCTAssertEqual(tally.dwellings.count, 1)
        XCTAssertEqual(tally.dwellings.first ?? -1, HomeMemory.holdEnd, accuracy: 1e-9,
                       "the row carries the chamber clock it was reached on")

        for t in [HomeMemory.holdEnd, 300, HomeMemory.secondAdaptationEnd] {
            dwelling.observe(chamberTime: t, dwell: t)
        }
        XCTAssertEqual(tally.dwellings.count, 1,
                       "one stay asked for the first dwelling \(tally.dwellings.count) times")
        XCTAssertTrue(dwelling.reachedTheSecond)
    }

    // MARK: - 3 · a local entry, a ledger row, and nothing to the Mandala table

    /// R17 at the one new write site. The dwell writes **locally first** — the
    /// read-time source of truth — and then one row in App Activity. The Mandala
    /// table holds Śaktis and Āvaraṇas and never an event.
    func testTheDwellWritesALocalEntryAndNothingToTheMandalaTable() throws {
        let context = try context()
        let her = shakti(102)
        context.insert(her)

        SilenceDwell.record(shakti: her, durationSec: 212, context: context)

        let entries = try context.fetch(FetchDescriptor<RecognitionEntry>())
        XCTAssertEqual(entries.count, 1, "the dwell wrote \(entries.count) local entries")
        let entry = try XCTUnwrap(entries.first)
        XCTAssertEqual(entry.gesture, .silence, "a silence is not a recognition")
        XCTAssertEqual(entry.khadgamalaPosition, 102)
        XCTAssertEqual(entry.ringNumber, 9)

        // Nothing but recognition entries entered the store: no HomeMemory row
        // was invented, and no Śakti was created.
        XCTAssertTrue(try context.fetch(FetchDescriptor<HomeMemory>()).isEmpty,
                      "the dwell wrote a room's memory. That is the dwelling's own business, on leaving")

        // The ledger row it queues addresses the ledger's table and links her
        // **Śakti row** — a link is not a write to that table, and there is no
        // `Row Type` anywhere in it.
        let payload = ActivityLedger.silence(shaktiRecordId: "recBindu", name: her.name,
                                             durationSec: 212, at: entry.timestamp)
        XCTAssertEqual(payload.type, ActivityLedger.ActivityType.silenceHeld)
        let fields = ActivityLedger.fields(for: payload)
        XCTAssertEqual(fields[ActivityLedger.Field.sourceApp] as? String, "Mandala")
        XCTAssertEqual(fields[ActivityLedger.Field.gestureSource] as? String,
                       ActivityLedger.GestureSource.silence)
        XCTAssertEqual(fields[ActivityLedger.Field.durationSec] as? Double, 212)
        XCTAssertNil(fields["Row Type"], "the Mandala table's retired event discriminator is back")
        XCTAssertNil(fields[ActivityLedger.Field.notes], "a silence carries no words")

        // …and the two files that make up the wire name no table but the
        // ledger's. Read off disk, so a future write cannot be added quietly.
        for name in ["SilenceDwell.swift", "HomeDwelling.swift"] {
            let file = try XCTUnwrap(LawSource.production(name), "\(name) is not in the shipping tree")
            XCTAssertFalse(file.text.contains("Self.tableId"),
                           "\(name) names the Mandala table")
            XCTAssertFalse(file.text.contains("URLRequest"),
                           "\(name) makes its own request. Every write goes through the ledger's one POST")
        }
    }

    // MARK: - 4 · invisible

    /// Ruling 11's *never displayed* and law 2's *no count*, held by the shape of
    /// the types rather than by care.
    ///
    /// The dwelling imports no SwiftUI and vends nothing a view could bind to;
    /// the one screen that carries one touches it in exactly two places, and both
    /// of them are lifecycle.
    func testTheDwellingHasNothingToShow() throws {
        let dwelling = try XCTUnwrap(LawSource.production("HomeDwelling.swift"))
        XCTAssertFalse(dwelling.text.contains("import SwiftUI"),
                       "the dwelling can see SwiftUI. It has nothing to draw")
        for shown in ["@Published", "ObservableObject", "@Observable", "some View"] {
            XCTAssertFalse(dwelling.text.contains(shown),
                           "the dwelling vends `\(shown)` — a screen could read the silence off it")
        }

        let rite = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let uses = rite.text.components(separatedBy: "dwelling?.").dropFirst()
        XCTAssertEqual(uses.count, 2,
                       "the rite reaches for the dwelling \(uses.count) times, not twice")
        for use in uses {
            XCTAssertTrue(use.hasPrefix("begin(clock:") || use.hasPrefix("end()"),
                          "the rite asks the dwelling something other than to begin or to end: \(use.prefix(40))")
        }

        // Nothing walker-facing anywhere in the ledger's milestone words carries
        // a digit: *every seat* is a fact about the khaḍgamālā, not a score.
        let words = [ActivityLedger.fullCircle(shaktiRecordId: "r", name: "Lalitā", at: .now),
                     ActivityLedger.firstDwelling(shaktiRecordId: "r", name: "Lalitā",
                                                  chamberTime: 227, at: .now)]
        for item in words {
            XCTAssertNil(item.name.rangeOfCharacter(from: .decimalDigits),
                         "a milestone's name counts something: \(item.name)")
            XCTAssertNil(item.detail.rangeOfCharacter(from: .decimalDigits),
                         "a milestone's detail counts something: \(item.detail)")
        }
    }

    // MARK: - 5 · Full Circle, on the 102nd first-felt

    /// The circle closes when every seat of the khaḍgamālā has been felt — and
    /// the count that decides it is asked of the **ledger**, which is R17 working
    /// as intended: a reinstall cannot reset it, and it never reaches the walker.
    func testFullCircleClosesOnTheHundredAndSecondAndNotTheHundredAndFirst() {
        XCTAssertEqual(ActivityLedger.fullCircleAt, KhadgamalaMap.total)
        XCTAssertEqual(ActivityLedger.fullCircleAt, 102)
        XCTAssertFalse(ActivityLedger.isFullCircle(felt: 0))
        XCTAssertFalse(ActivityLedger.isFullCircle(felt: 101))
        XCTAssertTrue(ActivityLedger.isFullCircle(felt: 102))
        // A base that somehow held more than the khaḍgamālā does must still
        // close: a milestone that can be missed by a stray row is worse than one
        // that fires a row late.
        XCTAssertTrue(ActivityLedger.isFullCircle(felt: 103))

        let payload = ActivityLedger.fullCircle(shaktiRecordId: "recLast", name: "Lalitā", at: .now)
        XCTAssertEqual(payload.type, "Full Circle")
        XCTAssertEqual(payload.linkRecordId, "recLast")
        let fields = ActivityLedger.fields(for: payload)
        XCTAssertEqual(fields[ActivityLedger.Field.linkToMandala] as? [String], ["recLast"])
        XCTAssertNotNil(fields[ActivityLedger.Field.feltAt])
    }

    // MARK: - 6 · once ever, and a reinstall cannot undo it

    /// **The guard the letter ledger did not have.** A local flag is per-install:
    /// a reinstall or a second device would log the milestone again, which is
    /// exactly what happened to `Letter Written` until §0.6's server-derived
    /// reconcile. So both milestones read the ledger's own view, and this is that
    /// read, exercised as a reinstall.
    func testNeitherMilestoneCanBeWrittenTwiceAcrossAReinstall() {
        let key = "ledgeredMilestones"
        let saved = UserDefaults.standard.stringArray(forKey: key)
        defer {
            if let saved { UserDefaults.standard.set(saved, forKey: key) }
            else { UserDefaults.standard.removeObject(forKey: key) }
        }
        UserDefaults.standard.removeObject(forKey: key)

        for milestone in ActivityLedger.Milestone.allCases {
            XCTAssertFalse(AirtableService.hasLedgeredMilestone(milestone))
            AirtableService.markMilestoneLedgered(milestone)
            AirtableService.markMilestoneLedgered(milestone)   // idempotent
            XCTAssertTrue(AirtableService.hasLedgeredMilestone(milestone))
        }
        XCTAssertEqual(UserDefaults.standard.stringArray(forKey: key)?.count, 2,
                       "the local set does not hold one entry per milestone")

        // …and now the app is reinstalled: the local set is gone.
        UserDefaults.standard.removeObject(forKey: key)
        for milestone in ActivityLedger.Milestone.allCases {
            XCTAssertFalse(AirtableService.hasLedgeredMilestone(milestone),
                           "a reinstall did not clear the local set — this test proves nothing")
        }

        // The ledger still holds both rows, so the reconcile marks them again and
        // nothing is written a second time.
        let onServer = [row(ActivityLedger.ActivityType.fullCircle),
                        row(ActivityLedger.ActivityType.firstDwelling),
                        row(ActivityLedger.ActivityType.shaktiRecognized),
                        row(ActivityLedger.ActivityType.ringCrossed),
                        row("Some Other App's Event")]
        let held = ActivityLedger.ledgered(in: onServer)
        XCTAssertEqual(held, Set(ActivityLedger.Milestone.allCases))
        for milestone in held { AirtableService.markMilestoneLedgered(milestone) }
        for milestone in ActivityLedger.Milestone.allCases {
            XCTAssertTrue(AirtableService.hasLedgeredMilestone(milestone),
                          "\(milestone.rawValue) would be written a second time after a reinstall")
        }

        // A ledger that holds neither marks neither — the guard does not fire on
        // any row that happens to be there.
        XCTAssertTrue(ActivityLedger.ledgered(in: [row(ActivityLedger.ActivityType.silenceHeld),
                                                   row(ActivityLedger.ActivityType.letterWritten)]).isEmpty)
        XCTAssertEqual(ActivityLedger.ledgered(in: [row(ActivityLedger.ActivityType.fullCircle)]),
                       [.fullCircle],
                       "one milestone on the server marked the other one too")
    }

    /// **A server that could not be asked is not a server that said yes.**
    ///
    /// The salvaged first cut of this wire remembered the milestone on a failed
    /// read as well as on a successful one. Nothing ever clears the local set —
    /// `reconcileLedgeredMilestones` only adds to it — so one timed-out read
    /// suppressed a once-ever row on that install permanently. The read still
    /// fails closed, because a duplicated milestone cannot be taken back; closed
    /// now means **write nothing and remember nothing**.
    func testAMilestoneReadThatFailedIsNotAMilestoneThatWasWritten() {
        XCTAssertEqual(AirtableService.decision(for: .present).write, false)
        XCTAssertEqual(AirtableService.decision(for: .present).remember, true,
                       "a milestone the server already holds is never written again")

        XCTAssertEqual(AirtableService.decision(for: .absent).write, true)
        XCTAssertEqual(AirtableService.decision(for: .absent).remember, true)

        XCTAssertEqual(AirtableService.decision(for: .unknown).write, false,
                       "an unanswered question about a once-ever row is answered by not writing it")
        XCTAssertEqual(AirtableService.decision(for: .unknown).remember, false,
                       """
                       a read that failed marked the milestone locally, and nothing ever clears \
                       that set — the row would never be written on this install again.
                       """)
    }

    /// The read both guards share is narrowed to this instrument's own rows and
    /// to the two types — it must not be a scan of the whole ledger, which every
    /// Bindu app writes to.
    func testTheMilestoneReadAsksForThisInstrumentsTwoRowsOnly() {
        let formula = ActivityLedger.ledgeredMilestones
        XCTAssertTrue(formula.contains("{Source App}='Mandala'"),
                      "the milestone read is not narrowed to this instrument: \(formula)")
        XCTAssertTrue(formula.contains("Full Circle") && formula.contains("First Dwelling"))
        XCTAssertFalse(formula.contains("Shakti Recognized"))
        XCTAssertEqual(ActivityLedger.ofType("Letter Written"),
                       "{Activity Type}='Letter Written'")
    }

    // MARK: - 7 · the third event was struck

    /// The brief named three. `Deepest Ring Reached` is **dropped** — `Ring
    /// Crossed` already fires once per new-deepest ring, so it would duplicate
    /// it exactly — and it is recorded in `DECISIONS.md` under the charter's §4
    /// table. This holds the drop: the vocabulary must not grow it back.
    func testDeepestRingReachedDoesNotExist() throws {
        // Asked of **code and not of prose.** The name is allowed to appear in a
        // comment — `ActivityLedger`'s own header says why the event was struck,
        // and `crossing(ring:feltAt:)` has said since build 36 that it subsumes
        // it; a note that survives is how the next pass finds out instead of
        // re-deriving the ruling. What may not exist is the string itself, in
        // anything that runs.
        for file in LawSource.production {
            for line in file.text.components(separatedBy: .newlines) {
                let code = line.components(separatedBy: "//").first ?? line
                XCTAssertFalse(code.contains("Deepest Ring Reached"),
                               "\(file.path) has brought back the event that was struck: \(code)")
            }
        }
        XCTAssertEqual(ActivityLedger.Milestone.allCases.count, 2)
        XCTAssertEqual(Set(ActivityLedger.Milestone.allCases.map(\.activityType)),
                       ["Full Circle", "First Dwelling"])

        // …and `Ring Crossed` is still the one that carries a new-deepest ring,
        // which is why the third event had nothing left to say.
        let crossing = ActivityLedger.crossing(ring: 9, feltAt: .now)
        XCTAssertEqual(crossing.type, ActivityLedger.ActivityType.ringCrossed)
        XCTAssertEqual(crossing.descentRing, 9)
    }
}
