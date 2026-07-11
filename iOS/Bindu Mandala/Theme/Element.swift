import Foundation

/// Her element — the axis the whole Living Rite composes from: Atmosphere places
/// her glow by it, and the Daily Rite chooses one of six archetypes from it.
/// (Ported from `living-rite-core.jsx` `lrElement` / `LR_RING_ELEMENTS`.)
enum Element: String, CaseIterable, Equatable {
    case fire, water, air, earth, ether, light

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
    /// Her element — Ring 2 from her tattva, every other ring from the fixed
    /// per-ring table (Ruling 6). Computed only — no stored property, no migration.
    var element: Element {
        let ring = ringNumber ?? 2
        let t = tattva.trimmingCharacters(in: .whitespacesAndNewlines)
        if ring == 2 && !t.isEmpty { return Element.parse(tattva: t) }
        return Element.forRing(ring)
    }
}
