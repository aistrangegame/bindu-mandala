import XCTest
@testable import Bindu_Mandala

// MARK: - Upgrade U1 · A · the Router, proven
//
// The U1 brief, Part A 6: every world reachable from `home()` by `go`; back
// returns the exact address; nothing overlays (one world mounted at a time,
// asserted on the router's state). With them: the registry is whole and its
// numbers are the world files' (`waves/upgrade/worlds/spine-and-home.md`,
// `visual.md`, `game.md` — read off disk, never retyped; a missing world file
// is a failure, never a skip), the crossing library's numbers and keyframes
// are Design's, every address has a link, the journey survives a relaunch, and
// each of the six channels has its Router call. Every check carries a planted
// defect beside it that it is shown to catch (V30).

/// The world files, read off disk (the checkout on the Mac).
private enum RouterSources {

    static func url(_ name: String) -> URL {
        SourceTree.repoRoot.appendingPathComponent("waves/upgrade/worlds/\(name)")
    }

    static func text(_ name: String) throws -> String {
        let u = url(name)
        guard let d = FileManager.default.contents(atPath: u.path), let s = String(data: d, encoding: .utf8) else {
            throw DesignCorpus.Missing(path: u.path + " (a world file — a missing source is a failure)")
        }
        return s
    }

    struct NoMatch: Error, CustomStringConvertible {
        let pattern: String
        var description: String { "the world file no longer says \(pattern)" }
    }

    /// The capture groups of the first match, or a thrown failure.
    static func groups(_ pattern: String, in text: String) throws -> [String] {
        let re = try NSRegularExpression(pattern: pattern)
        let ns = text as NSString
        guard let m = re.firstMatch(in: text, range: NSRange(location: 0, length: ns.length)) else {
            throw NoMatch(pattern: pattern)
        }
        return (1..<m.numberOfRanges).map { i in
            m.range(at: i).location == NSNotFound ? "" : ns.substring(with: m.range(at: i))
        }
    }

    /// A number as Design writes it (`.30`, `2.35`, `780`).
    static func number(_ s: String) -> Double? {
        Double(s.hasPrefix(".") ? "0" + s : s)
    }

    /// The number in one capture group of the first match, or a thrown failure.
    static func read(_ pattern: String, _ text: String, _ group: Int) throws -> Double {
        let g = try groups(pattern, in: text)
        guard group < g.count, let v = number(g[group]) else { throw NoMatch(pattern: pattern) }
        return v
    }
}

final class U1RouterTests: XCTestCase {

    // MARK: 1 · The registry is whole

    /// Every station index 0…13 once, Home alone at the centre, every world once.
    static func stationsAreWhole(_ entries: [WorldEntry]) -> Bool {
        let rings = entries.compactMap { $0.station.index }
        let centres = entries.filter { $0.station == .centre }
        return Set(entries.map(\.id)) == Set(WorldID.allCases) && entries.count == WorldID.allCases.count
            && rings.sorted() == Array(0..<WorldEntry.Station.count)
            && centres.map(\.id) == [.home]
    }

    func testTheRegistryHoldsEveryWorldOnce() {
        let entries = WorldRegistry.entries
        XCTAssertEqual(entries.map(\.id), WorldID.allCases)
        XCTAssertTrue(Self.stationsAreWhole(entries))
        XCTAssertEqual(WorldRegistry.stations.count, 14)
        XCTAssertEqual(WorldRegistry.stations.first?.id, .today, "Today is the first door (ruling 1)")
        XCTAssertEqual(Set(entries.map(\.displayName)).count, 15, "two worlds share a name")
        XCTAssertEqual(Set(entries.map(\.essenceHex)).count, 15, "two worlds bloom in one colour")
        for e in entries {
            XCTAssertNotNil(e.essenceHex.range(of: #"^#[0-9A-F]{6}$"#, options: .regularExpression), "\(e.id): \(e.essenceHex)")
            XCTAssertTrue(NeverMeasure.measuresOutLoud(e.displayName).isEmpty, e.displayName)
            XCTAssertEqual(WorldRegistry.entry(e.id), e)
        }
        // Born red: a registry with a station twice, or a world missing, is caught.
        var twice = entries
        twice[2] = WorldEntry(id: twice[2].id, displayName: twice[2].displayName, station: .ring(0),
                              essenceHex: twice[2].essenceHex, colourSource: twice[2].colourSource,
                              threads: twice[2].threads, kpDoors: twice[2].kpDoors, arrival: twice[2].arrival)
        XCTAssertFalse(Self.stationsAreWhole(twice))
        XCTAssertFalse(Self.stationsAreWhole(Array(entries.dropLast())))
    }

    /// §1 "Being there" #2: "r ≈ 148 pt: Today at 12 o'clock, then clockwise
    /// Her Presence, Her Home, the Mandala, …" — read from the world file.
    func testTheStationRingIsTheWorldFilesOrder() throws {
        let text = try RouterSources.text("spine-and-home.md")
        let g = try RouterSources.groups(#"r ≈ (\d+) pt: \*\*Today at 12 o'clock\*\*, then clockwise ([^.]+)\."#, in: text)
        let fileOrder = ["Today"] + g[1].components(separatedBy: ", ")
        let registryOrder = WorldRegistry.stations.map(\.displayName)
        XCTAssertEqual(registryOrder, fileOrder)
        XCTAssertEqual(WorldEntry.Station.radius, RouterSources.number(g[0]))
        XCTAssertEqual(fileOrder.count, WorldEntry.Station.count)

        // Geometry: Today straight up, A Strange Game (the eighth) straight down.
        let today = WorldRegistry.entry(.today).station.offset
        XCTAssertEqual(today.x, 0, accuracy: 1e-9)
        XCTAssertEqual(today.y, -148, accuracy: 1e-9)
        let game = WorldRegistry.entry(.game).station.offset
        XCTAssertEqual(game.x, 0, accuracy: 1e-9)
        XCTAssertEqual(game.y, 148, accuracy: 1e-9)
        XCTAssertGreaterThan(WorldRegistry.entry(.herPresence).station.offset.x, 0, "the ring does not run clockwise")

        // Born red: two neighbours swapped are not the file's order.
        var swapped = registryOrder
        swapped.swapAt(1, 2)
        XCTAssertNotEqual(swapped, fileOrder)
    }

    /// Every world's colour is found, as written, in the file it is cited from.
    func testEveryEssenceColourIsReadFromItsSource() throws {
        var files: [String: String] = [:]
        for e in WorldRegistry.entries {
            let file = e.colourSource.file
            if files[file] == nil { files[file] = try RouterSources.text(file).uppercased() }
            XCTAssertTrue(files[file]?.contains(e.essenceHex.uppercased()) ?? false,
                          "\(e.id)'s \(e.essenceHex) is not in \(file) (\(e.colourSource.section))")
        }
        // Born red: an invented colour is not found.
        XCTAssertFalse(try RouterSources.text("visual.md").uppercased().contains("#123457"))
    }

    // MARK: 2 · Every world is reachable from home() by go

    @MainActor
    func testEveryWorldIsReachableFromHomeByGo() {
        let r = Router(directory: nil, launch: nil, settlesInstantly: true)
        XCTAssertEqual(r.state.current, .home)
        for w in WorldID.allCases where w != .home {
            _ = r.home()
            XCTAssertEqual(r.state.current, .home)
            XCTAssertTrue(r.go(to: Address(w)), "\(w) refused")
            XCTAssertEqual(r.state.current.world, w)
            XCTAssertEqual(r.mounted.world, w, "\(w) was routed but not mounted")
            XCTAssertTrue(r.back())
            XCTAssertEqual(r.mounted, .home)
        }

        // By every thread door (§2 E #47): kp 1–102, chakra 1–33, a day.
        var reached: Set<WorldID> = []
        for kp in Address.kpRange {
            for a in WorldRegistry.doors(kp: kp) {
                _ = r.home()
                XCTAssertTrue(r.go(to: a), "kp \(kp) → \(a.world)")
                XCTAssertEqual(r.mounted, a)
                reached.insert(a.world)
            }
        }
        for ch in Address.chakraRange {
            for a in WorldRegistry.doors(chakra: ch) {
                _ = r.home()
                XCTAssertTrue(r.go(to: a), "chakra \(ch) → \(a.world)")
                XCTAssertEqual(r.mounted, a)
                reached.insert(a.world)
            }
        }
        let day = Address.Day(iso: "2026-10-13")!
        for a in WorldRegistry.doors(day: day) {
            _ = r.home()
            XCTAssertTrue(r.go(to: a))
            reached.insert(a.world)
        }
        XCTAssertEqual(reached, [.today, .herPresence, .herHome, .mandala, .rings, .climb, .relationship,
                                 .the33, .game, .time, .memory, .well])
        XCTAssertEqual(WorldRegistry.doors(kp: 40).map(\.world).last, .relationship)
        XCTAssertFalse(WorldRegistry.doors(kp: 29).contains { $0.world == .relationship },
                       "the Field's kp door opens only on its three connections")

        // Born red: an address off the garland or the Road is refused, and he stays.
        _ = r.home()
        XCTAssertFalse(r.go(to: Address(.herHome, kp: 0)))
        XCTAssertFalse(r.go(to: Address(.herHome, kp: 103)))
        XCTAssertFalse(r.go(to: Address(.the33, chakra: 34)))
        XCTAssertFalse(r.go(to: .home), "the place he stands on is not a crossing")
        XCTAssertEqual(r.state.current, .home)
        XCTAssertTrue(WorldRegistry.doors(kp: 103).isEmpty)
        XCTAssertTrue(WorldRegistry.doors(chakra: 0).isEmpty)
    }

    // MARK: 3 · Back returns the exact address

    @MainActor
    func testBackReturnsTheExactAddress() {
        let r = Router(directory: nil, launch: nil, settlesInstantly: true)
        let a = Address(.herHome, kp: 29, anchor: .init(scale: 1.4, offsetX: 12, offsetY: -3))
        let b = Address(.the33, chakra: 7, anchor: .init(scrollStep: 3))
        let c = Address(.time, day: Address.Day(iso: "2026-10-13"))
        XCTAssertTrue(r.go(to: a))
        XCTAssertTrue(r.go(to: b))
        XCTAssertTrue(r.go(to: c))
        XCTAssertTrue(r.back()); XCTAssertEqual(r.state.current, b); XCTAssertEqual(r.mounted, b)
        XCTAssertTrue(r.back()); XCTAssertEqual(r.state.current, a); XCTAssertEqual(r.mounted, a)
        XCTAssertTrue(r.back()); XCTAssertEqual(r.state.current, .home)
        XCTAssertFalse(r.back(), "at Home with no way back, back does nothing")

        // The camera he leaves a place at is the camera he comes back to.
        let still = Address(.mandala, kp: 63)
        let rest = Address.Anchor(scale: 2.2, zoom: 0.7)
        XCTAssertTrue(r.go(to: still))
        r.note(anchor: rest)
        XCTAssertTrue(r.go(to: Address(.well)))
        XCTAssertTrue(r.back())
        XCTAssertEqual(r.state.current.anchor, rest)
        XCTAssertEqual(r.mounted.anchor, rest)

        // Home and back: the point's tap remembers where he stood.
        XCTAssertTrue(r.home())
        XCTAssertTrue(r.back())
        XCTAssertEqual(r.state.current, Address(.mandala, kp: 63, anchor: rest))

        // With no way back, the edge still leads out — Home.
        let launched = Router(directory: nil, launch: Address(.well), settlesInstantly: true)
        XCTAssertTrue(launched.back())
        XCTAssertEqual(launched.state.current, .home)

        // Born red: equality holds the camera, so a back that lost it is caught.
        XCTAssertNotEqual(a.place, a)
        XCTAssertEqual(a.place, Address(.herHome, kp: 29))
    }

    // MARK: 4 · Nothing overlays — one world mounted at a time

    @MainActor
    func testOneWorldIsMountedAtATime() {
        let r = Router(directory: nil, launch: nil, settlesInstantly: false)
        XCTAssertTrue(r.go(to: Address(.well), via: .descent()))
        XCTAssertEqual(r.state.current.world, .well, "the state moves at the touch")
        XCTAssertEqual(r.mounted, .home, "the destination mounted before the crossing's beat")
        XCTAssertEqual(r.inFlight?.to.world, .well)
        XCTAssertEqual(r.inFlight?.timing.mountAt ?? 0, Crossing.descentSeconds * Crossing.descentSeam, accuracy: 1e-9)
        r.settle()
        XCTAssertEqual(r.mounted.world, .well)
        XCTAssertNil(r.inFlight)

        // Two crossings in quick succession: still exactly one world, the old one,
        // until the last crossing mounts.
        XCTAssertTrue(r.go(to: Address(.today), via: .blink()))
        XCTAssertTrue(r.go(to: Address(.time)))
        XCTAssertEqual(r.mounted.world, .well)
        XCTAssertEqual(r.inFlight?.from.world, .today)
        r.settle()
        XCTAssertEqual(r.mounted.world, .time)
    }

    /// No world is presented over another: nothing in the spine opens a sheet,
    /// a cover or a popover, and the root mounts exactly one `WorldHost`.
    static func presentsOverAWorld(_ code: String) -> Bool {
        code.range(of: #"\.(sheet|fullScreenCover|popover)\s*\("#, options: .regularExpression) != nil
    }

    func testTheSpineLaysNothingOverAWorld() throws {
        let spine = LawSource.production.filter { $0.path.hasPrefix("Spine/") }
        XCTAssertGreaterThanOrEqual(spine.count, 8, "the Spine folder was not read: \(spine.map(\.path))")
        for f in spine {
            XCTAssertFalse(Self.presentsOverAWorld(String(f.lexed.masked)), "\(f.path) lays something over a world")
        }
        let hosts = LawSource.production.reduce(0) { n, f in
            n + Rx.all(#"\bWorldHost\("#, String(f.lexed.masked)).count
        }
        XCTAssertEqual(hosts, 1, "the world is mounted in \(hosts) places — one root, one world")
        // Born red.
        XCTAssertTrue(Self.presentsOverAWorld("content.fullScreenCover(isPresented: $x) { WellView() }"))
        XCTAssertTrue(Self.presentsOverAWorld(".sheet (item: $s) { s in S() }"))
    }

    // MARK: 5 · Where he was survives a relaunch

    @MainActor
    func testWhereHeWasSurvivesARelaunch() throws {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("u1-router-\(UUID().uuidString)", isDirectory: true)
        defer { try? FileManager.default.removeItem(at: dir) }

        let a = Address(.herHome, kp: 29, anchor: .init(scale: 1.2))
        let b = Address(.the33, chakra: 7)
        let first = Router(directory: dir, launch: nil, settlesInstantly: true)
        XCTAssertTrue(first.go(to: a))
        XCTAssertTrue(first.go(to: b))
        XCTAssertTrue(FileManager.default.fileExists(atPath:
            PracticeVault.fileURL(named: Router.journeyFile, in: dir).path), "the journey was not kept")

        let next = Router(directory: dir, launch: nil, settlesInstantly: true)
        XCTAssertEqual(next.state.current, .home, "a launch arrives at the Bindu (ruling 1)")
        XCTAssertEqual(next.mounted, .home)
        XCTAssertEqual(next.state.before, b, "where he stood was lost")
        XCTAssertEqual(next.state.lastByWorld[WorldID.herHome.rawValue], a, "her Home's place lost its camera")
        XCTAssertEqual(next.state.beads, [a, b], "the Road Home's beads, in station order")
        XCTAssertTrue(next.state.backStack.isEmpty)

        // The walk's address still wins a launch (DEBUG).
        let walked = Router(directory: dir, launch: Address(.well), settlesInstantly: true)
        XCTAssertEqual(walked.state.current, Address(.well))

        // The journey is plain JSON that comes back whole.
        let data = try JSONEncoder().encode(first.state)
        XCTAssertEqual(try JSONDecoder().decode(NavigationState.self, from: data), first.state)

        // Born red: a relaunch that kept no bead is not the state that was saved.
        var lost = first.state.relaunched()
        lost.lastByWorld = [:]
        XCTAssertNotEqual(lost, first.state.relaunched())
    }

    func testADayIsWrittenAndReadAsItsDate() throws {
        let d = try XCTUnwrap(Address.Day(iso: "2026-10-13"))
        XCTAssertEqual(d.iso, "2026-10-13")
        XCTAssertEqual(d.adding(days: 1).iso, "2026-10-14")
        XCTAssertEqual(d.adding(days: -13).iso, "2026-09-30")
        let data = try JSONEncoder().encode(Address(.well, day: d))
        XCTAssertTrue(String(decoding: data, as: UTF8.self).contains("\"2026-10-13\""))
        XCTAssertEqual(try JSONDecoder().decode(Address.self, from: data).day, d)
        // Born red: days that do not exist.
        XCTAssertNil(Address.Day(iso: "2026-02-30"))
        XCTAssertNil(Address.Day(iso: "2026-13-01"))
        XCTAssertNil(Address.Day(iso: "13 Oct"))
    }

    // MARK: 6 · The crossing library is the world files'

    func testTheCrossingNumbersAreTheWorldFiles() throws {
        let s = try RouterSources.text("spine-and-home.md")
        let n = RouterSources.read
        XCTAssertEqual(Crossing.gatherSeconds, try n(#"Gather \((\.\d+) s\)"#, s, 0))
        XCTAssertEqual(Crossing.bloomSeconds, try n(#"Bloom \((\.\d+) s\)"#, s, 0))
        XCTAssertEqual(Crossing.bloomMountSeconds, try n(#"the destination mounts at (\.\d+) s"#, s, 0))
        XCTAssertEqual(Crossing.bloomReach, try n(#"to (\d+(?:\.\d+)?) × the larger side"#, s, 0))
        XCTAssertEqual(Crossing.gatherScale, try n(#"draws toward the point \(×(\.\d+)\)"#, s, 0))
        XCTAssertEqual(Crossing.reducedSeconds, try n(#"Reduced motion: (\.\d+) s cross-fade"#, s, 0))
        XCTAssertEqual(Crossing.dissolveSeconds, try n(#"Within a world: dissolve (\.\d+) s"#, s, 0))
        XCTAssertEqual(Crossing.veilLightSeconds, try n(#"Veil bloom into light (\d+\.\d+) s / into dark (\d+\.\d+) s"#, s, 0))
        XCTAssertEqual(Crossing.veilDarkSeconds, try n(#"Veil bloom into light (\d+\.\d+) s / into dark (\d+\.\d+) s"#, s, 1))
        XCTAssertEqual(Crossing.passageSeconds, try n(#"the passage (\d+\.\d+) s \(#58\)"#, s, 0))
        XCTAssertEqual(Crossing.passageLandingSeconds, try n(#"landing (\.\d+) s smear"#, s, 0))
        XCTAssertEqual(Crossing.descentSeconds, try n(#"(\d+\.\d+) s cubic-bezier\(\.66,0,\.24,1\): dark plane"#, s, 0))
        XCTAssertEqual(Crossing.descentSeam, try n(#"haptic \.9/\.15 at (\d+)%"#, s, 0) / 100)
        XCTAssertEqual(Crossing.descentEmberPoints, try n(#"ember (\d+) pt 0 → 1@13%"#, s, 0))
        XCTAssertEqual(Crossing.blinkLidSeconds, try n(#"lids grow 0 → 50% over (\.\d+) s"#, s, 0))
        XCTAssertEqual(Crossing.blinkOpenSeconds, try n(#"the Rite opens at (\d+) ms"#, s, 0) / 1000)
        XCTAssertEqual(Crossing.blinkGlintDelay, try n(#"the seam glints after (\.\d+) s \(glint (\.\d+) s\)"#, s, 0))
        XCTAssertEqual(Crossing.blinkGlintSeconds, try n(#"the seam glints after (\.\d+) s \(glint (\.\d+) s\)"#, s, 1))
        XCTAssertEqual(Crossing.returnWindowMinutes, try n(#"Going back within (\d+) min"#, s, 0))
        XCTAssertEqual(Crossing.returnSettleSeconds, try n(#"settles over (\d+) ms"#, s, 0) / 1000)

        // The curves, from `visual.md`'s shared motion constants.
        let v = try RouterSources.text("visual.md")
        func curve(_ name: String) throws -> (Crossing.Curve, Double) {
            let g = try RouterSources.groups(#"\| `\#(name)` \| \(([\d.]+), ([\d.]+), ([\d.]+), ([\d.]+)\)[^|]*\| ([\d.]+) s"#, in: v)
            let d = g.compactMap(RouterSources.number)
            XCTAssertEqual(d.count, 5, name)
            return (Crossing.Curve(c1x: d[0], c1y: d[1], c2x: d[2], c2y: d[3]), d[4])
        }
        let descent = try curve("descent")
        XCTAssertEqual(Crossing.Curve.descent, descent.0)
        XCTAssertEqual(Crossing.descentSeconds, descent.1)
        let blink = try curve("blinkLids")
        XCTAssertEqual(Crossing.Curve.blinkLids, blink.0)
        XCTAssertEqual(Crossing.blinkLidSeconds, blink.1)
        let light = try curve("veilLight")
        XCTAssertEqual(Crossing.Curve.veilLight, light.0)
        XCTAssertEqual(Crossing.veilLightSeconds, light.1)
        let dark = try curve("veilDark")
        XCTAssertEqual(Crossing.Curve.veilDark, dark.0)
        XCTAssertEqual(Crossing.veilDarkSeconds, dark.1)
        let bloom = try RouterSources.groups(#"; bloom \(([\d.]+), ([\d.]+), ([\d.]+), ([\d.]+)\)"#, in: v)
            .compactMap(RouterSources.number)
        XCTAssertEqual(Crossing.Curve.bloom, Crossing.Curve(c1x: bloom[0], c1y: bloom[1], c2x: bloom[2], c2y: bloom[3]))

        // The clock each kind keeps.
        XCTAssertEqual(Crossing.bloomTiming.total, 1.02, accuracy: 1e-9)
        XCTAssertEqual(Crossing.bloomTiming.mountAt, 0.92, accuracy: 1e-9)
        XCTAssertEqual(Crossing.blink().timing().mountAt, 0.78, accuracy: 1e-9)
        XCTAssertEqual(Crossing.descent().timing().total, 2.35, accuracy: 1e-9)
        for kind in Crossing.Kind.allCases {
            let t = Crossing(kind: kind).timing(reduceMotion: true)
            XCTAssertTrue(t.isReduced)
            XCTAssertEqual(t.total, Crossing.reducedSeconds, "\(kind) under reduced motion")
            let full = Crossing(kind: kind).timing()
            XCTAssertLessThanOrEqual(full.mountAt, full.total, "\(kind) mounts after it ends")
        }

        // Born red: a number the file does not say is not found.
        XCTAssertThrowsError(try n(#"Gather \((\.31) s\)"#, s, 0))
    }

    /// #55 and #56's keyframes, written back in Design's notation, are the
    /// world file's own words.
    func testTheKeyframesAreDesignsOwnWords() throws {
        let s = try RouterSources.text("spine-and-home.md")
        XCTAssertTrue(s.contains("bloom opacity " + Crossing.bloomOpacity.designNotation), Crossing.bloomOpacity.designNotation)
        XCTAssertTrue(s.contains("scale " + Crossing.bloomScale.designNotation + ", fill radial"), Crossing.bloomScale.designNotation)
        XCTAssertTrue(s.contains("scale " + Crossing.descentEmberScale.designNotation + "; a ~4% band"),
                      Crossing.descentEmberScale.designNotation)
        XCTAssertTrue(s.contains(Crossing.descentPlaneHexes.joined(separator: ", ").replacingOccurrences(of: "#0A0806", with: "#0A0806 55%")))
        let fill = try RouterSources.groups(#"rgba\(255,248,232,(\.\d+)\), rgba\(247,213,163,(\.\d+)\) (\d+)%, transparent (\d+)%"#, in: s)
            .compactMap(RouterSources.number)
        XCTAssertEqual(Crossing.bloomFillStops.map { $0.opacity }, [fill[0], fill[1], 0])
        XCTAssertEqual(Crossing.bloomFillStops.map { $0.location }, [0, fill[2] / 100, fill[3] / 100])

        // The tracks themselves.
        XCTAssertEqual(Crossing.bloomScale.value(at: 0), 0.04, accuracy: 1e-12)
        XCTAssertEqual(Crossing.bloomScale.value(at: 0.62), 1, accuracy: 1e-12)
        XCTAssertEqual(Crossing.bloomOpacity.value(at: 0.38), (0.95 + 0.5) / 2, accuracy: 1e-12)
        XCTAssertEqual(Crossing.Curve.linear.value(at: 0.3), 0.3, accuracy: 1e-6)
        XCTAssertEqual(Crossing.Curve.descent.value(at: 0), 0)
        XCTAssertEqual(Crossing.Curve.descent.value(at: 1), 1)
        XCTAssertLessThan(Crossing.Curve.descent.value(at: 0.25), 0.25, "the descent does not start slow")

        // Born red: a track one stop off is not the file's.
        let off = Keyframes([(0, 0), (0.14, 0.9), (0.62, 0.5), (1, 0)])
        XCTAssertFalse(s.contains("bloom opacity " + off.designNotation))
    }

    // MARK: 7 · Every address has a link

    func testEveryAddressHasALinkAndBack() throws {
        for kp in 0...103 {
            let a = DeepLink.address(forKP: kp)
            XCTAssertEqual(a != nil, Address.kpRange.contains(kp), "kp \(kp)")
            guard let a else { continue }
            XCTAssertEqual(a, Address(.herHome, kp: kp))
            XCTAssertEqual(DeepLink.address(from: DeepLink.url(for: a)), a)
            XCTAssertEqual(DeepLink.address(from: try XCTUnwrap(URL(string: "bindu://kp/\(kp)"))), a)
        }
        for ch in 0...34 {
            let a = DeepLink.address(forRoad: ch)
            XCTAssertEqual(a != nil, Address.chakraRange.contains(ch), "road \(ch)")
            guard let a else { continue }
            XCTAssertEqual(DeepLink.address(from: DeepLink.url(for: a)), a)
            XCTAssertEqual(DeepLink.address(from: try XCTUnwrap(URL(string: "bindu://road/\(ch)"))), a)
        }
        for w in WorldID.allCases {
            XCTAssertEqual(DeepLink.address(from: try XCTUnwrap(URL(string: "bindu://world/\(w.rawValue)"))), Address(w))
            XCTAssertEqual(DeepLink.address(from: DeepLink.url(for: Address(w))), Address(w))
        }
        let full = Address(.time, kp: 40, chakra: 7, day: Address.Day(iso: "2026-10-13"), sub: "dawn & dusk",
                           anchor: .init(zoom: 3))
        let url = DeepLink.url(for: full)
        XCTAssertEqual(url.scheme, "bindu")
        XCTAssertEqual(DeepLink.address(from: url), full.place, "the camera stays on the phone")
        XCTAssertEqual(DeepLink.address(from: try XCTUnwrap(URL(string: "bindu://day/2026-10-13"))),
                       Address(.today, day: Address.Day(iso: "2026-10-13")))

        // Born red: links that name no address.
        for bad in ["bindu://place?world=nowhere", "bindu://place?world=herHome&kp=103",
                    "bindu://place?world=time&day=2026-02-30", "bindu://place?world=the33&ch=x",
                    "https://place?world=home", "bindu://kp/0", "bindu://road/34", "bindu://elsewhere/1"] {
            XCTAssertNil(DeepLink.address(from: try XCTUnwrap(URL(string: bad))), bad)
        }
    }

    /// `OPEN_WORLD` routes through the Router's launch address, and
    /// `OPEN_PLACE=world:kp:ch:day` opens any address (§2 J #75).
    func testTheWalksLaunchArgumentsNameAddresses() throws {
        XCTAssertEqual(DeepLink.place(fromLaunchValue: "herHome:29::"), Address(.herHome, kp: 29))
        XCTAssertEqual(DeepLink.place(fromLaunchValue: "the33::7:"), Address(.the33, chakra: 7))
        XCTAssertEqual(DeepLink.place(fromLaunchValue: "time:::2026-10-13"), Address(.time, day: Address.Day(iso: "2026-10-13")))
        XCTAssertEqual(DeepLink.place(fromLaunchValue: "well"), Address(.well))
        XCTAssertEqual(DeepLink.launchAddress(arguments: ["OPEN_WORLD=well"]), Address(.well))
        XCTAssertEqual(DeepLink.launchAddress(arguments: ["OPEN_WORLD=well", "OPEN_PLACE=herHome:29::"]),
                       Address(.herHome, kp: 29), "the last wins")
        XCTAssertEqual(DeepLink.launchAddress(arguments: ["OPEN_PLACE=herHome:29::", "OPEN_WORLD=well"]),
                       Address(.well), "the last wins")
        XCTAssertNil(DeepLink.launchAddress(arguments: []))
        XCTAssertNil(DeepLink.launchAddress(arguments: ["START_TAB=well"]))

        // The shell reads OPEN_WORLD through here, and only in DEBUG.
        // U2 · the root is the Router's: it takes its launch address from here.
        let router = try XCTUnwrap(LawSource.production("Router.swift"))
        XCTAssertTrue(String(router.lexed.masked).contains("DeepLink.launchAddress("),
                      "the Router reads OPEN_WORLD around itself")
        XCTAssertNil(LawSource.production("RootView.swift"), "the retired RootView is back")
        let link = try XCTUnwrap(LawSource.production("DeepLink.swift"))
        XCTAssertTrue(link.text.contains("#if DEBUG"), "OPEN_PLACE is honoured outside DEBUG")

        // Born red.
        for bad in ["herHome:x::", "nowhere:1::", "herHome:103::", "the33::34:", "time:::2026-02-30", "home:1:2:2026-10-13:extra"] {
            XCTAssertNil(DeepLink.place(fromLaunchValue: bad), bad)
        }
    }

    // MARK: 8 · The six channels are gone; each poster calls its Router method
    //
    // U2 · B: U1 bridged the six NotificationCenter channels; U2 switched every
    // poster to its Router call and removed the channels (§2 J #71).

    /// The poster of each retired channel, and the Router call it now makes.
    static let posters: [(file: String, call: String)] = [
        ("RecognitionMomentView.swift", "Router.shared.recognitionSettled("),
        ("WaysIn.swift", "Router.shared.askWay("),
        ("EnergyGift.swift", "Router.shared.giftOpened("),
        ("PlayGame.swift", "Router.shared.openPlay("),
        ("HomecomingView.swift", "Router.shared.reEnterHomecoming("),
        ("HomeAfterEffect.swift", "Router.shared.leftHerRoom("),
    ]

    func testNoNotificationChannelIsLeft() throws {
        let declared: [String] = LawSource.production.flatMap { f in
            Rx.groups(#"Notification\.Name\(\s*"([^"]+)"\s*\)"#, f.text).map { "\(f.path) · \($0[1])" }
        }
        XCTAssertEqual(declared, [], "a NotificationCenter channel routes around the Router")
        for p in Self.posters {
            let f = try XCTUnwrap(LawSource.production(p.file), p.file)
            let code = String(f.lexed.masked)
            XCTAssertTrue(code.contains(p.call), "\(p.file) no longer calls \(p.call)")
            XCTAssertFalse(code.contains("NotificationCenter.default.post"), "\(p.file) still posts a notification")
        }
        let presenters = LawSource.production.filter {
            let code = String($0.lexed.masked)
            return code.contains("func playFieldPresenter(") || code.contains("func leelaDrops(")
        }
        XCTAssertEqual(presenters.map(\.path), [], "a global presenter is back")
        // Born red: a declared channel is seen.
        XCTAssertFalse(Rx.groups(#"Notification\.Name\(\s*"([^"]+)"\s*\)"#,
                                 #"static let x = Notification.Name("bindu.somewhere.new")"#).isEmpty)
    }

    @MainActor
    func testEachPosterReachesItsRouterCall() throws {
        let r = Router(directory: nil, launch: nil, settlesInstantly: true)

        r.recognitionSettled(source: AirtableService.RecognitionSource.mandala.rawValue)
        XCTAssertEqual(r.state.current.world, .memory, "Recognition settles into Memory from every source")
        XCTAssertTrue(r.back())
        XCTAssertEqual(r.state.current, .home, "back returns him to where he felt her")

        r.askWay(.modes)
        XCTAssertEqual(r.state.current.world, .modes)

        r.giftOpened(kp: 29)
        XCTAssertEqual(r.state.current, Address(.home, kp: 29, sub: Address.cardSub))

        let game = try XCTUnwrap(PlayGame.allCases.first)
        r.openPlay(game)
        XCTAssertEqual(r.state.current, Address(.game, sub: game.rawValue))
        r.openPlay(nil)
        XCTAssertEqual(r.state.current, Address(.game), "the whole field")

        r.reEnterHomecoming()
        XCTAssertEqual(r.state.current, .home)
        XCTAssertEqual(r.takeCeremony(), .homecoming)
        XCTAssertNil(r.takeCeremony(), "the Homecoming was owed twice")

        r.leftHerRoom(ring: 3)
        XCTAssertEqual(r.afterEffect?.ring, 3)

        r.leelaDropped(id: "drop-7")
        XCTAssertEqual(r.state.current, Address(.game, sub: Address.leelaSubPrefix + "drop-7"))
        XCTAssertEqual(r.state.current.leelaDropID, "drop-7")

        // Born red: a way that does not exist is not a way.
        XCTAssertNil(WayIn(rawValue: "nowhere"))
    }

    // MARK: 9 · The crossing blooms in the right colour, and is remembered once

    @MainActor
    func testTheCrossingCarriesTheColourAndCountsOnlyBetweenWorlds() {
        let r = Router(directory: nil, launch: nil, settlesInstantly: true)
        var crossings: [String] = []
        r.onWorldCrossed = { from, to in crossings.append("\(from.world.rawValue)>\(to.world.rawValue)") }

        XCTAssertTrue(r.go(to: Address(.well), via: .descent()))
        XCTAssertEqual(r.lastCrossing?.colourHex, WorldRegistry.entry(.well).essenceHex, "a crossing blooms in the world entered")
        XCTAssertEqual(r.lastCrossing?.crossing.kind, .descent)
        XCTAssertTrue(r.back())
        XCTAssertEqual(r.lastCrossing?.colourHex, WorldRegistry.entry(.well).essenceHex, "back blooms in the colour he left")

        XCTAssertTrue(r.go(to: Address(.herHome, kp: 29)))
        XCTAssertTrue(r.go(to: Address(.herHome, kp: 30)))   // within a world
        XCTAssertTrue(r.back())                              // within a world
        XCTAssertTrue(r.back())                              // to Home
        XCTAssertEqual(crossings, ["home>well", "well>home", "home>herHome", "herHome>home"])

        r.colourResolver = { $0.world == .the33 ? "#B04F8C" : nil }
        XCTAssertTrue(r.go(to: Address(.the33, chakra: 7)))
        XCTAssertEqual(r.lastCrossing?.colourHex, "#B04F8C", "the finer colour was not taken")

        r.reduceMotion = true
        XCTAssertTrue(r.home())
        XCTAssertEqual(r.lastCrossing?.timing.isReduced, true)
        XCTAssertEqual(r.lastCrossing?.timing.total, Crossing.reducedSeconds)

        // Born red: the colour of the world left is not the colour entered.
        XCTAssertNotEqual(WorldRegistry.entry(.well).essenceHex, WorldRegistry.entry(.home).essenceHex)
    }
}
