import Foundation

// MARK: - RING 1 · the eight Mātṛkās · the room that is the mouth before sound
//
// Design's `matrka(world, card, G, syllable)`, built on the Phase 3.1 spine. Its
// own header:
//
//     RING 1 · MĀTṚKĀ — the Mother of a row of the alphabet.
//     Her letters stand around you, unspoken. The room is the mouth before sound.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ONE CHANNEL RING 1 HAS THAT NO OTHER RING DOES
// ─────────────────────────────────────────────────────────────────────────────
//
// Every room in the instrument is tuned by four channels — her physics, her
// altitude, her phase and her words (handoff §4.3). The eight Mātṛkās have a
// fifth, and it is a **count**:
//
//     const n = 5 + ((card.pos - 11) % 4) * 3;   // how many letters her row governs
//
// which over khaḍgamālā 11…18 is 5, 8, 11, 14, 5, 8, 11, 14. Two Mothers who
// share a count do not share a phase, an altitude, a physics or a bīja, and the
// count itself is the one thing in Ring 1 that changes *how many things are in
// the room*. ``HomeGrammar/matrkaLetterCount(position:)`` is Design's formula and
// this room reads it off the ``HomeGrammar/Reading`` rather than recomputing it.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT MAKES THIS ROOM A MĀTṚKĀ AND NOT A SIDDHI OR A MUDRĀ
// ─────────────────────────────────────────────────────────────────────────────
//
//   · a Siddhi is one thing and the room repeating it, receding (``SiddhiRoom``);
//   · a Mudrā is five long vaults opening outward (``MudraRoom``);
//   · **a Mātṛkā is a closed ring of `n` letters, standing still and waiting,
//     with exactly one of them being spoken at any instant.**
//
// The spoken one is Design's own, and it is the sharpest thing in Ring 1:
//
//     const turn = (t * 0.22 + i / n) % 1;
//     m.material.emissiveIntensity = 1.4 + Math.pow(Math.max(0, Math.sin(Math.PI * turn)), 8) * 5 + b * 1.8;
//
// An eighth power of a sine is a narrow window — a letter is past half its own
// brightness for about a quarter of its turn — so what the walker sees is a point
// of light travelling round a ring of dark letters, **one letter at its peak at
// any instant**, handing on to the next at a rate her row's own count sets. A row
// of five hands on every nine tenths of a second and a row of fourteen every
// third of one, and neither is a room anybody else could stand in.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND WHY THE LETTERS GROW UNTIL THEY TOUCH, AND THEN STOP
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's reversal is *"the letters were never separate from the voice"*, and it
// is `m.scale.y = 1 + b * 3.4` — the letters **grow** where they stand, while the
// column in front of her opens, until the ring and the column are one thing. The
// ring does not move.
//
// It is carried literally, with one bound Design does not need and this
// instrument does: a letter may grow **until it is touching its neighbours**, and
// no further. Past that the row is an annulus, which is a row that has stopped
// saying how many letters are in it — and how many letters are in it is the one
// channel this family has that no other ring does. The bound is her count's own
// (`π · radius / n`), so it is still hers: a row of five may grow two and a half
// times over and a row of fourteen barely at all, which is the difference between
// the rooms rather than a limit imposed on them.
//
// The first version of this file closed the *ring* instead, drawing the letters
// in toward the column. It is written down because the check that caught it is
// worth keeping: at Design's own radius a row of **fourteen letters is already
// touching**, so two of the eight rooms had no convergence in them at all and the
// suite said so.
struct MatrkaRoom: RoomSurfaceMechanism {

    // MARK: - Who she is

    /// `khadgamalaPosition` 11–18. The only key.
    let position: Int
    /// Her physics, classified from her own tattva and quality.
    let physics: HomePhysics
    /// Her turn of the eight — Design's `(card.pos % 8) / 8`.
    let phase: Double
    /// **How many letters her row governs** — Design's
    /// `5 + ((card.pos - 11) % 4) * 3`, read off the grammar.
    let letters: Int

    init(_ reading: HomeGrammar.Reading) {
        self.position = reading.position
        self.physics = reading.physics
        self.phase = reading.phase ?? 0
        self.letters = max(1, reading.matrkaLetterCount
                           ?? HomeGrammar.matrkaLetterCount(position: reading.position))
    }

    // MARK: - Design's own numbers

    /// The ring her row stands on: Design's `cos(a) * 6.4`.
    static let ringRadius: Double = 6.4

    /// …and how far in front of her it is centred: Design's `- 2`.
    static let ringStandsBefore: Double = -2

    /// One letter: `BoxGeometry(0.16, 1.5, 0.16)` — a bar, standing.
    ///
    /// What carries into the surface is **half its length**, because a mark's
    /// reach is a radius and a bar's is half of what it measures. ``CrossingRoom``
    /// carries its own marks by the same reading, off the torus radii rather than
    /// the diameters.
    static let letterLength: Double = 1.5
    static let letterWidth: Double = MatrkaRoom.letterLength / 2

    /// **How far a letter grows as the premise turns.** Design's
    /// `m.scale.y = 1 + b * 3.4`, bounded by her own count — see the header.
    static let lettersGrow: Double = 3.4

    /// Design's displacement amplitude in this room — `displace(kind, …, 1.1)`,
    /// which is half the Siddhi's: a letter waiting to be spoken trembles, it
    /// does not travel.
    static let travel: Double = 1.1

    /// **How far apart in time two neighbouring letters are.** Design's
    /// `displace(kind, t - i * 0.22, ph, 1.1)` — the row does not move as one
    /// body, it moves the way a row of letters is read.
    static let letterLag: TimeInterval = 0.22

    /// How fast the speaking goes round: Design's `turn = (t * 0.22 + i / n) % 1`.
    static let speaks: Double = 0.22

    /// How narrow the window in which a letter is being spoken: Design's
    /// `Math.pow(…, 8)`.
    static let spokenSharpness: Double = 8

    /// Design's own emissive ramp on a letter — `1.4 + spoken * 5 + b * 1.8` —
    /// against its own ceiling, so it reads as a share of the light.
    static let letterAtRest: Double = 1.4
    static let letterSpoken: Double = 5
    static let letterDeep: Double = 1.8
    static let letterCeiling: Double = 1.4 + 5 + 1.8

    /// The column of voice, rising in front of her from the first moment:
    /// `opacity = 0.06 + 0.12 * k + b * 0.22`, `scale = 1 + b * 1.1`, on a
    /// cylinder that opens from 0.4 to 1.5.
    static let columnAtRest: Double = 0.06
    static let columnSettling: Double = 0.12
    static let columnFoot: Double = 0.4
    static let columnMouth: Double = 1.5
    static let columnOpens: Double = 1.1

    // MARK: - What the premise becomes

    /// **The letters were never separate from the voice.** Her ring stood around
    /// the walker for the whole of the first adaptation — the enclosure — and the
    /// column in front of her takes it over.
    ///
    /// Read from ``HomeBecoming/archetype(_:)``, which holds Design's own two
    /// numbers for this archetype: `column.material.opacity … + b * 0.22` and
    /// `m.scale.y = 1 + b * 3.4`.
    var becoming: HomeBecoming { .archetype(.matrka) }

    // MARK: - What is done to the material

    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]] {
        let surface = stage.placement.surface
        guard let material = stage.materials[surface] else { return [:] }
        let k = stage.settling, b = stage.deep
        let axes = RoomUnits.axes(of: surface)
        let centre = Self.centre(of: stage, axes: axes, material: material)

        let figure = RingOne.Figure(spread: Self.ringRadius,
                                    part: Self.letterLength,
                                    on: material,
                                    bodyAltitude: stage.placement.bodyAltitude)
        let travel = figure.length(Self.travel)
        let share = RingOne.lightShare(of: letters)

        // **How far a letter may grow, and where it stops.** Design's
        // `m.scale.y = 1 + b * 3.4` on a bar that stands in a ring of radius 6.4;
        // the bound is her own count, because `n` letters on a ring of radius `r`
        // are touching when each is `π · r / n` across. See the header.
        // **And a ring wide enough to hold that many letters the material can
        // carry.** Her count is this family's fifth channel, and a figure scaled
        // down to fit the picture takes the letters down with it: on a floor four
        // body-heights across, Design's own letter comes out at a third of a mesh
        // cell, where it moves no material and therefore lights none of it
        // (``RingOne/narrowestMark``) — which is not fourteen faint letters, it is
        // none.
        //
        // So where a letter has fallen under the mesh, **the ring opens by exactly
        // the factor the letter had to**, and the proportion between the two —
        // which is her count, and the only thing that separates a row of five from
        // a row of fourteen — is the one Design drew. A letter is then one cell
        // and the ring carries `π · 6.4 / (n · 0.75)` of them: 5.4 letter-widths of
        // room to grow at five, and 1.9 at fourteen.
        let oneLetter = material.reach(worldUnits: figure.length(Self.letterWidth))
        let opens = oneLetter > 1e-12 ? max(1, RingOne.narrowestMark / oneLetter) : 1
        let radius = min(RoomReversal.answeringSpan,
                         material.reach(worldUnits: figure.length(Self.ringRadius)) * opens)
        let touching = .pi * radius / Double(letters)
        let reach = RingOne.reach(min(touching, oneLetter * opens * (1 + b * Self.lettersGrow)))

        var marks: [SurfaceAction] = []
        marks.reserveCapacity(letters + 1)

        // ── the column of voice, which is this room's answering mark ────────
        //
        // Rising in front of her from the first moment, and opening as the
        // premise turns. It is a **swell** — material raised from beneath, never a
        // thing set on top of the surface — and it is what the ring is drawing
        // toward.
        //
        // **And it is the only answer this room makes**, which is why
        // ``RoomReversal/actions(_:deep:stage:)`` is not also called here. A room
        // that answered twice would have two answers, and the second one is a lit
        // disc standing in front of the first: the generic answering mark opens to
        // ``RoomReversal/answeringSpan`` at a glow of `0.35 + 0.5 · fraction`,
        // which on a working face a body square is a lit area a quarter of the
        // surface across at six tenths brightness. Measured on the render, that
        // and the column together left Vārāhī's near half five times as bright
        // past the second adaptation as at the first — the wash ``PressRoom``
        // found once and ``CrossingRoom`` found again, arriving a third time by a
        // different door. Design's own column is faint by construction
        // (`opacity = 0.06 + 0.12 * k + b * 0.22`, on an additive cylinder) and it
        // is that ramp the column carries.
        //
        // The room still reverses exactly as far as the instrument says it does:
        // the reach it opens to is ``RoomReversal/answeringSpan`` times the same
        // saturating fraction the station travels by, so the mark and the surface
        // it is in agree without either of them being written down twice.
        let fraction = RoomReversal.answeringFraction(takes: becoming.takes)
        let mouth = figure.reach(Self.columnFoot
                                 + (Self.columnMouth - Self.columnFoot) * k)
        let voice = Self.columnAtRest + Self.columnSettling * k + b * becoming.yields
        marks.append(.swell(at: centre,
                            reach: min(RoomReversal.answeringSpan * fraction,
                                       mouth * (1 + b * Self.columnOpens)),
                            depth: RingOne.depth(size: 1, on: material),
                            glow: voice))

        // ── her row, ringed and waiting to be spoken ────────────────────────
        for index in 0..<letters {
            let here = letter(index, at: chamberTime, radius: radius, centre: centre,
                              travel: travel, axes: axes, material: material)
            let before = letter(index, at: chamberTime - RingOne.readOver, radius: radius,
                                centre: centre, travel: travel, axes: axes, material: material)

            // Design's own speaking, going round the ring at a rate her count
            // sets. One letter at a time, and the window is an eighth power.
            let turn = Self.wrapped(chamberTime * Self.speaks + Double(index) / Double(letters))
            let spoken = pow(max(0, sin(.pi * turn)), Self.spokenSharpness)
            let burns = (Self.letterAtRest + Self.letterSpoken * spoken
                         + Self.letterDeep * b) / Self.letterCeiling

            marks.append(RingOne.mark(here, from: before,
                                      reach: reach,
                                      size: 1,
                                      travel: travel,
                                      glow: burns * share,
                                      material: material))
        }

        // The enclosure giving the room up is a **station** and not a mark — a
        // wall is not marked, it moves — and that half of the reversal arrives
        // through the default ``RoomSurfaceMechanism/stations(at:stage:)``. The
        // other half is the column above.
        return [surface: marks]
    }

    // MARK: - Where one letter of her row stands

    /// Where the ring is centred: Design's own `- 2` in front of her, on the
    /// surface she is felt at.
    static func centre(of stage: RoomStage, axes: RoomUnits.SurfaceAxes,
                       material: RoomMaterial) -> SurfaceCoordinate {
        let at = stage.placement.coordinate
        let before = RingOne.inRoom(ringStandsBefore)
        return SurfaceCoordinate(u: at.u,
                                 v: at.v + material.reach(worldUnits:
                                        axes.along(design: before, rise: -before))).clamped
    }

    /// One letter, at one moment: its place on the ring, and her physics at that
    /// letter's own moment of the row.
    func letter(_ index: Int, at chamberTime: TimeInterval, radius: Double,
                centre: SurfaceCoordinate, travel: Double,
                axes: RoomUnits.SurfaceAxes, material: RoomMaterial) -> RingOne.Place {
        let a = Double(index) / Double(letters) * 2 * .pi
        let drift = HomeGrammar.displace(physics,
                                         time: chamberTime - Double(index) * Self.letterLag,
                                         phase: phase,
                                         amplitude: travel)
        let u = centre.u + cos(a) * radius + material.reach(worldUnits: axes.across(drift))
        let v = centre.v + sin(a) * radius + material.reach(worldUnits: axes.along(drift))
        return RingOne.Place(at: SurfaceCoordinate(u: u, v: v).clamped,
                             into: axes.into(drift))
    }

    /// A turn, kept in `0..<1`.
    static func wrapped(_ x: Double) -> Double {
        let r = x.truncatingRemainder(dividingBy: 1)
        return r < 0 ? r + 1 : r
    }
}
