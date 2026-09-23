import XCTest
@testable import Bindu_Mandala

// MARK: - EphemeralStoreTests — the harness's own store, and the law it may not touch
//
// `FeltRegisterSnapshots` reads ten screens against a committed geometry. Every
// one of those baselines was recorded on a store with nothing in it, and two of
// the screens *write*: the shipped `BinduMandalaUITests` records a recognition,
// and so does the ceremony screen at the end of the snapshot roster. Read off
// the practitioner's own on-disk store, the Field then says "felt here" beside a
// Śakti who has one, and the suite reports a composition change that is really
// just the container remembering the last run.
//
// The answer is `EPHEMERAL_STORE`: a UI-test launch gets a fresh in-memory store
// and leaves the disk alone. The suite becomes order-independent and re-runnable
// without erasing a simulator between passes.
//
// Charter §2 law 8 is why this file exists. A launch argument that could reach a
// practitioner's store would be a way to lose his practice, so two things have to
// be true at once and both are asserted here:
//
//  1. It is **DEBUG-only**. The argument does not exist in a shipped build.
//  2. It is **non-destructive**. The ephemeral path returns before anything on
//     disk is opened, preserved or removed — it does not delete, and it does not
//     call `preserveExistingStore`.

final class EphemeralStoreTests: XCTestCase {

    private func source(_ name: String) -> SourceFile? { LawSource.production(name) }

    func testTheEphemeralStoreExistsOnlyInADebugBuild() {
        guard let f = source("BinduMandalaApp.swift") else {
            return XCTFail("BinduMandalaApp is gone")
        }
        guard let decl = Rx.first(#"usesEphemeralStore: Bool = \{[\s\S]*?\n    \}\(\)"#, f.text) else {
            return XCTFail("`AppRuntime.usesEphemeralStore` is gone — the UI suite's store flag")
        }
        XCTAssertTrue(decl.contains("#if DEBUG"),
                      "EPHEMERAL_STORE is no longer behind #if DEBUG: a shipped build could be "
                      + "launched onto an empty store (charter §2, law 8)")
        XCTAssertTrue(decl.contains("#else\n        return false"),
                      "the release branch of EPHEMERAL_STORE must be an unconditional false")
        // The string itself appears exactly once, inside that declaration, so no
        // second reader can grow a different meaning for the same argument.
        XCTAssertEqual(Rx.all(#"EPHEMERAL_STORE"#, String(f.lexed.masked)).count, 0,
                       "EPHEMERAL_STORE appears in code outside its own string literal")
        XCTAssertEqual(Rx.all(#""EPHEMERAL_STORE""#, f.text).count, 1,
                       "EPHEMERAL_STORE is read in more than one place")
    }

    func testTheEphemeralPathNeverTouchesTheStoreOnDisk() {
        guard let f = source("PersistenceRecovery.swift") else {
            return XCTFail("PersistenceRecovery is gone")
        }
        guard let body = Rx.first(#"static func makeContainer\([\s\S]*?\n    \}"#, f.text) else {
            return XCTFail("`makeContainer` is gone")
        }
        guard let branch = Rx.first(#"if AppRuntime\.usesEphemeralStore \{[\s\S]*?\n        \}"#, body) else {
            return XCTFail("`makeContainer` no longer honours the ephemeral store")
        }
        XCTAssertTrue(branch.contains("isStoredInMemoryOnly: true"),
                      "the ephemeral branch opens something other than an in-memory store")
        for forbidden in ["preserveExistingStore", "removeItem", "moveItem", "trashItem"] {
            XCTAssertFalse(branch.contains(forbidden),
                           "the ephemeral branch reaches the disk via \(forbidden) — law 8 says a "
                           + "debug argument may never stand between him and his practice")
        }
        // It has to come *first*: after the on-disk open, a corrupt store would
        // already have been preserved aside before the flag was ever read.
        let ephemeralAt = body.range(of: "AppRuntime.usesEphemeralStore")?.lowerBound
        let diskAt = body.range(of: "migrationPlan: BinduMigrationPlan.self")?.lowerBound
        guard let ephemeralAt, let diskAt else { return XCTFail("makeContainer changed shape") }
        XCTAssertLessThan(ephemeralAt, diskAt,
                          "the ephemeral branch is read after the on-disk store is opened")
    }

    /// And it is off unless somebody asks for it. The unit host passes no such
    /// argument, so this is the real runtime value, not a re-reading of source.
    func testItIsOffByDefault() {
        XCTAssertFalse(AppRuntime.usesEphemeralStore,
                       "the ephemeral store is on in a process that never asked for it")
    }
}

// MARK: - The pinned energy, and the day the Field stopped depending on
//
// `FeltRegisterSnapshots.testEveryTouchedScreenHoldsItsComposition` went red on
// the ~16 days in 102 when today's Śakti falls in Ring 2, and the app was right
// every time. A `SYNC_OFF` launch seeds only the sixteen Ring-2 Karṣiṇīs; the
// Field marks today's seat; so on those sixteen days she is in the roster and
// marked, and on the other 86 she is absent and nothing is marked. The baseline
// was recorded on one of the 86. Proven rather than argued: an unchanged tree was
// run either side of the 06:00 practice-day boundary and failed byte-identically
// after it.
//
// Two things fix it and both are asserted here, because a fix nothing holds is a
// fix that comes undone. `TheHundredTwoView` was the ONE screen reaching past the
// override to the calendar; and the LAST `ENERGY_POS` now wins, so the Field can
// append its own without disturbing the base pin the Rite needs.

final class PinnedEnergyTests: XCTestCase {

    /// **The Field asks the override first.** If this reverts to calling the
    /// calendar directly, the composition lock becomes a dice roll again.
    func testTheFieldHonoursThePinnedEnergyPosition() throws {
        let f = try XCTUnwrap(LawSource.production("TheHundredTwoView.swift"),
                              "TheHundredTwoView.swift is not in the production corpus")
        let line = try XCTUnwrap(
            f.text.split(separator: "\n").first { $0.contains("private var todayPos") },
            "TheHundredTwoView no longer declares todayPos — this test has lost its subject")

        XCTAssertTrue(line.contains("AppRuntime.pinnedEnergyPosition"), """
            The Field reads the calendar without consulting AppRuntime.pinnedEnergyPosition. \
            It is the only screen that ever did, and it cost the composition lock a red on a \
            sixteenth of all days. Found: \(line.trimmingCharacters(in: .whitespaces))
            """)
        XCTAssertTrue(line.contains("DailyEnergyService.todaysPosition()"), """
            The calendar fallback is gone. The override is for tests and screenshots; a real \
            launch passes no argument and must still get today's actual Śakti.
            """)
    }

    /// **The last one wins**, which is what lets one screen override the suite.
    func testTheLastPinnedEnergyArgumentWins() throws {
        let f = try XCTUnwrap(LawSource.production("BinduMandalaApp.swift"))
        let decl = try XCTUnwrap(
            Rx.first("static let pinnedEnergyPosition[\\s\\S]{0,600}?\\}\\(\\)", f.text),
            "pinnedEnergyPosition is no longer declared where this test looks for it")

        XCTAssertTrue(decl.contains(".last(where:"), """
            pinnedEnergyPosition takes the FIRST matching argument. FeltRegisterSnapshots \
            composes `base + screen.arguments`, so the base's ENERGY_POS=29 would win and the \
            Field's own pin would be silently ignored — the lock would go back to depending on \
            the date, and nothing would say so.
            """)
        XCTAssertFalse(decl.contains(".first(where:"),
                       "pinnedEnergyPosition reads both first and last; one of them is dead.")
    }

    /// **The Field's snapshot pins outside the bootstrap roster.** Ring 2 is
    /// kp 29–44; today must fall outside it so no seat is ever marked, which is
    /// the composition the committed baselines already hold.
    func testTheFieldSnapshotPinsTodayOutsideTheSeededRing() throws {
        let path = LawSource.uiTestRoot.appendingPathComponent("FeltRegisterSnapshots.swift")
        let text = try String(contentsOf: path, encoding: .utf8)
        let entry = try XCTUnwrap(
            Rx.first("SnapshotScreen\\(name: \"field\"[\\s\\S]{0,240}?\\)", text),
            "the `field` snapshot screen is no longer declared")

        let match = try XCTUnwrap(Rx.groups("ENERGY_POS=(\\d+)", entry).first,
                                  "the field screen no longer pins ENERGY_POS, so its "
                                  + "composition depends on the calendar again")
        let position = try XCTUnwrap(Int(match[1]))
        XCTAssertFalse((29...44).contains(position), """
            The field snapshot pins kp \(position), which is inside Ring 2 (29–44) — the only \
            ring a SYNC_OFF launch seeds. Today's Śakti would be found in the roster and her \
            seat marked, and the committed baselines hold the composition with nothing marked.
            """)
    }
}
