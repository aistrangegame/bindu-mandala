import XCTest
import CoreGraphics
@testable import Bindu_Mandala

// MARK: - RING 1 · PASS THREE · the ten Mudrās, and the seal that is not a hand
//
// Khaḍgamālā 19–28, which completes Ring 1's twenty-eight and therefore the first
// two full rings of the instrument. Eight are the grammar speaking
// (``MudraRoom``) and two are rooms Design named and never finished:
//
//   · 27 Sarva-Yoni — ``MembraneRoom``, *no door · you were always inside*
//   · 28 Sarva-Trikhaṇḍā — ``TripleRoom``, *three rooms · one seal, only in
//     stillness*
//
// What is held here:
//
//   1. all ten resolve **by position**, with 27 and 28 reaching their authored
//      rooms and nobody else reaching any of the three
//   2. **nothing in any of the ten reads as a hand, a finger or a body part** —
//      the law at its most exposed, measured rather than asserted in words
//   3. the seal only ever opens; it never grips
//   4. every pair of the ten diverges above Design's tenth on the geometry
//   5. **the three families separate further than sisters within a family do**,
//      which is the whole reason the brief asked for three passes
//   6. each of the ten is legible at both adaptations, on a real offscreen render
//   7. each reverses its own premise
//   8. every mark stands clear of the stone's own grain, and nothing mounts a
//      solid
//
// **What the synthetic half proves, and what it does not.** Only Ring 2's sixteen
// rows ship in the binary; Ring 1 lives in Airtable and a bundled copy would be
// the ghost roster law 1 exists to prevent. Every row here comes from
// ``HomesCorpus``, built out of real tattva vocabulary keyed off position, so a
// difference found between two of them is weaker evidence than it looks. The
// checks that matter least depend on the rows: the aniconic measures, the
// opening, the reversal and the family separation are facts about the rooms.
final class MudraRoomTests: XCTestCase {

    private static let captureSize = CGSize(width: 320, height: 640)
    private static let firstAdaptation = HomeMemory.firstAdaptation
    private static let pastTheSecond = HomeMemory.secondAdaptationEnd

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { (19...28).contains($0.row.position) }
            .sorted { $0.row.position < $1.row.position }
    }

    private func sealed(_ room: HomeRoom) -> MudraRoom? {
        RoomMechanisms.forRoom(room) as? MudraRoom
    }

    /// **The whole of Ring 1, fingerprinted once.** Both geometric checks below
    /// ask the same twenty-eight rooms different questions, and a fingerprint
    /// costs a built scene: shared, the suite builds twenty-eight of them instead
    /// of thirty-eight. Nothing about the measure changes — it is the same print
    /// either way — and the two checks cannot drift onto different evidence,
    /// which is the same reason ``HomesCorpus`` exists.
    private static let ringOne: [RingOneFingerprint.Seat] =
        RingOneFingerprint.ringOne(HomesCorpus.resolvedRooms())

    // MARK: - 1 · all ten, by position, and the two authored among them

    /// **The dispatch is decided by position and by nothing else.**
    ///
    /// Design's `BY_NAME` keys `Sarvayoni` and `Sarvatrikhaṇḍā`, and its own
    /// cards read `Sarva-Yoni` and `Sarva-Trikhaṇḍā`: in Design's shipped Axis
    /// both of these rooms are silently never reached, and `homes-verify.js`
    /// cannot see it happen because its only coverage question is whether *some*
    /// room was built. Keyed by khaḍgamālā position the miss cannot happen, and
    /// this is the check Design lacked.
    func testEveryMudraReachesHerOwnRoomByPosition() {
        var reached: [Int: String] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(row.position) reached no mechanism at all")
                continue
            }
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            reached[row.position] = String(describing: type(of: mechanism))
        }
        XCTAssertEqual(reached, [
            19: "MudraRoom", 20: "MudraRoom", 21: "MudraRoom", 22: "MudraRoom",
            23: "MudraRoom", 24: "MudraRoom", 25: "MudraRoom", 26: "MudraRoom",
            27: "MembraneRoom", 28: "TripleRoom",
        ], "a Mudrā is standing in somebody else's room")

        // …and nobody outside the ten seats reaches any of the three.
        let strangers = HomesCorpus.resolvedRooms()
            .filter { !(19...28).contains($0.row.position) }
            .filter { entry in
                let built = RoomMechanisms.forRoom(entry.room)
                return built is MudraRoom || built is MembraneRoom || built is TripleRoom
            }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a Mudrā's room without standing in her ten seats")

        // Her turn of the ten is Design's own, and no two of the eight share one.
        let phases = rooms().compactMap { sealed($0.room)?.phase }
        XCTAssertEqual(phases.count, 8)
        XCTAssertEqual(Set(phases.map { String(format: "%.6f", $0) }).count, 8,
                       "two of the grammar-built Mudrās take the same turn of the ten")
    }

    // MARK: - 2 · nothing here reads as a body

    /// **The aniconic law, measured.**
    ///
    /// A mudrā *is* a hand gesture in the tradition and Design's own attribute
    /// vocabulary contains forms it calls `seal` and `palm`. This is the one
    /// family of the hundred and two where law 4 has to be held by construction
    /// rather than by taste, so each of the three rooms is asked for a property a
    /// body does not have:
    ///
    ///   · **the seal is its own mirror image.** Design's five angles are
    ///     `±0.9, ±0.45, 0`, so vault `i` and vault `4 - i` are reflections of one
    ///     another across the walker's own axis — at every moment, because the
    ///     reflection is in the across-axis and the opening turns about the other
    ///     two. A hand is chiral: the thumb is what makes it one. A figure that is
    ///     its own mirror image cannot be a hand, and cannot be made into one
    ///     without failing this.
    ///   · **the five do not taper, and the longest of them are the outermost.**
    ///     Design's tube is one constant radius over one constant curve, and the
    ///     middle span is the *shortest* of the five — the inverse of a hand's
    ///     profile, where the middle digit is longest and the outer ones fall
    ///     away.
    ///   · **the fan has no centre.** A hand joins its five at a palm; nothing is
    ///     ever marked where this fan's feet would join, because the walker is
    ///     standing there. What the seal holds is seven units beyond the fan.
    ///   · **the membrane is rotationally symmetric.** Eight veins at Design's
    ///     own `(i / 8) · 2π`, equally spaced on one circle, and three concentric
    ///     sources beyond. Nothing about a body has eight-fold symmetry.
    ///   · **the triple stands the same figure three times.** A body occurs once.
    ///
    /// And over all ten: the shape her attribute brings into the room is one of
    /// the twenty-six abstract forms, never a figure — Design's card words `hand`
    /// and `palm` resolve through ``HomeAttribute/kin`` onto `linedDisc`, *a disc
    /// bearing three lines*, which is the aniconic mechanism working rather than
    /// a breach of it.
    func testNothingInTheTenReadsAsABodyPart() {
        // **The figure this family is in danger of, and not a general body-word
        // sweep.** A mudrā is a hand, so the words that would restore the figure
        // here are the hand's. Where a Śakti is *felt* — the eyes, the throat, the
        // heart — is her `bodilyLocation`, which is the practice and not a picture
        // of a goddess; `LawsTests` makes exactly that distinction for the somatic
        // fields and refuses to flag them, and a check that flagged them here
        // would be noise pretending to be a law. The first run of this test found
        // that honestly: it failed on khaḍgamālā 24 for saying *"the kāla of the
        // eyes"*, which is where she is felt.
        let bodyWords = ["hand", "finger", "thumb", "palm", "fist", "knuckle", "wrist",
                         "grip", "clasp", "limb", "torso", "womb", "flesh"]

        // ── the ten rooms' own words ────────────────────────────────────────
        for (row, room) in rooms() {
            if let label = room.label {
                for said in [label.near, label.deep] {
                    let lowered = said.lowercased()
                    for word in bodyWords {
                        XCTAssertFalse(lowered.contains(word),
                                       """
                                       khaḍgamālā \(row.position) says "\(said)" to the walker, and \
                                       that names a \(word). A mudrā is a sealing; law 4 does not \
                                       let the one family where the figure is closest be the one \
                                       that names it.
                                       """)
                    }
                }
            }
            guard let form = HomeAttribute.form(atPosition: row.position) else {
                XCTFail("khaḍgamālā \(row.position) brings no attribute into her room")
                continue
            }
            let drawn = (form.rawValue + " " + form.shape).lowercased()
            for word in bodyWords {
                XCTAssertFalse(drawn.contains(word),
                               """
                               khaḍgamālā \(row.position)'s attribute is drawn as "\(form.shape)", \
                               which names a \(word). Design's own card word here is \
                               "\(HomeAttribute.designKey(atPosition: row.position) ?? "—")", and \
                               the whole point of `kin` is that it never arrives as one.
                               """)
            }
        }

        // ── the seal is its own mirror image ────────────────────────────────
        for index in 0..<MudraRoom.vaults {
            let mirrored = MudraRoom.vaults - 1 - index
            XCTAssertEqual(MudraRoom.angle(ofVault: index),
                           -MudraRoom.angle(ofVault: mirrored), accuracy: 1e-12,
                           "vault \(index) is not the reflection of vault \(mirrored)")
            for opening in [0.0, MudraRoom.opens] {
                for sample in 0..<MudraRoom.vaultSamples {
                    let here = MudraRoom.curve(vault: index, sample: sample, opening: opening)
                    let there = MudraRoom.curve(vault: mirrored, sample: sample, opening: opening)
                    XCTAssertEqual(here.across, -there.across, accuracy: 1e-9,
                                   """
                                   the seal has lost its mirror symmetry at vault \(index), \
                                   sample \(sample). A five that is not its own reflection is a \
                                   hand, and this family may not have one.
                                   """)
                    XCTAssertEqual(here.rise, there.rise, accuracy: 1e-9)
                    XCTAssertEqual(here.depth, there.depth, accuracy: 1e-9)
                }
            }
        }

        // ── the five do not taper, and the middle is the shortest ───────────
        let spans = (0..<MudraRoom.vaults).map { index -> Double in
            var length = 0.0
            for sample in 1..<MudraRoom.vaultSamples {
                let a = MudraRoom.curve(vault: index, sample: sample - 1, opening: 0)
                let b = MudraRoom.curve(vault: index, sample: sample, opening: 0)
                length += ((a.across - b.across) * (a.across - b.across)
                           + (a.rise - b.rise) * (a.rise - b.rise)
                           + (a.depth - b.depth) * (a.depth - b.depth)).squareRoot()
            }
            return length
        }
        let longest = spans.max() ?? 0, shortest = spans.min() ?? 0
        XCTAssertLessThan(longest / max(shortest, 1e-9), 1.2,
                          """
                          the five spans run \(shortest)…\(longest). A hand's digits differ by \
                          half; five vaults are one span, and a fan whose parts have begun to \
                          differ in length has begun to be a hand.
                          """)
        XCTAssertEqual(spans.firstIndex(of: shortest), MudraRoom.vaults / 2,
                       """
                       the middle of the fan is no longer its shortest span. The inverse of a \
                       hand's profile is what keeps this a vault, and it is Design's own geometry \
                       rather than a choice made here.
                       """)

        // ── the fan has no centre, and it is a sphere around where he stands ──
        //
        // **The first version of this check measured from the wrong point**, and
        // the failure was worth keeping: the five feet stand on a 103° *arc*, and
        // the centroid of an arc sits close to the arc itself, so the middle vault
        // came out 0.96 away and the check read as a breach. The fan's own centre
        // is not the mean of its feet — it is the room's axis, `(0, springs,
        // standsBefore)`, and every foot is exactly `footRadius` from it because
        // Design's radius term is `5 + u * 4`.
        //
        // Stated properly it is a stronger sentence than the one it replaces:
        // **nothing in this room ever comes nearer the walker than the ring the
        // seal springs from — not a vault at any moment of its opening, and not
        // what the seal holds**, which stands at `(0, 0, -7)` and is therefore
        // also exactly five from him. The seal is a sphere with him at its centre.
        // A hand is a thing you look at from outside.
        func fromHim(_ point: (across: Double, depth: Double, rise: Double)) -> Double {
            let dr = point.rise - MudraRoom.springs, dd = point.depth - MudraRoom.standsBefore
            return (point.across * point.across + dr * dr + dd * dd).squareRoot()
        }
        var nearest = fromHim((across: 0, depth: MudraRoom.heldStands, rise: 0))
        for index in 0..<MudraRoom.vaults {
            for opening in [0.0, MudraRoom.opens * (1 + Double(index) * MudraRoom.opensFurther)] {
                for sample in 0..<MudraRoom.vaultSamples {
                    nearest = min(nearest,
                                  fromHim(MudraRoom.curve(vault: index, sample: sample,
                                                          opening: opening)))
                }
            }
        }
        XCTAssertEqual(nearest, MudraRoom.footRadius, accuracy: MudraRoom.footRadius * 0.02,
                       """
                       the nearest thing in this room stands \(nearest) from the walker against a \
                       seal that springs at \(MudraRoom.footRadius). Either something has come \
                       inside the ring — the place a palm would be, and the place he is standing — \
                       or the seal no longer closes around him at all.
                       """)

        // ── the membrane is rotationally symmetric ──────────────────────────
        let gaps = (0..<MembraneRoom.veins).map { index -> Double in
            MembraneRoom.angle(ofVein: (index + 1) % MembraneRoom.veins)
                - MembraneRoom.angle(ofVein: index)
        }
        for gap in gaps {
            let turn = gap < 0 ? gap + 2 * .pi : gap
            XCTAssertEqual(turn, 2 * .pi / Double(MembraneRoom.veins), accuracy: 1e-9,
                           """
                           the membrane's veins are no longer equally spaced about the room's \
                           axis. Eight-fold symmetry is what makes a vessel a vessel rather than \
                           an organ, and it is Design's own `(i / 8) * 2π`.
                           """)
        }
        XCTAssertEqual(MembraneRoom.nested.sorted(), MembraneRoom.nested,
                       "the three sources beyond are no longer concentric and in order")

        // ── the triple stands the same figure three times ───────────────────
        for (row, room) in rooms() where row.position == 28 {
            let marks = RingOneStage.marks(room: room, at: Self.firstAdaptation)
            let perGhost = TripleRoom.loops * TripleRoom.loopSamples
            XCTAssertEqual(marks.count, TripleRoom.ghosts * perGhost + 1,
                           "the triple is not three ghosts and one seal")
            let ghosts = (0..<TripleRoom.ghosts).map {
                Array(marks[($0 * perGhost)..<(($0 + 1) * perGhost)])
            }
            func extent(_ block: [SurfaceAction]) -> (u: Double, v: Double) {
                let us = block.map(\.at.u), vs = block.map(\.at.v)
                return ((us.max() ?? 0) - (us.min() ?? 0), (vs.max() ?? 0) - (vs.min() ?? 0))
            }
            let first = extent(ghosts[0])
            for (index, ghost) in ghosts.enumerated().dropFirst() {
                let mine = extent(ghost)
                XCTAssertEqual(mine.u, first.u, accuracy: 1e-6,
                               "ghost \(index) is not congruent with ghost 0 across the room")
                XCTAssertEqual(mine.v, first.v, accuracy: 1e-6,
                               "ghost \(index) is not congruent with ghost 0 along the room")
                XCTAssertEqual(Set(ghost.map(\.reach)).count, Set(ghosts[0].map(\.reach)).count,
                               "ghost \(index) is not drawn the same way ghost 0 is")
            }
        }
    }

    // MARK: - 3 · the seal only ever opens

    /// **A seal opens; fingers close.**
    ///
    /// Design's `d0.rotation.x = b * 0.42 * (1 + i * 0.1)` is monotone in the
    /// second adaptation and it is the only thing in this room that the turn
    /// changes about the fan. So the check is stated as the room's own sentence:
    /// as the stay deepens, no vault of the seal ever comes back toward where it
    /// sprang from, and the outer vaults travel furthest — which is a closure
    /// letting go, and is the opposite of a grip.
    func testTheSealOnlyEverOpens() {
        var travelled: [Int: Double] = [:]
        for index in 0..<MudraRoom.vaults {
            var previous = 0.0
            for step in 0...10 {
                let deep = Double(step) / 10
                let opening = deep * MudraRoom.opens * (1 + Double(index) * MudraRoom.opensFurther)
                let crown = MudraRoom.curve(vault: index,
                                            sample: MudraRoom.vaultSamples - 1,
                                            opening: opening)
                // How far the crown has been carried from where it stood at rest.
                let atRest = MudraRoom.curve(vault: index,
                                             sample: MudraRoom.vaultSamples - 1, opening: 0)
                let moved = ((crown.depth - atRest.depth) * (crown.depth - atRest.depth)
                             + (crown.rise - atRest.rise) * (crown.rise - atRest.rise)).squareRoot()
                XCTAssertGreaterThanOrEqual(moved, previous - 1e-12,
                                            """
                                            vault \(index) came back toward where it sprang from \
                                            as the stay deepened. This room is a closure that \
                                            lets go; nothing in it grips.
                                            """)
                previous = moved
                if step == 10 { travelled[index] = moved }
            }
        }
        guard let inner = travelled[0], let outer = travelled[MudraRoom.vaults - 1] else {
            return XCTFail("the seal has no vaults")
        }
        XCTAssertGreaterThan(outer, inner,
                             """
                             the outermost vault travelled \(outer) and the innermost \(inner). \
                             Design opens the outer ones furthest — `(1 + i * 0.1)` — and that \
                             graded opening is what makes the seal read as one closure letting go \
                             rather than five things moving.
                             """)

        // …and what it held is let go while its own light falls, which is the
        // one mark in Ring 1 that dims as the premise turns.
        for (row, room) in rooms() where sealed(room) != nil {
            let early = RingOneStage.marks(room: room, at: Self.firstAdaptation)
            let late = RingOneStage.marks(room: room, at: Self.pastTheSecond)
            XCTAssertEqual(early.count, MudraRoom.vaults * MudraRoom.vaultSamples + 1,
                           "khaḍgamālā \(row.position) is not five vaults and what they hold")
            XCTAssertEqual(late.count, early.count)
            XCTAssertGreaterThan(late[0].reach, early[0].reach,
                                 "khaḍgamālā \(row.position) never lets go of what she held")
            XCTAssertLessThan(late[0].glow, early[0].glow,
                              """
                              khaḍgamālā \(row.position)'s held light rises as it opens. Design's \
                              own ramp falls — `0.5 + 0.3 * k - b * 0.2` — and an opening lit area \
                              is the pale wash `PressRoom` found with a picture.
                              """)
            XCTAssertLessThanOrEqual(late[0].reach,
                                     RingOne.widestMark + 1e-9,
                                     "khaḍgamālā \(row.position)'s seal opened past the room")
        }
    }

    // MARK: - 4 · the sister-divergence check, on geometry

    /// **All forty-five pairs of the ten, above Design's tenth.**
    func testEveryPairOfTheTenDivergesOnGeometry() {
        let prints = Self.ringOne.filter { (19...28).contains($0.position) }
            .map { (kp: $0.position, print: $0.print) }
        XCTAssertEqual(prints.count, 10)
        let width = prints[0].print.count
        XCTAssertGreaterThan(width, 100, "the fingerprint reads too little of the room to mean anything")

        var blurred: [String] = []
        var closest = (pair: "—", divergence: Double.infinity)
        var pairs = 0
        for (index, a) in prints.enumerated() {
            for b in prints[(index + 1)...] {
                pairs += 1
                let d = RingOneFingerprint.divergence(a.print, b.print)
                if d < closest.divergence { closest = ("kp \(a.kp) ↔ kp \(b.kp)", d) }
                if d <= RingOneFingerprint.threshold {
                    blurred.append("kp \(a.kp) ↔ kp \(b.kp) — divergence " + String(format: "%.3f", d))
                }
            }
        }
        XCTAssertEqual(pairs, 45, "ten rooms is forty-five pairs")
        print("MUDRA_DIVERGENCE {\"pairs\":\(pairs),\"components\":\(width),"
              + "\"closest\":\"\(closest.pair)\","
              + String(format: "\"divergence\":%.4f}", closest.divergence))
        XCTAssertTrue(blurred.isEmpty,
                      """
                      \(blurred.count) pair(s) of the ten build rooms that blur into one another. \
                      Could this room belong to any other Śakti? Fix the room; never lower the \
                      threshold.
                      \(blurred.joined(separator: "\n"))
                      """)

        // And the measure is not being passed by dilution.
        let silent = (0..<width).filter { index in Set(prints.map { $0.print[index] }).count == 1 }
        print("MUDRA_FINGERPRINT {\"components\":\(width),\"silent\":\(silent.count)}")
        XCTAssertLessThan(Double(silent.count) / Double(width), 0.5,
                          """
                          \(silent.count) of \(width) fingerprint components are the same in all \
                          ten rooms. The print has become mostly padding.
                          """)
    }

    // MARK: - 5 · three families, and the reason the brief asked for three passes

    /// **A Mudrā and a Siddhi differ more than two Mudrās do — and so for every
    /// pair of the three families.**
    ///
    /// This is the check the whole of item 3.5 exists to pass. Ring 1 is not one
    /// ring of twenty-eight: it is a power exercised, a sound that makes, and a
    /// closure that seals, and if the three had blurred then twenty-eight rooms
    /// would be wearing three names. Measured as two means over
    /// ``RingOneFingerprint``'s own geometry: how far apart two sisters of one
    /// family stand, against how far apart two rooms of different families stand.
    ///
    /// Asked of the rooms **the grammar speaks for**. The seven authored rooms of
    /// Ring 1 are authored, Ruling 10 exempts them from the grammar-only proof,
    /// and a hand-built room is an outlier in whichever family it sits in by
    /// construction. Their numbers are printed rather than folded in.
    func testTheThreeFamiliesSeparateMoreThanSistersDo() {
        let seats = Self.ringOne
        XCTAssertEqual(seats.count, 28, "Ring 1 is not twenty-eight seats")

        let families: [HomeArchetype] = [.siddhi, .matrka, .mudra]
        let grammared = Dictionary(grouping: seats.filter(\.grammared), by: \.family)
        for family in families {
            XCTAssertFalse((grammared[family] ?? []).isEmpty,
                           "\(family.rawValue) has no grammar-built room to measure")
        }

        var within: [HomeArchetype: Double] = [:]
        for family in families {
            let mine = grammared[family] ?? []
            within[family] = RingOneFingerprint.meanDivergence(mine, mine)
        }
        var between: [String: Double] = [:]
        for (index, one) in families.enumerated() {
            for other in families[(index + 1)...] {
                between["\(one.rawValue)|\(other.rawValue)"] =
                    RingOneFingerprint.meanDivergence(grammared[one] ?? [], grammared[other] ?? [])
            }
        }

        let sisters = within.map { "\"\($0.key.rawValue)\":" + String(format: "%.4f", $0.value) }
        let strangers = between.map { "\"\($0.key)\":" + String(format: "%.4f", $0.value) }
        print("RING1_FAMILIES {\"within\":{\(sisters.joined(separator: ","))},"
              + "\"between\":{\(strangers.joined(separator: ","))}}")

        // The authored seven, printed and not asserted on (Ruling 10).
        let authored = seats.filter { !$0.grammared }.map(\.position)
        print("RING1_AUTHORED {\"positions\":\(authored)}")

        guard let widestSisters = within.max(by: { $0.value < $1.value }) else {
            return XCTFail("the families could not be measured")
        }
        // **The claim this pass has to make**: a Mudrā is unmistakable from a
        // Siddhi and from a Mātṛkā by a wider margin than two Mudrās, two
        // Siddhis or two Mātṛkās are from one another.
        for (against, name) in [(HomeArchetype.siddhi, "Siddhis"), (.matrka, "Mātṛkās")] {
            let key = between["\(against.rawValue)|mudra"] ?? between["mudra|\(against.rawValue)"]
            guard let apart = key else {
                return XCTFail("the Mudrās were never measured against the \(name)")
            }
            XCTAssertGreaterThan(apart, widestSisters.value,
                                 """
                                 the Mudrās stand \(apart) from the \(name), and the \
                                 widest-spread sisters — the \(widestSisters.key.rawValue)s — \
                                 stand \(widestSisters.value) from one another. A Śakti's family \
                                 is supposed to be legible before she is: a power exercised, a \
                                 sound that makes, and a closure that seals are three kinds of \
                                 room, not three labels on one.
                                 """)
        }
    }

    // MARK: - 6 · legible, at both adaptations

    func testAllTenAreLegibleAtBothAdaptations() throws {
        for (row, room) in rooms() {
            let scene = RoomScene(room: room)
            for (when, t) in [("the first adaptation", Self.firstAdaptation),
                              ("past the second", Self.pastTheSecond)] {
                guard let image = scene.capture(size: Self.captureSize, atSceneTime: t) else {
                    return XCTFail("khaḍgamālā \(row.position) could not be rendered offscreen")
                }
                let spread = Self.luminance(of: image)
                print("RING1_MUDRA_LEGIBILITY {\"kp\":\(row.position),\"when\":\"\(when)\","
                      + String(format: "\"mean\":%.4f,\"min\":%.4f,\"max\":%.4f,\"saturated\":%.4f}",
                               spread.mean, spread.low, spread.high, spread.saturated))
                XCTAssertGreaterThan(spread.mean, 0.01,
                                     "khaḍgamālā \(row.position), \(when): the room rendered black")
                XCTAssertLessThan(spread.mean, 0.9,
                                  "khaḍgamālā \(row.position), \(when): the room blew out to white")
                XCTAssertLessThan(spread.saturated, 0.25,
                                  """
                                  khaḍgamālā \(row.position), \(when): \
                                  \(Int(spread.saturated * 100))% of the frame is at white — the \
                                  pale wash, arriving by a fourth door.
                                  """)
                XCTAssertGreaterThan(spread.high - spread.low, 0.02,
                                     """
                                     khaḍgamālā \(row.position), \(when): the render is flat — \
                                     nothing for a raking light to fall across.
                                     """)
            }
        }
    }

    // MARK: - 7 · each reverses its own premise

    /// **Every one of the ten turns its own premise over, and the three do it
    /// three different ways.**
    ///
    /// The eight grammar Mudrās open: the enclosure they were sealed inside gives
    /// up, and the canopy travels *away*. The membrane clears, and it is the only
    /// enclosure in Ring 1 that is moving before the turn — it breathes at every
    /// instant, which is *"you were always inside"* said as a station. The triple
    /// stops arriving and begins to breathe, which is the sharpest reversal in the
    /// ring: nothing resolves.
    func testEachOfTheTenReversesItsOwnPremise() throws {
        for (row, room) in rooms() {
            let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(room),
                                          "khaḍgamālā \(row.position) has no mechanism")
            XCTAssertTrue(mechanism.becoming.isAReversal,
                          "khaḍgamālā \(row.position)'s premise is answered by itself")

            let early = RingOneStage.stage(room: room, at: Self.firstAdaptation)
            let late = RingOneStage.stage(room: room, at: Self.pastTheSecond)
            let before = mechanism.stations(at: Self.firstAdaptation, stage: early)
            let after = mechanism.stations(at: Self.pastTheSecond, stage: late)
            let parts = RoomReversal.resolved(mechanism.becoming,
                                              bodyAltitude: room.bodyAltitude)

            XCTAssertLessThan(after[parts.premise] ?? 0, 0,
                              """
                              khaḍgamālā \(row.position)'s premise is not giving the room up at \
                              the turn. A room that does not reverse its premise is a loop.
                              """)
            let travelled = after[parts.answer] ?? 0
            if parts.answer != .ground {
                XCTAssertNotEqual(travelled, 0, accuracy: 1e-9,
                                  "khaḍgamālā \(row.position)'s answer never takes the room over")
                XCTAssertEqual(travelled < 0, mechanism.becoming.answerComes < 0,
                               "khaḍgamālā \(row.position)'s answer travels the wrong way")
            }

            if row.position == 27 {
                // The membrane is the one enclosure in Ring 1 that is already
                // moving while the eye is settling, and never stops.
                XCTAssertNotEqual(before[.wall] ?? 0, 0, accuracy: 1e-12,
                                  "the membrane is not breathing before the turn")
                let breaths = stride(from: 0.0, through: 60.0, by: 1.5).map { t -> Double in
                    mechanism.stations(at: t, stage: RingOneStage.stage(room: room, at: t))[.wall] ?? 0
                }
                XCTAssertGreaterThan(breaths.max() ?? 0, 0, "the vessel never widens")
                XCTAssertLessThan(breaths.min() ?? 0, 0, "the vessel never narrows")
            } else {
                XCTAssertTrue(before.isEmpty,
                              """
                              khaḍgamālā \(row.position) has already moved a surface while the eye \
                              was still settling. The room stands in its premise until the premise \
                              turns; that is what makes the turn a turn.
                              """)
            }

            if row.position == 28 {
                // *three and one, and always both* — the register stops arriving
                // and begins to breathe, so the three are never in register again
                // and never fully apart again.
                let apart = stride(from: HomeMemory.holdEnd, through: Self.pastTheSecond, by: 4)
                    .map { TripleRoom.separation(at: $0, deep: HomeGrammar.deepProgress(chamberTime: $0)) }
                XCTAssertGreaterThan((apart.max() ?? 0) - (apart.min() ?? 0), 0.1,
                                     """
                                     the trinity has resolved into one. Design's own comment is \
                                     that it is one movement and not a puzzle that resolves.
                                     """)
                XCTAssertEqual(TripleRoom.separation(at: Self.firstAdaptation, deep: 0), 0,
                               accuracy: 0.02,
                               "the three never came into register while the eye was settling")
            }
        }
    }

    // MARK: - 8 · a mark that can be seen, and nothing standing in it

    func testEveryMudraMarkStandsClearOfTheStonesOwnGrain() {
        for (row, room) in rooms() {
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            for t in [0, Self.firstAdaptation, Self.pastTheSecond] {
                for (index, mark) in RingOneStage.marks(room: room, at: t).enumerated()
                where mark.reach > 0 {
                    XCTAssertGreaterThanOrEqual(mark.depth, material.grainRelief - 1e-9,
                                                """
                                                khaḍgamālā \(row.position), mark \(index) at \(t)s \
                                                is \(mark.depth) deep against a grain of \
                                                \(material.grainRelief). It cannot be seen.
                                                """)
                }
            }
        }
    }

    func testNoMudraRoomMountsASolid() {
        for (row, room) in rooms() {
            let scene = RoomScene(room: room)
            for t in [0, Self.firstAdaptation, Self.pastTheSecond] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               "khaḍgamālā \(row.position) mounted a solid at \(t)s")
            }
        }
    }

    // MARK: - The frame, read

    private struct Luminance {
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
