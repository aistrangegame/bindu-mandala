import Foundation

// MARK: - THE DEEP TERM: what a room's premise becomes
//
// Design is explicit, in `homes-chambers.js` and again in its own verification
// register:
//
//     the second adaptation is never "more of the same": in every room it
//     REVERSES the room's own premise.
//
// The Phase 3.1 review found that the spine could not carry that. It carries the
// reversal's *stage* — the mark widening and nearing, the key handing its work to
// the mark, the gradient turning toward her — and that stage is **the same stage
// in all 102 rooms**. `HomeGrammar.Reading` had nowhere to say what a particular
// room's premise turns into, so the second adaptation was one generic
// intensification wearing 102 different colours. A room that does not reverse its
// premise is a loop, not a room.
//
// This file is the missing term, and it is deliberately small. A reversal, said
// as plainly as Design says it, is two facts and two amounts:
//
//   * which part of the room **carried the premise** while the eye was settling;
//   * which part **answers it** once the premise turns;
//   * how completely the first one **yields**;
//   * how far the second one **takes over**.
//
// Everything else — which verb the answering material performs, how far that is
// in scene units, what it does to the light — is read from those, downstream, in
// ``RoomReversal``. Nothing here is a scene and nothing here is drawn.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY IT IS SAID IN SURFACES, AND WHY THAT IS NOT A LAYERING MISTAKE
// ─────────────────────────────────────────────────────────────────────────────
//
// ``RoomSurfaceKind`` is the room's four parts — the ground, the canopy, the
// enclosure, and the working face standing at her own altitude. It imports
// nothing that can draw, names no geometry, and its own header says it states the
// binding condition *"in the coordinate system before `RoomMaterial` states it in
// the API"*. It is vocabulary, not renderer.
//
// So the becoming is written in it rather than in a second four-case enum of its
// own. The instrument has already paid for one duplicated table — the body zones,
// ported twice on parallel branches and unified afterwards — and a second copy of
// "the parts a room has" would drift the same way. There is one list of the
// room's parts and this file reads it.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE PART THAT CANNOT BE WRITTEN HERE
// ─────────────────────────────────────────────────────────────────────────────
//
// There is **no case for a thing in the air**, in either field, because
// ``RoomSurfaceKind`` has none. A premise is always carried by some of the room's
// own material and always answered by some of it. A reversal that wanted a free
// object to arrive would have nowhere to name it — which is the renderer ruling's
// binding condition reaching one layer further out than it did before.

/// **What a room's premise becomes.**
///
/// Hand-authored for the eight rooms Design wrote by hand, and read off her
/// archetype for the other ninety-four. Pure: it holds no geometry, no scene and
/// no words, so a room can state its reversal before anything is drawn and a test
/// can read it without a renderer.
struct HomeBecoming: Equatable, Hashable {

    /// The part of the room that carried the premise while the eye was settling.
    let premise: RoomSurfaceKind

    /// The part that answers it once the premise turns.
    ///
    /// **Never the same part as ``premise``.** A premise answered by itself is an
    /// intensification, which is precisely the thing this term exists to stop
    /// being; ``isAReversal`` says so and the tests hold every room to it.
    let answer: RoomSurfaceKind

    /// How completely the part that carried the premise gives up its work, `0`–`1`.
    /// Design's own fade for that room, read off its `update(t)`.
    let yields: Double

    /// How far the answering part travels to take the work over, as a multiple of
    /// what it was doing before. Design's own growth for that room.
    ///
    /// **Signed, and the sign is not a convenience.** Design's reversals go both
    /// ways and the difference is the whole meaning: Ring 5's gift becomes the
    /// ground he is standing on and arrives *at* him, while Ring 4's gesture
    /// expands through fourteen shells and leaves *past* him. Positive is toward
    /// the walker, negative away from him. A reversal with no sign would make
    /// those two rooms the same room.
    let takes: Double

    init(premise: RoomSurfaceKind, answer: RoomSurfaceKind,
         yields: Double, takes: Double) {
        self.premise = premise
        self.answer = answer
        self.yields = min(1, max(0, yields))
        self.takes = takes
    }

    /// Which way the answering material travels: `+1` toward the walker, `-1`
    /// away from him. What verb it performs is read from this rather than
    /// assigned by name — the same discipline ``RoomInscription`` reads its own
    /// five verbs by.
    var answerComes: Double { takes < 0 ? -1 : 1 }

    /// Whether this is a reversal at all: the work has to move, and something has
    /// to happen where it moved to.
    var isAReversal: Bool { premise != answer && (yields > 0 || takes != 0) }
}

// MARK: - The ten archetype reversals

extension HomeBecoming {

    /// Design's own reversal for one of the ten archetypes, read out of its
    /// builder in `homes-grammar.js` — the deep sentence it prints, and the two
    /// numbers its `update(t)` actually drives with `b`.
    ///
    /// Every one of the ten is a different pair of parts or a different way round,
    /// so a Vāk Devī's room and a Nigarbha Yoginī's do not turn alike;
    /// `testNoTwoArchetypesReverseAlike` holds them apart. The reading beside each
    /// is Design's own sentence, so the mapping can be argued with rather than
    /// taken on trust.
    static func archetype(_ archetype: HomeArchetype) -> HomeBecoming {
        switch archetype {

        // RING 1 · SIDDHI — *"the capacity was never lent"*.
        // `lent.scale.setScalar(1 - b * 0.8)` — what was held out in front of her
        // shrinks to nothing; `core.material.emissiveIntensity = … + b * 2.4` on a
        // base of 2.4 — and what is left is what she was standing on all along.
        case .siddhi:
            return HomeBecoming(premise: .face, answer: .ground, yields: 0.8, takes: 1.0)

        // RING 1 · MĀTṚKĀ — *"the letters were never separate from the voice"*.
        // The letters stand around the room and are drawn into one column in
        // front of her; `column.material.opacity = … + b * 0.22` on a base of
        // 0.18, and `column.scale.setScalar(1 + b * 1.1)`.
        //
        // **The growth is the column's and not the letters'**, and getting that
        // wrong is what Phase 3.5 had to find with a picture. This case first
        // carried Design's `m.scale.y = 1 + b * 3.4`, which is how far *the
        // letters* stretch — the premise — read as how far *the column* takes the
        // room over. Through ``RoomReversal/answeringFraction(takes:)`` that sent
        // her working face three quarters of its clearance toward the eye, and
        // all eight Mātṛkā rooms ended the stay as one flat grey field: the whole
        // picture was her own working surface. The two numbers had been taken
        // from opposite sides of the reversal.
        case .matrka:
            return HomeBecoming(premise: .wall, answer: .face, yields: 0.22, takes: 1.1)

        // RING 1 · MUDRĀ — Design's *"the seal has opened its hand"*, carried as
        // *"the seal has opened, and let go of what it held"* because law 4 does
        // not let a walker-facing line name a body part in the one family where a
        // mudrā already is one (``MudraRoom``, and ``HomeGrammar/tag(for:position:bija:quality:tattva:)``).
        // `held.scale.setScalar(… + b * 3.6)` and
        // `held.children[0].material.opacity = 0.5 + 0.3 * k - b * 0.2`: the seal
        // you were standing inside opens, upward and away.
        case .mudra:
            return HomeBecoming(premise: .wall, answer: .canopy, yields: 0.2, takes: -3.6)

        // RING 2 · CROSSED — *"the drawing and the drawn are one"*.
        // `m.material.opacity = (0.26 + 0.34 * k) * (1 - b * 0.3)` — what she drew
        // fades from in front of her; `s.scale.setScalar(1.4 * (1 + b * 1.2))` —
        // the organ she was given grows until it is the room around him.
        case .crossed:
            return HomeBecoming(premise: .face, answer: .wall, yields: 0.3, takes: -1.2)

        // RING 3 · BODILESS — *"the effect was the only body"*.
        // `shell.material.opacity = 1 - b * 0.8` — the enclosure gives way;
        // `p.scale.setScalar(1 + b * 1.6)` — the effect, which had no cause, opens
        // out past where he stands.
        case .bodiless:
            return HomeBecoming(premise: .wall, answer: .face, yields: 0.8, takes: -1.6)

        // RING 4 · COSMIC — *"the gesture had no centre to leave"*.
        // `heart.scale.setScalar(… - b * 0.34)` — the centre empties;
        // `s.scale.setScalar(1 + b * (0.22 + i * 0.03))` over twenty shells — and
        // the gesture is at the scale of the walls.
        case .cosmic:
            return HomeBecoming(premise: .face, answer: .wall, yields: 0.34, takes: -0.52)

        // RING 5 · GIVING — *"the giving and the given are one"*.
        // The gifts fall in from beyond the wall the whole first adaptation; then
        // `cup.material.opacity = … * (1 - b * 0.8)` and
        // `cup.scale.setScalar(1 + b * 4.2)` — the place they were landing opens
        // out until what was given is the ground he is on.
        case .giving:
            return HomeBecoming(premise: .canopy, answer: .ground, yields: 0.8, takes: 4.2)

        // RING 6 · REVEALING — *"it was never hidden · you were the veil"*.
        // `veil.material.opacity = max(0, 0.72 - k * 0.46 - b * 0.26)` — the veil
        // that was around him clears; `truth.scale.setScalar(1 + b * 0.5)` — what
        // it hid was overhead the whole time.
        case .revealing:
            return HomeBecoming(premise: .wall, answer: .canopy, yields: 0.26, takes: 0.5)

        // RING 7 · SOUNDING — *"you are inside the syllable"*.
        // `s.material.opacity = (0.24 + 0.4 * k) * (1 - b * 0.4)` — the standing
        // waves stop being a wall he is looking at;
        // `s.scale.setScalar(1.8 * (1 + b * 1.2))` — they pass him, and the sound
        // becomes what he is standing in.
        case .sounding:
            return HomeBecoming(premise: .wall, answer: .ground, yields: 0.4, takes: 1.2)

        // RING 8 · SOURCING — *"will was already act and form"*.
        // `L.l.intensity = L.mine ? 900 : 90 + b * 700` — the two corners that were
        // dark answer; `bindu.scale.setScalar(2.2 * (1 + b * 2.4))` — and the point
        // at the source is overhead, where the triangle's own apex is.
        case .sourcing:
            return HomeBecoming(premise: .face, answer: .canopy, yields: 0.1, takes: 2.4)
        }
    }
}
