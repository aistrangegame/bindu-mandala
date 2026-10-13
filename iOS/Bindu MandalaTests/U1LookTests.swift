import XCTest
import SwiftUI
@testable import Bindu_Mandala

// MARK: - U1 · Part C · Look — the tests
//
// `waves/upgrade/briefs/U1-instruments.md` Part C §7: token values against
// `visual.md`; contrast ratios computed; palette determinism for all 102.
//
// Where Design has the number in its own files it is **read off disk** through
// the U0 `DesignCorpus` helper (a missing file is a failure, never a skip):
// the house tokens (`DESIGN_SPEC.md`), the ring and cluster seeds, the four
// hours and the jitter / composition formulas (`living-rite-core.jsx`), the
// Mandala's sky (`living-rite-mandala.jsx`), the home petals' and the nine
// enclosures' periods (`Home Mandala.html`, `Mandala App v2.html`,
// `home-mandala.jsx`). Where the number exists only in the world file (the
// studio-language tokens come from rupakarshini, which is not in the corpus;
// the ring table's oklab columns were computed in the upgrade session; the
// settled new-moon row), it is typed here from `visual.md` with its section.
//
// **Every check is born red.** Each comparison runs through a small checker
// that returns its failures, and each test also runs that checker on a
// planted defect and asserts it complains — so a checker that silently passes
// everything fails its own test.

final class U1LookTests: XCTestCase {

    // MARK: - Helpers

    private func groups(_ pattern: String, in text: String) -> [[String]] {
        guard let re = try? NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines]) else {
            XCTFail("bad pattern \(pattern)"); return []
        }
        let ns = text as NSString
        return re.matches(in: text, range: NSRange(location: 0, length: ns.length)).map { m in
            (0..<m.numberOfRanges).map { i in
                let r = m.range(at: i)
                return r.location == NSNotFound ? "" : ns.substring(with: r)
            }
        }
    }

    private func block(_ text: String, from start: String, to end: String = "};") -> String {
        guard let a = text.range(of: start), let b = text.range(of: end, range: a.upperBound..<text.endIndex) else {
            XCTFail("block \(start) not found in Design source"); return ""
        }
        return String(text[a.upperBound..<b.lowerBound])
    }

    private func hexEq(_ a: LookColor, _ b: String) -> Bool { a.hex == LookColor(hex: b).hex }

    // MARK: - 1 · House tokens against Design's spec

    /// `DESIGN_SPEC.md` names → `HouseTokens`.
    private let specMap: [String: LookColor] = [
        "groundColor": HouseTokens.ground, "surfaceColor": HouseTokens.surface,
        "darkVeil": HouseTokens.veil, "silenceGround": HouseTokens.silence,
        "goldColor": HouseTokens.gold, "goldDeep": HouseTokens.goldDeep,
        "creamColor": HouseTokens.cream, "accentRed": HouseTokens.crimson,
        "innerInstrument": HouseTokens.goldBright,
    ]

    private func houseFailures(spec: String, tokens: [String: LookColor]) -> [String] {
        var found: [String: String] = [:]
        for g in groups(#"^\s*(\w+)\s*=\s*(#[0-9A-Fa-f]{6})"#, in: spec) { found[g[1]] = g[2] }
        var out: [String] = []
        for (name, token) in tokens {
            guard let hex = found[name] else { out.append("\(name) missing from DESIGN_SPEC.md"); continue }
            if !hexEq(token, hex) { out.append("\(name): Look \(token.hex) ≠ Design \(hex)") }
        }
        return out
    }

    func testHouseTokensAreDesignSpecs() throws {
        let spec = try DesignCorpus.text("DESIGN_SPEC.md")
        XCTAssertEqual(houseFailures(spec: spec, tokens: specMap), [])
        // §2 #4: the three the spec does not carry, typed from visual.md.
        XCTAssertEqual(HouseTokens.ink2.hex, "#968D85")
        XCTAssertEqual(HouseTokens.crimsonLit.hex, "#A4343E")
        XCTAssertEqual(HouseTokens.goldWarm.hex, "#CF9443")
        XCTAssertEqual(HouseTokens.ember.hex, "#C0392B")
        // Born red: a planted wrong ground is caught.
        var planted = specMap
        planted["groundColor"] = LookColor(hex: "#0D0509")
        XCTAssertFalse(houseFailures(spec: spec, tokens: planted).isEmpty)
    }

    // MARK: - 2 · The Mandala's sky (living-rite-mandala.jsx)

    func testMandalaSkyIsDesignsIndigoWell() throws {
        let jsx = try DesignCorpus.text("living-rite-mandala.jsx")
        let g = groups(#"radial-gradient\(circle at 50% 44%, (#[0-9a-fA-F]{6}), (#[0-9a-fA-F]{6}) 60%, (#[0-9a-fA-F]{6})\)"#, in: jsx)
        let first = try XCTUnwrap(g.first, "the indigo well is not in living-rite-mandala.jsx")
        let m = WorldStyle.mandala.colours
        XCTAssertTrue(hexEq(m.ground, first[1]), "centre \(m.ground.hex) vs \(first[1])")
        XCTAssertTrue(hexEq(try XCTUnwrap(m.named["skyMid"]), first[2]))
        XCTAssertTrue(hexEq(try XCTUnwrap(m.groundRim), first[3]))
        XCTAssertFalse(hexEq(HouseTokens.ground, first[1]), "born red: the house ground is not the well")
    }

    // MARK: - 3 · Seeds, jitter, composition (living-rite-core.jsx)

    private func seedTable(_ text: String) -> [String: HSL] {
        var out: [String: HSL] = [:]
        for g in groups(#"(\w+):\s*\{\s*h:\s*(\d+),\s*s:\s*(\d+),\s*l:\s*(\d+)\s*\}"#, in: text) {
            out[g[1]] = HSL(h: Double(g[2])!, s: Double(g[3])!, l: Double(g[4])!)
        }
        return out
    }

    private func seedFailures(rings: [String: HSL], clusters: [String: HSL]) -> [String] {
        var out: [String] = []
        // Ring n's first kp (ring 2 by cluster below).
        let firstKp = [1: 1, 3: 45, 4: 53, 5: 67, 6: 77, 7: 87, 8: 99, 9: 102]
        for (ring, kp) in firstKp {
            guard let d = rings[String(ring)] else { out.append("ring \(ring) missing"); continue }
            if ShaktiPalette.seed(kp: kp) != d { out.append("ring \(ring) seed \(ShaktiPalette.seed(kp: kp)) ≠ \(d)") }
        }
        // Ring 2 clusters — the data spells `self`; the Swift enum is `selfBody`.
        let clusterKp = ["inner": 29, "tanmatra": 32, "citta": 37, "stability": 38, "self": 42]
        for (name, kp) in clusterKp {
            guard let d = clusters[name] else { out.append("cluster \(name) missing"); continue }
            if ShaktiPalette.seed(kp: kp) != d { out.append("cluster \(name) seed ≠ \(d)") }
        }
        return out
    }

    func testSeedsAreDesignsRingAndClusterHues() throws {
        let core = try DesignCorpus.text("living-rite-core.jsx")
        let rings = seedTable(block(core, from: "const LR_RING_HUES = {"))
        let clusters = seedTable(block(core, from: "const LR_CLUSTER_HUES = {"))
        XCTAssertEqual(rings.count, 8)
        XCTAssertEqual(clusters.count, 5)
        XCTAssertEqual(seedFailures(rings: rings, clusters: clusters), [])
        var planted = rings
        planted["6"] = HSL(h: 195, s: 42, l: 46)
        XCTAssertFalse(seedFailures(rings: planted, clusters: clusters).isEmpty)
    }

    /// The formulas, Design's own text, and an independent evaluation of them.
    func testJitterAndCompositionAreDesignsFormulas() throws {
        let core = try DesignCorpus.text("living-rite-core.jsx")
        XCTAssertTrue(core.contains("function lrJitter(kp, range) { return ((kp * 2654435761 % 1000) / 1000 - 0.5) * range; }"))
        XCTAssertTrue(core.contains("const m = (s.kp * 2654435761) >>> 0;"))
        XCTAssertTrue(core.contains("sigilScale: 0.86 + ((m >> 3) & 7) / 7 * 0.4"))
        XCTAssertTrue(core.contains("nameTier: (m >> 6) & 3"))

        func designFrac(_ kp: Int) -> Double { Double((kp * 2654435761) % 1000) / 1000 }
        func plantedFrac(_ kp: Int) -> Double { Double((kp * 2654435769) % 1000) / 1000 }
        var mismatches = 0, plantedMismatches = 0
        for kp in 1...102 {
            if abs(ShaktiPalette.frac(kp: kp) - designFrac(kp)) > 1e-12 { mismatches += 1 }
            if abs(ShaktiPalette.frac(kp: kp) - plantedFrac(kp)) > 1e-12 { plantedMismatches += 1 }
            let m = UInt32(truncatingIfNeeded: Int64(kp) * 2654435761)
            let c = ShaktiPalette.composition(kp: kp)
            XCTAssertEqual(c.flip, (m & 1) == 1)
            XCTAssertEqual(c.spin, (m & 2) != 0 ? 1 : -1)
            XCTAssertEqual(c.sigilScale, 0.86 + Double((m >> 3) & 7) / 7 * 0.4, accuracy: 1e-12)
            XCTAssertEqual(c.nameTier, Int((m >> 6) & 3))
            XCTAssertTrue((0.86...1.26).contains(c.sigilScale))
            XCTAssertEqual(ShaktiPalette.jitter(kp: kp, 14), Atmosphere.jitter(kp, 14), accuracy: 1e-12)
        }
        XCTAssertEqual(mismatches, 0)
        XCTAssertGreaterThan(plantedMismatches, 0, "born red: a wrong multiplier is noticed")
    }

    // MARK: - 4 · Relit by the hour (§1.5.3)

    private func relightFailures(_ text: String) -> [String] {
        var out: [String] = []
        let pattern = #"(dawn|noon|dusk|night):\s*\{[^}]*dh:\s*(-?[\d.]+),\s*lAdd:\s*(-?[\d.]+),\s*sMul:\s*([\d.]+),\s*glowMul:\s*([\d.]+),\s*tint:\s*'(#[0-9a-fA-F]{6})',\s*tintA:\s*([\d.]+),\s*moteMul:\s*([\d.]+)"#
        let rows = groups(pattern, in: text)
        if rows.count != 4 { out.append("expected 4 Design hours, found \(rows.count)") }
        for g in rows {
            guard let v = TimeVariant(rawValue: g[1]) else { out.append("hour \(g[1])"); continue }
            let r = Relight.of(v)
            let d = [g[2], g[3], g[4], g[5], g[7], g[8]].map { Double($0)! }
            if r.dh != d[0] || r.lAdd != d[1] || r.sMul != d[2] || r.glowMul != d[3] || r.tintA != d[4] || r.moteMul != d[5] {
                out.append("\(g[1]) numbers ≠ Design")
            }
            if !hexEq(LookColor(hex: r.tint), g[6]) { out.append("\(g[1]) tint ≠ Design") }
        }
        return out
    }

    func testRelightIsDesignsFourHoursAndTheSettledNewMoon() throws {
        let core = try DesignCorpus.text("living-rite-core.jsx")
        let table = block(core, from: "const LR_TIME_VARIANTS = {")
        XCTAssertEqual(relightFailures(table), [])
        XCTAssertFalse(relightFailures(table.replacingOccurrences(of: "dh: 8,", with: "dh: 9,")).isEmpty,
                       "born red: a moved dawn is noticed")
        // §1.5.3: the new-moon row Design never wrote, settled in the upgrade.
        XCTAssertEqual(Relight.of(.newmoon), Relight(dh: -7, lAdd: -12, sMul: 0.55, glowMul: 0.85,
                                                    tint: "#04030C", tintA: 0.18, moteMul: 0.5))
    }

    func testTheSettledWindowsAndTheNewMoon() {
        let expected: [TimeVariant] = [.night, .night, .night, .night, .night,
                                       .dawn, .dawn, .dawn, .dawn,
                                       .noon, .noon, .noon, .noon, .noon, .noon, .noon,
                                       .dusk, .dusk, .dusk, .dusk,
                                       .night, .night, .night, .night]
        XCTAssertEqual((0..<24).map { ShaktiPalette.timeVariant(hour: $0, lunarPhase: 0.5) }, expected)
        XCTAssertEqual(ShaktiPalette.timeVariant(hour: 23, lunarPhase: 0.02), .newmoon)
        XCTAssertEqual(ShaktiPalette.timeVariant(hour: 2, lunarPhase: 0.98), .newmoon)
        XCTAssertEqual(ShaktiPalette.timeVariant(hour: 2, lunarPhase: 0.03), .night, "the window is open, < .03")
        XCTAssertEqual(ShaktiPalette.timeVariant(hour: 12, lunarPhase: 0.0), .noon, "the new moon overrides night only")
        // moteMul is read (G1-0467).
        XCTAssertEqual(ShaktiPalette.motes(10, at: .night), 13)
        XCTAssertEqual(ShaktiPalette.motes(10, at: .noon), 7)
        XCTAssertEqual(ShaktiPalette.motes(10, at: .newmoon), 5)
        XCTAssertEqual(ShaktiPalette.motes(10, at: nil), 10)
        XCTAssertNotEqual(ShaktiPalette.motes(10, at: .dusk), 10, "born red: dusk's 1.15 changes the count")
    }

    // MARK: - 5 · Palette determinism for all 102

    func testPaletteIsDeterministicForAll102AtEveryHour() {
        let hours: [TimeVariant?] = [nil] + TimeVariant.allCases.map { Optional($0) }
        var previous: (ring: Int, hue: Double)? = nil
        for kp in 1...102 {
            let ring = ShaktiPalette.ring(kp: kp)
            XCTAssertTrue((1...9).contains(ring), "kp \(kp)")
            if ring == 2 { XCTAssertNotNil(ShaktiPalette.cluster(kp: kp)) } else { XCTAssertNil(ShaktiPalette.cluster(kp: kp), "kp \(kp): the 86 carry no cluster") }
            let seed = ShaktiPalette.seed(kp: kp)
            for v in hours {
                let a = ShaktiPalette.atmosphere(kp: kp, at: v)
                let b = ShaktiPalette.atmosphere(kp: kp, at: v)
                XCTAssertEqual(a, b, "kp \(kp) at \(String(describing: v)) not deterministic")
                XCTAssertEqual(ShaktiPalette.ground(a), ShaktiPalette.ground(b))
                XCTAssertEqual(ShaktiPalette.groundDeep(a), ShaktiPalette.groundDeep(b))
                let dh = v.map { Relight.of($0).dh } ?? 0
                let d = Luminance.hueDistance(a.hue.h, HSL.wrap(seed.h + dh))
                XCTAssertLessThanOrEqual(d, 7.0001, "kp \(kp): jitter is ±7°")
                XCTAssertTrue((6...90).contains(a.hue.s) || v == nil)
                XCTAssertTrue((8...82).contains(a.hue.l) || v == nil)
                XCTAssertEqual(a.timeKey, v)
            }
            // With no hour it is Atmosphere's own derivation, exactly.
            XCTAssertEqual(ShaktiPalette.atmosphere(kp: kp),
                           Atmosphere.derive(ring: ring, cluster: ShaktiPalette.cluster(kp: kp), khadgamala: kp,
                                             element: ShaktiPalette.element(kp: kp)))
            // Position is identity: neighbours in a ring never share a hue.
            let h = ShaktiPalette.atmosphere(kp: kp).hue.h
            if let p = previous, p.ring == ring { XCTAssertNotEqual(p.hue, h, "kp \(kp - 1) and \(kp) share a hue") }
            previous = (ring, h)
        }
    }

    func testRuling4ElementsAndEtherAt280() {
        XCTAssertEqual(ShaktiPalette.element(kp: 31), .fire)
        XCTAssertEqual(ShaktiPalette.element(kp: 40), .air)
        XCTAssertEqual(ShaktiPalette.element(kp: 42), .light)
        XCTAssertEqual(ShaktiPalette.element(kp: 43), .water)
        XCTAssertEqual(ShaktiPalette.element(kp: 1), .earth)
        XCTAssertEqual(ShaktiPalette.element(kp: 80), .ether)
        XCTAssertEqual(ShaktiPalette.element(kp: 102), .light)
        // §1.5.4 table: archetype, backdrop breath, tint hex.
        let expected: [(Element, String, Double, String)] = [
            (.fire, "ascension", 11, "#DAA681"), (.water, "descent", 13, "#81ADDA"),
            (.air, "horizon", 12, "#81C4DA"), (.ether, "veil", 9.6, "#BC81DA"),
            (.earth, "foundation", 15, "#DA9781"), (.light, "radiance", 7.6, "#DACB81"),
        ]
        for (e, arch, breath, tint) in expected {
            let l = ElementLayout.of(e)
            XCTAssertEqual(l.archetype, arch)
            XCTAssertEqual(l.backdropBreath, breath)
            XCTAssertEqual(LookColor(l.tint).hex, tint, "\(e)")
        }
        XCTAssertEqual(ElementLayout.of(.ether).tintHue, 280)
        XCTAssertNotEqual(LookColor(HSL(h: 265, s: 55, l: 68)).hex, "#BC81DA", "born red: soul 265 is not ether")
        // In a Mandala world the element never sets hue: ring 6 stays teal.
        XCTAssertEqual(ShaktiPalette.seed(kp: 80).h, 194)
    }

    // MARK: - 6 · The nine rings (§1.4.4) — the oklab columns

    private struct RingRow { let hex, wash, deep, text, fog: String; let density, veil, tempo, breath, chrome: Double }

    private let ringTable: [RingRow] = [
        RingRow(hex: "#CE9546", wash: "#2D1C15", deep: "#190D0D", text: "#CE9546", fog: "#1D1206", density: 0.0125, veil: 0.00, tempo: 1.00, breath: 0, chrome: 1.00),
        RingRow(hex: "#D4A017", wash: "#2E1E12", deep: "#1A0E0B", text: "#D4A017", fog: "#0A1330", density: 0.017, veil: 0.12, tempo: 0.82, breath: 3.5, chrome: 0.80),
        RingRow(hex: "#C46482", wash: "#2C141D", deep: "#190810", text: "#C56583", fog: "#2A0C06", density: 0.021, veil: 0.24, tempo: 0.62, breath: 8, chrome: 0.80),
        RingRow(hex: "#BE3747", wash: "#2B0E14", deep: "#18050B", text: "#CC5D61", fog: "#0B1219", density: 0.014, veil: 0.36, tempo: 0.72, breath: 9, chrome: 0.60),
        RingRow(hex: "#D37045", wash: "#2E1614", deep: "#1A090C", text: "#D37045", fog: "#06180E", density: 0.018, veil: 0.48, tempo: 0.66, breath: 11, chrome: 0.60),
        RingRow(hex: "#4490A7", wash: "#1B1C22", deep: "#100C13", text: "#4490A7", fog: "#1A0409", density: 0.022, veil: 0.60, tempo: 0.50, breath: 13, chrome: 0.25),
        RingRow(hex: "#B04F8C", wash: "#29111E", deep: "#170711", text: "#BB6597", fog: "#D8D2C4", density: 0.034, veil: 0.72, tempo: 0.44, breath: 15, chrome: 0.25),
        RingRow(hex: "#D62F29", wash: "#2F0E10", deep: "#1A060A", text: "#DE5244", fog: "#0F0B04", density: 0.015, veil: 0.86, tempo: 0.36, breath: 18, chrome: 0.25),
        RingRow(hex: "#E7CA6A", wash: "#31241B", deep: "#1C1110", text: "#E7CA6A", fog: "#141008", density: 0.009, veil: 1.00, tempo: 0.28, breath: 4, chrome: 0.00),
    ]

    private func ringFailures(_ table: [RingRow]) -> [String] {
        var out: [String] = []
        for (i, row) in table.enumerated() {
            let r = RingLook.of(i + 1)
            let n = i + 1
            if r.hex.hex != row.hex { out.append("ring \(n) hex \(r.hex.hex) ≠ \(row.hex)") }
            if r.wash.hex != row.wash { out.append("ring \(n) wash \(r.wash.hex) ≠ \(row.wash)") }
            if r.deep.hex != row.deep { out.append("ring \(n) deep \(r.deep.hex) ≠ \(row.deep)") }
            if r.text.hex != row.text { out.append("ring \(n) text \(r.text.hex) ≠ \(row.text)") }
            if Contrast.ratio(r.text, on: r.wash) < 4.5 { out.append("ring \(n) text under 4.5 : 1") }
            if r.fog.hex != row.fog { out.append("ring \(n) fog") }
            if r.fogDensity != row.density || r.veil != row.veil || r.tempo != row.tempo { out.append("ring \(n) weather") }
            if r.breath != row.breath { out.append("ring \(n) breath \(r.breath) ≠ \(row.breath)") }
            if r.chrome.chromeOpacity != row.chrome { out.append("ring \(n) chrome") }
        }
        return out
    }

    func testTheNineRingsWashDeepAndLegibleText() {
        XCTAssertEqual(ringFailures(ringTable), [])
        var planted = ringTable
        planted[2] = RingRow(hex: "#C46482", wash: "#2C141D", deep: "#190810", text: "#C46482", fog: "#2A0C06",
                             density: 0.021, veil: 0.24, tempo: 0.62, breath: 8, chrome: 0.80)
        XCTAssertFalse(ringFailures(planted).isEmpty, "born red: rose unlifted (4.48 : 1) is caught")
        // The raw rose really is below the floor on its wash — the lift is needed.
        XCTAssertLessThan(Contrast.ratio(LookColor(hex: "#C46482"), on: LookColor(hex: "#2C141D")), 4.5)
    }

    // MARK: - 7 · Depth: colour and chrome (§1.8, §1.9)

    func testThePointWarmsGoldToEmber() {
        let stops: [(Double, String)] = [(0, "#C9963F"), (0.25, "#C9813A"), (0.5, "#C76B35"), (0.75, "#C45430"), (1, "#C0392B")]
        for (d, hex) in stops { XCTAssertEqual(DepthColour.point(depth: d).hex, hex, "depth \(d)") }
        XCTAssertNotEqual(OKLab.mix(DepthColour.gold, DepthColour.ember, 0.5).hex,
                          LookColor(r: (0xC9 + 0xC0) / 2 / 255, g: (0x96 + 0x39) / 2 / 255, b: (0x3F + 0x2B) / 2 / 255).hex,
                          "born red: an sRGB mix is not the oklab mix")
        XCTAssertEqual(PointLook.forWorld(.today).core.hex, "#C9813A")
        XCTAssertEqual(PointLook.forWorld(.home).core.hex, "#C0392B")
        XCTAssertEqual(PointLook.forWorld(.home).halo?.hex, "#8B1A2A")
    }

    func testChromeThinsWithDepth() {
        XCTAssertEqual(ChromeStep.allCases.map(\.chromeOpacity), [1.0, 0.8, 0.6, 0.25, 0.0])
        let expected: [WorldID: Double] = [
            .home: 0, .today: 0.8, .mandala: 1, .rings: 1, .herHome: 0.25, .herPresence: 0.6,
            .climb: 0.8, .the33: 0.8, .game: 1, .modes: 1, .time: 1, .memory: 1, .well: 0.25,
            .beneath: 0, .relationship: 1,
        ]
        for w in WorldID.allCases { XCTAssertEqual(ChromeStep.atRest(w).chromeOpacity, expected[w], "\(w)") }
        XCTAssertEqual((1...9).map { ChromeStep.ring($0).chromeOpacity }, [1, 0.8, 0.8, 0.6, 0.6, 0.25, 0.25, 0.25, 0])
        XCTAssertEqual([1, 3, 4, 6, 7, 8, 9].map { ChromeStep.climb(band: $0).chromeOpacity }, [0.8, 0.8, 0.6, 0.6, 0.25, 0.25, 0])
        XCTAssertFalse(ChromeStep.centre.showsLabels)
        XCTAssertTrue(ChromeStep.surface.showsLabels)
        XCTAssertEqual(ChromeStep.wakeSeconds, 4)
        XCTAssertNotEqual(ChromeStep.atRest(.home), ChromeStep.atRest(.game), "born red: the table is not flat")
    }

    // MARK: - 8 · Breath (§1.6) against Design's CSS

    private func cssPeriod(_ text: String, _ selectorOrName: String) -> Double? {
        let escaped = NSRegularExpression.escapedPattern(for: selectorOrName)
        let byClass = groups(escaped + #"\s*\{\s*animation:\s*\w+\s+([\d.]+)s"#, in: text)
        if let g = byClass.first { return Double(g[1]) }
        let byName = groups(#"animation:\s*"# + escaped + #"\s+([\d.]+)s"#, in: text)
        return byName.first.flatMap { Double($0[1]) }
    }

    private func breathFailures(home: String, v2: String) -> [String] {
        var out: [String] = []
        let petals: [(String, BreathEnclosure.Relationship)] = [
            (".home-petal-today", .today), (".home-petal-embodied", .embodied), (".home-petal-active", .active),
            (".home-petal-exploring", .exploring), (".home-petal-mapped", .mapped),
        ]
        for (sel, r) in petals {
            guard let p = cssPeriod(home, sel) else { out.append("\(sel) not in Home Mandala.html"); continue }
            if BreathEnclosure.homePetal(r) != p { out.append("\(sel) \(BreathEnclosure.homePetal(r)) ≠ \(p)") }
        }
        if cssPeriod(home, ".home-petal-today") != BreathEnclosure.petals16.period { out.append("today's petal is the ring's period") }
        if cssPeriod(home, ".home-r3-petal") != BreathEnclosure.petals8.period { out.append("ring 3") }
        let inner: [(String, BreathEnclosure)] = [
            ("lockR4", .triangles14), ("lockR5", .outerTen), ("lockR6", .innerTen), ("lockR7", .triangles8),
            ("deepGhostTri", .primary), ("mandalaBinduBreathe", .bindu),
        ]
        for (name, e) in inner {
            guard let p = cssPeriod(v2, name) else { out.append("\(name) not in Mandala App v2.html"); continue }
            if e.period != p { out.append("\(name) \(e.period) ≠ \(p)") }
        }
        return out
    }

    func testEnclosureBreathIsDesignsUnsnapped() throws {
        let home = try DesignCorpus.text("Home Mandala.html")
        let v2 = try DesignCorpus.text("Mandala App v2.html")
        XCTAssertEqual(breathFailures(home: home, v2: v2), [])
        XCTAssertFalse(breathFailures(home: home.replacingOccurrences(of: "homeTodayBreathe 3.5s", with: "homeTodayBreathe 3s"),
                                      v2: v2).isEmpty, "born red: the old 3 s is caught")
        XCTAssertEqual(BreathEnclosure.bhupura.period, 0, "the earth underfoot does not breathe")
        XCTAssertTrue(try DesignCorpus.text("home-mandala.jsx").contains("(i * 0.18).toFixed(2)"))
        XCTAssertEqual(BreathEnclosure.petalStagger, 0.18)
        XCTAssertEqual(BreathEnclosure.downTriangles, [10, 12, 14, 16, 18])
    }

    func testTheOneClockNoLongerSnaps() {
        XCTAssertEqual(BreathClock.livePeriod(grammar: 9.3, score: nil), 9.3)
        XCTAssertEqual(BreathClock.livePeriod(grammar: 8, score: ShaktiScore.Tempo(breath: 3.5, rate: nil)), 3.5)
        XCTAssertEqual(BreathClock.livePeriod(grammar: 9, score: ShaktiScore.Tempo(breath: nil, rate: 0.8)), 11.25, accuracy: 1e-12)
        // Born red: the Wave 6 snap really would have moved these.
        XCTAssertNotEqual(BreathClock.period(grammar: 9.3, score: nil), 9.3)
        XCTAssertNotEqual(BreathClock.period(grammar: 8, score: ShaktiScore.Tempo(breath: 3.5, rate: nil)), 3.5)
        // One epoch: the same instant has the same phase however it is asked.
        let d = Date(timeIntervalSinceReferenceDate: 1_000_003.5)
        XCTAssertEqual(BreathClock.phase(at: d, period: 3.5),
                       BreathClock.phase(at: d.timeIntervalSinceReferenceDate, period: 3.5), accuracy: 1e-12)
        XCTAssertEqual(WorldBreath.period(.home), 4)
        XCTAssertEqual(WorldBreath.period(.time), 8, "Time is the only world that keeps 8 s")
        XCTAssertEqual(WorldBreath.glowPeriod, 12.5)
        XCTAssertEqual(WorldBreath.glowOpacity(at: Date(timeIntervalSinceReferenceDate: 12.5 / 2)), 0.07, accuracy: 1e-9)
    }

    // MARK: - 9 · Motion constants (§1.4)

    func testMotionCurvesAreTheWorldFiles() {
        let expected: [String: (Double, Double, Double, Double, Double)] = [
            "veilLight": (0.22, 0.61, 0.36, 1, 1.05), "veilLightBloom": (0.16, 1, 0.3, 1, 1.05),
            "veilDark": (0.5, 0, 0.15, 1, 1.5), "descent": (0.66, 0, 0.24, 1, 2.35),
            "waking": (0.22, 1, 0.3, 1, 2.85), "surfacing": (0.22, 0.61, 0.36, 1, 0.95),
            "sheetRise": (0.22, 1, 0.36, 1, 1.1), "verb": (0.16, 1, 0.3, 1, 0.6),
            "blinkLids": (0.62, 0.02, 0.4, 1, 0.66), "lightReach": (0.2, 0.7, 0.2, 1, 2.6),
            "nameFade": (0.25, 0.1, 0.25, 1, 1.6), "rkOut": (0.22, 0.61, 0.36, 1, 0.25),
            "soft": (0.4, 0, 0.2, 1, 0.5),
        ]
        func failures(_ curves: [MotionCurve]) -> [String] {
            var out: [String] = []
            for c in curves {
                guard let e = expected[c.name] else { out.append("\(c.name) unknown"); continue }
                if (c.c1x, c.c1y, c.c2x, c.c2y, c.duration) != e { out.append(c.name) }
            }
            if Set(curves.map(\.name)) != Set(expected.keys) { out.append("set differs") }
            return out
        }
        XCTAssertEqual(failures(LookMotion.all), [])
        XCTAssertFalse(failures(LookMotion.all.map { $0.name == "descent" ? $0.with(duration: 2.0) : $0 }).isEmpty)
        XCTAssertEqual(LookMotion.boardHop.duration, 0.55)
        XCTAssertEqual(LookMotion.verbWorld.duration, 1.1)
        XCTAssertEqual(LookPace.allCases.map(\.duration), [0.5, 0.25, 0.18])
        XCTAssertEqual(LookPace.allCases.map(\.rise), [16, 24, 32])
        XCTAssertEqual(LookSpace.scale, [4, 8, 12, 16, 24, 32, 48, 64, 96])
        XCTAssertEqual(LookMotion.typeSwapFraction, 0.45)
        XCTAssertEqual(LookMotion.veil(into: LookColor(hex: "#FAF6EE")), LookMotion.veilLight)
        XCTAssertEqual(LookMotion.veil(into: LookColor(hex: "#0D0508")), LookMotion.veilDark)
    }

    // MARK: - 10 · Every world: one language, legible ink, type floors

    func testEachWorldWearsItsLanguage() {
        let expected: [WorldID: StudioLanguage] = [
            .home: .mandala, .today: .feed, .mandala: .mandala, .rings: .mandala, .herHome: .mandala,
            .herPresence: .feed, .climb: .ascent, .the33: .chakra, .game: .leela, .modes: .field,
            .time: .mandala, .memory: .being, .well: .lalita, .beneath: .blink, .relationship: .lalita,
        ]
        for w in WorldID.allCases { XCTAssertEqual(WorldStyle.of(w).language, expected[w], "\(w)") }
        XCTAssertEqual(WorldStyle.of(.today).inner?.language, .linen)
        XCTAssertEqual(WorldStyle.of(.game).inner?.language, .play)
        XCTAssertEqual(WorldStyle.of(.modes).inner?.language, .candle)
        XCTAssertEqual(WorldStyle.of(.well).inner?.language, .learning)
        let used = Set(WorldStyle.all.flatMap(\.languages))
        XCTAssertEqual(used, Set(StudioLanguage.allCases), "all thirteen languages are worn")
        for s in WorldStyle.all { XCTAssertEqual(s.world, WorldID.allCases.first { WorldStyle.of($0) == s }) }
    }

    private func legibilityFailures(_ name: String, _ l: LanguageStyle) -> [String] {
        var out: [String] = []
        let c = l.colours
        let ink = Contrast.ratio(c.ink, on: c.ground)
        if ink < Contrast.bodyFloor { out.append(String(format: "%@ ink %.2f : 1", name, ink)) }
        if let rim = c.groundRim, Contrast.ratio(c.ink, on: rim) < Contrast.bodyFloor { out.append("\(name) ink on rim") }
        if let i2 = c.ink2, Contrast.ratio(i2, on: c.ground) < Contrast.bodyFloor { out.append("\(name) ink-2") }
        for t in [l.type.display, l.type.ui] + (l.type.voice.map { [$0] } ?? []) where t.size < 11 {
            out.append("\(name) type \(t.size) pt")
        }
        return out
    }

    func testEveryWorldsInkReadsOnItsGround() {
        var failures: [String] = []
        for s in WorldStyle.all {
            failures += legibilityFailures("\(s.world)", s.main)
            if let i = s.inner { failures += legibilityFailures("\(s.world)·inner", i) }
        }
        XCTAssertEqual(failures, [])
        // Born red: the old .3 α cream (2.31 : 1) is caught as text.
        let planted = LanguageStyle(language: .mandala,
                                    colours: WorldColours(ground: HouseTokens.ground, ink: HouseTokens.cream.opacity(0.3)),
                                    type: WorldStyle.home.type)
        XCTAssertFalse(legibilityFailures("planted", planted).isEmpty)
    }

    /// The ratios §1.4 / §1.14 state, recomputed.
    func testStatedContrastRatios() {
        let stated: [(String, Double, String, Double)] = [
            ("#F2E8D9", 1, "#040104", 17.13), ("#968D85", 1, "#0D0508", 6.18), ("#C9963F", 1, "#0D0508", 7.60),
            ("#EDE8E3", 1, "#0E0C12", 15.97), ("#25201A", 1, "#F6EFE2", 14.12),
            ("#3A2E15", 1, "#F4E9CF", 11.00), ("#B8322B", 1, "#F4E9CF", 4.93),
            ("#F0E8DC", 0.92, "#0C0A12", 13.67), ("#99948F", 1, "#0C0A12", 6.54), ("#F0E8DC", 0.5, "#0C0A12", 4.58),
            ("#1D2631", 1, "#E3E9EA", 12.45), ("#56616C", 1, "#E3E9EA", 5.15), ("#3FB8B4", 1, "#1B2230", 6.62),
            ("#F3ECDD", 1, "#0F4A50", 8.44), ("#F5E2D6", 1, "#020208", 16.49), ("#887D79", 1, "#020208", 5.18),
            ("#D46453", 1, "#020208", 5.66), ("#E8D9B8", 1, "#100A08", 14.08), ("#8E7D5F", 1, "#100A08", 4.91),
            ("#2E2A24", 1, "#FAF6EE", 13.23), ("#5A5349", 1, "#FAF6EE", 7.04), ("#5F7355", 1, "#FAF6EE", 4.79),
            ("#B9B2C9", 1, "#0E0C14", 9.50), ("#F3B05A", 1, "#0A0806", 10.63),
            ("#DBD5CC", 1, "#0A0A0C", 13.57), ("#807E79", 1, "#0A0A0C", 4.88),
            ("#ECE7DD", 1, "#1A1826", 14.17), ("#B6B0C2", 1, "#1A1826", 8.30),
            ("#F2E8D9", 0.5, "#0D0508", 4.55), ("#8B1A2A", 1, "#0D0508", 2.19), ("#A4343E", 1, "#0D0508", 3.01),
        ]
        func failures(_ rows: [(String, Double, String, Double)]) -> [String] {
            rows.compactMap { fg, a, bg, r in
                let got = Contrast.ratio(LookColor(hex: fg, alpha: a), on: LookColor(hex: bg))
                return abs(got - r) <= 0.015 ? nil : String(format: "%@ α%.2f on %@: %.2f ≠ %.2f", fg, a, bg, got, r)
            }
        }
        XCTAssertEqual(failures(stated), [])
        XCTAssertFalse(failures([("#F2E8D9", 0.3, "#0D0508", 4.55)]).isEmpty, "born red")
        // Crimson is graphic only — never text.
        XCTAssertLessThan(Contrast.ratio(HouseTokens.crimson, on: HouseTokens.ground), Contrast.bodyFloor)
        XCTAssertGreaterThanOrEqual(Contrast.ratio(HouseTokens.crimsonLit, on: HouseTokens.ground), Contrast.graphicFloor - 0.01)
        XCTAssertTrue(Contrast.isDisplay(size: 24, bold: false))
        XCTAssertFalse(Contrast.isDisplay(size: 22, bold: false), "22 px / 400 is NOT large text")
        XCTAssertTrue(Contrast.isDisplay(size: 18.66, bold: true))
    }

    func testReadableAlwaysReachesTheFloor() {
        let grounds = ["#0D0508", "#0C0A12", "#020208", "#1A1826", "#0E0C14"].map { LookColor(hex: $0) }
        for kp in 1...102 {
            let accent = LookColor(ShaktiPalette.atmosphere(kp: kp).hue)
            for g in grounds {
                let r = Contrast.readable(accent, on: g)
                XCTAssertGreaterThanOrEqual(Contrast.ratio(r, on: g), 4.5, "kp \(kp) on \(g.hex)")
            }
        }
        // The paper accent keeps its hue (≤ 2.2° drift in oklab) and reads.
        let paper = LookColor(hex: "#FBF8F1")
        let lav = LookColor(hex: "#B3B3DD")
        let acp = Contrast.paperAccent(lav)
        XCTAssertGreaterThanOrEqual(Contrast.ratio(acp, on: paper), 4.5)
        func hue(_ c: LookColor) -> Double { let l = OKLab.lab(c); return atan2(l.b, l.a) * 180 / .pi }
        XCTAssertLessThanOrEqual(Luminance.hueDistance(hue(acp), hue(lav)), 2.2)
    }

    // MARK: - 11 · Type: what ships and what is still to bundle (§1.15)

    func testBundledFacesAreExactlyTheFilesOnDisk() throws {
        let fonts = SourceTree.iOSRoot.appendingPathComponent("Bindu Mandala/Fonts")
        let onDisk = try FileManager.default.contentsOfDirectory(atPath: fonts.path).filter { $0.hasSuffix(".ttf") || $0.hasSuffix(".otf") }
        XCTAssertEqual(Set(onDisk), Set(TypeFamily.bundledFiles))
        let plist = try String(contentsOf: SourceTree.iOSRoot.appendingPathComponent("Bindu Mandala/Info.plist"),
                               encoding: .utf8)
        for f in TypeFamily.bundledFiles { XCTAssertTrue(plist.contains("<string>\(f)</string>"), "\(f) in UIAppFonts") }
        XCTAssertEqual(TypeFamily.toBundle.count, 17, "sixteen to add, plus Cormorant extended")
        XCTAssertEqual(TypeFace.cormorantLight.postScriptName, AppFont.cormorant)
        XCTAssertEqual(TypeFace.cormorantLightItalic.postScriptName, AppFont.cormorantItalic)
        XCTAssertNotEqual(TypeFace.cormorantMedium.postScriptName, AppFont.cormorant, "born red")
        XCTAssertEqual(TypeToken(.systemCaps, 8).size, 11, "8–10 px sources are raised to 11 pt")
        XCTAssertEqual(TypeToken(.systemCaps, 11, tracking: 0.22).trackingPoints, 11 * 0.22, accuracy: 1e-9)
    }

    // MARK: - 12 · Canon colours (§1.11)

    func testCanonColoursWinAndTheDyadsAreTheBake() {
        XCTAssertEqual(ColourSource.resolve([(.language, LookColor(hex: "#111111")),
                                             (.canon, LookColor(hex: "#B83A3A")),
                                             (.house, LookColor(hex: "#0D0508"))])?.hex, "#B83A3A")
        XCTAssertEqual(ColourSource.resolve([(.canon, nil), (.borrowed, LookColor(hex: "#222222")),
                                             (.house, LookColor(hex: "#0D0508"))])?.hex, "#0D0508")
        XCTAssertNil(ColourSource.resolve([(.canon, nil)]))
        for d in CanonColour.dyads {
            let room = ChakraConstellation.all.first { $0.road == d.road }
            XCTAssertEqual(room?.colorHex?.uppercased(), d.ground.hex, "road \(d.road) ground is the Map's hex")
            XCTAssertEqual(room?.colorDyad, d.dyad, "road \(d.road) dyad")
            XCTAssertEqual(CanonColour.room(road: d.road)?.hex, d.ground.hex)
        }
        XCTAssertEqual(ChakraConstellation.all.compactMap { CanonColour.room(road: $0.road) }.count, 33, "33 / 33 rooms carry a hex")
        let steps = CanonColour.steps(LookColor(hex: "#B83A3A"))
        XCTAssertGreaterThan(OKLab.lab(steps.bright).L, OKLab.lab(steps.base).L)
        XCTAssertEqual(steps.glow.a, 0.36); XCTAssertEqual(steps.border.a, 0.30); XCTAssertEqual(steps.soft.a, 0.62)
        XCTAssertEqual(CanonColour.mindTriadFill(road: 22)?.hex, "#EE8800")
        XCTAssertNil(CanonColour.mindTriadFill(road: 30))
        XCTAssertNotEqual(CanonColour.room(road: 2)?.hex, "#A82828", "born red: the site's drift loses")
    }

    // MARK: - 13 · Reduce Motion (§1.13) and the point

    func testReduceMotionPausesLoopsAndKeepsMechanisms() {
        for k in ReducedMotion.Kind.allCases {
            XCTAssertEqual(ReducedMotion.pauses(k, reduceMotion: true), k == .decorativeLoop, "\(k)")
            XCTAssertFalse(ReducedMotion.pauses(k, reduceMotion: false))
        }
        XCTAssertEqual([0, 0.2, 0.25, 0.6, 0.99, 1].map { ReducedMotion.quantize($0, steps: 4) }, [0, 0, 0.25, 0.5, 0.75, 1])
        XCTAssertEqual(ReducedMotion.holdDuration(1.8, reduceMotion: true), 1.8, "holds keep their length")
        XCTAssertEqual(ReducedMotion.holdProgress(0.6, reduceMotion: true), 0.5)
        XCTAssertEqual(ReducedMotion.crossingDuration(1.5, reduceMotion: true), 0.2)
        XCTAssertEqual(ReducedMotion.crossingDuration(1.5, reduceMotion: false), 1.5)
        XCTAssertFalse(ReducedMotion.crossingSounds(reduceMotion: true))
        XCTAssertEqual(ReducedMotion.breathOpacity(at: 1, period: 4, peak: 1.2), 1)
        XCTAssertEqual(ReducedMotion.breathOpacity(at: 3, period: 4, peak: 1.2), 1 / 1.2, accuracy: 1e-12)
        XCTAssertEqual(ReducedMotion.breathOpacity(at: 5, period: 4, peak: 1.2), 1, "period unchanged")
        XCTAssertEqual(ReducedMotion.adaptSeconds, 160); XCTAssertEqual(ReducedMotion.holdSeconds, 190)
        XCTAssertEqual(ReducedMotion.secondSeconds, 150)
        XCTAssertNil(ReducedMotion.animation(.decorativeLoop, designed: .linear, reduceMotion: true))
        XCTAssertNotNil(ReducedMotion.animation(.hold, designed: .linear, reduceMotion: true), "born red: holds are not stripped")
    }

    func testThePointInEveryWorldAndHisTratak() {
        for w in WorldID.allCases {
            let p = PointLook.forWorld(w)
            XCTAssertTrue((0...1).contains(p.depth), "\(w)")
            XCTAssertGreaterThanOrEqual(p.size, 6); XCTAssertLessThanOrEqual(p.size, 10)
        }
        XCTAssertEqual(PointLook.forWorld(.home).breath, 4)
        XCTAssertEqual(PointLook.forWorld(.home).breathPeak, 1.20)
        XCTAssertEqual(PointLook.mandala(zoomDepth: 1).breathPeak, 1.28)
        XCTAssertEqual(PointLook.forWorld(.the33).coreAlpha, 0.3)
        XCTAssertEqual(PointLook.forWorld(.well).glow, [22, 48])
        XCTAssertEqual((1...9).map { PointLook.ring($0).depth }, (0...8).map { Double($0) / 8 })
        XCTAssertNil(PointLook.ring(1).breath, "the Bhūpura holds")
        // Tratak: begins at 20 s, full at 45 s.
        XCTAssertEqual(TratakLight.intensity(stillFor: 19), 0)
        XCTAssertEqual(TratakLight.intensity(stillFor: 20), 0)
        XCTAssertEqual(TratakLight.intensity(stillFor: 30), 0.4, accuracy: 1e-12)
        XCTAssertEqual(TratakLight.intensity(stillFor: 45), 1)
        XCTAssertEqual(TratakLight.intensity(stillFor: 600), 1)
        // The light wanders within its reach and never stands still.
        var seen = Set<String>()
        for t in stride(from: 0.0, through: 120, by: 0.5) {
            let o = TratakLight.offset(at: t)
            XCTAssertLessThanOrEqual(abs(o.width), TratakLight.reach * 1.31)
            XCTAssertLessThanOrEqual(abs(o.height), TratakLight.reach * 0.86)
            seen.insert(String(format: "%.1f,%.1f", o.width, o.height))
        }
        XCTAssertGreaterThan(seen.count, 100, "no pattern, never caught")
        XCTAssertGreaterThanOrEqual(max(Hit.min, PointLook.forWorld(.the33).size * 2.6), 44, "44 pt target")
    }

    /// The point renders as one accessible element at every world's look.
    @MainActor
    func testThePointRendersInEveryWorld() {
        for w in WorldID.allCases {
            let view = ThePoint(look: PointLook.forWorld(w), light: w == .home ? .always : .off, onTap: {})
                .frame(width: 60, height: 60)
                .background(WorldStyle.of(w).colours.ground.color)
            let r = ImageRenderer(content: view)
            r.scale = 2
            XCTAssertNotNil(r.uiImage, "\(w)")
        }
    }

    // MARK: - 14 · People's hues (§1.4.15)

    func testPersonHueIsTheFormula() {
        func reference(_ s: String) -> Double {
            var n: UInt32 = 0
            for u in s.unicodeScalars { n = n &* 31 &+ u.value }
            return (Double(n) * 137.508).truncatingRemainder(dividingBy: 360).rounded()
        }
        for name in ["Gaia", "Ashrey", "Ram", "Bīja", ""] {
            XCTAssertEqual(WorldStyle.personHue(name), reference(name))
            XCTAssertTrue((0...360).contains(WorldStyle.personHue(name)))
        }
        XCTAssertNotEqual(WorldStyle.personHue("Gaia"), WorldStyle.personHue("Ram"))
    }
}
