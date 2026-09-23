import XCTest

// MARK: - The felt register's snapshot harness
//
// Charter §4 hands Phase 4 a mandate with no hands in it: *"Satisfy the
// thresholds in audit §H through automation … use XCUITest and snapshot tests
// in place of hands."* Nobody is going to look at these screens before they
// ship, so "it still looks the same" has to be a number.
//
// What a snapshot is here
// ───────────────────────
// Not a PNG. A PNG of a screen that breathes — motes, sigil spin, the Bindu's
// pulse, an atmosphere that is a function of the hour — differs from itself on
// the next run, and a test that goes red for weather is a test that gets muted.
//
// The snapshot is the screen's **geometry**: every element the accessibility
// tree exposes — every `Text`, `Button`, `TextField`, `Image` — with its frame,
// rounded to a quarter point. That is what "the composition" *is*: what is on
// the screen, and where. It does not move when the light does, and it moves the
// instant a layout does.
//
// The law this enforces
// ─────────────────────
// Phase 4 may change exactly two things: how legible a string is, and how big a
// control's touch area is. It may **not** re-compose a screen — that is the
// failure `iOS/FIDELITY.md` exists to prevent, where a pass goes green while the
// atmosphere quietly drains out.
//
// So the baselines committed under `Baselines/` are the geometry of `main`
// **before** Phase 4 — the pre-change snapshot. Every element that moves against
// them fails, and the only way to make it pass is to write the move down in
// `FeltRegisterClassifications.shifts` with the reason it happened. A hit area
// that grows and shoves its neighbour down is not a silent pass; it is a red
// test with a number in it, and then a sentence somebody had to type.
//
// Recording
// ─────────
//   BINDU_RECORD_BASELINE=1   writes the baselines instead of checking them.
// Run it on the tree as it stood *before* the change, once per device class.
// The marker file is `iOS/SnapshotBaselines/.record`.
// Never run it to "fix" a failure — that is how a regression becomes a baseline.

// MARK: - One element's place on the screen

struct ElementFrame: Equatable {
    let type: String
    let label: String
    /// Distinguishes two elements sharing a type and a label (two "›" on the
    /// Field). Assigned in tree order, so it is stable across runs.
    let ordinal: Int
    let x, y, w, h: Double

    var key: String { "\(type)|\(label)|\(ordinal)" }

    /// The three places an element can be anchored on an axis: its leading edge,
    /// its centre, its trailing edge. Which one holds still is what its parent's
    /// alignment decides.
    var anchorsX: [Double] { [x, x + w / 2, x + w] }
    var anchorsY: [Double] { [y, y + h / 2, y + h] }

    static func round(_ v: Double) -> Double { (v * 4).rounded() / 4 }

    var line: String {
        let f = { (v: Double) in String(format: "%.2f", ElementFrame.round(v)) }
        return "\(type)|\(label)|\(ordinal)|\(f(x))|\(f(y))|\(f(w))|\(f(h))"
    }

    static func parse(_ line: String) -> ElementFrame? {
        let p = line.components(separatedBy: "|")
        guard p.count == 7,
              let ordinal = Int(p[2]),
              let x = Double(p[3]), let y = Double(p[4]),
              let w = Double(p[5]), let h = Double(p[6]) else { return nil }
        return ElementFrame(type: p[0], label: p[1], ordinal: ordinal, x: x, y: y, w: w, h: h)
    }

    /// The ceremony says the hour back to the practitioner ("she was felt here ·
    /// 3:47 PM"), the threshold counts its seats — so a label carries digits
    /// that are different on every run. Digits are blanked for *identity* only;
    /// nothing here is ever read back to a walker.
    ///
    /// A **run** of digits collapses to one `#`, not one `#` per digit. Blanking
    /// them one for one still lets the clock change the key: a baseline recorded
    /// at 9:07 PM says `#:## PM` and the same screen read at 10:07 says
    /// `##:## PM`, so the element reports as gone and a stranger reports as new —
    /// a suite that goes red at ten o'clock and green at nine. The count of
    /// digits is never anything this harness needs.
    ///
    /// The meridiem goes the same way. `SHE WAS FELT HERE · #:# PM` and
    /// `#:# AM` are the same fact — the ceremony saying the hour back — and a
    /// baseline recorded before midnight must not report the whole line gone and
    /// a stranger arrived at ten past twelve. A run that starts in the evening
    /// and ends after it is exactly the run this suite is for.
    /// The smallest distance any anchor travelled, signed.
    static func displacement(_ was: [Double], _ now: [Double]) -> Double {
        zip(was, now).map { $1 - $0 }.min(by: { abs($0) < abs($1) }) ?? 0
    }

    static func normalize(_ label: String) -> String {
        var out = ""
        var inDigits = false
        for ch in label {
            if ch.isNumber {
                if !inDigits { out.append("#"); inDigits = true }
            } else {
                inDigits = false
                out.append(ch)
            }
        }
        return ElementFrame.foldMoon(ElementFrame.foldClock(out))
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "|", with: "/")
    }

    /// The moon, folded the way the clock is folded, and for the same reason.
    ///
    /// `LunarPhaseService.headerLabel` says "<Phase> · <Nth> Night", and both
    /// halves of it move on the calendar rather than on anything this suite
    /// changed. The phase name turns over about every four days, and the digit
    /// fold leaves the ordinal's own suffix behind — `#TH` on most nights,
    /// `#ST`, `#ND`, `#RD` on the first three of a cycle and the twenty-first to
    /// twenty-third. A changed key reads as `gone`, which this file's own
    /// comparison makes deliberately unclassifiable, plus an unclassified
    /// `new`: four failures across two screens on every device class, on the
    /// weather, with no code change at all. That is the outcome the header of
    /// this file exists to prevent, and the clock was folded for it while the
    /// moon was missed.
    ///
    /// Scoped to a phase name that actually precedes a blanked ordinal night,
    /// so "Full Moon" in a walker's own sentence is left alone. The frames
    /// themselves need no help: a shorter phase name re-centres the strip, and
    /// the comparison already takes the smallest of three anchors.
    private static let moon = try? NSRegularExpression(
        pattern: "(?:New Moon|Waxing Crescent|First Quarter|Waxing Gibbous|Full Moon"
               + "|Waning Gibbous|Last Quarter|Waning Crescent) · #(?:st|nd|rd|th) Night",
        options: [.caseInsensitive])

    static func foldMoon(_ s: String) -> String {
        guard let moon else { return s }
        let ns = s as NSString
        return moon.stringByReplacingMatches(in: s, options: [],
                                             range: NSRange(location: 0, length: ns.length),
                                             withTemplate: "~ · # NIGHT")
    }

    /// A blanked clock, with its meridiem folded: `#:# PM` → `#:# ~`. Scoped to
    /// a meridiem that actually follows a blanked number, so "AM" as a word in a
    /// walker's own sentence is left alone.
    private static let clock = try? NSRegularExpression(pattern: "(#(?::#)*) (AM|PM)")

    static func foldClock(_ s: String) -> String {
        guard let clock else { return s }
        let ns = s as NSString
        return clock.stringByReplacingMatches(in: s, options: [],
                                              range: NSRange(location: 0, length: ns.length),
                                              withTemplate: "$1 ~")
    }
}

// MARK: - The screens Phase 4 touches

struct SnapshotScreen {
    let name: String
    let arguments: [String]
    /// Something that proves the screen actually arrived before it is measured.
    let settles: (XCUIApplication) -> Bool
    /// Taps that reach a screen no launch argument can open.
    var approach: (XCUIApplication) -> Void = { _ in }
    /// Time for staged arrivals to finish after `settles` is true. A screen read
    /// mid-stage reports a different set of elements every run.
    var afterSettle: TimeInterval = 1.6
    /// `EPHEMERAL_STORE` is what makes this suite re-runnable. Two things in a
    /// single `xcodebuild test` write a recognition — the shipped
    /// `BinduMandalaUITests`, which runs before this class, and the ceremony
    /// screen at the end of the roster below — and a Field read off a store that
    /// remembers one says "felt here" beside a Śakti's name, which is a
    /// different screen than the one every baseline was recorded from. With a
    /// store of its own, each launch reads the instrument as a new install does,
    /// and nothing it writes outlives it. The disk is never touched;
    /// `EphemeralStoreTests` holds that, and holds the argument to DEBUG.
    static let base = ["SKIP_SUMMONS", "SKIP_HOMECOMING", "SYNC_OFF",
                       "ENERGY_POS=29", "EPHEMERAL_STORE"]

    static func text(_ app: XCUIApplication, _ fragment: String, _ timeout: TimeInterval = 25) -> Bool {
        app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] %@", fragment))
            .firstMatch
            .waitForExistence(timeout: timeout)
    }

    static func button(_ app: XCUIApplication, _ fragment: String, _ timeout: TimeInterval = 25) -> Bool {
        app.buttons
            .matching(NSPredicate(format: "label CONTAINS[c] %@", fragment))
            .firstMatch
            .waitForExistence(timeout: timeout)
    }

    /// The hamburger carries no label (H5's census: the shell exposes none), so
    /// it is found where it lives — the top-trailing 44×44 — rather than by a
    /// name this phase would have had to invent.
    static func tapHamburger(_ app: XCUIApplication) {
        let bounds = app.frame
        let hit = app.buttons.allElementsBoundByIndex.first {
            $0.exists && $0.frame.maxX > bounds.width - 76
                && $0.frame.minY < 140 && $0.frame.height >= 40 && $0.frame.width >= 40
        }
        hit?.tap()
    }

    /// Three attempts, because one is not reliable: the hamburger is tapped while
    /// the room behind it is still arriving, and a tap that lands during that
    /// transition is swallowed. A menu that never opened would otherwise cost a
    /// whole screen's baseline and look like a failure of the screen.
    static func openSettings(_ app: XCUIApplication) {
        let settings = app.buttons.matching(NSPredicate(format: "label == 'Settings'")).firstMatch
        for _ in 0..<3 {
            tapHamburger(app)
            if settings.waitForExistence(timeout: 5) { break }
        }
        if settings.exists { settings.tap() }
    }

    // FOUR SCREENS OF THE AUDIT'S LIST ARE NOT HERE, and each reason is written
    // down rather than papered over.
    //
    // Two have no content to render. `AvaranaThresholdView` and `NityaDetailView`
    // show rows that live only in Airtable; `ShaktiBootstrap` seeds the sixteen
    // Ring-2 Śaktis and nothing else, so a simulator with `SYNC_OFF` has no
    // āvaraṇa and no Nityā to open, and a launch argument pointed at either one
    // quietly no-ops.
    //
    // Two were **removed after their baselines were read back**, because what had
    // been recorded for them was not a picture of them:
    //
    //  · `film`. The Way Behind was reached by opening Settings and flicking up
    //    four times, and a `fullScreenCover` leaves the sheet beneath it in the
    //    accessibility tree. Subtracting the `settings` reading could not clear
    //    it, because `settings` is read *unscrolled* and the film's approach
    //    scrolls: the rows exposed below the fold are new keys, so what landed in
    //    `film.geom` was a hundred lines of Settings at whatever height four
    //    flicks happened to leave them. A baseline that is a function of a flick
    //    is not a baseline. (`OPEN_FILM` now opens the film directly, which is
    //    what `HitAreaTests` uses to measure CLOSE on the running app; the film's
    //    own composition is unproven here and its two Phase 4 paddings are held
    //    by `HitAreaIdiomTests`' ledger.)
    //
    //  · `homecoming`. `RootView.initialDestination()` falls back to a *same-day
    //    restore* out of `UserDefaults`, so the screen under the Homecoming is
    //    wherever the previous screen in this same suite left the app — the
    //    committed baseline is six sevenths the Portrait Mandala. Its seventh
    //    line, the one that is actually the Homecoming's, reports as a
    //    full-screen container whose origin moves with the status bar, and it
    //    drifted 21.67 pt between two runs of an unchanged tree. Its one Phase 4
    //    change is the "tap to enter" ghost, which `LegibilityTests` pins to
    //    exactly 11 pt and 0.5 α.
    //
    // Both are recoverable by a later pass: pin `START_TAB` under the Homecoming
    // and record from the tree as it stood before this phase. Neither is
    // recoverable by re-recording now, which would only write down the change
    // this suite exists to catch.
    static let all: [SnapshotScreen] = [
        SnapshotScreen(name: "mandala", arguments: ["START_TAB=mandala"],
                       settles: { text($0, "Śrī Yantra") }),

        SnapshotScreen(name: "mandala-descent", arguments: ["START_TAB=mandala", "OPEN_SILENCE"],
                       settles: { text($0, "THE BINDU") }, afterSettle: 3.0),

        // kp 33, not 29, and this matters: `AUTO_RECOGNIZE` writes a real local
        // recognition for **today's** Śakti — pinned to kp 29 by `ENERGY_POS` —
        // and Her Moments reads them back, so a Detail opened on 29 grows a row
        // every time this suite is run and its geometry is different on every
        // pass. Sparśākarṣiṇī is felt by nothing here, so her Detail is the same
        // screen on the first run and the hundredth.
        SnapshotScreen(name: "detail", arguments: ["START_TAB=mandala", "OPEN_DETAIL=33"],
                       settles: { text($0, "Embodiment") }),

        SnapshotScreen(name: "rite", arguments: ["START_TAB=rite"],
                       settles: { button($0, "I feel her") }, afterSettle: 2.4),

        // `ENERGY_POS=1` and it matters, because the LAST one wins. A `SYNC_OFF`
        // launch seeds only the sixteen Ring-2 Karṣiṇīs, and the Field marks
        // today's seat: on the ~16 days in 102 when today's Śakti falls in
        // kp 29–44 she is in the roster and her seat is marked, and on the other
        // 86 she is absent and none is. The baseline was recorded on one of the
        // 86, so this lock went red on a sixteenth of all days with the app
        // behaving perfectly. Pinning today OUTSIDE the roster makes the absence
        // the deliberate, permanent case instead of the likely one — the
        // baselines are untouched, because this is the composition they already
        // hold.
        SnapshotScreen(name: "field", arguments: ["START_TAB=102", "ENERGY_POS=1"],
                       settles: { text($0, "The Field") }),

        SnapshotScreen(name: "well", arguments: ["START_TAB=well"],
                       settles: { text($0, "Your Letters to Them") }),

        SnapshotScreen(name: "well-letter", arguments: ["START_TAB=well", "OPEN_LETTER=29"],
                       settles: { button($0, "The Well") }, afterSettle: 2.0),

        SnapshotScreen(name: "memory", arguments: ["START_TAB=memory"],
                       settles: { text($0, "she is felt, not measured") }, afterSettle: 2.4),

        SnapshotScreen(name: "settings", arguments: ["START_TAB=well"],
                       settles: { text($0, "Daily Rhythm") },
                       approach: { openSettings($0) }),

        // Last, and it has to be last: this is the only screen here that
        // *writes*. The ceremony records a real recognition at `onAppear`, the
        // Field says "felt here" beside a Śakti who has one, and the Detail lists
        // them under Her Moments — so any screen read after this one would be
        // reading a different instrument than the screen before it did. It also
        // means the simulator is dirty afterwards; `testTheSimulatorHasNotBeenFeltIn`
        // is what makes that loud on the next run instead of mysterious.
        SnapshotScreen(name: "recognition", arguments: ["START_TAB=rite", "AUTO_RECOGNIZE"],
                       // The whole line, never a fragment of it: `LawsTests`
                       // holds both Recognition lines verbatim at every site,
                       // and "felt you back" on its own is a near-miss of one.
                       settles: { text($0, "and she felt you back") }, afterSettle: 4.5),
    ]
}

// MARK: - Where the baselines live

enum SnapshotStore {
    /// `…/iOS/Bindu MandalaUITests/FeltRegisterSnapshots.swift` → `iOS/SnapshotBaselines/`.
    ///
    /// Beside the target rather than inside it, and for a concrete reason: the
    /// project uses filesystem-synchronized groups, so anything under a target's
    /// folder is a resource to be copied into its bundle — and three device
    /// folders holding `rite.geom` apiece is three commands producing one output.
    /// The build refuses it, rightly. These are fixtures the *test* reads off
    /// disk, exactly as `LawsTests` reads the source tree, so they belong outside
    /// the bundle.
    ///
    /// Symlinks resolved for the reason `LawsTests` resolves them: on macOS
    /// `/tmp` is `/private/tmp`, and a path wrong in that one component reads as
    /// correct to the eye and then fails every comparison.
    static let root: URL = URL(fileURLWithPath: #filePath)
        .resolvingSymlinksInPath()
        .deletingLastPathComponent()      // Bindu MandalaUITests
        .deletingLastPathComponent()      // iOS
        .appendingPathComponent("SnapshotBaselines", isDirectory: true)

    /// Recording is opt-in twice over: an environment variable when the runner
    /// inherits one, and otherwise a marker file the operator has to create by
    /// hand beside the baselines. Neither is ever set in a normal run, so the
    /// suite cannot silently re-record its own regression.
    static var isRecording: Bool {
        if ProcessInfo.processInfo.environment["BINDU_RECORD_BASELINE"] == "1" { return true }
        return FileManager.default.fileExists(atPath: root.appendingPathComponent(".record").path)
    }

    /// "promax" / "phone" / "se", from the screen's own points — so the file a
    /// run reads is decided by the hardware it is on, never by a scheme name.
    static func deviceClass(width: Double, height: Double) -> String {
        let shorter = min(width, height)
        if shorter >= 420 { return "promax" }
        if shorter >= 390 { return "phone" }
        return "se"
    }

    static func url(device: String, screen: String) -> URL {
        root.appendingPathComponent(device, isDirectory: true)
            .appendingPathComponent("\(screen).geom")
    }

    static func write(_ frames: [ElementFrame], device: String, screen: String) throws {
        let dir = root.appendingPathComponent(device, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let body = frames.map(\.line).joined(separator: "\n") + "\n"
        try body.write(to: url(device: device, screen: screen), atomically: true, encoding: .utf8)
    }

    static func read(device: String, screen: String) -> [ElementFrame]? {
        guard let text = try? String(contentsOf: url(device: device, screen: screen), encoding: .utf8)
        else { return nil }
        let frames = text.split(separator: "\n").compactMap { ElementFrame.parse(String($0)) }
        return frames.isEmpty ? nil : frames
    }
}

// MARK: - Reading a screen

enum ScreenReader {

    /// The element types that carry the composition. `.other` is deliberately
    /// absent: SwiftUI mints anonymous containers by the hundred and their
    /// frames are an implementation detail, not a place on the screen.
    static let types: [XCUIElement.ElementType] = [
        .staticText, .button, .textField, .secureTextField, .textView, .switch, .image, .slider,
    ]

    static func name(_ t: XCUIElement.ElementType) -> String {
        switch t {
        case .staticText:       return "text"
        case .button:           return "button"
        case .textField:        return "field"
        case .secureTextField:  return "secure"
        case .textView:         return "editor"
        case .switch:           return "switch"
        case .image:            return "image"
        case .slider:           return "slider"
        default:                return "other"
        }
    }

    static func read(_ app: XCUIApplication) -> [ElementFrame] {
        var out: [ElementFrame] = []
        for t in types {
            var seen: [String: Int] = [:]
            for e in app.descendants(matching: t).allElementsBoundByIndex {
                let f = e.frame
                guard e.exists, f.width > 0, f.height > 0 else { continue }
                let label = ElementFrame.normalize(e.label)
                let stem = "\(name(t))|\(label)"
                let ordinal = seen[stem, default: 0]
                seen[stem] = ordinal + 1
                out.append(ElementFrame(type: name(t), label: label, ordinal: ordinal,
                                        x: f.origin.x, y: f.origin.y, w: f.width, h: f.height))
            }
        }
        return out.sorted { $0.key < $1.key }
    }
}

// MARK: - The tests

final class FeltRegisterSnapshots: XCTestCase {

    /// One point. The frame arithmetic is exact and the file rounds to a
    /// quarter, so this is not slack for a real move — it is the floor under
    /// which SwiftUI's own rounding lives, and under which nothing is visible
    /// to anybody.
    private let tolerance = 1.0

    override func setUp() { continueAfterFailure = true }

    func testEveryTouchedScreenHoldsItsComposition() throws {
        // Two screens came off this list when their baselines were read back.
        // A third that quietly went missing would leave a suite that still says
        // it locks the felt register and no longer does.
        XCTAssertEqual(SnapshotScreen.all.count, 10,
                       "the snapshot roster changed size — a screen cannot leave without the "
                       + "sentence above `SnapshotScreen.all` saying why")

        var failures: [String] = []
        var recorded = 0

        for screen in SnapshotScreen.all {
            let app = XCUIApplication()
            app.launchArguments = SnapshotScreen.base + screen.arguments
            app.launch()
            screen.approach(app)
            guard screen.settles(app) else {
                failures.append("\(screen.name): never arrived")
                app.terminate()
                continue
            }
            Thread.sleep(forTimeInterval: screen.afterSettle)

            let bounds = app.frame
            let device = SnapshotStore.deviceClass(width: bounds.width, height: bounds.height)
            let frames = ScreenReader.read(app)

            // The ceremony screen writes a recognition, and it survives the run.
            // A Field read on a simulator that remembers one says "felt here"
            // beside her name, which is a different screen — and would look like
            // a composition regression rather than a dirty container.
            if screen.name == "field",
               frames.contains(where: { $0.label.lowercased().contains("felt here") }) {
                failures.append("\(device)/field: this simulator remembers a recognition from an "
                                + "earlier run. `xcrun simctl erase` it — the ceremony screen "
                                + "records one every pass, by design.")
            }

            // A screen that reports nothing would pass every comparison it is
            // given. The floor is the same idea `LawsTests` calls a corpus floor.
            XCTAssertGreaterThanOrEqual(frames.count, 2,
                                        "\(screen.name) on \(device) exposed almost nothing to read")

            let shot = XCTAttachment(screenshot: app.screenshot())
            shot.name = "\(device)-\(screen.name)"
            shot.lifetime = .keepAlways
            add(shot)

            if SnapshotStore.isRecording {
                try SnapshotStore.write(frames, device: device, screen: screen.name)
                recorded += 1
                app.terminate()
                continue
            }

            guard let baseline = SnapshotStore.read(device: device, screen: screen.name) else {
                failures.append("\(device)/\(screen.name): no baseline recorded")
                app.terminate()
                continue
            }

            failures.append(contentsOf: compare(live: frames, baseline: baseline,
                                                screen: screen.name, device: device))
            app.terminate()
        }

        if SnapshotStore.isRecording {
            // A recording run compared nothing, so it fails — always. Left as a
            // pass, a `.record` marker somebody forgot to delete (or committed)
            // turns this whole suite into a machine that writes down whatever it
            // sees and reports success. That is the one failure a composition
            // lock cannot survive.
            XCTFail("recorded \(recorded) baseline(s) and compared nothing. Delete "
                    + "iOS/SnapshotBaselines/.record and run again to judge.")
            return
        }
        XCTAssertTrue(failures.isEmpty,
                      "The composition moved against the pre-change baseline. Every line below is "
                      + "either a regression, or a change that has to be written into "
                      + "FeltRegisterClassifications.shifts with its reason:\n"
                      + failures.joined(separator: "\n"))
    }

    private func compare(live: [ElementFrame], baseline: [ElementFrame],
                         screen: String, device: String) -> [String] {
        var out: [String] = []
        let liveByKey = Dictionary(live.map { ($0.key, $0) }, uniquingKeysWith: { a, _ in a })
        let baseByKey = Dictionary(baseline.map { ($0.key, $0) }, uniquingKeysWith: { a, _ in a })

        for (key, was) in baseByKey.sorted(by: { $0.key < $1.key }) {
            guard let now = liveByKey[key] else {
                // A `ClassifiedShift` bounds how far something *moved*. It has
                // nothing to say about something that is no longer on the
                // screen, and letting it answer here was a hole wide enough to
                // drive a whole control through: three of the entries below are
                // written `keyContains: "|"`, which is in every key there is, so
                // every screen they cover could have lost any element it liked
                // and stayed green. A disappearance is a failure unless it is a
                // *fold*, and a fold is a claim rather than an exemption: the
                // entry has to name the control the element went behind, and
                // **that control has to be on the screen this run just read**.
                // An entry naming a door that is not there classifies nothing.
                // What it cannot check from here — that the door really opens
                // onto this element — `TheLibraryFoldUITests` checks by opening
                // it. See `FeltRegisterClassifications.folded`.
                if let fold = FeltRegisterClassifications.folded.first(where: {
                    $0.screen == screen && key.contains($0.keyContains)
                }) {
                    if liveByKey.keys.contains(where: { $0.contains(fold.behind) }) { continue }
                    out.append("\(device)/\(screen): gone — \(key) — it is classified as folded "
                               + "behind \"\(fold.behind)\", and that control is not on the screen "
                               + "either")
                    continue
                }
                out.append("\(device)/\(screen): gone — \(key)")
                continue
            }
            // A string that grew because its type grew has not *moved*: it is
            // anchored where its stack put it and the growth came out the other
            // side. So the displacement on an axis is the smallest distance any
            // of its three anchors travelled — if a leading edge, a centre or a
            // trailing edge held still, the element held still and only grew.
            // A string that was pushed down by a taller neighbour has no anchor
            // that held, and every one of its three reports the same shove.
            let dx = ElementFrame.displacement(was.anchorsX, now.anchorsX)
            let dy = ElementFrame.displacement(was.anchorsY, now.anchorsY)
            let moved = max(abs(dx), abs(dy))
            guard moved > tolerance else { continue }
            if let allowed = ClassifiedShift.allowance(screen: screen, key: key, device: device) {
                // Judged against the *nearest classified translation*, not
                // against zero. A control added to a stack moves everything
                // below it by its own height and nothing above it; saying so in
                // `settles` keeps the residual bound at the resolution it was
                // written at, instead of widening it to the height of the
                // control. See `ClassifiedShift.settles`.
                let residual = allowed.residual(moved)
                if residual > allowed.maxDelta + tolerance {
                    out.append(String(format: "%@/%@: %@ moved %.2f pt — %.2f pt off the classified "
                                      + "%@ pt, past the %.2f pt allowed for \"%@\"",
                                      device, screen, key, moved, residual,
                                      allowed.settlesDescription, allowed.maxDelta, allowed.reason))
                }
                continue
            }
            out.append(String(format: "%@/%@: %@ moved (dx %.2f, dy %.2f) — unclassified",
                              device, screen, key, dx, dy))
        }

        for (key, _) in liveByKey.sorted(by: { $0.key < $1.key }) where baseByKey[key] == nil {
            // Same again, the other way round: a new element is a change to the
            // composition, which is the one thing this phase may not make. It
            // needs its own sentence in `FeltRegisterClassifications.appeared`,
            // naming the screen and the element, not a movement bound that
            // happens to match every key on the screen.
            if !FeltRegisterClassifications.appeared.contains(where: {
                $0.screen == screen && key.contains($0.keyContains)
            }) {
                out.append("\(device)/\(screen): new — \(key)")
            }
        }
        return out
    }
}
