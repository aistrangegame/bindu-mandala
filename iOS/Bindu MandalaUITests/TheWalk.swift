import XCTest

// MARK: - U0 · the walk driver (verification.md V18, V20)
//
// The automated walk: a cold launch on the dated snapshot (`SNAPSHOT=2026-10-13`
// — the app reads `Bindu MandalaTests/Snapshot/2026-10-13/*.json` from the host
// through `SNAPSHOT_DIR`, and every ledger write goes to the in-memory mock, never
// to Airtable), the Homecoming skipped, a store that lives and dies with the
// launch — and then every top-level destination the app has today, by the route
// it has today, writing at every step:
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
// `U0`). The app is launched with `WALK_OUT` and `WALK_TRACE=1` as well, so its
// event trace (`trace.jsonl`) lands in the same run folder.
//
// **Built so U1/U2 only add steps.** A step is data — a name, the world it is
// in (a `WorldID` raw value), how it is reached, and the words that prove it
// arrived. The two walks below are lists; a later wave appends to them (or
// adds a list) and inherits the record, the matrix and the report.

/// One step of the walk.
struct WalkStep {
    enum Route: String {
        /// A cold launch with these extra arguments.
        case launch
        /// From wherever the walk stands, through the hamburger menu.
        case menu
        /// A cold launch addressed by `OPEN_WORLD=<world>` (V11's thread doors).
        case address
    }

    let name: String
    /// `WorldID` raw value (the UI target cannot import the app's enum; the
    /// fifteen are restated in `TheWalk.worlds` and checked against the app's
    /// own file by `testTheWalkKnowsEveryWorld`).
    let world: String
    let route: Route
    /// The menu item's words (`.menu`) or the extra launch arguments (`.launch`).
    let via: [String]
    /// Words that are on the destination and prove it arrived; empty when the
    /// destination has no stable words yet (the step is recorded, not judged).
    let sentinels: [String]
}

final class TheWalk: XCTestCase {

    // MARK: The worlds and the steps

    /// The fifteen worlds (`Services/WorldID.swift`), in its order.
    static let worlds = ["home", "today", "mandala", "rings", "herHome", "herPresence", "climb",
                         "the33", "game", "modes", "time", "memory", "well", "beneath", "relationship"]

    /// Every top-level destination by its current route (U0: RootView's five
    /// rooms and Settings, through the hamburger menu).
    static let menuWalk: [WalkStep] = [
        WalkStep(name: "launch", world: "today", route: .launch, via: [], sentinels: []),
        WalkStep(name: "mandala", world: "mandala", route: .menu, via: ["The Mandala"], sentinels: ["Śrī Yantra"]),
        WalkStep(name: "rite", world: "today", route: .menu, via: ["The Rite"], sentinels: ["I feel her"]),
        WalkStep(name: "well", world: "well", route: .menu, via: ["The Well"], sentinels: ["Your Letters"]),
        WalkStep(name: "field", world: "rings", route: .menu, via: ["The Field"], sentinels: ["The Field"]),
        WalkStep(name: "memory", world: "memory", route: .menu, via: ["The Memory"],
                 sentinels: ["she is felt, not measured"]),
        WalkStep(name: "settings", world: "relationship", route: .menu, via: ["Settings"],
                 sentinels: ["Re-enter the Homecoming"]),
    ]

    /// Every world by its address (`OPEN_WORLD=<id>`), mapped in U0 to the
    /// closest existing screen (`WorldID.u0Destination`).
    static let addressWalk: [WalkStep] = TheWalk.worlds.map { world in
        let sentinels: [String]
        switch world {
        case "home", "mandala", "the33", "modes": sentinels = ["Śrī Yantra"]
        case "today", "herPresence", "time":     sentinels = ["I feel her"]
        case "rings", "herHome", "relationship": sentinels = ["The Field"]
        case "memory":                           sentinels = ["she is felt, not measured"]
        case "well":                             sentinels = ["Your Letters"]
        case "beneath":                          sentinels = ["THE BINDU"]
        default:                                 sentinels = []   // climb, game: recorded, not judged in U0
        }
        return WalkStep(name: "world-\(world)", world: world, route: .address, via: [], sentinels: sentinels)
    }

    // MARK: The record

    struct Record {
        let directory: URL
        private(set) var n = 0

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
            let wave = env["WALK_WAVE"] ?? "U0"
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
                            into test: XCTestCase) throws {
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

    // MARK: Arriving

    /// The first sentinel on screen, waiting up to `timeout` for any of them.
    private func arrived(_ app: XCUIApplication, _ sentinels: [String], timeout: TimeInterval = 20) -> String? {
        guard !sentinels.isEmpty else {
            Thread.sleep(forTimeInterval: 3)
            return nil
        }
        let deadline = Date().addingTimeInterval(timeout)
        repeat {
            for s in sentinels {
                let p = NSPredicate(format: "label CONTAINS[c] %@", s)
                if app.staticTexts.matching(p).firstMatch.exists || app.buttons.matching(p).firstMatch.exists {
                    return s
                }
            }
            Thread.sleep(forTimeInterval: 0.5)
        } while Date() < deadline
        return nil
    }

    /// The hamburger: the highest unlabelled control in the top-trailing corner
    /// (the shell gives it no label — the same finder `MandalaLightReachTests` uses).
    private func hamburger(_ app: XCUIApplication) -> XCUIElement? {
        let bounds = app.frame
        return app.buttons.allElementsBoundByIndex
            .filter { $0.exists && $0.label.isEmpty }
            .filter { $0.frame.minX > bounds.width * 0.6 && $0.frame.minY < 140 }
            .min { $0.frame.minY < $1.frame.minY }
    }

    private func throughTheMenu(_ app: XCUIApplication, to item: String) -> Bool {
        let target = app.buttons.matching(NSPredicate(format: "label == %@", item)).firstMatch
        guard let button = hamburger(app) else { return false }
        guard press(button, until: target, attempts: 4, eachTimeout: 8) else { return false }
        target.tap()
        return true
    }

    // MARK: The walks

    /// Every top-level destination by its current route, from one cold launch.
    func testTheWalkByTheMenu() throws {
        var record = try Record.make(test: "menu")
        var app: XCUIApplication? = nil
        var missed: [String] = []
        for step in Self.menuWalk {
            switch step.route {
            case .launch:
                app?.terminate()
                app = launch(step.via, record: record)
            case .menu:
                guard let a = app else { continue }
                if !throughTheMenu(a, to: step.via.first ?? "") {
                    missed.append("\(step.name): the menu did not open onto “\(step.via.first ?? "")”")
                }
            case .address:
                app?.terminate()
                app = launch(["OPEN_WORLD=\(step.world)"], record: record)
            }
            guard let a = app else { continue }
            let found = arrived(a, step.sentinels)
            let ok = step.sentinels.isEmpty || found != nil
            if !ok { missed.append("\(step.name): none of \(step.sentinels) arrived") }
            try record.write(step: step, app: a, arrived: ok, found: found, into: self)
            if step.name == "settings" {
                // Settings is a sheet; leave it the way a walker does.
                a.swipeDown(velocity: .fast)
            }
        }
        app?.terminate()
        XCTAssertTrue(missed.isEmpty, "the walk did not reach:\n" + missed.joined(separator: "\n")
                      + "\nrecord: \(record.directory.path)")
    }

    /// Every world by its address, one cold launch each.
    func testTheWalkByAddress() throws {
        var record = try Record.make(test: "address")
        var missed: [String] = []
        for step in Self.addressWalk {
            let app = launch(["OPEN_WORLD=\(step.world)"], record: record)
            let found = arrived(app, step.sentinels)
            let ok = step.sentinels.isEmpty || found != nil
            if !ok { missed.append("\(step.world): none of \(step.sentinels) arrived") }
            try record.write(step: step, app: app, arrived: ok, found: found, into: self)
            app.terminate()
        }
        XCTAssertTrue(missed.isEmpty, "OPEN_WORLD did not reach:\n" + missed.joined(separator: "\n")
                      + "\nrecord: \(record.directory.path)")
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
        XCTAssertEqual(Set(Self.menuWalk.map(\.name)).count, Self.menuWalk.count, "two steps share a name")
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
        XCTAssertTrue(record.directory.path.contains("/\(ProcessInfo.processInfo.environment["WALK_WAVE"] ?? "U0")/"))
        try? FileManager.default.removeItem(at: record.directory)
    }
}
