import Foundation

// MARK: - RING 1 · the ten Mudrās · the room that is a seal you stand inside
//
// Design's `mudra(world, card, G)`, built on the Phase 3.1 spine. Its own header
// and its own label are the whole design:
//
//     // five fingers of the seal, as vaults you stand between
//     label: `${low(card.quality)} · a seal you stand inside`
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ANICONIC LAW IS AT ITS MOST EXPOSED HERE, AND THIS IS HOW IT IS HELD
// ─────────────────────────────────────────────────────────────────────────────
//
// A mudrā **is** a hand gesture in the tradition. Law 4 says no figural imagery
// for any Śakti: forms are shapes performing actions. Those two facts meet in
// this one family and nowhere else in the instrument, so the reading is written
// down rather than left to taste.
//
// Design already resolves it, in its own comment: the five are *"as vaults you
// stand between"*. Not five fingers drawn; five **arches**, springing from a ring
// of the room's own floor at radius 5 and opening to radius 9 while they rise
// nine and arch over. The walker stands **among** them — Design's `a = -0.9 +
// (i/4) * 1.8` spreads them a hundred and three degrees across the room, with him
// inside the fan — and what a fan of equal arches over your head reads as is a
// vault, which is what Design calls it.
//
// Three properties keep that reading, and each of them has a test:
//
//   1. **The five are mirror-symmetric about the walker's own axis.** Design's
//      own angles are `±0.9, ±0.45, 0`. A hand is chiral — the thumb is what
//      makes it one — so a five that is its own mirror image is not a hand, and
//      cannot be made into one without failing
//      `testTheSealIsMirrorSymmetricAndSoIsNotAHand`.
//   2. **The five are the same span, and none of them tapers.** Design's tube is
//      one constant radius over one constant curve; digits differ in length and
//      taper to a tip. Nothing here does either.
//   3. **The fan has no centre.** A hand has a palm joining its five at the base;
//      this fan's feet stand on a ring of radius 5 around a centre where nothing
//      is ever marked, because the walker is standing there. What the seal holds
//      is seven units further off, beyond the fan, not between its feet.
//
// This file therefore names no digit, no finger and no hand, and neither does the
// room's own second sentence: Design's `'the seal has opened its hand'` is a
// walker-facing string naming a body part in the one family where the law is
// fragile, and ``HomeGrammar/tag(for:position:bija:quality:tattva:)`` now says
// *"the seal has opened, and let go of what it held"*, which is the same event
// with the figure taken out of it. Where Design's words and law 4 disagree, the
// law wins (charter §2).
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT MAKES THIS ROOM A MUDRĀ AND NOT A SIDDHI OR A MĀTṚKĀ
// ─────────────────────────────────────────────────────────────────────────────
//
// Ring 1 is three families, and the brief asks for three passes rather than one
// pass of twenty-eight precisely so that they cannot blur. The difference is not
// a tuning; it is what the room *is*:
//
//   · a **Siddhi** is a power exercised — one capacity, and the room performing
//     it again a moment later and further off (``SiddhiRoom``);
//   · a **Mātṛkā** is a sound that makes — a closed ring of `n` letters standing
//     around the walker, one of them being spoken at any instant
//     (``MatrkaRoom``);
//   · **a Mudrā is a sealing** — five arches closed around what they hold, and a
//     walker standing inside the closure. Nothing in a Mudrā's room repeats, and
//     nothing in it goes round. It **encloses**, and at the turn it **opens**.
//
// Read as arrangements: the Siddhi is a train receding down one line; the Mātṛkā
// is a closed ring with a travelling point of light on it; the Mudrā is an open
// fan with one thing beyond it. No two of the three could be mistaken for each
// other at any moment of any stay, and
// `testTheThreeFamiliesSeparateMoreThanSistersDo` measures exactly that.
//
// ─────────────────────────────────────────────────────────────────────────────
// THREE READINGS OF DESIGN THIS FILE MAKES
// ─────────────────────────────────────────────────────────────────────────────
//
// **1 · A vault springs from the stone and lifts clear of it.** Design's arch
// rises nine units over a room that has air in it; this instrument's rooms have
// surfaces and nothing else, and ``RingOne/Place`` has no third axis that could
// name a point in the air — deliberately (Phase 3.1's binding condition). So how
// far the arch stands off its surface is carried as **how much of a mark it
// makes there**: full where it springs, and fading to the stone's own grain at
// the crown. That is a vault seen in the floor it rests on, which is what a vault
// is, and it costs the room nothing Design drew.
//
// **2 · The seal opens by pivoting where it springs.** Design's
// `d0.rotation.x = b * 0.42 * (1 + i * 0.1)` rotates each tube about its own
// local x, which mixes the room's height and its depth: the arch tips over, its
// crown dropping and travelling, and the outer vaults tipping furthest. It is
// carried as that rotation, taken about the vault's own foot so the seal opens
// rather than slides — and it is monotone in the second adaptation, which is what
// makes `testTheSealOnlyEverOpens` able to say that this room never grips.
//
// **3 · What the seal holds is let go, and its light goes with it.** Design's
// `held.scale.setScalar(… + b * 3.6)` on a sprite whose opacity is
// `0.5 + 0.3 * k - b * 0.2`. Carried literally, that is a lit area growing
// four-and-a-half-fold on the surface the walker is looking at, which is the
// pale structureless wash ``PressRoom`` found with a picture and ``CrossingRoom``
// and ``MatrkaRoom`` each found again by a different door. So the opening is
// **bounded by the seal's own foot** — what it held may open until it fills the
// ring the vaults spring from and no further, because past that nothing is
// holding it — and the rest of Design's 3.6 is spent where the instrument already
// spends it: ``HomeBecoming/archetype(_:)`` gives this archetype `takes: -3.6`,
// so the canopy travels away by 0.78 of its own clearance and the enclosure gives
// up 0.2 of its. The room opens; the picture does not wash out.
struct MudraRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 19–28. The only key.
    let position: Int
    /// Her physics, classified from her own tattva and quality.
    let physics: HomePhysics
    /// Her turn of the ten — Design's `(card.pos % 10) / 10`.
    let phase: Double

    init(_ reading: HomeGrammar.Reading) {
        self.position = reading.position
        self.physics = reading.physics
        self.phase = reading.phase ?? 0
    }

    // MARK: - Design's own numbers

    /// Five. Design's `for (let i = 0; i < 5; i++)`.
    static let vaults = 5

    /// How far across the room the fan is spread: Design's
    /// `a = -0.9 + (i / 4) * 1.8` — a hundred and three degrees, symmetric about
    /// the walker's own axis, with him inside it.
    static let fan: Double = 0.9

    /// Where a vault springs from and where it opens to: Design's `5 + u * 4`.
    static let footRadius: Double = 5
    static let mouthRadius: Double = 9

    /// The arch itself: Design's `y - 4 + u * 9 - u² * 3.4`. It springs four
    /// below her own altitude, rises nine, and arches over by three and a half.
    static let springs: Double = -4
    static let rises: Double = 9
    static let arches: Double = 3.4

    /// …and how far in front of her the whole fan stands, leaning further off as
    /// it opens: Design's `- 4 - u * 2`.
    static let standsBefore: Double = -4
    static let leansAway: Double = 2

    /// One vault, across: Design's `TubeGeometry(curve, 32, 0.34, 8, false)`.
    static let vaultRadius: Double = 0.34

    /// **How finely a vault is sampled, and why it is not Design's number.**
    ///
    /// Design draws a continuous tube. The five verbs have none — *"the
    /// vocabulary has no verb for a line, so a line is made of the verb there is,
    /// overlapping along its own length"* (``PressRoom``, and ``EndlessRoom``
    /// after it). A vault runs between 5.99 and 6.52 units in Design's room, so
    /// at seventeen samples its neighbours stand 0.41 apart and Design's own
    /// radius of 0.34 comfortably covers the half-step between them: the span
    /// reads as one arch rather than as a row of beads. It is near the coarsest
    /// sampling at which that is true, which is the only reason it is not larger
    /// — five vaults at Design's own tubular resolution of 32 would be a hundred
    /// and sixty-five marks to carry a shape eighty-five already carry.
    static let vaultSamples = 17

    /// **How far apart in time two neighbouring vaults are.** Design's
    /// `displace(kind, t - i * 0.3, ph, 1.4)` — the seal does not move as one
    /// body, it closes the way a closure closes.
    static let vaultLag: TimeInterval = 0.3

    /// Design's displacement amplitude in this room — `displace(kind, …, 1.4)`.
    static let travel: Double = 1.4

    /// Design damps the drift along the room's own depth — `d[2] * 0.6` — so the
    /// fan keeps its spread rather than shuffling through itself.
    static let driftDepthDamping: Double = 0.6

    /// **How far the seal opens once the premise turns, and how much further the
    /// outer vaults go than the inner ones.** Design's
    /// `d0.rotation.x = b * 0.42 * (1 + i * 0.1)`.
    static let opens: Double = 0.42
    static let opensFurther: Double = 0.1

    /// Design's own emissive ramp on a vault — `0.7 + k * 0.8 + b * 2.2` —
    /// against its own ceiling, so it reads as a share of the light rather than
    /// as a three.js intensity.
    static let vaultAtRest: Double = 0.7
    static let vaultSettling: Double = 0.8
    static let vaultDeep: Double = 2.2
    static let vaultCeiling: Double = 0.7 + 0.8 + 2.2

    /// **What the gesture holds — the thing it is a seal OF.** Design's
    /// `held.position.set(0, y, -7)` on a sprite of 4.4, breathing at
    /// `1 + 0.14 * sin(t * 0.2)`, and opening by `b * 3.6` as the seal lets go.
    static let heldStands: Double = -7
    static let heldSize: Double = 4.4
    static let heldBreathes: Double = 0.14
    static let heldBreathRate: Double = 0.2
    static let heldOpens: Double = 3.6

    /// Design's own ramp on what it holds — `0.5 + 0.3 * k - b * 0.2` — against
    /// its own ceiling. It is the one light in Ring 1 that **falls** as the
    /// premise turns, and it falls because the thing is being let go.
    static let heldAtRest: Double = 0.5
    static let heldSettling: Double = 0.3
    static let heldReleases: Double = 0.2
    static let heldCeiling: Double = 0.5 + 0.3

    // MARK: - What the premise becomes

    /// **The seal has opened, and let go of what it held.**
    ///
    /// Read from ``HomeBecoming/archetype(_:)``, which holds Design's own two
    /// numbers for this archetype: the enclosure the walker was sealed inside
    /// gives up a fifth of its clearance, and the canopy travels away by
    /// `3.6 / 4.6` of its own — Design's `held.scale.setScalar(… + b * 3.6)`,
    /// upward and out, which is where a seal's contents go when it opens.
    var becoming: HomeBecoming { .archetype(.mudra) }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep
        let axes = RoomUnits.axes(of: surface)
        let centre = stage.placement.coordinate

        // The whole seal as one figure — the fan out to its mouth, and what it
        // holds — brought into the picture the walker is actually looking at.
        let figure = RingOne.Figure(spread: Self.mouthRadius,
                                    part: Self.heldSize,
                                    on: material,
                                    bodyAltitude: stage.placement.bodyAltitude)

        // The room has six things in it: five vaults, and what they hold. One
        // thing's share of the light is one of six, and one sample's share of its
        // own vault's light is one of seventeen — ``RingOne/lightShare(of:)``,
        // which is ``RoomInscription``'s own arithmetic for a form with parts,
        // applied at the two levels this room actually has.
        let share = RingOne.lightShare(of: Self.vaults + 1)
        let perSample = RingOne.lightShare(of: Self.vaultSamples)

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(Self.vaults * Self.vaultSamples + 1)

        // ── what the seal holds ─────────────────────────────────────────────
        //
        // One mark, seven units beyond the fan, breathing on Design's own slow
        // sine from the first moment. It is **not** between the vaults' feet —
        // the walker is standing there, and a fan with something in its middle is
        // the one arrangement this family must never make (see the header).
        //
        // It is an **impression**: pressed in and held, which is what a seal does
        // to what it seals. As the premise turns it opens — bounded by the ring
        // the vaults spring from, because past that nothing is holding it — while
        // its own light falls on Design's own ramp. Opening and dimming at once is
        // what makes this a release rather than a wash.
        let breath = 1 + Self.heldBreathes * sin(chamberTime * Self.heldBreathRate)
        let wants = material.reach(worldUnits: figure.length(Self.heldSize / 2))
            * breath * (1 + b * Self.heldOpens)
        let heldReach = min(figure.reach(Self.footRadius), min(RingOne.widestMark, wants))
        let heldGlow = max(0, Self.heldAtRest + Self.heldSettling * k
                           - b * Self.heldReleases) / Self.heldCeiling
        let beyond = figure.length(Self.heldStands)
        marks.append(.impression(
            at: SurfaceCoordinate(u: centre.u,
                                  v: centre.v + material.reach(
                                    worldUnits: axes.along(design: beyond, rise: -beyond))).clamped,
            reach: heldReach,
            depth: RingOne.depth(size: 1, on: material),
            glow: heldGlow * share))

        // ── and the five vaults closed around him ───────────────────────────
        //
        // Each springs from the ring at radius five and opens to nine, arching
        // over as it goes; each carries her own physics at its own moment of the
        // closure; and each tips further open as the premise turns, the outer ones
        // furthest. The verb is read from the travel by
        // ``RingOne/mark(_:from:reach:size:travel:glow:material:)``, exactly as it
        // is in the other two families — nothing here is assigned by name.
        let travel = figure.length(Self.travel)
        let burns = (Self.vaultAtRest + Self.vaultSettling * k
                     + Self.vaultDeep * b) / Self.vaultCeiling
        let reach = figure.reach(Self.vaultRadius)

        for index in 0..<Self.vaults {
            let now = span(index, at: chamberTime, deep: b, figure: figure,
                           centre: centre, axes: axes, material: material)
            let then = span(index, at: chamberTime - RingOne.readOver, deep: b, figure: figure,
                            centre: centre, axes: axes, material: material)
            for sample in 0..<Self.vaultSamples {
                // How much of a mark the arch makes here: everything where it
                // springs from the stone, and the stone's own grain by the time it
                // is overhead. See the header, reading 1.
                marks.append(RingOne.mark(now[sample].place, from: then[sample].place,
                                          reach: reach,
                                          size: 1 - now[sample].lift,
                                          travel: travel,
                                          glow: burns * share * perSample,
                                          material: material))
            }
        }

        // **This room makes one answer and not two.** The seal opening *is* the
        // reversal on the material — what it held is let go, and the five arches
        // tip open around it — so ``RoomReversal/actions(_:deep:stage:)`` is not
        // also called. A generic answering mark on top would be a second, brighter
        // disc standing in front of the first, which is the finding ``MatrkaRoom``
        // had to make with a picture and there is no reason to make twice. The
        // other half of the reversal — the enclosure giving the room up and the
        // canopy travelling away — is a **station**, and arrives through the
        // default ``RoomSurfaceMechanism/stations(at:stage:)``.
        return [surface: marks]
    }

    // MARK: - Where one vault stands

    /// One sample of one vault at one moment: where it falls on the surface, and
    /// how far off that surface the arch stands there.
    struct Sample: Equatable {
        var place: RingOne.Place
        /// `0` where the vault springs from the material and `1` at the furthest
        /// this vault ever stands off it.
        var lift: Double
    }

    /// The whole of one vault at one moment, in the coordinates of the surface it
    /// is happening to.
    ///
    /// The lift is normalised against **this vault's own furthest**, computed in
    /// the same pass, because how far an arch stands off the stone depends on
    /// which surface it is standing on: on a floor the arch rises away overhead,
    /// and on a working face it leans out of the panel. One number, read off the
    /// vault itself rather than chosen for it.
    func span(_ index: Int, at chamberTime: TimeInterval, deep: Double,
              figure: RingOne.Figure, centre: SurfaceCoordinate,
              axes: RoomUnits.SurfaceAxes, material: RoomMaterial) -> [Sample] {
        // Her physics, at this vault's own moment of the closure, with Design's
        // own damping along the room's depth.
        let drift = HomeGrammar.displace(physics,
                                         time: chamberTime - Double(index) * Self.vaultLag,
                                         phase: phase,
                                         amplitude: figure.length(Self.travel))
        let damped = HomeOffset(x: drift.x, y: drift.y, z: drift.z * Self.driftDepthDamping)
        let opening = deep * Self.opens * (1 + Double(index) * Self.opensFurther)

        var along: [Double] = []
        var off: [Double] = []
        var across: [Double] = []
        along.reserveCapacity(Self.vaultSamples)
        off.reserveCapacity(Self.vaultSamples)
        across.reserveCapacity(Self.vaultSamples)

        for sample in 0..<Self.vaultSamples {
            let curve = Self.curve(vault: index, sample: sample, opening: opening)
            across.append(curve.across)
            // Which of Design's two remaining axes runs **along** the surface and
            // which stands **off** it is ``RoomUnits/axes(of:)``: on a floor or a
            // canopy the vault runs away into the room and rises off the stone; on
            // a working face it climbs the panel and leans out of it.
            along.append(axes.along(design: curve.depth, rise: curve.rise))
            off.append(axes.along(design: curve.rise, rise: curve.depth))
        }

        let foot = off[0]
        let furthest = off.map { abs($0 - foot) }.max() ?? 0
        return (0..<Self.vaultSamples).map { sample in
            let u = material.reach(worldUnits: figure.length(across[sample])
                                   + axes.across(damped))
            let v = material.reach(worldUnits: figure.length(along[sample])
                                   + axes.along(damped))
            return Sample(place: RingOne.Place(
                            at: SurfaceCoordinate(u: centre.u + u, v: centre.v + v).clamped,
                            into: axes.into(damped)),
                          lift: furthest > 0 ? abs(off[sample] - foot) / furthest : 0)
        }
    }

    /// The angle one vault stands at: Design's `a = -0.9 + (i / 4) * 1.8`.
    ///
    /// **Symmetric about zero, and that is the aniconic guarantee.** The five are
    /// `-0.9, -0.45, 0, 0.45, 0.9`, so vault `i` and vault `4 - i` are mirror
    /// images of one another across the walker's own axis. A hand is chiral.
    static func angle(ofVault index: Int) -> Double {
        -fan + Double(index) / Double(vaults - 1) * (2 * fan)
    }

    /// One sample of one vault, in Design's own room and in Design's own axes:
    /// across, into the room's depth, and up.
    ///
    /// `opening` is Design's `rotation.x`, taken about the vault's **own foot**,
    /// so the seal opens where it springs rather than sliding through the room.
    /// The rotation mixes the room's height and its depth, which is why the crown
    /// both drops and travels as the arch tips — and why the seal opening is a
    /// different event from the seal simply growing.
    static func curve(vault index: Int, sample: Int,
                      opening: Double) -> (across: Double, depth: Double, rise: Double) {
        let a = angle(ofVault: index)
        let u = Double(sample) / Double(max(1, vaultSamples - 1))
        let radius = footRadius + u * (mouthRadius - footRadius)

        let footRise = springs
        let footDepth = cos(a) * footRadius + standsBefore
        let rise = springs + u * rises - u * u * arches
        let depth = cos(a) * radius + standsBefore - u * leansAway

        // Design's `rotation.x`, about the foot: `y' = y cos θ - z sin θ`,
        // `z' = y sin θ + z cos θ`.
        let dRise = rise - footRise, dDepth = depth - footDepth
        let c = cos(opening), s = sin(opening)
        return (across: sin(a) * radius,
                depth: footDepth + dRise * s + dDepth * c,
                rise: footRise + dRise * c - dDepth * s)
    }
}
