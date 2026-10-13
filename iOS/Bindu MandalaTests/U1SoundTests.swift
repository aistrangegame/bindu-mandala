import XCTest
@testable import Bindu_Mandala

// MARK: - Upgrade U1 · B · Sound
//
// `waves/upgrade/worlds/sound.md` §1.2–1.9 and S81. The numbers are read from
// Design's own files where they exist — `Design/Corpus/homes-sound.js` (ROOTS,
// JUST), `Design/Corpus/living-rite-core.jsx` (LR_RING_FREQ, `lrRingChime`),
// `Design/Chakra/shell/walk-canon.js` (the canon awakening panels) — through
// `DesignCorpus`, where a missing file is a failure, never a skip. The rest are
// sound.md's tables, written here with the element they come from. The mixer
// is rendered offline (`MixRenderer`) and measured: amplitude at a frequency
// by direct correlation, peaks, the duck, the crossfade.

@MainActor
final class U1SoundTests: XCTestCase {

    // MARK: Helpers

    private func matches(_ pattern: String, in text: String) -> [[String]] {
        guard let re = try? NSRegularExpression(pattern: pattern) else {
            XCTFail("bad pattern \(pattern)")
            return []
        }
        let ns = text as NSString
        return re.matches(in: text, range: NSRange(location: 0, length: ns.length)).map { m in
            (0..<m.numberOfRanges).map { i in
                let r = m.range(at: i)
                return r.location == NSNotFound ? "" : ns.substring(with: r)
            }
        }
    }

    private func numbers(_ text: String) -> [Double] {
        matches("-?[0-9]+(?:\\.[0-9]+)?", in: text).compactMap { Double($0[0]) }
    }

    /// Amplitude of `hz` in `x` by direct correlation (a one-bin DFT).
    private func amplitude(_ x: [Float], _ hz: Double, sampleRate: Double = 44_100) -> Double {
        var re = 0.0, im = 0.0
        let w = 2 * Double.pi * hz / sampleRate
        for (n, s) in x.enumerated() {
            re += Double(s) * cos(w * Double(n))
            im += Double(s) * sin(w * Double(n))
        }
        return 2 * (re * re + im * im).squareRoot() / Double(x.count)
    }

    private func peak(_ x: [Float]) -> Double { Double(x.map { abs($0) }.max() ?? 0) }

    /// A renderer whose master has woken fully (τ 1.2 s; 6 s is > 99 %),
    /// with nothing else sounding.
    private func settled() -> MixRenderer {
        let r = MixRenderer()
        r.post(.master(1))
        _ = r.render(seconds: 6)
        return r
    }

    private func lrRingChimeBody() throws -> String {
        let text = try DesignCorpus.text("living-rite-core.jsx")
        guard let start = text.range(of: "function lrRingChime") else {
            XCTFail("lrRingChime not in living-rite-core.jsx")
            return ""
        }
        return String(text[start.lowerBound...].prefix(2500))
    }

    // MARK: - The one tuning (§1.4, S10)

    /// Design's ROOTS, read off `homes-sound.js`, are the spine — and
    /// `HomeCarrier` holds the same nine.
    func testRingRootsAreDesignsROOTS() throws {
        let js = try DesignCorpus.text("homes-sound.js")
        guard let body = matches("const ROOTS = \\[([^\\]]*)\\]", in: js).first?[1] else {
            return XCTFail("ROOTS not found in homes-sound.js")
        }
        let design = numbers(body)
        XCTAssertEqual(design.count, 9)
        XCTAssertEqual(Tuning.ringRoots.count, design.count)
        for (mine, theirs) in zip(Tuning.ringRoots, design) { XCTAssertEqual(mine, theirs, accuracy: 1e-9) }
        XCTAssertEqual(HomeCarrier.roots, Tuning.ringRoots, "HomeCarrier and Tuning must not drift apart")
        XCTAssertEqual(Tuning.root(ring: 0), 55, accuracy: 1e-9)
        XCTAssertEqual(Tuning.root(ring: 42), 123.47, accuracy: 1e-9)
    }

    func testJustIntervalsAreDesignsJUST() throws {
        let js = try DesignCorpus.text("homes-sound.js")
        guard let body = matches("const JUST = \\[([^\\]]*)\\]", in: js).first?[1] else {
            return XCTFail("JUST not found in homes-sound.js")
        }
        let design: [Double] = body.split(separator: ",").map { term in
            let parts = term.split(separator: "/").map { Double($0.trimmingCharacters(in: .whitespaces)) ?? .nan }
            return parts.count == 2 ? parts[0] / parts[1] : parts[0]
        }
        XCTAssertEqual(design.count, 12)
        XCTAssertEqual(Tuning.just.count, 12)
        for (mine, theirs) in zip(Tuning.just, design) { XCTAssertEqual(mine, theirs, accuracy: 1e-12) }
    }

    /// S11, sound.md §1.4's examples: Aṃ@R1 110.00 · ka@R1 137.50; no syllable → root.
    func testCarrierLaw() {
        XCTAssertEqual(Tuning.carrier(ring: 1, syllable: "Aṃ"), 110.0, accuracy: 0.001)
        XCTAssertEqual(Tuning.carrier(ring: 1, syllable: "ka"), 137.5, accuracy: 0.001)
        XCTAssertEqual(Tuning.carrier(ring: 4, syllable: nil), 73.42, accuracy: 0.001)
    }

    /// S26: bell(r) = root(10 − r) × 4, falling inward.
    func testNineEnclosureBells() {
        let table = [493.88, 440.00, 392.00, 370.00, 329.64, 293.68, 277.20, 246.96, 220.00]
        XCTAssertEqual(Tuning.bells.count, 9)
        for (r, hz) in table.enumerated() {
            XCTAssertEqual(Tuning.bell(ring: r + 1), hz, accuracy: 0.005, "bell \(r + 1)")
        }
        for r in 1..<9 { XCTAssertGreaterThan(Tuning.bell(ring: r), Tuning.bell(ring: r + 1), "deeper rings ring lower") }
    }

    /// §7 ruling 3: five of Design's eight LR_RING_FREQ pitches survive exactly
    /// (392, 329.6, 293.7, 246.9, 220) — read from living-rite-core.jsx.
    func testFiveOfDesignsEightRingChimesSurvive() throws {
        let jsx = try DesignCorpus.text("living-rite-core.jsx")
        guard let body = matches("const LR_RING_FREQ = \\{([^}]*)\\}", in: jsx).first?[1] else {
            return XCTFail("LR_RING_FREQ not found")
        }
        let design = matches("[0-9]+:\\s*([0-9.]+)", in: body).compactMap { Double($0[1]) }
        XCTAssertEqual(design.count, 8)
        let survivors = design.filter { d in Tuning.bells.contains { abs($0 - d) <= 0.1 } }
        XCTAssertEqual(survivors.sorted(), [220.0, 246.9, 293.7, 329.6, 392.0])
    }

    /// S26: Design's bell kept verbatim — duration, attack and peak, lowpass,
    /// partials — read from `lrRingChime`; its voice gain then held at 0.075.
    func testBellVoiceIsDesignsLrRingChime() throws {
        let body = try lrRingChimeBody()
        XCTAssertEqual(Double(matches("dur = ([0-9.]+)", in: body).first?[1] ?? ""), Tuning.BellVoice.duration)
        let master = matches("master\\.gain\\.exponentialRampToValueAtTime\\(([0-9.]+), now \\+ ([0-9.]+)\\)", in: body).first
        XCTAssertEqual(Double(master?[1] ?? ""), Tuning.BellVoice.designPeak)
        XCTAssertEqual(Double(master?[2] ?? ""), Tuning.BellVoice.attack)
        XCTAssertEqual(Double(matches("warm\\.frequency\\.setValueAtTime\\(([0-9.]+)", in: body).first?[1] ?? ""),
                       Tuning.BellVoice.lowpassFrom)
        let fall = matches("warm\\.frequency\\.exponentialRampToValueAtTime\\(([0-9.]+), now \\+ dur \\* ([0-9.]+)\\)", in: body).first
        XCTAssertEqual(Double(fall?[1] ?? ""), Tuning.BellVoice.lowpassTo)
        XCTAssertEqual(Double(fall?[2] ?? ""), Tuning.BellVoice.lowpassFraction)
        let parts = matches("\\[base(?: \\* ([0-9.]+))?, ([0-9.]+), dur(?: \\* ([0-9.]+))?\\]", in: body).map { m in
            (Double(m[1]) ?? 1, Double(m[2]) ?? .nan, Double(m[3]) ?? 1)
        }
        XCTAssertEqual(parts.count, Tuning.BellVoice.partials.count)
        for (p, mine) in zip(parts, Tuning.BellVoice.partials) {
            XCTAssertEqual(p.0, mine.ratio, accuracy: 1e-9)
            XCTAssertEqual(p.1, mine.gain, accuracy: 1e-9)
            XCTAssertEqual(p.2, mine.durationFraction, accuracy: 1e-9)
        }
        XCTAssertEqual(MixLaw.clampEvent(Tuning.BellVoice.designPeak), MixLaw.eventCeiling,
                       "a synthesised voice never stands above 0.075 (S04)")
    }

    /// sound.md §1.4's derived table.
    func testDerivedTable() {
        let vak = [196.00, 220.50, 245.00, 261.33, 326.67, 367.50, 392.00, 441.00, 490.00, 522.67, 653.33, 735.00]
        XCTAssertEqual(Tuning.vakLadder.count, 12)
        for (mine, hz) in zip(Tuning.vakLadder, vak) { XCTAssertEqual(mine, hz, accuracy: 0.005) }
        XCTAssertFalse(Tuning.vakRatios.contains(1.5), "the Vāk ladder withholds the fifth")
        for (mine, hz) in zip(Tuning.triad, [220.0, 277.2, 330.0]) { XCTAssertEqual(mine, hz, accuracy: 0.001) }
        XCTAssertEqual(Tuning.triadUnison, 110, accuracy: 1e-9)
        XCTAssertEqual(Tuning.shepardFMin, 30.87, accuracy: 0.005)
        XCTAssertEqual(Tuning.shepardVoices, 7)
        XCTAssertEqual(Tuning.climbBeats, [8, 7.5, 7, 6.5, 6, 5.5, 5, 4.5, 4.2])
        XCTAssertEqual(Tuning.summitBeat, 4)
        XCTAssertEqual(Tuning.climbCarrier(ring: 8), 220, accuracy: 1e-9)
        XCTAssertEqual(Tuning.fallingMantraDuration(ring: 1), 1.2, accuracy: 0.001)
        XCTAssertEqual(Tuning.fallingMantraDuration(ring: 9), 2.69, accuracy: 0.01)
        XCTAssertEqual(Tuning.fallingMantra(ring: 9, vowel: .i), 330, accuracy: 0.001)
        XCTAssertEqual(Tuning.fallingMantraDelay, 0.18)
        XCTAssertEqual(Tuning.Om.partials.map { $0.hz }, [68.05, 136.1, 272.2])
        XCTAssertEqual(Tuning.Om.partials.map { $0.gain }, [0.15, 1.0, 0.30])
        XCTAssertEqual(Tuning.Om.root, TreeOfLife.omHz)
    }

    /// S12: the strikes are [1, 2, 4] until the fifth is granted (≥ 0.5), then
    /// Design's [1, 1.5, 2]; always granted in ring 9.
    func testStrikesWithholdTheFifth() {
        XCTAssertEqual(Tuning.strikeRatios(grantsFifth: 0, ring: 3), [1, 2, 4])
        XCTAssertEqual(Tuning.strikeRatios(grantsFifth: 0.49, ring: 3), [1, 2, 4])
        XCTAssertEqual(Tuning.strikeRatios(grantsFifth: 0.5, ring: 3), [1, 1.5, 2])
        XCTAssertEqual(Tuning.strikeRatios(grantsFifth: 0, ring: 9), [1, 1.5, 2])
        XCTAssertEqual(Tuning.grantsFifth(ring: 9, chamberSeconds: 0, dwellSeconds: 0), 1)
        XCTAssertEqual(Tuning.grantsFifth(ring: 2, chamberSeconds: 287, dwellSeconds: 0), 0.5, accuracy: 1e-9)
        XCTAssertEqual(Tuning.grantsFifth(ring: 2, chamberSeconds: 0, dwellSeconds: 480), 1, accuracy: 1e-9)
        XCTAssertEqual(Tuning.grantsFifth(ring: 2, chamberSeconds: 100, dwellSeconds: 100), 0)
        // Beat 2 on entry is the octave, not the fifth.
        let c = Tuning.carrier(ring: 1, syllable: "ka")
        XCTAssertEqual(Tuning.strike(ring: 1, beat: 2, syllable: "ka", grantsFifth: 0), c * 2, accuracy: 1e-9)
    }

    /// Every pitch the tables carry is in the one tuning; no retired-only
    /// pitch is (S81).
    func testEveryTablePitchIsInTheOneTuningAndNoRetiredOne() {
        var pitches = Tuning.bells + Tuning.vakLadder + Tuning.triad + RoomTones.all.compactMap { $0.hz }
        for v in WorldVoices.all {
            if case let .partials(fundamental, _, _, _) = v.bed { pitches.append(fundamental) }
            if case .fixed(let hz) = v.threshold { pitches.append(hz) }
        }
        for hz in pitches { XCTAssertTrue(Tuning.isAllowed(hz), "\(hz) Hz is outside the one tuning") }
        for hz in Tuning.retiredOnly { XCTAssertFalse(Tuning.isAllowed(hz), "retired \(hz) Hz is still allowed") }
        XCTAssertFalse(Tuning.retired.isEmpty)
    }

    // MARK: - The 33 rooms' fixed tones (§1.7, S48)

    /// The awakening tones are the canon panels P1–P8, read from
    /// `Design/Chakra/shell/walk-canon.js`; P9 (Silence) is Maya.
    func testRoomTonesAreTheCanonAwakeningPanels() throws {
        let js = try DesignCorpus.text("Design/Chakra/shell/walk-canon.js")
        let panels = matches("Awakening — \\S+ \\(P([0-9]), ([0-9.]+) Hz\\)", in: js)
        XCTAssertEqual(panels.count, 8)
        for m in panels {
            guard let p = Int(m[1]), let hz = Double(m[2]), let room = RoomTones.awakeningPanelRooms[p] else {
                XCTFail("unreadable panel \(m)"); continue
            }
            XCTAssertEqual(RoomTones.tone(room: room)?.hz, hz, "P\(p) → room \(room)")
            XCTAssertEqual(RoomTones.tone(room: room)?.kind, .tone)
        }
        let silence = matches("Awakening — \\S+ \\(P([0-9]), Silence\\)", in: js)
        XCTAssertEqual(silence.first?[1], "9")
        XCTAssertEqual(RoomTones.tone(room: RoomTones.awakeningPanelRooms[9] ?? 0)?.kind, .silence)
    }

    func testRoomTableShape() {
        XCTAssertEqual(RoomTones.all.map { $0.room }, Array(1...33))
        XCTAssertEqual(RoomTones.tone(room: 32)?.kind, .sealed)
        XCTAssertNil(RoomTones.tone(room: 32)?.hz, "room 32 is sealed: no tone")
        XCTAssertNil(HerSpec.room(RoomTones.tone(room: 32)!))
        for room in 21...29 {
            XCTAssertEqual(RoomTones.tone(room: room)?.hz, 110)
            XCTAssertEqual(RoomTones.tone(room: room)?.kind, .mindRoom)
        }
        XCTAssertEqual(RoomTones.tone(room: 20)?.hz ?? 0, Tuning.root(ring: 4), accuracy: 1e-9, "Armin is D2, R4's root")
        XCTAssertEqual(RoomTones.tone(room: 1)?.kind, .om)
        XCTAssertEqual(RoomTones.tone(room: 33)?.kind, .om)
        let wake = [2, 3, 4, 5, 6, 7, 8, 31].compactMap { RoomTones.tone(room: $0)?.wakeUpCarrier }
        XCTAssertEqual(wake, [87, 105, 160, 170.5, 192, 213, 240, 264])
        XCTAssertEqual([10, 11, 12, 13, 14, 15, 16, 17, 18].compactMap { RoomTones.tone(room: $0)?.hz },
                       [174, 320, 210, 341, 341, 384, 384, 426, 426])
        XCTAssertEqual(RoomTones.practiceGain, 0.012)
    }

    // MARK: - The fifteen world voices (§1.5, S22)

    func testWorldVoicesMatchTheTable() {
        XCTAssertEqual(WorldVoices.all.map { $0.world }, WorldID.allCases)
        for v in WorldVoices.all { XCTAssertTrue(v.buses.contains(.floor), "\(v.world): the Om is under everything") }

        XCTAssertEqual(WorldVoices.voice(for: .home).bed, WorldBed.none)
        XCTAssertEqual(WorldVoices.voice(for: .home).thresholdHz(), 136.1)

        // The 33: WORLD_ESSENCE road, "stately bell".
        guard case let .partials(f33, p33, lp33, _) = WorldVoices.voice(for: .the33).bed else {
            return XCTFail("the 33 has a partials bed")
        }
        XCTAssertEqual(f33, 146.8)
        XCTAssertEqual(p33.map { $0.ratio }, [1, 2, 3, 5])
        XCTAssertEqual(p33.map { $0.gain }, [0.36, 0.18, 0.10, 0.05])
        XCTAssertEqual(lp33, 920)

        // The Relationship Field: 272.2 × [1, 1.005, 1.5, 2], a 1.36 Hz beat.
        guard case let .partials(fr, pr, lpr, _) = WorldVoices.voice(for: .relationship).bed else {
            return XCTFail("the Field has a partials bed")
        }
        XCTAssertEqual(fr, 272.2)
        XCTAssertEqual(pr.map { $0.ratio }, [1, 1.005, 1.5, 2])
        XCTAssertEqual(pr.map { $0.gain }, [0.28, 0.28, 0.15, 0.09])
        XCTAssertEqual(lpr, 1100)
        XCTAssertEqual(fr * 0.005, 1.36, accuracy: 0.005)

        guard case let .partials(fm, pm, lpm, _) = WorldVoices.voice(for: .modes).bed else { return XCTFail("modes") }
        XCTAssertEqual(fm, 138.6)
        XCTAssertEqual(pm.map { $0.wave }, [.triangle, .sine])
        XCTAssertEqual(pm.map { $0.gain }, [0.42, 0.22])
        XCTAssertEqual(lpm, 440)

        guard case let .partials(fmem, pmem, lpmem, _) = WorldVoices.voice(for: .memory).bed else { return XCTFail("memory") }
        XCTAssertEqual(fmem, 98.0)
        XCTAssertEqual(pmem.map { $0.gain }, [0.55])
        XCTAssertEqual(lpmem, 360)

        guard case let .partials(fg, pg, lpg, _) = WorldVoices.voice(for: .game).bed else { return XCTFail("game") }
        XCTAssertEqual(fg, 196)
        XCTAssertEqual(pg.map { $0.ratio }, [1, 1.25, 1.5])
        XCTAssertEqual(lpg, 900)

        XCTAssertEqual(WorldVoices.voice(for: .well).bed, .pinkNoise(gain: 0.015))
        XCTAssertEqual(WorldVoices.voice(for: .well).thresholdPeak, 0.016)
        XCTAssertEqual(WorldVoices.voice(for: .beneath).bed, .score(recording: "bindu/kingdom.mp3"))
        XCTAssertEqual(WorldVoices.voice(for: .mandala).bed, .ringGround(.enclosure))
        XCTAssertEqual(WorldVoices.voice(for: .climb).bed, .ringGround(.climb))

        // Thresholds (§1.5's last column).
        XCTAssertEqual(WorldVoices.voice(for: .mandala).thresholdHz(ring: 1), 110)
        XCTAssertEqual(WorldVoices.voice(for: .rings).thresholdHz(ring: 7), 196)
        XCTAssertEqual(WorldVoices.voice(for: .game).thresholdHz(), 196)
        XCTAssertEqual(WorldVoices.voice(for: .time).thresholdHz(), 194.18)
        XCTAssertEqual(WorldVoices.voice(for: .memory).thresholdHz(), 196)
        XCTAssertEqual(WorldVoices.voice(for: .beneath).thresholdHz(), 123.47)
        XCTAssertEqual(WorldVoices.voice(for: .today).thresholdHz(herCarrier: 137.5), 137.5)

        // The Mandala's ground is quieter deeper: 0.16 − 0.0125·(r − 1).
        XCTAssertEqual(RingGroundRule.enclosure.level(ring: 1), 0.16, accuracy: 1e-9)
        XCTAssertEqual(RingGroundRule.enclosure.level(ring: 9), 0.06, accuracy: 1e-9)
        XCTAssertEqual(RingGroundRule.ring.level(ring: 9), 0.16, accuracy: 1e-9)
    }

    /// DH:4208–4376 / S22: Q .65, 0.08 Hz at cutoff × 0.25, ±2 cents, 2.6 s
    /// equal-power, 2.9 s stop, 0.028 over 2.4 s.
    func testCrossfadeIsEqualPower() {
        XCTAssertEqual(WorldVoices.lowpassQ, 0.65)
        XCTAssertEqual(WorldVoices.breathHz, 0.08)
        XCTAssertEqual(WorldVoices.breathDepth, 0.25)
        XCTAssertEqual(WorldVoices.detuneCents, 2)
        XCTAssertEqual(WorldVoices.crossfade, 2.6)
        XCTAssertEqual(WorldVoices.outgoingStop, 2.9)
        XCTAssertEqual(WorldVoices.bedLevel, 0.028)
        XCTAssertEqual(WorldVoices.bedRise, 2.4)
        for t in stride(from: 0.0, through: 2.6, by: 0.13) {
            let g = WorldVoices.equalPower(t: t)
            XCTAssertEqual(g.out * g.out + g.incoming * g.incoming, 1, accuracy: 1e-9, "equal power at \(t)")
        }
        XCTAssertEqual(WorldVoices.equalPower(t: 0).out, 1, accuracy: 1e-12)
        XCTAssertEqual(WorldVoices.equalPower(t: 2.6).incoming, 1, accuracy: 1e-12)
    }

    /// S09: sine f + f × 2.002 at 0.22, peak 0.032 at 0.42 of 1.8 s; the menu hum 0.010.
    func testThresholdTone() {
        XCTAssertEqual(WorldVoices.Threshold.partialRatio, 2.002)
        XCTAssertEqual(WorldVoices.Threshold.partialGain, 0.22)
        XCTAssertEqual(WorldVoices.Threshold.menuHum, 0.010)
        XCTAssertEqual(WorldVoices.thresholdEnvelope(t: 0.42 * 1.8), 0.032, accuracy: 1e-12)
        XCTAssertEqual(WorldVoices.thresholdEnvelope(t: 0), 0)
        XCTAssertEqual(WorldVoices.thresholdEnvelope(t: 1.8), 0)
        let samples = stride(from: 0.0, through: 1.8, by: 0.001).map { WorldVoices.thresholdEnvelope(t: $0) }
        let top = samples.indices.max { samples[$0] < samples[$1] } ?? 0
        XCTAssertEqual(Double(top) * 0.001, 0.756, accuracy: 0.002)
    }

    // MARK: - The law of the mix (§1.2, S01–S04)

    func testCeilingsAndTheOmFloor() {
        XCTAssertEqual(MixLaw.clampEvent(0.2), 0.075)
        XCTAssertEqual(MixLaw.clampBinaural(0.10), 0.050)
        XCTAssertEqual(MixLaw.clampBinaural(0), 0.003)
        XCTAssertEqual(MixLaw.limiterCeiling, 0.8913, accuracy: 0.0001)
        XCTAssertEqual(MixLaw.omLevel(depth: 0, swell: nil), 0.004, accuracy: 1e-12)
        XCTAssertEqual(MixLaw.omLevel(depth: 9, swell: nil), 0.030, accuracy: 1e-12)
        XCTAssertEqual(MixLaw.omLevel(depth: 9, swell: 0.001), 0.030, accuracy: 1e-12, "a swell never goes under the floor")
        XCTAssertEqual(MixLaw.omLevel(depth: 0, swell: 0.5), 0.20, accuracy: 1e-12)
        XCTAssertEqual(MixLaw.songGain, 0.8)
        XCTAssertEqual(MixLaw.defaultMasterVolume, 0.8)
    }

    /// Layers add; an accent ducks WORLD and HER to 0.6; the Om is never ducked.
    func testBusGainsSumAndDuckButNeverTheOm() {
        let g = MixLaw.busGains(scene: [.world, .her, .accent], duck: 1)
        XCTAssertEqual(g[.floor], 1, "the Om is never ducked and stands in every scene")
        XCTAssertEqual(g[.world] ?? 0, 0.6, accuracy: 1e-12)
        XCTAssertEqual(g[.her] ?? 0, 0.6, accuracy: 1e-12)
        XCTAssertEqual(g[.accent], 1)
        XCTAssertEqual(g[.binaural], 0, "not in this scene")
        let calm = MixLaw.busGains(scene: [.world, .her, .binaural], duck: 0)
        XCTAssertEqual(calm[.world], 1)
        XCTAssertEqual(calm[.her], 1)
        XCTAssertEqual(calm[.binaural], 1, "beds and binaural add; nothing zeroes another")
    }

    /// The conductor's shape: every claimed bed sounds (the old arbiter zeroed
    /// all but one), and the Om stays at its floor under them.
    func testConductorBridgeSumsBeds() {
        let summed = MixLaw.conductorGains(beds: [.field, .room], accenting: false)
        XCTAssertEqual(summed[.field], 1)
        XCTAssertEqual(summed[.room], 1)
        XCTAssertEqual(summed[.om], 1)
        XCTAssertEqual(summed[.play], 0)
        let ducked = MixLaw.conductorGains(beds: [.field], accenting: true)
        XCTAssertEqual(ducked[.field], 0.6)
        XCTAssertEqual(ducked[.om], 1, "the Om is never ducked below its floor")
        // What it replaces: one bed at a time.
        let old = SoundArbiter.gains(beds: [.field, .room], accenting: false)
        XCTAssertEqual(old[.field], 0)
    }

    /// S02, C-1350: one song at a time; the same one pressed twice stops it.
    func testOneSongAtATime() {
        var slot = SongSlot()
        guard case let .start(first, stopping: nothing) = slot.press("bindu/cross.mp3") else { return XCTFail() }
        XCTAssertNil(nothing)
        guard case let .start(second, stopping: old) = slot.press("bindu/kingdom.mp3") else { return XCTFail() }
        XCTAssertEqual(old, first, "starting a song stops the other")
        XCTAssertNotEqual(second.id, first.id)
        XCTAssertEqual(slot.press("bindu/kingdom.mp3"), .stop(second), "the same source twice stops the first")
        XCTAssertNil(slot.current)
        XCTAssertNil(slot.stop())
        _ = slot.press("bindu/play.mp3")
        slot.finished(999)
        XCTAssertNotNil(slot.current, "a superseded session's end changes nothing")
    }

    /// S03: ambient by default; playback only while he pressed play; record only while listening.
    func testOneSessionNeed() {
        XCTAssertEqual(SoundSessionNeed.need(songPressed: false, listening: false), .ambient)
        XCTAssertEqual(SoundSessionNeed.need(songPressed: true, listening: false), .playback)
        XCTAssertEqual(SoundSessionNeed.need(songPressed: true, listening: true), .listening)
        XCTAssertEqual(SoundSessionNeed.need(songPressed: false, listening: true), .listening)
    }

    /// S80: Mono Audio, or the speaker under Auto, makes the binaural a pulse.
    func testBinauralRendering() {
        XCTAssertEqual(MixLaw.binauralRendering(mode: .auto, monoAudio: false, headphones: true), .stereo)
        XCTAssertEqual(MixLaw.binauralRendering(mode: .auto, monoAudio: false, headphones: false), .pulse)
        XCTAssertEqual(MixLaw.binauralRendering(mode: .auto, monoAudio: true, headphones: true), .pulse)
        XCTAssertEqual(MixLaw.binauralRendering(mode: .always, monoAudio: false, headphones: false), .stereo)
        XCTAssertEqual(MixLaw.binauralRendering(mode: .always, monoAudio: true, headphones: true), .pulse)
        XCTAssertEqual(MixLaw.binauralRendering(mode: .off, monoAudio: false, headphones: true), .off)
    }

    // MARK: - Mute and volume (S06)

    private func freshDefaults() -> UserDefaults {
        let name = "U1SoundTests.\(UUID().uuidString)"
        let d = UserDefaults(suiteName: name)!
        d.removePersistentDomain(forName: name)
        return d
    }

    func testSettingsDefaultOnAndMigrateLrSound() {
        let d = freshDefaults()
        let s = SoundSettings(defaults: d)
        XCTAssertTrue(s.masterOn, "BC-09: sound is on by default")
        XCTAssertEqual(s.masterVolume, 0.8)
        XCTAssertEqual(s.binauralMode, .auto)
        XCTAssertEqual(s.layerGain(.world), 1)
        s.toggleMute()
        XCTAssertFalse(SoundSettings(defaults: d).masterOn, "the mute is kept")
        XCTAssertEqual(SoundSettings(defaults: d).effectiveMaster, 0)

        let old = freshDefaults()
        old.set(false, forKey: "lr_sound")
        XCTAssertFalse(SoundSettings(defaults: old).masterOn, "lr_sound migrates into sound.master.on")
        XCTAssertEqual(old.object(forKey: SoundSettings.Key.masterOn) as? Bool, false)

        s.setMasterVolume(3)
        XCTAssertEqual(s.masterVolume, 1)
        s.setLayer(.binaural, gain: 0.25)
        XCTAssertEqual(SoundSettings(defaults: d).layerGain(.binaural), 0.25)
    }

    // MARK: - His recordings (§1.9, S64)

    func testRecordingsCatalogue() {
        XCTAssertEqual(Recordings.all.count, 58)
        XCTAssertEqual(Set(Recordings.all.map { $0.path }).count, 58)
        XCTAssertEqual(Set(Recordings.all.map { $0.sha256 }).count, 40, "40 unique recordings")
        XCTAssertEqual(Recordings.unique.count, 40)
        XCTAssertFalse(Recordings.unique.contains { $0.path == "b/dream.mp3" }, "bindu/ is kept over its b/ twin")
        let hex = CharacterSet(charactersIn: "0123456789abcdef")
        for r in Recordings.all {
            XCTAssertEqual(r.sha256.count, 64, r.path)
            XCTAssertTrue(r.sha256.unicodeScalars.allSatisfy { hex.contains($0) }, r.path)
            XCTAssertEqual(r.gitBlob.count, 8, r.path)
            XCTAssertGreaterThan(r.bytes, 1_000_000, r.path)
        }
        // b/ duplicates bindu/ byte for byte.
        for r in Recordings.all where r.path.hasPrefix("b/") {
            if let twin = Recordings.recording("bindu/" + r.path.dropFirst(2)) {
                XCTAssertEqual(twin.sha256, r.sha256, r.path)
            }
        }
        // Every recording a door names is in the catalogue.
        var used = [Recordings.aatma, Recordings.mayaEnding, Recordings.kingdom, Recordings.cross,
                    Recordings.before, Recordings.lalitaDance] + Recordings.axisTriptych + Recordings.family
        used += (1...33).compactMap { Recordings.dance(room: $0) }
        used += Array(Tuning.songCarriers.keys)
        for path in used { XCTAssertNotNil(Recordings.recording(path), "\(path) is not on aistrangegame.com") }
        XCTAssertEqual(Recordings.remoteURL("bindu/kingdom.mp3").absoluteString, "https://aistrangegame.com/bindu/kingdom.mp3")
        XCTAssertEqual(Recordings.dance(room: 31), "tree-of-life/aatma.mp3")
        XCTAssertEqual(Recordings.lalitaDance, "bindu/play.mp3")
        XCTAssertNil(Recordings.dance(room: 12), "body rooms dance songless")
    }

    func testRecordingStoreVerifiesBytes() throws {
        XCTAssertEqual(RecordingStore.sha256Hex(Data()),
                       "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
        let kingdom = try XCTUnwrap(Recordings.recording(Recordings.kingdom))
        let wrong = Data("not his song".utf8)
        XCTAssertThrowsError(try RecordingStore.verify(wrong, against: kingdom)) { error in
            XCTAssertEqual(error as? RecordingStore.Failure,
                           .shaMismatch(expected: kingdom.sha256, got: RecordingStore.sha256Hex(wrong)))
        }
        let bytes = Data("a recording".utf8)
        let fake = Recording(path: "x.mp3", bytes: bytes.count, sha256: RecordingStore.sha256Hex(bytes), gitBlob: "00000000")
        XCTAssertNoThrow(try RecordingStore.verify(bytes, against: fake))
    }

    /// A verified file in the cache is played from there; nothing is fetched.
    func testRecordingStoreUsesTheCacheFirst() async throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent("U1Sound-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: root) }
        let store = RecordingStore(cacheRoot: root)
        let target = store.cacheURL(for: Recordings.kingdom)
        try FileManager.default.createDirectory(at: target.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("cached".utf8).write(to: target)
        let url = try await store.localURL(for: Recordings.kingdom)
        XCTAssertEqual(url.standardizedFileURL, target.standardizedFileURL)
        do {
            _ = try await store.localURL(for: "nowhere/none.mp3")
            XCTFail("an unknown path is refused")
        } catch let RecordingStore.Failure.unknown(path) {
            XCTAssertEqual(path, "nowhere/none.mp3")
        }
    }

    // MARK: - Rendered offline (S16, S01, S04, S57, S80, S22)

    /// The Om sounds at its floor (0.004 at Home) once woken, measured at 136.1 Hz.
    func testOmSoundsAtItsFloor() {
        let r = settled()
        r.post(.om(level: MixLaw.omLevel(depth: 0, swell: nil), tau: 0.05))
        _ = r.render(seconds: 1)
        let out = r.render(seconds: 2)
        let a = amplitude(out.left, Tuning.Om.root)
        XCTAssertEqual(a, 0.004, accuracy: 0.0004, "the Om's floor at 136.1 Hz")
        XCTAssertEqual(amplitude(out.left, Tuning.Om.octave), 0.004 * 0.30, accuracy: 0.0002)
        XCTAssertGreaterThanOrEqual(r.omLevel, 0.004)
    }

    /// An accent ducks the world's bed to 0.6 and lets it back over 0.9 s;
    /// the Om never goes under its floor while it rings.
    func testAccentDucksTheBedNeverTheOm() {
        let r = settled()
        r.post(.scene(WorldVoices.voice(for: .the33).buses))
        r.post(.om(level: 0.004, tau: 0.05))
        r.post(.bed(BedSpec.make(WorldVoices.voice(for: .the33).bed)))
        _ = r.render(seconds: 3)
        XCTAssertEqual(r.bedGain, WorldVoices.bedLevel, accuracy: 0.0005, "the bed stands at 0.028")
        r.post(.accent(.bell(ring: 3)))
        _ = r.render(seconds: 0.5)
        XCTAssertGreaterThan(r.duck, 0.9)
        XCTAssertEqual(MixLaw.duckMultiplier(.world, depth: r.duck), 0.6, accuracy: 0.05)
        XCTAssertGreaterThanOrEqual(r.omLevel, 0.004, "the Om is never ducked")
        _ = r.render(seconds: 3)
        XCTAssertLessThan(r.duck, 0.05, "the bed comes back")
    }

    /// Whatever is asked of it, nothing leaves above −1 dBFS — and the test
    /// proves the ceiling acted (the unlimited sum went over it).
    func testCeilingHolds() {
        let r = settled()
        r.post(.om(level: 0.2, tau: 0.01))
        r.post(.binaural(BinauralSpec(carrier: 136.1, beat: 4, gain: 0.05, rendering: .stereo)))
        for _ in 0..<MixRenderer.accentVoices { r.post(.accent(.bell(ring: 9))) }
        let out = r.render(seconds: 0.5)
        XCTAssertGreaterThan(r.unlimitedPeak, MixLaw.limiterCeiling, "the planted overload went past the ceiling")
        XCTAssertLessThanOrEqual(peak(out.left), MixLaw.limiterCeiling + 1e-6)
        XCTAssertLessThanOrEqual(peak(out.right), MixLaw.limiterCeiling + 1e-6)
    }

    /// Every accent voice's gain is at most 0.075, measured: one bell alone.
    func testOneBellStaysUnderTheEventCeiling() {
        let r = settled()
        r.post(.accent(.bell(ring: 1)))
        let out = r.render(seconds: Tuning.BellVoice.duration + 0.1)
        let partialSum = Tuning.BellVoice.partials.map { $0.gain }.reduce(0, +)
        XCTAssertLessThanOrEqual(peak(out.left), MixLaw.eventCeiling * partialSum + 1e-6)
        XCTAssertGreaterThan(amplitude(Array(out.left.prefix(22_050)), Tuning.bell(ring: 1)), 0.005, "the bell sounds at bell(1)")
        XCTAssertEqual(r.activeAccents, 0, "it has ended by 1.7 s")
    }

    /// S57: the binaural is true L/R — carrier left, carrier + beat right —
    /// inside 0.003–0.050.
    func testBinauralIsTrueLeftRight() {
        let r = settled()
        r.post(.binaural(BinauralSpec(carrier: 136.1, beat: 0.5, gain: 0.04, rendering: .stereo)))
        _ = r.render(seconds: 6)
        let out = r.render(seconds: 4)     // 4 s: 136.1 and 136.6 are exactly two bins apart
        XCTAssertEqual(amplitude(out.left, 136.1), 0.04, accuracy: 0.004)
        XCTAssertEqual(amplitude(out.right, 136.6), 0.04, accuracy: 0.004)
        XCTAssertLessThan(amplitude(out.left, 136.6), 0.004)
        XCTAssertLessThan(amplitude(out.right, 136.1), 0.004)
        r.post(.binaural(BinauralSpec(carrier: 136.1, beat: 0.5, gain: 0.5, rendering: .stereo)))
        _ = r.render(seconds: 6)
        XCTAssertLessThanOrEqual(r.binauralGain, MixLaw.binauralRange.upperBound + 1e-9, "0.10 is too loud on headphones")
    }

    /// S80: under Mono Audio it is one pulse on both ears, AM at the beat.
    func testMonoAudioMakesAPulse() {
        let r = settled()
        r.post(.binaural(BinauralSpec(carrier: 136.1, beat: 4, gain: 0.04, rendering: .pulse)))
        _ = r.render(seconds: 6)
        let out = r.render(seconds: 1)
        XCTAssertEqual(out.left, out.right, "both ears hear the same pulse")
        let window = 1296      // four whole periods of 136.1 Hz (~29 ms)
        let rms: [Double] = stride(from: 0, to: out.left.count - window, by: window).map { s in
            let w = out.left[s..<(s + window)]
            return (w.map { Double($0) * Double($0) }.reduce(0, +) / Double(window)).squareRoot()
        }
        let hi = rms.max() ?? 0, lo = rms.min() ?? 0
        XCTAssertGreaterThan(hi / max(lo, 1e-9), 1.6, "the pulse breathes at the beat")
    }

    /// S22: a new bed crosses in over 2.6 s; the outgoing one is gone by 2.9 s.
    func testBedsCrossfadeAndTheOutgoingStops() {
        let r = settled()
        r.post(.bed(BedSpec.make(WorldVoices.voice(for: .the33).bed)))
        _ = r.render(seconds: 3)
        r.post(.bed(BedSpec.make(WorldVoices.voice(for: .game).bed)))
        _ = r.render(seconds: 1.3)
        XCTAssertEqual(r.outgoingCount, 1, "both sound during the crossing")
        XCTAssertEqual(r.bedGain, WorldVoices.bedLevel * WorldVoices.equalPower(t: 1.3).incoming, accuracy: 0.001)
        _ = r.render(seconds: 1.7)
        XCTAssertEqual(r.outgoingCount, 0, "the outgoing bed is stopped at 2.9 s")
        XCTAssertEqual(r.bedGain, WorldVoices.bedLevel, accuracy: 0.0005)
    }

    /// Only master mute silences the Om.
    func testMuteSilencesEvenTheOm() {
        let r = settled()
        r.post(.om(level: 0.03, tau: 0.05))
        _ = r.render(seconds: 1)
        r.post(.master(0))
        _ = r.render(seconds: 4)
        let out = r.render(seconds: 0.5)
        XCTAssertLessThan(peak(out.left), 0.0001)
        XCTAssertGreaterThan(r.omLevel, 0.02, "muting is the master's; the Om itself is not stopped")
    }

    // MARK: - The mixer, offline (S05, S09, S48)

    func testMixerWakesEntersAndSoundsARoom() {
        let mixer = SoundMixer(settings: SoundSettings(defaults: freshDefaults()))
        mixer.enter(.the33)
        _ = mixer.renderer.render(seconds: 0.5)
        XCTAssertEqual(mixer.renderer.activeAccents, 0, "nothing sounds before the first touch")
        XCTAssertEqual(mixer.renderer.master, 0)
        mixer.wakeOnFirstTouch()
        mixer.enter(.the33)
        _ = mixer.renderer.render(seconds: 0.5)
        XCTAssertGreaterThanOrEqual(mixer.renderer.activeAccents, 1, "the threshold tone sounds on entry")
        _ = mixer.renderer.render(seconds: 3)
        XCTAssertEqual(mixer.renderer.bedGain, WorldVoices.bedLevel, accuracy: 0.0005)

        mixer.enterRoom(2)
        _ = mixer.renderer.render(seconds: 5)
        XCTAssertEqual(mixer.renderer.herGain, RoomTones.practiceGain, accuracy: 0.0005, "Muladhara's 174 at .012")
        XCTAssertEqual(mixer.renderer.master, MixLaw.defaultMasterVolume, accuracy: 0.01)
        XCTAssertGreaterThanOrEqual(mixer.renderer.omLevel, MixLaw.omFloor(depth: 0) * 0.95,
                                    "the Om rose to its floor on the first touch")
        mixer.enterRoom(32)
        _ = mixer.renderer.render(seconds: 5)
        XCTAssertLessThan(mixer.renderer.herGain, 0.0005, "room 32 is sealed: no tone")

        mixer.toggleMute()
        _ = mixer.renderer.render(seconds: 4)
        XCTAssertLessThan(mixer.renderer.master, 0.001)
        mixer.toggleMute()
    }
}
