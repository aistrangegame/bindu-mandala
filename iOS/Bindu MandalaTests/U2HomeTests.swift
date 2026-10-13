import XCTest
@testable import Bindu_Mandala

// MARK: - Upgrade U2 · A · Home, proven where it is pure
//
// `waves/upgrade/worlds/spine-and-home.md` §1 and §2 A–B: the Waking's
// keyframes, the arrival owed once a launch, the greeting read from the ledger
// (never a flag), the ghost yantra's light (whether, recency, length — never
// counts), the bloom, the station ring's places, the five's lines verbatim,
// Mauna's captions at 7 / 14 / 21 / 28 s, and the stillness gate. Every
// verbatim line is read back out of the world file itself (a missing file is
// a failure, never a skip). Each check is shown able to fail by a planted
// defect beside it.

final class U2HomeTests: XCTestCase {

    private static func worldFile() throws -> String {
        let url = SourceTree.repoRoot.appendingPathComponent("waves/upgrade/worlds/spine-and-home.md")
        return try String(contentsOf: url, encoding: .utf8)
    }

    private let cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0) ?? c.timeZone
        return c
    }()

    /// A day index: whole days since the epoch.
    private func day(_ d: Date) -> Int { Int(floor(d.timeIntervalSince1970 / 86_400)) }
    private func at(day n: Int, hour h: Double = 12) -> Date {
        Date(timeIntervalSince1970: Double(n) * 86_400 + h * 3600)
    }

    // MARK: The words are the world file's

    @MainActor
    func testEveryHomeLineIsVerbatimInTheWorldFile() throws {
        let text = try Self.worldFile()
        var lines: [String] = []
        lines += HomeFive.all.map(\.line)
        lines.append(HomeFive.atThePoint)
        lines += MaunaCaptions.beats.compactMap(\.line)
        lines += HomeReading.Greeting.returning.lines
        lines += HomeReading.Greeting.welcome.lines
        lines.append(HomeStillness.line)
        lines.append(HomeDeepZoom.firstTimeLine)
        lines += HomeDeepZoom.recognisedLines
        for line in lines {
            XCTAssertTrue(text.contains(line), "“\(line)” is not the world file's own words")
        }
        // Planted: a line one word off is not found.
        XCTAssertFalse(text.contains("Shadow is Bindu distorting."))
    }

    // MARK: #1 · The Waking

    @MainActor
    func testTheWakingKeyframesAreTheWorldFiles() {
        let s = WakingScore.self
        XCTAssertEqual(s.seconds, 2.85)
        XCTAssertEqual(s.kindleAt, 2.85 * 0.58, accuracy: 0.01, "the kindle is not at 58 %")
        XCTAssertEqual(s.value(s.emberScale, at: 0), 0.3, accuracy: 1e-9)
        XCTAssertEqual(s.value(s.emberScale, at: 0.36), 1, accuracy: 1e-9)
        XCTAssertEqual(s.value(s.emberScale, at: 0.58), 1.32, accuracy: 1e-9)
        XCTAssertEqual(s.value(s.emberScale, at: 0.80), 0.6, accuracy: 1e-9)
        XCTAssertEqual(s.value(s.haloOpacity, at: 0.10), 0, accuracy: 1e-9, "the halo lifts before 13 %")
        XCTAssertEqual(s.value(s.haloOpacity, at: 0.50), 1, accuracy: 1e-9)
        XCTAssertEqual(s.value(s.bloomOpacity, at: 0.87), 1, accuracy: 1e-9)
        XCTAssertEqual(s.value(s.scrimOpacity, at: 0.6), 1, accuracy: 1e-9, "the scrim lifts before 64 %")
        XCTAssertEqual(s.value(s.scrimOpacity, at: 0.87), 0, accuracy: 1e-9)
        // Planted: halfway between two keys is between their values.
        let mid = s.value(s.emberScale, at: 0.18)
        XCTAssertGreaterThan(mid, 0.3)
        XCTAssertLessThan(mid, 1)
    }

    // MARK: #1–#4 · The arrival is owed once, and only to a launch that lands at Home

    @MainActor
    func testTheArrivalIsOwedOnceAndOnlyAtLaunch() {
        let launch = HomeLaunch(arguments: [], isUnitTesting: false)
        XCTAssertTrue(launch.take(wayBackIsEmpty: true))
        XCTAssertFalse(launch.take(wayBackIsEmpty: true), "the Waking played twice in one launch")

        let walked = HomeLaunch(arguments: [], isUnitTesting: false)
        XCTAssertFalse(walked.take(wayBackIsEmpty: false), "a crossing into Home was taken for a launch")
        XCTAssertFalse(walked.take(wayBackIsEmpty: true))

        XCTAssertFalse(HomeLaunch(arguments: ["SKIP_HOMECOMING"], isUnitTesting: false).take(wayBackIsEmpty: true))
        XCTAssertTrue(HomeLaunch(arguments: ["FORCE_HOMECOMING"], isUnitTesting: true).take(wayBackIsEmpty: true))
        XCTAssertFalse(HomeLaunch(arguments: [], isUnitTesting: true).take(wayBackIsEmpty: true),
                       "the XCTest host was woken")
    }

    // MARK: #5 · The greeting is read from the ledger

    @MainActor
    func testTheGreetingIsReadFromTheLedger() {
        let today = 100
        XCTAssertNil(HomeReading.greeting(today: today, lastActDay: nil, actedToday: false, greetedToday: false),
                     "the first arrival is the Origin's, not Home's")
        XCTAssertEqual(HomeReading.greeting(today: today, lastActDay: 99, actedToday: false, greetedToday: false),
                       .welcome)
        XCTAssertEqual(HomeReading.greeting(today: today, lastActDay: 97, actedToday: false, greetedToday: false),
                       .returning)
        XCTAssertNil(HomeReading.greeting(today: today, lastActDay: 99, actedToday: true, greetedToday: false),
                     "a day already walked was greeted")
        XCTAssertNil(HomeReading.greeting(today: today, lastActDay: 99, actedToday: false, greetedToday: true),
                     "he was greeted twice in a day")
        XCTAssertEqual(HomeReading.Greeting.returning.seconds, 2.3)
        XCTAssertEqual(HomeReading.Greeting.welcome.seconds, 3)

        let acts = [HomeAct(at: at(day: 90), kp: 30, felt: true),
                    HomeAct(at: at(day: 97), kp: 31, felt: false),
                    HomeAct(at: at(day: 100), kp: 32, felt: true)]
        XCTAssertEqual(HomeReading.lastActDay(acts, today: 100, dayOf: day), 97, "today's act was read as the last day away")
        // Planted: a silence is not a felt meeting.
        XCTAssertFalse(HomeReading.isMet([HomeAct(at: at(day: 100), kp: 102, felt: false)], today: 100, dayOf: day))
        XCTAssertTrue(HomeReading.isMet(acts, today: 100, dayOf: day))
    }

    // MARK: #12 · The ghost yantra — whether, recency, length; never how many

    @MainActor
    func testHisRecordIsLightNeverACount() {
        let now = at(day: 200)
        let once = [HomeAct(at: at(day: 198), kp: 29, felt: true)]
        let many = (0..<40).map { _ in HomeAct(at: at(day: 198), kp: 29, felt: true) }
        XCTAssertEqual(HomeReading.seatLight(once, now: now, today: 200, dayOf: day),
                       HomeReading.seatLight(many, now: now, today: 200, dayOf: day),
                       "forty meetings shone brighter than one — the screen counted him")

        let light = HomeReading.seatLight([
            HomeAct(at: at(day: 200), kp: 29, felt: true),          // today
            HomeAct(at: at(day: 150), kp: 30, felt: true),
            HomeAct(at: at(day: 197), kp: 30, felt: true),          // known long, met lately
            HomeAct(at: at(day: 196), kp: 31, felt: true),          // met lately
            HomeAct(at: at(day: 180), kp: 32, felt: true),          // this month
            HomeAct(at: at(day: 100), kp: 33, felt: true),          // long ago
            HomeAct(at: at(day: 199), kp: 34, felt: false),         // a silence, not a meeting
        ], now: now, today: 200, dayOf: day)
        XCTAssertEqual(light[29], 1.0)
        XCTAssertEqual(light[30], 1.0)
        XCTAssertEqual(light[31], 0.76)
        XCTAssertEqual(light[32], 0.44)
        XCTAssertEqual(light[33], 0.22)
        XCTAssertNil(light[34], "a silence lit a seat as felt")
        XCTAssertLessThan(HomeReading.ghost, 0.08)
        XCTAssertGreaterThan(HomeReading.ghost, 0.04)
    }

    // MARK: #19 · The bloom rises fast and falls slow

    @MainActor
    func testTheBloomRisesFastAndFallsSlow() {
        let start = at(day: 300, hour: 8)
        let acts = (0..<5).map { HomeAct(at: start.addingTimeInterval(Double($0)), kp: 29, felt: true) }
        let b = HomeReading.bloom(acts, now: start.addingTimeInterval(5), today: 300, dayOf: day)
        XCTAssertEqual(b, 0.30, accuracy: 0.002)
        let later = HomeReading.bloom(acts, now: start.addingTimeInterval(4 + 10 * 60), today: 300, dayOf: day)
        XCTAssertEqual(later, 0.30 - 0.12, accuracy: 0.002, "ten minutes did not take .12")
        XCTAssertEqual(HomeReading.bloom(acts, now: start.addingTimeInterval(86_000 / 2), today: 300, dayOf: day), 0,
                       "the bloom fell below nothing")
        // Planted: yesterday's acts do not bloom today.
        XCTAssertEqual(HomeReading.bloom(acts, now: at(day: 301), today: 301, dayOf: day), 0)
    }

    // MARK: #11 · #15 · #17 · Where things stand

    @MainActor
    func testTheStationsStandRoundThePointClockwiseFromToday() {
        let size = CGSize(width: 390, height: 844)
        let c = HomeLayout.point(in: size)
        XCTAssertEqual(c.y, 844 * 0.46, accuracy: 1e-9)
        XCTAssertEqual(HomeLayout.stationRadius(in: size), 148.2, accuracy: 0.01, "r ≈ 148 at 390")
        let today = WorldRegistry.entry(.today)
        let p = HomeLayout.station(today, size: size, centre: c)
        XCTAssertEqual(p.x, c.x, accuracy: 1e-6)
        XCTAssertLessThan(p.y, c.y, "Today is not at 12 o'clock")
        let game = HomeLayout.station(WorldRegistry.entry(.game), size: size, centre: c)
        XCTAssertGreaterThan(game.y, c.y, "A Strange Game is not straight down")
        let presence = HomeLayout.station(WorldRegistry.entry(.herPresence), size: size, centre: c)
        XCTAssertGreaterThan(presence.x, c.x, "the ring does not run clockwise")

        for f in HomeFive.all {
            let q = HomeLayout.five(f, centre: c)
            XCTAssertEqual(Double(hypot(q.x - c.x, q.y - c.y)), 58, accuracy: 1e-6)
            XCTAssertLessThan(q.y, c.y, "a structural point fell onto the beads' arc")
        }
        XCTAssertFalse(HomeFive.all.contains { $0.road == 32 }, "the sealed room was placed")
        for n in 1...5 {
            for i in 0..<n {
                let b = HomeLayout.bead(i, of: n, centre: c)
                XCTAssertGreaterThan(b.y, c.y, "a Road Home bead stands above the point")
                XCTAssertEqual(Double(hypot(b.x - c.x, b.y - c.y)), 64, accuracy: 1e-6)
            }
        }
    }

    // MARK: #24 · Mauna's captions at 7 / 14 / 21 / 28 s

    @MainActor
    func testMaunasCaptionsDeepenOnTheirSeconds() {
        XCTAssertNil(MaunaCaptions.line(at: 6.9))
        XCTAssertEqual(MaunaCaptions.line(at: 7), "All of her. Here. Always.")
        XCTAssertEqual(MaunaCaptions.line(at: 14), "She has not gone anywhere.")
        XCTAssertEqual(MaunaCaptions.line(at: 21.5), "You have not gone anywhere.")
        XCTAssertNil(MaunaCaptions.line(at: 28), "the silence after 28 s is not silent")
        XCTAssertNil(MaunaCaptions.line(at: 600))
    }

    // MARK: #33 · The stillness gate

    @MainActor
    func testTheStillnessGateIsPausedByATouchAndOpensOnce() {
        XCTAssertEqual(HomeStillness.full, 4.6)
        XCTAssertEqual(HomeStillness.after, 0.34)
        XCTAssertTrue(HomeStillness.gathers(touching: false, untouchedFor: 0.4, voiceOver: false, somethingOpen: false))
        XCTAssertFalse(HomeStillness.gathers(touching: true, untouchedFor: 9, voiceOver: false, somethingOpen: false))
        XCTAssertFalse(HomeStillness.gathers(touching: false, untouchedFor: 0.2, voiceOver: false, somethingOpen: false))
        XCTAssertFalse(HomeStillness.gathers(touching: false, untouchedFor: 9, voiceOver: true, somethingOpen: false),
                       "VoiceOver's walker was carried off by a stillness")
        XCTAssertFalse(HomeStillness.gathers(touching: false, untouchedFor: 9, voiceOver: false, somethingOpen: false,
                                             restedSinceTouch: true),
                       "the gate opened twice in one stillness")
    }

    // MARK: #27 · The deep zoom carries sixteen names a layer, and never a bottom

    @MainActor
    func testEachLayerOfTheFallCarriesItsOwnSixteen() {
        let names = (1...16).map { "n\($0)" }
        let first = HomeDeepZoom.slice(names, layer: 0)
        let second = HomeDeepZoom.slice(names, layer: 1)
        XCTAssertEqual(first.count, 16)
        XCTAssertEqual(second.first, "n14", "layer 1 does not begin 13 round the garland")
        XCTAssertNotEqual(first, second)
        XCTAssertEqual(HomeDeepZoom.slice([], layer: 3), [])
        XCTAssertEqual(ThePoint.defaultHoldSeconds, 0.9, "the fall is not a 0.9 s hold (ruling 9)")
    }
}
