# The method

*How we work when a new space opens. Written from what actually moved the work,
not from good intentions. Read this first, before designing anything new here.*

---

## 0 · Read everything before making anything

Before the first pixel: open the **best thing already built in this project** and
find its ceiling. Not the brief — the *work*. The brief tells you the intent; the
existing files tell you the standard.

The failure this prevents actually happened: a whole first pass was designed from
assumptions while `ring-nine.jsx` (a blooming Śrī Yantra, Shepard tones, per-ring
verbs) sat unopened in the same folder. The output was a dim gradient with serif
text on it, and it was rightly called a downgrade. **Nothing about the brief caused
that. Not reading did.**

So: list the directory. Read the two or three richest files. Read the data spine.
The 102 cards (from Airtable) are authoritative; `all-shaktis-data.js` is superseded.
Read `github.md` to know what shipped. Then design.

## 1 · Mechanism, never mood

A mood is unbuildable and produces decoration. A mechanism is buildable and
produces design.

- ✗ "cathedral, Hans Zimmer, grand" → a gradient and big type
- ✓ "Turrell: nothing appears to happen until your eyes have adjusted, and only
  then is it clear the room was exact the whole time" → an adaptation clock every
  surface reads from

When a direction arrives as an adjective, convert it to a mechanism **out loud**
and get that confirmed before building. If the ask names a reference, the question
is always *what does it DO*, not *what does it look like*.

## 2 · Never show the first attempt

The first instinct is the average of everything ever seen. It is, by construction,
the least original thing available.

**Standing rule: push to V2 silently, push to V3 silently, then think twice before
showing V3.** This does not need to be asked for again. If a pass can be described
in one sentence that a competent stranger would also have written, it is not done.

## 3 · Say the plan in plain words, and distrust your own vocabulary

Any time the reasoning can only be explained in labels — "P0 → P10", "the sample
gate", "phase 3c" — the labels are hiding a thought that hasn't been had.

The moment the plan had to be restated in plain language, the real error surfaced:
the brief's *uniqueness grammar* (Quality → the room's soul, Function → the room's
mechanism, Somatic → the room's physics) had been flattened into two decorative
knobs, aperture shape and fade speed. The brief was more radical than the build.

**Before building: state what each piece DOES in one sentence with no project
jargon. If that sentence is boring, the piece is wrong — not the sentence.**

## 4 · Fix the rule, not the instance

Four consecutive rounds went to the same class of bug — geometry derived on one
side, hardcoded on the other — because each round fixed the pixel that was
reported. The fix was one exported function both sides read from
(`riteApertureSpan`).

When a defect appears: **name the class before touching the code.** If the same
class can recur elsewhere, fix it where it's derived, once.

## 5 · No cuts, only travel

This is the strongest single principle in the project and it was discovered late.

Three separate pieces — a threshold viewer, a room switcher, a world switcher —
became one instrument the moment they were replaced by **continuous movement
through one space**. The climb, the flight into a point of light, the air
thickening until the world is swallowed. Every switcher, menu, tab, modal and fade
to black is a place where the experience stops being an experience.

**Applies to everything new: if the user has to choose from a list, the design
isn't finished.** The rite became the *distance travelled*, not a screen before
the room. That's the shape to look for.

## 6 · One engine with N tunings, never N artefacts

102 rooms cannot be hand-made, and a gallery of hand-made rooms cannot be
implemented — Code needs a rule. Build the engine, then condition it.

The working form: **the mechanism is hers; the light, material and geometry come
from her world.** The same mechanism in a different āvaraṇa is a different room,
because the gem is the light and the dhātu is the material. Un-authored Śaktis
inherit the shared floor, which is honest and shows exactly what's still waiting.

## 7 · Build from the real data, degrade gracefully, never invent canon

Every name, count and phrase comes from the project's own data. The 102 are
28 · 16 · 8 · 14 · 10 · 10 · 12 · 3 · 1 because the data says so, not because it
was recalled. Where a field is missing, degrade visibly to the shared floor —
never fabricate a plausible-looking substitute. The gaps are information.

## 8 · Verify what the eye can't reach — and verify backwards

WebGL canvases cannot be screenshotted here — the capture re-renders the DOM, so a
live canvas photographs as pure black. Verify 3D by reading pixels off the GPU
(`renderer.render()` then `gl.readPixels` — a cold read without an immediate
render returns zeros).

But pixel reads are only the second of three levels, and the third is the one
that finds real work:

- **V1 — "does it load"**: console errors, a screenshot, click the main control.
  Only ever proves nothing crashed.
- **V2 — "measure what I built"**: luminance grids, label uniqueness, geometry
  deltas. Catches much — but verifies the code against *itself*, checks only what
  was remembered, and is per-piece. **Structurally blind to regressions between
  files and to written claims the artifact doesn't honour.**
- **V3 — run backwards from what has been claimed**, as a harness that can fail:
  *canon* (every datum traces to the user's files) · *coverage* (all of them, not
  samples) · *distinction* (the brief's own test, measured) · *legibility* (every
  state rendered for real) · *promise* (every written claim asserted against code)
  · *felt* (nothing measures the user out loud) · *coherence* (one artifact, no
  orphans, no lost features, the record and the build agreeing).

`The Homes - Verification V3.html` is the working instance. It found six real
defects, including **a whole feature the Axis had silently dropped from an earlier
piece** — and one false positive in its own first version, which is the reminder
that **the verifier needs verifying too**.

Also standing: module `<script>` imports cache — bump a `?v=` query after editing.
And `Object3D.position` is read-only; `Object.assign(light, {position})` throws in
a module and silently kills the whole file. Additive points at close range stack
to pure white — clamp `gl_PointSize`.

## 9 · Time is elapsed, never device-tied

Locked decision, governs everything: mechanisms run on real elapsed seconds — not
proximity, not device motion, not stillness. Stillness may govern *arrival* of
something, never its *persistence* (once a line has surfaced it stays for the
visit; a high-water mark, not a live reading).

## 10 · Never measure it out loud

No counters, no percentages, no "3 of 9", no progress bars, no badges. The
instrument may know everything about you and must display none of it. Depth is
felt — a ceremony that runs quicker, a room that opens further along, a light
already lit when you arrive.

## 11 · Register decisions where they survive the conversation

Chat is not memory. Every locked decision goes into `The Homes - the thread.md`
(or its equivalent for a new space) in the same turn it is made. Anything that
lives only in a message is already lost.

---

## The shape of a new space

1. **Read** — the richest existing files, the data spine, the thread.
2. **Convert** — every adjective in the ask into a mechanism, stated plainly.
3. **Concept, three passes deep, before any build** — and show only the third.
4. **Judge against the ask's own test** — for The Homes: *could this room belong to
   any other Śakti?* Every new space needs such a sentence; find it in the brief.
5. **Build the engine, condition it, show the gaps.**
6. **Verify by probe, not by faith.**
7. **Write the decisions down.**

## What to ask for, and when

Ask when the answer changes what gets built and cannot be derived from the files.
Do not ask what the data already answers. One form, composed, most important
first. Then build — and when a call is genuinely mine to make, make it and say
which way I went and why.
