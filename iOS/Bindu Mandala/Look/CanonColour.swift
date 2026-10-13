import SwiftUI

// MARK: - U1 · Look · canon colours win (visual.md §1.11, §2 #4, §1.4.4)
//
// Precedence (settled): 1 the Map's Color Hex for each of the 33 rooms, the
// Mandala Atmosphere for each of the 102 · 2 the Mandala house tokens · 3 the
// world's language tokens · 4 field / dance / site hues only where no canon
// value exists. Every colour a world reads comes through here or through
// `ShaktiPalette`, never a hex chosen at the call site.

/// Which source a colour came from, highest first. Implements `visual.md`
/// §1.11.1 "Precedence (settled)".
enum ColourSource: Int, CaseIterable, Comparable {
    /// The Map's Color Hex (the 33) or the Mandala Atmosphere (the 102).
    case canon = 1
    /// The Mandala house tokens.
    case house = 2
    /// The world's studio language.
    case language = 3
    /// Field / dance / site hues — only where nothing above has a value.
    case borrowed = 4

    static func < (a: ColourSource, b: ColourSource) -> Bool { a.rawValue < b.rawValue }

    /// The first value present, in precedence order.
    static func resolve(_ candidates: [(ColourSource, LookColor?)]) -> LookColor? {
        for (_, colour) in candidates.sorted(by: { $0.0 < $1.0 }) {
            if let colour { return colour }
        }
        return nil
    }
}

/// The Mandala house tokens in full (`Color+Tokens.swift` holds most; the ink-2,
/// crimson-lit, gold-bright and the ember are added here, additively).
/// Implements `visual.md` §2 #4 "Mandala house tokens".
enum HouseTokens {
    static let ground = LookColor(hex: "#0D0508")
    static let surface = LookColor(hex: "#1A0C10")
    static let veil = LookColor(hex: "#080307")
    static let silence = LookColor(hex: "#040104")
    static let gold = LookColor(hex: "#C9963F")
    static let goldDeep = LookColor(hex: "#A07830")
    static let goldWarm = LookColor(hex: "#CF9443")
    static let goldBright = LookColor(hex: "#D4A017")
    static let cream = LookColor(hex: "#F2E8D9")
    static let ink2 = LookColor(hex: "#968D85")
    /// Graphic only, never text (2.19 : 1).
    static let crimson = LookColor(hex: "#8B1A2A")
    /// Graphic only, never text (3.01 : 1).
    static let crimsonLit = LookColor(hex: "#A4343E")
    /// The point's ember and consequence red — only where there is consequence.
    static let ember = LookColor(hex: "#C0392B")
    static let emberPressed = LookColor(hex: "#9E2D21")
    /// The hairline gold's alpha.
    static let hairlineAlpha = 0.14

    /// Status as light — a relationship, never a grade, never shown as a number.
    static func statusLight(_ r: BreathEnclosure.Relationship) -> Double {
        switch r {
        case .mapped:    return 0.22
        case .exploring: return 0.44
        case .active:    return 0.76
        case .embodied:  return 1.0
        case .today:     return 1.0
        }
    }

    /// The text ladder (spine role grammar): high .92 · mid .80 · body .72 ·
    /// soft .58 · whisper .36 · ghost .20. Whisper and ghost are texture (below
    /// the .5 floor) — never words.
    static let textLadder: [(name: String, alpha: Double)] = [
        ("high", 0.92), ("mid", 0.80), ("body", 0.72), ("soft", 0.58), ("whisper", 0.36), ("ghost", 0.20),
    ]
}

/// One of the nine rings as a world (§1.4.4): its hex, wash, deep, legible
/// text, the WORLDS weather and its breath and chrome. Implements `visual.md`
/// §1.4.4 "The nine rings — mandala · ring-n".
struct RingLook: Equatable {
    let ring: Int
    /// The ring's colour (Atmosphere's seed; ring 2 the DS-04 cluster hex).
    let hex: LookColor
    let fog: LookColor
    let fogDensity: Double
    let veil: Double
    let tempo: Double
    /// Gem diffusion — light behaviour, never hue.
    let gemDiffusion: Double

    /// `mix(oklab, #0D0508 80 %, ring 20 %)`.
    var wash: LookColor { ShaktiPalette.wash(hex) }
    /// `mix(oklab, #070205 88 %, ring 12 %)`.
    var deep: LookColor { ShaktiPalette.deep(hex) }
    /// The ring's hex lifted toward cream until it reads at 4.5 : 1 on its wash.
    var text: LookColor { Contrast.readable(hex, on: wash) }
    /// Its enclosure's breath (ring 1 holds).
    var breath: Double { BreathEnclosure.forRing(ring)?.period ?? 0 }
    var chrome: ChromeStep { ChromeStep.ring(ring) }
    /// Fog density × (1 + veil × 0.55).
    var effectiveFogDensity: Double { fogDensity * (1 + veil * 0.55) }

    static func of(_ ring: Int) -> RingLook {
        let n = min(max(ring, 1), 9)
        let hex = n == 2 ? LookColor(hex: "#D4A017") : LookColor(Atmosphere.ringHue(n))
        switch n {
        case 1: return RingLook(ring: 1, hex: hex, fog: LookColor(hex: "#1D1206"), fogDensity: 0.0125, veil: 0.00, tempo: 1.00, gemDiffusion: 0.20)
        case 2: return RingLook(ring: 2, hex: hex, fog: LookColor(hex: "#0A1330"), fogDensity: 0.017, veil: 0.12, tempo: 0.82, gemDiffusion: 0.30)
        case 3: return RingLook(ring: 3, hex: hex, fog: LookColor(hex: "#2A0C06"), fogDensity: 0.021, veil: 0.24, tempo: 0.62, gemDiffusion: 0.45)
        case 4: return RingLook(ring: 4, hex: hex, fog: LookColor(hex: "#0B1219"), fogDensity: 0.014, veil: 0.36, tempo: 0.72, gemDiffusion: 0.15)
        case 5: return RingLook(ring: 5, hex: hex, fog: LookColor(hex: "#06180E"), fogDensity: 0.018, veil: 0.48, tempo: 0.66, gemDiffusion: 0.25)
        case 6: return RingLook(ring: 6, hex: hex, fog: LookColor(hex: "#1A0409"), fogDensity: 0.022, veil: 0.60, tempo: 0.50, gemDiffusion: 0.55)
        case 7: return RingLook(ring: 7, hex: hex, fog: LookColor(hex: "#D8D2C4"), fogDensity: 0.034, veil: 0.72, tempo: 0.44, gemDiffusion: 0.95)
        case 8: return RingLook(ring: 8, hex: hex, fog: LookColor(hex: "#0F0B04"), fogDensity: 0.015, veil: 0.86, tempo: 0.36, gemDiffusion: 0.10)
        default: return RingLook(ring: 9, hex: hex, fog: LookColor(hex: "#141008"), fogDensity: 0.009, veil: 1.00, tempo: 0.28, gemDiffusion: 0.70)
        }
    }

    static let all: [RingLook] = (1...9).map { RingLook.of($0) }
}

/// The 33's canon colours: the Map's Color Hex per room (baked into
/// `Data/ChakraConstellation.json` as `colorHex`), its six-step contract, the
/// dyads of the body rooms, the seeded grounds 21–33 and the next-colour
/// rhyme. Implements `visual.md` §1.11.2–1.11.4 and §1.4.8 "room hue".
enum CanonColour {

    /// The Map's Color Hex for a room by its Road position (1…33), as baked.
    static func room(road: Int, in rooms: [Chakra33] = ChakraConstellation.all) -> LookColor? {
        guard let hex = rooms.first(where: { $0.road == road })?.colorHex,
              hex.hasPrefix("#"), hex.count == 7 else { return nil }
        return LookColor(hex: hex)
    }

    /// The six-step contract derived from a room's hex (§1.4.8): bright +18 L
    /// (oklab L, in per cent of its 0…1 range) · glow α .36 · tint mix 12 % into
    /// the ground · border α .30 · soft α .62.
    struct RoomSteps: Equatable {
        let base: LookColor
        let bright: LookColor
        let glow: LookColor
        let tint: LookColor
        let border: LookColor
        let soft: LookColor
    }

    /// The 33's night ground the tint mixes into.
    static let the33Ground = LookColor(hex: "#0C0A12")

    static func steps(_ hex: LookColor, ground: LookColor = the33Ground) -> RoomSteps {
        var lab = OKLab.lab(hex)
        lab.L = min(lab.L + 0.18, 1)
        return RoomSteps(base: hex,
                         bright: OKLab.color(lab),
                         glow: hex.opacity(0.36),
                         tint: OKLab.mix(ground, hex, 0.12),
                         border: hex.opacity(0.30),
                         soft: hex.opacity(0.62))
    }

    // MARK: The dyad palette (body 10–19, §1.11.3)

    struct Dyad: Equatable {
        let road: Int
        let centre: String
        let dyad: String
        let ground: LookColor
    }

    static let dyads: [Dyad] = [
        Dyad(road: 10, centre: "Soles", dyad: "Red / Cyan", ground: LookColor(hex: "#7A1515")),
        Dyad(road: 11, centre: "Forge", dyad: "Yellow / Blue", ground: LookColor(hex: "#6B5800")),
        Dyad(road: 12, centre: "Prana", dyad: "Orange / Azure", ground: LookColor(hex: "#7A3800")),
        Dyad(road: 13, centre: "Hands", dyad: "Green / Magenta", ground: LookColor(hex: "#163D1E")),
        Dyad(road: 14, centre: "Pulse", dyad: "Green / Magenta", ground: LookColor(hex: "#112E17")),
        Dyad(road: 15, centre: "Sonar", dyad: "Blue / Yellow", ground: LookColor(hex: "#091840")),
        Dyad(road: 16, centre: "Echo", dyad: "Blue / Yellow", ground: LookColor(hex: "#060D30")),
        Dyad(road: 17, centre: "Vision", dyad: "Yellow / Blue", ground: LookColor(hex: "#5C4800")),
        Dyad(road: 18, centre: "Axis", dyad: "Indigo / Chartreuse", ground: LookColor(hex: "#1A0848")),
        Dyad(road: 19, centre: "Crow", dyad: "Violet / Chartreuse", ground: LookColor(hex: "#3A0A54")),
    ]

    /// The body light as two colours in productive tension: the primary is the
    /// ground hex lifted +40 L (oklab, per cent), the complement at its hue + 180°.
    static func dyadLight(_ d: Dyad) -> (primary: LookColor, complement: LookColor) {
        var lab = OKLab.lab(d.ground)
        lab.L = min(lab.L + 0.40, 1)
        let primary = OKLab.color(lab)
        let comp = OKLab.color(OKLab.Lab(L: lab.L, a: -lab.a, b: -lab.b))
        return (primary, comp)
    }

    // MARK: Seeded grounds 21–33 (§1.11.2 — where the Map gives a hex, the hex wins)

    static let sceneGrounds: [Int: LookColor] = [
        21: LookColor(hex: "#0E0A1F"),
        25: LookColor(hex: "#0B0E22"),
        29: LookColor(hex: "#140C1E"),
        30: LookColor(hex: "#F4F1EC"),   // veil
        31: LookColor(hex: "#0F0A04"),   // trikoṇa
        32: LookColor(hex: "#0E1A0C"),   // field — light without text (ruling 2)
        33: LookColor(hex: "#FBF6EA"),   // morning
    ]

    /// The Mind triads' fills: Creation 21–23 warm amber, Recognition 24–26
    /// cool blue-silver, Emergence 27–29 gold.
    static func mindTriadFill(road: Int) -> LookColor? {
        switch road {
        case 21...23: return LookColor(r: 238 / 255, g: 136 / 255, b: 0)
        case 24...26: return LookColor(r: 100 / 255, g: 140 / 255, b: 220 / 255)
        case 27...29: return LookColor(r: 201 / 255, g: 168 / 255, b: 76 / 255)
        default:      return nil
        }
    }

    // MARK: Next-colour rhyme (§1.11.4)

    /// The destination's colour bleeds up from the bottom edge at 24 s.
    static let nextColourBleedSeconds: Double = 24
    /// Ajna → Sahasrara door; Sahasrara → Shadow door.
    static let ajnaToSahasrara = LookColor(hex: "#9B5AE6")
    static let sahasraraToShadow = LookColor(hex: "#E8D4A8")
    /// A sideways door tints the world toward its accent at α .55 and the page
    /// changes after 520 ms.
    static let sidewaysTintAlpha = 0.55
    static let sidewaysChangeSeconds = 0.52
}
