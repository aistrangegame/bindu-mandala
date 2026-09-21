import XCTest
import SwiftData
import SwiftUI
import SceneKit
import UIKit
@testable import Bindu_Mandala

// MARK: - The rite of entering, judged
//
// It is the first thing the walker feels every time he enters, so this suite is
// weighted toward the two laws that meet at the threshold rather than toward
// the drawing:
//
//   * **the ceremony compresses on a return and never skips** — three beats at
//     every compression Design's curve can produce, down to and including the
//     floor, and each beat writing over the compressed duration rather than a
//     shortened ceremony;
//   * **and none of it is said out loud** — every string the rite can put in
//     front of the walker, over all 102, run through Design's own nine
//     MEASURING patterns, plus a second detector for the thing those patterns
//     cannot see: a sentence that mentions a return without ever printing a
//     number.
//
// The second one is the reason this file scans its own source. `LawsTests` will
// catch a digit anywhere in the tree; nothing in the tree catches "welcome
// back", because there is no number in it. So the rite's own literals are read
// off disk and refused the vocabulary of returning — and the detector is proved
// against a planted line before it is trusted.
@MainActor
final class RiteOfEnteringTests: XCTestCase {

    // MARK: - Fixtures

    private func room(position: Int = RiteFixture.garima,
                      ring: Int? = nil,
                      tattva: String = "Pṛthvī — earth",
                      quality: String = "Weightedness",
                      bodilyLocation: String = "Mūlādhāra / sit-bones / soles") -> HomeRoom {
        let ring = ring ?? KhadgamalaMap.ringNumber(forKhadgamala: position)
        guard let room = HomeRooms.resolve(position: position, ring: ring, tattva: tattva,
                                           quality: quality, bodilyLocation: bodilyLocation) else {
            fatalError("no room resolved at position \(position)")
        }
        return room
    }

    /// Her words as the base gives them for the room the rite enters.
    private var garimaWords: RiteWords {
        RiteWords.compose(appreciationPhrase: "Thank you for the weight that holds me here.",
                          ringAppreciation: Avarana.appreciationPhrase(forRing: 1),
                          devanagari: "गरिमा",
                          name: "Garimā",
                          etymology: "Guru + imā",
                          quality: "Weightedness")
    }

    /// A whole ceremony, walked: every beat touched through to the room.
    /// Returns what the ceremony struck, and where the walker stood at each
    /// touch.
    @discardableResult
    private func walk(_ rite: inout RiteOfEntering,
                      from epoch: TimeInterval,
                      waiting: TimeInterval? = nil) -> (struck: [RiteBeat], travel: [Double]) {
        var travel: [Double] = [rite.approach.value(at: epoch)]
        var now = epoch
        for _ in 1...RiteBeat.allCases.count {
            now += waiting ?? rite.writingDuration
            rite.touch(at: now)
            travel.append(rite.approach.value(at: now))
        }
        return (rite.struck, travel)
    }

    // MARK: - The beat writes over its compressed duration

    /// Her memory scales **how long a beat takes to write**, and nothing else.
    func testEachBeatWritesOverItsCompressedDuration() {
        for reduceMotion in [false, true] {
            let whole = reduceMotion
                ? RiteOfEntering.reducedWritingSeconds
                : RiteOfEntering.writingSeconds
            for visits in 0...8 {
                let compression = HomeMemory.compression(visits: visits)
                let epoch: TimeInterval = 1_000
                let rite = RiteOfEntering(compression: compression,
                                          reduceMotion: reduceMotion,
                                          now: epoch)

                XCTAssertEqual(rite.writingDuration, whole * compression, accuracy: 1e-9,
                               "the beat's duration is not Design's seconds times her compression")

                // It is done exactly at the end of that duration, and not before.
                XCTAssertEqual(rite.writing(at: epoch + rite.writingDuration), 1, accuracy: 1e-9)
                XCTAssertGreaterThanOrEqual(rite.writing(at: epoch + rite.writingDuration * 2), 1)

                guard !reduceMotion else { continue }
                XCTAssertEqual(rite.writing(at: epoch), 0, accuracy: 1e-9)
                XCTAssertEqual(rite.writing(at: epoch + rite.writingDuration / 2), 0.5, accuracy: 1e-9)
                XCTAssertLessThan(rite.writing(at: epoch + rite.writingDuration * 0.99), 1,
                                  "the beat finished writing before its duration was up")
            }
        }

        // And the compression really is a *shortening*, never a removal: the
        // most-known room's ceremony is the floor's share of the least-known
        // one's, beat for beat.
        let fresh = RiteOfEntering(compression: HomeMemory.compression(visits: 0))
        let known = RiteOfEntering(compression: HomeMemory.compression(visits: 40))
        XCTAssertEqual(known.writingDuration / fresh.writingDuration,
                       HomeMemory.compressionFloor, accuracy: 1e-9)
        XCTAssertEqual(known.struck.count, fresh.struck.count)
    }

    // MARK: - Three beats, at every compression, and the floor holds

    /// **The law the brief states twice.** However known she is, the ceremony
    /// is three beats — it is only written faster.
    func testThreeBeatsHappenAtEveryCompressionAndTheFloorHolds() {
        var compressions: Set<Double> = []
        for visits in 0...400 {
            let compression = HomeMemory.compression(visits: visits)
            compressions.insert(compression)

            XCTAssertGreaterThanOrEqual(compression, HomeMemory.compressionFloor,
                                        "the ceremony fell through its own floor at \(visits) visits")
            XCTAssertLessThanOrEqual(compression, 1)

            for reduceMotion in [false, true] {
                var rite = RiteOfEntering(compression: compression,
                                          reduceMotion: reduceMotion, now: 0)
                let walked = walk(&rite, from: 0)
                XCTAssertEqual(walked.struck, [.phrase, .written, .roots],
                               """
                               the ceremony was not three beats at compression \(compression) \
                               (reduceMotion \(reduceMotion)) — a return may shorten the rite and \
                               may never skip a beat of it
                               """)
                XCTAssertGreaterThanOrEqual(
                    rite.writingDuration,
                    HomeMemory.compressionFloor * (reduceMotion
                                                   ? RiteOfEntering.reducedWritingSeconds
                                                   : RiteOfEntering.writingSeconds) - 1e-9,
                    "a beat wrote faster than the floor allows")
            }
        }

        // Design's own curve, stated out loud so a retuning is visible here.
        XCTAssertEqual(compressions.sorted(by: >).prefix(4).map { ($0 * 100).rounded() / 100 },
                       [1.0, 0.68, 0.46, 0.36],
                       "the compression curve is no longer 1 → 0.68 → 0.46 → the floor")

        // A caller that hands over nonsense gets the floor, not a vanished rite.
        for absurd in [0, -3, Double.nan, 1e9] {
            let rite = RiteOfEntering(compression: absurd)
            XCTAssertGreaterThanOrEqual(rite.compression, HomeMemory.compressionFloor)
            XCTAssertLessThanOrEqual(rite.compression, 1)
            XCTAssertGreaterThan(rite.writingDuration, 0)
        }
    }

    // MARK: - Touch-paced, never timed out

    /// Nothing advances on a timer, and nothing is ever skipped.
    func testTheSequenceIsTouchPacedRatherThanTimedOut() {
        var rite = RiteOfEntering(compression: 1, now: 0)

        // A whole day at the first beat, and he is still at the first beat.
        let aDay: TimeInterval = 86_400
        XCTAssertEqual(rite.stage, .beat(.phrase))
        XCTAssertEqual(rite.frame(at: aDay).beat, .phrase)
        XCTAssertEqual(rite.struck, [.phrase])
        XCTAssertEqual(rite.approach.value(at: aDay),
                       RiteOfEntering.stations[1], accuracy: 1e-3,
                       "the walker kept travelling after the beat he was given had finished")

        // …and one touch moves him, however long he waited.
        XCTAssertEqual(rite.touch(at: aDay), .written)
        XCTAssertEqual(rite.stage, .beat(.written))

        // A touch **before** the beat has written also moves him: the ceremony
        // is paced by him, not by the clock, in both directions.
        var hurried = RiteOfEntering(compression: 1, now: 0)
        XCTAssertLessThan(hurried.writing(at: 0.01), 1)
        XCTAssertEqual(hurried.touch(at: 0.01), .written)
        XCTAssertEqual(hurried.touch(at: 0.02), .roots)
        XCTAssertNil(hurried.touch(at: 0.03), "the third touch releases him rather than writing")
        XCTAssertEqual(hurried.struck, [.phrase, .written, .roots])
        XCTAssertEqual(hurried.stage, .crossing)

        // Once released, further touches do nothing at all — the crossing is
        // the one stretch he does not pace.
        XCTAssertNil(hurried.touch(at: 0.04))
        XCTAssertEqual(hurried.struck, [.phrase, .written, .roots])
    }

    // MARK: - The rite is the distance

    /// The three beats are three stretches of the crossing, and the walker only
    /// moves when he touches.
    func testTheCrossingIsFoldedIntoTheTravel() {
        XCTAssertEqual(RiteOfEntering.stations, [0, 0.3, 0.62, 0.88, 1],
                       "Design's stations along the travel have changed")

        let epoch: TimeInterval = 500
        var rite = RiteOfEntering(compression: 1, now: epoch)
        XCTAssertEqual(rite.approach.from, 0, "the crossing does not begin at the far end")
        XCTAssertEqual(rite.approach.to, RiteOfEntering.stations[1])

        var now = epoch
        for (index, beat) in [RiteBeat.written, .roots].enumerated() {
            now += 30
            XCTAssertEqual(rite.touch(at: now), beat)
            XCTAssertEqual(rite.approach.to, RiteOfEntering.stations[index + 2], accuracy: 1e-9,
                           "beat \(beat) does not carry him to his station")
        }

        // The third touch: the last stretch, steadily, and he arrives.
        now += 30
        XCTAssertNil(rite.touch(at: now))
        XCTAssertEqual(rite.approach.to, 1)
        let crossing = try? XCTUnwrap(rite.crossingDuration(at: now))
        XCTAssertNotNil(crossing)
        XCTAssertEqual(rite.approach.value(at: now + (crossing ?? 0)), 1, accuracy: 1e-9,
                       "the crossing does not reach the room")
        XCTAssertLessThan(rite.approach.value(at: now), 1)

        // And the crossing costs what is left of Design's 2.2 seconds, not the
        // whole of it again.
        XCTAssertEqual(crossing ?? 0,
                       RoomApproach.releaseSeconds * (1 - RiteOfEntering.stations[3]),
                       accuracy: 0.2)

        rite.arrive(at: now + 10)
        XCTAssertEqual(rite.stage, .inside)
        XCTAssertFalse(rite.isCeremonial)
        XCTAssertEqual(rite.approach.value(at: now + 1_000), 1)
    }

    /// The room is really looked at from further out while he is crossing, and
    /// from where he stands once he is in.
    func testTheEyeStandsBackWhileHeIsStillCrossing() {
        XCTAssertEqual(RoomUnits.eyeDepth(approach: 1), RoomUnits.eyeZ, accuracy: 1e-9)
        XCTAssertEqual(RoomUnits.eyeDepth(approach: 0),
                       RoomUnits.eyeZ + RoomUnits.approachStandOff, accuracy: 1e-9)
        XCTAssertEqual(RoomUnits.approachStandOff, RoomUnits.roomHeight, accuracy: 1e-9,
                       "the crossing is no longer one body-height, which is the only reason it is not a tuned number")

        // Monotone: every touch brings him nearer and none of them takes him back.
        var previous = Double.infinity
        for step in 0...20 {
            let depth = RoomUnits.eyeDepth(approach: Double(step) / 20)
            XCTAssertLessThanOrEqual(depth, previous + 1e-9, "the walker moved away from her room")
            previous = depth
        }

        let her = room()
        let scene = RoomScene(room: her)
        scene.pose(at: 0)
        let standing = scene.cameraNode.position.z
        scene.stand(atApproach: 0)
        XCTAssertGreaterThan(scene.cameraNode.position.z, standing,
                             "standing at the far end of the crossing did not move the eye back")
        scene.stand(atApproach: 1)
        XCTAssertEqual(scene.cameraNode.position.z, standing, accuracy: 1e-4)

        // The crossing adds nothing to the room: the binding condition still holds.
        XCTAssertEqual(scene.solidsInHerLayer, 0,
                       "the approach put a solid under her layer")

        // An entered room is still exactly one clock: posing it sets the air to
        // her own world time, so the seam the threshold needs cannot leave a
        // room breathing on two clocks at once.
        scene.pose(at: 120)
        XCTAssertEqual(scene.breathedAt,
                       HomeWorlds.worldClock(120, ring: her.ring), accuracy: 1e-9)
        scene.breathe(at: 9)
        XCTAssertEqual(scene.breathedAt, 9, accuracy: 1e-9)
        scene.pose(at: 120)
        XCTAssertEqual(scene.breathedAt,
                       HomeWorlds.worldClock(120, ring: her.ring), accuracy: 1e-9,
                       "a pose no longer brings the air back onto her own clock")
    }

    // MARK: - The strike

    /// One struck tone per beat: her carrier at the unison, the fifth, the
    /// octave. `HomeCarrier` owns the arithmetic; the rite owns which beat.
    func testTheStrikePitchesAreTheCarrierTheFifthAndTheOctave() {
        for (ring, syllable) in [(1, nil), (2, "aṁ"), (7, "hrīṃ"), (9, nil)] as [(Int, String?)] {
            let carrier = HomeCarrier.carrierFor(ring: ring, syllable: syllable)
            var rite = RiteOfEntering(compression: 1, now: 0)
            walk(&rite, from: 0)

            XCTAssertEqual(rite.struck, [.phrase, .written, .roots])
            let pitches = rite.strikePitches(ring: ring, syllable: syllable)
            XCTAssertEqual(pitches.count, 3, "a beat landed without a tone")
            XCTAssertEqual(pitches[0], carrier, accuracy: 1e-9)
            XCTAssertEqual(pitches[1], carrier * HomeCarrier.fifthRatio, accuracy: 1e-9)
            XCTAssertEqual(pitches[2], carrier * 2, accuracy: 1e-9)
            XCTAssertEqual(HomeCarrier.fifthRatio, 1.5)

            // Rising, always — the ceremony opens upward.
            XCTAssertEqual(pitches, pitches.sorted())
        }

        // A room whose syllable the base does not name is struck on the bare
        // root: silence about what is unknown, never a plausible pitch.
        XCTAssertEqual(RiteOfEntering.strikePitch(beat: .phrase, ring: 3, syllable: nil),
                       HomeCarrier.root(forRing: 3), accuracy: 1e-9)
    }

    // MARK: - Reduced motion

    /// Reduced motion is given the **outcome** of every beat, and still walks
    /// all three.
    func testReduceMotionReachesTheSettledStateWithEveryBeatStillPresent() {
        let epoch: TimeInterval = 10
        var rite = RiteOfEntering(compression: 1, reduceMotion: true, now: epoch)
        var seen: [RiteBeat] = []
        var now = epoch

        for _ in 1...RiteBeat.allCases.count {
            let frame = rite.frame(at: now)
            let beat = try? XCTUnwrap(frame.beat)
            seen.append(beat ?? .phrase)

            XCTAssertTrue(frame.isSettled,
                          "beat \(String(describing: frame.beat)) is mid-writing with reduce motion on")
            XCTAssertEqual(frame.writing, 1, accuracy: 1e-9)
            XCTAssertNotNil(frame.prompt, "the prompt is withheld on a path with nothing to wait for")

            // …and it is still settled a moment later, because nothing is running.
            XCTAssertEqual(rite.frame(at: now + 0.5), frame,
                           "something moved on the reduce-motion path")

            // The crossing is quantized: he steps to his station and stands there.
            XCTAssertEqual(rite.approach.motion, .still,
                           "reduce motion is gliding rather than stepping")
            now += 1
            rite.touch(at: now)
        }

        XCTAssertEqual(seen, [.phrase, .written, .roots],
                       "a beat was dropped on the reduce-motion path")
        XCTAssertEqual(rite.struck, [.phrase, .written, .roots])

        // The stations are still the stations — quantized, not shortened.
        var stepping = RiteOfEntering(compression: 1, reduceMotion: true, now: 0)
        XCTAssertEqual(stepping.approach.value(at: 0), RiteOfEntering.stations[1])
        stepping.touch(at: 1)
        XCTAssertEqual(stepping.approach.value(at: 1), RiteOfEntering.stations[2])
        stepping.touch(at: 2)
        XCTAssertEqual(stepping.approach.value(at: 2), RiteOfEntering.stations[3])
        stepping.touch(at: 3)
        XCTAssertEqual(stepping.approach.value(at: 3), 1, "he never arrives with reduce motion on")
        XCTAssertEqual(stepping.crossingDuration(at: 3), 0)

        // And the animated path really is different, so this is a comparison
        // between two things rather than one thing asserted twice.
        let moving = RiteOfEntering(compression: 1, reduceMotion: false, now: 0)
        XCTAssertNotEqual(moving.frame(at: 0), moving.frame(at: 0.5))
        XCTAssertLessThan(moving.frame(at: 0).writing, 1)
    }

    // MARK: - Design's three curves

    /// Her name is written in **three** strokes, each easing across and then
    /// holding — which is what makes it a hand rather than a wipe.
    func testHerNameIsWrittenInThreeStrokes() {
        XCTAssertEqual(RiteOfEntering.strokes, 3)
        XCTAssertEqual(RiteOfEntering.revealed(writing: 0), 0, accuracy: 1e-9)
        XCTAssertEqual(RiteOfEntering.revealed(writing: 1), 1, accuracy: 1e-3)

        // Never backwards.
        var previous = -1.0
        for step in 0...1_000 {
            let revealed = RiteOfEntering.revealed(writing: Double(step) / 1_000)
            XCTAssertGreaterThanOrEqual(revealed, previous - 1e-9, "the hand unwrote a stroke")
            XCTAssertLessThanOrEqual(revealed, 1 + 1e-9)
            previous = revealed
        }

        // Three strokes means two pauses in the middle of the writing, at a
        // third and at two thirds — the moments the hand is lifted.
        var plateaus: [Double] = []
        var run = 0
        for step in 1...1_000 {
            let here = RiteOfEntering.revealed(writing: Double(step) / 1_000)
            let before = RiteOfEntering.revealed(writing: Double(step - 1) / 1_000)
            if abs(here - before) < 1e-12 {
                run += 1
            } else {
                if run >= 5 { plateaus.append(before) }
                run = 0
            }
        }
        XCTAssertEqual(plateaus.count, 2,
                       "her name is not being written in three strokes — \(plateaus) pauses found")
        XCTAssertEqual(plateaus.first ?? 0, 1.0 / 3, accuracy: 1e-3)
        XCTAssertEqual(plateaus.last ?? 0, 2.0 / 3, accuracy: 1e-3)

        // The hold is Design's own: each stroke is drawn across the first 0.72
        // of its share and waits out the rest.
        XCTAssertEqual(RiteOfEntering.strokeHold, 0.72)
        XCTAssertEqual(RiteOfEntering.revealed(writing: RiteOfEntering.strokeHold / 3),
                       1.0 / 3, accuracy: 1e-9)
    }

    /// Her roots part and come back together, and her quality arrives beneath
    /// them — the beat ends with the name whole again.
    func testHerRootsPartAndRejoinWithHerQualityBeneath() {
        XCTAssertEqual(RiteOfEntering.rootGap(writing: 0), 0, accuracy: 1e-9)
        XCTAssertEqual(RiteOfEntering.rootGap(writing: 1), 0, accuracy: 1e-9,
                       "the roots were left standing apart")

        // **They begin coming back together before they have finished parting.**
        // Design's `join` opens at 0.52 and `split` does not complete until
        // 0.58, so the widest the roots ever stand is 0.52/0.58 of the full gap
        // — and that overlap is why the beat reads as one breath rather than as
        // two gestures with a pause between them.
        let widest = stride(from: 0.0, through: 1.0, by: 0.0005)
            .map { RiteOfEntering.rootGap(writing: $0) }.max() ?? 0
        XCTAssertGreaterThan(widest, 0.85, "the roots never really parted")
        XCTAssertEqual(widest,
                       RiteOfEntering.rootsRejoinFrom / RiteOfEntering.rootsPartOver,
                       accuracy: 1e-3,
                       "the parting and the rejoining no longer overlap")
        XCTAssertEqual(RiteOfEntering.rootGap(writing: RiteOfEntering.rootsRejoinFrom),
                       widest, accuracy: 1e-3)

        XCTAssertEqual(RiteOfEntering.gloss(writing: RiteOfEntering.glossArrivesFrom), 0, accuracy: 1e-9)
        XCTAssertEqual(RiteOfEntering.gloss(writing: 1), 1, accuracy: 1e-9)
        XCTAssertEqual(RiteOfEntering.glossAlpha, 0.6)

        // The prompt waits for the writing, at every beat, and says the right
        // thing: the third touch enters, the others go on.
        for (beat, prompt) in [(RiteBeat.phrase, RitePrompt.goOn),
                               (.written, .goOn),
                               (.roots, .enter)] {
            var rite = RiteOfEntering(compression: 1, now: 0)
            while case .beat(let at) = rite.stage, at != beat { rite.touch(at: 0) }
            XCTAssertNil(rite.frame(at: 0).prompt, "the prompt arrived before the beat was written")
            XCTAssertEqual(rite.frame(at: rite.writingDuration).prompt, prompt)
        }
        XCTAssertEqual(RitePrompt.goOn.words, "touch to go on")
        XCTAssertEqual(RitePrompt.enter.words, "touch to enter")

        // FIDELITY's legibility floor, which is why the prompt is not Design's
        // 0.44: it is the one instruction in the ceremony.
        XCTAssertGreaterThanOrEqual(RiteOfEntering.promptAlpha, 0.5)
        XCTAssertGreaterThanOrEqual(RiteOfEntering.glossAlpha, 0.5)
        XCTAssertGreaterThanOrEqual(RiteOfEntering.phraseAlpha, 0.5)
    }

    // MARK: - The head start

    /// On a return the room opens where his accumulated dwell has earned, and
    /// the ceremony itself is not part of that clock.
    func testTheHeadStartOpensTheChamberClockWhereTheDwellSays() throws {
        // The clock is held at the threshold, however long the ceremony takes.
        let clock = RoomClock.held()
        XCTAssertTrue(clock.isHeld)
        XCTAssertEqual(clock.chamberTime(now: Date().timeIntervalSinceReferenceDate + 600), 0,
                       "the room adapted while he was still standing at its threshold")

        // …and it begins, once, where her dwell says.
        let dwell: TimeInterval = 400
        let opening = HomeMemory.headStart(dwell: dwell)
        XCTAssertEqual(opening, dwell * 0.55, accuracy: 1e-9)
        let begun: TimeInterval = 5_000
        clock.begin(opening: opening, at: begun)
        XCTAssertFalse(clock.isHeld)
        XCTAssertEqual(clock.chamberTime(now: begun), opening, accuracy: 1e-9)
        XCTAssertEqual(clock.chamberTime(now: begun + 12), opening + 12, accuracy: 1e-9)

        // Design's own thresholds, so a retuning is visible here.
        XCTAssertEqual(HomeMemory.headStart(dwell: 11), 0, "a glance is not a relationship")
        XCTAssertEqual(HomeMemory.headStart(dwell: 12), 12 * 0.55, accuracy: 1e-9)
        XCTAssertEqual(HomeMemory.headStart(dwell: HomeMemory.dwellCap),
                       HomeMemory.headStartCap, accuracy: 1e-9)
        XCTAssertEqual(HomeMemory.headStartCap, 221)

        // The still path draws the room's **opening** while he is at the
        // threshold and the settled room once he is in it. Handing a walker
        // with reduce motion on a fully-adapted room to cross toward would be
        // the end of a stay he has not begun.
        let waiting = RoomClock.held()
        XCTAssertEqual(waiting.stillInstant(), 0, accuracy: 1e-9,
                       "the still path adapted her room before he had entered it")
        waiting.begin(opening: opening, at: Date().timeIntervalSinceReferenceDate)
        XCTAssertEqual(waiting.stillInstant(), RoomClock.settled, accuracy: 1e-9)
        XCTAssertEqual(RoomClock(opening: 0).stillInstant(), RoomClock.settled, accuracy: 1e-9,
                       "an ordinary room's still path is no longer the settled state")

        // The rite carries the head start it was given, and does not derive one.
        let rite = RiteOfEntering(compression: 1, headStart: opening)
        XCTAssertEqual(rite.headStart, opening, accuracy: 1e-9)
        XCTAssertEqual(RiteOfEntering(compression: 1, headStart: -5).headStart, 0)

        // And the threshold opens the clock at exactly that, in one place.
        let view = try XCTUnwrap(LawSource.production("RiteOfEnteringView.swift"))
        let source = String(view.lexed.masked)
        let openings = Rx.all(#"\.begin\(opening:\s*[A-Za-z_][A-Za-z0-9_.]*"#, source)
        XCTAssertEqual(openings.count, 1, "the chamber clock is begun in more than one place")
        XCTAssertEqual(openings.first, ".begin(opening: rite.headStart",
                       """
                       the chamber clock is opened at something other than the head start her \
                       accumulated dwell earned.
                       """)
    }

    /// The compression and the head start are **read** from what her room
    /// remembers rather than worked out again at the threshold.
    func testTheCeremonyReadsHerMemoryRatherThanRecomputingIt() throws {
        let container = try ModelContainer(
            for: HomeMemory.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let store = HomeMemoryStore(context: ModelContext(container))

        // A room never stood in: the whole ceremony, opening at its beginning.
        let fresh = RiteOfEntering.toRoom(at: RiteFixture.garima, remembering: store)
        XCTAssertEqual(fresh.compression, 1)
        XCTAssertEqual(fresh.headStart, 0)

        // …and one that has been stood in, at length.
        store.record(khadgamalaPosition: RiteFixture.garima, dwell: 300)
        store.record(khadgamalaPosition: RiteFixture.garima, dwell: 300)
        let known = RiteOfEntering.toRoom(at: RiteFixture.garima, remembering: store)
        XCTAssertEqual(known.compression, store.compression(for: RiteFixture.garima), accuracy: 1e-12)
        XCTAssertEqual(known.headStart, store.headStart(for: RiteFixture.garima), accuracy: 1e-12)
        XCTAssertLessThan(known.compression, fresh.compression, "the ceremony did not soften")
        XCTAssertGreaterThan(known.headStart, 0, "the room did not open where his dwell earned")

        // Three beats all the same.
        var rite = known
        walk(&rite, from: 0)
        XCTAssertEqual(rite.struck, [.phrase, .written, .roots])
    }

    // MARK: - Her words, off her own row

    /// Every fall-back degrades to something true rather than to something
    /// invented (invariant 5).
    func testHerWordsComeOffHerRowAndDegradeToSomethingTrue() {
        let whole = garimaWords
        XCTAssertEqual(whole.appreciation, "Thank you for the weight that holds me here.")
        XCTAssertEqual(whole.written, "गरिमा")
        XCTAssertEqual(whole.roots, ["Guru", "imā"])
        XCTAssertEqual(whole.gloss, "Weightedness")

        // Nothing at all but a name and a ring: her āvaraṇa's gratitude, her
        // name in place of her Devanāgarī, and her name's own parts.
        let bare = RiteWords.compose(appreciationPhrase: nil,
                                     ringAppreciation: Avarana.appreciationPhrase(forRing: 4),
                                     devanagari: "",
                                     name: "Sarva-Yoni",
                                     etymology: nil,
                                     quality: "")
        XCTAssertEqual(bare.appreciation, Avarana.appreciationPhrase(forRing: 4))
        XCTAssertFalse(bare.appreciation.isEmpty, "the threshold went silent")
        XCTAssertEqual(bare.written, "Sarva-Yoni")
        XCTAssertEqual(bare.roots, ["Sarva", "Yoni"], "the app's own compound mark was not read")
        XCTAssertEqual(bare.gloss, "")

        // Design's morpheme peel, for a name carrying no mark.
        XCTAssertEqual(RiteWords.compoundParts(of: "Sarvaśaktimayī"), ["Sarva", "śakti", "mayī"])
        XCTAssertEqual(RiteWords.compoundParts(of: "Tripurā"), ["Tripurā"],
                       "a name whose parts are unknown must be shown whole, not guessed at")

        // **The suffix order is load-bearing, and it costs something.** Design
        // tries `ākarṣiṇī` before `karṣiṇī`, so the suffix comes away whole and
        // the *head* carries the elision of the sandhi: Kāma + ākarṣiṇī reads
        // `Kām · ākarṣiṇī`, not `Kāmā · karṣiṇī`. Re-sort the list and the
        // sixteen Karṣiṇīs split the other way. It is asserted rather than
        // inherited by accident, and it is the **fall-back** in any case — the
        // roots the walker actually sees come off her `etymology` field, which
        // the base carries for all 102.
        XCTAssertEqual(RiteWords.compoundParts(of: "Kāmākarṣiṇī"), ["Kām", "ākarṣiṇī"])
        XCTAssertEqual(RiteWords.nameSuffixes,
                       ["ākarṣiṇī", "karṣiṇī", "mayī", "pradā", "kāriṇī",
                        "sundarī", "mālinī", "eśvarī", "iṇī", "inī"],
                       "Design's suffix order decides where a name comes apart")
        XCTAssertEqual(RiteWords.roots(inEtymology: "Kāma + Ākarṣiṇī"), ["Kāma", "Ākarṣiṇī"],
                       "her own etymology, where the base gives one, is read before any peel")

        // The etymology is read as roots only when it is one — prose is refused
        // rather than chopped into half-sentences.
        XCTAssertEqual(RiteWords.roots(inEtymology: "Anaṅga + Kusuma"), ["Anaṅga", "Kusuma"])
        XCTAssertEqual(RiteWords.roots(inEtymology: "Sarva · Artha · Sādhikā"),
                       ["Sarva", "Artha", "Sādhikā"])
        XCTAssertNil(RiteWords.roots(inEtymology: "Garimā"))
        XCTAssertNil(RiteWords.roots(inEtymology: ""))
        XCTAssertNil(RiteWords.roots(inEtymology:
            "From guru, heavy — the weight that settles. It is not a burden."))
        XCTAssertNil(RiteWords.roots(inEtymology:
            "a very long root indeed that is really a clause + another"))
    }

    // MARK: - Nothing the rite can say measures him

    /// **Design's nine MEASURING patterns over the whole rite corpus**, for all
    /// 102 — the sixteen that genuinely ship and sync, and the rest driven off
    /// real vocabulary keyed by position.
    ///
    /// The detector is the harness's own `Measuring`, reused rather than copied:
    /// a second copy of nine regexes drifts, and a drifted detector is worse
    /// than none.
    func testNoStringTheRiteCanComposeMeasuresOutLoud() {
        var read = 0
        var offences: [String] = []

        for row in HomesCorpus.rows() {
            let words = riteWords(for: row)
            for string in words.all + [RitePrompt.goOn.words, RitePrompt.enter.words] {
                read += 1
                for pattern in Measuring.measuresOutLoud(string) {
                    offences.append("kp \(row.position) (\(row.provenance)) · \(pattern) · \(string)")
                }
            }
        }

        XCTAssertGreaterThanOrEqual(read, 102 * 4,
                                    "only \(read) strings were read — the rite corpus is not all 102")
        XCTAssertTrue(offences.isEmpty,
                      """
                      the threshold measures him out loud. The instrument may know everything about \
                      his walking and must display none of it.
                      \(offences.prefix(10).joined(separator: "\n"))
                      """)

        // The detector can fail.
        XCTAssertFalse(Measuring.measuresOutLoud("your progress · 3 of 9 · day 4").isEmpty,
                       "the measuring detector caught nothing in a string written to break it")
    }

    /// **The half the patterns cannot see.** "welcome back" carries no digit, so
    /// no measuring pattern will ever catch it; it is caught here, by refusing
    /// the rite's own authored vocabulary any word about returning.
    ///
    /// Her content is not in scope and must not be — it is the base's, and a
    /// Śakti whose phrase says *"Thank you for the hook that returns me"* is
    /// speaking about herself, not about him. What is in scope is every word
    /// these two files put in his way on their own account.
    func testTheRiteNeverSaysHeHasBeenHereBefore() throws {
        let returning: [(what: String, pattern: String)] = [
            ("a welcome",           #"(?i)\bwelcome\b"#),
            ("a return",            #"(?i)\breturn(s|ed|ing)?\b"#),
            ("a coming back",       #"(?i)\bback\b"#),
            ("an again",            #"(?i)\bagain\b"#),
            ("a before",            #"(?i)\bbefore\b"#),
            ("a standing here",     #"(?i)\bstood\b|\bhave\s+been\s+here\b"#),
            ("a visit",             #"(?i)\bvisit(s|ed|ing)?\b"#),
            ("a remembering",       #"(?i)\bremember(s|ed|ing)?\b"#),
            ("an already",          #"(?i)\balready\b"#),
            ("a last time",         #"(?i)\blast\s+time\b"#),
            ("an anew",             #"(?i)\bonce\s+more\b"#),
        ]

        var literals = 0
        var offences: [String] = []
        for name in ["RiteOfEntering.swift", "RiteOfEnteringView.swift"] {
            let file = try XCTUnwrap(LawSource.production(name), "\(name) is missing")
            for literal in file.lexed.literals {
                literals += 1
                for rule in returning where Rx.matches(rule.pattern, literal.shape) {
                    offences.append("\(file.path) · \(rule.what) · \(SwiftLexer.collapse(literal.shape))")
                }
            }
        }

        XCTAssertGreaterThanOrEqual(literals, 20,
                                    "only \(literals) literals were read from the rite — the scan is not reading it")
        XCTAssertTrue(offences.isEmpty,
                      """
                      the rite says out loud what it is only allowed to let him feel. The compression \
                      is the ceremony being quicker, and the head start is her room already open; \
                      neither is ever announced, and there is no line telling him he has been here.
                      \(offences.joined(separator: "\n"))
                      """)

        // The detector can fail.
        for planted in ["welcome back", "you have stood here before", "your 4th visit",
                        "here again", "she remembers you"] {
            XCTAssertTrue(returning.contains { Rx.matches($0.pattern, planted) },
                          "\"\(planted)\" slipped past the returning detector")
        }
        // …and it lets the ceremony's own words through.
        for allowed in [RitePrompt.goOn.words, RitePrompt.enter.words,
                        "Thank you for the weight that holds me here."] {
            XCTAssertFalse(returning.contains { Rx.matches($0.pattern, allowed) },
                           "false positive on \"\(allowed)\"")
        }
    }

    // MARK: - It arrives at a real room

    /// The rite is not a screen shown before a room: the room is underneath it
    /// the whole way, it is **her** room, and the walker is looking at it from
    /// further out until he arrives.
    func testTheRiteArrivesAtARealRoom() throws {
        let her = room()
        XCTAssertTrue(her.isBuilt, "Garimā's room did not resolve to a room of her own")
        XCTAssertEqual(her.position, RiteFixture.garima)

        let window = host(her)
        defer { teardown(window) }
        pump(seconds: 1.0)

        let view = try XCTUnwrap(sceneView(in: window), "the rite put no room on screen")
        let driver = try XCTUnwrap(view.delegate as? RoomDriver)
        XCTAssertEqual(driver.scene.room.position, RiteFixture.garima,
                       "the rite is standing in front of somebody else's room")
        XCTAssertEqual(driver.scene.solidsInHerLayer, 0)

        // He is outside it, looking in.
        let standing = try XCTUnwrap(view.pointOfView?.position.z)
        XCTAssertGreaterThan(Double(standing), RoomUnits.eyeZ + 1e-3,
                             "the rite opens with the walker already standing in her room")
        XCTAssertLessThanOrEqual(Double(standing),
                                 RoomUnits.eyeZ + RoomUnits.approachStandOff + 1e-3)

        // **Her stay has not begun and the air is moving anyway.** The room is
        // posed at its own opening the whole crossing — it has not adapted,
        // because he has not been in it — while the enclosure's weather runs on
        // the world's clock, which is not hers and does not wait at her door.
        XCTAssertEqual(driver.scene.posedAt, 0, accuracy: 1e-9,
                       "her room adapted while he was still crossing toward it")
        XCTAssertGreaterThan(driver.scene.breathedAt, 0,
                             """
                             the air stood perfectly still for the whole ceremony. The weather is \
                             continuous and it follows him into her room; holding her chamber clock \
                             must not hold the āvaraṇa's.
                             """)
        let air = driver.scene.breathedAt
        pump(seconds: 0.4)
        XCTAssertGreaterThan(driver.scene.breathedAt, air, "the air stopped moving")

        // And what he is looking at is a lit room rather than a black frame —
        // the geometry half, which is the half a machine can judge.
        let image = try XCTUnwrap(driver.scene.capture(size: CGSize(width: 240, height: 480),
                                                       atSceneTime: 0))
        let light = Self.meanLuminance(of: image)
        XCTAssertGreaterThan(light, 0.004, "the room the rite arrives at renders black")
        XCTAssertLessThan(light, 0.9, "the room the rite arrives at is blown out")
    }

    // MARK: - Helpers

    /// A rite corpus row: her four rite fields, keyed off position and composed
    /// from real vocabulary, never copied from a card.
    private func riteWords(for row: HomesCorpus.Row) -> RiteWords {
        let stem = row.tattva.components(separatedBy: CharacterSet(charactersIn: " (—·"))
            .first.flatMap { $0.isEmpty ? nil : $0 } ?? "Sā"
        let name: String
        switch row.position % 3 {
        case 0:  name = "Sarva-\(stem)"                 // the app's own compound mark
        case 1:  name = "Sarva\(stem)kāriṇī"            // Design's morpheme peel
        default: name = stem                             // no parts to find at all
        }
        return RiteWords.compose(
            appreciationPhrase: row.position % 4 == 0
                ? nil : "Thank you for the \(stem.lowercased()) that asks nothing of me.",
            ringAppreciation: Avarana.appreciationPhrase(forRing: row.ring),
            devanagari: row.position % 5 == 0 ? nil : "सर्व",
            name: name,
            etymology: row.position % 3 == 0
                ? "Sarva + \(stem)"
                : (row.position % 3 == 1 ? "From \(stem.lowercased()), the whole of it — hers." : nil),
            quality: row.quality)
    }

    private var retained: UIWindow?

    private func host(_ her: HomeRoom) -> UIWindow {
        let rite = RiteOfEnteringView(room: her,
                                      words: garimaWords,
                                      syllable: nil,
                                      compression: 1)
        let controller = UIHostingController(rootView: rite.statusBarHidden(true))
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
        retained = window
        return window
    }

    private func teardown(_ window: UIWindow) {
        window.isHidden = true
        window.rootViewController = nil
        if retained === window { retained = nil }
    }

    private func pump(seconds: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(seconds))
    }

    private func sceneView(in window: UIWindow) -> SCNView? {
        func walk(_ view: UIView) -> SCNView? {
            if let found = view as? SCNView { return found }
            for child in view.subviews {
                if let found = walk(child) { return found }
            }
            return nil
        }
        guard let root = window.rootViewController?.view else { return nil }
        return walk(root)
    }

    private static func meanLuminance(of image: CGImage) -> Double {
        let width = image.width, height = image.height
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        guard let context = CGContext(data: &pixels, width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: width * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return 0 }
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        var total = 0.0
        var counted = 0
        for y in stride(from: 0, to: height, by: 4) {
            for x in stride(from: 0, to: width, by: 4) {
                let offset = (y * width + x) * 4
                total += (0.2126 * Double(pixels[offset])
                          + 0.7152 * Double(pixels[offset + 1])
                          + 0.0722 * Double(pixels[offset + 2])) / 255
                counted += 1
            }
        }
        return counted == 0 ? 0 : total / Double(counted)
    }
}

/// The room the rite is judged at: Garimā, khaḍgamālā position 4, whose spike
/// room is the proven one. Outside the class because it stands in a default
/// argument, which is evaluated where the call is rather than where the class is.
private enum RiteFixture {
    static let garima = 4
}
