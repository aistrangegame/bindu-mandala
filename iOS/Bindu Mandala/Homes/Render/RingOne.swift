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

// ─────────────────────────────────────────────────────────────────────────────
// AND WHERE THE ARITHMETIC ACTUALLY LIVES NOW
// ─────────────────────────────────────────────────────────────────────────────
//
// Phase 3.6 needed every one of the rules below again, six times over, for the
// outer climb — and the divisor changes at ring 4, where Design's altitude span
// goes from 9 to 8. A second copy would have drifted the way the body zones did
// when they were ported on two branches.
//
// So the arithmetic is ``OuterRings``, parameterised by ring, and this file is
// the **names Ring 1's rooms and Ring 1's suites speak in**. Every member below
// forwards; none of them restates. What is genuinely Ring 1's — that it is three
// families split by position, and the reasoning that got each rule written — stays
// here, where its evidence is.
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
        OuterRings.inRoom(designUnits, ring: ring)
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
    static var widestMark: Double { OuterRings.widestMark }

    /// **The narrowest a mark may be and still be a mark**: one cell of the
    /// surface's own mesh.
    ///
    /// A surface is meshed and lit at ``RoomScene/resolution`` points a side, and
    /// both the relief and the emission are read **at those points and nowhere
    /// else**. A mark narrower than the gap between them therefore has no vertex
    /// inside it: it moves no material, and because light here is only ever a
    /// property of a disturbance, it emits nothing either. It is not faint, it is
    /// absent.
    ///
    /// That is not hypothetical arithmetic. Ring 1's second render put eighty-five
    /// of a Mudrā's eighty-six marks under this number — every sample of all five
    /// vaults, at four tenths of a cell — so what the walker stood in was the one
    /// disc the seal holds and no seal; and Sarva-Yoni's whole vessel, veins and
    /// all, was under it for the first adaptation and the hold, so her room was
    /// empty until the turn. The cause is ``Figure``: a figure scaled down to fit
    /// the picture scales its parts with it, and a part of a part is very small.
    ///
    /// Ring 2 has guarded this since it was built
    /// (`testHerMarksStandClearOfTheStonesOwnGrain`); Ring 1 now keeps the floor
    /// rather than the check alone.
    /// It lives in ``RoomInscription/narrowestMark`` now, beside the mesh's own
    /// resolution, because Ring 2's own marks turned out to fall under it too —
    /// the smallest of the seven a Karṣiṇī draws is 0.86 of a cell on a floor or
    /// a canopy — and there cannot be two answers to what the material can carry.
    static var narrowestMark: Double { OuterRings.narrowestMark }

    /// A reach the material can actually carry, in the surface's own coordinates:
    /// never wider than ``widestMark``, and never narrower than ``narrowestMark``.
    ///
    /// **A withdrawal is applied after this and never inside it, and that was
    /// tested the hard way.** A mark giving the room up shrinks by its reach — the
    /// Siddhi's lent capacity to a fifth of itself, Vaśitva's ring to a quarter —
    /// and a floor underneath the withdrawal holds it open instead: measured, the
    /// capacity that Design shrinks by four fifths came back the same size it
    /// began, and `testTheCapacityShrinksWhileTheRoomTakesItOver` said so at once.
    /// A capacity that is still there was never lent, and that is a worse failure
    /// than a mark that grows too small to see at the very end of a stay, which is
    /// what *lent* looks like.
    ///
    /// So a room scales its figure through here and then multiplies by however
    /// much of the room it is giving up. A mark that is **narrowing rather than
    /// leaving** — Vaśitva's pool of attention, which is the only light in that
    /// room and is coming to rest on him rather than going — passes through here
    /// afterwards, because that one has to be seen at the end.
    static func reach(_ surfaceUnits: Double) -> Double {
        OuterRings.reach(surfaceUnits)
    }

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
        private let figure: OuterRings.Figure

        init(spread: Double, part: Double, on material: RoomMaterial,
             bodyAltitude: Double) {
            self.figure = OuterRings.Figure(ring: RingOne.ring, spread: spread, part: part,
                                            on: material, bodyAltitude: bodyAltitude)
            self.scale = figure.scale
        }

        /// A length in Design's room, in this one's scene units.
        func length(_ designUnits: Double) -> Double { figure.length(designUnits) }

        /// A size in Design's room, in this surface's own coordinates — and never
        /// narrower than the material can carry, because a figure that has been
        /// scaled down to fit the picture has scaled its marks down with it.
        /// ``RingOne/narrowestMark`` is the whole of that reasoning.
        func reach(_ designUnits: Double) -> Double { figure.reach(designUnits) }
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
    static var readOver: TimeInterval { OuterRings.readOver }

    // MARK: - Where one part of a room's work stands

    /// One part of a Ring 1 room's work, in the coordinates of the surface it is
    /// happening to: two numbers along the surface, and one **into** it.
    ///
    /// **There is no third axis here that could name a point in the air.** `into`
    /// is not a height — it is how far the part's own travel has carried it
    /// against the material, which is how deep the mark it is making goes. A
    /// part's place is still two numbers on a surface, exactly as
    /// ``SurfaceCoordinate`` allows and no further.
    typealias Place = OuterRings.Place

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
        OuterRings.motion(place, span: span)
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
        OuterRings.pressed(into, travel: travel)
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
    /// It lives in ``RoomInscription/depth(size:on:)`` now, beside the mark depth
    /// it is the floor of, because Ring 2 needed the same answer for the same
    /// reason and the instrument has already paid once for a rule that was
    /// written down twice. Ring 1 keeps the name its rooms and its suites speak
    /// in.
    static func depth(size: Double, on material: RoomMaterial) -> Double {
        OuterRings.depth(size: size, on: material)
    }

    static func mark(_ here: Place, from before: Place,
                     reach: Double, size: Double, travel: Double, glow: Double,
                     material: RoomMaterial) -> SurfaceAction {
        // See ``depth(size:on:)``, which is where the grain floor lives, and
        // ``OuterRings/mark(_:from:reach:size:travel:glow:material:)``, which is
        // where the arithmetic is: `lean` is how hard this part is bearing on the
        // stone at this instant, and neither end of it ever falls below the grain.
        OuterRings.mark(here, from: before, reach: reach, size: size,
                        travel: travel, glow: glow, material: material)
    }

    /// One part's share of the light, so that `count` parts converging do not
    /// stack to a flat field. The same root ``RoomInscription`` shares one mark's
    /// worth of material among a rosary's twenty-seven beads by, for the same
    /// reason and by the same arithmetic.
    static func lightShare(of count: Int) -> Double {
        OuterRings.lightShare(of: count)
    }
}
