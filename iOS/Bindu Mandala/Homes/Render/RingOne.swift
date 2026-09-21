import Foundation

// MARK: - RING 1 · Trailokyamohana · what the three families share, and no more
//
// Ring 1 is **not one ring of twenty-eight**. Design splits it three ways by
// position and writes three different builders for the three halves of the
// khaḍgamālā's first turn:
//
//     R1_FAMILY = (pos) => (pos <= 10 ? 'siddhi' : pos <= 18 ? 'matrka' : 'mudra')
//
//   · **the ten Siddhis** (1–10) — a capacity is *lent*, and the room does the
//     same thing a moment later, further off. `siddhi(world, card, G)`.
//   · **the eight Mātṛkās** (11–18) — a row of the alphabet stands around you
//     unspoken, and one letter at a time comes to the point of being said.
//     `matrka(world, card, G, syllable)`.
//   · **the ten Mudrās** (19–28) — the room *is* a gesture: five vaults you
//     stand between, and a seal large enough to stand inside.
//     `mudra(world, card, G)`.
//
// They are three different kinds of thing and they must not blur into one
// another. That is why this file is small: it holds the arithmetic all three
// need and **nothing about what any of them does**. A shared helper that knew
// what a room looked like would be the one generic physics Design's own
// verification pass found under seventy-eight of its hundred and two rooms,
// arriving through the back door.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE ONE RULING THIS FILE MAKES: A LAYOUT IS THE ROOM'S, A MARK IS THE BODY'S
// ─────────────────────────────────────────────────────────────────────────────
//
// ``CrossingRoom`` had to settle how a length in Design's room becomes a length
// in this one, and it settled it against **the body**: a mark read as a fraction
// of the *surface* came out four times smaller on a ceiling than on a face, and
// on a face it came out shallower than the stone's own grain — a mark nobody can
// see, in a room whose only content is marks.
//
// Ring 1 needs a second half of that answer, because two of its three families
// draw a **figure** and not a scatter: the Mātṛkās stand a ring of letters
// around the walker at Design's radius of 6.4, and the Mudrās arch five vaults
// out to a radius of 9. Read against the body those land at 4.55 and 6.4 scene
// units — which fits comfortably on a floor four body-heights across and runs
// clean off a working face that is one body square.
//
// So:
//
//   * **a mark** — how wide one thing is and how deep it goes — is a fraction of
//     the **body**, exactly as the crossing ruled, because that is what makes it
//     readable at all;
//   * **a layout** — where the parts of a figure stand relative to one another —
//     is brought into the **picture the walker is actually looking at**, and
//     where the figure does not fit, the *whole figure* is scaled down rather
//     than its parts being clamped. A ring whose marks are clamped onto the edge
//     of the material is not a ring, it is a heap; and a heap is the same heap in
//     all eight Mātṛkā rooms.
//
// ``Figure`` is that rule and ``depth(size:on:)`` is the floor every mark keeps,
// and between them they are the only reason this file is not three copies of the
// same eight lines.

enum RingOne {

    /// The āvaraṇa the three families stand in. Position decides which family;
    /// nothing here consults a name.
    static let ring = 1

    /// Design's own body span in a Ring 1 room — `(0.5 - alt) * 9`, whose whole
    /// range is 9 — read off ``RoomUnits/grammarSpan(ring:)`` rather than typed,
    /// so a change in the grammar arrives here instead of being missed.
    static var designSpan: Double { RoomUnits.grammarSpan(ring: ring) }

    /// A length in Design's Ring 1 room, in this one's scene units.
    ///
    /// **Against the body**, which is the one thing the two rooms both have: the
    /// crown-to-soles span is 9 in Design's numbers and ``RoomUnits/roomHeight``
    /// in this instrument's.
    static func inRoom(_ designUnits: Double) -> Double {
        let span = designSpan
        guard span != 0 else { return 0 }
        return designUnits / span * RoomUnits.roomHeight
    }

    /// The widest any one mark of a Ring 1 room may open, in the surface's own
    /// coordinates.
    ///
    /// ``RoomReversal/answeringSpan`` is the instrument's own answer to how wide
    /// a mark may be — *"half the span is the widest a mark can be and still have
    /// material around it to be a mark in"* — and that is the answer for a mark
    /// the reversal makes. A mark the *premise* makes is one of several, so it
    /// gets half of it: two of them side by side are still two marks in a
    /// surface, and a single one is never the surface.
    static let widestMark: Double = RoomReversal.answeringSpan / 2

    /// **A figure, brought into the picture the walker is actually looking at.**
    ///
    /// Design's Ring 1 rooms are halls — a box thirteen across, a sphere
    /// twenty-eight — and this instrument's rooms are seen through a phone held
    /// upright. Two bounds apply, and the first render of Ring 1 broke both:
    ///
    /// **1 · the material.** A working face is one body square, and a ring of
    /// letters at Design's radius of 6.4 is 4.55 scene units — wider than half
    /// the panel it is being drawn on.
    ///
    /// **2 · the frame**, which is the tighter of the two and the one nothing in
    /// the instrument had needed before. At the distance a face settles to, the
    /// picture is 2.6 units tall and **1.3 across**
    /// (``RoomUnits/visibleHalfWidth(atDistance:)``). Vaiṣṇavī's fourteen letters
    /// stood on a ring 5.2 units wide: the room she is the Mother of was almost
    /// entirely outside the picture, with one bright patch of it showing over the
    /// riser. Every check in the suite was green.
    ///
    /// So a figure that does not fit is **scaled as a whole** — its layout and
    /// the size of its parts by the same number — and never clamped part by part.
    /// A ring whose marks are clamped onto the edge of the material is not a
    /// ring, it is a heap, and a heap is the same heap in all eight Mātṛkā rooms.
    ///
    /// The distance is read at the **end** of the stay, where the room is nearest
    /// and the picture is smallest, so a figure has one size for the whole visit.
    /// A figure that resized as the room came toward him would be a zoom, and
    /// nothing in Design's rooms zooms.
    struct Figure {
        /// `1` where Design's figure already fits.
        let scale: Double
        private let material: RoomMaterial

        init(spread: Double, part: Double, on material: RoomMaterial,
             bodyAltitude: Double) {
            self.material = material
            let want = RingOne.inRoom(abs(spread)) + RingOne.inRoom(abs(part)) / 2

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
        func length(_ designUnits: Double) -> Double { RingOne.inRoom(designUnits) * scale }

        /// A size in Design's room, in this surface's own coordinates.
        func reach(_ designUnits: Double) -> Double {
            min(RingOne.widestMark, material.reach(worldUnits: length(designUnits)))
        }
    }

    // MARK: - The clock a Ring 1 room is read on

    /// **How long a reading of a moving part is taken over.**
    ///
    /// ``RoomInscription/sampleGap`` is a quarter of a second because Design's
    /// twenty-six attribute forms are *gestures*, and a gesture moves at the rate
    /// a quarter of a second can see. Her physics does not: the displacement
    /// kernel's terms turn at between 0.03 and 0.6 radians a second, so a mark
    /// sampled at a gesture's rate has barely moved and every one of the fifty
    /// kinds classifies below ``RoomInscription/workingSpeed`` — which is a whole
    /// family speaking one verb, and a family with no physics.
    ///
    /// So a family's marks are read across a quarter of the first adaptation,
    /// which is the interval her own kernel turns in. The classifier is
    /// unchanged and still reads the travel rather than a name; what changes is
    /// the clock the travel is read on, and the clock is hers. This is
    /// ``CrossingRoom/readOver``'s finding, and Ring 1 inherits the finding
    /// rather than rediscovering it.
    static let readOver: TimeInterval = HomeMemory.firstAdaptation / 4

    // MARK: - Where one part of a room's work stands

    /// One part of a Ring 1 room's work, in the coordinates of the surface it is
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
    /// surface, and the two surfaces a Ring 1 Śakti can stand at differ by a
    /// factor of four in span. Handing the classifier fractions would make the
    /// same travel read as four different speeds depending on where on her body
    /// she is felt.
    static func motion(_ place: Place, span: Double) -> AttributeMotion {
        AttributeMotion(x: place.at.u * span, y: place.into, z: place.at.v * span)
    }

    /// How far a part's travel has carried it **against** the stone, `-1` drawn
    /// back out of it to `+1` driven into it.
    ///
    /// Read against ``HomeGrammar/widestTerm`` rather than against the amplitude
    /// the kernel was handed, and that is not a nicety: the kernel multiplies its
    /// amplitude by as much as 2.2, so a normalisation by the amplitude alone
    /// leaves the fast axes railed at ±1 for most of every turn — and a mark that
    /// is railed has stopped carrying her phase at all.
    static func pressed(_ into: Double, travel: Double) -> Double {
        min(1, max(-1, -into / max(travel * HomeGrammar.widestTerm, 0.0001)))
    }

    /// One part of a room's work, as one action on the material.
    ///
    /// The verb is ``RoomInscription``'s, read from this part's own travel over
    /// her own clock — nothing here is assigned by name, in any family. The depth
    /// is the instrument's own ``RoomInscription/markDepth``, shared out among the
    /// parts exactly as ``RoomInscription`` shares one mark's worth among a
    /// rosary's beads, and leaning with how hard the part is bearing on the
    /// stone. And the light is the surface's, which is to say it exists exactly
    /// as far as the surface moved.
    /// **How deep a Ring 1 mark goes, and the floor no mark falls below.**
    ///
    /// The dhātu's grain stands a fortieth of a body high and one mark's own
    /// depth is a twentieth, so a mark at half strength is *exactly* the grain
    /// and a mark below that is invisible — not faint, invisible, since what the
    /// walker sees is a raking light falling across relief and the relief it
    /// falls across is the grain's. Ring 1's first render is the evidence:
    /// Vaiṣṇavī's fourteen letters were shared down to a quarter of a mark by a
    /// `1 / √n`, which is 0.085 against a grain of 0.16, and her whole room came
    /// back as horizontal banding with nothing standing in it. ``CrossingRoom``
    /// wrote the finding down — *"a mark shallower than the grain is a mark
    /// nobody can see"* — and this is that finding enforced rather than
    /// remembered.
    ///
    /// So the grain is the floor and one mark's depth is the ceiling, and `size`
    /// — how large this mark is against the largest the room makes, which is
    /// ``CrossingRoom``'s own `relative` — moves it between them. Many parts
    /// still share the **light**; they do not share their footing.
    ///
    /// A mark that is *giving the room up* therefore withdraws by its **reach**
    /// and never by its depth: a mark that grew shallower would stop being seen
    /// while it was still there, which is a different thing from leaving.
    /// `testEverySiddhiMarkStandsClearOfTheStonesOwnGrain` holds every room in
    /// the ring to it.
    static func depth(size: Double, on material: RoomMaterial) -> Double {
        let floor = min(material.grainRelief, RoomInscription.markDepth)
        return floor + (RoomInscription.markDepth - floor) * min(1, max(0, size))
    }

    static func mark(_ here: Place, from before: Place,
                     reach: Double, size: Double, travel: Double, glow: Double,
                     material: RoomMaterial) -> SurfaceAction {
        // See ``depth(size:on:)``, which is where the grain floor lives. `lean` is
        // how hard this part is bearing on the stone at this instant — a mark
        // driven into the material is deeper and one drawn back out of it is
        // shallower, and neither ever falls below the grain.
        let lean = 0.55 + 0.45 * pressed(here.into, travel: travel)
        let depth = RingOne.depth(size: min(1, max(0.2, size)) * lean, on: material)

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

    /// One part's share of the light, so that `count` parts converging do not
    /// stack to a flat field. The same root ``RoomInscription`` shares one mark's
    /// worth of material among a rosary's twenty-seven beads by, for the same
    /// reason and by the same arithmetic.
    static func lightShare(of count: Int) -> Double {
        1 / Double(max(1, count)).squareRoot()
    }
}
