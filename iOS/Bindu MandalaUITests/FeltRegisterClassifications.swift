import Foundation

// MARK: - Every move this phase made, written down
//
// `FeltRegisterSnapshots` compares each screen against the geometry of `main`
// before Phase 4. Anything that moved has to appear here, with how far and why.
// That is the whole mechanism, and the friction is the point: a hit area that
// grew and pushed its neighbour down cannot pass quietly — somebody has to type
// the sentence that says it did.
//
// Two kinds of entry are legitimate, and no third:
//
//  1. **A string got legible.** FIDELITY rule 4 asks for ≥ 11 pt and ≥ 0.5 α. A
//     label that grows from 10 pt to 11.5 pt is one and a half points taller, so
//     it and everything under it in its stack settles by that much. The words are
//     in the same place on the screen; they are simply readable there now.
//
//  2. **A touch target grew, and the growth was paid for.** Every one of the
//     eight is grown by a *known* number of points and the same number comes back
//     out of the padding or spacing beside it, so the drawn composition does not
//     move at all. Where a hit area appears here it is the control's *reported*
//     frame — what iOS hit-tests and what VoiceOver announces — opening out
//     around words that did not move.
//
// A shift with no entry is a regression. An entry with a vague reason is a
// regression somebody talked their way past.
//
// **On bounds that cover a whole screen.** Three screens carry one cause that
// reaches every string on them — Settings' five section titles, the Detail's
// reflowed paragraph, the Field's header — and there, an entry bounds a *type*
// of element rather than naming forty of them one at a time. The bound is the
// largest move that cause can produce, measured, not estimated; anything past it
// still fails. Where the cause is local, the entry names the control.

struct ClassifiedShift {
    /// The screen's name in `SnapshotScreen.all`.
    let screen: String
    /// A substring of the element's key (`type|label|ordinal`). A substring,
    /// because the key carries the walker's own words and those are long.
    let keyContains: String
    /// The largest move permitted, in points, on either axis.
    let maxDelta: Double
    let reason: String

    static let table: [ClassifiedShift] = FeltRegisterClassifications.shifts

    static func allowance(screen: String, key: String) -> ClassifiedShift? {
        table.first { $0.screen == screen && key.contains($0.keyContains) }
    }
}

enum FeltRegisterClassifications {

    // The three sentences the entries below refer back to, written once.

    /// §4.5, from the device audit's Also-observed 6.
    private static let cormorant =
        "The Detail's quality paragraph was the one body text in the instrument still set in a "
        + "system sans; §4.5 puts it in Cormorant at 15 pt. Cormorant Light is a narrower face, "
        + "so her paragraph reflows a line shorter and everything under it in the scroll settles "
        + "upward by that line. The section titles below it are each 1.5 pt taller as well "
        + "(10.5 → 11.5, §4.1), which is the rest of it. Nothing was re-composed: the same blocks "
        + "in the same order, closer together by the height of one line of type."

    /// §4.1 over a sheet of stacked cards.
    private static let settingsTitles =
        "Settings' five section titles were 10 pt — under FIDELITY rule 4's floor — and are now "
        + "11.5. Five cards, each 1.5 pt taller, so a row settles by up to that many points times "
        + "the number of cards above it. The sheet's own title moved from `.navigationTitle`, "
        + "which renders in the system face, to a principal toolbar item in Cormorant (§4.5), "
        + "which is a point or two of navigation-bar height. Every card is in the same order at "
        + "the same margin."
        + "\n\n"
        + "§4.3 adds a fraction of a point per row on top of that, and the bound went from 11 to "
        + "14 to hold it. A scaled token is `Font.custom(_:size:relativeTo:)` rather than "
        + "`Font.custom(_:size:)`, and a font measured against a text style carries that style's "
        + "own line metrics — the same glyphs at the same point size, in a line box a hair "
        + "taller. On one row it is invisible; Settings is eight cards deep, so its last two rows "
        + "settled 12.5 pt against the 11 that had been classified. Measured, not estimated: on "
        + "every other screen in the roster, nothing moved past the bound it already had."

    /// §4.2, the reported frame rather than the drawn one.
    private static let reportedFrame =
        "This is the control's reported frame opening out, not the words moving. Its own padding "
        + "moved from the Button on to the label — identical layout, and the drawn line is "
        + "untouched — so what changed is the box iOS hit-tests and VoiceOver announces, which is "
        + "exactly the point of §4.2. Audit §H4 measured this one at about 19 pt tall."

    /// Elements that are on a screen now and were not before. A movement bound
    /// cannot stand in for one of these: `keyContains: "|"` matches every key
    /// there is, and three of the entries below are written that way, so a
    /// blanket allowance would have let any screen grow anything at all. This
    /// list is separate, exact, and there is one entry in it.
    ///
    /// `screen` and `keyContains` read the same way they do in a shift.
    static let appeared: [(screen: String, keyContains: String, reason: String)] = [
        // ── §4.4 · the Mandala, reachable ───────────────────────────────────
        //
        // The living Mandala is one `Canvas`, and a canvas has no accessibility
        // tree — audit §H5: *"the 102 seats are invisible to VoiceOver."*
        // `MandalaAccessibilityLayer` is the tree the drawing does not have: one
        // element per seat that is on the screen, one per enclosure whose ring
        // is, each standing where the canvas drew the thing it speaks for.
        //
        // **Nothing drawn changed.** Every element is a `Color.clear` and the
        // whole layer is `allowsHitTesting(false)`, so the field's pan, pinch
        // and tap still belong to the one gesture catcher underneath and not a
        // pixel moved. What arrived is a hundred and eleven *announcements* —
        // the composition of the spoken screen, which did not exist at all
        // before. iOS reports them as buttons, because an element carrying an
        // activate action is a button; that is why they are visible to this
        // reader rather than invisible to it.
        //
        // Two entries per screen, because a seat and an enclosure say different
        // things: every seat ends "…of the one hundred and two." and every
        // enclosure names its form. On a simulator with `SYNC_OFF` only Ring 2's
        // sixteen are seated, so sixteen and one arrive; on the full instrument
        // it is a hundred and two and nine.
        ("mandala", "of the one hundred and two.",
         "§4.4. One spoken element per seated Śakti, standing where the canvas drew her. "
         + "Nothing drawn moved: the layer is `Color.clear` and hit-tests nothing."),
        ("mandala", "enclosure. ",
         "§4.4. One spoken element per enclosure whose ring is on the screen, standing where "
         + "the canvas writes its name."),

        // The Detail is a `fullScreenCover`, and a cover leaves the screen
        // beneath it in the tree — the committed baseline for `detail` carries
        // the Mandala's own header and zoom column for exactly that reason. So
        // the same seventeen arrive here, from the same layer, behind the sheet.
        ("detail", "of the one hundred and two.",
         "§4.4, behind the cover — the Detail's baseline already carries the Mandala beneath it."),
        ("detail", "enclosure. ",
         "§4.4, behind the cover — the Detail's baseline already carries the Mandala beneath it."),

        // ── §4.4 · the tap-anywhere exit ────────────────────────────────────
        ("recognition", "Close this moment and return.",
         "§4.4. The whole ceremony is the way out, which gives a sighted walker a target the "
         + "size of the glass and a VoiceOver walker nothing at all — there is no element under "
         + "the finger to find. This is that element: `Color.clear`, hit-tests nothing, carries "
         + "the action, and sorted last so the two Recognition lines are still what the screen "
         + "says first. Their words and their 2.6 / 4.1 / 5.1 second staging are untouched."),

        // ── Phase 3.7 · the two doors ───────────────────────────────────────
        //
        // This file was written for a phase that was forbidden to re-compose a
        // screen, and it says so in its own header. Phase 3.7 is the phase whose
        // whole job is to add one thing to two screens: until it landed, the
        // rite of entering, the hundred and two rooms and the nine-āvaraṇa climb
        // were unreachable from the shipping shell — built, tested, and dead.
        // So these are not Phase 4 moves that slipped through; they are the two
        // doors, named, with what each one costs measured rather than estimated.
        ("detail", "Be with her",
         "Phase 3.7. The way into her room, in the Detail's footer above “I feel her”. It is "
         + "outside the ScrollView, so it grows downward from the scroll's own edge and **nothing "
         + "on the Detail moves**: there is no accompanying shift entry, and any movement of an "
         + "existing element here is still a failure."),
        ("field", "Rise through the nine",
         "Phase 3.7. The way onto the axis, under the Field's own “NINE RINGS · ONE HUNDRED AND "
         + "TWO” — the one screen in the app whose subject is the nine. It costs 52 pt (a 44 pt "
         + "target and the header stack's 8 pt spacing); 8 of them are paid for out of the "
         + "header's own bottom padding, 14 → 6, because a 15 pt line centred in a 44 pt target "
         + "already stands about fourteen points clear of its own box. The other 44 are the shift "
         + "entry below."),

        ("settings", "text|Settings|1",
         "A second \"Settings\" — the principal toolbar item that says the sheet's name in "
         + "Cormorant (§4.5). `.navigationTitle(\"Settings\")` stays beneath it, because "
         + "VoiceOver and the back stack read that one; only the rendering was wrong."),
    ]

    static let shifts: [ClassifiedShift] = [

        // ── The Detail ───────────────────────────────────────────────────────
        ClassifiedShift(screen: "detail", keyContains: "text|", maxDelta: 19, reason: cormorant),
        ClassifiedShift(screen: "detail", keyContains: "button|", maxDelta: 17, reason: cormorant),

        // ── The Field ────────────────────────────────────────────────────────
        //
        // **Phase 3.7 raised this bound from 2.5 pt to 46.5, and that is a real
        // loss of resolution on this one screen — written down rather than
        // waved past.** The door to the axis stands in the header, so everything
        // under it settles by the 44 pt the door costs after the 8 the header's
        // own padding gives back, **plus** the 2.5 this entry already carried:
        // the two causes are in the same stack and add. Measured rather than
        // estimated — the largest move on the running app is 45.42 pt, and the
        // bound is the sum of the two classified causes rather than that
        // reading rounded up. A tighter bound is not available: the shift is a
        // single rigid translation of the whole list, and this file's vocabulary
        // is a per-element maximum. What is still caught is any element that
        // moves *further* than the door pushed it, and every arrival, which
        // needs its own sentence above.
        ClassifiedShift(screen: "field", keyContains: "|", maxDelta: 46.5, reason:
            "\"NINE RINGS · ONE HUNDRED AND TWO\" was 10.5 pt at 0.45 α — under the floor on both "
            + "counts — and is now 11.5 at 0.55 (§4.1). The header is a point taller, so the rings "
            + "under it begin a point lower. The ring row's seat count grew the same point and "
            + "carries its chevron with it. The threshold row's 8 pt of new touch area is paid for "
            + "in that row's own padding and costs the seats nothing — and on a simulator with no "
            + "āvaraṇa the row is not there to grow, which is why that padding asks first."
            + "\n\n"
            + "Phase 3.7 adds the 44 pt the door to the axis stands in, above every ring. The "
            + "door's own entry in `appeared` has the arithmetic."),

        // ── The Bindu's descent ──────────────────────────────────────────────
        ClassifiedShift(screen: "mandala-descent", keyContains: "↑ return to the field",
                        maxDelta: 9, reason: reportedFrame),
        ClassifiedShift(screen: "mandala-descent", keyContains: "|", maxDelta: 3, reason:
            "\"NINTH ĀVARAṆA · THE BINDU\" was 10.5 pt and \"SOUND THE SOURCE\" 10 pt at 0.5 α; "
            + "both are now 11.5 at 0.55 (§4.1). The Bindu's words are a staged column, so two "
            + "labels a point and a half taller settle the lines between them by a point or two. "
            + "The order, the centring and the staging are unchanged."),

        // ── The ceremony ─────────────────────────────────────────────────────
        ClassifiedShift(screen: "recognition", keyContains: "|", maxDelta: 2, reason:
            "\"Tap anywhere to close\" was 10 pt at 0.40 α and now sits exactly on rule 4's floor, "
            + "11 pt at 0.50 — a ghost still, but a legible one (§4.1). It is the last line in a "
            + "bottom-anchored column, so the acts above it settle by a point. The two Recognition "
            + "lines, their words and their 2.6 / 4.1 / 5.1 second staging are untouched."),

        // ── Settings ─────────────────────────────────────────────────────────
        ClassifiedShift(screen: "settings", keyContains: "text|", maxDelta: 14, reason: settingsTitles),
        ClassifiedShift(screen: "settings", keyContains: "button|", maxDelta: 14, reason: settingsTitles),
        ClassifiedShift(screen: "settings", keyContains: "switch|", maxDelta: 14, reason: settingsTitles),
        ClassifiedShift(screen: "settings", keyContains: "field|", maxDelta: 14, reason:
            settingsTitles + " The rename field also carries 2 pt of new touch area under its box "
            + "(§4.2) — the box itself is the size it was drawn, and the hint below gives the 2 pt "
            + "back, so nothing under it moves."),
    ]
}
