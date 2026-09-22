import Foundation

// MARK: - RINGS 3–9 · what the six outer archetypes share, and no more
//
// Ring 1 is three families and Ring 2 is the crossing, and both of them are
// built. What is left is the outer climb — six archetypes across fifty-eight
// seats, each of them one builder in `homes-grammar.js`:
//
//   · ring 3 · the Anaṅgas    → BODILESS   effect with no source
//   · ring 4 · Sampradāya     → COSMIC     one gesture at the scale of worlds
//   · ring 5 · Kulottīrṇa     → GIVING     something arrives, from beyond
//   · ring 6 · Nigarbha       → REVEALING  it was already here; the veil thins
//   · ring 7 · the Vāsinīs    → SOUNDING   the room is made of her syllable
//   · ring 8 · the Triad      → SOURCING   will, act, form at the origin
//   · ring 9 · the Bindu      → authored; the grammar declines to speak for her
//
// This file is to those six what ``RingOne`` is to the first ring's three, and
// for the same reason: it holds **the arithmetic all six need and nothing about
// what any of them does**. A shared helper that knew what a room looked like
// would be the one generic physics Design's own verification pass found under
// seventy-eight of its hundred and two rooms, arriving through the back door.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY THERE IS ONE FILE AND NOT SIX COPIES OF EIGHT LINES
// ─────────────────────────────────────────────────────────────────────────────
//
// Every finding the first two rings paid for in renders applies unchanged to all
// six of these, and the instrument has already paid twice for a rule that was
// written down twice — the body zones, ported on two branches and unified
// afterwards, and the grain floor, written in ``RingOne`` and then needed again
// by ``CrossingRoom``. So the four findings live here once:
//
//   1. **A mark is a fraction of the body, not of the surface.** ``CrossingRoom``
//      ruled it: the same arc read against the *surface* came out four times
//      smaller on a ceiling than on a face, and on a face every ring she pressed
//      was shallower than the stone's own grain. *Seven rings, buried.*
//   2. **A layout is brought into the picture**, and where a figure does not fit
//      the **whole figure** is scaled rather than its parts clamped
//      (``Figure``). Ring 1's first render is the evidence.
//   3. **A mark narrower than one mesh cell is absent, not faint**
//      (``RoomInscription/narrowestMark``), and **a mark shallower than the
//      stone's own grain cannot be seen** (``RoomInscription/depth(size:on:)``).
//   4. **Her physics is read on her own clock** (``readOver``), because a kernel
//      that turns at 0.03–0.6 radians a second has barely moved across the
//      quarter-second a *gesture* is read over, and a family read at a gesture's
//      rate comes back speaking one verb.
//
// ``RingOne`` now forwards to this file rather than carrying its own copy, so
// there is one implementation and Ring 1 keeps the names its rooms and its
// suites speak in.
//
// ─────────────────────────────────────────────────────────────────────────────
// TWO FACTS ABOUT THE SPINE, BEFORE THE NEXT FIVE PASSES
// ─────────────────────────────────────────────────────────────────────────────
//
// **A mechanism may mark any surface except the enclosure.** `actions(at:stage:)`
// returns a dictionary over all four kinds, and ``RoomScene`` carries marks on the
// floor, the canopy and the working face — its `litSurfaces` is a list precisely so
// a mechanism can mark stone her attribute never touches. The **wall** is the one
// exception, and it is a fact about the scene rather than a rule: `buildWalls`
// takes no morph targets, so an action keyed to `.wall` is computed and never
// drawn. ``RoomReversal`` already refuses to mark one — an enclosure that answers
// does so by *moving* — and a room that wants its sides to do something wants
// ``RoomSurfaceMechanism/stations(at:stage:)``.
//
// **Her attribute stands at the centre of every room.** ``RoomInscription`` mounts
// it at ``RoomPlacement/coordinate``, which is also where the ember stands and
// where a reversal opens its answering mark. A figure laid out around her placement
// therefore has her attribute inside it, in all 102 rooms and by Design's own
// arrangement — so a check about what the **room** does reads the mechanism rather
// than the finished surface (``OuterRingStage/marks(room:at:)``).
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ONE THING THIS FILE ADDS THAT NEITHER BUILT RING NEEDED
// ─────────────────────────────────────────────────────────────────────────────
//
// **``spread(index:of:kind:)``** — Design's `ph + i / n`, read against her own
// kernel's turn rather than typed.
//
// Every one of the six outer builders stands `n` parts around a turn and phases
// them by `i / n`: eight petals in BODILESS, fourteen shells in COSMIC, twelve
// gifts in GIVING, ten in REVEALING, her mode's nodes in SOUNDING, three corners
// in SOURCING. Written literally, that is an **identity** for half the kernel's
// fifty-one kinds: their terms are all `|sin|`, whose period is half a turn of
// phase, so parts `i` and `i + n/2` come back exactly the same number and a ring
// of eight moves as four pairs.
//
// That is ``CrossingRoom``'s own finding — *"where a half turn says nothing, a
// quarter does"* — arriving at every outer archetype at once, and it is read off
// the kernel by ``HomeGrammar/counterPhase(of:)`` rather than from a table of
// which kinds fold. Design's `i / n` is unchanged everywhere it says something;
// what is read is *how much of a turn a turn is* for this Śakti's physics.
enum OuterRings {

    /// The rings this file is the ground for. Ring 9's room is authored, so the
    /// grammar speaks for six archetypes across rings 3–8; the ninth is here in
    /// the range because a check that walks the outer climb walks all of it.
    static let rings = 3...9

    /// The six archetypes the outer climb is built from, in ring order.
    static let archetypes: [HomeArchetype] = [.bodiless, .cosmic, .giving,
                                              .revealing, .sounding, .sourcing]

    // MARK: - Design's room, in this one

    /// Design's own body span in a room of this ring — `(0.5 - alt) * 9` in rings
    /// 1–3 and `* 8` from ring 4 outward, whose whole range is 9 or 8. Read off
    /// ``RoomUnits/grammarSpan(ring:)`` rather than typed, so a change in the
    /// grammar arrives here instead of being missed.
    ///
    /// **The divisor changes at ring 4 and that is not a detail.** A length read
    /// against 9 when the room's own curve says 8 is out by an eighth in every
    /// mark of every room from Sampradāya outward, which is the difference
    /// between a figure that fits the picture and one that does not.
    static func designSpan(ring: Int) -> Double { RoomUnits.grammarSpan(ring: ring) }

    /// A length in Design's room, in this one's scene units.
    ///
    /// **Against the body**, which is the one thing the two rooms both have: the
    /// crown-to-soles span is Design's 9 or 8 and ``RoomUnits/roomHeight`` here.
    static func inRoom(_ designUnits: Double, ring: Int) -> Double {
        let span = designSpan(ring: ring)
        guard span != 0 else { return 0 }
        return designUnits / span * RoomUnits.roomHeight
    }

    // MARK: - What the material can carry

    /// The widest any one mark of an outer room may open, in the surface's own
    /// coordinates. ``RoomReversal/answeringSpan`` is the instrument's answer to
    /// how wide a mark may be; a mark the *premise* makes is one of several, so
    /// it gets half of it.
    static let widestMark: Double = RoomReversal.answeringSpan / 2

    /// **The narrowest a mark may be and still be a mark**: one cell of the
    /// surface's own mesh, from ``RoomInscription/narrowestMark``. A mark with no
    /// vertex inside it moves no material, and because light here is only ever a
    /// property of a disturbance it emits nothing either. It is not faint, it is
    /// absent.
    static var narrowestMark: Double { RoomInscription.narrowestMark }

    /// A reach the material can actually carry: never wider than ``widestMark``,
    /// never narrower than ``narrowestMark``.
    ///
    /// **A withdrawal is applied after this and never inside it.** A floor
    /// underneath a withdrawal holds the mark open instead of letting it leave —
    /// measured in Ring 1, where the capacity Design shrinks by four fifths came
    /// back the size it began.
    static func reach(_ surfaceUnits: Double) -> Double {
        min(widestMark, max(narrowestMark, surfaceUnits))
    }

    /// How deep a mark goes, and the floor no mark falls below — the grain, from
    /// ``RoomInscription/depth(size:on:)``. Named here so an outer room reads the
    /// same word its sisters in Ring 1 do.
    static func depth(size: Double, on material: RoomMaterial) -> Double {
        RoomInscription.depth(size: size, on: material)
    }

    /// **How much clear material one mark needs around it before another mark's
    /// stroke can reach it**, in the surface's own coordinates.
    ///
    /// Three of the five verbs are round and are nothing well inside their own
    /// reach, but a **furrow** holds its whole depth for the length of its stroke
    /// and a **crack** is still at a quarter of its own where it closes — both of
    /// them run ``SurfaceAction/cutoffReaches`` of their reach *along* the stroke.
    /// So a figure that means to leave a place empty has to stand its parts at
    /// least this far off it, and a figure whose parts are closer is one whose
    /// marks are writing on each other.
    ///
    /// Phase 3.6 found this the hard way and it is here because every outer ring
    /// lays out a figure: the eight effects of a bodiless room stand on Design's
    /// ring of 5.4 with a sprite span of 4.2, and a mark of that size makes a
    /// stroke **longer than the ring is wide** — so the two effects whose stroke
    /// happens to point at the middle lit the absence they were standing around,
    /// measured at 0.55 of full emission in the one place the room's whole
    /// sentence needs dark.
    static func clearance(ofReach reach: Double) -> Double {
        reach * SurfaceAction.cutoffReaches
    }

    /// **How far her physics carries a thing along the plane it is acting in**,
    /// per unit of amplitude — measured from the kernel rather than bounded by
    /// ``HomeGrammar/widestTerm``.
    ///
    /// A room that lays out a figure and means to keep a place empty has to know
    /// two things: how long a mark's stroke is (``clearance(ofReach:)``) and how
    /// far her motion can carry that mark *toward* the place. Bounding the second
    /// by the kernel's widest term would open every ring to the widest kind's
    /// excursion, so a Śakti whose physics barely moves would stand in the same
    /// room as one whose physics is Mahat's widening — and the whole point of the
    /// kernel is that she does not.
    ///
    /// Design's two in-plane axes are `x` and `z`; `y` leaves the plane. Asked of
    /// the kernel over a long window at unit amplitude, once, so a new kind
    /// arrives here by itself.
    static let inPlaneExcursion: [HomePhysics: Double] = {
        var out: [HomePhysics: Double] = [:]
        for kind in HomePhysics.allCases {
            var far = 0.0
            for step in 0...1200 {
                let d = HomeGrammar.displace(kind, time: Double(step) * 0.25,
                                             phase: 0, amplitude: 1)
                far = max(far, (d.x * d.x + d.z * d.z).squareRoot())
            }
            out[kind] = far
        }
        return out
    }()

    /// The same, at a room's own amplitude.
    static func inPlaneExcursion(_ kind: HomePhysics, amplitude: Double) -> Double {
        (inPlaneExcursion[kind] ?? HomeGrammar.widestTerm) * abs(amplitude)
    }

    /// One part's share of the light, so that `count` parts converging do not
    /// stack to a flat field. The same root ``RoomInscription`` shares one mark's
    /// worth of material among a rosary's beads by.
    static func lightShare(of count: Int) -> Double {
        1 / Double(max(1, count)).squareRoot()
    }

    // MARK: - A figure, brought into the picture

    /// **A figure, brought into the picture the walker is actually looking at.**
    ///
    /// ``RingOne/Figure``'s reasoning, with the ring as a parameter because the
    /// outer climb's altitude span is 8 rather than 9 from ring 4 outward. Two
    /// bounds apply and Ring 1's first render broke both: the **material** — a
    /// working face is one body square — and the **frame**, which is the tighter
    /// of the two. At the distance a face settles to the picture is 2.6 units
    /// tall and 1.3 across, and Design's figures are halls.
    ///
    /// A figure that does not fit is **scaled as a whole** — its layout and the
    /// size of its parts by the same number — and never clamped part by part. A
    /// ring whose marks are clamped onto the edge of the material is not a ring,
    /// it is a heap, and a heap is the same heap in every room of the ring.
    ///
    /// The distance is read at the **end** of the stay, where the room is nearest
    /// and the picture smallest, so a figure has one size for the whole visit. A
    /// figure that resized as the room came toward him would be a zoom, and
    /// nothing in Design's rooms zooms.
    struct Figure {
        /// Which ring's own body span the design units are read against.
        let ring: Int
        /// `1` where Design's figure already fits.
        let scale: Double
        private let material: RoomMaterial

        init(ring: Int, spread: Double, part: Double,
             on material: RoomMaterial, bodyAltitude: Double) {
            self.ring = ring
            self.material = material
            let want = OuterRings.inRoom(abs(spread), ring: ring)
                + OuterRings.inRoom(abs(part), ring: ring) / 2

            // What the material can hold: half the surface is the furthest the
            // figure's outer edge can stand from its centre and still be inside
            // it at both ends. ``RoomReversal/answeringSpan``'s own reasoning.
            let onSurface = RoomReversal.answeringSpan * material.span

            // …and what the walker can see of it, where the room has come as near
            // as it ever comes.
            let settled = RoomUnits.placement(bodyAltitude: bodyAltitude,
                                              chamberTime: HomeMemory.secondAdaptationEnd)
            let inFrame = RoomUnits.visibleHalfWidth(
                atDistance: RoomUnits.distance(fromEyeTo: settled))

            let room = min(onSurface, inFrame)
            self.scale = want > room && want > 0 ? room / want : 1
        }

        /// A length in Design's room, in this one's scene units.
        func length(_ designUnits: Double) -> Double {
            OuterRings.inRoom(designUnits, ring: ring) * scale
        }

        /// A size in Design's room, in this surface's own coordinates — and never
        /// narrower than the material can carry, because a figure scaled down to
        /// fit the picture has scaled its marks down with it.
        func reach(_ designUnits: Double) -> Double {
            OuterRings.reach(material.reach(worldUnits: length(designUnits)))
        }
    }

    // MARK: - The clock an outer room is read on

    /// **How long a reading of a moving part is taken over.**
    ///
    /// ``RoomInscription/sampleGap`` is a quarter of a second because Design's
    /// twenty-six attribute forms are *gestures*, and a gesture moves at the rate
    /// a quarter of a second can see. Her physics does not: the displacement
    /// kernel's terms turn at between 0.03 and 0.6 radians a second, so a mark
    /// sampled at a gesture's rate has barely moved, every one of the fifty-one
    /// kinds classifies below ``RoomInscription/workingSpeed``, and a whole ring
    /// comes back speaking one verb — which is a ring with no physics.
    ///
    /// ``CrossingRoom/readOver``'s finding, which ``RingOne`` inherited and the
    /// outer six inherit here rather than rediscovering.
    static let readOver: TimeInterval = HomeMemory.firstAdaptation / 4

    // MARK: - Design's `i / n`, read against her own kernel

    /// **Where the `index`-th of `count` parts stands in her own turn.**
    ///
    /// Design writes `ph + i / n` in every one of the six outer builders. That is
    /// a full turn of *phase* shared out among `n` parts — and for half the
    /// kernel's kinds a full turn of phase is **two** turns of the kernel,
    /// because their terms are all `|sin|` and fold at half a turn. Written
    /// literally, a ring of eight petals whose physics is Water's welling or
    /// Earth's settling moves as four identical pairs.
    ///
    /// So the parts are spread across **one turn of the kernel** rather than one
    /// turn of phase, and how much of a turn that is, is asked of the kernel:
    /// ``HomeGrammar/counterPhase(of:)`` already answers *how far out of step is
    /// as far as this kind can be*, which is half a cycle, so a whole cycle is
    /// twice it. For every kind that does not fold this returns Design's `i / n`
    /// exactly, to the last bit.
    ///
    /// Nothing here consults a name, and there is no table of which kinds fold —
    /// one would drift the moment a kind was added.
    static func spread(index: Int, of count: Int, kind: HomePhysics) -> Double {
        guard count > 0 else { return 0 }
        return Double(index) / Double(count) * 2 * HomeGrammar.counterPhase(of: kind)
    }

    // MARK: - Where one part of a room's work stands

    /// One part of an outer room's work, in the coordinates of the surface it is
    /// happening to: two numbers along the surface, and one **into** it.
    ///
    /// **There is no third axis here that could name a point in the air.** `into`
    /// is not a height — it is how far the part's own travel has carried it
    /// against the material, which is how deep the mark it is making goes. A
    /// part's place is still two numbers on a surface, exactly as
    /// ``SurfaceCoordinate`` allows and no further.
    struct Place: Equatable {
        var at: SurfaceCoordinate
        /// How far the part has travelled along the surface's own normal, in
        /// scene units. Negative is into the material.
        var into: Double

        init(at: SurfaceCoordinate, into: Double) {
            self.at = at
            self.into = into
        }

        /// Drawn toward another place, `0` where it stands and `1` on top of it.
        func drawn(toward target: Place, by amount: Double) -> Place {
            let b = min(1, max(0, amount))
            return Place(at: SurfaceCoordinate(u: at.u * (1 - b) + target.at.u * b,
                                               v: at.v * (1 - b) + target.at.v * b),
                         into: into * (1 - b) + target.into * b)
        }
    }

    /// A part's place, as the classifier reads a moving part: `y` is always the
    /// way out of the material, so *down onto the stone* means the same thing on
    /// a floor, a ceiling and a working face.
    ///
    /// **In scene units, and the conversion is not cosmetic.**
    /// ``RoomInscription/workingSpeed`` and ``RoomInscription/strikeSpeed`` are
    /// distances the room is measured in; a surface coordinate is a fraction of a
    /// surface, and a floor and a working face differ by a factor of four in
    /// span. Handing the classifier fractions would make the same travel read as
    /// four different speeds depending on where on her body she is felt.
    static func motion(_ place: Place, span: Double) -> AttributeMotion {
        AttributeMotion(x: place.at.u * span, y: place.into, z: place.at.v * span)
    }

    /// How far a part's travel has carried it **against** the stone, `-1` drawn
    /// back out of it to `+1` driven into it.
    ///
    /// Read against ``HomeGrammar/widestTerm`` rather than against the amplitude
    /// the kernel was handed: the kernel multiplies its amplitude by as much as
    /// 2.2, so normalising by the amplitude alone leaves the fast axes railed at
    /// ±1 for most of every turn — and a mark that is railed has stopped carrying
    /// her phase at all.
    static func pressed(_ into: Double, travel: Double) -> Double {
        min(1, max(-1, -into / max(travel * HomeGrammar.widestTerm, 0.0001)))
    }

    /// One part of a room's work, as one action on the material.
    ///
    /// The verb is ``RoomInscription``'s, read from this part's own travel over
    /// her own clock — nothing here is assigned by name, in any archetype. The
    /// depth is the instrument's own ``RoomInscription/markDepth``, floored at
    /// the stone's grain and leaning with how hard the part is bearing on it. And
    /// the light is the surface's, which is to say it exists exactly as far as the
    /// surface moved.
    static func mark(_ here: Place, from before: Place,
                     reach: Double, size: Double, travel: Double, glow: Double,
                     material: RoomMaterial) -> SurfaceAction {
        let lean = 0.55 + 0.45 * pressed(here.into, travel: travel)
        let depth = OuterRings.depth(size: min(1, max(0.2, size)) * lean, on: material)

        let now = motion(here, span: material.span)
        let then = motion(before, span: material.span)
        switch RoomInscription.verb(for: now, previous: then) {
        case .impression: return .impression(at: here.at, reach: reach, depth: depth, glow: glow)
        case .furrow:     return .furrow(at: here.at, reach: reach, depth: depth, glow: glow)
        case .crack:      return .crack(at: here.at, reach: reach, depth: depth, glow: glow)
        case .swell:      return .swell(at: here.at, reach: reach, depth: depth, glow: glow)
        case .compaction: return .compaction(at: here.at, reach: reach, depth: depth, glow: glow)
        }
    }

    // MARK: - Which room an outer seat gets

    /// **The outer climb's dispatch, and the one place a built archetype is
    /// named.**
    ///
    /// ``RoomMechanisms/forRoom(_:)`` asks this before it falls back to the bare
    /// archetype turn, so each of the six rings arrives by changing exactly one
    /// line here — its own — rather than by six passes over the same `switch` in
    /// ``RoomReversal``. The archetype was decided by
    /// ``HomeGrammar/archetype(ring:position:)`` from her ring and her position
    /// alone, which is the only key the laws allow; nothing here consults a name.
    ///
    /// `nil` means *not built yet*, and a seat whose archetype is still `nil`
    /// keeps her ring's own reversal rather than none — a room that does not
    /// reverse is a loop, and a half-built outer climb must not cost the rings
    /// behind it the turn they already had.
    static func outerRoom(_ reading: HomeGrammar.Reading) -> RoomSurfaceMechanism? {
        switch reading.archetype {
        case .bodiless:  return BodilessRoom(reading)   // ring 3 · Phase 3.6, built
        case .cosmic:    return nil                     // ring 4 · Sampradāya
        case .giving:    return nil                     // ring 5 · Kulottīrṇa
        case .revealing: return nil                     // ring 6 · Nigarbha
        case .sounding:  return SoundingRoom(reading)   // ring 7 · Phase 3.6, built
        case .sourcing:  return nil                     // ring 8 · the Triad
        case .siddhi, .matrka, .mudra, .crossed: return nil
        }
    }
}
