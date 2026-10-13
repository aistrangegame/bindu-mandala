import XCTest
@testable import Bindu_Mandala

// MARK: - U1 · D · Gesture and Score
//
// `waves/upgrade/briefs/U1-instruments.md` Part D: the hold engine, the
// haptics library, the Score player. Numbers are read from their sources where
// the sources are in the repository — Design's own files (`Design/Chakra/…`,
// through `DesignCorpus`: a missing file is a FAIL, never a skip) and the dated
// Airtable snapshot of the Bindu Field (`Snapshot/2026-10-13/bindu-field.json`,
// the 46 Score JSON rows). Where the source lives only in the register (the
// room-gate ladder, G0's drain band), the number is pinned here with its
// citation.
//
// V30: every check is shown able to fail — each suite carries its planted
// defect beside it (a hold that fills in a tap's time, a sharp haptic, a Score
// broken one rule at a time).

final class U1DTests: XCTestCase {

    // MARK: - Helpers

    /// Drive a hold: press at 0, frames of `frame` seconds while held (with key
    /// repeats if asked), release at `holdFor`, then frames for `after` s.
    private func drive(_ e: inout HoldEngine, by source: HoldSource = .touch, holdFor: TimeInterval,
                       after: TimeInterval = 1.0, frame: TimeInterval = 0.016,
                       repeatsEvery: TimeInterval? = nil) -> [(t: TimeInterval, event: HoldEvent)] {
        var out: [(t: TimeInterval, event: HoldEvent)] = []
        func note(_ t: TimeInterval, _ es: [HoldEvent]) { out.append(contentsOf: es.map { (t, $0) }) }
        var t = 0.0
        note(t, e.press(at: t, by: source))
        var nextRepeat = repeatsEvery
        while t + frame < holdFor {
            t += frame
            if let r = nextRepeat, let every = repeatsEvery, t >= r {
                let repeated = e.press(at: t, by: source, isRepeat: true)
                XCTAssertTrue(repeated.isEmpty, "a key repeat did something: \(repeated)")
                nextRepeat = r + every
            }
            note(t, e.tick(at: t))
        }
        note(holdFor, e.release(at: holdFor, by: source))
        t = holdFor
        while t < holdFor + after {
            t += frame
            note(t, e.tick(at: t))
        }
        return out
    }

    private static func isVoice(_ c: ScoreCue) -> Bool {
        if case .voice = c.kind { return true }
        return false
    }

    private func completes(_ engine: HoldEngine, holdFor: TimeInterval) -> Bool {
        var e = engine
        return drive(&e, holdFor: holdFor).contains { $0.event == .completed }
    }

    private var snapshotURL: URL {
        SourceTree.iOSRoot.appendingPathComponent("Bindu MandalaTests/Snapshot/2026-10-13/bindu-field.json")
    }

    private func snapshotPage() throws -> Data {
        guard let d = FileManager.default.contents(atPath: snapshotURL.path) else {
            throw DesignCorpus.Missing(path: snapshotURL.path)
        }
        return d
    }

    /// The Score JSON cells of the snapshot, counted independently of
    /// `ScoreCatalog` (plain `JSONSerialization` over the export's field ids).
    private func snapshotScoreCells() throws -> [String] {
        let page = try XCTUnwrap(try JSONSerialization.jsonObject(with: snapshotPage()) as? [String: Any])
        let records = try XCTUnwrap(page["records"] as? [[String: Any]])
        return records.compactMap { ($0["fields"] as? [String: Any])?["fldxIm6qUXLcdrRuR"] as? String }
            .filter { !$0.isEmpty }
    }

    private func crossJSON() throws -> String {
        let rows = try ScoreCatalog.rows(fromPage: snapshotPage())
        return try XCTUnwrap(rows.first { $0.verb == "cross" }?.scoreJSON, "cross is not in the snapshot")
    }

    private func cross() throws -> LoadedScore { try ScoreLoader.load(crossJSON()) }

    /// A Score tree with the value at `path` replaced (nil removes it).
    private func setting(_ j: ScoreJSON, _ path: [String], _ v: ScoreJSON?) -> ScoreJSON {
        guard let k = path.first else { return v ?? .null }
        let rest = Array(path.dropFirst())
        if let i = Int(k), case .array(var a) = j, a.indices.contains(i) {
            a[i] = setting(a[i], rest, v)
            return .array(a)
        }
        guard case .object(var o) = j else { return j }
        if rest.isEmpty {
            if let v { o[k] = v } else { o.removeValue(forKey: k) }
        } else {
            o[k] = setting(o[k] ?? .object([:]), rest, v)
        }
        return .object(o)
    }

    /// Load a Score tree; the rules it was refused under (empty = it loaded).
    private func refusedRules(_ j: ScoreJSON) throws -> Set<ScoreFinding.Rule> {
        let data = try JSONEncoder().encode(j)
        do {
            _ = try ScoreLoader.load(data)
            return []
        } catch let r as ScoreRefusal {
            return Set(r.findings.map(\.rule))
        }
    }

    // MARK: - The hold engine (G0 · V25)

    /// The durations, read from Design where Design holds them.
    func testTheLadderIsTheSourcesOwn() throws {
        // The covenant is one breath: `const BREATH = () => 5000 * pace();`
        let engine = try DesignCorpus.text("Design/Chakra/shell/bindu-engine.js")
        let breath = try XCTUnwrap(Rx.groups(#"const BREATH = \(\) => (\d+) \* pace\(\)"#, engine).first?[1])
        XCTAssertEqual(HoldLadder.covenant * 1000, try XCTUnwrap(Double(breath)), accuracy: 0.5)

        // The story hold is the shell's `hold_ms` and the practice page's HOLD_DURATION.
        let adapter = try DesignCorpus.text("Design/Chakra/shell/canon-adapter.js")
        let holdMs = try XCTUnwrap(Rx.groups(#"hold_ms:\s*(\d+)"#, adapter).first?[1])
        XCTAssertEqual(HoldLadder.story * 1000, try XCTUnwrap(Double(holdMs)), accuracy: 0.5)
        let practice = try DesignCorpus.text("Design/Chakra/uploads/bindu-practice(4).html")
        let duration = try XCTUnwrap(Rx.groups(#"HOLD_DURATION = (\d+)"#, practice).first?[1])
        XCTAssertEqual(HoldLadder.story * 1000, try XCTUnwrap(Double(duration)), accuracy: 0.5)

        // The brief's five (U1 Part D item 1).
        XCTAssertEqual([HoldLadder.readiness, HoldLadder.gate, HoldLadder.story, HoldLadder.send, HoldLadder.covenant]
                        .map { Int(($0 * 1000).rounded()) }, [750, 1100, 1800, 2300, 5000])

        // The room-gate ladder (the-33 §2 row 32; register G3-0040…0045, G3-0212):
        // 3500 → 1500, falling as the body rises.
        XCTAssertEqual(HoldLadder.roomGateLadder.map { Int(($0 * 1000).rounded()) },
                       [3500, 3200, 2800, 2600, 2400, 2000, 1800, 1500])
        XCTAssertEqual(HoldLadder.roomGateLadder, HoldLadder.roomGateLadder.sorted(by: >), "the ladder does not fall")
        XCTAssertEqual([2, 3, 4, 5, 6, 7, 8, 31].compactMap(HoldLadder.roomGate(road:)), HoldLadder.roomGateLadder)
        XCTAssertEqual(HoldLadder.roomGate(road: 1), HoldLadder.covenant, "the Bindu's gate is one breath")
        XCTAssertNil(HoldLadder.roomGate(road: 12), "a body room's gate is an instrument, not a hold")

        // G0: an early release drains at DOWN_MS 620–750; Compose's is 620.
        XCTAssertTrue(HoldLadder.drainBand.contains(HoldLadder.drain))
        XCTAssertEqual(HoldLadder.sendDrain, 0.620, accuracy: 1e-9)
        XCTAssertEqual(HoldLadder.frameClamp, 0.064, accuracy: 1e-9)
        XCTAssertEqual(HoldLadder.cancelDistance, 9)
    }

    /// Commit on the threshold, act on release.
    func testAHoldCommitsOnlyAtFullAndActsOnlyOnRelease() {
        let rise = HoldLadder.gate
        var e = HoldEngine(rise: rise)
        let events = drive(&e, holdFor: rise + 0.3)
        let commit = events.first { $0.event == .committed }
        let complete = events.first { $0.event == .completed }
        XCTAssertNotNil(commit, "a full hold never committed")
        XCTAssertGreaterThanOrEqual(commit?.t ?? 0, rise - 1e-9, "it committed before the light was full")
        XCTAssertEqual(complete?.t ?? -1, rise + 0.3, accuracy: 1e-9, "the act did not wait for the release")
        XCTAssertEqual(events.filter { $0.event == .completed }.count, 1)
        XCTAssertFalse(events.contains { $0.event == .letGo }, "a full hold drained")

        // Released at exactly its duration: complete.
        var exact = HoldEngine(rise: rise)
        XCTAssertTrue(drive(&exact, holdFor: rise).contains { $0.event == .completed })
        // Released a frame short: not.
        XCTAssertFalse(completes(HoldEngine(rise: rise), holdFor: rise - 0.02))
    }

    /// An early release drains, never fails, never acts.
    func testAnEarlyReleaseDrainsAndNeverActs() {
        let rise = HoldLadder.gate
        var e = HoldEngine(rise: rise)
        var events: [HoldEvent] = []
        events += e.press(at: 0, by: .touch)
        var t = 0.0
        while t < rise / 2 { t += 0.016; events += e.tick(at: t) }
        let atRelease = e.progress
        XCTAssertEqual(atRelease, 0.5, accuracy: 0.02)
        events += e.release(at: t, by: .touch)
        var last = e.progress
        var drainedAt: TimeInterval?
        let releasedAt = t
        while t < releasedAt + 1.0 {
            t += 0.016
            let step = e.tick(at: t)
            events += step
            XCTAssertLessThanOrEqual(e.progress, last + 1e-12, "the light rose after the hand let go")
            last = e.progress
            if step.contains(.drained) { drainedAt = t }
        }
        XCTAssertFalse(events.contains(.committed))
        XCTAssertFalse(events.contains(.completed))
        XCTAssertTrue(events.contains(.letGo))
        // Drains over DOWN_MS from full: half a light in half the drain (± a frame).
        XCTAssertNotNil(drainedAt, "the light never drained")
        XCTAssertEqual((drainedAt ?? 0) - releasedAt, atRelease * HoldLadder.drain, accuracy: 0.02,
                       "the drain is not DOWN_MS — a jolt, or a crawl")
        XCTAssertEqual(e.progress, 0)

        // Pressing again while it drains rises from where the light is.
        var again = HoldEngine(rise: rise)
        _ = again.press(at: 0, by: .touch)
        var u = 0.0
        while u < 0.5 { u += 0.016; _ = again.tick(at: u) }
        _ = again.release(at: u, by: .touch)
        u += 0.1; _ = again.tick(at: u)
        let mid = again.progress
        _ = again.press(at: u, by: .touch)
        XCTAssertEqual(again.progress, mid, accuracy: 1e-9, "a second press jolted the light")
    }

    /// A tap does nothing; no tap rate completes a hold.
    func testATapDoesNothing() {
        var e = HoldEngine(rise: HoldLadder.readiness)
        let tap = drive(&e, holdFor: 0.1)
        XCTAssertFalse(tap.contains { $0.event == .committed || $0.event == .completed })
        XCTAssertTrue(tap.contains { $0.event == .drained })

        // Twenty taps at four a second, across far more than the hold's length.
        // (A tap rate is not a hold: each 50 ms touch drains away in the 200 ms
        // between. G0 lets a second press rise from where the light is, so a
        // hand that is down most of the time *is* holding — that is the law.)
        var rapid = HoldEngine(rise: HoldLadder.readiness)
        var t = 0.0
        var all: [HoldEvent] = []
        for _ in 0..<20 {
            all += rapid.press(at: t, by: .touch)
            let up = t + 0.05
            while t < up { t += 0.016; all += rapid.tick(at: t) }
            all += rapid.release(at: t, by: .touch)
            let next = t + 0.2
            while t < next { t += 0.016; all += rapid.tick(at: t) }
        }
        XCTAssertGreaterThan(t, HoldLadder.readiness)
        XCTAssertFalse(all.contains(.completed), "a tap rate completed a hold")

        // Planted defect (V30): a hold that fills in a tap's time is caught.
        XCTAssertTrue(completes(HoldEngine(rise: 0.05), holdFor: 0.1),
                      "the tap check cannot see a hold shorter than a tap")
    }

    /// A held key counts; its repeats are ignored; key up early drains.
    func testAHeldKeyCountsAndItsRepeatsAreIgnored() {
        let d = HoldLadder.story
        var full = HoldEngine(rise: d)
        let held = drive(&full, by: .key, holdFor: d, repeatsEvery: 0.05)
        XCTAssertTrue(held.contains { $0.event == .completed }, "a held key did not complete")

        var half = HoldEngine(rise: d)
        let early = drive(&half, by: .key, holdFor: d / 2, repeatsEvery: 0.05)
        XCTAssertFalse(early.contains { $0.event == .completed || $0.event == .committed })
        XCTAssertTrue(early.contains { $0.event == .letGo })

        // Repeats alone are not a hold.
        var repeats = HoldEngine(rise: d)
        for k in 0..<100 { XCTAssertTrue(repeats.press(at: Double(k) * 0.05, by: .key, isRepeat: true).isEmpty) }
        XCTAssertFalse(repeats.isHeld)

        // A key coming up does not end a finger's hold.
        var finger = HoldEngine(rise: d)
        _ = finger.press(at: 0, by: .touch)
        XCTAssertTrue(finger.release(at: 0.1, by: .key).isEmpty)
        XCTAssertTrue(finger.isHeld)
    }

    /// Movement beyond the cancel distance drains, even after the commit.
    func testACancelNeverActs() {
        var e = HoldEngine(rise: HoldLadder.gate)
        _ = e.press(at: 0, by: .touch)
        var t = 0.0
        var events: [HoldEvent] = []
        while t < HoldLadder.gate + 0.1 { t += 0.016; events += e.tick(at: t) }
        XCTAssertTrue(events.contains(.committed))
        events += e.cancel(at: t)
        while t < HoldLadder.gate + 2 { t += 0.016; events += e.tick(at: t) }
        XCTAssertFalse(events.contains(.completed), "a cancelled hold acted")
        XCTAssertTrue(events.contains(.drained))
    }

    /// One frame never advances more than 64 ms: a stall cannot complete a hold.
    func testAStalledFrameCannotCompleteAHold() {
        var e = HoldEngine(rise: HoldLadder.gate)
        _ = e.press(at: 0, by: .touch)
        _ = e.tick(at: 5)
        XCTAssertEqual(e.progress, HoldLadder.frameClamp / HoldLadder.gate, accuracy: 1e-9)
        XCTAssertFalse(e.release(at: 5, by: .touch).contains(.completed))
    }

    /// VoiceOver performs the act at once; the engine is then done.
    func testAVoicePerformsTheActAtOnce() {
        var e = HoldEngine(rise: HoldLadder.covenant)
        XCTAssertEqual(e.performByVoice(), [.committed, .completed])
        XCTAssertTrue(e.performByVoice().isEmpty)
        XCTAssertTrue(e.press(at: 0, by: .touch).isEmpty, "a done hold took another press")
        e.reset()
        XCTAssertFalse(e.press(at: 0, by: .touch).isEmpty)
    }

    /// The driver acts only on what the engine says (driven clock).
    @MainActor
    func testTheDriverActsOnlyOnTheEnginesWord() {
        var now = 0.0
        var committed = 0, completed = 0
        let driver = HoldDriver(rise: HoldLadder.gate, clock: { now })
        driver.feelsHaptics = false
        driver.bind(onCommit: { committed += 1 }, onComplete: { completed += 1 })
        driver.press(.touch)
        now = 0.3
        driver.release(.touch)
        XCTAssertEqual(committed + completed, 0, "an early release acted")
        driver.reset()
        driver.performByVoice()
        XCTAssertEqual(committed, 1)
        XCTAssertEqual(completed, 1)
        driver.reset()
    }

    func testTheHoldRampIsG0s() {
        XCTAssertEqual(HoldLadder.rampIntensity(at: 0), 0.15, accuracy: 1e-12)
        XCTAssertEqual(HoldLadder.rampIntensity(at: 1), 0.60, accuracy: 1e-12)
        XCTAssertEqual(HoldLadder.rampIntensity(at: 2), 0.60, accuracy: 1e-12)
        XCTAssertEqual(HoldLadder.rampSharpness, 0.3, accuracy: 1e-12)
        XCTAssertEqual(HoldEngine.spokenProgress(0.5), "50 percent")
    }

    // MARK: - The haptics library (sound.md S78, S53, S71)

    private func warmthOffences(_ patterns: [HapticPattern]) -> [String] {
        var out: [String] = []
        for p in patterns {
            let ceiling = HapticPattern.namedSharpness[p.name] ?? HapticPattern.warmCeiling
            for e in p.events where e.sharpness > ceiling + 1e-12 {
                out.append("\(p.name) sharpness \(e.sharpness) > \(ceiling)")
            }
            for e in p.events where !(0...1).contains(e.intensity) {
                out.append("\(p.name) intensity \(e.intensity)")
            }
        }
        return out
    }

    /// "warm, never sharp (sharpness ≤ .3 unless named)".
    func testTheLibraryIsWarm() {
        XCTAssertGreaterThanOrEqual(HapticPattern.library.count, 25)
        XCTAssertEqual(warmthOffences(HapticPattern.library), [])
        // Planted defect (V30).
        let sharp = HapticPattern(name: "sharp", events: [.transient(intensity: 0.5, sharpness: 0.9)])
        XCTAssertFalse(warmthOffences([sharp]).isEmpty, "the warmth check cannot see a sharp pattern")
    }

    /// The gesture set's numbers (S78).
    func testTheGestureSetIsS78s() {
        func first(_ p: HapticPattern) -> (Double, Double) { (p.events[0].intensity, p.events[0].sharpness) }
        XCTAssertTrue(first(.tick) == (0.3, 0.4))
        XCTAssertTrue(first(.word) == (0.3, 0.4))
        XCTAssertTrue(first(.heart) == (0.5, 0.3))
        XCTAssertTrue(first(.completion) == (0.8, 0.5))
        XCTAssertTrue(first(.kindle) == (0.6, 0.2))
        let descent = HapticPattern.descent(passage: 2.0)
        XCTAssertEqual(descent.events[0].time, 1.1, accuracy: 1e-9, "the Descent's felt moment is 55 % of the passage")
        XCTAssertTrue(first(descent) == (0.9, 0.15))
        XCTAssertEqual(HapticPattern.stillPoint(stage: 0)?.events.first?.intensity, 0.25)
        XCTAssertEqual(HapticPattern.stillPoint(stage: 1)?.events.first?.intensity, 0.15)
        XCTAssertNil(HapticPattern.stillPoint(stage: 2), "the Still Point's depth is not quiet")
        XCTAssertEqual(HapticPattern.panelGate.duration, 0.080, accuracy: 1e-9)
        XCTAssertEqual(HapticPattern.panelContinue.duration, 0.040, accuracy: 1e-9)
        XCTAssertEqual(HapticPattern.panelPivot.duration, 0.050, accuracy: 1e-9)
    }

    /// The heartbeat 60 bpm (S53: .35 / .15), the long-silence heart 50 bpm,
    /// charge 46.
    func testTheHeartsBeatAtTheirBpm() {
        XCTAssertEqual(HapticPattern.heartbeat.period ?? 0, 1.0, accuracy: 1e-12)
        XCTAssertEqual(HapticPattern.heartbeat.bpm ?? 0, 60, accuracy: 1e-9)
        XCTAssertEqual(HapticPattern.heartbeat.events.first?.intensity, 0.35)
        XCTAssertEqual(HapticPattern.heartbeat.events.first?.sharpness, 0.15)
        XCTAssertEqual(HapticPattern.longSilenceHeart.period ?? 0, 1.2, accuracy: 1e-12)
        XCTAssertEqual(HapticPattern.longSilenceHeart.events.first?.duration ?? 0, 0.030, accuracy: 1e-12)
        XCTAssertEqual(HapticPattern.charge.bpm ?? 0, 46, accuracy: 1e-9)
        XCTAssertEqual(HapticPattern.ringSevenBreath.period, 15)
    }

    /// The cross Score's own arrays (Airtable, 13 Oct) are the library's.
    func testTheScoresArraysAreTheLibrarys() throws {
        let patterns = try XCTUnwrap(try cross().score.score.haptics?.patterns)
        let crossing = try XCTUnwrap(patterns["crossing_peak"]?.patternMs)
        let bell = try XCTUnwrap(patterns["bell"]?.patternMs)
        let mirror = try XCTUnwrap(patterns["mirror_flash"]?.patternMs)
        XCTAssertEqual(HapticPattern.vibration("crossing", ms: crossing), .crossing)
        XCTAssertEqual(HapticPattern.vibration("bell", ms: bell), .bell)
        XCTAssertEqual(HapticPattern.vibration("mirror", ms: mirror), .mirror)
    }

    /// The web's vibrate arrays become Core Haptics events.
    func testAVibrateArrayBecomesEvents() {
        let p = HapticPattern.vibration("x", ms: [12, 40, 12, 60, 80])
        XCTAssertEqual(p.events.map(\.kind), [.transient, .transient, .continuous])
        for (got, want) in zip(p.events.map(\.time), [0, 0.052, 0.124]) {
            XCTAssertEqual(got, want, accuracy: 1e-12, "event times drift")
        }
        XCTAssertEqual(p.events[2].duration, 0.080, accuracy: 1e-12)
        XCTAssertNil(HapticPattern.hit(intensity: 0.4), "a hit at .4 was felt")
        XCTAssertEqual(HapticPattern.hit(intensity: 0.5)?.events.first?.kind, .transient)
        XCTAssertEqual(HapticPattern.hit(intensity: 1.0)?.events.first?.duration, 0)   // 20 ms: a tap
        XCTAssertEqual(HapticPattern.drop.duration, 0.100, accuracy: 1e-12)
        XCTAssertEqual(HapticPattern.earth(intensity: 1).events.count, 2)
    }

    // MARK: - The Score (V42)

    /// Every Score JSON row in the snapshot parses and passes the 21 rules —
    /// as `validate.py` passes all of them ("Zero FAILs required").
    func testEverySnapshotScoreLoads() throws {
        let cells = try snapshotScoreCells()
        XCTAssertEqual(cells.count, 46, "the snapshot's Score JSON rows changed")
        var ids: Set<String> = []
        for json in cells {
            do {
                let s = try ScoreLoader.load(json)
                ids.insert(s.score.score.identity.id)
                XCTAssertEqual(s.score.schema, ScoreV2.schemaV2)
                XCTAssertFalse(s.score.score.phases.isEmpty)
            } catch {
                XCTFail("\(error)")
            }
        }
        XCTAssertEqual(ids.count, 46, "two rows share a Score id")

        // The catalog reader agrees, and every row with a Score plays (Drafted).
        let rows = try ScoreCatalog.rows(fromPage: snapshotPage())
        XCTAssertEqual(rows.filter(\.isPlayable).count, 46)
        XCTAssertTrue(rows.filter(\.isPlayable).allSatisfy { $0.status == .drafted })
    }

    /// The warnings are validate.py's (with Appendix A and V42's needs_listening):
    /// cross warns only that its cathedral module is not built; the 45 batch
    /// drafts have no haptic at the peak.
    func testTheWarningsAreTheBatchsOwn() throws {
        let c = try cross()
        XCTAssertEqual(Set(c.warnings.map(\.rule)), [.r15])
        var r19 = 0, r21 = 0
        for json in try snapshotScoreCells() {
            let s = try ScoreLoader.load(json)
            guard s.score.score.identity.id != "cross" else { continue }
            if s.warnings.contains(where: { $0.rule == .r19 }) { r19 += 1 }
            if s.warnings.contains(where: { $0.rule == .r21 }) { r21 += 1 }
            XCTAssertFalse(s.warnings.contains { $0.rule == .r20 }, "\(s.score.score.identity.id) lost its reason")
        }
        XCTAssertEqual(r19, 45)
        XCTAssertEqual(r21, 43, "the peaks waiting for his listening changed")
        // A known module is not warned.
        XCTAssertTrue(try ScoreLoader.load(crossJSON(), knownModules: ["cathedral-v1"]).warnings.isEmpty)
    }

    /// A Score broken one rule at a time is refused under that rule (V30 for
    /// every hard rule).
    func testABrokenScoreIsRefused() throws {
        let base = try ScoreJSON.parse(crossJSON())
        XCTAssertEqual(try refusedRules(base), [], "cross itself was refused")
        func s(_ path: String...) -> [String] { ["score"] + path }
        let six: ScoreJSON = .array(["bindu", "gaia", "sid", "arch", "karishma", "sakshi"].map { .string($0) })
        let planted: [(ScoreFinding.Rule, ScoreJSON)] = [
            (.r1, setting(base, ["schema"], .string("bindu-score/v1.0"))),
            (.r2, setting(base, s("return"), nil)),
            (.r2, setting(base, s("field_connection"), .null)),
            (.r3, setting(base, s("identity", "id"), .string("Cross"))),
            (.r4, setting(base, s("anchors", "peak_t", "extracted"), .number(999))),
            (.r4, setting(base, s("identity", "song", "duration_seconds"), nil)),
            (.r5, setting(base, s("phases", "1", "start"), .number(20))),
            (.r6, setting(base, s("silence_windows", "1", "start"), .number(4))),
            // cross's phases are contiguous; open a gap 145–165 under its peak at 160.
            (.r7, setting(base, s("phases", "4", "start"), .number(165))),
            (.r8, setting(base, s("return", "starts_seconds_before_end"), .number(500))),
            (.r9, setting(base, s("binaural", "beat_schedule", "11", "until"), .number(229))),
            (.r9, setting(base, s("binaural", "beat_schedule", "3", "until"), .number(10))),
            (.r10, setting(base, s("path", "1", "max_blend"), .number(1.0))),
            (.r10, setting(base, s("shape_choreography", "0", "max_blend"), .number(1.2))),
            (.r11, setting(base, s("ensemble", "generation_order"), six)),
            (.r12, setting(base, s("mirror_system", "families", "abc"), .array([.string("x")]))),
            (.r13, setting(base, s("binaural", "carrier", "derivation"), .string("solfeggio"))),
            (.r14, setting(base, s("binaural", "carrier", "derivation"), .string("imposed"))),
            (.r16, setting(base, s("resonance_link", "carrier_hz"), .number(136.1))),
            (.r16, setting(base, s("resonance_link", "shaktis"), .array([.string("Kāmeśvarī at 528 Hz")]))),
            (.r17, setting(base, s("silence_footprint_pct"), nil)),
        ]
        for (rule, doc) in planted {
            let refused = try refusedRules(doc)
            XCTAssertTrue(refused.contains(rule), "a Score breaking \(rule.tag) was not refused under it (got \(refused))")
        }
        // An imposed carrier with its reason is lawful.
        let imposed = setting(setting(base, s("binaural", "carrier", "derivation"), .string("imposed")),
                              s("binaural", "carrier", "reason"), .string("the room's own tone"))
        XCTAssertEqual(try refusedRules(imposed), [])
        // Not JSON at all.
        XCTAssertThrowsError(try ScoreLoader.load("{"))
        // The id rule itself.
        XCTAssertTrue(ScoreValidator.isScoreId("in_shadow2"))
        XCTAssertFalse(ScoreValidator.isScoreId("2cross"))
        XCTAssertFalse(ScoreValidator.isScoreId("cross-2"))
    }

    /// The typed mirror holds cross as the format writes it.
    func testCrossDecodesIntoTheTypedMirror() throws {
        let b = try cross().score.score
        XCTAssertEqual(b.identity.id, "cross")
        XCTAssertEqual(b.identity.song?.durationSeconds, 230.09)
        XCTAssertEqual(b.config.peakT, 160, "score-format §3.4: cross ships PEAK_T 160")
        XCTAssertEqual(b.anchors.peakT?.extracted, 138.0, "§4: the extraction found 138.0")
        XCTAssertEqual(b.binaural.carrier.hz, 110)
        XCTAssertEqual(b.binaural.carrier.derivation, "absent_fifth")
        XCTAssertEqual(b.binaural.beatSchedule.last?.until, nil)
        XCTAssertEqual(b.binaural.beatSchedule.first { $0.ramp == true }?.hz, .ramp(from: 7, to: 9))
        XCTAssertEqual(b.ensemble?.generationOrder?.count, 7)
        XCTAssertEqual(b.mirrorSystem?.families?.count, 16)
        XCTAssertEqual(b.voiceTriggers?.count, 4)
        XCTAssertEqual(b.optionalLayers?.ol3VoiceGuidance?.isOn, false)
        XCTAssertEqual(b.returnPlan.startsSecondsBeforeEnd, 15)
    }

    // MARK: - Cue timing (S62)

    func testCrossCuesFallWhereTheScoreSaysInOrder() throws {
        let score = try cross().score
        let b = score.score
        let tl = ScoreTimeline(score: score)
        XCTAssertEqual(tl.duration, 230.09)
        XCTAssertEqual(tl.peak, 160)
        XCTAssertEqual(tl.returnStart, 230.09 - 15, accuracy: 1e-9)

        // In time order, every one inside the song (no voice: OL-3 is off).
        XCTAssertEqual(tl.cues.map(\.time), tl.cues.map(\.time).sorted())
        XCTAssertTrue(tl.cues.allSatisfy { $0.time >= 0 && $0.time <= tl.duration })
        XCTAssertFalse(tl.cues.contains { if case .voice = $0.kind { return true }; return false })

        func times(_ match: (ScoreCue.Kind) -> Bool) -> [TimeInterval] { tl.cues.filter { match($0.kind) }.map(\.time) }
        XCTAssertEqual(times { if case .phase = $0 { return true }; return false }, b.phases.map(\.start))
        XCTAssertEqual(times { if case .mirror = $0 { return true }; return false }, b.mirrorSystem?.times ?? [])
        XCTAssertEqual(times { if case .wordReveal = $0 { return true }; return false }, [160])
        XCTAssertEqual(times { if case .iLoveYou = $0 { return true }; return false }, [157], "peak_t - 3")
        XCTAssertEqual(times { if case .haptic(let n, _) = $0 { return n == "crossing_peak" }; return false }, [160])
        XCTAssertEqual(times { if case .haptic(let n, _) = $0 { return n == "mirror_flash" }; return false },
                       b.mirrorSystem?.times ?? [])
        XCTAssertEqual(times { if case .haptic(let n, _) = $0 { return n == "bell" }; return false }, [],
                       "a bell fired without the song's hits")
        XCTAssertEqual(times { if case .climax(true) = $0 { return true }; return false }, [145])
        XCTAssertEqual(times { if case .climax(false) = $0 { return true }; return false }, [195])
        let thresholds = times { if case .threshold(true) = $0 { return true }; return false }
        XCTAssertEqual(thresholds.count, 2, "Tier 0 is [[0, 2], [\"end-1\", \"end\"]]")
        XCTAssertEqual(thresholds.first ?? -1, 0, accuracy: 1e-9)
        XCTAssertEqual(thresholds.last ?? -1, 230.09 - 1, accuracy: 1e-9)
        XCTAssertEqual(times { if case .returnBegan = $0 { return true }; return false }, [tl.returnStart])
        XCTAssertEqual(times { if case .ended = $0 { return true }; return false }, [230.09])
        XCTAssertEqual(times { if case .shape = $0 { return true }; return false }, [30, 145, tl.returnStart])
        let beats = times { if case .beat = $0 { return true }; return false }
        XCTAssertEqual(beats.count, 12)
        XCTAssertEqual(beats.first, 0)

        // The Return dissolves in the Score's order; the ledger writes there.
        let ledger = tl.cues.compactMap { c -> ScoreLedgerWrite? in
            if case .ledger(let w) = c.kind { return w }
            return nil
        }
        XCTAssertEqual(ledger.count, 1)
        XCTAssertEqual(ledger.first?.event, .danceCompleted)
        XCTAssertEqual(ledger.first?.trackRecordId, "recmLDCDcmA5r4CJt")
        XCTAssertEqual(ledger.first?.declaredActivityType, b.fieldConnection.appActivity?.activityType)
        XCTAssertEqual(tl.cues.first { $0.lane == .ledger }?.time, tl.returnStart)

        // OL-3 on: his recordings, at the Score's times.
        let voiced = ScoreTimeline(score: score, voiceGuidance: true)
        let voiceTimes = voiced.cues.filter(Self.isVoice).map(\.time)
        XCTAssertEqual(voiceTimes, (b.voiceTriggers ?? []).map(\.t))
        XCTAssertTrue(voiced.cues.filter(Self.isVoice).allSatisfy { $0.lane == .sound })
    }

    /// The beat: steps, the ramp, the designed windows, Karishma's freeze.
    func testTheBeatFollowsTheScheduleAndFreezesInSilence() throws {
        let tl = ScoreTimeline(score: try cross().score)
        XCTAssertEqual(tl.beat(at: 20), 8.0)
        XCTAssertEqual(tl.scheduledBeat(at: 162), 7.83, "the designed Schumann window")
        XCTAssertEqual(tl.scheduledBeat(at: 165), 2.69, "the designed 2.69 window")
        XCTAssertEqual(tl.scheduledBeat(at: 214) ?? 0, 8.0, accuracy: 1e-9, "the 7 → 9 ramp at its middle")
        XCTAssertEqual(tl.scheduledBeat(at: 229), 10.0)
        // 205.5–210 is a silence inside the ramp: the beat holds its value at 205.5.
        XCTAssertTrue(tl.beatFreezesInSilence)
        let frozen = tl.scheduledBeat(at: 205.5) ?? 0
        XCTAssertEqual(tl.beat(at: 209) ?? 0, frozen, accuracy: 1e-12)
        XCTAssertNotEqual(tl.scheduledBeat(at: 209) ?? 0, frozen, accuracy: 1e-6, "the planted check cannot see a freeze")
    }

    /// The gain laws.
    func testTheGainLaws() throws {
        let tl = ScoreTimeline(score: try cross().score)
        XCTAssertEqual(tl.phaseMultiplier(at: 163), 1.3)
        XCTAssertEqual(tl.phaseMultiplier(at: 150), 1.2)
        XCTAssertEqual(tl.phaseMultiplier(at: 210), 0.8)
        XCTAssertEqual(tl.phaseMultiplier(at: 50), 1.0)
        for t in stride(from: 0.0, through: 230.0, by: 0.5) {
            for e in [0.0, 0.5, 1.0] {
                let g = tl.binauralGain(at: t, energy: e)
                XCTAssertTrue(g == 0 || (ScoreTimeline.binauralFloor...ScoreTimeline.binauralCeiling).contains(g),
                              "binaural gain \(g) at \(t) s left its band")
            }
        }
        // Inverse: quieter song, louder binaural — at 26.18 s, where Karishma's
        // sway is at its trough (sin(.18 t) = −1), so neither reading is clipped.
        let trough = 1.5 * Double.pi / ScoreTimeline.karishmaSwayRate
        XCTAssertEqual(tl.binauralGain(at: trough, energy: 1.0), 0.030, accuracy: 1e-9)
        XCTAssertEqual(tl.binauralGain(at: trough, energy: 0.0), 0.050, accuracy: 1e-9)
        XCTAssertEqual(tl.binauralGain(at: 230.09, energy: 0), 0, accuracy: 1e-12, "the final ramp does not close")
        XCTAssertEqual(tl.songGain(at: 0), 0)
        XCTAssertEqual(tl.songGain(at: 1.5), 0.4, accuracy: 1e-12)
        XCTAssertEqual(tl.songGain(at: 100), 0.8, accuracy: 1e-12)
        XCTAssertEqual(tl.songGain(at: 231), 0)
        // Tier 4: ramp 145–160, hold 160–180, out 180–195, factor .8.
        XCTAssertEqual(tl.globalBoost(at: 100), 1.0, accuracy: 1e-12)
        XCTAssertEqual(tl.globalBoost(at: 152.5), 1.4, accuracy: 1e-12)
        XCTAssertEqual(tl.globalBoost(at: 170), 1.8, accuracy: 1e-12)
        XCTAssertEqual(tl.globalBoost(at: 187.5), 1.4, accuracy: 1e-12)
        XCTAssertTrue(tl.isThreshold(at: 1))
        XCTAssertFalse(tl.isThreshold(at: 100))
        XCTAssertTrue(tl.isReturning(at: 220))
    }

    /// The player fires every cue once, in order, on one clock; a seek fires
    /// nothing.
    @MainActor
    func testThePlayerFiresEachCueOnceInOrder() throws {
        let player = try ScorePlayer.load(crossJSON())
        player.feelsHaptics = false
        var fired: [ScoreCue] = []
        player.onCue = { fired.append($0) }
        var t = 0.0
        while t <= player.timeline.duration + 1 {
            player.advance(to: t)
            t += 0.25
        }
        XCTAssertEqual(fired, player.timeline.cues, "a cue was skipped, doubled or reordered")
        XCTAssertTrue(player.hasEnded)

        // Planted defect (V30): the same comparison sees a doubled cue.
        XCTAssertNotEqual(fired + [fired[0]], player.timeline.cues)

        // A seek back fires nothing and re-syncs.
        fired.removeAll()
        player.seek(to: 150)
        XCTAssertTrue(fired.isEmpty)
        XCTAssertEqual(player.phaseName, "The Crossing")
        XCTAssertEqual(player.advance(to: 161).map(\.time).filter { $0 <= 150 }, [], "a seek re-fired the past")
        XCTAssertTrue(fired.contains { if case .wordReveal = $0.kind { return true }; return false })

        // A batch draft plays too: its one beat, its return at the default lead.
        let draft = try XCTUnwrap(try snapshotScoreCells().compactMap { try? ScoreLoader.load($0) }
            .first { $0.score.score.identity.id == "move" })
        let tl = ScoreTimeline(score: draft.score)
        XCTAssertEqual(tl.returnStart, tl.duration - ScoreTimeline.defaultReturnLead, accuracy: 1e-9)
        XCTAssertEqual(tl.cues.filter { if case .beat = $0.kind { return true }; return false }.count, 1)
        XCTAssertEqual(tl.seedSecondsPerCharacter ?? 0, 60 / 129.2, accuracy: 1e-9, "the seed types at the beat")
    }

    /// One clock: the free clock runs, pauses and seeks; a song's clock rules
    /// when there is one.
    @MainActor
    func testTheOneClock() throws {
        var c = FreeScoreClock()
        XCTAssertEqual(c.time(at: 50), 0)
        c.start(at: 100)
        XCTAssertEqual(c.time(at: 102.5), 2.5, accuracy: 1e-12)
        c.pause(at: 103)
        XCTAssertEqual(c.time(at: 200), 3, accuracy: 1e-12)
        c.seek(to: 10, at: 200)
        c.start(at: 300)
        XCTAssertEqual(c.time(at: 301), 11, accuracy: 1e-12)

        final class Song: ScoreClockSource { var scoreTime: TimeInterval? }
        let song = Song()
        var host = 0.0
        let player = ScorePlayer(score: try cross(), host: { host })
        player.feelsHaptics = false
        player.songClock = song
        host = 500
        song.scoreTime = 0
        player.tick()
        XCTAssertEqual(player.time, 0, "the clock moved before the song played")
        song.scoreTime = 42
        player.tick()
        XCTAssertEqual(player.time, 42, "the song's time is not the one clock")
    }

    /// Nothing counts him: the fruit's counting weaves are dropped; the rest
    /// are the Score's own words.
    func testTheFruitNeverCountsHim() throws {
        let tl = ScoreTimeline(score: try cross().score)
        let all = try XCTUnwrap(tl.score.score.consciousnessLoop.fruit?.weaves)
        XCTAssertTrue(all.contains { $0.text.contains("{n}") }, "the planted counting weave is gone from cross")
        XCTAssertFalse(tl.fruitWeaves.contains { $0.text.contains("{n}") || $0.condition.contains("prior_") })
        XCTAssertEqual(tl.fruitWeaves.count, all.count - all.filter(ScoreTimeline.countsHim).count)
        XCTAssertTrue(tl.fruitWeaves.contains { $0.condition == "motion == still" })
        XCTAssertEqual(tl.seedSecondsPerCharacter ?? 0, 0.557, accuracy: 1e-9)
    }

    /// The song's frame data: `SC()` and the haptics it adds.
    func testTheSongsFrameData() throws {
        XCTAssertEqual(ScoreAudioData.interpolate([0, 1, 0], at: 0.25, frame: 0.5), 0.5, accuracy: 1e-12)
        XCTAssertEqual(ScoreAudioData.interpolate([0, 1, 0], at: 0.75, frame: 0.5), 0.5, accuracy: 1e-12)
        XCTAssertEqual(ScoreAudioData.interpolate([0, 1, 0], at: 9, frame: 0.5), 0)
        let json = #"{"meta":{"frame_interval":0.5},"E":[0,1,0.5],"H":[{"t":10,"i":0.3},{"t":201,"i":0.7},[202,0.9]],"DROPS":[{"t":150},88]}"#
        let audio = try ScoreAudioData.parse(Data(json.utf8))
        XCTAssertEqual(audio.hits.count, 3)
        XCTAssertEqual(audio.drops, [150, 88])
        XCTAssertEqual(audio.sample("E", at: 0.25) ?? -1, 0.5, accuracy: 1e-12)
        let tl = ScoreTimeline(score: try cross().score, audio: audio)
        let hits = tl.cues.filter { if case .haptic(let n, _) = $0.kind { return n == "hit" }; return false }.map(\.time)
        XCTAssertEqual(hits, [201, 202], "a hit at .3 was felt, or one above .4 was not")
        let bells = tl.cues.filter { if case .haptic(let n, _) = $0.kind { return n == "bell" }; return false }.map(\.time)
        XCTAssertEqual(bells, [201, 202], "cross's bell criteria: after 200 s, hit ≥ .6")
        XCTAssertEqual(tl.cues.filter { if case .haptic(let n, _) = $0.kind { return n == "drop" }; return false }.count, 2)
    }

    /// Only Drafted or higher plays.
    func testOnlyADraftedScorePlays() throws {
        XCTAssertFalse(ScoreStatus.unscored.plays)
        XCTAssertTrue(ScoreStatus.drafted.plays)
        XCTAssertTrue(ScoreStatus.verified.plays)
        let page = #"{"records":[{"id":"rec1","fields":{"Score JSON":"{}","Score Status":"Unscored","Verb":"x"}},{"id":"rec2","fields":{"fldxIm6qUXLcdrRuR":"{}","fldOSMHwD7IxshwO7":{"id":"sel","name":"Verified"}}}]}"#
        let rows = try ScoreCatalog.rows(fromPage: Data(page.utf8))
        XCTAssertEqual(rows.map(\.isPlayable), [false, true])
        XCTAssertEqual(rows.first?.verb, "x")
    }
}
