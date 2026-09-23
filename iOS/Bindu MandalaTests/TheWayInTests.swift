import XCTest
import SwiftData
import SwiftUI
import SceneKit
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
        // **No directory is excused.** This check used to skip `Views/Spike/`,
        // and the project synchronises its whole source root into the app
        // target — the spike ships. A room constructed there is a room in the
        // shipping binary, reached without the rite, and the exclusion was the
        // one door this proof could not see through.
        var sites: [String] = []
        for f in LawSource.production {
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
        // **The scan reads the whole type, attributes and all.**
        //
        // It used to require `var`/`let` to be the first token on the line,
        // which silently excused every `@State`, every `@Binding` and every
        // `private` — that is, the three properties on this type that actually
        // hold anything, and the exact shape a count would arrive in.
        // `@State private var visits = 0` would have passed the old scan
        // unchanged. `SwiftProperties.stored` reads attributes and modifiers
        // first and then the declaration, and the assertion below names the two
        // it must have found, so a scan that goes blind fails rather than
        // passing everything.
        let stored = SwiftProperties.stored(in: String(file.lexed.masked))
        XCTAssertTrue(stored.contains { $0.name == "gone" && $0.attributes.contains("@State") },
                      "the scan no longer sees `@State private var gone` — it is reading past the "
                      + "attributes, which is where a stored count would be written")
        XCTAssertTrue(stored.contains { $0.name == "gone" && $0.attributes.contains("@Binding") },
                      "the scan no longer sees `@Binding var gone`")
        XCTAssertGreaterThanOrEqual(stored.count, 7,
                                    "the property scan read \(stored.count) properties: \(stored)")

        for property in stored {
            let type = property.type
            XCTAssertTrue(type == "Bool" || type.contains("-> Void") || type.contains("Binding<Bool>"),
                          "the way out carries `\(property.name): \(type)` — it holds flags and "
                          + "closures, and a value it holds is a value it can be made to show")
        }

        // And the type's own vocabulary — its static settings — is the two
        // strings and the three numbers this file is allowed to choose. A
        // *sixth* static, or a static that is not one of these, is a new value
        // on the one surface a walker sees inside a room.
        let settings = SwiftProperties.statics(in: String(file.lexed.masked)).map(\.name).sorted()
        XCTAssertEqual(settings, ["alpha", "held", "seconds", "size", "stepped"],
                       "the way out grew a type property: \(settings)")
    }

    /// The crossing is Design's own `2.2`, pinned here because the UI suite
    /// cannot import the app and carries the number by hand.
    /// `TheWayInUITests.crossing` is the same literal; if this changes, that one
    /// goes red for a named reason instead of timing out for a mysterious one.
    func testTheCrossingIsDesignsOwnTwoAndAFifthSeconds() {
        XCTAssertEqual(RoomApproach.releaseSeconds, 2.2, accuracy: 1e-9,
                       "the crossing changed length — `TheWayInUITests.crossing` has to change with it")
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

        // The *rules* of the hand-over are ``TheStay``'s and are driven above —
        // filed once, by whichever door closes first, and never for a ceremony
        // he abandoned. What is asserted here is only that this view still asks
        // that type rather than keeping its own flags again.
        let handOver = try XCTUnwrap(
            Rx.first(#"private func handOverTheStay\(\) \{[\s\S]*?\n    \}"#, code),
            "the stay is no longer handed over from one named place")
        XCTAssertTrue(handOver.contains("stay.handOver(elapsedNow: clock.elapsed(), entered: !clock.isHeld)"),
                      "the hand-over keeps its own bookkeeping again, where only its source text "
                      + "can be judged: \(SwiftLexer.collapse(handOver))")
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

    /// Nothing on any surface of this layer measures him.
    ///
    /// **The list is derived, not typed.** It used to be five filenames, which
    /// meant a sixth walker-facing file in this layer was simply not read — the
    /// one shape a hard-coded roster always takes. What is read now is every
    /// file in `Views/Rooms/` plus every screen that opens one of the two doors,
    /// so a new room surface, or a third door cut on a third screen, is judged
    /// the day it is written. (`LawsTests` walks the whole production tree and
    /// would catch it too; this is the same wall built where the phase lives.)
    func testNeitherNewSurfaceMeasuresHim() throws {
        var surfaces = Set(LawSource.production
            .filter { $0.path.hasPrefix("Views/Rooms/") }
            .map(\.path))
        for f in LawSource.production {
            let code = String(f.lexed.masked)
            if code.contains("RiteOfEnteringView.entering(") || code.contains("WorldClimbView(") {
                surfaces.insert(f.path)
            }
        }
        XCTAssertTrue(surfaces.contains("Views/Common/ShaktiDetailView.swift")
                      && surfaces.contains("Views/Common/TheHundredTwoView.swift")
                      && surfaces.contains("Views/Rooms/TheWayOut.swift"),
                      "the derivation no longer finds the two doors and the way out: \(surfaces.sorted())")
        XCTAssertGreaterThanOrEqual(surfaces.count, 5, "only \(surfaces.count) surfaces were found")

        var read = 0
        var offences: [String] = []
        for name in surfaces.sorted() {
            let file = try XCTUnwrap(LawSource.production.first { $0.path == name }, "\(name) is missing")
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

    // MARK: - 7 · The door is on the screen, not merely written

    /// **`herDoor` is drawn, not just declared.**
    ///
    /// Every other check in this file reads the door's *declaration*: what it
    /// asks before it opens, where its words live, that nothing else opens a
    /// rite. Deleting the one line that puts it in the Detail's body would leave
    /// all of them green — the declaration is still there, the `fullScreenCover`
    /// is still there with its one `entering(` call in it — and the instrument
    /// would be unreachable again, which is the exact condition this phase
    /// exists to end.
    func testTheDoorStandsInTheBodyOfHerScreen() throws {
        let detail = try XCTUnwrap(LawSource.production("ShaktiDetailView.swift"))
        let code = String(detail.lexed.masked)

        let mentions = Rx.all(#"\bherDoor\b"#, code)
        XCTAssertEqual(mentions.count, 2,
                       "`herDoor` appears \(mentions.count) times — it is declared once and drawn "
                       + "once, and neither of those may go missing")

        let body = try XCTUnwrap(Rx.first(#"var body: some View \{[\s\S]*?\n    \}"#, code),
                                 "the Detail no longer has a `body` this check can read")
        XCTAssertTrue(body.contains("herDoor"),
                      "the way into her room is declared but never drawn. The room layer is "
                      + "unreachable from the shell again, and every other check in this file "
                      + "is still green.")
        // …and it stands above the recognition, which is the ladder's order.
        let door = try XCTUnwrap(body.range(of: "herDoor"))
        let felt = try XCTUnwrap(body.range(of: "recognitionFooter"))
        XCTAssertTrue(door.lowerBound < felt.lowerBound,
                      "the room is drawn below the recognition — the room is the ground the "
                      + "recognition is made on, so it stands above it")
    }

    // MARK: - 8 · A row the grammar cannot read is still a room of her own

    /// **The 102 check, made able to fail for the reason it claims to guard.**
    ///
    /// `testEveryOneOfTheHundredAndTwoCanBeEntered` walks `HomesCorpus.rows()`,
    /// and eighty-six of those are composed from the corpus's own tattva and
    /// body-location vocabulary — words the grammar was built to read. Its
    /// sharpest assertion, `rite.room.isBuilt`, therefore could not fail for
    /// five sixths of the garland: the data was made to suit the reader.
    ///
    /// This drives the same production call over all 102 positions with **every
    /// readable field emptied** — no tattva, no quality, no body location, no
    /// bīja, which is the worst a real Airtable row can be — and asserts the
    /// same two things. A reviewer's claim that such a row falls to the shared
    /// gem-lit seat is refuted here rather than argued: `HomeGrammar.read`
    /// declines on her *āvaraṇa*, never on her words, and `physics` and
    /// `bodyAltitude` both have a floor to fall to. If that ever stops being
    /// true, the walker is admitted onto a seat instead of a room and this goes
    /// red on the day it changes.
    func testAnUnreadableRowIsStillEnteredOntoARoomOfHerOwn() throws {
        let store = try store()
        var seated: [Int] = []
        var refused: [Int] = []

        for position in 1...KhadgamalaMap.total {
            let bare = Shakti(position: position, name: "", shortName: "", phonetic: "",
                              quality: "", qualityDescription: "", somatic: "",
                              somaticPoetry: "", bija: "", bodilyLocation: "",
                              tattva: "", recognitionPhrase: "",
                              cluster: .inner, status: .mapped)
            bare.khadgamalaPosition = position
            bare.ringNumber = KhadgamalaMap.ringNumber(forKhadgamala: position)

            guard let rite = RiteOfEnteringView.entering(bare, remembering: store) else {
                refused.append(position); continue
            }
            XCTAssertEqual(rite.room.position, position)
            if !rite.room.isBuilt { seated.append(position) }
        }

        XCTAssertEqual(refused, [],
                       "a row with a position and an āvaraṇa was refused a threshold because the "
                       + "rest of her row was empty: \(refused)")
        XCTAssertEqual(seated, [],
                       "an empty row is admitted onto the shared seat rather than a room of her "
                       + "own — the door is shown, and there is nobody there: \(seated)")
    }

    // MARK: - 9 · Beat two is set in the face the string needs

    /// **The centre of the threshold was drawn in the OS's sans.**
    ///
    /// `RiteWords.written` is `firstSpoken([devanagari, name])` — her Devanāgarī
    /// where the base has it, her roman name where it does not — and the view
    /// hard-coded the system face for both, because Cormorant carries no
    /// Devanāgarī. A row with no Devanāgarī therefore had her name written in an
    /// OS alert's typeface at the one moment the instrument writes her name,
    /// between a Cormorant beat one and a Cormorant beat three, while her Detail
    /// rendered the identical string in Cormorant a tap away. Ahaṅkārākarṣiṇī
    /// (kp 31) is such a row, and she is a Ring-2 Karṣiṇī that syncs.
    func testBeatTwoAsksWhichScriptItEndedUpIn() {
        let devanagari = RiteWords.compose(appreciationPhrase: nil, ringAppreciation: "x",
                                           devanagari: "अहङ्कारार्षिणी", name: "Ahaṅkārākarṣiṇī",
                                           etymology: nil, quality: "")
        XCTAssertTrue(devanagari.writtenIsDevanagari,
                      "her Devanāgarī is not recognised as Devanāgarī, so it would be set in a "
                      + "face that has no glyphs for it")

        let roman = RiteWords.compose(appreciationPhrase: nil, ringAppreciation: "x",
                                      devanagari: nil, name: "Ahaṅkārākarṣiṇī",
                                      etymology: nil, quality: "")
        XCTAssertEqual(roman.written, "Ahaṅkārākarṣiṇī")
        XCTAssertFalse(roman.writtenIsDevanagari,
                       "her roman name reads as Devanāgarī, and would be drawn in the system face")

        // An empty field is the same answer as a missing one.
        XCTAssertFalse(RiteWords.compose(appreciationPhrase: nil, ringAppreciation: "x",
                                         devanagari: "  ", name: "Kāmākarṣiṇī",
                                         etymology: nil, quality: "").writtenIsDevanagari)
        // Diacritics are not Devanāgarī, and neither is a chevron or a space.
        XCTAssertFalse(RiteWords.isDevanagari("Ahaṅkārākarṣiṇī · Vaśinī"))
        XCTAssertTrue(RiteWords.isDevanagari("श्री"))
    }

    /// And the view asks it rather than choosing for both.
    func testTheFaceOfBeatTwoFollowsTheStringAndNotTheField() throws {
        let file = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let code = String(file.lexed.masked)
        let beat = try XCTUnwrap(
            Rx.first(#"private func written\(_ frame: RiteFrame\) -> some View \{[\s\S]*?\n    \}"#, code),
            "beat two is no longer a `written(_:)` this check can read")
        XCTAssertTrue(beat.contains("words.writtenIsDevanagari"),
                      "beat two chooses its face without asking which script it ended up in: "
                      + SwiftLexer.collapse(beat))
        XCTAssertTrue(beat.contains("AppFont.sanskrit(Self.writtenSize)"),
                      "a roman name in beat two is not set in the instrument's own face")
        // The system face survives, because Cormorant has no Devanāgarī — the
        // fix is a branch, not a replacement.
        XCTAssertTrue(beat.contains(".system(size: Self.writtenSize)"),
                      "Devanāgarī is being asked of a face that carries none")
        // …and it is the only place in the rite that reaches for the system face.
        XCTAssertEqual(Rx.all(#"\.system\(size:"#, code).count, 1,
                       "the rite sets something else in the system face")
    }

    // MARK: - 10 · The way out, driven

    /// **What a stay is worth, asserted by running it rather than by grepping
    /// for a `guard` line.**
    ///
    /// The four rules of leaving used to be three `@State` flags and two guards
    /// inside the view, and the only thing a test could reach was their source
    /// text — a refactor that kept the spelling and inverted the meaning would
    /// have passed. ``TheStay`` is the same arithmetic, liftable and drivable.
    func testTheStayEndsWhereHeDecidedItEnded() {
        var stay = TheStay()
        XCTAssertNil(stay.endedAt)

        stay.ends(at: 40)
        XCTAssertEqual(stay.endedAt, 40)
        // A press reported twice does not shorten the stay twice.
        stay.ends(at: 70)
        XCTAssertEqual(stay.endedAt, 40, "a second beginning moved the end of the stay")

        // What is filed is where he decided it ended, not where the surface went.
        XCTAssertEqual(stay.handOver(elapsedNow: 99, entered: true), 40)
    }

    func testAWalkerWhoLetGoOfTheCrossingDidNotLeave() {
        var stay = TheStay()
        XCTAssertFalse(stay.goesOn(), "a let-go with no crossing behind it moved something")

        stay.ends(at: 40)
        XCTAssertTrue(stay.goesOn(), "letting go of the crossing did not undo the ending")
        XCTAssertNil(stay.endedAt)
        // …so he goes on accruing, and what is filed is the whole of it.
        XCTAssertEqual(stay.handOver(elapsedNow: 120, entered: true), 120)
    }

    func testTheStayIsFiledExactlyOnceAndNeverForARoomHeDidNotEnter() {
        var byTheWayOut = TheStay()
        byTheWayOut.ends(at: 30)
        XCTAssertEqual(byTheWayOut.handOver(elapsedNow: 31, entered: true), 30)
        XCTAssertNil(byTheWayOut.handOver(elapsedNow: 31, entered: true),
                     "the stay was filed twice — the way out and the surface going away are two "
                     + "doors onto one write")
        XCTAssertTrue(byTheWayOut.handedOver)

        // A ceremony he abandoned at the threshold: the clock never started, so
        // there is no stay, and nothing is written.
        var abandoned = TheStay()
        XCTAssertNil(abandoned.handOver(elapsedNow: 900, entered: false),
                     "a rite the walker walked away from recorded a stay")
        XCTAssertFalse(abandoned.handedOver,
                       "an abandoned rite used up the one hand-over, so a real stay later in the "
                       + "same room would be silently dropped")

        // And a clock that reports backwards writes nothing rather than a
        // negative dwell, which would make the next ceremony longer.
        var backwards = TheStay()
        backwards.ends(at: -5)
        XCTAssertEqual(backwards.handOver(elapsedNow: 0, entered: true), 0)
    }

    /// The still path files the whole of the stay.
    ///
    /// Under reduced motion the way out is a touch: `unwind` is never called, so
    /// nothing ever sets an ending, and what has to be filed is everything up to
    /// the moment he stepped out. That was asserted nowhere.
    func testTheStillPathFilesTheWholeStay() {
        var stay = TheStay()
        XCTAssertNil(stay.endedAt, "the still path never begins a crossing out")
        XCTAssertEqual(stay.handOver(elapsedNow: 314, entered: true), 314)
    }

    /// **A crossing that was taken away puts him back.**
    ///
    /// `onPressingChanged(false)` is the only thing that calls `holdOn()`, and a
    /// press can be taken from under the view without one — a call banner, the
    /// app backgrounding, the digitizer teardown `DECISIONS.md` records for the
    /// harness. He was then left inside the room with the eye withdrawn to
    /// nothing, both dwelling marks cancelled, the stay frozen, and no gesture
    /// that could undo any of it. The withdrawal now watches itself.
    func testAWithdrawalThatWasTakenAwayIsPutBack() throws {
        let file = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let code = String(file.lexed.masked)

        let watch = try XCTUnwrap(
            Rx.first(#"private func watchTheWithdrawal\(over seconds: TimeInterval\) \{[\s\S]*?\n    \}"#, code),
            "the withdrawal is no longer watched — a cancelled press leaves the walker inside "
            + "the room with the eye withdrawn and nothing that can put it back")
        XCTAssertTrue(watch.contains("holdOn()"),
                      "the watch does something other than put him back: \(SwiftLexer.collapse(watch))")
        // Armed by the crossing, and disarmed by both honest ends.
        XCTAssertTrue(Rx.matches(#"private func unwind\(over seconds: TimeInterval\) \{[\s\S]*?watchTheWithdrawal\(over: seconds\)"#, code),
                      "beginning the crossing out no longer arms the watch")
        for ending in ["holdOn", "out"] {
            let body = try XCTUnwrap(Rx.first(#"private func \#(ending)\(\) \{[\s\S]*?\n    \}"#, code),
                                     "`\(ending)()` is gone")
            XCTAssertTrue(body.contains("withdrawal?.cancel()"),
                          "`\(ending)()` leaves the watch armed, so it will put a walker who really "
                          + "did leave back into a room he is no longer in")
        }
        // It waits for the crossing itself plus slack, never less.
        XCTAssertGreaterThan(RiteOfEnteringView.withdrawalSlack, 0)
        XCTAssertLessThan(RiteOfEnteringView.withdrawalSlack, TheWayOut.seconds,
                          "the watch waits longer than a second crossing would take")
    }
}

// MARK: - Reading a Swift type's properties off disk

/// A property scan that sees what is actually written, rather than what a
/// simple line-start pattern happens to catch.
///
/// The check it serves — *"there is nowhere in the way out to say a number"* —
/// is only worth anything if it reads the properties a number would be written
/// as. `@State private var visits = 0` is the realistic shape of that mistake,
/// and a pattern anchored on `var`/`let` as the first token on the line cannot
/// see it. So attributes (`@State`, `@Binding`, `@Environment(…)`) and modifiers
/// (`private`, `static`, `final`) are read first, and the declaration after
/// them.
enum SwiftProperties {

    struct Property: CustomStringConvertible, Equatable {
        let attributes: [String]
        let modifiers: [String]
        let keyword: String
        let name: String
        /// The written type, or the initialiser's text where the type is
        /// inferred — which is what a reader has to judge either way.
        let type: String
        let isComputed: Bool

        var isStatic: Bool { modifiers.contains("static") }
        var description: String {
            ((attributes + modifiers).joined(separator: " ") + " \(keyword) \(name): \(type)")
                .trimmingCharacters(in: .whitespaces)
        }
    }

    /// Every property declaration in `code` — which must be lexed and masked, so
    /// a string literal cannot look like one.
    static func all(in code: String) -> [Property] {
        let pattern = #"(?m)^[ \t]*((?:@[A-Za-z_][A-Za-z0-9_]*(?:\([^)\n]*\))?[ \t]+)*)"#
            + #"((?:(?:private|fileprivate|internal|public|open|static|final|lazy|weak|unowned)"#
            + #"(?:\(set\))?[ \t]+)*)"#
            + #"(var|let)[ \t]+([A-Za-z_][A-Za-z0-9_]*)[ \t]*"#
            + #"(?::[ \t]*([^\n={]+?)[ \t]*)?"#
            + #"(?:(=[^\n]*|\{[^\n]*))?[ \t]*$"#
        return Rx.groups(pattern, code).map { g in
            let written = g[5].trimmingCharacters(in: .whitespaces)
            let tail = g[6].trimmingCharacters(in: .whitespaces)
            let initialiser = tail.hasPrefix("=")
                ? String(tail.dropFirst()).trimmingCharacters(in: .whitespaces) : ""
            return Property(
                attributes: g[1].split(whereSeparator: { $0 == " " || $0 == "\t" }).map(String.init),
                modifiers: g[2].split(whereSeparator: { $0 == " " || $0 == "\t" }).map(String.init),
                keyword: g[3],
                name: g[4],
                // The written type, or — where it was inferred — the
                // initialiser, which is what a reader has to judge instead. An
                // un-annotated property is therefore judged on what it is set
                // to, and `var visits = 0` reads as `0` rather than vanishing.
                type: written.isEmpty ? initialiser : written,
                isComputed: tail.hasPrefix("{"))
        }
    }

    /// The stored instance properties — what an instance of the type *holds*.
    static func stored(in code: String) -> [Property] {
        all(in: code).filter { !$0.isComputed && !$0.isStatic }
    }

    /// The type's own settings: its vocabulary, shared by every instance and
    /// chosen once by whoever wrote the file.
    static func statics(in code: String) -> [Property] {
        all(in: code).filter { $0.isStatic }
    }
}


// MARK: - The redraw a still room depends on, proven as a frame

/// **The thing that actually regressed, asserted where it regressed.**
///
/// `testEveryPlaceTheWalkerMovesAsksTheStillRoomForAFrame` reads source text: it
/// counts `approach.set(`, greps two substrings out of `stand(at:)`, and counts
/// `moves: moves` twice. None of that can see whether a moved walker *produces a
/// new pose*, which is the defect — a reduce-motion walker standing at the door
/// for the whole ceremony while every one of those greps stayed green.
///
/// The four existing `posesApplied` assertions cannot see it either: they build
/// a `RoomDriver` by hand and never go through SwiftUI, so `updateUIView` — the
/// one link in the chain — is not in any of them.
///
/// This puts the room in a real window, moves the walker the way the rite moves
/// him, and reads the driver's own register. Both halves are asserted, because
/// only the pair is the claim: time alone does not pose a still room, and a move
/// does.
@MainActor
final class StillRoomRedrawTests: XCTestCase {

    /// Stands in for the rite's `moves` — the same `Int`, bumped from outside.
    final class Walker: ObservableObject {
        @Published var moves = 0
    }

    private struct Host: View {
        let room: HomeRoom
        @ObservedObject var walker: Walker
        var body: some View {
            RoomView(room: room, forceReduceMotion: true, moves: walker.moves)
                .statusBarHidden(true)
        }
    }

    func testAStillRoomIsPosedOncePerMoveAndNeverByTimeAlone() throws {
        let room = try XCTUnwrap(HomeRooms.resolve(position: 29, ring: 2,
                                                   tattva: "Ākāśa", quality: "She who draws",
                                                   bodilyLocation: "heart"))
        let walker = Walker()
        let controller = UIHostingController(rootView: Host(room: room, walker: walker))
        controller.view.backgroundColor = .black

        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        let window = scene.map { UIWindow(windowScene: $0) } ?? UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert + 1
        window.backgroundColor = .black
        window.isOpaque = true
        window.rootViewController = controller
        window.makeKeyAndVisible()
        defer {
            window.isHidden = true
            window.rootViewController = nil
        }

        pump(0.9)
        guard let view = sceneView(in: window), let driver = view.delegate as? RoomDriver else {
            return XCTFail("the room did not put an SCNView on screen")
        }
        XCTAssertFalse(view.isPlaying, "the still path is not still")

        // 1 · Time alone never poses it.
        let settled = driver.posesApplied
        XCTAssertGreaterThan(settled, 0, "the still room was never posed at all")
        pump(1.2)
        XCTAssertEqual(driver.posesApplied, settled,
                       "a still room left alone was posed again — the render loop is not stopped")

        // 2 · And every move the walker makes produces one.
        //
        // Asserted as *rose*, not as exactly one: SwiftUI decides for itself how
        // many times it calls `updateUIView`, and the claim is that a move
        // reaches the room at all — which is precisely what stopped being true.
        var last = settled
        for move in 1...4 {
            walker.moves &+= 1
            pump(0.35)
            XCTAssertGreaterThan(driver.posesApplied, last,
                                 """
                                 move \(move) did not reach the room. `RoomView.moves` is what makes \
                                 the representable differ when the walker has moved; without it he \
                                 stands where he was for the whole ceremony while every \
                                 source-shape check stays green.
                                 """)
            last = driver.posesApplied
        }
        // Four moves, not forty: this is still the path with no render loop on it.
        XCTAssertLessThanOrEqual(last - settled, 12,
                                 "a still room was posed \(last - settled) times for four moves")
    }

    private func pump(_ seconds: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(seconds))
    }

    private func sceneView(in window: UIWindow) -> SCNView? {
        func walk(_ view: UIView) -> SCNView? {
            if let found = view as? SCNView { return found }
            for child in view.subviews { if let found = walk(child) { return found } }
            return nil
        }
        guard let root = window.rootViewController?.view else { return nil }
        return walk(root)
    }
}
