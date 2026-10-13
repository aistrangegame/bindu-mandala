import XCTest
@testable import Bindu_Mandala

// MARK: - Upgrade U2 · C · the worlds in their own spaces, proven
//
// `waves/upgrade/briefs/U2-spine-and-home.md` Part C: the Mandala cleared to
// the held yantra and the Veil; the Veil at Design's numbers (read from
// `waves/upgrade/worlds/mandala-and-rings.md`, never retyped alone); every
// other world hosted in its own space and registered; nothing in the hosted
// worlds laid over another; room first. Each check carries a planted defect it
// is shown to catch (V30).

private enum WorldFile {
    static func text(_ name: String) throws -> String {
        let u = SourceTree.repoRoot.appendingPathComponent("waves/upgrade/worlds/\(name)")
        guard let d = FileManager.default.contents(atPath: u.path), let s = String(data: d, encoding: .utf8) else {
            throw DesignCorpus.Missing(path: u.path + " (a world file — a missing source is a failure)")
        }
        return s
    }
}

final class U2WorldsTests: XCTestCase {

    // MARK: 1 · Every hosted world is registered

    @MainActor
    func testEveryWorldButHomeIsHostedAndRegistered() {
        XCTAssertEqual(Set(WorldBuilders.hostedWorlds), Set(WorldID.allCases).subtracting([.home]),
                       "Part C hosts every world but Home (Part A's)")
        WorldBuilders.registerHostedWorlds()
        defer { for w in WorldBuilders.hostedWorlds { WorldBuilders.unregister(w) } }
        for w in WorldBuilders.hostedWorlds {
            XCTAssertFalse(WorldBuilders.isPlaceholder(w), "\(w.rawValue) still draws as its placeholder")
        }
        // Born red: a world taken back out is a placeholder again, and seen.
        WorldBuilders.unregister(.well)
        XCTAssertTrue(WorldBuilders.isPlaceholder(.well))
    }

    // MARK: 2 · Nothing in a hosted world is laid over another

    static func coversAWorld(_ code: String) -> Bool {
        code.range(of: #"\.(sheet|fullScreenCover|popover)\s*\("#, options: .regularExpression) != nil
    }

    func testTheHostedWorldsLayNothingOverAnother() {
        let worlds = LawSource.production.filter { $0.path.hasPrefix("Worlds/") }
        XCTAssertGreaterThanOrEqual(worlds.count, 6, "the Worlds folder was not read: \(worlds.map(\.path))")
        for f in worlds {
            XCTAssertFalse(Self.coversAWorld(String(f.lexed.masked)), "\(f.path) lays a cover over a world")
        }
        // The screens that used to raise another world over themselves now cross.
        for (name, gone) in [("LivingMandalaView.swift", ".fullScreenCover("),
                             ("LivingMandalaView.swift", ".herRoom("),
                             ("DailyRiteView.swift", ".herRoom("),
                             ("DailyRiteView.swift", "ModeHost("),
                             ("DailyRiteView.swift", "LowStateDoorView("),
                             ("TheHundredTwoView.swift", "WorldClimbView("),
                             ("ShaktiDetailView.swift", ".herRoom("),
                             ("WorldClimbView.swift", ".herRoom("),
                             ("ClimbBodyChakras.swift", ".chakraRoom("),
                             ("PortraitMandalaView.swift", "ThePointView("),
                             ("PlayFieldView.swift", "ModesDoorView(")] {
            guard let f = LawSource.production(name) else { return XCTFail("\(name) is gone") }
            XCTAssertFalse(String(f.lexed.masked).contains(gone), "\(name) still raises \(gone) over its world")
        }
        // Born red.
        XCTAssertTrue(Self.coversAWorld("x.fullScreenCover(isPresented: $a) { WellView() }"))
        XCTAssertFalse(Self.coversAWorld("x.onChange(of: a) { _, _ in }"))
    }

    // MARK: 3 · The Mandala is the held yantra and the Veil

    /// What left the Mandala's glass (MX01–MX15).
    static let leftTheGlass = [
        "ChakraLayerOverlay(", "ChakraConstellationDrawing", "chakras:",   // the 33, the Road, thresholds
        "GatesOfReleaseLayer(", "TreeOfLifeRingLayer(", "mandalaFieldVoice(",  // the rings
        "TheCentre(", "MaunaView(", "LalitaSourceView(", "TheEightDissolutions(", // Home, the game
        "ModesDoorView(", "ChakraRingClimb(", "WaysInRingView(", "PlayField.open(", // modes, climb, ways
        "MandalaWays.", "ShaktiDetailView(",
    ]

    static func stillOnTheGlass(_ code: String) -> [String] {
        leftTheGlass.filter { code.contains($0) }
    }

    func testTheMandalaIsCleared() throws {
        let host = try XCTUnwrap(LawSource.production("LivingMandalaView.swift"))
        let code = String(host.lexed.masked)
        XCTAssertEqual(Self.stillOnTheGlass(code), [], "these still stand on the Mandala's glass")
        XCTAssertTrue(code.contains("MandalaVeilDrawer("), "the Veil is gone from the Mandala")
        XCTAssertTrue(code.contains("WorldDoors.herHome("), "a seat no longer opens her room")
        // Born red: each of them, planted, is seen.
        for planted in Self.leftTheGlass {
            XCTAssertEqual(Self.stillOnTheGlass("let x = " + planted), [planted])
        }
    }

    // MARK: 4 · The Veil at Design's numbers

    @MainActor
    func testTheVeilIsDesignsNumbers() throws {
        let file = try WorldFile.text("mandala-and-rings.md")
        // The numbers as the world file writes them.
        for words in ["720 high", "clamped 0…612", "under 6 px", "past 42%", "offset < 257.04",
                      ".52 s on cubic-bezier(.22,1,.36,1)", "0.5 + 0.5 × offset/612"] {
            XCTAssertTrue(file.contains(words), "mandala-and-rings.md no longer says \"\(words)\"")
        }
        let design = CGSize(width: 390, height: 844)
        XCTAssertEqual(MandalaVeilDrawer.designHeight, 720)
        XCTAssertEqual(MandalaVeilDrawer.peek, 108)
        XCTAssertEqual(MandalaVeilDrawer.closedOffset(in: design), 612)
        XCTAssertEqual(MandalaVeilDrawer.tapSlop, 6)
        XCTAssertEqual(MandalaVeilDrawer.seconds, 0.52, accuracy: 1e-9)
        XCTAssertEqual(Double(MandalaVeilDrawer.closedOffset(in: design) * MandalaVeilDrawer.snapFraction),
                       257.04, accuracy: 1e-6)
        // The release rule.
        let closed: CGFloat = 612
        XCTAssertEqual(MandalaVeilDrawer.settle(offset: 257, travelled: -355, from: closed, closed: closed), 0)
        XCTAssertEqual(MandalaVeilDrawer.settle(offset: 258, travelled: -354, from: closed, closed: closed), closed)
        XCTAssertEqual(MandalaVeilDrawer.settle(offset: closed - 3, travelled: -3, from: closed, closed: closed), 0,
                       "a tap on the resting peek raises the Veil")
        XCTAssertEqual(MandalaVeilDrawer.settle(offset: 4, travelled: 4, from: 0, closed: closed), closed,
                       "a tap on the risen edge lowers it")
        // The yantra dims with the sheet, never hidden.
        XCTAssertEqual(MandalaVeilDrawer.dim(offset: 0, closed: closed), 0.5, accuracy: 1e-9)
        XCTAssertEqual(MandalaVeilDrawer.dim(offset: closed, closed: closed), 1, accuracy: 1e-9)
        XCTAssertEqual(MandalaVeilDrawer.dim(offset: 306, closed: closed), 0.75, accuracy: 1e-9)
        // Born red: a drag of 6 is not a tap, and an old fixed dim is not this one.
        XCTAssertEqual(MandalaVeilDrawer.settle(offset: closed - 6, travelled: -6, from: closed, closed: closed), closed)
        XCTAssertNotEqual(MandalaVeilDrawer.dim(offset: 0, closed: closed), 0.55, accuracy: 1e-9)
        // A short glass keeps the peek.
        let short = CGSize(width: 375, height: 667)
        XCTAssertEqual(MandalaVeilDrawer.height(in: short) - MandalaVeilDrawer.closedOffset(in: short),
                       MandalaVeilDrawer.peek)
    }

    // MARK: 5 · Room first, and every door a crossing

    @MainActor
    func testRoomFirstAndTheDoorsCross() {
        let r = Router(directory: nil, launch: nil, settlesInstantly: true)
        WorldDoors.herHome(29, router: r)
        XCTAssertEqual(r.state.current, Address(.herHome, kp: 29))
        WorldDoors.herPresence(29, router: r)
        XCTAssertEqual(r.state.current, Address(.herPresence, kp: 29))
        XCTAssertTrue(r.back())
        XCTAssertEqual(r.state.current, Address(.herHome, kp: 29), "back from her page returns to her room")

        WorldDoors.ring(3, router: r)
        XCTAssertEqual(r.state.current, Address(.rings, sub: "ring.3"))
        WorldDoors.ring(12, router: r)
        XCTAssertEqual(r.state.current, Address(.rings, sub: "ring.9"), "a ring beyond the ninth is the ninth")
        WorldDoors.climb(ring: 4, router: r)
        XCTAssertEqual(r.state.current, Address(.climb, sub: "ring.4"))
        WorldDoors.chakraRoom(20, router: r)
        XCTAssertEqual(r.state.current, Address(.the33, chakra: 20, sub: WorldSub.room))
        WorldDoors.beneath(WorldSub.low, router: r)
        XCTAssertEqual(r.state.current, Address(.beneath, sub: "low"))
        WorldDoors.modes(.puja, router: r)
        XCTAssertEqual(r.state.current, Address(.modes, sub: TheModes.Mode.puja.rawValue))

        XCTAssertEqual(WorldSub.ring(in: "ring.1"), 1)
        XCTAssertEqual(WorldSub.ring(in: "ring.9"), 9)
        // Born red: no ring outside the nine, and no ring where none is named.
        XCTAssertNil(WorldSub.ring(in: "ring.0"))
        XCTAssertNil(WorldSub.ring(in: "ring.10"))
        XCTAssertNil(WorldSub.ring(in: "card"))
        XCTAssertNil(WorldSub.ring(in: nil))
    }

    // MARK: 6 · The Relationship Field's three, and its bridge

    @MainActor
    func testTheRelationshipFieldStandsOnItsThreeConnections() {
        let kps = Set(RelationshipWorld.connections.map(\.kp))
        XCTAssertEqual(kps, WorldRegistry.entry(.relationship).kpDoors ?? [],
                       "the world's doors and the registry's kp doors disagree")
        XCTAssertEqual(RelationshipWorld.bridge.kp, 41)
        // Born red.
        XCTAssertNotEqual(kps.union([41]), WorldRegistry.entry(.relationship).kpDoors ?? [])
    }
}
