import Foundation

/// Her element — the axis the whole Living Rite composes from: Atmosphere places
/// her glow by it, and the Daily Rite chooses one of six archetypes from it.
/// (Ported from `living-rite-core.jsx` `lrElement` / `LR_RING_ELEMENTS`.)
///
/// `.light` is Ring 9's (Lalitā, the point) and, by ruling 4 (12 Oct 2026),
/// Ātmākarṣiṇī's in Ring 2 (kp 42). Every `switch` over `Element` names it.
enum Element: String, CaseIterable, Equatable {
    case fire, water, air, earth, ether, light

    /// U0 · C12 — the sixteen Karṣiṇīs of Ring 2 by position, one explicit table.
    /// The base names the element for kp 29–33 (Pṛthivī, Ap, Tejas, Vāyu, Ākāśa);
    /// ruling 4 sets kp 31 fire (Ahaṅ), 40 air (Nāma), 42 light (Ātma), 43 water
    /// (Amṛta); Design's RING2 grammar gives the rest. The tattva text on her row
    /// stays verbatim and untouched — for kp 34–44 it names the cross-mapped
    /// organ, so it cannot be parsed into an element.
    static let ring2ByKp: [Int: Element] = [
        29: .earth, 30: .water, 31: .fire, 32: .air, 33: .ether,
        34: .fire, 35: .water, 36: .earth, 37: .ether, 38: .earth,
        39: .water, 40: .air, 41: .fire, 42: .light, 43: .water, 44: .earth,
    ]

    /// A Ring-2 Śakti's element by her position (kp 29–44); nil outside Ring 2.
    static func forRing2(kp: Int) -> Element? {
        ring2ByKp[kp]
    }

    /// Per-ring temperament for every ring except Ring 2 (which reads her tattva).
    /// Ruling 6: rings 1,3–9 take a fixed element; Ring 2 is handled by `parse`.
    /// Exhaustive with an `.ether` terminal default so it never blanks for the 86.
    static func forRing(_ ring: Int) -> Element {
        switch ring {
        case 1: return .earth
        case 3: return .air
        case 4: return .water
        case 5: return .fire
        case 6: return .ether
        case 7: return .air
        case 8: return .fire
        case 9: return .light
        default: return .ether   // ring 2 (no tattva) and any indeterminate ring
        }
    }

    /// Parse a Ring-2 Śakti's free-text tattva into an element. Falls to `.ether`
    /// when nothing matches — never nil.
    static func parse(tattva: String) -> Element {
        let t = tattva.lowercased()
        if t.contains("fire")  || t.contains("agni")                                   { return .fire }
        if t.contains("air")   || t.contains("vāyu") || t.contains("vayu")             { return .air }
        if t.contains("water") || t.contains("jala") || t.contains("apas")             { return .water }
        if t.contains("earth") || t.contains("pṛthvī") || t.contains("prithvi")        { return .earth }
        if t.contains("ether") || t.contains("ākāśa") || t.contains("akasha") || t.contains("space") { return .ether }
        return .ether
    }
}

extension Shakti {
    /// Her element — Ring 2 from the kp table (C12, ruling 4), every other ring
    /// from the fixed per-ring table (Ruling 6). A Ring-2 row with no position
    /// still falls back to her tattva. Computed only — no stored property, no
    /// migration.
    var element: Element {
        if let kp = khadgamalaPosition, let e = Element.forRing2(kp: kp) { return e }
        let ring = ringNumber ?? 2
        let t = tattva.trimmingCharacters(in: .whitespacesAndNewlines)
        if ring == 2 && !t.isEmpty { return Element.parse(tattva: t) }
        return Element.forRing(ring)
    }
}
