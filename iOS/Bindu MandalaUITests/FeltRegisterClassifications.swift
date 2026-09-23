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
    /// The largest move permitted, in points, on either axis — **measured from
    /// the nearest of ``settles``**, not from where the element used to be.
    let maxDelta: Double
    let reason: String

    /// **The rigid translations this screen's change is known to cause, in
    /// points, and the reason this type has two numbers instead of one.**
    ///
    /// A control added to a stack pushes everything below it down by its own
    /// height and leaves everything above it exactly where it was. With one
    /// number to say that with, the only way to classify it is to raise the
    /// bound to the height of the control — which is what Phase 3.7 first did on
    /// the Field, taking a 2.5 pt lock to 46.5 and making the whole screen about
    /// eighteen times coarser for the rest of the build. Charter §3 forbids
    /// exactly that: *"never weaken one to make it pass."* Re-recording the
    /// baseline was no better — these baselines are the geometry of `main`
    /// **before Phase 4**, and re-recording one from this tree would dissolve
    /// everything Phase 4's own entries are holding.
    ///
    /// So the door's 44 points are named as what they are — a translation the
    /// screen is *expected* to have made — and the residual is judged at the
    /// original resolution. `settles: [0, 44]` says: an element either did not
    /// move, or it moved by the height of the door, and either way it may be
    /// 2.5 points off that. An element that moves 20, or 60, or that fails to
    /// move when its neighbours did, is a failure again — none of which the
    /// 46.5 pt bound could see.
    ///
    /// `[0]` — the default — is the ordinary case: nothing rigid is expected,
    /// and `maxDelta` is the whole allowance, exactly as before.
    let settles: [Double]

    /// **The device class this entry speaks for, when the translation is not the
    /// same on every screen — `nil` for every entry that is.**
    ///
    /// Almost every classified move is device-independent: a string that got
    /// 1.5 pt taller got 1.5 pt taller everywhere, and an entry with no device
    /// says so by saying nothing. But a translation that is netted against a
    /// **reflow** is not, because a reflow is line-count dependent and a line
    /// count is a function of column width. Phase 3.8 is the first entry where
    /// that bites: the shelf it adds is the same height on every screen, but
    /// what it is measured against — §4.5's Cormorant paragraph — lands on a
    /// different line count on the phone than on the other two, so the residual
    /// comes out **36.00 pt on the SE, 35.58 on the Pro Max and 11.58 on the
    /// phone**. The two ends of the range agree to 0.42 pt and the middle one
    /// differs by a line.
    ///
    /// That shape is also the warning: the branch arrived with one number,
    /// `11.58`, written as though it held everywhere. It had been measured on
    /// one device. **A residual netted against a reflow must be measured on
    /// every class the lock runs on**, and this field is what lets all three
    /// answers be written down instead of one of them being widened to cover the
    /// rest.
    ///
    /// The alternatives were `maxDelta: 26`, or `settles: [11.58, 36.0]` — the
    /// first widens the lock on this screen by ten times and the second lets
    /// *any* device settle at *either* value, which is three claims where there
    /// is one fact per screen. Naming the device keeps each claim exactly as
    /// sharp as it was measured. Charter §3: never weaken a check to make it
    /// pass.
    ///
    /// `deviceKey` is what `SnapshotStore` already derives from the screen's own
    /// points — "promax" / "phone" / "se" — so an entry names the same thing the
    /// baseline directory is named after.
    let device: String?

    init(screen: String, keyContains: String, maxDelta: Double,
         settles: [Double] = [0], device: String? = nil, reason: String) {
        self.screen = screen
        self.keyContains = keyContains
        self.maxDelta = maxDelta
        self.settles = settles
        self.device = device
        self.reason = reason
    }

    /// How far this element is from the nearest translation it was classified as
    /// making. This is the number `maxDelta` bounds.
    func residual(_ moved: Double) -> Double {
        settles.map { abs(moved - $0) }.min() ?? moved
    }

    /// The classified translations, for a failure message that says which one
    /// the element missed.
    var settlesDescription: String {
        settles.map { String(format: "%.2f", $0) }.joined(separator: " or ")
    }

    static let table: [ClassifiedShift] = FeltRegisterClassifications.shifts

    /// The first entry that answers for this element **on this device**. An
    /// entry with no `device` answers for every one, as every entry written
    /// before Phase 3.8 does; an entry that names one is skipped on the others,
    /// which is what lets three sharp claims sit where one loose one would have
    /// had to.
    static func allowance(screen: String, key: String, device: String) -> ClassifiedShift? {
        table.first {
            $0.screen == screen && key.contains($0.keyContains)
                && ($0.device == nil || $0.device == device)
        }
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
        // ── Phase 3.8 · the library's first shelf ───────────────────────────
        //
        // `her moments` is the control the section's title became: the same
        // words, in the screen's own lowercase, standing where the title stood.
        // `go deeper` is not here — it was on the screen before this phase and
        // it keeps its name, its type and its 44 pt target; only the word it
        // showed while open has gone, because two shelves on one screen cannot
        // both say "less".
        ("detail", "button|her moments",
         "Phase 3.8. The library's first shelf, at the foot of the Detail's scroll, holding the "
         + "register of when she was felt. It is unconditional and it never changes with his "
         + "walking: the same row for a Śakti felt a hundred times and one felt never, which is "
         + "the whole reason the register is behind it."),

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

    /// **Elements that are no longer drawn, because a fold now stands in front
    /// of them — and the control that reaches them.**
    ///
    /// The comparison treats a disappearance as a failure with no appeal, and it
    /// was right to: three of the shift entries below are written
    /// `keyContains: "|"`, which is in every key there is, so letting a movement
    /// bound answer for a departure would have let any screen they cover lose
    /// any control it liked and stay green.
    ///
    /// Phase 3.8 is the phase whose whole job is to make a screen shorter, and
    /// what it needs is vocabulary rather than an exemption — the same answer
    /// Phase 3.7 reached when it had to say *"this moved by the height of the
    /// thing above it"* and wrote `settles` instead of raising a bound.
    ///
    /// An entry here makes one claim, and it is a claim that can be wrong:
    /// **this element is not gone, it is behind the control named `behind`, and
    /// that control is on the screen.** The comparison checks the second half
    /// itself — an entry naming a door that is not there classifies nothing and
    /// the disappearance fails as before — and `TheLibraryFoldUITests` checks
    /// the first, by opening every door named here and finding every element
    /// that went behind it, by the same key. An element that had simply been
    /// deleted has no door to name and nothing that can find it again.
    ///
    /// `TheFoldVocabularyTests` holds the entries themselves to the shape of a
    /// claim: a type, words enough to name one element rather than a screenful,
    /// a door, and a reason somebody had to write.
    static let folded: [(screen: String, keyContains: String,
                         behind: String, reason: String)] = [
        // ── Phase 3.8 · the library fold ────────────────────────────────────
        //
        // Her Moments is the register of what has passed between them, and it
        // grows a row every time she is felt. Before this fold, a Śakti felt
        // forty times had a Detail forty rows longer than a Śakti felt once —
        // the quantity was never printed, it was *drawn*, in scroll height, and
        // it was in his hand every time he reached the foot of her screen. Law 2
        // does not care which way a measure is drawn. It now stands behind
        // `her moments`, which is shut every time she is opened and is the same
        // row on the first visit and the hundredth.
        //
        // Two elements go behind it on this baseline, and both come back when it
        // is opened: the section's own title, and — because the snapshot is read
        // on a Śakti nothing has been felt for — the line that says so.
        ("detail", "text|HER MOMENTS", "her moments",
         "Phase 3.8. The section's title, behind the library's first shelf. The section itself is "
         + "unchanged — same title, same divider, same list — it is simply no longer the thing a "
         + "walker has to travel through to reach her room."),
        ("detail", "text|She has not been felt here yet.", "her moments",
         "Phase 3.8. Her Moments' own empty line, behind the same shelf. The snapshot is read on "
         + "kp 33, who is felt by nothing in this suite, so the register's empty state is what "
         + "this baseline recorded of it."),
    ]

    static let shifts: [ClassifiedShift] = [

        // ── The Detail ───────────────────────────────────────────────────────
        //
        // **Phase 3.8's one movement, named rather than left to be absorbed.**
        //
        // The library's two shelves are the last things in the Detail's scroll,
        // so the only element below the fold is `go deeper` — and it is the only
        // element on this screen that Phase 3.8 moves at all. The shelf that now
        // stands where Her Moments' section stood is shorter than the section
        // was (28 pt of air and a 44 pt target, against a divider, a title, a
        // list and their spacings), so `go deeper` rises by the difference.
        // Everything above the shelves is exactly where it was, which is the
        // design virtue rather than a lucky outcome: the fold stands at the foot
        // of the scroll precisely so that what stays out stays put.
        //
        // **It is two entries, because it is two different numbers, and that is
        // the finding rather than an inconvenience.** The shelf is the same
        // height on every screen — 28 pt of air and a 44 pt target — and so is
        // the section it replaces, to a quarter point: 97.00 pt on the SE
        // (`felt into being` bottom 941.50 to `go deeper`'s own pad at 1038.50)
        // and 96.75 on the two 6-inch classes. So 3.8's own lift is device-stable
        // at about 25 pt.
        //
        // What is *not* device-stable is what that lift is measured against.
        // These baselines are the geometry of `main` **before Phase 4**, so the
        // residual is 3.8's lift net of §4.5's Cormorant reflow — and a reflow is
        // line-count dependent, on a column the baselines record as 294.50 pt
        // wide on the SE, 338.00 on the phone and 374.25 on the Pro Max. Cormorant
        // Light is a narrower face, so her paragraph re-wraps, and **the phone is
        // the one where it lands on a different line count** — everything below
        // it settles a line lower there and the fold's lift is netted against it,
        // where on the other two it is not. Measured, on the running app, one
        // device at a time:
        //
        //     se        36.00 pt
        //     promax    35.58 pt
        //     phone     11.58 pt
        //
        // The two ends of the range agree to 0.42 pt and the middle one differs
        // by a Cormorant line. That is why this is a device claim and not one
        // number with slack around it.
        //
        // **The wrong answers, and why each is wrong.** `maxDelta: 26` would
        // cover all three and make this screen ten times coarser for the rest of
        // the build — the exact edit Phase 3.7 had to undo on the Field, and what
        // charter §3 means by *"never weaken one to make it pass."*
        // `settles: [11.5, 36.0]` would let *any* class settle at *either* value,
        // which is three claims where there is one fact per screen. So
        // `ClassifiedShift` grew a `device`, the way it grew `settles` when 3.7
        // needed to say "this moved by the height of the thing above it": every
        // claim stays at the 2.5 pt resolution it was measured at.
        //
        // **All three are pinned, and none falls through.** A fourth device class
        // would meet the 17 pt `button|` bound below and fail loudly, which is
        // the right answer: nobody has measured this element on it.
        //
        // **These entries exist at all because that bound would have taken the
        // move silently.** It allows 17 pt for the Cormorant reflow, and the
        // phone's 11.50 is inside it — so without a line here, a change *this*
        // phase made would have been absorbed by a sentence written about a
        // different one, which is the same failure as widening a bound.
        //
        // First in the table on purpose: `ClassifiedShift.allowance` takes the
        // first match, and the two blanket bounds below would otherwise answer
        // for them.
        //
        // **`0` is deliberately not in `settles`.** The Field's entry carries it
        // because that door translates only what is below it and half that
        // screen is above; here there is exactly one element under the shelves
        // and it is *required* to have moved. Allowing zero would let a fold
        // that had stopped folding pass quietly.
        ClassifiedShift(screen: "detail", keyContains: "button|go deeper",
                        maxDelta: 2.5, settles: [36.0], device: "se", reason:
            "Phase 3.8. `go deeper` is the library's second shelf and the only element below the "
            + "fold. The first shelf replaces a section taller than itself, so this rises by the "
            + "difference — 36.00 pt from the pre-Phase-4 baseline on the SE, where §4.5's "
            + "Cormorant paragraph keeps its line count and the two lifts add. Nothing above the "
            + "shelves moves at all."),
        ClassifiedShift(screen: "detail", keyContains: "button|go deeper",
                        maxDelta: 2.5, settles: [35.58], device: "promax", reason:
            "Phase 3.8, on the Pro Max: the same lift against the same reflow as the SE, in the "
            + "widest column in the instrument, and it agrees with the narrowest to 0.42 pt — "
            + "35.58 pt, measured. Nothing above the shelves moves at all."),
        ClassifiedShift(screen: "detail", keyContains: "button|go deeper",
                        maxDelta: 2.5, settles: [11.58], device: "phone", reason:
            "Phase 3.8, on the phone, and this is the class where §4.5's Cormorant paragraph lands "
            + "on a different line count — everything below it already settles a line lower here, "
            + "so the fold's ~25 pt lift is netted against that and leaves 11.58 pt. Written down "
            + "rather than left to the 17 pt Cormorant bound below, which is the one place this "
            + "move would have been swallowed without a sentence."),
        ClassifiedShift(screen: "detail", keyContains: "text|", maxDelta: 19, reason: cormorant),
        ClassifiedShift(screen: "detail", keyContains: "button|", maxDelta: 17, reason: cormorant),

        // ── The Field ────────────────────────────────────────────────────────
        //
        // **Phase 3.7's door is classified as the translation it is, and the
        // 2.5 pt resolution stays.** The door to the axis stands in the header,
        // so everything under it settles by the 44 pt the door costs after the
        // 8 the header's own padding gives back — and everything *above* it,
        // which is the header's own two lines, does not move at all. Those are
        // the two answers in `settles`, and the 2.5 this entry already carried
        // is what an element may be off whichever of them applies to it.
        //
        // This bound was briefly written as a single 46.5 — the sum of the two
        // causes — which passed, and which would also have passed an element
        // that drifted twenty points for no reason at all, or one that stayed
        // put while every one of its neighbours moved. Measured rather than
        // estimated: the largest move on the running app is 45.42 pt, which is
        // 1.42 off the classified 44.
        ClassifiedShift(screen: "field", keyContains: "|", maxDelta: 2.5, settles: [0, 44], reason:
            "\"NINE RINGS · ONE HUNDRED AND TWO\" was 10.5 pt at 0.45 α — under the floor on both "
            + "counts — and is now 11.5 at 0.55 (§4.1). The header is a point taller, so the rings "
            + "under it begin a point lower. The ring row's seat count grew the same point and "
            + "carries its chevron with it. The threshold row's 8 pt of new touch area is paid for "
            + "in that row's own padding and costs the seats nothing — and on a simulator with no "
            + "āvaraṇa the row is not there to grow, which is why that padding asks first."
            + "\n\n"
            + "Phase 3.7 adds the 44 pt the door to the axis stands in, above every ring — a rigid "
            + "translation of everything below the door and of nothing above it, which is why 44 "
            + "is written in `settles` rather than added to the bound. The door's own entry in "
            + "`appeared` has the arithmetic."),

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
