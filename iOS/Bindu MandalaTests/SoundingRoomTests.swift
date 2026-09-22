import XCTest
@testable import Bindu_Mandala

// MARK: - RING 7 · the twelve Vāsinīs
//
// Khaḍgamālā 87–98. None of the twelve is authored: every one is
// ``SoundingRoom``, tuned by her own row.
//
// **This ring is asked harder than the others, and the reason is structural.**
// SOUNDING has no phase divisor at all, so all twelve carry
// ``HomeGrammar/Reading/phase`` `nil`; four pairs share a mode number; and on the
// real cards eight of the twelve classify to one physics and seven of those eight
// sit in one body zone. The Phase 3 foundation recorded these as the likeliest
// twelve in the instrument to blur. So beyond the shared outer-climb register
// there are checks here that exist only for this ring: that the mode reaches the
// room at all, that it decides both the count of marks and the width of the wall,
// and that the wave **alternates** rather than merely repeating.
//
// What is held:
//
//   1. each of the twelve reaches her own room by position, and her mode is
//      Design's `2 + (pos % 8)` — including the four pairs that share one
//   2. no two of the twelve build the same room — all 66 pairs above Design's
//      tenth, and the print refused if it could be passed by dilution
//   3. a sounding travels along the wall and a silence never does. A static
//      offset cannot see a cancelled motion, so what is asserted is what travels
//   4. her nodes are spread over one turn of *her own kernel*, so a physics that
//      folds does not press identical pairs
//   5. the wave alternates — one sounding driven out while the next is drawn in —
//      and every mark in the room carries light, because the ring is sourceless
//   6. her mode decides the wall: a higher mode stands on a wider ring, and no
//      sounding's stroke reaches the silence beside it
//   7. the premise reverses as something the room does
//   8. every mark clears the mesh cell and the stone's own grain
//   9. nothing mounts a solid, and each of the twelve is legible at both
//      adaptations
//
// **What the synthetic rows prove, and what they do not.** Only Ring 2's sixteen
// ship in the binary; the Vāsinīs live in Airtable and a bundled copy would be
// the ghost roster law 1 exists to prevent. Every row below comes from
// ``HomesCorpus``, so a difference found between two of them is weaker evidence
// than it looks. The mode checks are the exception: `2 + (pos % 8)` is read off
// position alone, so what they assert is exactly what ships.
@MainActor
final class SoundingRoomTests: XCTestCase {

    private static let seats = 87...98

    /// Nineteen: the widest mode in the ring stands eighteen marks, and the
    /// reversal makes one. No room's marks are truncated, and a room of the
    /// narrowest mode carries four real slots against fifteen empty ones — which
    /// is not padding, because an empty slot in a mode-two room reads against a
    /// filled one in a mode-nine room and is therefore a difference rather than a
    /// constant. ``OuterRingFingerprint/refusesDilution(_:)`` is asserted anyway.
    private static let slots = 19

    private func rooms() -> [(row: HomesCorpus.Row, room: HomeRoom)] {
        HomesCorpus.resolvedRooms().filter { Self.seats.contains($0.row.position) }
    }

    private func built(_ position: Int) throws -> (room: HomeRoom, mechanism: SoundingRoom) {
        let entry = try XCTUnwrap(rooms().first { $0.row.position == position },
                                  "khaḍgamālā \(position) did not resolve")
        let mechanism = try XCTUnwrap(RoomMechanisms.forRoom(entry.room) as? SoundingRoom,
                                      "khaḍgamālā \(position) is not a sounding room")
        return (entry.room, mechanism)
    }

    /// The figure one of the twelve is laid out on, at one instant.
    private func figure(_ room: HomeRoom, at t: TimeInterval)
        -> (stage: RoomStage, material: RoomMaterial, figure: OuterRings.Figure)? {
        let stage = OuterRingStage.stage(room: room, at: t)
        guard let material = stage.materials[stage.placement.surface] else { return nil }
        return (stage, material,
                OuterRings.Figure(ring: SoundingRoom.ring,
                                  spread: SoundingRoom.nodeRing * 2,
                                  part: SoundingRoom.nodeSize / 2,
                                  on: material,
                                  bodyAltitude: stage.placement.bodyAltitude))
    }

    // MARK: - 1 · each of the twelve reaches her own room, by position

    func testEachVasiniReachesHerOwnRoomByPosition() throws {
        var reached: [Int: String] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) else {
                XCTFail("khaḍgamālā \(row.position) reached no mechanism at all")
                continue
            }
            XCTAssertTrue(room.isBuilt, "khaḍgamālā \(row.position) fell through to the shared seat")
            XCTAssertEqual(row.ring, 7)
            reached[row.position] = String(describing: type(of: mechanism))
        }
        XCTAssertEqual(reached, Dictionary(uniqueKeysWithValues:
                                            Self.seats.map { ($0, "SoundingRoom") }),
                       "a Vāsinī is standing in somebody else's room")

        let strangers = HomesCorpus.resolvedRooms()
            .filter { !Self.seats.contains($0.row.position) }
            .filter { RoomMechanisms.forRoom($0.room) is SoundingRoom }
            .map(\.row.position)
        XCTAssertTrue(strangers.isEmpty,
                      "\(strangers) reached a sounding room without standing in the seventh āvaraṇa")

        // **Her mode is Design's own, and it is the only number her position
        // reaches this archetype through.** Read off position alone, so this
        // asserts what ships rather than what the corpus made up.
        for position in Self.seats {
            let (_, mechanism) = try built(position)
            XCTAssertEqual(mechanism.mode, 2 + HomeGrammar.mod(position, 8),
                           "khaḍgamālā \(position) is not standing at her own mode")
            XCTAssertGreaterThanOrEqual(mechanism.mode, 2)
            XCTAssertLessThanOrEqual(mechanism.mode, 9)
        }

        // …and the thinness itself, written down: four pairs share a mode, and
        // nothing about the room may rest on the mode alone.
        var byMode: [Int: [Int]] = [:]
        for position in Self.seats {
            byMode[2 + HomeGrammar.mod(position, 8), default: []].append(position)
        }
        let shared = byMode.filter { $0.value.count > 1 }.map(\.value).sorted { $0[0] < $1[0] }
        XCTAssertEqual(shared, [[87, 95], [88, 96], [89, 97], [90, 98]],
                       """
                       the four mode collisions have moved. This ring's whole difficulty is that \
                       `2 + (pos % 8)` wraps across twelve seats, and the divergence check below \
                       is what stands in for it.
                       """)

        // …and no Vāsinī carries a phase, which is the fact the room is built
        // against.
        for (row, room) in rooms() {
            guard case .grammar(let reading) = room.kind else {
                return XCTFail("khaḍgamālā \(row.position) is not a grammar room")
            }
            XCTAssertNil(reading.phase,
                         """
                         khaḍgamālā \(row.position) now carries a phase. SOUNDING has no divisor \
                         and this room is built on that; if the grammar has grown one, the room \
                         should be reading it.
                         """)
        }
    }

    // MARK: - 2 · no two of the twelve build the same room

    func testNoTwoVasinisBuildTheSameRoom() {
        let seats = OuterRingFingerprint.ring(7, HomesCorpus.resolvedRooms(), slots: Self.slots)
        XCTAssertEqual(seats.count, 12)

        var closest = (1.0, 0, 0)
        for (index, one) in seats.enumerated() {
            for other in seats[(index + 1)...] {
                let d = OuterRingFingerprint.divergence(one.print, other.print)
                if d < closest.0 { closest = (d, one.position, other.position) }
                XCTAssertGreaterThan(d, OuterRingFingerprint.threshold,
                                     """
                                     khaḍgamālā \(one.position) and \(other.position) are \
                                     \(String(format: "%.3f", d)) apart on the geometric \
                                     fingerprint, under Design's tenth. Two sisters are standing \
                                     in one room, in the ring most likely to blur.
                                     """)
            }
        }
        print("RING7_DIVERGENCE {\"closestPair\":[\(closest.1),\(closest.2)],"
              + String(format: "\"divergence\":%.4f}", closest.0))

        let dilution = OuterRingFingerprint.refusesDilution(seats)
        XCTAssertLessThan(Double(dilution.constant) / Double(max(1, dilution.total)), 0.5,
                          """
                          \(dilution.constant) of \(dilution.total) components read the same in \
                          all twelve rooms. A print that is mostly padding passes by dilution.
                          """)
    }

    // MARK: - 3 · what travels along the wall, and what never does

    /// **A static offset cannot detect a cancelled motion, so this asserts what
    /// travels.**
    ///
    /// A silence is the place the wave never carries anywhere: it has no travel
    /// *along* the stone at any moment of any stay, and that stillness is what the
    /// verb classifier reads. A sounding is the only thing in the room that does
    /// travel along it, and it travels radially.
    func testASoundingTravelsAlongTheWallAndASilenceNeverDoes() throws {
        var pressed = 0
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? SoundingRoom,
                  let read = figure(room, at: 0) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let still = HomeGrammar.stillKinds.contains(mechanism.physics)
            let moments: [TimeInterval] = [0, 7, 30, HomeMemory.firstAdaptation,
                                           HomeMemory.holdEnd, HomeMemory.secondAdaptationEnd]

            for index in 0..<mechanism.marks where mechanism.isSilence(index) {
                let places = moments.map { t in
                    mechanism.place(index: index, at: t, figure: read.figure,
                                    stage: read.stage, material: read.material)
                }
                XCTAssertEqual(Set(places.map { "\($0.at.u)|\($0.at.v)" }).count, 1,
                               """
                               khaḍgamālā \(row.position), silence \(index) travelled along the \
                               wall. A node is the one place her syllable never carries anywhere.
                               """)
                // …and her physics still reaches it, on one channel or the other:
                // how far the stone is driven, and how hard it is held.
                let held = moments.map { t in
                    String(format: "%.9f",
                           mechanism.held(index: index, at: t,
                                          travel: read.figure.length(SoundingRoom.travel)))
                }
                let bore = Set(zip(places.map { "\($0.into)" }, held).map { $0 + "|" + $1 }).count > 1
                if still {
                    XCTAssertFalse(bore,
                                   "khaḍgamālā \(row.position) presses on \(mechanism.physics.rawValue), which does not move")
                } else {
                    XCTAssertTrue(bore,
                                  """
                                  khaḍgamālā \(row.position), silence \(index): her physics is \
                                  \(mechanism.physics.rawValue) and nothing is bearing on the \
                                  stone. Design's `s.position.y = y + d[1]` is the only place her \
                                  tattva reaches this room.
                                  """)
                }
            }
            if !still { pressed += 1 }

            let travelled = (0..<mechanism.marks).filter { !mechanism.isSilence($0) }.allSatisfy { index in
                let here = mechanism.place(index: index, at: 0, figure: read.figure,
                                           stage: read.stage, material: read.material)
                let later = mechanism.place(index: index, at: OuterRings.readOver,
                                            figure: read.figure, stage: read.stage,
                                            material: read.material)
                return here.at != later.at
            }
            XCTAssertTrue(travelled,
                          """
                          khaḍgamālā \(row.position): a sounding did not move across a quarter of \
                          the first adaptation. The wall is not carrying her wave.
                          """)
        }
        XCTAssertGreaterThanOrEqual(pressed, 8,
                                    "too few of the twelve carry a physics that moves for this to prove anything")
    }

    /// **Design's `s.position.y = y + d[1]`, reproduced exactly where Design
    /// wrote it — and reaching the room where Design's line would have lost it.**
    ///
    /// The eight speech Vāsinīs classify to `sound`, whose kernel is a `y` term
    /// and nothing else, so ``SoundingRoom/bearing(of:atAngle:)`` has to return
    /// Design's own number for them to the last bit. A dozen of the kernel's kinds
    /// have no `y` term at all — two of them are this ring's own, `encircle` for
    /// `pāśa` and `point` for `aṅkuśa` — and for those Design's line taken
    /// literally is silence, in the one place her tattva reaches this archetype.
    func testHerPhysicsReachesEverySilenceWhateverHerKernelIsMadeOf() {
        // Where the kernel is purely off-plane, the bearing is Design's `d[1]`.
        for kind in HomePhysics.allCases {
            for step in 0...40 {
                let t = Double(step) * 3
                let d = HomeGrammar.displace(kind, time: t, phase: 0.17, amplitude: 1.3)
                guard d.x == 0, d.z == 0 else { continue }
                for mode in 2...9 {
                    for node in 0..<mode {
                        let a = Double(node) / Double(mode) * 2 * .pi
                        XCTAssertEqual(SoundingRoom.bearing(of: d, atAngle: a), d.y, accuracy: 0,
                                       "\(kind.rawValue) no longer carries Design's own `d[1]`")
                    }
                }
            }
        }

        // …and every kind that moves at all bears on every silence of every mode.
        for kind in HomePhysics.allCases where !HomeGrammar.stillKinds.contains(kind) {
            for mode in 2...9 {
                for node in 0..<mode {
                    let a = Double(node) / Double(mode) * 2 * .pi
                    // Both channels: how far the stone is driven, and how hard
                    // it is held. A node her motion runs straight along is driven
                    // nowhere and held hardest; one it runs into is the reverse.
                    // Either alone has angles where it is identically nothing, and
                    // the pair never does.
                    let borne = stride(from: 0.0, through: 120.0, by: 3).map { t -> String in
                        let d = HomeGrammar.displace(kind, time: t, phase: 0.11, amplitude: 1)
                        return String(format: "%.9f|%.9f",
                                      SoundingRoom.bearing(of: d, atAngle: a),
                                      SoundingRoom.hold(of: d, atAngle: a, travel: 1))
                    }
                    XCTAssertGreaterThan(Set(borne).count, 1,
                                         """
                                         \(kind.rawValue), mode \(mode), silence \(node): nothing bears \
                                         on the stone across two minutes. Her tattva does not reach \
                                         the room at all.
                                         """)
                }
            }
        }
    }

    // MARK: - 4 · her nodes are spread over one turn of her own kernel

    /// Design's `i / n` is an identity for every kind whose terms are `|sin|`,
    /// and this ring's `n` runs from two to nine — so a mode of eight would press
    /// four identical pairs into the stone.
    func testHerNodesAreSpreadOverOneTurnOfHerOwnKernel() {
        let folding = HomePhysics.allCases.filter { kind in
            !HomeGrammar.stillKinds.contains(kind) && HomeGrammar.counterPhase(of: kind) != 0.5
        }
        XCTAssertFalse(folding.isEmpty, "no kind folds — the finding this guards has gone")

        for mode in 2...9 {
            for kind in HomePhysics.allCases where !HomeGrammar.stillKinds.contains(kind) {
                var seen: Set<String> = []
                for node in 0..<mode {
                    let phase = OuterRings.spread(index: node, of: mode, kind: kind)
                    let offsets = stride(from: 0.0, through: 40.0, by: 2.5).map { t -> String in
                        let d = HomeGrammar.displace(kind, time: t, phase: phase, amplitude: 1)
                        return String(format: "%.6f|%.6f|%.6f", d.x, d.y, d.z)
                    }
                    seen.insert(offsets.joined(separator: ";"))
                }
                XCTAssertEqual(seen.count, mode,
                               """
                               mode \(mode), \(kind.rawValue): only \(seen.count) of the \(mode) \
                               silences are pressed differently.
                               """)
            }
        }

        // …and where a half turn already said something, Design's own `i / n` is
        // untouched, to the last bit.
        for kind in HomePhysics.allCases where HomeGrammar.counterPhase(of: kind) == 0.5 {
            for mode in 2...9 {
                for node in 0..<mode {
                    XCTAssertEqual(OuterRings.spread(index: node, of: mode, kind: kind),
                                   Double(node) / Double(mode), accuracy: 0,
                                   "\(kind.rawValue) no longer carries Design's own `i / n`")
                }
            }
        }
    }

    // MARK: - 5 · the wave alternates, and every mark carries light

    /// **A standing wave drives one sounding out while it draws the next in**,
    /// and nothing else in the hundred and two moves its material both ways around
    /// a single ring. Design's `sin` is what says so, and this is the check that
    /// it has not quietly become a repetition.
    ///
    /// The light is asserted at the same time because Ring 7 is **pearl at 0.95
    /// and sourceless** — there is no directional light in the room at all, so a
    /// mark that carries no light of its own is not dim, it is missing.
    func testTheWaveAlternatesAndEveryMarkCarriesLight() throws {
        for (row, room) in rooms() {
            let (_, mechanism) = try built(row.position)

            // The silences are the wave's zeros, at Design's own angles.
            for index in 0..<mechanism.marks where mechanism.isSilence(index) {
                XCTAssertEqual(mechanism.wave(index), 0, accuracy: 1e-9,
                               "khaḍgamālā \(row.position): mark \(index) is not a zero of her wave")
                XCTAssertEqual(mechanism.angle(index),
                               Double(index / 2) / Double(mechanism.mode) * 2 * .pi,
                               accuracy: 1e-9,
                               "khaḍgamālā \(row.position): her silences are not at Design's angles")
            }

            // …and the soundings between them alternate in sign.
            let soundings = (0..<mechanism.marks).filter { !mechanism.isSilence($0) }
            XCTAssertEqual(soundings.count, mechanism.mode)
            var previous: Double = 0
            for index in soundings {
                let w = mechanism.wave(index)
                XCTAssertEqual(abs(w), 1, accuracy: 1e-9,
                               "khaḍgamālā \(row.position): sounding \(index) is not at the wave's crest")
                if previous != 0 {
                    XCTAssertLessThan(w * previous, 0,
                                      """
                                      khaḍgamālā \(row.position): two neighbouring soundings are \
                                      driven the same way. Her wall is repeating rather than \
                                      standing.
                                      """)
                }
                previous = w
            }

            // Every mark carries light, in a room with no other light.
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                let marks = OuterRingStage.marks(room: room, at: t)
                XCTAssertGreaterThanOrEqual(marks.count, mechanism.marks,
                                            "khaḍgamālā \(row.position) is not 2n marks at \(t)s")
                for (index, mark) in marks.enumerated() {
                    XCTAssertGreaterThan(mark.glow, 0,
                                         """
                                         khaḍgamālā \(row.position), mark \(index) at \(t)s carries \
                                         no light. The seventh āvaraṇa is sourceless — there is no \
                                         key to find it.
                                         """)
                }
            }

            XCTAssertTrue(room.gem.isSourceless,
                          "khaḍgamālā \(row.position)'s room is no longer lit sourcelessly")
        }
    }

    // MARK: - 6 · her mode decides the wall

    /// **A standing wave needs a wall long enough to carry it**, which is this
    /// archetype's own version of Ring 3's *"an effect's stroke closes on the ring
    /// it stands on"*. Two limbs: no sounding's stroke reaches the silence beside
    /// it, and a higher mode therefore stands on a wider ring.
    func testHerModeDecidesHowWideTheWallOpens() throws {
        var byMode: [Int: Double] = [:]
        for (row, room) in rooms() {
            guard let mechanism = RoomMechanisms.forRoom(room) as? SoundingRoom,
                  let read = figure(room, at: HomeMemory.firstAdaptation) else {
                return XCTFail("khaḍgamālā \(row.position) did not lay out")
            }
            let layout = mechanism.layout(figure: read.figure, material: read.material)
            XCTAssertGreaterThanOrEqual(layout.reach, RoomInscription.narrowestMark - 1e-12)

            // The chord between two neighbouring marks, against one stroke at its
            // widest — the reach a silence has opened out to past the second
            // adaptation.
            let chord = 2 * layout.ring * sin(.pi / Double(mechanism.marks))
            let widest = OuterRings.clearance(
                ofReach: layout.reach * (1 + mechanism.silenceOpens))
            XCTAssertGreaterThanOrEqual(chord, widest - 1e-12,
                                        """
                                        khaḍgamālā \(row.position) stands \(mechanism.marks) marks \
                                        on a ring of \(layout.ring): the chord is \(chord) against \
                                        a stroke of \(widest), so each sounding writes through the \
                                        silence beside it and her room has no silences at all.
                                        """)
            byMode[mechanism.mode] = layout.ring
        }

        // …and the wall opens with the mode. Read across the ring's own rooms,
        // which differ in surface and altitude too, so this is asserted where it
        // is a fact about the mode rather than about one room: the widest mode
        // stands wider than the narrowest.
        let widest = try XCTUnwrap(byMode[9])
        let narrowest = try XCTUnwrap(byMode[2])
        XCTAssertGreaterThan(widest, narrowest,
                             """
                             a mode of nine stands on a ring of \(widest) and a mode of two on \
                             \(narrowest). Her mode is not reaching the wall.
                             """)
    }

    // MARK: - 7 · the premise reverses, as something the room does

    /// *The standing waves stop being a wall he is looking at; they pass him, and
    /// the sound becomes what he is standing in.* Three things happen and none is
    /// a word in a label: the enclosure gives way, the silences open out, and the
    /// **ground** takes the work over — the one outer archetype answered by the
    /// thing he is standing on.
    func testThePremiseReversesAsSomethingTheRoomDoes() throws {
        for (row, room) in rooms() {
            let settling = HomeMemory.firstAdaptation
            let past = HomeMemory.secondAdaptationEnd

            let wallSettling = OuterRingStage.stations(room: room, at: settling)[.wall] ?? 0
            let wallPast = OuterRingStage.stations(room: room, at: past)[.wall] ?? 0
            XCTAssertEqual(wallSettling, 0, accuracy: 1e-9,
                           "khaḍgamālā \(row.position)'s enclosure moved before the premise turned")
            XCTAssertLessThan(wallPast, 0,
                              """
                              khaḍgamālā \(row.position)'s enclosure never gives way. Design's \
                              `s.material.opacity = … * (1 - b * 0.4)` is the premise leaving.
                              """)

            // The silences open out — Design's `1.8 * (1 + b * 1.2)`.
            let (_, mechanism) = try built(row.position)
            let early = OuterRingStage.marks(room: room, at: settling)
            let late = OuterRingStage.marks(room: room, at: past)
            let answers = late.count - mechanism.marks
            let silence = { (marks: [SurfaceAction], offset: Int) -> Double in
                (0..<mechanism.marks).filter { mechanism.isSilence($0) }
                    .compactMap { index -> Double? in
                        let slot = offset + index
                        return slot < marks.count ? marks[slot].reach : nil
                    }.max() ?? 0
            }
            let opened = silence(late, answers)
            XCTAssertGreaterThan(opened, silence(early, 0) * 1.2,
                                 """
                                 khaḍgamālā \(row.position)'s silences do not open out past the \
                                 second adaptation.
                                 """)

            // …and the ground answers, wherever her body put her working surface.
            let stage = OuterRingStage.stage(room: room, at: past)
            let all = try XCTUnwrap(RoomMechanisms.forRoom(room)).actions(at: past, stage: stage)
            // The reversal's own mark is first: ``SoundingRoom/actions(at:stage:)``
            // starts from ``RoomReversal/actions(_:deep:stage:)`` and appends the
            // room's own marks after it, so this reads the answer whether or not
            // her body already put her working surface on the floor.
            let ground = all[.ground] ?? []
            let answer = try XCTUnwrap(ground.first,
                                       "khaḍgamālā \(row.position): nothing answered on the ground")
            XCTAssertEqual(answer.verb, .swell,
                           """
                           khaḍgamālā \(row.position): the ground read as \(answer.verb.rawValue). \
                           The sound becomes what he is standing in, so the material rises.
                           """)
            XCTAssertGreaterThan(answer.reach, 0)

            // The ground never comes toward him — he is standing on it.
            let station = OuterRingStage.stations(room: room, at: past)[.ground] ?? 0
            XCTAssertLessThanOrEqual(station, 0,
                                     "khaḍgamālā \(row.position)'s floor rose toward his eye")
        }
    }

    // MARK: - 8 · a mark that can be seen

    func testEveryMarkClearsTheMeshCellAndTheStonesGrain() throws {
        for (row, room) in rooms() {
            let (_, mechanism) = try built(row.position)
            let material = RoomMaterial(surface: RoomUnits.surface(forBodyAltitude: room.bodyAltitude),
                                        seed: room.position)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.holdEnd,
                      HomeMemory.secondAdaptationEnd] {
                let marks = OuterRingStage.marks(room: room, at: t)
                let mine = marks.dropFirst(max(0, marks.count - mechanism.marks))
                for (index, mark) in marks.enumerated() where mark.reach > 0 {
                    XCTAssertGreaterThanOrEqual(mark.reach, RoomInscription.narrowestMark - 1e-12,
                                                """
                                                khaḍgamālā \(row.position), mark \(index) at \(t)s \
                                                reaches \(mark.reach) against a mesh cell of \
                                                \(RoomInscription.narrowestMark). It is sampled away.
                                                """)
                    XCTAssertGreaterThanOrEqual(mark.depth, material.grainRelief - 1e-9,
                                                """
                                                khaḍgamālā \(row.position), mark \(index) at \(t)s \
                                                is \(mark.depth) deep against a grain of \
                                                \(material.grainRelief). It cannot be seen.
                                                """)
                }
                for (index, mark) in mine.enumerated() where mark.reach > 0 {
                    XCTAssertLessThanOrEqual(mark.depth, RoomInscription.markDepth + 1e-9,
                                             """
                                             khaḍgamālā \(row.position), mark \(index) at \(t)s is \
                                             deeper than one mark's worth. The room is not a quarry.
                                             """)
                }
            }
        }
    }

    // MARK: - 9 · no solid, and legible at both adaptations

    func testNoSoundingRoomMountsASolid() {
        for (row, room) in rooms() {
            let scene = RoomScene(room: room)
            for t in [0, HomeMemory.firstAdaptation, HomeMemory.secondAdaptationEnd] {
                scene.pose(at: t)
                XCTAssertEqual(scene.solidsInHerLayer, 0,
                               """
                               khaḍgamālā \(row.position) mounted \(scene.solidsInHerLayer) solids \
                               at \(t)s. An attribute is an action on the room's own material and \
                               never a free-standing lit object.
                               """)
            }
        }
    }

    func testEveryVasiniRoomIsLegibleAtBothAdaptations() {
        for (row, room) in rooms() {
            OuterRingCapture.assertLegible(room, called: "khaḍgamālā \(row.position)")
        }
    }
}
