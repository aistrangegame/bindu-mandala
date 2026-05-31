# UX Audit — Bindu Mandala iOS

Scope: every Swift view in `iOS/Bindu Mandala/Views/` plus `BinduMandalaApp.swift`.
Read-only audit. No code changed.

## Premise reconciliation (read first)

Two parts of the brief don't match the current code:

1. **"8 tabs"** — The shipped `RootView` has exactly **3** tabs: Today, Mandala, The Well (`RootView.swift:10`). There is no `More` menu. The custom tab bar (`CustomTabBar`) does not use `UITabBar`, so iOS's "5 + More" rule does not apply automatically. Section 5 below answers what the user almost certainly means: of all the destinations a user can reach, which deserve top-level slots.
2. **"Airtable fields: readings / recognition / lalita perspective"** — none of those names exist in `AirtableService.Fields` (`AirtableService.swift:63-93`). The mapped fields are: `Name`, `Sanskrit Name`, `Avarana`, `Quality`, `Quality Description`, `Cluster Group`, `Esoteric Tattva`, `Somatic Signature`, `Bodily Location`, `Bija`, `Field Connection`, `Status`, `Notes`. Section 3 audits empty-state behavior for the fields that *do* exist, plus for the local-only artifacts the user may be thinking of (recognition log entries, letters, field connections).

---

## 1. Readability

The brief asks for **<11pt AND <0.28 opacity** as a hard-fail flag. I'll group findings by severity.

### Hard fails (≤10pt AND ≤0.22 opacity — unreadable in motion or sunlight)

| Where | Text | Size | Opacity | File:Line |
|---|---|---|---|---|
| Mandala bottom hint | "Tap a petal to enter · Bindu for silence" | 9pt | 0.22 | `MandalaScreenView.swift:139-143` |
| Silence return hint | "Tap to return" | 9pt | **0.14** | `SilenceView.swift:94-98` |
| Silence names ring | each `shortName` (×16) | 11pt | **0.16** | `SilenceView.swift:44-47` |
| Homecoming entry hint | "tap to enter" | 10pt | 0.18 | `HomecomingView.swift:49-53` |
| Recognition close hint | "Tap anywhere to close" | 10pt | 0.18 | `RecognitionMomentView.swift:112-115` |

These are dismissal/affordance hints in **dark, sacred-screen contexts**. The intent is clearly "barely there, only seen by a settled eye." That is a design choice, not a bug — but every one of these screens is also a potential dead-end (see §2). If a user does not perceive the hint, the screen has no visible way out. The two functions are in conflict.

### Sub-11pt text (above the opacity threshold)

| Where | Text | Size | Opacity |
|---|---|---|---|
| Lotus petal labels | each `shortName` (×16) | `diameter * 0.021` ≈ **7.2pt** at the shipped 344pt diameter | 0.82 / 0.38 | `LotusMandalaView.swift:84-87`
| Tab bar labels | "TODAY" / "MANDALA" / "THE WELL" (inactive) | 10pt | 0.32 | `RootView.swift:82-85`
| Cluster legend (Mandala) | cluster names | 9.5pt | 0.45 | `MandalaScreenView.swift:126-128`
| Mandala "TODAY" ray label | "TODAY" | ≈9.3pt @ d=344 | 0.7 gold | `LotusMandalaView.swift:171-175`
| ShaktiDetail section titles | "QUALITY", "BĪJA SYLLABLE · TAP TO HEAR", etc. | 9.5pt | 0.3 | `ShaktiDetailView.swift:273-276`
| ShaktiDetail status pill | status label | 10pt | full color | `ShaktiDetailView.swift:92-94`
| ShaktiDetail field-connection header | "FIELD CONNECTION — …" | 9.5pt | 0.3 | `ShaktiDetailView.swift:236-239`
| Settings section headers | "DAILY RHYTHM", etc. | 10pt | 0.7 gold | `SettingsView.swift:166-169`
| Well subtitle | "Speak to her directly. She is listening." | 9pt | 0.32 | `WellView.swift:49-52`
| ClusterDotView label | cluster name | 10.5pt | full cluster color | `ClusterDotView.swift:13-16`
| BodyOutline location label (Today V1) | e.g. "SKIN SURFACE" | 10pt | 0.65 of cluster color | `TodayView.swift:142-146`
| Today "BĪJA" label (V2) | "BĪJA" | 10pt | 0.3 | `TodayView.swift:153-156`

Most are uppercase Sanskrit/English tracked labels — they're stylistically intentional. The two I'd single out as **actually impaired**:

- **Lotus petal labels at ~7.2pt** — these name the *primary navigation* on the Mandala screen. 7.2pt @ 0.38 (status: mapped) is at the edge of perceptibility. Users will tap petals blind and rely on the detail screen to confirm identity. That may be okay (it's a discovery flow), but worth a design decision rather than an accident.
- **Inactive tab labels at 10pt @ 0.32** — these are the only labels that *change state* (gold when active). Inactive opacity of 0.32 is close to the 0.28 threshold and the contrast against `Color.ground` (#0D0508) is low.

### Items that look bad on paper but are fine in context

- Recognition Moment ripple rings at 0.17–0.35 opacity gold — decoration, not text.
- DustMotes at 0.18–0.46 opacity — decoration.
- Homecoming line text at 22pt @ 1.0 opacity — passes.
- Recognition Moment name 38pt, ShaktiDetail name 34pt, Today name 44/48pt — all pass.

---

## 2. Dead ends

A "dead end" = the screen offers no visible affordance to leave it. I evaluated every screen the user can reach.

### Root tabs (Today, Mandala, Well)

These are root; "exit" means switching tabs via the custom bar. Always visible. **OK.**

### Modal / cover screens — most have ONLY tap-to-dismiss with a faint hint

| Screen | Way out | Discoverability |
|---|---|---|
| `HomecomingView` | tap anywhere | "tap to enter" hint @ 10pt 0.18, **delayed 7.0s** (`HomecomingView.swift:120-123`). Before then there is **no visible exit**. For a first-launch screen this is by design — but a curious user could sit there a long time. |
| `SilenceView` | tap anywhere | "Tap to return" hint @ 9pt 0.14 — the faintest text in the app. Effectively invisible in bright environments. |
| `RecognitionMomentView` | tap anywhere outside the NoteCard | "Tap anywhere to close" @ 10pt 0.18, appears at ~4.1s after entry. **Tapping during the staged fade-in (0–4s) will dismiss the screen mid-ceremony** — a destructive interaction since the recognition has *already* been logged at `stage()`. Probably acceptable, but: a user who fat-fingers in the first second loses the visual of the moment they just created. |
| `ShaktiDetailView` | "‹ Mandala" custom back button (top-left) | Visible @ 14pt gold. **Swipe-back disabled** (`navigationBarBackButtonHidden(true)` + hidden toolbar). One way out only. |
| `LetterEditorView` | "‹ The Well" custom back button | Same as above. **Swipe-back disabled.** With the keyboard up, the button stays above the keyboard. OK. |
| `SettingsView` | "Done" toolbar button | Standard sheet, also swipe-down. OK. |

### Hard dead-end risks

1. **Silence + Homecoming + Recognition close hints are too faint** (see §1). On a sunny day or with screen brightness low, these screens look like they have no exit. If a user doesn't think to tap, they're trapped.
2. **ShaktiDetail and LetterEditor disable iOS swipe-back.** Custom back buttons exist and are clearly labeled, but users with iPhones expect edge-swipe. Not a dead-end per se, but a friction point.
3. **No dead ends from accidental state.** I checked: no `fullScreenCover` is presented from a state the user can't undo, no nested cover stacks.

---

## 3. Empty states

I'll cover the user's named fields plus what's actually wired.

### "Readings" — does not exist

No Airtable field named `Readings`. Not rendered anywhere.

### "Recognition" — two interpretations

**(a) `recognitionPhrase` per Śakti** — used on Recognition Moment (`RecognitionMomentView.swift:65`). **Not pulled from Airtable** — it is hard-coded in `ShaktiBootstrap.all` for every Śakti. So this is never empty unless the bootstrap data is broken. Empty-state risk: zero.

**(b) `RecognitionEntry` log entries per Śakti** — shown in `HerMomentsList` on `ShaktiDetailView`. **Empty state handled well**: "She has not been felt here yet." @ 14pt italic 0.35 (`ShaktiDetailView.swift:294-297`). Graceful.

### "Lalita perspective" — does not exist

No such field in the model, the Airtable mapping, or any view. If this is a *planned* field, it has no surface yet.

### Other empty-state behaviors worth flagging

| Surface | What happens when source is empty | Verdict |
|---|---|---|
| Today screen with no `shaktis` in store | Shows `ProgressView()` indefinitely (`TodayView.swift:54-56`). Bootstrap should always seed via `ShaktiBootstrap.seedIfNeeded` on first launch, but if seeding fails silently, **the user sees a spinner forever**. No "could not load" message. | **Fragile** |
| Today `s.somatic` empty | Renders `""` (curly-quotes around empty: `"\u{201C}\(s.somatic)\u{201D}"`) → two quotes with no content. (`TodayView.swift:127`) | Ugly but not broken |
| Today `s.bija` empty | Background giant bīja text is invisible; "Today's Bīja — " footnote ends with a dash; V2 variant shows blank 42pt area. | Ugly |
| ShaktiDetail Field Connection section | Gated by `if shakti.hasFieldConnection` (`ShaktiDetailView.swift:27`). Renders nothing when empty. | **Graceful** |
| ShaktiDetail `qualityDescription`, `somaticPoetry`, `tattva` empty | Renders empty containers with section headings but no body text. | Ugly |
| Well row when no letter saved | "You can speak to her here" italic placeholder (`WellView.swift:81-84`). | **Graceful** |
| LetterEditor empty draft | "Speak to her directly. She is listening." italic placeholder (`WellView.swift:115-121`). | **Graceful** |
| Mandala when `shaktis.isEmpty` | `LotusMandalaView`'s `shakti(at:)` defensively `shaktis[index % shaktis.count]` will **crash on empty array** (mod by zero / out of range) (`LotusMandalaView.swift:218-220`). MandalaScreenView passes `todayIndex: nil` only as guard, but still calls `LotusMandalaView` with the empty array. | **Crash risk** |
| Mandala progress counts (e.g. `0 of 0 Active`) | Renders literal "0 of 0". | Harmless |
| Settings `fieldRow` when Śakti not seeded | `if let shakti = …` guard returns nothing — section silently empty. | Safe |

### Airtable resilience

`AirtableService.reconcile` only overwrites local fields **when remote is non-empty** (`AirtableService.swift:129-136`). So an empty Airtable cell will never blow away the bootstrap value — a deliberate, good defensive pattern. The local cache stays as the source of truth at read time. Empty-state risk from Airtable downtime: low.

---

## 4. Broken interactions

I audited every Button, Toggle, TextField/TextEditor, gesture, and tappable shape.

### Working as expected

- **Today**: "I feel her" CTA → presents `RecognitionMomentView`. Settings gear → presents Settings sheet.
- **Recognition Moment**: outer tap → dismisses (and persists note if any). NoteCard onTapGesture → focuses TextField without dismissing parent (correct propagation control).
- **Mandala**: petal tap → opens detail. Bindu tap → opens Silence. Hit area for petals is loosened by `PetalShape(outerRatio: 0.46, innerRatio: 0.10, halfWidthRatio: 0.11)` (`LotusMandalaView.swift:74-76`) — generous. Bindu has explicit 64×64 hit target.
- **Well**: row tap → opens LetterEditor with the right Śakti. TextEditor → saves on `onDisappear`.
- **ShaktiDetail**: status pill → advances through mapped → exploring → active → embodied with ceremony animation; at embodied it taps softly (no-op). Bīja text and play disc both call `soundBija()`. Back button → dismiss.
- **Settings**: notifications Toggle → triggers permission flow. Start-hour & cadence pickers → reschedule. Field-name TextFields → persist via SwiftData `context.save()` on edit. Re-enter Homecoming → resets UserDefaults flag, posts notification, dismisses.
- **Custom TabBar**: switches tabs with haptic.
- **Homecoming / Silence**: tap to dismiss.

### Issues

1. **Status pill has no visual affordance for tappability** (`ShaktiDetailView.swift:88-107`). It's styled as a label. The ceremony only fires *after* a tap, so first-time users will not know they can advance status. **High discoverability cost** for a core action (the whole status model is unreachable otherwise).

2. **Bīja sound disc is decorative** but the play-icon glyph + dual rings look like a control. Both the disc and the bīja glyph trigger `soundBija()`, so taps on either work — but the *only* hint they're tappable is the section title "Tap to Hear." The icon's visual style is loud relative to its actual purpose (it duplicates the bīja's behavior).

3. **"Today's Bīja — uṁ" footnote** (`TodayView.swift:178-182`) reads like a tappable affordance (the dash + bīja syllable). It's static text. Potential miscue.

4. **Recognition Moment: tap-to-dismiss is live during the 0–4 second staged entry.** The recognition is logged at `stage()` (line 132), so an early dismiss still leaves a log entry — but the user sees almost nothing of the ceremony. Consider gating dismissal behind, e.g., `nameVisible == true` or a minimum 2s.

5. **Silence will record a `silence` entry only if `duration >= 1.0`** (`SilenceView.swift:172-179`). A quick double-tap to close — unintentional or otherwise — silently does nothing. Fine, but the contract is invisible.

6. **LotusMandalaView `shakti(at:)` will out-of-range on empty array** — see §3.

7. **No swipe-back on ShaktiDetail and LetterEditor.** Not "broken" but breaks platform convention.

8. **No sliders in the app.** No swipe gestures beyond standard ScrollView. No drag-to-dismiss anywhere except the system sheet on Settings.

9. **DustMotes, RippleRings, MoonPhase glyph, BodyOutline, PetalShape outer petals (ghost ring)** — all decorative with `.allowsHitTesting(false)` where appropriate. No phantom touch targets. Verified.

---

## 5. Tab bar — answering for the actual app

Current state: **3 tabs in code, not 8.** `RootView.swift:10` defines `enum Tab { case today, mandala, well }`. The custom `CustomTabBar` does not surface a More menu.

If the intent is to add more destinations, here is a prioritization of all currently-reachable surfaces, ranked by frequency × centrality to the practice:

### Should be top-level (the 5 most important)

1. **Today** — the daily anchor, the only place "I feel her" is triggered. The single most-used surface. Non-negotiable.
2. **Mandala** — navigation hub for all 16 Śaktis + entry to Silence. The map of the whole app.
3. **The Well** — the private writing surface; users will return to letters daily.
4. **Silence** — currently buried as a Bindu-tap inside Mandala. It is a *practice* in itself and a frequent destination; surfacing it would reduce friction. (Counter-argument: tapping the Bindu *is* the ritual, and a tab would cheapen it. Designer's call.)
5. **Settings** — currently a gear icon on Today only. Reasonable to keep there; if surfaced as a tab it would be the lowest-traffic of the 5.

### Belong in More / secondary nav (the 3 least important)

1. **ShaktiDetail** — already accessed by tapping a petal; should *not* be a tab (no canonical "current" Śakti for a tab to point at).
2. **Recognition Moment** — a *modal ceremony*, not a destination. Should never be a tab.
3. **Homecoming** — first-launch only, plus the "Re-enter the Homecoming" Settings button. Not a tab.

### My recommendation if the spec really is 8 tabs

It probably isn't, but: most apps that ship 8 tabs are masking unsolved IA. The Bindu Mandala's natural shape is **3 spatial tabs (Today / Mandala / Well) + a few modal ceremonies (Recognition, Silence, Homecoming).** Settings stays a gear. Adding more would dilute the design language. If the brief mentions 8 tabs, suggest aligning the brief to the code rather than the code to the brief.

---

## 6. Cognitive load

I counted distinct attention-competitors per screen and identified the primary action. "Competitor" = anything that draws the eye and is independently rendered (decoration counted at a coarser level so it doesn't dominate).

| Screen | Elements competing for attention | Primary action |
|---|---|---|
| **Today (V1, body variant)** | (1) moon header, (2) cluster dot+label, (3) **name (44pt)**, (4) phonetic, (5) **quality (gold 20pt)**, (6) divider, (7) **somatic prompt (19pt italic)**, (8) body outline + location, (9) **"I feel her" red CTA**, (10) bīja footnote, plus DustMotes + radial gradient | **"I feel her"** — clearly dominant; the red capsule is the only saturated red element. Load: **medium-high (~9 elements)** but well hierarchized — eye lands on name, then prompt, then CTA. |
| **Today (V2, bīja variant)** | All of (1)–(7) + giant background bīja (280pt @ 0.07) + foreground 42pt bīja + "BĪJA" label + same CTA + footnote. The body outline section is replaced by the foreground bīja. | Same. Slightly **less load** (the body outline is more visually busy than centered bīja). |
| **Mandala** | (1) Avarana heading, (2–17) **16 petals**, (18) TODAY ray + label, (19) bindu glow, (20) progress count line, (21) **5-cluster legend**, (22) bottom hint. Plus ghost geometry (3 outer rings) and 8 ghost petals. | **Tap a petal**. Load: **high** (22+ elements), but the lotus geometry organizes them spatially so it feels like one composition rather than 22 items. The cluster legend at the bottom is the most expendable competing element — it teaches the color code but isn't navigable. |
| **The Well (list)** | Header (2 lines) + 16 rows, each row has 4 sub-elements (dot, name, preview, chevron) + divider. | **Tap a row**. Load: **medium** — a vertical list reads sequentially; the eye doesn't need to choose between rows. |
| **LetterEditor** | Header (back / Śakti name / cluster dot) + placeholder + the TextEditor itself. | **Type a letter**. Load: **low** — this is the cleanest screen in the app. Good. |
| **ShaktiDetail** | navBar + name + phonetic + cluster+status pill + 5–6 sections (Quality, Somatic, **Bīja 108pt**, Tattva, Field Connection, Her Moments). | **Tap bīja to hear** is the only obvious action; **advance status pill** is the hidden one. Load: **high but well-paginated** — each section is visually distinct. The 108pt bīja sits in the middle of the scroll and may pull more attention than it warrants given how short the play interaction is. |
| **Recognition Moment** | Giant background bīja + 4 ripple rings + name + divider + recognitionPhrase + 2-act log (with divider) + optional NoteCard + close hint. **Staged over ~4 seconds.** | **Receive the moment**. Optionally write a note. Load is **deliberately high** but staged over time — at any given second only 2–3 elements are visible/animated. The temporal staging is the right tool here. |
| **Silence** | 16 names in faint outer circle + 3 outer ghost rings + outer light ring + bindu + caption (after 7s) + return hint. | **Be here, then tap to return**. Load: **very low** — by design. The eye has only the bindu and (optionally) the names to land on. |
| **Settings** | 4 sections: Daily Rhythm (toggle + 2 pickers + caption), Field Connections (3 editable rows + caption), Bīja (caption only), Homecoming (button + caption). | **Toggle "Let her arrive"** is the most consequential. Load: **medium**, organized into card sections — reads well. |
| **Homecoming** | Bindu + 2 staged lines + entry hint. | **Tap to enter** (after observing). Load: **very low.** |
| **Custom Tab Bar (persistent)** | 3 tab buttons (icon + label each). | Switch tab. Load: **negligible**. |

### Patterns worth naming

- The app's overall load profile is **bimodal**: ceremonial screens (Homecoming, Silence, LetterEditor) are very low-load and very intentional; practice screens (Today, Mandala, ShaktiDetail) are medium-to-high but pull it off through spatial hierarchy and typographic restraint.
- **Today's "I feel her" red capsule is the only saturated red CTA in the entire app.** That is a strong, defensible design move — it makes the primary action unmistakable. Don't dilute it elsewhere.
- The **status pill on ShaktiDetail** is the largest cognitive-load weakness: a high-value action with no affordance, surrounded by 5+ static info sections. It's easy to miss.

---

## Summary of recommendations (not changes — just flags)

1. **Lift the lotus petal label size** above 7.2pt (or commit to "petals are tapped blind, names belong on the detail").
2. **Make tap-to-dismiss hints survive bright daylight.** Silence's 9pt @ 0.14 is too faint to count as an exit. Either raise to ≥0.28 or add a subtle pulse so the eye finds it.
3. **Give the ShaktiDetail status pill a visible affordance** (underline on tap, chevron, or a "Tap to deepen" sub-line). The whole status model is otherwise undiscoverable.
4. **Guard `LotusMandalaView` against empty `shaktis`** — it crashes on mod-by-zero. Render a skeleton or a "loading" lotus instead.
5. **Re-decide the 8-tab brief.** The app's natural shape is 3 tabs + ceremonies. If a future spec adds tabs, prioritize Today / Mandala / Well as top-level and keep ceremonies modal.
6. **Re-decide swipe-back-disabled** on ShaktiDetail and LetterEditor. Custom back buttons are clean, but iOS users expect edge-swipe.
7. **Empty-state polish** on Today: if `s.somatic` / `s.bija` / `s.qualityDescription` ever come back empty (from a future Airtable change), the screen will look broken. Defensive copy or skip-rendering would help.

End of audit.
