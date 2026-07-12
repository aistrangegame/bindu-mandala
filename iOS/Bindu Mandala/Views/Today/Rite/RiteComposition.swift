import Foundation

/// The Daily Rite's structural vocabulary. Her element chooses a **plan** (block
/// order, alignment, where the sigil sits, whether her name becomes the vast
/// backdrop); a per-kp **composition** adds within-element variance (lean, spin,
/// scale, a subtle name-size nudge) so no two of the 102 are identical even
/// within one archetype. Ported from `living-rite-today.jsx` TD_PLANS + core
/// `lrComposition` / `LR_ARCHETYPE_BY_ELEMENT`.

enum RiteBlock { case kicker, name, nameSmall, phon, know, rule, quality, prompt }
enum RiteAlign { case center, lean }
enum SigilPlacement { case bottom, bottomWide, bottomBig, side, center, centerBig }

struct RitePlan {
    let archetype: String        // ascension / descent / horizon / veil / foundation / radiance
    let order: [RiteBlock]
    let align: RiteAlign
    let sigil: SigilPlacement
    let sigilScale: Double
    let horizonLine: Bool
    let veilName: Bool           // her name is the vast ground (ether)
    let nameCap: Double

    /// Element → composition. `earth` is the terminal fallback.
    static func forElement(_ e: Element) -> RitePlan {
        switch e {
        case .fire:   // ascension — she rises: prompt & quality first, name the climax
            return .init(archetype: "ascension",
                         order: [.kicker, .prompt, .rule, .quality, .name, .phon, .know],
                         align: .center, sigil: .bottom, sigilScale: 1.0,
                         horizonLine: false, veilName: false, nameCap: 58)
        case .water:  // descent — she settles: name high, prompt pools at the close
            return .init(archetype: "descent",
                         order: [.kicker, .name, .phon, .know, .rule, .quality, .prompt],
                         align: .center, sigil: .bottomWide, sigilScale: 1.15,
                         horizonLine: false, veilName: false, nameCap: 58)
        case .air:    // horizon — she drifts: sigil off one edge + a horizon line
            // (Centered stack; the drift lives in the offset sigil + horizon line.
            // Lean text asymmetry is a later polish pass — center is clip-proof.)
            return .init(archetype: "horizon",
                         order: [.kicker, .name, .phon, .know, .rule, .quality, .prompt],
                         align: .center, sigil: .side, sigilScale: 1.0,
                         horizonLine: true, veilName: false, nameCap: 58)
        case .ether:  // veil — she pervades: her name is the vast ground; a quiet stack floats
            return .init(archetype: "veil",
                         order: [.kicker, .nameSmall, .rule, .quality, .prompt, .know],
                         align: .center, sigil: .center, sigilScale: 0.9,
                         horizonLine: false, veilName: true, nameCap: 58)
        case .earth:  // foundation — she grounds: centered, a wide low sigil base
            return .init(archetype: "foundation",
                         order: [.kicker, .name, .phon, .know, .rule, .quality, .prompt],
                         align: .center, sigil: .bottomBig, sigilScale: 1.3,
                         horizonLine: false, veilName: false, nameCap: 58)
        case .light:  // radiance — she is the point: compact name within a dominant sigil
            return .init(archetype: "radiance",
                         order: [.kicker, .name, .phon, .rule, .quality, .prompt, .know],
                         align: .center, sigil: .centerBig, sigilScale: 1.15,
                         horizonLine: false, veilName: false, nameCap: 52)
        }
    }
}

/// Per-Śakti within-element variance, seeded off `khadgamalaPosition` (PR-0 ruling).
struct RiteComposition: Equatable {
    let element: Element
    let flip: Bool          // lean left/right (air)
    let spin: Double        // sigil rotation direction (+1 / -1)
    let sigilScale: Double  // 0.86–1.26
    let nameTier: Int       // 0–3 subtle name-size nudge

    static func derive(kp: Int, element: Element) -> RiteComposition {
        let m = UInt32(truncatingIfNeeded: kp &* 2654435761)
        return RiteComposition(
            element: element,
            flip: (m & 1) == 1,
            spin: (m & 2) != 0 ? 1 : -1,
            sigilScale: 0.86 + Double((m >> 3) & 7) / 7 * 0.4,
            nameTier: Int((m >> 6) & 3)
        )
    }

    /// The subtle name-size nudge by tier ([0,2,-2,3] in the prototype).
    var nameSizeNudge: Double { [0, 2, -2, 3][nameTier] }
}
