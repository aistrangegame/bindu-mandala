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
        ClassifiedShift(screen: "field", keyContains: "|", maxDelta: 2.5, reason:
            "\"NINE RINGS · ONE HUNDRED AND TWO\" was 10.5 pt at 0.45 α — under the floor on both "
            + "counts — and is now 11.5 at 0.55 (§4.1). The header is a point taller, so the rings "
            + "under it begin a point lower. The ring row's seat count grew the same point and "
            + "carries its chevron with it. The threshold row's 8 pt of new touch area is paid for "
            + "in that row's own padding and costs the seats nothing — and on a simulator with no "
            + "āvaraṇa the row is not there to grow, which is why that padding asks first."),

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
        ClassifiedShift(screen: "settings", keyContains: "text|", maxDelta: 11, reason: settingsTitles),
        ClassifiedShift(screen: "settings", keyContains: "button|", maxDelta: 11, reason: settingsTitles),
        ClassifiedShift(screen: "settings", keyContains: "switch|", maxDelta: 11, reason: settingsTitles),
        ClassifiedShift(screen: "settings", keyContains: "field|", maxDelta: 11, reason:
            settingsTitles + " The rename field also carries 2 pt of new touch area under its box "
            + "(§4.2) — the box itself is the size it was drawn, and the hint below gives the 2 pt "
            + "back, so nothing under it moves."),
    ]
}
