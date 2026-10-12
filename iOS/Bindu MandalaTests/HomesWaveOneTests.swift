import XCTest
import SceneKit
@testable import Bindu_Mandala

// MARK: - Wave 1 · the Homes in Design's language of light
//
// The pure logic Slice D added, asserted against Design's own numbers: the
// seat-shaped shells, the nine bands' counts and clocks, the HDR exposure per
// world, her light at her mark, the room's words and the after-effect. And the
// surviving principle, once more, in the new code: nothing here is a figure,
// and nothing here measures him.
@MainActor
final class HomesWaveOneTests: XCTestCase {

    private func room(position: Int, ring: Int, bodilyLocation: String,
                      tattva: String = "Pṛthivī", quality: String = "she who attracts") -> HomeRoom {
        guard let room = HomeRooms.resolve(position: position, ring: ring, tattva: tattva,
                                           quality: quality, bodilyLocation: bodilyLocation) else {
            fatalError("no room resolved at position \(position)")
        }
        return room
    }

    // MARK: - Seat-shaped shells

    /// Design's `rite-core.jsx` `room:` column, ring by ring.
    func testEverySeatHasDesignsShape() {
        XCTAssertEqual(SeatShape.forRing(1), .square)
        XCTAssertEqual(SeatShape.forRing(2), .petal(count: 16))
        XCTAssertEqual(SeatShape.forRing(3), .petal(count: 8))
        for ring in [4, 6, 8] { XCTAssertEqual(SeatShape.forRing(ring), .triangle(pointsAway: true)) }
        for ring in [5, 7] { XCTAssertEqual(SeatShape.forRing(ring), .triangle(pointsAway: false)) }
        XCTAssertEqual(SeatShape.forRing(9), .circle)
    }

    /// Each shape builds the shell it names — no two worlds share a box.
    func testEachShapeBuildsItsOwnShell() {
        XCTAssertEqual(RoomShell.panels(for: .square).count, 3, "the court is two sides and a far wall")
        let lotus16 = RoomShell.panels(for: .petal(count: 16))
        let lotus8 = RoomShell.panels(for: .petal(count: 8))
        XCTAssertTrue(lotus16.allSatisfy(\.isPetal))
        XCTAssertTrue(lotus8.allSatisfy(\.isPetal))
        XCTAssertGreaterThan(lotus16.count, lotus8.count, "sixteen petals stand closer than eight")
        XCTAssertEqual(RoomShell.panels(for: .triangle(pointsAway: true)).count, 2)
        XCTAssertEqual(RoomShell.panels(for: .triangle(pointsAway: false)).count, 3)
        XCTAssertEqual(RoomShell.panels(for: .circle).count, 12, "round, open where he came in")
        XCTAssertTrue(RoomShell.panels(for: .triangle(pointsAway: true)).allSatisfy(\.shrinksAsItCloses),
                      "a triangle closes by shrinking about its centroid, or its sides cross")
        XCTAssertFalse(RoomShell.panels(for: .square).contains(where: \.shrinksAsItCloses),
                       "the court closes as it always has")
    }

    /// **No wall stands between him and her mark**, in any shape.
    ///
    /// Each panel is a segment on the floor plan. Where one crosses the line he
    /// looks along — straight ahead, from where the rite's crossing begins to
    /// the furthest her mark ever rests — it must cross beyond the mark or
    /// behind him.
    func testNoShellCrossesHisLineOfSight() {
        let nearest = RoomUnits.eyeDepth(approach: 0)
        let furthest = RoomUnits.placement(bodyAltitude: 0.5, chamberTime: 0).depth
        let shapes: [SeatShape] = [.square, .petal(count: 16), .petal(count: 8),
                                   .triangle(pointsAway: true), .triangle(pointsAway: false), .circle]
        for shape in shapes {
            for panel in RoomShell.panels(for: shape) {
                // Local x runs to (cos φ, −sin φ) on the plan.
                let ax = panel.x - cos(panel.yaw) * panel.width / 2
                let az = panel.z + sin(panel.yaw) * panel.width / 2
                let bx = panel.x + cos(panel.yaw) * panel.width / 2
                let bz = panel.z - sin(panel.yaw) * panel.width / 2
                guard (ax <= 0 && bx >= 0) || (bx <= 0 && ax >= 0), abs(bx - ax) > 1e-9 else { continue }
                let f = (0 - ax) / (bx - ax)
                let crossing = az + (bz - az) * f
                XCTAssertFalse(crossing > furthest + 1e-6 && crossing < nearest - 1e-6,
                               "\(shape): a wall crosses his line of sight at z = \(crossing)")
            }
        }
    }

    /// A room's walls are her seat's, and her seat's plan is drawn in light.
    func testEveryRoomStandsInItsSeat() {
        for (position, ring, location) in [(4, 1, "soles"), (30, 2, "pelvis"), (57, 4, "heart"),
                                           (71, 5, "throat"), (102, 9, "heart")] {
            let scene = RoomScene(room: room(position: position, ring: ring, bodilyLocation: location))
            XCTAssertEqual(scene.seat, SeatShape.forRing(ring))
            let seams = scene.nodeNames(in: .building).filter { $0 == "seam" }.count
            XCTAssertEqual(seams, RoomShell.panels(for: scene.seat).count,
                           "ring \(ring): the seat's plan is not drawn under every wall")
            XCTAssertGreaterThan(scene.lights(in: .building), 0)
        }
    }

    // MARK: - The nine bands

    /// Design's own counts, from `homes-worlds.js`.
    func testEveryBandCarriesDesignsCounts() {
        XCTAssertTrue(BandAir.forRing(1).hasSun)
        XCTAssertEqual(BandAir.forRing(1).motes, 90)
        XCTAssertEqual(BandAir.forRing(2).expandingRings, 7)
        XCTAssertEqual(BandAir.forRing(2).motes, 120)
        XCTAssertEqual(BandAir.forRing(3).churnPoints, 2_600)
        XCTAssertEqual(BandAir.forRing(4).causticSpectra, 3)
        XCTAssertTrue(BandAir.forRing(4).hasPrism)
        XCTAssertEqual(BandAir.forRing(5).ribs, 72)
        XCTAssertEqual(BandAir.forRing(5).shafts, 24)
        XCTAssertEqual(BandAir.forRing(6).lanterns, 9)
        XCTAssertEqual(BandAir.forRing(7).veils, 5)
        XCTAssertEqual(BandAir.forRing(7).motes, 150)
        XCTAssertTrue(BandAir.forRing(8).hasTravellingBand)
        XCTAssertEqual(BandAir.forRing(9).gemLamps, 9)
        XCTAssertEqual(BandAir.gemLampColours.count, 9)
        XCTAssertEqual(BandAir.forRing(9).motes, 220)
        XCTAssertEqual(BandAir.ribPlan().count, 72)

        // No two worlds carry the same air.
        let all = HomeWorlds.rings.map(BandAir.forRing)
        for i in all.indices {
            for j in all.indices where j > i {
                XCTAssertNotEqual(all[i], all[j], "rings \(i + 1) and \(j + 1) carry the same air")
            }
        }
    }

    /// The colonnade and the lanterns open toward him: nothing solid in the
    /// air stands on the line between his eye and her mark.
    func testTheBandsSolidsLeaveHisLineOfSightOpen() {
        let furthest = RoomUnits.placement(bodyAltitude: 0.5, chamberTime: 0).depth - 0.5
        let ribRadius = 0.42 * BandAir.scale
        for rib in BandAir.ribPlan() where rib.z > furthest {
            XCTAssertGreaterThan(abs(rib.x), ribRadius + 0.25,
                                 "a rib stands in front of her at (\(rib.x), \(rib.z))")
        }
        let lanternRadius = 2.8 * BandAir.scale
        for t in stride(from: 0.0, through: 2_000.0, by: 50.0) {
            for i in 0..<9 {
                let p = BandAir.lanternPlace(i, at: t)
                guard p.z > furthest else { continue }
                XCTAssertGreaterThan(abs(p.x), lanternRadius,
                                     "lantern \(i) stands in front of her at t = \(t)")
            }
        }
    }

    /// Every world's air is light, it is the world's own, and it is a pure
    /// function of the band's clock.
    func testEveryWorldsAirIsLightAndItsOwn() {
        var signatures: [Set<String>] = []
        for ring in HomeWorlds.rings {
            let position = [4, 30, 46, 57, 71, 77, 93, 99, 102][ring - 1]
            let air = RoomAir(room: room(position: position, ring: ring, bodilyLocation: "heart"))
            XCTAssertGreaterThan(air.lightBodies, 0, "ring \(ring) has no light in its air")
            var names: Set<String> = []
            func walk(_ node: SCNNode) {
                if let name = node.name { names.insert(name) }
                node.childNodes.forEach(walk)
            }
            walk(air.root)
            signatures.append(names)
            // Posing the same instant twice is the same air.
            air.update(worldTime: 120)
            air.update(worldTime: 120)
        }
        for i in signatures.indices {
            for j in signatures.indices where j > i {
                XCTAssertNotEqual(signatures[i], signatures[j],
                                  "rings \(i + 1) and \(j + 1) build the same air")
            }
        }
    }

    /// HDR is on in every world, and the pearl Crown is the one exposed most
    /// gently — its fog is already bright.
    func testEveryWorldIsExposedInHDRWithItsOwnBloom() {
        for ring in HomeWorlds.rings {
            let exposure = RoomExposure.forRing(ring)
            let camera = SCNCamera()
            exposure.apply(to: camera)
            XCTAssertTrue(camera.wantsHDR, "ring \(ring) renders without HDR")
            XCTAssertFalse(camera.wantsExposureAdaptation, "ring \(ring) would drift between captures")
            XCTAssertGreaterThan(camera.bloomIntensity, 0, "ring \(ring) has no bloom")
            XCTAssertLessThanOrEqual(exposure.exposureOffset, 0.6)
        }
        let crown = RoomExposure.forRing(7)
        for ring in HomeWorlds.rings where ring != 7 {
            XCTAssertLessThan(crown.exposureOffset, RoomExposure.forRing(ring).exposureOffset)
            XCTAssertGreaterThan(crown.bloomThreshold, RoomExposure.forRing(ring).bloomThreshold)
        }
    }

    // MARK: - Her light at her mark

    /// The core is hottest once the eye has settled and softens past the second
    /// adaptation, while the halo widens — the mark becoming the room.
    func testHerLightSoftensAsTheMarkBecomesTheRoom() {
        let opening = HerLight.at(settling: 0, deep: 0)
        let settled = HerLight.at(settling: 1, deep: 0)
        let reversed = HerLight.at(settling: 1, deep: 1)
        XCTAssertGreaterThan(settled.coreAlpha, opening.coreAlpha)
        XCTAssertLessThan(reversed.coreAlpha, settled.coreAlpha)
        XCTAssertGreaterThan(reversed.haloSize, settled.haloSize)
        XCTAssertLessThan(reversed.haloAlpha, settled.haloAlpha,
                          "a wider halo that also brightened would wash the near half of the frame")
        XCTAssertEqual(HerLight.at(settling: 5, deep: 5), reversed, "the stay is clamped")
    }

    // MARK: - The room's own words

    func testTheWordsArriveWithTheStay() {
        XCTAssertEqual(RoomWords.stage(chamberTime: 0), .arriving)
        XCTAssertEqual(RoomWords.stage(chamberTime: HomeMemory.firstAdaptation), .near)
        XCTAssertEqual(RoomWords.stage(chamberTime: HomeMemory.secondAdaptationEnd), .deep)
        XCTAssertEqual(RoomWords.stage(chamberTime: RoomClock.settled), .deep,
                       "a reduce-motion walker is shown the settled room's words")
        // They turn when the room turns, never before.
        var last = RoomWords.Stage.arriving
        for step in 0...400 {
            let now = RoomWords.stage(chamberTime: Double(step))
            XCTAssertGreaterThanOrEqual(now, last, "the words went back at t = \(step)")
            last = now
        }
    }

    func testEveryRoomSaysItsOwnWords() {
        // Design's sentences for the eight hand-authored rooms, all present.
        XCTAssertEqual(Set(RoomWords.authored.keys), Set(HomeAuthoredMechanism.allCases))
        let garima = RoomWords.compose(room: room(position: 4, ring: 1, bodilyLocation: "soles"),
                                       name: "Garimā", quality: "Weightedness")
        XCTAssertEqual(garima.near, "the ceiling is coming down")
        XCTAssertEqual(garima.deep, "the weight was holding you all along")
        XCTAssertEqual(garima.place, "Feet · the first āvaraṇa")
        XCTAssertEqual(garima.sentence(at: .arriving), "")

        let heart = room(position: 57, ring: 4, bodilyLocation: "heart", tattva: "Ākāśa")
        let words = RoomWords.compose(room: heart, name: "  Sarvasaṅkṣobhiṇī ", quality: "she who agitates")
        XCTAssertEqual(words.name, "Sarvasaṅkṣobhiṇī")
        XCTAssertEqual(words.near, heart.label?.near)
        XCTAssertEqual(words.deep, heart.label?.deep)
        XCTAssertTrue(words.place.hasSuffix("the fourth āvaraṇa"))
    }

    /// Nothing the room says counts anything — Design's nine MEASURING
    /// patterns, over every word every one of the 102 could say.
    func testNoRoomWordMeasuresHim() throws {
        let measuring = [#"\b\d+\s*(?:of|\/)\s*\d+\b"#, #"\b\d+\s*%"#, #"\bvisit(?:s)?\s*[:=]\s*\d+"#,
                         #"\bstreak\b"#, #"\bprogress\b"#, #"\blevel\s*\d"#, #"\bscore\b"#,
                         #"\bday\s*\d+\b"#, #"\b\d+\s*(?:times|visits)\b"#]
        let patterns = try measuring.map { try NSRegularExpression(pattern: $0, options: [.caseInsensitive]) }
        var said: [String] = [HomeAfterEffect.line, RoomWords.seatSentence]
        for position in 1...102 {
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: position)
            guard let room = HomeRooms.resolve(position: position, ring: ring, tattva: "Pṛthivī",
                                               quality: "she who attracts", bodilyLocation: "heart")
            else { continue }
            said += RoomWords.compose(room: room, name: "her name", quality: "her quality").all
        }
        for text in said {
            let range = NSRange(location: 0, length: (text as NSString).length)
            for pattern in patterns {
                XCTAssertNil(pattern.firstMatch(in: text, range: range), "\"\(text)\" measures out loud")
            }
        }
    }

    // MARK: - The after-effect

    func testHerSiddhiLingersAsDesignWroteIt() {
        // `rite-core.jsx`'s `after:` column.
        let expected: [HomeAfterEffect.Kind] = [.sharper, .wider, .lighter, .wider, .sharper,
                                                .heavier, .wider, .lighter, .wider]
        XCTAssertEqual(HomeWorlds.rings.map(HomeAfterEffect.kind(ring:)), expected)
        XCTAssertEqual(HomeAfterEffect.lingers, 180)
        XCTAssertEqual(HomeAfterEffect.line, "her siddhi is still on the instrument")

        for kind in HomeAfterEffect.Kind.allCases {
            let leaving = HomeAfterEffect.look(kind: kind, age: 0)
            XCTAssertNotEqual(leaving, .unchanged, "\(kind) does nothing to the instrument")
            XCTAssertEqual(HomeAfterEffect.look(kind: kind, age: HomeAfterEffect.lingers), .unchanged,
                           "\(kind) is still on the instrument after it has gone")
            // It only ever fades.
            var last = Double.infinity
            for age in stride(from: 0.0, through: 180.0, by: 6.0) {
                let look = HomeAfterEffect.look(kind: kind, age: age)
                // Heavier darkens while the Axis's lift brightens, so its
                // brightness passes through zero on the way; its other three
                // are read instead.
                let shade = kind == .heavier ? 0 : abs(look.brightness)
                let strength = shade + abs(look.contrast - 1)
                    + abs(look.saturation - 1) + abs(look.scale - 1)
                XCTAssertLessThanOrEqual(strength, last + 1e-12, "\(kind) grew at \(age) s")
                last = strength
            }
        }
        // The exposure lift is the Axis's, and every kind leaves lighter at first.
        XCTAssertGreaterThan(HomeAfterEffect.look(kind: .heavier, age: 0).brightness, -0.06)
        XCTAssertTrue(HomeAfterEffect.lineShows(age: 0))
        XCTAssertFalse(HomeAfterEffect.lineShows(age: HomeAfterEffect.lineHolds))
    }
}
