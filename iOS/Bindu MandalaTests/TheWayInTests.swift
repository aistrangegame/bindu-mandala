import XCTest
import SwiftData
import SwiftUI
@testable import Bindu_Mandala

// MARK: - Phase 3.7 · the way in, the way out, and the two doors that carry them
//
// Everything Phases 3.1 to 3.6 built stood behind a door nobody had cut. This
// suite is what says the doors are there, that they go where they say they go,
// that they go there for **all** of the hundred and two rather than for the ones
// somebody happened to try, and that the way out is a way out rather than a
// dismissal.
//
// Four things it holds, and the third is the one with teeth:
//
//   1. **No room without the rite.** There is exactly one place in the shipping
//      tree where a `RoomView` is constructed, and it is the threshold.
//   2. **One door, and it is unconditional.** The Detail asks whether she has a
//      room and nothing else — not her ring, not her cluster, not whether the
//      base has answered.
//   3. **All 102, not a sample.** Every seat with a position and a ring is put
//      through the *same* production call the door makes.
//   4. **The way out is real.** The stay is recorded when he crosses out, which
//      is the write that makes the next ceremony shorter — and the ceremony
//      still writes all three beats at every compression that write can produce.
@MainActor
final class TheWayInTests: XCTestCase {

    // MARK: - Fixtures

    /// Her row as the base carries it, built from the shared corpus so this
    /// suite cannot be passing against data no other suite has seen.
    private func row(_ r: HomesCorpus.Row) -> Shakti {
        let s = Shakti(position: r.position, name: "kp \(r.position)", shortName: "", phonetic: "",
                       quality: r.quality, qualityDescription: "", somatic: "",
                       somaticPoetry: "", bija: r.bija ?? "", bodilyLocation: r.bodilyLocation,
                       tattva: r.tattva, recognitionPhrase: "", cluster: .inner, status: .mapped)
        s.khadgamalaPosition = r.position
        s.ringNumber = r.ring
        return s
    }

    private func store() throws -> HomeMemoryStore {
        let container = try ModelContainer(
            for: HomeMemory.self, Shakti.self, RecognitionEntry.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        return HomeMemoryStore(context: ModelContext(container))
    }

    // MARK: - 1 · Every one of the hundred and two, by the door the walker uses

    /// **The line is reachability, and it is asked of all of them.**
    ///
    /// Not "a room resolves" — `WholeInstrumentTests` already holds that, and it
    /// was true for every one of the 102 while not one of them could be opened.
    /// This drives ``RiteOfEnteringView/entering(_:remembering:)``, which is the
    /// exact call the Detail's door makes and the only way into a room in the
    /// shell, and asserts it answers for every seat in the garland.
    func testEveryOneOfTheHundredAndTwoCanBeEntered() throws {
        let store = try store()
        var refused: [String] = []
        var entered = 0

        for r in HomesCorpus.rows() {
            guard let rite = RiteOfEnteringView.entering(row(r), remembering: store) else {
                refused.append("kp \(r.position) (ring \(r.ring), \(r.provenance)) has no threshold")
                continue
            }
            entered += 1
            XCTAssertEqual(rite.room.position, r.position,
                           "kp \(r.position)'s threshold opens onto somebody else's room")
            XCTAssertEqual(rite.room.ring, r.ring)
            XCTAssertTrue(rite.room.isBuilt,
                          "kp \(r.position) is entered onto the shared seat rather than a room of "
                          + "her own — the way in reaches her, but there is nobody there")
        }

        XCTAssertEqual(entered, KhadgamalaMap.total,
                       "\(refused.count) of the hundred and two cannot be entered:\n"
                       + refused.joined(separator: "\n"))
    }

    /// And the one row that genuinely has no room is still refused, so the
    /// guard above is a guard rather than a formality.
    func testARowWithNoSeatInTheGarlandHasNoThreshold() throws {
        let store = try store()
        let r = HomesCorpus.syntheticRow(position: 29)

        let orphan = row(r)
        orphan.khadgamalaPosition = nil
        XCTAssertNil(RiteOfEnteringView.entering(orphan, remembering: store),
                     "a row with no khaḍgamālā position was given a threshold — position is identity")

        let ringless = row(r)
        ringless.ringNumber = nil
        XCTAssertNil(RiteOfEnteringView.entering(ringless, remembering: store),
                     "a row with no āvaraṇa was given a threshold")
    }

    // MARK: - 2 · The Gate

    /// **The Gate is crossable by the same door as everybody else.**
    ///
    /// Ruling 10 makes Laghimā and Garimā the authored Gate, and Phase 3.3 built
    /// them. This asserts the two things that make them reachable rather than
    /// merely built: the threshold opens for both, and what it opens onto is
    /// each one's own authored mechanism — the concrete type, not the enum case,
    /// which a placeholder turn would also satisfy.
    func testTheGateIsCrossedByTheSameDoor() throws {
        let store = try store()
        let gate: [Int: String] = [
            3: String(describing: ReleaseRoom.self),
            4: String(describing: PressRoom.self),
        ]

        for (position, mechanism) in gate.sorted(by: { $0.key < $1.key }) {
            let rite = try XCTUnwrap(
                RiteOfEnteringView.entering(row(HomesCorpus.syntheticRow(position: position)),
                                            remembering: store),
                "khaḍgamālā \(position) — half the Gate — has no threshold")
            guard case .authored(let kind) = rite.room.kind else {
                XCTFail("khaḍgamālā \(position) is not resolved as an authored room"); continue
            }
            let built = try XCTUnwrap(RoomMechanisms.forRoom(rite.room),
                                      "khaḍgamālā \(position) reaches no mechanism (\(kind))")
            XCTAssertEqual(String(describing: type(of: built)), mechanism,
                           "khaḍgamālā \(position) opens onto \(type(of: built)), not \(mechanism)")
        }
    }

    // MARK: - 3 · No room is ever reached without the rite

    /// The room is drawn by exactly one thing in the shipping tree, and that
    /// thing is the threshold.
    ///
    /// This is the law *"a room may not be reached without the rite"* held where
    /// it cannot be got round: not by checking that today's two doors go through
    /// the ceremony, but by proving there is nowhere else a room can come from.
    func testTheOnlyRoomInTheShellIsTheOneBehindTheRite() throws {
        var sites: [String] = []
        for f in LawSource.production where !f.path.hasPrefix("Views/Spike/") {
            for site in Rx.all(#"\bRoomView\("#, String(f.lexed.masked)) where !site.isEmpty {
                sites.append(f.path)
            }
        }
        XCTAssertEqual(sites, ["Views/Rooms/RiteOfEnteringView.swift"],
                       """
                       a room is drawn somewhere other than behind the rite of entering. \
                       The threshold is the only way in; a second construction site is a room \
                       a walker can arrive at without being admitted to it.
                       """)
    }

    /// …and the threshold itself is opened from exactly one place, which is her
    /// own screen.
    func testTheDoorIsCutInOnePlaceAndItIsHerOwnScreen() throws {
        var doors: [String] = []
        for f in LawSource.production {
            let code = String(f.lexed.masked)
            for _ in Rx.all(#"RiteOfEnteringView\.entering\("#, code) { doors.append(f.path) }
        }
        XCTAssertEqual(doors, ["Views/Common/ShaktiDetailView.swift"],
                       """
                       the way into a room is opened from \(doors.count) place(s). One door, \
                       reached by every path that finds her, is what makes the hundred and two \
                       equally reachable; a second door is a second set of conditions to drift.
                       """)
    }

    /// **And it is unconditional.**
    ///
    /// The one thing the Detail may ask before offering her room is whether she
    /// has one. Anything else — her ring, her cluster, whether she has been felt,
    /// whether the base has answered — would make some of the hundred and two
    /// reachable and others not, which is the one shape this phase may not take.
    func testTheDoorAsksOnlyWhetherSheHasARoom() throws {
        let detail = try XCTUnwrap(LawSource.production("ShaktiDetailView.swift"))
        let code = String(detail.lexed.masked)
        let door = try XCTUnwrap(
            Rx.first(#"private var herDoor: some View \{\s*\n\s*if [^\n]*\n"#, code),
            "the Detail's door is no longer a `herDoor` opening with a condition — "
            + "if it moved, this check has to move with it")
        XCTAssertTrue(door.contains("if HomeRooms.resolve(shakti) != nil {"),
                      """
                      the door to her room is gated on something other than whether she has one: \
                      \(SwiftLexer.collapse(door))
                      """)
    }

    // MARK: - 4 · The way out

    /// The way out is one way out, and its words live in one file.
    func testTheWayOutIsWrittenDownOnce() throws {
        var files: Set<String> = []
        for f in LawSource.production {
            for lit in f.literals where lit.text == TheWayOut.held || lit.text == TheWayOut.stepped {
                files.insert(f.path)
            }
        }
        XCTAssertEqual(files, ["Views/Rooms/TheWayOut.swift"],
                       "the way out is written in more than one place: \(files.sorted())")
    }

    /// It is a crossing, at the crossing's own length — Design's release, read
    /// rather than typed a second time.
    func testTheWayOutLastsAsLongAsTheWayIn() {
        XCTAssertEqual(TheWayOut.seconds, RoomApproach.releaseSeconds, accuracy: 1e-9)
        XCTAssertGreaterThan(TheWayOut.seconds, 0)
    }

    /// Reduced motion gets a **step**, not a slowed-down walk: a different word,
    /// because it is a different gesture, and no long press anywhere on that
    /// branch. `iOS/FIDELITY.md`'s real still path, at the one control a room has.
    func testReducedMotionStepsOutRatherThanHoldingThroughNothing() throws {
        XCTAssertEqual(TheWayOut.words(reduceMotion: false), TheWayOut.held)
        XCTAssertEqual(TheWayOut.words(reduceMotion: true), TheWayOut.stepped)
        XCTAssertNotEqual(TheWayOut.held, TheWayOut.stepped)

        let file = try XCTUnwrap(LawSource.production("TheWayOut.swift"))
        let code = String(file.lexed.masked)
        let branch = try XCTUnwrap(Rx.first(#"if reduceMotion \{[\s\S]*?\} else \{"#, code),
                                   "the way out no longer branches on the motion setting")
        XCTAssertFalse(branch.contains("onLongPressGesture"),
                       "the still path holds a long press through a room that is not moving")
        XCTAssertTrue(branch.contains("onTapGesture"),
                      "the still path offers no gesture at all")
        XCTAssertEqual(Rx.all(#"minimumDuration: TheWayOut\.seconds"#, code).count, 1,
                       "the hold is no longer exactly the crossing's own length")
    }

    /// It clears FIDELITY rule 4's floor rather than sitting on it — this is an
    /// instruction, not a ghost — and it is set in the rite's own voice, so the
    /// last thing read on the way in and the first on the way out are one type.
    func testTheWayOutIsLegibleAndInTheRitesOwnVoice() {
        XCTAssertGreaterThanOrEqual(TheWayOut.size, 11)
        XCTAssertGreaterThanOrEqual(TheWayOut.alpha, 0.5)
        XCTAssertEqual(TheWayOut.alpha, RiteOfEntering.promptAlpha, accuracy: 1e-9)
    }

    /// **And there is nowhere in it to say a number.**
    ///
    /// The way out is the only thing a walker is shown inside a room besides the
    /// room, which makes it the most obvious place in the instrument for a count
    /// to appear. Two registers: nothing it can say measures, and nothing it
    /// holds could be counted — its stored properties are a flag and three
    /// closures returning `Void`.
    func testTheWayOutCannotSayANumber() throws {
        let file = try XCTUnwrap(LawSource.production("TheWayOut.swift"))
        for lit in file.literals {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(lit.text).isEmpty,
                          "the way out measures out loud: \"\(lit.text)\"")
            XCTAssertNil(Rx.first(#"\d"#, lit.text),
                         "the way out says a digit: \"\(lit.text)\"")
        }
        let stored = Rx.groups(#"(?:^|\n)\s*(?:var|let)\s+[A-Za-z_][A-Za-z0-9_]*\s*:\s*([^\n=]+)"#,
                               String(file.lexed.masked)).map { $0[1].trimmingCharacters(in: .whitespaces) }
        XCTAssertGreaterThanOrEqual(stored.count, 4, "the property scan read nothing: \(stored)")
        for type in stored {
            XCTAssertTrue(type == "Bool" || type.contains("-> Void") || type.contains("Binding<Bool>"),
                          "the way out carries a \(type) — it holds a flag and three closures, and "
                          + "a value it holds is a value it can be made to show")
        }
    }

    // MARK: - 4b · The still room is asked for the frame rather than given one

    /// **The redraw a reduce-motion walker depends on was never declared.**
    ///
    /// `RoomApproachSource` is a reference so the room's driver can read the
    /// walker's distance on SceneKit's own thread without re-rendering the
    /// SwiftUI tree. The cost of that — never written down until this phase —
    /// is that moving him changes nothing SwiftUI can see, and with the render
    /// loop stopped nothing asks the room for another frame. The re-pose after
    /// a touch was incidental, produced by some *other* update to the view; two
    /// new stored properties on the rite were enough to stop it happening, and
    /// `testAReduceMotionWalkerIsCarriedToHisStation` found him standing at the
    /// door for the whole ceremony.
    ///
    /// `RoomView.moves` is the ask, made explicit — the same token
    /// ``WorldClimbView`` already carried as `steps`. This holds the shape that
    /// makes it impossible to forget: the rite moves the walker through exactly
    /// one function, and that function bumps the token.
    func testEveryPlaceTheWalkerMovesAsksTheStillRoomForAFrame() throws {
        let rite = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let code = String(rite.lexed.masked)

        let sets = Rx.all(#"approach\.set\("#, code)
        XCTAssertEqual(sets.count, 1,
                       """
                       the rite moves the walker from \(sets.count) places. One of them is \
                       `stand(at:)`, which asks the still room for a frame; the others move him \
                       where nothing with the render loop stopped will ever draw him.
                       """)
        let stand = try XCTUnwrap(Rx.first(#"private func stand\(at approach: RoomApproach\) \{[^}]*\}"#, code),
                                  "the rite no longer has one place that stands the walker")
        XCTAssertTrue(stand.contains("self.approach.set(approach)") && stand.contains("moves &+= 1"),
                      "standing the walker no longer asks the still room for a frame: \(SwiftLexer.collapse(stand))")
        XCTAssertTrue(code.contains("moves: moves"), "the room is not handed the token")

        // And the token really does reach both halves of a room — the scene and
        // the light pass — or one of them would draw a different instant than
        // the other, which is the defect the render spine already paid for once.
        let room = try XCTUnwrap(LawSource.production("RoomView.swift"))
        XCTAssertEqual(Rx.all(#"moves: moves"#, String(room.lexed.masked)).count, 2,
                       "the redraw token no longer reaches both the scene and the light pass")
    }

    // MARK: - 5 · What the stay is worth, and the compression it buys

    /// **The write that was missing.**
    ///
    /// `HomeMemoryStore.record` has existed since Phase 2.2 and nothing in the
    /// app had ever called it, so a compression that was asserted at every value
    /// Design's curve can produce had never actually compressed anything. The
    /// threshold now hands the stay over on the way out — asserted here on the
    /// production door's own source, because the wire is what was absent, not
    /// the arithmetic.
    func testTheThresholdHandsTheStayToHerRoomsMemory() throws {
        let file = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let code = String(file.lexed.masked)

        let writes = Rx.all(#"store\.record\([^)]*\)"#, code)
        XCTAssertEqual(writes.count, 1, "the stay is written down in \(writes.count) places")
        XCTAssertEqual(SwiftLexer.collapse(writes[0]),
                       "store.record(khadgamalaPosition: position, dwell: dwell)",
                       "the stay is filed under something other than her khaḍgamālā position")

        // Once, by whichever door closes first, and never for a room he did not
        // enter — a clock still held at her threshold is a stay that never began.
        XCTAssertEqual(Rx.all(#"recording\?\("#, code).count, 1,
                       "the stay is handed over from more than one place")
        XCTAssertTrue(code.contains("guard !handedOver, !clock.isHeld else { return }"),
                      "a stay can now be handed over twice, or handed over for a room "
                      + "the walker never entered")
    }

    /// And what that write buys: the ceremony is quicker, and it still happens.
    ///
    /// Compression is *felt* — there is no line anywhere that says it — so the
    /// only honest assertion is the pair: the same threshold takes less time to
    /// write, and none of its three beats is dropped on the way.
    func testAStayCompressesTheNextCeremonyAndNeverSkipsABeat() throws {
        let store = try store()
        let position = 29

        XCTAssertEqual(store.compression(for: position), 1, accuracy: 1e-9,
                       "a room never stood in already opens at a compression")
        XCTAssertEqual(store.headStart(for: position), 0, accuracy: 1e-9)

        var lastCompression = 1.0
        for stay in 1...12 {
            store.record(khadgamalaPosition: position, dwell: 240)
            let compression = store.compression(for: position)
            XCTAssertLessThanOrEqual(compression, lastCompression,
                                     "stay \(stay) made the ceremony longer")
            lastCompression = compression

            // Every beat still arrives, at whatever the compression has become.
            var rite = RiteOfEntering(compression: compression,
                                      headStart: store.headStart(for: position),
                                      now: 0)
            var now = 0.0
            for _ in 0..<3 {
                now += rite.writingDuration + 0.1
                _ = rite.touch(at: now)
            }
            XCTAssertEqual(rite.struck, [.phrase, .written, .roots],
                           "a beat was skipped after stay \(stay) — return compression "
                           + "shortens the writing and never the ceremony")
        }

        XCTAssertLessThan(lastCompression, 1,
                          "twelve stays bought no compression at all — the way out is writing nothing")
        XCTAssertGreaterThan(store.headStart(for: position), 0,
                             "accumulated dwell opened her room nowhere further in")
    }

    // MARK: - 6 · The climb's door

    /// The climb is opened from one place, and that place is the Field —
    /// never the menu. See ``TheHundredTwoView``'s own reasoning.
    func testTheClimbIsOpenedFromTheFieldAndNotFromTheMenu() throws {
        var doors: [String] = []
        for f in LawSource.production {
            for _ in Rx.all(#"WorldClimbView\("#, String(f.lexed.masked)) { doors.append(f.path) }
        }
        XCTAssertEqual(doors, ["Views/Common/TheHundredTwoView.swift"],
                       "the climb is reached from \(doors.count) place(s): \(doors)")

        let menu = try XCTUnwrap(LawSource.production("HamburgerMenuView.swift"))
        let root = try XCTUnwrap(LawSource.production("RootView.swift"))
        for f in [menu, root] {
            XCTAssertFalse(String(f.lexed.masked).contains("WorldClimb"),
                           "\(f.path) names the climb — it is not a sixth way of being in the app")
        }
        // The shell's destinations are untouched: the enum having room for one
        // more is not an argument that one belongs there.
        XCTAssertTrue(String(root.lexed.masked)
            .contains("enum Destination: String { case mandala, rite, well, the102, memory }"),
                      "a destination was added to the shell")
    }

    /// He rises from where he is already standing in the Field, not from the
    /// first āvaraṇa every time.
    func testTheClimbOpensAtTheRingHeIsStandingIn() throws {
        let field = try XCTUnwrap(LawSource.production("TheHundredTwoView.swift"))
        let code = String(field.lexed.masked)
        XCTAssertTrue(code.contains("startingAtRing: effectiveOpen ?? todayRing"),
                      "the climb no longer opens at the āvaraṇa the walker has open")
        // And every ring the Field can have open is a ring the climb can stand at.
        for ring in 1...9 {
            XCTAssertNotNil(HomeWorlds.world(ring: ring, live: nil),
                            "ring \(ring) has no world for the climb to open at")
        }
    }

    /// Nothing on either new surface measures him.
    func testNeitherNewSurfaceMeasuresHim() throws {
        let surfaces = ["TheWayOut.swift", "WorldClimbView.swift", "RiteOfEnteringView.swift",
                        "ShaktiDetailView.swift", "TheHundredTwoView.swift"]
        var read = 0
        var offences: [String] = []
        for name in surfaces {
            let file = try XCTUnwrap(LawSource.production(name), "\(name) is missing")
            for call in file.calls(to: LawSource.walkerFacingCallees) {
                for lit in call.literals {
                    read += 1
                    let hits = NeverMeasure.measuresOutLoud(lit.text)
                    if !hits.isEmpty { offences.append("\(call.origin) — \"\(lit.text)\"") }
                }
                for expr in call.expressions where !expr.isEmpty {
                    for what in NeverMeasure.practiceTouched(in: expr) {
                        offences.append("\(call.origin) — binds \(what): \(expr)")
                    }
                }
            }
        }
        XCTAssertGreaterThanOrEqual(read, 30, "only \(read) strings were read from the new surfaces")
        XCTAssertTrue(offences.isEmpty,
                      "the way in or the way out measures the walker:\n" + offences.joined(separator: "\n"))
    }
}
