import XCTest
import CoreGraphics
@testable import Bindu_Mandala

// MARK: - U2 · B · the spine shell
//
// `waves/upgrade/worlds/spine-and-home.md` §2 C #36 (the point), D #40–#42
// (the Constellation), E #47–#48 (thread doors), F #50 (search), G #51–#53
// (back and the edge), H #64 (World Crossed), J #71–#75 (one router, the
// launch arguments). Each check carries a planted defect it is shown to catch
// (V30: born red).

final class U2SpineTests: XCTestCase {

    // MARK: The root's gestures (D #40, G #53, I #66)

    func testTheRootsGesturesAreTheWorldFilesNumbers() {
        XCTAssertEqual(SpineGesture.edgeWidth, 22)
        XCTAssertEqual(SpineGesture.edgeTravel, 72)
        XCTAssertEqual(SpineGesture.pullOpens, 84)
        XCTAssertEqual(SpineGesture.pullSpan, 120)
        XCTAssertEqual(SpineGesture.pullDimMax, 0.35)
        XCTAssertEqual(SpineGesture.fastSwipe, 600)

        let top: CGFloat = 47
        func intent(_ sx: CGFloat, _ sy: CGFloat, _ dx: CGFloat, _ dy: CGFloat, lead: CGFloat = 0) -> SpineGesture.Intent {
            SpineGesture.intent(start: CGPoint(x: sx, y: sy), translation: CGSize(width: dx, height: dy),
                                predictedEnd: CGSize(width: dx, height: dy + lead), safeTop: top)
        }
        XCTAssertEqual(intent(8, 400, 90, 4), .back, "the edge is a way out")
        XCTAssertEqual(intent(8, 400, 60, 4), .none, "short of 72 pt is not yet out")
        XCTAssertEqual(intent(40, 400, 120, 4), .none, "the edge is the leading 22 pt only")
        XCTAssertEqual(intent(200, top + 30, 4, 100), .menu, "a slow pull from the top opens the Constellation")
        XCTAssertEqual(intent(200, top + 30, 4, 60), .none, "the pull opens past 84 pt")
        XCTAssertEqual(intent(200, top + 30, 4, 100, lead: 200), .home, "a fast swipe down is the ReturnArc")
        XCTAssertEqual(intent(200, 500, 4, 200), .none, "a world's own scroll is never taken for the pull")

        XCTAssertEqual(SpineGesture.dim(forPull: 0), 0)
        XCTAssertEqual(SpineGesture.dim(forPull: 60), 0.175, accuracy: 1e-9)
        XCTAssertEqual(SpineGesture.dim(forPull: 500), 0.35, accuracy: 1e-9, "the world dims to .65, never further")
        XCTAssertEqual(SpineGesture.pullDistance(start: CGPoint(x: 100, y: 600), translation: CGSize(width: 0, height: 90),
                                                 safeTop: top), 0)
        // Born red: a sideways drag from the top is not a pull.
        XCTAssertEqual(intent(200, top + 30, 140, 100), .none)
    }

    // MARK: The Router's menu, places, edge and source

    @MainActor
    func testTheMenuAndThePlacesCloseInPlaceAndCrossingsCloseThem() {
        let r = Router(directory: nil, launch: nil, settlesInstantly: true)
        XCTAssertTrue(r.go(to: Address(.well)))
        let here = r.state

        r.openMenu()
        XCTAssertEqual(r.menuFace, .constellation)
        r.openMenu(.veil)
        XCTAssertEqual(r.menuFace, .veil, "the switch keeps him where he is")
        XCTAssertTrue(r.back())
        XCTAssertNil(r.menuFace, "back first closes the menu")
        XCTAssertEqual(r.state, here, "closing the menu moved him")

        r.open(place: .settings)
        XCTAssertEqual(r.place, .settings)
        XCTAssertTrue(r.back())
        XCTAssertNil(r.place, "back closes the spine place")
        XCTAssertEqual(r.state, here, "closing Settings moved him")

        r.openMenu()
        r.open(place: .oneSecond)
        XCTAssertNil(r.menuFace, "a place opens in the menu's stead")
        XCTAssertTrue(r.go(to: Address(.time)))
        XCTAssertNil(r.place, "a crossing leaves the place behind")
        XCTAssertNil(r.menuFace)
        XCTAssertEqual(r.mounted.world, .time)

        // Born red: back without anything open is a real back.
        XCTAssertTrue(r.back())
        XCTAssertEqual(r.state.current.world, .well)
    }

    @MainActor
    func testThePointsHoldFallsToTheSourceAndTheEdgeBloomsBack() {
        var now = Date(timeIntervalSince1970: 1_800_000_000)
        let r = Router(directory: nil, launch: nil, settlesInstantly: true, clock: { now })
        XCTAssertTrue(r.go(to: Address(.climb)))
        XCTAssertTrue(r.toSource())
        XCTAssertEqual(r.state.current, Address.source)
        XCTAssertEqual(r.state.current, Address(.home, kp: 102, sub: "source"), "the source is keyed by kp 102")
        XCTAssertEqual(r.lastCrossing?.crossing.kind, .pravesha)

        now += 60
        XCTAssertTrue(r.backFromEdge())
        XCTAssertEqual(r.state.current.world, .climb)
        XCTAssertEqual(r.lastCrossing?.crossing.kind, .returnBloom, "back within 45 min is the return bloom")
        XCTAssertEqual(r.lastCrossing?.colourHex, WorldRegistry.entry(.home).essenceHex, "in the colour he left")

        XCTAssertTrue(r.go(to: Address(.well)))
        now += 46 * 60
        XCTAssertTrue(r.backFromEdge())
        XCTAssertEqual(r.lastCrossing?.crossing.kind, .bloom, "after 45 min the bloom, not the return")
        XCTAssertEqual(r.state.current.world, .climb)
    }

    @MainActor
    func testTwoBacksHeardForOneSwipeTakeOneStep() {
        // A live router (not settling instantly) hears the root's edge and a
        // world's own way out for the same swipe: one step back, not two.
        let r = Router(directory: nil, launch: nil, settlesInstantly: false)
        XCTAssertTrue(r.go(to: Address(.time)))
        XCTAssertTrue(r.go(to: Address(.memory)))
        XCTAssertTrue(r.back())
        XCTAssertFalse(r.back(), "the second back of one swipe was taken")
        XCTAssertEqual(r.state.current.world, .time)
        XCTAssertEqual(Router.backDebounceSeconds, 0.35)
    }

    // MARK: Addresses the spine names

    func testTheSpinesSubPlaces() {
        XCTAssertEqual(Address.ringPlace(3), Address(.rings, sub: "ring.3"))
        XCTAssertEqual(Address.ringPlace(3).ringNumber, 3)
        XCTAssertEqual(Address.ringPlace(12).ringNumber, 9, "a ring past the ninth is the ninth")
        XCTAssertNil(Address(.rings, sub: "ring.0").ringNumber)
        XCTAssertNil(Address(.rings, sub: "ring.x").ringNumber)
        XCTAssertEqual(Address(.game, sub: "leela.d-4").leelaDropID, "d-4")
        XCTAssertNil(Address(.today, sub: "leela.d-4").leelaDropID, "a drop lives only in A Strange Game")
        XCTAssertNil(Address(.game, sub: "leela.").leelaDropID)
        XCTAssertTrue(Address.source.isValid)
    }

    func testOpenPlayIsAnAddress() {
        XCTAssertEqual(DeepLink.play(fromLaunchArgument: "OPEN_PLAY"), Address(.game))
        let game = PlayGame.allCases[0]
        XCTAssertEqual(DeepLink.play(fromLaunchArgument: "OPEN_PLAY=\(game.rawValue)"), Address(.game, sub: game.rawValue))
        XCTAssertNil(DeepLink.play(fromLaunchArgument: "OPEN_PLAY=nothing"), "an unknown game opened something")
        XCTAssertNil(DeepLink.play(fromLaunchArgument: "OPEN_PLAYING"))
        XCTAssertEqual(DeepLink.launchAddress(arguments: ["OPEN_WORLD=well", "OPEN_PLAY"]), Address(.game), "the last wins")
        XCTAssertNil(DeepLink.launchAddress(arguments: ["START_TAB=rite"]), "START_TAB is retired")
    }

    // MARK: Thread doors (E #47–#48)

    func testThreadDoorsFollowTheThreads() {
        let doors = ThreadDoorPlan.doors(for: Address(.herHome, kp: 29), todaysKP: 7)
        let across = doors.filter { $0.kind == .across }.map(\.to.world)
        XCTAssertEqual(across, [.herPresence, .mandala, .rings, .climb], "her position reaches these worlds, in station order")
        XCTAssertFalse(across.contains(.herHome), "a door to the world he is in")
        XCTAssertFalse(across.contains(.today), "Today is a kp door only when she is today's")
        XCTAssertFalse(across.contains(.relationship), "the Relationship Field opens only for 31 · 40 · 42")
        let neighbours = doors.filter { $0.kind != .across }.map(\.to)
        XCTAssertEqual(neighbours, [Address(.herHome, kp: 28), Address(.herHome, kp: 30)])

        let todays = ThreadDoorPlan.doors(for: Address(.herHome, kp: 29), todaysKP: 29)
        XCTAssertTrue(todays.contains { $0.to.world == .today })
        let gaia = ThreadDoorPlan.doors(for: Address(.herPresence, kp: 31), todaysKP: nil)
        XCTAssertTrue(gaia.contains { $0.to == Address(.relationship, kp: 31) })

        XCTAssertEqual(ThreadDoorPlan.neighbour(kp: 1, step: -1), 102, "round the garland")
        XCTAssertEqual(ThreadDoorPlan.neighbour(kp: 102, step: 1), 1)
        XCTAssertEqual(ThreadDoorPlan.neighbour(chakra: 33, step: 1), 1, "along the Road")
        XCTAssertEqual(ThreadDoorPlan.neighbour(chakra: 1, step: -1), 33)

        let day = Address.Day(iso: "2026-10-31")!
        let dayDoors = ThreadDoorPlan.doors(for: Address(.time, day: day), todaysKP: nil)
        XCTAssertEqual(dayDoors.filter { $0.kind == .across }.map(\.to.world), [.today, .memory, .well])
        XCTAssertTrue(dayDoors.contains { $0.to == Address(.time, day: Address.Day(iso: "2026-11-01")!) })

        XCTAssertTrue(ThreadDoorPlan.doors(for: Address(.beneath), todaysKP: 29).isEmpty,
                      "a place on no thread shows no doors")
        for d in doors + dayDoors {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(d.kicker).isEmpty, "a door's words measure him: \(d.kicker)")
            XCTAssertTrue(d.to.isValid)
        }
        XCTAssertEqual(Set((doors + dayDoors).map(\.id)).count, (doors + dayDoors).count, "two doors share an id")
        // Born red: kp 0 opens nothing.
        XCTAssertTrue(ThreadDoorPlan.doors(for: Address(.herHome, kp: 0), todaysKP: 0).isEmpty)
    }

    // MARK: Search (F #50)

    private let sparsha = SpineSearchShakti(kp: 33, title: "Sparśākarṣiṇī",
                                            spellings: ["Sparśākarṣiṇī", "Spar · SHAH · kar · shi · nee", "Sparśa", "स्पर्शाकर्षिणी"])

    func testSearchFindsHerByFourSpellingsAndOpensByPosition() {
        let index = SpineSearch.index(shaktis: [sparsha], chakras: [])
        for q in ["Sparśākarṣiṇī", "sparsakarsini", "SPARSHA", "shahkar", "Sparśa", "स्पर्श"] {
            let found = SpineSearch.results(for: q, in: index)
            XCTAssertTrue(found.contains { $0.to == Address(.herHome, kp: 33) }, "“\(q)” did not find her")
        }
        XCTAssertEqual(SpineSearch.prompt, "Type one word you're carrying")
        // Born red: a word she does not carry finds nothing, and nothing is found by nothing.
        XCTAssertTrue(SpineSearch.results(for: "zzqx", in: index).isEmpty)
        XCTAssertTrue(SpineSearch.results(for: "  ", in: index).isEmpty)
    }

    func testSearchFindsEveryWorldModeGameAndChakra() {
        let index = SpineSearch.index(shaktis: [], chakras: ChakraConstellation.all)
        for w in WorldID.allCases {
            let found = SpineSearch.results(for: WorldRegistry.entry(w).displayName, in: index, limit: 200)
            XCTAssertTrue(found.contains { $0.to == Address(w) }, "the world \(w) is not found by its name")
        }
        for m in TheModes.Mode.allCases {
            XCTAssertTrue(SpineSearch.results(for: m.title, in: index, limit: 200).contains { $0.to == Address(.modes, sub: m.rawValue) })
        }
        for g in PlayGame.allCases {
            XCTAssertTrue(SpineSearch.results(for: g.title, in: index, limit: 200).contains { $0.to == Address(.game, sub: g.rawValue) },
                          "the game \(g) is not found by its name")
        }
        XCTAssertEqual(ChakraConstellation.all.count, 33, "the bake is not in the bundle")
        for c in ChakraConstellation.all {
            XCTAssertTrue(SpineSearch.results(for: c.name, in: index, limit: 200).contains { $0.to == Address(.the33, chakra: c.road) },
                          "chakra \(c.road) is not found by its name")
        }
        XCTAssertEqual(Set(index.map(\.id)).count, index.count, "two places share an id")
    }

    // MARK: The Constellation (D #40)

    @MainActor
    func testTheConstellationIsHomesOwnRing() {
        XCTAssertEqual(ConstellationLayout.poeticThreads.count, 17, "seventeen poetic threads")
        let field = CGSize(width: 360, height: 640)
        XCTAssertEqual(ConstellationLayout.point(of: .home, in: field), CGPoint(x: 180, y: 320))
        let today = ConstellationLayout.point(of: .today, in: field)
        XCTAssertEqual(today.x, 180, accuracy: 1e-6, "Today stands straight up")
        XCTAssertLessThan(today.y, 320)
        XCTAssertEqual(ConstellationLayout.radius(in: field), 0.38 * 360, accuracy: 1e-9)
        XCTAssertEqual(ConstellationLayout.fieldSize(in: CGSize(width: 1000, height: 2000)), CGSize(width: 720, height: 820))
        XCTAssertEqual(ConstellationLayout.colouredThreads.map(\.hex), ["#C9963F", "#D62F29", "#F2E8D9"])
        XCTAssertEqual(ConstellationLayout.threadProgress(0, at: 0.39), 0, "a thread waits 400 ms")
        XCTAssertEqual(ConstellationLayout.threadProgress(0, at: 2.6), 1, accuracy: 1e-9, "and draws in over 2.2 s")
        XCTAssertEqual(ConstellationLayout.threadProgress(1, at: 0.48), 0, accuracy: 1e-9, "staggered 80 ms")
        XCTAssertEqual(ConstellationLayout.nodeArrival(0, at: 0.88), 1, accuracy: 1e-9)
        XCTAssertEqual(ConstellationLayout.nodeArrival(2, at: 0.19), 0, accuracy: 1e-9, "staggered 55 ms")
        // Every world has a place, and no two share one.
        let points = WorldID.allCases.map { ConstellationLayout.point(of: $0, in: field) }
        XCTAssertEqual(Set(points.map { "\(Int($0.x.rounded())),\(Int($0.y.rounded()))" }).count, 15)
        XCTAssertEqual(MenuList.order.count, 15)
        XCTAssertEqual(Set(MenuVeil.sky + MenuVeil.gates + MenuVeil.terraces + MenuVeil.beneathTheGround + [.home, .rings]),
                       Set(WorldID.allCases), "the Veil holds every world by depth")
    }

    // MARK: World Crossed (H #64)

    func testOneCrossingIsOneWorldCrossedRow() {
        let at = Date(timeIntervalSince1970: 1_800_000_000)
        let row = ActivityLedger.worldCrossed(from: .the33, to: .well, mandalaLink: "", mapRecordId: "recMap", at: at)
        XCTAssertEqual(row.type, ActivityLedger.ActivityType.worldCrossed)
        XCTAssertEqual(row.detail, "from The thirty-three to The Well")
        XCTAssertEqual(row.gestureSource, ActivityLedger.GestureSource.chakra, "the source is the world he left")
        XCTAssertEqual(row.linkToMap, ["recMap"])
        XCTAssertEqual(row.linkRecordId, "")
        XCTAssertTrue(NeverMeasure.measuresOutLoud(row.name + " " + row.detail).isEmpty)
        for w in WorldID.allCases {
            XCTAssertFalse(ActivityLedger.gestureSource(leaving: w).isEmpty)
        }
        let home = ActivityLedger.worldCrossed(from: .home, to: .today, mandalaLink: "recShakti", mapRecordId: nil, at: at)
        XCTAssertEqual(home.gestureSource, "Home")
        XCTAssertEqual(home.linkRecordId, "recShakti")
        XCTAssertNil(home.linkToMap)
        // Born red: the Map link is never an empty record.
        XCTAssertNil(ActivityLedger.worldCrossed(from: .home, to: .the33, mandalaLink: "", mapRecordId: "", at: at).linkToMap)
    }

    // MARK: The shell's wiring (source)

    func testTheShellStandsOnTheSpine() throws {
        let app = try XCTUnwrap(LawSource.production("AppRoot.swift"))
        let code = String(app.lexed.masked)
        XCTAssertTrue(code.contains("SpineRoot("), "the root is not the spine")
        XCTAssertTrue(code.contains("LaunchCeremony("), "the launch passes through no ceremony")
        let root = try XCTUnwrap(LawSource.production("SpineRoot.swift"))
        let rootCode = String(root.lexed.masked)
        XCTAssertTrue(rootCode.contains("SpineWorlds.registerAll()"), "the worlds are never registered")
        XCTAssertTrue(rootCode.contains("SpineServices.bootstrap("), "the launch work (seed, sync, summons) is gone")
        XCTAssertTrue(rootCode.contains("onWorldCrossed"), "crossings are not written to the ledger")
        XCTAssertNil(LawSource.production("HamburgerMenuView.swift"), "the hamburger is back")
        let services = try XCTUnwrap(LawSource.production("SpineServices.swift"))
        for call in ["ShaktiBootstrap.seedIfNeeded(", "RecognitionMigrator.backfillIfNeeded(",
                     "AirtableService.shared.sync(", "DailySummons.reschedule(", "EnergyGift.reschedule(",
                     "GiftRouter.shared.take("] {
            XCTAssertTrue(services.text.contains(call), "the shell no longer does \(call)")
        }
    }
}
