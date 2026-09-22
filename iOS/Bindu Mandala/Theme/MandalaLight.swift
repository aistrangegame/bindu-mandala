import SwiftUI

// MARK: - MandalaLight — one source, nine refractions
//
// Phase 5. Expansion ideas 27 ("lit from the Bindu"), 28 ("made of light, not
// lines") and 30 ("veiled by secrecy") are one sentence said three ways, and
// this file is that sentence as arithmetic.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT IS RE-FOUNDED, AND WHAT IS NOT
// ─────────────────────────────────────────────────────────────────────────────
//
// Before this file, every seat was lit **independently**: `Atmosphere.derive`
// handed each Śakti a hue seeded off her ring (or her ring-2 cluster) and
// jittered ±7° by her khaḍgamālā position, and the canvas drew that colour flat.
// A hundred and two little lamps, each its own.
//
// Idea 27 asks for the opposite theology: *one* light, the Bindu's, reaching
// every seat through the gem of its enclosure. So this file does not replace
// the hue — `Atmosphere` and ``SeatLighting`` stay the single source of *what
// colour is this Śakti* (Ruling 7 / R3, and the 86's false `.inner` cluster
// default still never leaks). What this file adds is everything a *source*
// implies and a lamp does not:
//
//   · **reach** — how much of the Bindu's light arrives here at all, falling
//     with distance from the centre;
//   · **refraction** — how far the arriving light pulls her hue toward the
//     source's own, governed by the gem's behaviour;
//   · **the veil** — how much of the ring's secrecy stands between her and a
//     walker who is not yet still and close.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE GEM IS A BEHAVIOUR. IT IS NEVER A COLOUR.
// ─────────────────────────────────────────────────────────────────────────────
//
// ``HomeGem``'s own header records a mistake Design made and then corrected:
// deriving a room's colour from the gemstone's name. *"Topaz is not a hue the
// walker's light is allowed to come from."* Hue, saturation and lightness
// belong to ``Atmosphere``; what the gem carries is `diffuse` — how scattered
// the light is, 0 a hard point and 1 everywhere at once — and, at the Crown
// alone, that it has no source.
//
// Idea 27 as the expansion doc writes it ("Topaz: warm, amber, low. Sapphire:
// deep blue, cool") asks for exactly the corrected mistake, and this file
// refuses it. Not one gem name appears below, and `MandalaLightTests` reads
// this file's own source to prove it. The refraction is built out of `diffuse`
// instead, which turns out to say the same thing better:
//
//   **a gem that scatters little transmits the source; a gem that scatters
//   much turns the light into its own.**
//
// So ring 8's cat's eye (0.10) seats sit almost in the Bindu's own gold, ring
// 7's pearl (0.95) is wholly itself, and the pull is bounded at
// ``refractionLimit`` so a Śakti is never *more* the source than she is
// herself. Position stays identity, and the same Śakti is the same colour here
// and in her Home, because both read `Atmosphere`.
//
// ─────────────────────────────────────────────────────────────────────────────
// NOTHING HERE IS ALLOWED TO KNOW HOW OFTEN SHE HAS BEEN FELT
// ─────────────────────────────────────────────────────────────────────────────
//
// Light is where "how much" wants to creep in, and the beautiful version of the
// broken law is the veil that lifts with familiarity — *return often enough and
// the eighth enclosure clears* — which is a completion meter rendered as fog.
// The veil's inputs are **the ring, how close the viewport is, and how long the
// glass has been untouched, and nothing else**. All three are structural or
// present-tense: the same on the first day and the ten-thousandth, and they
// reset the moment a finger lands.
//
// The one thing this file takes from a walker's practice is a `Bool` — whether
// a seat has been felt at all. A state, not a measure. There is no `Int` in any
// signature below that came from a ledger, and `MandalaLightTests` asserts the
// source carries no count-family identifier at all.

/// The light standing at one enclosure: what reaches it, how its gem bends
/// that, and how much of its secrecy is still drawn across it.
///
/// A pure value type, testable off-device exactly as ``HomeGem`` and
/// ``HomeWorlds`` are. It holds no view, no clock and no store.
struct MandalaLight: Equatable {

    /// Āvaraṇa 1–9.
    let ring: Int
    /// How much of the Bindu's light arrives here, 1 at the centre falling
    /// outward. See ``reach(atRadius:)``.
    let reach: Double
    /// The gem's scattering, straight off ``HomeGem/behaviour`` — 0 a hard
    /// point, 1 everywhere at once. A behaviour, never a colour.
    let scatter: Double
    /// This ring's secrecy, straight off ``HomeWorlds/veils`` — 0 at the
    /// Bhūpura, 1 at the Bindu. Structural: it never moves.
    let veil: Double
    /// How much of that secrecy actually stands between the walker and this
    /// ring *right now* — the veil, less whatever stillness and nearness have
    /// cleared. Present-tense, and it closes again when she moves.
    let veiling: Double

    // MARK: - Constants

    /// The Bindu's own light: ``Atmosphere``'s ninth ring hue, unjittered. The
    /// one source every other light in the instrument is a refraction of.
    static let source = Atmosphere.ringHue(9)

    /// How steeply the source falls off with distance. Not inverse-square:
    /// the outermost enclosure is six times the radius of the eighth, and a
    /// square law would leave the Bhūpura's twenty-eight rooms at a fortieth of
    /// the centre's light, which is dark, not distant. This is the gentlest
    /// falloff that still reads as *further away*.
    static let falloff: Double = 1.35

    /// The furthest the refraction may pull a Śakti's hue toward the source.
    /// Bounded so she is always more herself than she is the Bindu.
    static let refractionLimit: Double = 0.45

    /// How much of a *mark's* opacity the full veil may take. A fully veiled
    /// enclosure still shows a little over half its light — "nearly invisible
    /// from outside", not absent.
    static let veilMarkDepth: Double = 0.45

    /// How much of a *word's* opacity the full veil may take, and the floor it
    /// may never take it below.
    ///
    /// Two numbers rather than one because FIDELITY §4 sets a legibility floor
    /// on meaningful text (≥ ~11pt, ≥ ~0.5 alpha) and mist is not a licence to
    /// cross it. A name is a legend, not a thing standing in the fog: it dims
    /// with its seat and then stops.
    static let veilTextDepth: Double = 0.25
    static let legibleTextAlpha: Double = 0.5

    /// How long the glass must lie untouched for the veil to have cleared as
    /// far as nearness alone allows.
    static let stillnessSpan: TimeInterval = 4.0

    /// How much of the clearing nearness buys on its own, before stillness.
    /// Being close is necessary; being still is what finishes it.
    static let nearnessShare: Double = 0.55

    // MARK: - Reach — the fall from the source

    /// How much of the Bindu's light arrives at a world radius. 1 at the
    /// origin, falling smoothly to about a third at the Bhūpura.
    static func reach(atRadius r: CGFloat) -> Double {
        let d = Double(max(r, 0)) / Double(MandalaWorld.ringRadius(1))
        return 1 / (1 + falloff * d * d)
    }

    /// How much arrives at an enclosure. Ring 9 *is* the source, so it is 1.
    static func reach(ring: Int) -> Double {
        reach(atRadius: MandalaWorld.ringRadius(ring))
    }

    // MARK: - Refraction — the gem bends, it does not colour

    /// The gem's scattering for a ring. An indeterminate ring inherits the home
    /// ring's behaviour, exactly as ``HomeGem`` does — the light is never
    /// behaviourless.
    static func scatter(ring: Int) -> Double {
        HomeGem.behaviour[ring]?.diffuse ?? HomeGem.behaviour[2]!.diffuse
    }

    /// How far the arriving light pulls a hue toward the source: far, through a
    /// gem that barely scatters; hardly at all through one that scatters
    /// everything.
    static func refraction(ring: Int) -> Double {
        (1 - scatter(ring: ring)) * refractionLimit
    }

    /// Two hues mixed along the shorter arc of the wheel. `t` 0 keeps `a`
    /// whole; `t` 1 arrives at `b`.
    ///
    /// The shorter arc matters: `Atmosphere`'s ring hues sit at 2° and 341° as
    /// well as 194°, and a naive interpolation from 341 to 46 would travel
    /// backwards through every colour in between and turn a red seat green
    /// halfway.
    static func mix(_ a: HSL, _ b: HSL, _ t: Double) -> HSL {
        let k = HSL.clamp(t, 0, 1)
        var d = HSL.wrap(b.h - a.h)
        if d > 180 { d -= 360 }
        return HSL(h: HSL.wrap(a.h + d * k),
                   s: a.s + (b.s - a.s) * k,
                   l: a.l + (b.l - a.l) * k)
    }

    /// One Śakti's hue as it arrives through her enclosure's gem.
    func refracted(_ own: HSL) -> HSL {
        Self.mix(own, Self.source, Self.refraction(ring: ring))
    }

    /// The colour of one seat: her own hue — bright if she has been felt,
    /// plain if she has not — refracted through her ring, then lifted by
    /// however much of the source reaches her.
    ///
    /// `felt` is a `Bool` and there is no arithmetic behind it. Whether she has
    /// been felt is a state of the instrument and may be seen; how often is a
    /// measure and may not.
    func seatColor(own: HSL, felt: Bool) -> HSL {
        let base = felt ? HSL(h: own.h, s: min(own.s + 10, 88), l: min(own.l + 18, 78)) : own
        let r = refracted(base)
        return HSL(h: r.h,
                   s: min(r.s + 6 * reach, 90),
                   l: min(r.l + 8 * reach, 80))
    }

    /// The colour of an enclosure's own band — the ring shown empty, before any
    /// Śakti is seated in it. `Atmosphere`'s unjittered ring seed, refracted.
    var bandColor: HSL {
        let r = refracted(Atmosphere.ringHue(ring))
        return HSL(h: r.h, s: min(r.s + 8 * reach, 92), l: min(r.l + 10 * reach, 82))
    }

    /// How wide an enclosure's band of light stands, in points at unit scale.
    /// A gem that scatters throws a broad soft band; one that does not draws a
    /// narrow bright line. The gem's behaviour, doing the only work it is
    /// allowed to do.
    var bandWidth: Double { 1.1 + 6.0 * scatter }

    /// How far a seat's halo spreads, as a multiple of its own radius. Same
    /// law as the band, at seat scale.
    var glowSpread: Double { 2.4 + 1.6 * scatter }

    // MARK: - The veil

    /// The radius at which a walker counts as standing *at* an enclosure.
    ///
    /// Eight of the nine answer with their own radius. The Bindu has none — it
    /// is a point — so it answers with the half-step inside the eighth, which
    /// is the last place there is to be before arriving.
    static func veilRadius(ring: Int) -> Double {
        ring >= 9 ? Double(MandalaWorld.ringRadius(8)) * 0.5
                  : Double(MandalaWorld.ringRadius(ring))
    }

    /// How near the viewport stands to an enclosure, 0 (far outside) to 1 (at
    /// it, or fallen within).
    ///
    /// `viewportRadius` is the world-space reach of the viewport — the same
    /// quantity ``MandalaCamera/enteredRing(in:)`` reads to decide which
    /// enclosure has been crossed, so nearness and crossing can never disagree
    /// about where the walker is.
    static func nearness(ring: Int, viewportRadius: Double) -> Double {
        guard viewportRadius > 0 else { return 1 }
        return min(1, veilRadius(ring: ring) / viewportRadius)
    }

    /// How settled the glass is, 0 the moment it is touched, rising to 1 over
    /// ``stillnessSpan``.
    ///
    /// **The reduce-motion path is a real one.** It is not this function run at
    /// zero duration; it is the settled value itself, returned without
    /// consulting the clock at all. A walker who has asked for no motion gets a
    /// veil that simply *is* where it comes to rest — no creep, no timeline, no
    /// frame in which it is halfway.
    static func stillness(untouchedFor dt: TimeInterval, reduceMotion: Bool) -> Double {
        if reduceMotion { return 1 }
        guard dt > 0 else { return 0 }
        return min(1, dt / stillnessSpan)
    }

    /// How much of a ring's secrecy still stands, given where the walker is and
    /// how still she is being.
    ///
    /// Nearness is necessary and stillness finishes it: close but moving clears
    /// ``nearnessShare`` of the veil, close and settled clears all of it, and
    /// far away clears nothing however long you wait. Both terms are
    /// present-tense and both reset — which is the whole reason this is lawful.
    /// Nothing a walker has *done* appears in this arithmetic.
    static func veiling(ring: Int, viewportRadius: Double, stillness: Double) -> Double {
        let veil = HomeWorlds.ringCharacter[ring]?.veil ?? 0
        let near = nearness(ring: ring, viewportRadius: viewportRadius)
        let cleared = near * (nearnessShare + (1 - nearnessShare) * HSL.clamp(stillness, 0, 1))
        return veil * (1 - HSL.clamp(cleared, 0, 1))
    }

    /// A mark's opacity with the standing veil drawn across it.
    func veiledMark(_ base: Double) -> Double {
        base * (1 - veiling * Self.veilMarkDepth)
    }

    /// A word's opacity with the veil across it — dimmed less than a mark, and
    /// never below FIDELITY's floor for anything that was legible to begin
    /// with. Mist is not a licence to make a name unreadable.
    func veiledText(_ base: Double) -> Double {
        let v = base * (1 - veiling * Self.veilTextDepth)
        return base >= Self.legibleTextAlpha ? max(v, Self.legibleTextAlpha) : v
    }

    // MARK: - Tratak (idea 38)

    /// When the gaze has held long enough for the field to begin holding still,
    /// and when it has held completely.
    static let tratakOnset: TimeInterval = 20
    static let tratakFull: TimeInterval = 45

    /// How far into the gaze the instrument has come, 0 before the onset and 1
    /// once it is whole.
    ///
    /// Earned by stillness and by nothing else — never by a tap, never by a
    /// count, and it falls back to nothing the instant the glass is touched.
    /// The thresholds are the same under reduce motion: the phenomenon is not
    /// handed over early to a walker who asked for less movement, it is simply
    /// drawn without moving.
    static func tratak(untouchedFor dt: TimeInterval) -> Double {
        guard dt > tratakOnset else { return 0 }
        return min(1, (dt - tratakOnset) / (tratakFull - tratakOnset))
    }

    /// Tratak as it is actually *shown*.
    ///
    /// With motion it comes up across the gaze. Under reduce motion there is no
    /// coming-up at all: the phenomenon is **absent until the gaze is whole and
    /// then simply there**, in one step, with no ramp to watch. That is a still
    /// path rather than a slow one — a twenty-five-second fade is still a fade,
    /// and a walker who asked for no movement should not be given the longest
    /// one in the app.
    ///
    /// It is never *earlier* than everyone else's, only later, which is the
    /// whole of "earned, and not handed over early".
    static func tratak(untouchedFor dt: TimeInterval, reduceMotion: Bool) -> Double {
        let gazed = tratak(untouchedFor: dt)
        return reduceMotion ? (gazed >= 1 ? 1 : 0) : gazed
    }

    // MARK: - The phase flag

    /// Phase 5's one switch. Default **off**; `MANDALA_LIGHT=on` as a launch
    /// argument turns it on for the UI suite.
    ///
    /// One flag for the whole phase, read in one file (`LivingMandalaView`),
    /// because 27, 28 and 30 are physically one render pass: you cannot switch
    /// the veil off and leave the Bindu as the source without keeping a second
    /// lighting path, and a second path is a second thing to hold above the
    /// legibility floor, correct under reduce motion and correct for a voice.
    /// The falling mantra rides the same switch, because a descent that speaks
    /// the yantra's bīja while the enclosures are still thin gold strokes is a
    /// half-instrument nobody should see, including the suite.
    static let enabled: Bool = ProcessInfo.processInfo.arguments.contains("MANDALA_LIGHT=on")
}

// MARK: - The field

/// Every enclosure's light at one moment — nine ``MandalaLight`` values built
/// from where the camera is and how long the glass has lain untouched.
///
/// Built once per drawn frame rather than per seat: the arithmetic is nine
/// short float expressions, and building it per seat would run it a hundred and
/// two times for nine answers.
struct MandalaLightField: Equatable {

    /// The world-space reach of the viewport.
    let viewportRadius: Double
    /// 0…1, how settled the glass is.
    let stillness: Double
    /// 0…1, how far into the gaze the instrument has come.
    let tratak: Double

    private let rings: [MandalaLight]

    init(viewportRadius: Double, stillness: Double, tratak: Double = 0) {
        self.viewportRadius = viewportRadius
        self.stillness = stillness
        self.tratak = HSL.clamp(tratak, 0, 1)
        self.rings = HomeWorlds.rings.map { ring in
            MandalaLight(
                ring: ring,
                reach: MandalaLight.reach(ring: ring),
                scatter: MandalaLight.scatter(ring: ring),
                veil: HomeWorlds.ringCharacter[ring]?.veil ?? 0,
                veiling: MandalaLight.veiling(ring: ring,
                                              viewportRadius: viewportRadius,
                                              stillness: stillness))
        }
    }

    /// The light at one enclosure. An indeterminate ring answers with the home
    /// ring's, so a seat whose ring never synced is lit rather than black.
    func light(ring: Int) -> MandalaLight {
        guard ring >= 1, ring <= rings.count else { return rings[1] }
        return rings[ring - 1]
    }
}
