import Foundation

// MARK: - RingBija — the fall speaks the mantra
//
// Phase 5, expansion idea 31: *"As you cross each ring, its bīja sounds — Aiṁ,
// Klīṁ, Sauḥ, Hrīṁ, Hsraiṁ, Hsklhrīṁ, Hsauḥ, Aiṁ Klīṁ Sauḥ, Hrīṁ. The full
// descent is the mantra of the yantra, spoken by the passage itself."*
//
// The mechanism already existed. `LivingMandalaView.updateEntered()` has always
// detected inward-only enclosure crossings and, behind the walker's own sound
// toggle, sounded `RingAudioService.ringChime`. Idea 31 is a substitution of
// *what the crossing plays*, not a new hook — so this file is a table and a
// voicing, and the view changes by one word.
//
// ─────────────────────────────────────────────────────────────────────────────
// SOUNDED, NEVER STACKED
// ─────────────────────────────────────────────────────────────────────────────
//
// The trap in idea 31 is not the sound, it is the **surface**. A falling mantra
// that is also *written* — "Aiṁ · Klīṁ · Sauḥ …" accumulating down the glass as
// you descend — is a list of the enclosures crossed, which reads as a position
// indicator while you are in it and as a completion list if it survived the
// session. So the syllables live here, in a service, and no view reads them:
// `MandalaLightTests` asserts that no file under `Views/` mentions this type.
//
// Nor does a voice hear them. `MandalaVoice` speaks the nine enclosures with
// their ordinals spelled as words and no numeral anywhere; a bīja added to that
// surface would be a syllable spoken by a synthesiser that cannot say it, on a
// screen where speech is already complete.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THE NINE ARE MADE OF
// ─────────────────────────────────────────────────────────────────────────────
//
// The syllables are not authored here. ``HomeWorlds/ringCharacter`` already
// carries all nine, cross-checked against the expansion doc's āvaraṇa table
// row for row when that file was ported. This file reads them.
//
// What it adds is a **voicing**, and it is built from the syllable rather than
// invented beside it:
//
//   · the **root** is the crossing tone the instrument already sounded —
//     528 Hz at the Bhūpura, falling about a whole tone per enclosure inward —
//     so the descent keeps the pitch contour it has always had and nothing a
//     walker already knows is taken away;
//   · the **partial** is a just interval chosen by the syllable's own vowel,
//     because a bīja's vowel is the part of it that is actually sounded: `ai`
//     opens a major third, `ī` a fifth, `au` a major sixth. Two sines a just
//     interval apart is what a partial *is* at this level, so it needs no new
//     DSP — the existing stepped-note voice plays both;
//   · the **notes** are one per syllable. Eight of the nine enclosures carry a
//     single syllable and sound as one tone. The eighth carries *Aiṁ Klīṁ
//     Sauḥ* — the three-syllable core — and sounds as three, in order, spaced.
//     The one enclosure whose bīja is a sentence is the one crossing that
//     sounds like a sentence.

/// The nine enclosure bījas, and how each one is sounded.
enum RingBija {

    /// One sounded syllable: a root, a partial a just interval above it, and
    /// when in the crossing it falls.
    struct Note: Equatable {
        /// The fundamental, in Hz.
        let frequency: Double
        /// The partial, in Hz — the just interval the syllable's vowel opens.
        let partial: Double
        /// How long the note rings.
        let duration: TimeInterval
        /// How long after the crossing this syllable sounds.
        let delay: TimeInterval
    }

    /// The whole enclosure's bīja, as the āvaraṇa table carries it.
    /// `HomeWorlds` is the only source; nothing is retyped here.
    static func syllable(ring: Int) -> String {
        HomeWorlds.ringCharacter[clamped(ring)]?.bija ?? ""
    }

    /// The syllables of one enclosure's bīja, in order. One for eight of the
    /// nine; three for the eighth.
    static func syllables(ring: Int) -> [String] {
        let whole = syllable(ring: ring)
        let parts = whole.split(separator: " ").map(String.init)
        return parts.isEmpty ? [] : parts
    }

    /// The crossing tone this enclosure has always sounded — the pitch contour
    /// of the descent, unchanged from `RingAudioService.ringChime`.
    static func root(ring: Int) -> Double {
        528.0 * pow(0.917, Double(clamped(ring) - 1))
    }

    /// The just interval a syllable's vowel opens, as a ratio over the root.
    ///
    /// Read off the syllable's own letters, longest vowel first so `ai` is not
    /// mistaken for a bare `a` and `au` is not mistaken for `a`. A syllable
    /// whose vowel is none of the three sounds at the unison — a single tone,
    /// which is what a bīja with nothing to open is.
    static func interval(forSyllable s: String) -> Double {
        let lower = s.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        if lower.contains("ai") { return 5.0 / 4.0 }    // major third — opening
        if lower.contains("au") { return 5.0 / 3.0 }    // major sixth — rounding
        if lower.contains("i")  { return 3.0 / 2.0 }    // fifth — piercing
        return 1.0
    }

    /// How long one syllable of this enclosure rings.
    ///
    /// **Inverse to its own pitch, and to nothing else.** A lower tone sustains
    /// longer — that is acoustics, not a table — so the deepest enclosure's
    /// syllable hangs about two and a third times as long as the Bhūpura's, and
    /// the descent slows in the ear as well as in the field.
    ///
    /// The obvious alternative was the ring's own `tempo`, which says the same
    /// thing more directly and was written that way first. It is **not** used:
    /// `WorldClimbTests.testTheTempoNeverReachesAnAdaptationClock` pins the
    /// tempo to the two files that define it and report it, precisely so that a
    /// third reader has to be argued for rather than added — and "a bell rings
    /// for about as long as the world's clock is slow" is a coincidence of
    /// shape, not an argument. The pitch was already here and already falls with
    /// depth; nothing had to be opened to reach it.
    static func duration(ring: Int) -> TimeInterval {
        1.2 * (root(ring: 1) / root(ring: ring))
    }

    /// The crossing, sounded.
    static func voicing(ring: Int) -> [Note] {
        let r = clamped(ring)
        let root = root(ring: r)
        let dur = duration(ring: r)
        let spacing = min(dur * 0.4, 0.55)
        return syllables(ring: r).enumerated().map { i, s in
            Note(frequency: root,
                 partial: root * interval(forSyllable: s),
                 duration: dur,
                 delay: Double(i) * spacing)
        }
    }

    private static func clamped(_ ring: Int) -> Int { max(1, min(9, ring)) }
}
