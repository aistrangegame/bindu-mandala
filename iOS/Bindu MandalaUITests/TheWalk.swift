import XCTest

// MARK: - U0 · the walk driver (verification.md V18, V20) — U2 · the spine's walk
//
// The automated walk: a cold launch on the dated snapshot (`SNAPSHOT=2026-10-13`
// — the app reads `Bindu MandalaTests/Snapshot/2026-10-13/*.json` from the host
// through `SNAPSHOT_DIR`, and every ledger write goes to the in-memory mock, never
// to Airtable), the Homecoming skipped, a store that lives and dies with the
// launch — and then every world, by every route the spine gives, writing at
// every step:
//
//   <WALK_OUT>/<wave>/<run>/NNN-<step>.png   the screen (XCUIScreen sees Metal)
//   <WALK_OUT>/<wave>/<run>/NNN-<step>.txt   the accessibility tree: the `.geom`
//                                            lines `ScreenReader` reads, then the
//                                            raw tree
//   <WALK_OUT>/<wave>/<run>/walk.jsonl       one JSON line per step
//
// `WALK_OUT` is an absolute host path (on his Mac, `~/BinduWalk`), taken from
// the test runner's environment (set it in the `Waves` test plan); without it
// the walk writes under `$SIMULATOR_HOST_HOME/BinduWalk`, and failing that the
// runner's temporary directory. `WALK_WAVE` names the wave folder (default
// `U2`). The app is launched with `WALK_OUT` and `WALK_TRACE=1` as well, so its
// event trace (`trace.jsonl`) lands in the same run folder.
//
// U2 · B: the shell is the spine (one world on screen at a time, launch at
// the Bindu). The walk reaches all fifteen worlds by every spine route — the
// Constellation (menu), a station at Home, the point, search, back by the
// edge, an address — and at every arrival asserts exactly one `world.<id>`
// sentinel in the accessibility tree (V11, V14: nothing laid over a world).
//
// **Built so later waves only add steps.** A step is data — a name, the world
// it is in (a `WorldID` raw value), how it is reached, and (optionally) words
// that prove more than arrival. A later wave appends to a list (or adds one)
// and inherits the record, the one-world check and the report.

/// One step of the walk.
struct WalkStep {
    enum Route: String {
        /// A cold launch with these extra arguments.
        case launch
        /// From wherever the walk stands, through the Constellation (the 2×2 mark).
        case menu
        /// A cold launch addressed by `OPEN_WORLD=<world>` (V11's thread doors).
        case address
        /// From Home, by the world's station.
        case station
        /// From any world, by the point (top-right) back to Home.
        case point
        /// Through the Constellation's search ("Type one word you're carrying").
        case search
        /// By the leading edge, back to where the walk stood before.
        case back
        /// A spine place (Settings) from the Constellation's foot.
        case place
    }

    let name: String
    /// `WorldID` raw value (the UI target cannot import the app's enum; the
    /// fifteen are restated in `TheWalk.worlds` and checked against the app's
    /// own file by `testTheWalkKnowsEveryWorld`).
    let world: String
    let route: Route
    /// The words typed (`.search`) or the extra launch arguments (`.launch`).
    let via: [String]
    /// Words that are on the destination and prove more than arrival; empty
    /// when arrival (its `world.<id>` sentinel) is the proof.
    let sentinels: [String]

    init(name: String, world: String, route: Route, via: [String] = [], sentinels: [String] = []) {
        self.name = name
        self.world = world
        self.route = route
        self.via = via
        self.sentinels = sentinels
    }
}

final class TheWalk: XCTestCase {

    // MARK: The worlds and the steps

    /// The fifteen worlds (`Services/WorldID.swift`), in its order.
    static let worlds = ["home", "today", "mandala", "rings", "herHome", "herPresence", "climb",
                         "the33", "game", "modes", "time", "memory", "well", "beneath", "relationship"]

    /// The fourteen stations round the point, clockwise from Today
    /// (`spine-and-home.md` §1 "Being there" #2).
    static let stations = ["today", "herPresence", "herHome", "mandala", "rings", "climb", "the33",
                           "game", "modes", "time", "memory", "well", "beneath", "relationship"]

    /// Each world's display name — what search is typed with (`WorldRegistry`).
    static let displayNames: [String: String] = [
        "home": "the Bindu", "today": "Today", "herPresence": "Her Presence", "herHome": "Her Home",
        "mandala": "the Mandala", "rings": "the Nine Rings", "climb": "the Climb", "the33": "the 33",
        "game": "A Strange Game", "modes": "the Modes", "time": "Time", "memory": "Memory",
        "well": "the Well", "beneath": "Beneath", "relationship": "the Relationship Field",
    ]

    /// U2 · every world through the Constellation, from one cold launch:
    /// launch at the Bindu, then each world in turn, ending at Home.
    static let menuWalk: [WalkStep] =
        [WalkStep(name: "launch", world: "home", route: .launch)]
        + TheWalk.stations.map { WalkStep(name: "menu-\($0)", world: $0, route: .menu) }
        + [WalkStep(name: "menu-home", world: "home", route: .menu),
           WalkStep(name: "settings", world: "home", route: .place, sentinels: ["Re-enter the Homecoming"]),
           WalkStep(name: "settings-back", world: "home", route: .back)]

    /// U2 · every station from Home, and the point back from each.
    static let stationWalk: [WalkStep] =
        [WalkStep(name: "launch", world: "home", route: .launch)]
        + TheWalk.stations.flatMap {
            [WalkStep(name: "station-\($0)", world: $0, route: .station),
             WalkStep(name: "point-from-\($0)", world: "home", route: .point)]
        }

    /// U2 · every world by one word typed into search.
    static let searchWalk: [WalkStep] =
        [WalkStep(name: "launch", world: "home", route: .launch)]
        + TheWalk.worlds.filter { $0 != "home" }.map {
            WalkStep(name: "search-\($0)", world: $0, route: .search, via: [TheWalk.displayNames[$0] ?? $0])
        }

    /// U2 · back returns to exactly where he was: Home → the Well → Time →
    /// (edge) the Well → (edge) Home.
    static let backWalk: [WalkStep] = [
        WalkStep(name: "launch", world: "home", route: .launch),
        WalkStep(name: "to-well", world: "well", route: .menu),
        WalkStep(name: "to-time", world: "time", route: .menu),
        WalkStep(name: "back-to-well", world: "well", route: .back),
        WalkStep(name: "back-to-home", world: "home", route: .back),
    ]

    /// Every world by its address (`OPEN_WORLD=<id>`) — U2: the Router opens
    /// it in its own space, and the sentinel proves it.
    static let addressWalk: [WalkStep] = TheWalk.worlds.map { world in
        WalkStep(name: "world-\(world)", world: world, route: .address)
    }

    // MARK: The record

    struct Record {
        let directory: URL
        private(set) var n = 0

        static var wave: String { ProcessInfo.processInfo.environment["WALK_WAVE"] ?? "U2" }

        static func make(test: String) throws -> Record {
            let env = ProcessInfo.processInfo.environment
            let base: URL
            if let out = env["WALK_OUT"], out.hasPrefix("/") {
                base = URL(fileURLWithPath: out, isDirectory: true)
            } else if let host = env["SIMULATOR_HOST_HOME"] {
                base = URL(fileURLWithPath: host, isDirectory: true).appendingPathComponent("BinduWalk")
            } else {
                base = FileManager.default.temporaryDirectory.appendingPathComponent("BinduWalk")
            }
            let stamp = DateFormatter()
            stamp.locale = Locale(identifier: "en_US_POSIX")
            stamp.dateFormat = "yyyyMMdd-HHmmss"
            let run = "\(stamp.string(from: Date()))-\(test)"
            let dir = base.appendingPathComponent(wave, isDirectory: true).appendingPathComponent(run, isDirectory: true)
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            return Record(directory: dir)
        }

        /// Screenshot, tree and one line of `walk.jsonl` for this step.
        mutating func write(step: WalkStep, app: XCUIApplication, arrived: Bool, found: String?,
                            worldsOnScreen: [String], into test: XCTestCase) throws {
            n += 1
            let stem = String(format: "%03d-%@", n, step.name)
            let screenshot = app.screenshot()
            try screenshot.pngRepresentation.write(to: directory.appendingPathComponent(stem + ".png"))

            let geom = ScreenReader.read(app).map(\.line).joined(separator: "\n")
            let tree = "# geom (type|label|ordinal|x|y|w|h)\n" + geom
                + "\n\n# accessibility tree\n" + app.debugDescription + "\n"
            try tree.write(to: directory.appendingPathComponent(stem + ".txt"), atomically: true, encoding: .utf8)

            let bounds = app.frame
            let line: [String: Any] = [
                "n": n, "step": step.name, "world": step.world, "route": step.route.rawValue,
                "via": step.via, "arrived": arrived, "sentinel": found.map { $0 as Any } ?? NSNull(),
                "worldsOnScreen": worldsOnScreen,
                "png": stem + ".png", "txt": stem + ".txt",
                "device": SnapshotStore.deviceClass(width: bounds.width, height: bounds.height),
                "w": Double(bounds.width), "h": Double(bounds.height),
                "at": ISO8601DateFormatter().string(from: Date()),
            ]
            var data = try JSONSerialization.data(withJSONObject: line, options: [.sortedKeys])
            data.append(0x0A)
            let jsonl = directory.appendingPathComponent("walk.jsonl")
            if let handle = try? FileHandle(forWritingTo: jsonl) {
                defer { try? handle.close() }
                _ = try handle.seekToEnd()
                try handle.write(contentsOf: data)
            } else {
                try data.write(to: jsonl)
            }

            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = stem
            attachment.lifetime = .keepAlways
            test.add(attachment)
        }
    }

    // MARK: Launching

    /// `…/iOS/Bindu MandalaUITests/TheWalk.swift` → `…/iOS/Bindu MandalaTests/Snapshot/2026-10-13`.
    static let snapshotDate = "2026-10-13"
    static var snapshotDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .resolvingSymlinksInPath()
            .deletingLastPathComponent()      // Bindu MandalaUITests
            .deletingLastPathComponent()      // iOS
            .appendingPathComponent("Bindu MandalaTests/Snapshot/\(snapshotDate)", isDirectory: true)
    }

    static func base(record: Record) -> [String] {
        ["SNAPSHOT=\(snapshotDate)", "SKIP_HOMECOMING", "SKIP_SUMMONS", "EPHEMERAL_STORE",
         "ENERGY_POS=29", "WALK_TRACE=1", "WALK_OUT=\(record.directory.path)"]
    }

    private func launch(_ extra: [String], record: Record) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = Self.base(record: record) + extra
        app.launchEnvironment["SNAPSHOT_DIR"] = Self.snapshotDirectory.path
        app.launchEnvironment["WALK_OUT"] = record.directory.path
        app.launchEnvironment["WALK_TRACE"] = "1"
        app.launch()
        return app
    }

    // MARK: Arriving — one world at a time

    /// A world's sentinel (`WorldID.sentinel`).
    static func sentinel(_ world: String) -> String { "world.\(world)" }

    private func element(_ app: XCUIApplication, id: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: id).firstMatch
    }

    /// Every `world.*` sentinel in the tree right now (V14: exactly one).
    private func worldsOnScreen(_ app: XCUIApplication) -> [String] {
        let q = app.descendants(matching: .any).matching(NSPredicate(format: "identifier BEGINSWITH 'world.'"))
        return q.allElementsBoundByIndex.filter(\.exists).map(\.identifier)
    }

    /// The world arrived (its sentinel stands, alone), and — when given — the
    /// first of the words that prove more.
    private func arrived(_ app: XCUIApplication, at world: String, words: [String],
                         timeout: TimeInterval = 20) -> (ok: Bool, found: String?, worlds: [String]) {
        let landed = element(app, id: Self.sentinel(world)).waitForExistence(timeout: timeout)
        // Let the crossing settle (the passage is 5.4 s; its overlay is never in the tree).
        Thread.sleep(forTimeInterval: 1.2)
        let worlds = worldsOnScreen(app)
        var found: String? = nil
        if !words.isEmpty {
            let deadline = Date().addingTimeInterval(8)
            repeat {
                for s in words {
                    let p = NSPredicate(format: "label CONTAINS[c] %@", s)
                    if app.staticTexts.matching(p).firstMatch.exists || app.buttons.matching(p).firstMatch.exists {
                        found = s
                    }
                }
                if found != nil { break }
                Thread.sleep(forTimeInterval: 0.5)
            } while Date() < deadline
        }
        let ok = landed && (words.isEmpty || found != nil)
        return (ok, found, worlds)
    }

    // MARK: The spine's routes

    /// The 2×2 mark → the Constellation.
    private func openMenu(_ app: XCUIApplication) -> Bool {
        let mark = element(app, id: "spine.menu.mark")
        guard mark.waitForExistence(timeout: 8) else { return false }
        return press(mark, until: element(app, id: "spine.menu"), attempts: 3, eachTimeout: 4)
    }

    private func throughTheMenu(_ app: XCUIApplication, to world: String) -> Bool {
        guard openMenu(app) else { return false }
        let node = element(app, id: "menu.node.\(world)")
        guard node.waitForExistence(timeout: 6) else { return false }
        // The nodes arrive over ~1.6 s; let them settle before the touch.
        Thread.sleep(forTimeInterval: 1.6)
        node.tap()
        return true
    }

    /// A station at Home: Part A's Home may open a card on the first touch and
    /// cross on the second (two taps, never one) — so a second touch is given
    /// when the first did not cross.
    private func throughTheStation(_ app: XCUIApplication, to world: String) -> Bool {
        let station = element(app, id: "station.\(world)")
        guard station.waitForExistence(timeout: 10) else { return false }
        station.tap()
        if element(app, id: Self.sentinel(world)).waitForExistence(timeout: 3) { return true }
        if station.exists && station.isHittable { station.tap() }
        return true
    }

    private func throughThePoint(_ app: XCUIApplication) -> Bool {
        let point = element(app, id: "point.home")
        guard point.waitForExistence(timeout: 8) else { return false }
        point.tap()
        return true
    }

    private func throughSearch(_ app: XCUIApplication, word: String, to world: String) -> Bool {
        guard openMenu(app) else { return false }
        let field = element(app, id: "menu.search")
        guard field.waitForExistence(timeout: 6) else { return false }
        field.tap()
        field.typeText(word)
        let result = app.descendants(matching: .any).matching(NSPredicate(
            format: "identifier BEGINSWITH 'search.result.world|' AND identifier ENDSWITH %@", "world=\(world)")).firstMatch
        guard result.waitForExistence(timeout: 6) else { return false }
        result.tap()
        return true
    }

    /// The leading edge (22 pt), travelled 72 pt and more.
    private func byTheEdge(_ app: XCUIApplication) {
        let from = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0.55)).withOffset(CGVector(dx: 6, dy: 0))
        let to = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0.55)).withOffset(CGVector(dx: 220, dy: 0))
        from.press(forDuration: 0.05, thenDragTo: to)
    }

    private func throughThePlace(_ app: XCUIApplication) -> Bool {
        guard openMenu(app) else { return false }
        let settings = element(app, id: "menu.settings")
        guard settings.waitForExistence(timeout: 6) else { return false }
        settings.tap()
        return element(app, id: "spine.place.settings").waitForExistence(timeout: 6)
    }

    // MARK: The walks

    /// Walk a list of steps from its own cold launch, recording every step and
    /// holding every arrival to one world on screen.
    private func walk(_ steps: [WalkStep], test: String) throws {
        var record = try Record.make(test: test)
        var app: XCUIApplication? = nil
        var missed: [String] = []
        for step in steps {
            var reached = true
            switch step.route {
            case .launch:
                app?.terminate()
                app = launch(step.via, record: record)
            case .address:
                app?.terminate()
                app = launch(["OPEN_WORLD=\(step.world)"], record: record)
            case .menu:
                if let a = app { reached = throughTheMenu(a, to: step.world) }
            case .station:
                if let a = app { reached = throughTheStation(a, to: step.world) }
            case .point:
                if let a = app { reached = throughThePoint(a) }
            case .search:
                if let a = app { reached = throughSearch(a, word: step.via.first ?? step.world, to: step.world) }
            case .back:
                if let a = app { byTheEdge(a) }
            case .place:
                if let a = app { reached = throughThePlace(a) }
            }
            guard let a = app else { continue }
            if !reached { missed.append("\(step.name): the \(step.route.rawValue) did not open") }

            if step.route == .place {
                // A spine place stands in the world's stead: no world is on
                // screen, and its own words prove it.
                let r = arrivedInPlace(a, words: step.sentinels)
                if !r.ok { missed.append("\(step.name): Settings did not stand as a place") }
                if !r.worlds.isEmpty { missed.append("\(step.name): a world stayed on screen under the place: \(r.worlds)") }
                try record.write(step: step, app: a, arrived: r.ok, found: r.found, worldsOnScreen: r.worlds, into: self)
                continue
            }

            let r = arrived(a, at: step.world, words: step.sentinels)
            if !r.ok { missed.append("\(step.name): \(Self.sentinel(step.world)) did not arrive") }
            if r.worlds != [Self.sentinel(step.world)] {
                missed.append("\(step.name): one world at a time was broken — \(r.worlds)")
            }
            try record.write(step: step, app: a, arrived: r.ok, found: r.found, worldsOnScreen: r.worlds, into: self)
        }
        app?.terminate()
        XCTAssertTrue(missed.isEmpty, "the walk did not reach:\n" + missed.joined(separator: "\n")
                      + "\nrecord: \(record.directory.path)")
    }

    private func arrivedInPlace(_ app: XCUIApplication, words: [String]) -> (ok: Bool, found: String?, worlds: [String]) {
        Thread.sleep(forTimeInterval: 1.0)
        var found: String? = nil
        for s in words {
            let p = NSPredicate(format: "label CONTAINS[c] %@", s)
            if app.staticTexts.matching(p).firstMatch.waitForExistence(timeout: 6)
                || app.buttons.matching(p).firstMatch.exists {
                found = s
                break
            }
        }
        return (words.isEmpty || found != nil, found, worldsOnScreen(app))
    }

    /// Every world through the Constellation, from one cold launch (and
    /// Settings as a place from its foot, left by the edge).
    func testTheWalkByTheMenu() throws {
        try walk(Self.menuWalk, test: "menu")
    }

    /// Every station from Home, and the point back to Home from each world.
    func testTheWalkByStationAndPoint() throws {
        try walk(Self.stationWalk, test: "station")
    }

    /// Every world by one word typed into search.
    func testTheWalkBySearch() throws {
        try walk(Self.searchWalk, test: "search")
    }

    /// Back by the edge returns to exactly where he stood, step by step.
    func testTheWalkBack() throws {
        try walk(Self.backWalk, test: "back")
    }

    /// Every world by its address, one cold launch each.
    func testTheWalkByAddress() throws {
        try walk(Self.addressWalk, test: "address")
    }

    /// Ruling 1: a cold launch with nothing asked arrives at the Bindu — even
    /// after he stood somewhere else when the instrument was closed.
    func testEveryLaunchArrivesAtTheBindu() throws {
        var record = try Record.make(test: "launch")
        var app = launch([], record: record)
        XCTAssertTrue(throughTheMenu(app, to: "well"))
        XCTAssertTrue(element(app, id: Self.sentinel("well")).waitForExistence(timeout: 20))
        app.terminate()
        app = launch([], record: record)
        let r = arrived(app, at: "home", words: [])
        try record.write(step: WalkStep(name: "relaunch", world: "home", route: .launch), app: app,
                         arrived: r.ok, found: nil, worldsOnScreen: r.worlds, into: self)
        XCTAssertTrue(r.ok, "a relaunch did not arrive at the Bindu")
        XCTAssertEqual(r.worlds, [Self.sentinel("home")])
        app.terminate()
    }

    // MARK: The walk's own floors (no app launch)

    /// The walk knows the same fifteen worlds the app does — read off the
    /// app's own `WorldID.swift`, so a world added there without a step here
    /// fails.
    func testTheWalkKnowsEveryWorld() throws {
        let file = URL(fileURLWithPath: #filePath).resolvingSymlinksInPath()
            .deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("Bindu Mandala/Services/WorldID.swift")
        guard let text = try? String(contentsOf: file, encoding: .utf8) else {
            // Xcode Cloud holds no checkout for the UI runner; the unit target's
            // `WorldRegistryTests` holds the same fact there.
            return XCTFail("WorldID.swift is not readable at \(file.path)")
        }
        guard let re = try? NSRegularExpression(pattern: #"(?m)^\s*case\s+([a-z][A-Za-z0-9]*)\s*$"#) else {
            return XCTFail("bad pattern")
        }
        let ns = text as NSString
        let cases = re.matches(in: text, range: NSRange(location: 0, length: ns.length))
            .map { ns.substring(with: $0.range(at: 1)) }
        XCTAssertEqual(cases, Self.worlds, "the walk's worlds and the app's WorldID have drifted")
        XCTAssertEqual(Self.addressWalk.map(\.world), Self.worlds)
        XCTAssertEqual(Set(Self.stations + ["home"]), Set(Self.worlds), "a station is missing")
        XCTAssertEqual(Set(Self.displayNames.keys), Set(Self.worlds))
        for list in [Self.menuWalk, Self.stationWalk, Self.searchWalk, Self.backWalk] {
            XCTAssertEqual(Set(list.map(\.name)).count, list.count, "two steps share a name")
        }
        // Every world is reached by the menu, by search and by address; every
        // station by its station and left by the point.
        XCTAssertEqual(Set(Self.menuWalk.map(\.world)), Set(Self.worlds))
        XCTAssertEqual(Set(Self.searchWalk.map(\.world) + ["home"]), Set(Self.worlds))
        XCTAssertEqual(Self.stationWalk.filter { $0.route == .station }.map(\.world), Self.stations)
    }

    /// The narrow floor the UI suites judge words by catches what it exists for
    /// and lets the lifted words through (V30: born red).
    func testTheNarrowFloorCatchesHisPracticeAndOnlyThat() {
        for measured in ["felt 7 times", "visits: 4", "a nine-day streak", "her score", "your third time"] {
            XCTAssertTrue(NarrowFloor.saysAQuantityOfHisPractice(measured), "\"\(measured)\" slipped through")
        }
        for allowed in ["Day 11", "3 of 9", "62%", "the second āvaraṇa", "felt again",
                        "Spar Shah kar shi nee. Second enclosure, thirty-third of the one hundred and two."] {
            XCTAssertFalse(NarrowFloor.saysAQuantityOfHisPractice(allowed), "\"\(allowed)\" is refused")
        }
    }

    /// The record writes what it says, where it says (no app launch: a
    /// screenshot-free write of the jsonl line shape).
    func testTheRecordFolderIsMadeUnderWalkOut() throws {
        let record = try Record.make(test: "selftest")
        var isDir: ObjCBool = false
        XCTAssertTrue(FileManager.default.fileExists(atPath: record.directory.path, isDirectory: &isDir))
        XCTAssertTrue(isDir.boolValue)
        XCTAssertTrue(record.directory.path.contains("/\(Record.wave)/"))
        try? FileManager.default.removeItem(at: record.directory)
    }
}
