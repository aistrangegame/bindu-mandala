import Foundation

// MARK: - The gem light
//
// The gem half of `Claude Design Round 2/homes/homes-chambers.js`.
//
// Design's own header on that block is the ruling this file obeys: *"a verbatim
// port of Atmosphere.swift — every number here is the repo's, not a design
// choice."* Design had already made, and already corrected, the mistake of
// re-deriving a room's colour from the gemstone's own name; topaz is not a hue
// the walker's light is allowed to come from. Hue, saturation and lightness
// belong to the app, and this file reads them straight out of ``Atmosphere``:
// its ring hues, its five ring-2 cluster hues, and its ±7° per-Śakti jitter
// keyed off khaḍgamālā position.
//
// What the gem *does* carry is Design's `GEM_BEHAVIOUR`: how diffuse the light
// is, and — at the Crown alone — that it has no source at all. That is
// behaviour, not colour, and it is the only thing added on top.
//
// Pure values. No SceneKit, no SwiftUI, no view; a ruled renderer draws these
// either way.

/// The light in one room: the app's own hue, wearing the ring's gem behaviour.
struct HomeGem: Equatable {

    /// Āvaraṇa 1–9.
    let ring: Int
    /// The gem's name, as the āvaraṇa table carries it — a word for the
    /// behaviour, never a source of colour.
    let gem: String
    /// How diffuse the light is, 0 (a hard point) to 1 (everywhere at once).
    let diffuse: Double
    /// The ring-2 cluster this seat belongs to, derived from her khaḍgamālā
    /// position. `nil` everywhere else — the 86's `.inner` default never leaks
    /// into a light (Ruling 7).
    let cluster: Cluster?
    /// The hue, saturation and lightness ``Atmosphere`` derives. The single
    /// source of this room's colour.
    let hue: HSL

    /// Whether this world's light arrives from nowhere.
    ///
    /// The Crown is the one āvaraṇa lit sourcelessly: luminous fog, no shadow
    /// anywhere, light from every direction at once, so there is nothing to
    /// orient by. A renderer must place **no directional light** in ring 7.
    var isSourceless: Bool { ring == HomeGem.sourcelessRing }

    /// The inverse of ``isSourceless`` — the ring admits a directional key.
    var hasDirectionalLight: Bool { !isSourceless }

    /// The lift on her accent, exactly as `Atmosphere.accentBright` computes it.
    var bright: HSL {
        HSL(h: hue.h, s: min(hue.s + 10, 88), l: min(hue.l + 18, 78))
    }

    /// The dhātu surface: her hue, desaturated and taken almost to black, so
    /// the walls are *her* material rather than a neutral grey. Design's `ink`.
    var ink: HSL {
        HSL(h: hue.h, s: hue.s * HomeGem.inkSaturationFactor, l: HomeGem.inkLightness)
    }

    // MARK: - Constants

    /// The only āvaraṇa whose light has no source.
    static let sourcelessRing = 7

    /// ``Atmosphere``'s jitter range: 14 degrees wide, so ±7 off the seed hue.
    static let jitterRange: Double = 14

    private static let inkSaturationFactor: Double = 0.55
    private static let inkLightness: Double = 12

    /// Design's `GEM_BEHAVIOUR` — the gem as behaviour only.
    static let behaviour: [Int: (gem: String, diffuse: Double)] = [
        1: ("Topaz", 0.20),
        2: ("Sapphire", 0.30),
        3: ("Coral", 0.45),
        4: ("Diamond", 0.15),
        5: ("Emerald", 0.25),
        6: ("Ruby", 0.55),
        7: ("Pearl", 0.95),
        8: ("Cat's eye", 0.10),
        9: ("All gems", 0.70),
    ]

    // MARK: - Derivation

    /// The light of one room.
    ///
    /// Pass her khaḍgamālā position and the light is hers: the seed hue jittered
    /// ±7° off her position, and — in ring 2 only — seeded from her cluster
    /// rather than the ring, so sisters of a cluster share a light as well as a
    /// corridor. Pass `nil` and you get the world shown empty: the ring's
    /// unjittered seed, before any Śakti is set inside it.
    ///
    /// Position is the only key. The cluster is read off the position through
    /// ``KhadgamalaMap`` and ``Cluster/forPosition(_:)``, never off a name and
    /// never off a stored `clusterRaw`.
    static func gemFor(ring: Int, khadgamalaPosition: Int?) -> HomeGem {
        let cluster = ring2Cluster(ring: ring, khadgamalaPosition: khadgamalaPosition)
        let seed = Atmosphere.seedHue(ring: ring, cluster: cluster)
        let h: Double
        if let kp = khadgamalaPosition {
            h = HSL.wrap(seed.h + Atmosphere.jitter(kp, jitterRange))
        } else {
            h = seed.h
        }
        // Design's own fallback: an indeterminate ring inherits the home ring's
        // behaviour rather than none, so the light is never behaviourless.
        let beh = behaviour[ring] ?? behaviour[2]!
        return HomeGem(ring: ring, gem: beh.gem, diffuse: beh.diffuse,
                       cluster: cluster, hue: HSL(h: h, s: seed.s, l: seed.l))
    }

    /// Her cluster seat — ring 2 and a genuine 29…44 position only.
    ///
    /// The lotus's sixteen are the only Śaktis in the 102 that carry a real
    /// cluster. Everywhere else this is `nil`, which is what keeps the 86's
    /// `.inner` default out of the light.
    static func ring2Cluster(ring: Int, khadgamalaPosition: Int?) -> Cluster? {
        guard ring == 2, let kp = khadgamalaPosition,
              KhadgamalaMap.ringNumber(forKhadgamala: kp) == 2 else { return nil }
        return Cluster.forPosition(KhadgamalaMap.perRingIndex(forKhadgamala: kp))
    }
}
