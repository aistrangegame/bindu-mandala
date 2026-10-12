import Foundation

// MARK: - Wave 6 · B · the Tree of Life through the nine rings
//
// The `tree-of-life` skill's nine panels are the nine āvaraṇas (Reading §5):
// Panel 1 Press (Bhūpura) … Panel 9 Dissolve (the Bindu, inverted). This file
// is the pure half of that mapping — tables and curves, no views and no sound —
// so every number is something a test can hold:
//
//   • the ring verbs, Press · Follow · Build · Open · Speak · Still · Receive ·
//     Hold · Dissolve, and the gesture each ring answers to in the Mandala's
//     interior (a held press in the outer rings, stillness by the sixth, and
//     nothing at all at the source — master brief §10's correction: gesture
//     recedes toward none as the rings deepen);
//   • the breath arc, where the guide's own labels take themselves away — P1
//     says in / hold / out, P6 says in / see, P7 says nothing;
//   • the guide's words thinning ring by ring, none from the seventh;
//   • Progressive Luminance, 5 % at the first ring to the whole of the light at
//     the Bindu (the skill's P1 5 … P8 90, the Bindu full);
//   • the Om at 136.1 Hz, always playing, its floor rising with depth — the
//     crescendo is not volume increasing, it is noise decreasing;
//   • Panel 9's eight inverse dissolutions (`mirror-dissolution-architecture`),
//     each undoing what its panel built, writing nothing;
//   • "Now go play." — the last words before Lalitā's field.
//
// The words a walker reads come from his rows (``GameStructure``) or from the
// panels' own authored text in the skill, verbatim.

enum TreeOfLife {

    // MARK: The verbs

    /// The skill's own nine, in ring order. The bake carries the same nine from
    /// the Identity rows; this table stands when the bundle has lost the file.
    static let verbs = ["Press", "Follow", "Build", "Open", "Speak",
                        "Still", "Receive", "Hold", "Dissolve"]

    static func verb(ring: Int) -> String? {
        guard (1...9).contains(ring) else { return nil }
        return GameStructure.panel(ring: ring)?.verb ?? verbs[ring - 1]
    }

    /// What the ring answers to, in the Mandala's interior — the ring's verb
    /// performed at ring scale.
    enum RingAnswer: Equatable {
        /// A hold anywhere in the ring that is not a seat.
        case press(seconds: Double)
        /// The glass left untouched this long.
        case stillness(seconds: Double)
        /// Nothing is asked. The source is not reached by doing (C-1307).
        case none

        /// How long the press is, if the ring answers to a press.
        var pressSeconds: Double? {
            if case .press(let s) = self { return s }
            return nil
        }

        /// How long the stillness is, if the ring answers to stillness.
        var stillnessSeconds: Double? {
            if case .stillness(let s) = self { return s }
            return nil
        }
    }

    /// The hold the Mandala's gesture catcher asks for at this ring — a press
    /// so long it is never met where the ring does not answer to one.
    static func holdSeconds(ring: Int) -> Double {
        answer(ring: ring).pressSeconds ?? 3600
    }

    /// Press, Follow, Build, Open and Speak are hands-on verbs and answer to a
    /// held press that lengthens as the rings deepen; Still, Receive and Hold
    /// are verbs of not-doing and answer to stillness; Dissolve asks nothing.
    static func answer(ring: Int) -> RingAnswer {
        switch ring {
        case 1: return .press(seconds: 0.8)
        case 2: return .press(seconds: 1.0)
        case 3: return .press(seconds: 1.2)
        case 4: return .press(seconds: 1.4)
        case 5: return .press(seconds: 1.6)
        case 6: return .stillness(seconds: 4)
        case 7: return .stillness(seconds: 6)
        case 8: return .stillness(seconds: 8)
        default: return .none
        }
    }

    // MARK: The guide removing itself

    /// How much of the guide's own instruction still stands at this ring, `0…1`.
    /// Full at the first ring, thinning, and gone from the seventh: by Panel 7
    /// the voice has removed itself.
    static func guideWords(ring: Int) -> Double {
        switch ring {
        case ...1: return 1
        case 2: return 0.84
        case 3: return 0.68
        case 4: return 0.52
        case 5: return 0.36
        case 6: return 0.18
        default: return 0
        }
    }

    /// One phase of a guided breath: how long, and the word it says — `nil`
    /// once the guide has stopped saying anything.
    struct BreathPhase: Equatable {
        let seconds: Double
        let label: String?
    }

    struct Breath: Equatable {
        let phases: [BreathPhase]
        let cycles: Int
        var seconds: Double { phases.reduce(0) { $0 + $1.seconds } * Double(cycles) }
    }

    /// The skill's Breath Arc, each ring's breath its teaching and its exhale
    /// naming its function. Rings 8 and 9 impose none: he breathes on his own.
    static func breath(ring: Int) -> Breath? {
        func b(_ cycles: Int, _ p: [(Double, String?)]) -> Breath {
            Breath(phases: p.map { BreathPhase(seconds: $0.0, label: $0.1) }, cycles: cycles)
        }
        switch ring {
        case 1: return b(3, [(4, "in"), (4, "hold"), (4, "out")])
        case 2: return b(2, [(4, "in"), (6, "release")])
        case 3: return b(2, [(3, "in"), (3, "hold"), (6, "forge")])
        case 4: return b(2, [(5, "in"), (5, "hold"), (8, "give")])
        case 5: return b(2, [(4, "in"), (7, "hold"), (8, "clear")])
        case 6: return b(2, [(6, "in"), (6, "see")])
        case 7: return b(2, [(7, nil), (8, nil)])
        default: return nil
        }
    }

    // MARK: Progressive luminance

    /// The light standing in the air at this depth, `0…1`: the skill's P1 5 %,
    /// P2 10, P3 18, P4 28, P5 40, P6 55, P7 75, P8 90, and the Bindu whole.
    static func luminance(ring: Int) -> Double {
        let table: [Double] = [0, 0.05, 0.10, 0.18, 0.28, 0.40, 0.55, 0.75, 0.90, 1.0]
        return table[max(0, min(9, ring))]
    }

    // MARK: The secrecy of the deeper rings

    /// How legible the ring's collective breath is: the Yoginī gradient, from
    /// Prakaṭa (manifest) at the first ring to Parāparārahasya at the ninth.
    /// Ring 1's is obvious; by rings 7–9 it is barely there.
    static func legibility(ring: Int) -> Double {
        let r = Double(max(1, min(9, ring)))
        return 1 - (r - 1) / 8 * 0.85
    }

    // MARK: The Om at 136.1

    /// Earth's orbital frequency, the point's and the worlds' own pitch.
    static let omHz: Double = 136.1
    /// Panel 9's voicing: the root, its octave at 30 %, its sub-octave at 15 %.
    static let omPartials: [(Double, Double)] = [(272.2, 0.30), (68.05, 0.15)]

    /// The Om's floor at a depth, as an absolute gain: imperceptible at the
    /// rim, a presence at the source. It is never turned on — it rises only
    /// as everything else falls away.
    static func omFloor(depth: Int) -> Double {
        let d = Double(max(0, min(9, depth)))
        return 0.004 + 0.026 * d / 9
    }

    // MARK: Panel 9 — the eight dissolutions

    /// How a station is dissolved: the inverse of the verb that built it.
    enum DissolveKind: Equatable {
        /// Touch, then lift.
        case lift
        /// A word drifts; letting it go is not touching it.
        case letGo(seconds: Double)
        /// Hold still; nothing made.
        case beStill(seconds: Double)
        /// Pinch inward, or three touches, each folding it further in.
        case foldIn
        /// The absence is the action.
        case silence(seconds: Double)
        /// Move — the release of the control.
        case move
        /// Swipe it upward, or hold it until it rises.
        case offerUp
        /// Press, hold, and let go.
        case holdThenRelease(seconds: Double)
    }

    struct Dissolution: Equatable {
        /// The ring whose verb this undoes.
        let ring: Int
        /// The instruction, verbatim from the skill's Mirror Dissolution.
        let instruction: String
        let kind: DissolveKind
    }

    /// The Mirror's eight stations, in its own order (root first). Each shows
    /// the panel's declaration and asks for the inverse of its verb. **The
    /// dissolution writes nothing** (panel 9: *"Like Panel 8 — the dissolution
    /// writes nothing"*): there is no ledger row here and nothing kept.
    static let dissolutions: [Dissolution] = [
        Dissolution(ring: 1, instruction: "Now release it.", kind: .lift),
        Dissolution(ring: 2, instruction: "Let the word go.", kind: .letGo(seconds: 8)),
        Dissolution(ring: 3, instruction: "Now be still.", kind: .beStill(seconds: 5)),
        Dissolution(ring: 4, instruction: "Let the recognition fold back into you.", kind: .foldIn),
        Dissolution(ring: 5, instruction: "Now let the silence hold it.", kind: .silence(seconds: 10)),
        Dissolution(ring: 6, instruction: "Now move.", kind: .move),
        Dissolution(ring: 7, instruction: "Now offer it back.", kind: .offerUp),
        Dissolution(ring: 8, instruction: "Now release what you held.", kind: .holdThenRelease(seconds: 3)),
    ]

    /// After the eight: the Mirror's recognition and its closing triangle,
    /// verbatim, and then the last words.
    static let recognition = "Everything you placed in this space is already moving toward you."
    static let closing = ["You have always had the Knowledge.",
                          "You have always been the Will.",
                          "Now You Become the Action."]
    /// The installation's final transmission (C-1163) — always, always, always.
    static let nowGoPlay = "Now go play."

    /// **The naming is the veil.** At the Bindu no name is spoken: the
    /// dissolution shows no Śakti's name, no ring's name, no label — only his
    /// own declarations leaving, and the point.
    static let theBinduIsNamed = false
}
