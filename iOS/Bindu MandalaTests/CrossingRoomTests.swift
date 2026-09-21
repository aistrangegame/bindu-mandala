import XCTest
import SwiftUI
import SceneKit
import UIKit
@testable import Bindu_Mandala

// MARK: - RING 2 · the sixteen crossings
//
// The home ring, and the one ring in the instrument whose rows are **real**:
// the sixteen Karṣiṇīs ship inside the binary and sync from the base, so every
// check here is asked of her actual quality, tattva, bodily location and bīja
// rather than of a card typed out in a test. `HomesCorpus` says which half of
// the 102 a row came from, and every row below answers `real`.
//
// What is being held:
//
//   1. all sixteen reach a built crossing, **by position**, and nobody else does
//   2. each is legible at both adaptations, on a real offscreen render
//   3. every one of the 120 pairs diverges above Design's tenth, on geometry
//   4. no two share a physics kind and a phase and an altitude
//   5. each reverses its own premise — the two halves are apart, and then one
//   6. no solid stands in any of the sixteen her-layers
//   7. the five cluster hues separate the five sub-families
//   8. reduce motion arrives at the settled room, reversed, without animating
@MainActor
final class CrossingRoomTests: XCTestCase {

    /// Big enough that a mark is several pixels across, small enough that
    /// sixteen rooms at two adaptations are seconds rather than minutes.
    private static let captureSize = CGSize(width: 320, height: 640)

    private static let firstAdaptation = HomeMemory.firstAdaptation
    private static let pastTheSecond = HomeMemory.secondAdaptationEnd

    /// The sixteen, resolved from the rows the app actually ships.
    private func karsinis() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        let rows = HomesCorpus.karsiniRows()
        XCTAssertEqual(rows.count, 16, "the shipped Ring 2 roster is not sixteen rows")
        XCTAssertTrue(rows.allSatisfy(\.isReal), "a Ring 2 row came from the synthetic half")
        return rows.compactMap { row in
            guard let room = HomeRooms.resolve(position: row.position, ring: row.ring,
                                               tattva: row.tattva, quality: row.quality,
                                               bodilyLocation: row.bodilyLocation,
                                               bija: row.bija) else {
                XCTFail("khaḍgamālā \(row.position) resolved to no room at all")
                return nil
            }
            return (row, room)
        }
    }

    private func crossing(_ room: HomeRoom) -> CrossingRoom? {
        RoomMechanisms.forRoom(room) as? CrossingRoom
    }

    // MARK: - 1 · all sixteen, by position

    /// **Every Karṣiṇī reaches the crossing, and she reaches it by position.**
    ///
    /// The whole of law 1 at this layer: the dispatch reads the archetype the
    /// resolution order decided from her ring and her position, and there is no
    /// name anywhere on the path. Held from both ends — all sixteen of 29…44
    /// arrive, and none of the other eighty-six does.
    func testEveryKarsiniReachesTheCrossingByPosition() {
        var reached: [Int] = []
        for (row, room) in karsinis() {
            guard let built = crossing(room) else {
                XCTFail("khaḍgamālā \(row.position) did not reach a built crossing")
                continue
            }
            XCTAssertEqual(built.position, row.position,
                           "the crossing at khaḍgamālā \(row.position) believes it is somebody else")
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            reached.append(row.position)
        }
        XCTAssertEqual(reached, Array(29...44))

        // …and nobody outside the sixteen.
        var strangers: [Int] = []
        for (row, room) in HomesCorpus.resolvedRooms() where !(29...44).contains(row.position) {
            if crossing(room) != nil { strangers.append(row.position) }
        }
        XCTAssertTrue(strangers.isEmpty,
                      """
                      \(strangers) reached Ring 2's room without standing in Ring 2. The dispatch \
                      has stopped being decided by position.
                      """)

        // The key is Design's, and it is one room.
        let keys = karsinis().filter { crossing($0.room)?.isKey == true }.map(\.row.position)
        XCTAssertEqual(keys, [CrossingRoom.keyPosition],
                       "the key pairing is khaḍgamālā 44 and no other seat")
    }

    /// **The ordering finding, on the rows that actually ship.**
    ///
    /// Every one of the sixteen says "she who attracts", so every one of them
    /// trips the classifier's twelfth rule — two behind the five elements. Which
    /// means the five whose tattva names an element, and the eight more that
    /// share those elements, are claimed by their **tattva**, and only the three
    /// whose tattva the classifier has no element for are left holding the ring's
    /// own drawing. Recorded as behaviour so a re-sort of the fifty rules shows
    /// up here as well as in `testTheRuleOrderIsLoadBearing`.
    func testHerTattvaIsWhatClaimsHer() {
        let expected: [Int: HomePhysics] = [
            29: .flare, 34: .flare, 41: .flare,      // Fire
            30: .lift,  33: .lift,                   // Air
            31: .open,  32: .open,  40: .open,       // Space
            35: .well,  39: .well,                   // Water
            36: .settle, 38: .settle, 44: .settle,   // Earth
            37: .draw,  42: .draw,  43: .draw,       // no element — the drawing itself
        ]
        for (row, room) in karsinis() {
            guard case .grammar(let reading) = room.kind else {
                XCTFail("khaḍgamālā \(row.position) carries no reading")
                continue
            }
            XCTAssertEqual(reading.archetype, .crossed)
            XCTAssertEqual(reading.physics, expected[row.position],
                           """
                           khaḍgamālā \(row.position) (\(row.tattva)) classifies as \
                           \(reading.physics.rawValue). Her tattva is what claims her, and the \
                           ordering is Design's.
                           """)
            // Her quality alone really does reach the drawing — that is the
            // finding, stated rather than assumed.
            XCTAssertEqual(HomeGrammar.physics(tattva: "", quality: row.quality), .draw,
                           "khaḍgamālā \(row.position)'s quality no longer says she attracts")
        }
    }

    // MARK: - 2 · legible, at both adaptations

    /// **None of the sixteen renders black and none blows out.**
    ///
    /// Design's first legibility register, on the ring the walker stands in most.
    /// Its own verification pass found five rooms rendering dark and one white,
    /// and every one of those was an authoring defect a luminance floor catches
    /// the same day.
    func testAllSixteenAreLegibleAtBothAdaptations() throws {
        for (row, room) in karsinis() {
            let scene = RoomScene(room: room)
            for (when, t) in [("the first adaptation", Self.firstAdaptation),
                              ("past the second", Self.pastTheSecond)] {
                guard let image = scene.capture(size: Self.captureSize, atSceneTime: t) else {
                    return XCTFail("khaḍgamālā \(row.position) could not be rendered offscreen")
                }
                let spread = Self.luminance(of: image)
                print("RING2_LEGIBILITY {\"kp\":\(row.position),\"when\":\"\(when)\","
                      + String(format: "\"mean\":%.4f,\"min\":%.4f,\"max\":%.4f,\"saturated\":%.4f}",
                               spread.mean, spread.low, spread.high, spread.saturated))
                XCTAssertGreaterThan(spread.mean, 0.01,
                                     "khaḍgamālā \(row.position), \(when): the room rendered black")
                XCTAssertLessThan(spread.mean, 0.9,
                                  "khaḍgamālā \(row.position), \(when): the room blew out to white")
                XCTAssertLessThan(spread.saturated, 0.25,
                                  """
                                  khaḍgamālā \(row.position), \(when): \
                                  \(Int(spread.saturated * 100))% of the frame is at white. Fourteen \
                                  marks that all converge on one point is exactly how Design's own \
                                  Laghimā stacked to an unreadable field.
                                  """)
                XCTAssertGreaterThan(spread.high - spread.low, 0.02,
                                     """
                                     khaḍgamālā \(row.position), \(when): the render is flat — nothing \
                                     for a raking light to fall across.
                                     """)
            }
        }
    }

    // MARK: - 3 · the sister-divergence check, on geometry

    /// **All one hundred and twenty pairs, above Design's tenth.**
    ///
    /// This is the check the Design thread records failing on it — *78 of 102
    /// rooms fell to one generic physics* — and it is the first time it can be
    /// asked of real geometry rather than of the grammar underneath it, because
    /// until Phase 3.1 there was no geometry to ask. It is asked here of every
    /// pair in the ring rather than of adjacent sisters only: sixteen rooms is
    /// one hundred and twenty pairs, and a ring where only the neighbours differ
    /// is a ring with two rooms in it.
    func testEveryPairOfTheSixteenDivergesOnGeometry() {
        let prints = karsinis().map { (kp: $0.row.position, print: CrossingFingerprint.of($0.room)) }
        XCTAssertEqual(prints.count, 16)
        let width = prints[0].print.count
        XCTAssertGreaterThan(width, 100, "the fingerprint reads too little of the room to mean anything")
        for entry in prints {
            XCTAssertEqual(entry.print.count, width,
                           "khaḍgamālā \(entry.kp) fingerprints to a different width")
        }

        var blurred: [String] = []
        var closest = (pair: "—", divergence: Double.infinity)
        var pairs = 0
        for (index, a) in prints.enumerated() {
            for b in prints[(index + 1)...] {
                pairs += 1
                let d = CrossingFingerprint.divergence(a.print, b.print)
                if d < closest.divergence {
                    closest = ("kp \(a.kp) ↔ kp \(b.kp)", d)
                }
                if d <= CrossingFingerprint.threshold {
                    blurred.append("kp \(a.kp) ↔ kp \(b.kp) — divergence "
                                   + String(format: "%.3f", d))
                }
            }
        }
        XCTAssertEqual(pairs, 120, "sixteen rooms is one hundred and twenty pairs")
        print("RING2_DIVERGENCE {\"pairs\":\(pairs),\"components\":\(width),"
              + "\"closest\":\"\(closest.pair)\","
              + String(format: "\"divergence\":%.4f}", closest.divergence))
        XCTAssertTrue(blurred.isEmpty,
                      """
                      \(blurred.count) pair(s) of the sixteen build rooms that blur into one \
                      another. Could this room belong to any other Śakti? Fix the room; never \
                      lower the threshold.
                      \(blurred.joined(separator: "\n"))
                      """)

        // **And the measure is not being passed by dilution.** A component that
        // reads the same in all sixteen rooms distinguishes nobody, and enough of
        // them would drag every real difference under the tenth while the check
        // went on saying green. The same reasoning `HomesHarnessTests` applies
        // one component at a time, applied to the whole print.
        let silent = (0..<width).filter { index in
            Set(prints.map { $0.print[index] }).count == 1
        }
        print("RING2_FINGERPRINT {\"components\":\(width),\"silent\":\(silent.count)}")
        XCTAssertLessThan(Double(silent.count) / Double(width), 0.5,
                          """
                          \(silent.count) of \(width) fingerprint components are the same in all \
                          sixteen rooms. The print has become mostly padding, and the tenth it is \
                          measured against no longer means what Design meant by it.
                          """)
    }

    /// The kernel never reaches further than ``CrossingRoom/kernelWidest`` times
    /// the amplitude it is handed, on any axis, for any of the fifty-one kinds.
    /// The crossing normalises its depth against that number; a kind that reached
    /// further would rail every mark in the ring, silently.
    func testTheKernelNeverExceedsItsWidestTerm() {
        var widest = 0.0
        var by = HomePhysics.breathe
        for kind in HomePhysics.allCases {
            for step in 0...600 {
                let t = Double(step) * 0.37
                for phase in stride(from: 0.0, to: 1.0, by: 0.125) {
                    let o = HomeGrammar.displace(kind, time: t, phase: phase, amplitude: 1)
                    let reach = max(abs(o.x), max(abs(o.y), abs(o.z)))
                    if reach > widest { widest = reach; by = kind }
                }
            }
        }
        print("RING2_KERNEL {\"widest\":" + String(format: "%.4f", widest)
              + ",\"kind\":\"\(by.rawValue)\"}")
        XCTAssertLessThanOrEqual(widest, CrossingRoom.kernelWidest + 1e-9,
                                 """
                                 \(by.rawValue) reaches \(widest) times its amplitude, past the \
                                 \(CrossingRoom.kernelWidest) the crossing normalises against. Every \
                                 mark of that physics would rail at full depth and stop carrying her \
                                 phase.
                                 """)
        XCTAssertGreaterThan(widest, CrossingRoom.kernelWidest * 0.9,
                             "the normaliser is far above anything the kernel does — it is not a reading")
    }

    /// The threshold has teeth, and a room cannot diverge from itself.
    func testTheDivergenceMeasureBites() {
        let a = (0..<20).map { "component \($0)" }
        XCTAssertEqual(CrossingFingerprint.divergence(a, a), 0)
        var oneApart = a; oneApart[3] = "elsewhere"
        XCTAssertLessThanOrEqual(CrossingFingerprint.divergence(a, oneApart),
                                 CrossingFingerprint.threshold)
        var threeApart = oneApart; threeApart[7] = "and"; threeApart[11] = "again"
        XCTAssertGreaterThan(CrossingFingerprint.divergence(a, threeApart),
                             CrossingFingerprint.threshold)
        XCTAssertEqual(CrossingFingerprint.divergence([], []), 0)
    }

    // MARK: - 4 · no two stand alike

    /// **No two of the sixteen share a physics kind and a phase and an
    /// altitude** — the three channels the grammar tunes the archetype through.
    ///
    /// The margin is printed as well as asserted, because the interesting case is
    /// the pair that shares two of the three: Dhairyā at the spine and Śarīrā at
    /// the whole body are both Earth and both stand at the body's middle, and
    /// what separates them is her turn of the sixteen, her attribute, her cluster
    /// and — at kp 44 alone — Design's key.
    func testNoTwoOfTheSixteenStandAlike() {
        var seen: [String: Int] = [:]
        var sharingTwo: [String] = []
        var readings: [(kp: Int, r: HomeGrammar.Reading)] = []
        for (row, room) in karsinis() {
            guard case .grammar(let reading) = room.kind else { continue }
            readings.append((row.position, reading))
            let key = [reading.physics.rawValue,
                       String(format: "%.6f", reading.phase ?? -1),
                       String(format: "%.4f", reading.bodyAltitude)].joined(separator: "|")
            if let already = seen[key] {
                XCTFail("khaḍgamālā \(row.position) stands exactly where khaḍgamālā \(already) does")
            }
            seen[key] = row.position
        }
        XCTAssertEqual(seen.count, 16)

        for (index, a) in readings.enumerated() {
            for b in readings[(index + 1)...] where a.r.physics == b.r.physics
            && abs(a.r.bodyAltitude - b.r.bodyAltitude) < 1e-9 {
                sharingTwo.append("kp \(a.kp) ↔ kp \(b.kp) — \(a.r.physics.rawValue) at "
                                  + String(format: "%.2f", a.r.bodyAltitude))
                XCTAssertNotEqual(a.r.phase, b.r.phase)
            }
        }
        print("RING2_STANDING {\"sharingPhysicsAndAltitude\":\(sharingTwo.count),"
              + "\"pairs\":\"\(sharingTwo.joined(separator: " · "))\"}")

        // Her altitude actually carries something across the ring. Before the
        // zone vocabulary reached the words the base writes, eleven of the
        // sixteen sat at the body's exact middle — which is her mark at one
        // height in eleven of the home ring's rooms.
        let altitudes = Set(readings.map { String(format: "%.4f", $0.r.bodyAltitude) })
        XCTAssertGreaterThanOrEqual(altitudes.count, 10,
                                    """
                                    the sixteen stand at only \(altitudes.count) heights between \
                                    them. Altitude is one of the four channels that make a room \
                                    hers, and it has stopped carrying anything.
                                    """)
    }

    /// The body vocabulary reaches the words the shipped rows actually write.
    /// Each of these is a row in `ShaktiBootstrap`, and each used to fall to the
    /// middle of the body.
    func testTheZoneVocabularyReadsTheRowsTheAppShips() {
        let expected: [(String, Double)] = [
            ("head", 0.22), ("temples", 0.23), ("nose", 0.28), ("ears", 0.3),
            ("tongue", 0.34), ("solar", 0.6), ("sacrum", 0.8),
        ]
        for (word, altitude) in expected {
            XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: word), altitude, accuracy: 1e-12,
                           "\"\(word)\" sits at the wrong height")
        }
        // Design's own eleven are untouched: nothing appended can shadow them.
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: "forehead"), 0.2, accuracy: 1e-12,
                       "\"forehead\" now reaches the appended `head` rule — the order has moved")
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: "above the head"), 0.1, accuracy: 1e-12)
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: "Solar plexus, shoulders"), 0.6,
                       accuracy: 1e-12)
        // …and `skin` is still the middle, which is the honest answer for a
        // Śakti felt wherever skin meets world.
        XCTAssertEqual(HomeGrammar.bodyAltitude(bodilyLocation: "skin"), 0.5, accuracy: 1e-12)
    }

    // MARK: - 5 · each reverses its own premise

    /// **The two halves are apart, and then they are one.**
    ///
    /// The crossing's own reversal, measured rather than asserted: the distance
    /// between the near half and the far half, in the surface's own coordinates,
    /// while the eye is still settling and once the premise has turned.
    func testTheTwoHalvesAreApartAndThenOne() {
        for (row, room) in karsinis() {
            guard let built = crossing(room) else { continue }
            let apart = Self.halfSeparation(built, room: room, at: Self.firstAdaptation)
            let one = Self.halfSeparation(built, room: room, at: Self.pastTheSecond)
            print("RING2_CROSSING {\"kp\":\(row.position),"
                  + String(format: "\"apartAtFirst\":%.4f,\"apartPastSecond\":%.6f}", apart, one))
            XCTAssertGreaterThan(apart, 0.01,
                                 """
                                 khaḍgamālā \(row.position): the two halves are already together at \
                                 the first adaptation. There is no counterpoint, so there is nothing \
                                 for the second adaptation to resolve.
                                 """)
            XCTAssertLessThan(one, apart * 0.05,
                              """
                              khaḍgamālā \(row.position): the far half has not converged. The drawing \
                              and the drawn are still two things past the second adaptation.
                              """)
        }
    }

    /// And the room's own premise turns with them: the enclosure the far half
    /// became leaves, and it leaves furthest at the key pairing.
    func testTheEnclosureAnswersAndTheKeyGoesFurthest() {
        var departures: [Int: Double] = [:]
        for (row, room) in karsinis() {
            guard let built = crossing(room) else { continue }
            XCTAssertTrue(built.becoming.isAReversal,
                          "khaḍgamālā \(row.position) does not reverse — her room is a loop")
            let parts = RoomReversal.resolved(built.becoming, bodyAltitude: room.bodyAltitude)
            XCTAssertNotEqual(parts.premise, parts.answer,
                              "khaḍgamālā \(row.position) answers her premise with itself")

            let scene = RoomScene(room: room)
            scene.pose(at: 0)
            XCTAssertEqual(scene.stood.values.map(abs).max() ?? 0, 0, accuracy: 1e-12,
                           "khaḍgamālā \(row.position) has already reversed at the opening")
            scene.pose(at: Self.pastTheSecond)
            XCTAssertGreaterThan(scene.enclosureRose, 0.05,
                                 """
                                 khaḍgamālā \(row.position): the enclosure did not leave. Design's far \
                                 half grows until it is the room around him, and here it is the room \
                                 that answers.
                                 """)
            XCTAssertEqual(scene.solidsInHerLayer, 0)
            departures[row.position] = scene.enclosureRose
        }
        let key = try? XCTUnwrap(departures[CrossingRoom.keyPosition])
        for (kp, rose) in departures.sorted(by: { $0.key < $1.key })
        where kp != CrossingRoom.keyPosition {
            XCTAssertGreaterThan(key ?? 0, rose,
                                 """
                                 khaḍgamālā \(kp)'s enclosure goes as far as the key pairing's. \
                                 Design marks khaḍgamālā 44 as the key and gives it the larger \
                                 growth; if the ring is flat here, `isKey` has stopped reaching \
                                 the room.
                                 """)
        }
    }

    /// **Her words turn too, and they turn into her own.**
    ///
    /// Fifteen of the sixteen used to say the same sentence at the one moment the
    /// room reverses. The crossing is now read off her row — the faculty out of
    /// her quality, the thing she is given out of her tattva — so the reversal is
    /// hers, and the key pairing keeps Design's authored line.
    func testEachCrossingSaysHerOwnReversal() {
        var deep: [String: Int] = [:]
        for (row, room) in karsinis() {
            guard let label = room.label else {
                XCTFail("khaḍgamālā \(row.position) has no words")
                continue
            }
            XCTAssertNotEqual(label.near, label.deep)
            XCTAssertFalse(label.deep.isEmpty)
            print("RING2_WORDS {\"kp\":\(row.position),\"deep\":\"\(label.deep)\"}")
            if let already = deep[label.deep] {
                XCTFail("""
                        khaḍgamālā \(row.position) and khaḍgamālā \(already) both say \
                        "\(label.deep)" once the premise reverses.
                        """)
            }
            deep[label.deep] = row.position
        }
        XCTAssertGreaterThanOrEqual(deep.count, 15,
                                    "the sixteen reversals speak with \(deep.count) voices")

        // Design's authored line at the key, and its own fallback where the row
        // genuinely carries no crossing: Cittā draws consciousness and is given
        // Pure Consciousness, which is one word twice rather than a crossing.
        let byPosition = Dictionary(uniqueKeysWithValues: karsinis().map { ($0.row.position, $0.room) })
        XCTAssertEqual(byPosition[44]?.label?.deep, "body and mind were one point")
        XCTAssertEqual(byPosition[37]?.label?.deep, "the drawing and the drawn are one")
        XCTAssertEqual(byPosition[33]?.label?.deep, "the touch and the air were one")

        // And nothing in any of it measures the walker.
        for (_, room) in karsinis() {
            for words in [room.label?.near ?? "", room.label?.deep ?? ""] {
                XCTAssertNil(words.rangeOfCharacter(from: .decimalDigits),
                             "a room's words carry a number: \"\(words)\"")
            }
        }
    }

    /// The readers the words are composed from, on the rows as the base writes
    /// them and on Design's cards, which write the same fact the other way round.
    func testTheCrossingIsReadFromHerRowAndNotFromATable() {
        XCTAssertEqual(HomeGrammar.drawnFaculty(from: "She who attracts Touch"), "touch")
        XCTAssertEqual(HomeGrammar.drawnFaculty(from: "She who attracts the I-sense"), "i-sense")
        XCTAssertEqual(HomeGrammar.drawnFaculty(from: "Kāma"), "kāma")
        XCTAssertEqual(HomeGrammar.givenTattva(from: "Earth (Pṛthivī)"), "earth")
        XCTAssertEqual(HomeGrammar.givenTattva(from: "Pṛthivī — earth"), "pṛthivī")
        XCTAssertEqual(HomeGrammar.givenTattva(from:
            "Pāyu — release, elimination. Self-recognition comes through letting go."), "pāyu")
        XCTAssertNil(HomeGrammar.crossing(quality: "She who attracts Consciousness",
                                          tattva: "Pure Consciousness (Cit)"),
                     "a faculty answered by itself is not a crossing")
        XCTAssertNil(HomeGrammar.crossing(quality: "She who attracts Touch", tattva: ""),
                     "a blank tattva is guarded, never assumed")
    }

    // MARK: - 6 · no solid, anywhere in the ring

    /// The binding condition over the whole ring, in the live graph and in the
    /// verbs. Fourteen marks a room and every one of them is something happening
    /// to the room's own stone.
    func testNoCrossingMountsASolidInHerLayer() {
        var verbs: Set<SurfaceVerb> = []
        for (row, room) in karsinis() {
            let scene = RoomScene(room: room)
            for t in [0.0, Self.firstAdaptation, HomeMemory.holdEnd, Self.pastTheSecond] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               "khaḍgamālā \(row.position): a geometry appeared under her own layer")
            }
            XCTAssertGreaterThan(scene.childCount(in: .her), 0,
                                 "khaḍgamālā \(row.position): the light in her mark is missing")

            guard let built = crossing(room) else { continue }
            for t in stride(from: 0.0, through: Self.pastTheSecond, by: 20) {
                let stage = Self.stage(room: room, at: t)
                let actions = built.actions(at: t, stage: stage)
                // The enclosure is never marked: a wall is not where a body is
                // felt, and Design never marks one.
                XCTAssertNil(actions[.wall],
                             "khaḍgamālā \(row.position) marked the enclosure")
                let onHers = actions[stage.placement.surface] ?? []
                XCTAssertEqual(onHers.count, CrossingRoom.marksPerHalf * 2,
                               """
                               khaḍgamālā \(row.position) put \(onHers.count) marks on her working \
                               surface; the crossing is seven a side.
                               """)
                onHers.forEach { verbs.insert($0.verb) }
            }
        }
        XCTAssertGreaterThanOrEqual(verbs.count, 3,
                                    """
                                    the whole ring acts through \(verbs.count) of the five verbs \
                                    (\(verbs.map(\.rawValue).sorted())). The verb is supposed to be \
                                    read from each half's own travel; if only one comes back, the \
                                    reading has collapsed and every room is doing the same thing.
                                    """)
        print("RING2_VERBS {\"verbs\":\"\(verbs.map(\.rawValue).sorted().joined(separator: ","))\"}")
    }

    /// **A mark has to stand clear of the stone's own grain.**
    ///
    /// The room gives its surfaces a low relief *"so a raking light has something
    /// to fall across"*, a fortieth of a body high. A crossing whose marks are
    /// shallower than that is seven rings pressed into a wall that already has
    /// seven hundred of its own, and looking at it says so at once: before the
    /// crossing's lengths were read against the body rather than against the
    /// surface, every mark in the ring was under the grain and the rooms came
    /// back as bare stone.
    func testHerMarksStandClearOfTheStonesOwnGrain() {
        for (row, room) in karsinis() {
            guard let built = crossing(room) else { continue }
            let stage = Self.stage(room: room, at: Self.firstAdaptation)
            guard let material = stage.materials[stage.placement.surface] else { continue }
            let marks = built.actions(at: Self.firstAdaptation, stage: stage)[stage.placement.surface] ?? []
            let deepest = marks.map(\.depth).max() ?? 0
            let widest = marks.map(\.reach).max() ?? 0
            XCTAssertGreaterThan(deepest, material.grainRelief,
                                 """
                                 khaḍgamālā \(row.position): her deepest mark is \(deepest) and the \
                                 stone's own grain stands \(material.grainRelief). Nothing she does \
                                 can be seen.
                                 """)
            XCTAssertLessThanOrEqual(deepest, RoomInscription.markDepth + 1e-9,
                                     """
                                     khaḍgamālā \(row.position) digs past one mark's worth. The room \
                                     is not a quarry, and fourteen marks do not get fourteen answers \
                                     to how deep anything may go.
                                     """)
            // …and wide enough that the mesh can carry it: the surface is meshed
            // at 64 a side, so a mark narrower than a cell is a mark with no
            // vertices in it.
            XCTAssertGreaterThan(widest, 1 / Double(RoomScene.resolution),
                                 "khaḍgamālā \(row.position)'s marks are narrower than one mesh cell")
        }
    }

    // MARK: - 7 · the five cluster hues

    /// **The five sub-families are five lights.**
    ///
    /// Ring 2 is the only ring in the 102 whose seats carry a real cluster, and
    /// `Atmosphere` already holds the five hues. This asks whether they reach the
    /// room: a sister's light is her cluster's seed jittered ±7° off her own
    /// position, so sisters of a cluster share a light and the five clusters do
    /// not.
    func testTheFiveClusterHuesSeparateTheFiveSubFamilies() {
        var byCluster: [Cluster: [(kp: Int, hue: Double)]] = [:]
        for (row, room) in karsinis() {
            guard let cluster = room.gem.cluster else {
                XCTFail("khaḍgamālā \(row.position) carries no cluster — the lotus's seats all do")
                continue
            }
            byCluster[cluster, default: []].append((row.position, room.gem.hue.h))
        }
        XCTAssertEqual(Set(byCluster.keys), Set(Cluster.allCases),
                       "the sixteen do not cover the five sub-families")
        XCTAssertEqual(byCluster.mapValues(\.count),
                       [.inner: 3, .tanmatra: 5, .citta: 1, .stability: 4, .selfBody: 3],
                       "the sub-families are not the five the base divides the lotus into")

        // Within a cluster: the same seed, ±7° of her own position and no more.
        for (cluster, seats) in byCluster {
            let seed = Atmosphere.clusterHue(cluster).h
            for seat in seats {
                let off = abs(Self.hueDistance(seat.hue, seed))
                XCTAssertLessThanOrEqual(off, HomeGem.jitterRange / 2 + 1e-9,
                                         """
                                         khaḍgamālā \(seat.kp) is \(off)° off her cluster's seed. \
                                         Her light is her sub-family's, jittered by her position.
                                         """)
            }
        }

        // Across clusters: no seat of one is nearer another cluster's seed than
        // its own, so the five families genuinely separate in the light.
        for (cluster, seats) in byCluster {
            let mine = Atmosphere.clusterHue(cluster).h
            for other in Cluster.allCases where other != cluster {
                let theirs = Atmosphere.clusterHue(other).h
                for seat in seats {
                    XCTAssertLessThan(abs(Self.hueDistance(seat.hue, mine)),
                                      abs(Self.hueDistance(seat.hue, theirs)),
                                      """
                                      khaḍgamālā \(seat.kp) is closer to \(other)'s light than to \
                                      \(cluster)'s. The jitter has grown past the distance between \
                                      two sub-families.
                                      """)
                }
            }
        }
        print("RING2_CLUSTERS {\"families\":\(byCluster.count),"
              + "\"seeds\":\"\(Cluster.allCases.map { String(format: "%.0f", Atmosphere.clusterHue($0).h) }.joined(separator: ","))\"}")
    }

    // MARK: - 8 · reduce motion

    /// **The still path arrives at the settled crossing, reversed, and never
    /// animates.** Asked of a Karṣiṇī rather than of the spine's own example,
    /// because the thing that has to survive the still path in this ring is the
    /// convergence: a room posed once must be posed at the moment the two halves
    /// are already one.
    func testReduceMotionReachesTheSettledCrossingWithoutAnimating() {
        guard let entry = karsinis().first(where: { $0.row.position == CrossingRoom.keyPosition })
        else { return XCTFail("the key pairing did not resolve") }

        let view = RoomView(room: entry.room, clock: RoomClock(opening: 0), forceReduceMotion: true)
        let controller = UIHostingController(rootView: view.statusBarHidden(true))
        controller.view.backgroundColor = .black
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        let window = scene.map { UIWindow(windowScene: $0) } ?? UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert + 1
        window.rootViewController = controller
        window.makeKeyAndVisible()
        defer { window.isHidden = true; window.rootViewController = nil }

        RunLoop.current.run(until: Date().addingTimeInterval(1.5))
        func walk(_ view: UIView) -> SCNView? {
            if let found = view as? SCNView { return found }
            for child in view.subviews {
                if let found = walk(child) { return found }
            }
            return nil
        }
        guard let root = controller.view, let sceneView = walk(root),
              let driver = sceneView.delegate as? RoomDriver else {
            return XCTFail("the crossing did not put an SCNView on screen")
        }
        XCTAssertFalse(sceneView.isPlaying, "reduce motion must stop the scene clock")
        XCTAssertFalse(sceneView.rendersContinuously)
        let posed = driver.posesApplied
        RunLoop.current.run(until: Date().addingTimeInterval(1.0))
        XCTAssertEqual(driver.posesApplied, posed,
                       "the crossing was posed again with reduce motion on")

        // And what it is still at is the settled crossing: the premise reversed,
        // the enclosure gone, and the two halves already one.
        let settled = RoomPose(sceneTime: RoomClock.settled, room: entry.room)
        XCTAssertEqual(settled.deep, 1, accuracy: 1e-9)
        guard let built = crossing(entry.room) else { return XCTFail("no crossing") }
        XCTAssertLessThan(Self.halfSeparation(built, room: entry.room, at: RoomClock.settled), 1e-6,
                          "the still room stopped before the drawing and the drawn were one")
        XCTAssertGreaterThan(driver.scene.enclosureRose, 0.05,
                             "the still room is not posed where a walker who stayed would have arrived")
    }

    // MARK: - Reading a room

    /// How far the far half still stands from the near half, in the working
    /// surface's own coordinates, averaged over the seven.
    private static func halfSeparation(_ built: CrossingRoom, room: HomeRoom,
                                       at t: TimeInterval) -> Double {
        let stage = stage(room: room, at: t)
        guard let material = stage.materials[stage.placement.surface] else { return 0 }
        let b = stage.deep
        var total = 0.0
        for index in 0..<CrossingRoom.marksPerHalf {
            let near = built.place(index: index, answering: false, at: t,
                                   surface: stage.placement.surface, material: material)
            let far = built.place(index: index, answering: true, at: t,
                                  surface: stage.placement.surface, material: material)
                .converged(onto: near, by: b)
            let du = far.at.u - near.at.u, dv = far.at.v - near.at.v
            total += (du * du + dv * dv).squareRoot()
        }
        return total / Double(CrossingRoom.marksPerHalf)
    }

    private static func stage(room: HomeRoom, at t: TimeInterval) -> RoomStage {
        var materials: [RoomSurfaceKind: RoomMaterial] = [:]
        for kind in RoomSurfaceKind.allCases {
            materials[kind] = RoomMaterial(surface: kind, seed: room.position)
        }
        return RoomStage(placement: RoomUnits.placement(bodyAltitude: room.bodyAltitude,
                                                        chamberTime: t),
                         settling: HomeGrammar.settling(chamberTime: t),
                         deep: HomeGrammar.deepProgress(chamberTime: t),
                         materials: materials)
    }

    /// The shorter way round the colour wheel, in degrees.
    private static func hueDistance(_ a: Double, _ b: Double) -> Double {
        let raw = (a - b).truncatingRemainder(dividingBy: 360)
        if raw > 180 { return raw - 360 }
        if raw < -180 { return raw + 360 }
        return raw
    }

    struct Luminance {
        let low: Double
        let high: Double
        let mean: Double
        let saturated: Double
    }

    private static func luminance(of image: CGImage) -> Luminance {
        let side = 64
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        guard let context = CGContext(data: &pixels, width: side, height: side,
                                      bitsPerComponent: 8, bytesPerRow: side * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return Luminance(low: 0, high: 0, mean: 0, saturated: 0) }
        context.draw(image, in: CGRect(x: 0, y: 0, width: side, height: side))

        var low = 1.0, high = 0.0, total = 0.0, blown = 0
        for index in stride(from: 0, to: pixels.count, by: 4) {
            let luma = (0.2126 * Double(pixels[index])
                        + 0.7152 * Double(pixels[index + 1])
                        + 0.0722 * Double(pixels[index + 2])) / 255
            low = Swift.min(low, luma)
            high = Swift.max(high, luma)
            total += luma
            if luma > 0.96 { blown += 1 }
        }
        let count = Double(side * side)
        return Luminance(low: low, high: high, mean: total / count,
                         saturated: Double(blown) / count)
    }
}

// MARK: - The geometric fingerprint, across a whole ring
//
// `homes-verify.js`'s `fingerprint(chamber, t)` and `divergence(a, b)`. Design's
// own walks a built chamber's graph and writes **each object's position, scale
// and opacity** to two decimals; `divergence(a, b)` is then the fraction of those
// components that differ, and its bar is a tenth.
//
// `GateRoomTests` ports it at the layer beneath the geometry, and reads two
// registers: where the room's four surfaces stand, and what the material of the
// floor and the ceiling is doing along the line the walker looks down. That was
// enough for the Gate, whose two rooms are a floor and a ceiling. It is not
// enough for a ring, and the reason is worth writing down rather than working
// around:
//
//   · **Fifteen of the sixteen act on a working face**, and a face's material is
//     read across as well as away, so a line of five probes down the middle
//     reads most of Ring 2 at zero. It probes a grid.
//
//   · **Two surfaces nothing happened to are two blocks of identical zeroes**,
//     and counting them dilutes every real difference in the room toward the
//     threshold. It reads the surface her body actually puts her on.
//
//   · **Design's own register is the objects**, and under the renderer ruling a
//     room has no objects — it has actions on its own material, which carry
//     exactly what Design writes down: where (`at`), how large (`reach`,
//     `depth`), how bright (`glow`), and now also what verb. So the actions are
//     read, in order, straight off the material the room shaped. That is the
//     closest thing in this instrument to what `fingerprint(chamber, t)` reads,
//     and it is read off the room rather than re-derived beside it.
//
//   · **And where her mark stands in the frame is geometry too.** Her altitude
//     decides where in the picture her mark sits and how far the eye inclines to
//     it (handoff §4.3), and on a working face it reaches neither the surface's
//     station nor its material — the face *is* her altitude. A fingerprint that
//     could not see it would be blind to one of the four channels that make a
//     room hers.
private enum CrossingFingerprint {

    /// Design's own bar: more than a tenth of the components differ.
    static let threshold: Double = 0.1

    /// Seven moments of one stay: the opening, the eye settling, the first
    /// adaptation, the hold, the turn, and two points past it.
    static let sampleTimes: [TimeInterval] = [0, 24, HomeMemory.firstAdaptation, 140,
                                              HomeMemory.holdEnd, 287,
                                              HomeMemory.secondAdaptationEnd]

    /// A grid over the surface, five by five.
    static let probes: [SurfaceCoordinate] = (0..<5).flatMap { u in
        (0..<5).map { v in
            SurfaceCoordinate(u: (Double(u) + 0.5) / 5, v: (Double(v) + 0.5) / 5)
        }
    }

    /// How many of the room's own marks are written down, and how many of her
    /// attribute's. Fixed, and padded when a room has fewer, so that two rooms
    /// whose forms carry different numbers of moving parts still line up
    /// component for component — which is what `divergence` assumes.
    ///
    /// Fourteen is the crossing's own count; twelve covers the largest form any
    /// Karṣiṇī carries, the lotus's eight petals and its centre.
    static let mechanismMarks = CrossingRoom.marksPerHalf * 2
    static let attributeMarks = 12

    private static func f(_ x: Double) -> String { String(format: "%.2f", x) }

    /// One action, as Design writes one object: where it is, how large, how
    /// bright — and what it is doing, which an object could not have said.
    private static func say(_ action: SurfaceAction?, _ slot: Int) -> String {
        guard let action else { return "a|\(slot)|-" }
        return "a|\(slot)|" + action.verb.rawValue + "|" + f(action.at.u) + "|" + f(action.at.v)
            + "|" + f(action.reach) + "|" + f(action.depth) + "|" + f(action.glow)
    }

    static func at(_ scene: RoomScene, _ t: TimeInterval) -> [String] {
        var out: [String] = []
        scene.pose(at: t)

        // Where each of the room's own surfaces stands.
        for surface in RoomSurfaceKind.allCases {
            out.append("s|" + surface.rawValue + "|" + f(scene.stood[surface] ?? 0))
        }

        // Where in the room — and so where in the frame — her mark falls.
        let placement = RoomUnits.placement(bodyAltitude: scene.room.bodyAltitude, chamberTime: t)
        out.append("p|surface|" + placement.surface.rawValue)
        out.append("p|height|" + f(placement.height))
        out.append("p|depth|" + f(placement.depth))
        out.append("p|footprint|" + f(placement.footprint))
        out.append("p|pitch|" + f(RoomUnits.eyePitch(toward: placement)))

        // And every mark on the surface her body puts her on, in the order the
        // room made them: the mechanism's first, then her attribute's.
        let shaped = scene.shaped(at: t)
        let actions = shaped[scene.receivingSurface]?.actions ?? []
        for slot in 0..<(mechanismMarks + attributeMarks) {
            out.append(say(slot < actions.count ? actions[slot] : nil, slot))
        }

        // …and the stone itself, so the print reads what was made and not only
        // what was asked for.
        if let material = shaped[scene.receivingSurface] {
            for probe in probes {
                out.append("m|" + f(material.relief(at: probe) - material.grain(at: probe))
                           + "|" + f(material.emission(at: probe)))
            }
        } else {
            probes.forEach { _ in out.append("m|-") }
        }
        return out
    }

    static func of(_ room: HomeRoom) -> [String] {
        let scene = RoomScene(room: room)
        return sampleTimes.flatMap { at(scene, $0) }
    }

    /// `homes-verify.js`'s `divergence`, ported exactly.
    static func divergence(_ a: [String], _ b: [String]) -> Double {
        let n = min(a.count, b.count)
        guard n > 0 else { return 0 }
        var differing = 0
        for i in 0..<n where a[i] != b[i] { differing += 1 }
        return Double(differing) / Double(n)
    }
}
