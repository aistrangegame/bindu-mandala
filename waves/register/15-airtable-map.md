# THE REGISTER · 15 · The Map (Airtable)

*Reader 15 · the second reading · written 2026-10-12 (night)*
*Source: base `app248ZTWhYJlvQj2` · table **The Map** `tblwpmyKOeMxEEHd7` · 33 records · 58 fields · 564,253 bytes of record JSON*

**Scope.** The canonical record of the 33 chakras, in full. I joined the field ids to their names with `python3 -I` and wrote each record as text, in Book Position order (`bp01…bp33`). Then I read every field of every record with the Read tool, from line 1 to the end (6,368 lines). The schema (all 58 field descriptions) was read the same way. For comparison I used:
- the register's two chakra readers (`05-chakra-corpus.md`, `06-chakra-skills.md`), looked up by grep and partial reads;
- the baked walk canon (`chakra-upload/extracted/uploads/walk-canon.json`);
- the app's bundle (`iOS/Bindu Mandala/Data/ChakraConstellation.json`).

Both files were compared programmatically, field by field.

**Sealed layer.** Chakra 32 (the Ego Reveal) is sealed by his ruling 2. For 32 this register gives only field names, sizes and identity cells that are already public (verb, colour, subtitle, Śakti, mudrā name). No reveal text is quoted, paraphrased or summarised.

Lalita's Gate Text says that a final Reveal is "held in the build itself". The record does not describe it, and neither does this register.

**Author substrate.** The canon's law `author_substrate_never_surfaced_verbatim` covers two fields: **Gaia Voice** (`author_substrate.gaia_voice`) and **Shakti Practice** (`author_substrate.app_build_note`). Here they are counted and described by mechanism. They are never quoted.

**Tags.** **[E]** marks an *energy* field: practice, gate, body, sound, yantra structure, teaching-as-recognition. **[S]** marks a *story* field: narrative voice, a Bindu Feed candidate. *substrate* marks an author-only field.

### Five findings first

1. **The Map, the canon and the app agree to the byte.** Every field the walk canon v1.0 bakes, and every field the app bundle carries, equals the live Airtable cell. There is no drift.
2. **Two names are crossed between the canon and the Map** (see C1):
   - The canon's `leela_story` is the Map's **Story Thread**.
   - The canon's `gate_text` is the Map's **Leela Story**.
   - The canon's `bindu_reflection` is the Map's **Post-Engagement Teaching**.

   Register 05 quotes under the canon's names. The app uses the Map's names, which are correct.
3. **About 175,000 characters of energy material are not in the app at all.** A further 30,430 characters of Gaia Voice (story, substrate) are also missing. In all, 21 fields are absent from the bundle (A.0, "Bundle: no"). The main ones:

   | Field | Size |
   |---|---|
   | Teaching Text | 79k |
   | Post-Engagement Teaching | 47k |
   | Shakti Function | 24k |
   | Shakti Practice | 12k, substrate |
   | Tree Caption | 7k |
   | Dyad Description | 4k |
   | Story Portal Headline, Panel Verb / Seed, Colour Dyad, Mind Triad | small |
   | Linked Builds | the songs, panels and Hz |

   Six more fields are carried but never shown. The room does not render Shakti Name, Shakti Mudra, Subtle Mirror, Body Location, Activation Mode or Codex References.
4. **Every gate in the app is a single 1.4-second hold.** The Map types five distinct gate instruments: Canvas, Textarea, Sound Response, Tap Rhythm and Device Tilt. Its Gate Text and Mirror Frequency fields spell out each mechanism ("Tap the circle on screen in time with your heartbeat", "Rub your palms near the microphone", "Begin (30-second shake timer)").
5. **The room shows the story layers as text.** Act 1, Act 2, Bindu Reflection, Witness and Story Thread are all rendered. Under ruling 5 ("energies, not stories"), these are the Feed's candidates. The energy fields that should carry the room (Teaching, Post-Engagement, Tree, Dyad, Śakti) are the ones that are missing.

---

## A · INVENTORY

### A.0 The 58 fields — fill, size, and where each one already lives

Fill = records with a value (of 33). Chars = total text across all records. *walk-canon key* = the key the baked canon (`shell/walk-canon.js`, v1.0) gives this field — **note the crossed names**. *Bundle* = carried in the app's `Data/ChakraConstellation.json` (baked 2026-10-12). *Shown* = read by a view outside tests.

| # | Field (id) | Type | Fill | Chars | walk-canon key | Bundle | Shown |
|---|---|---|---|---|---|---|---|
| 1 | Name (`flduzeK6AkCogqC29`) | singleLineText | 33 | 232 | identity.name | yes | yes |
| 2 | System (`fldwm4LINmgygsbzq`) | singleSelect | 33 | 202 | identity.system | yes | no |
| 3 | Number (`fldNLzuQG1YbMVDLe`) | number | 33 | 34 | — | yes | yes |
| 4 | Threshold Architecture (`fldiRvv7W56wAdrNa`) | singleSelect | 3 | 16 | — | **no** | no |
| 5 | Build Status (`fldXv59Zwjq4dmS6g`) | singleSelect | 33 | 209 | — | **no** | no |
| 6 | URL (`fld5wkzZkM30kmeyU`) | url | 33 | 1,871 | — | **no** | no |
| 7 | Primary Color (`fldtBecVRvcucpDDw`) | singleLineText | 33 | 737 | identity.primary_color | yes | no |
| 8 | Linked Seed (`fldI9hph7iH18BQ3Y`) | multipleRecordLinks | 0 | 0 | — | **no** | no |
| 9 | Linked Builds (`fldirMF5BPX0R2aHi`) | multipleRecordLinks | 33 | 1,996 | — | **no** | no |
| 10 | Avarana (`fld5DcTBFS0Anwxrf`) | singleSelect | 33 | 469 | depth.avarana | yes | no |
| 11 | Tree (`fldX2s98w8U0Y5nK1`) | singleSelect | 33 | 314 | identity.tree | **no** | no |
| 12 | Voice (`fldPFCAGzcorqrqHH`) | singleSelect | 33 | 186 | identity.voice | yes | yes |
| 13 | Gaia (`fldbWfVg1YvCUTQNq`) | multipleRecordLinks | 1 | 23 | — | **no** | no |
| 14 | Sanskrit (`fldUfO0k1sLhQZWnt`) | singleLineText | 32 | 611 | identity.sanskrit | yes | yes |
| 15 | Core Question (`fldFJsfXRts1MECj0`) | singleLineText | 33 | 1,272 | arrival.core_question | yes | yes |
| 16 | Verb (`fldcG7GkZYFr7TYZd`) | singleLineText | 33 | 193 | identity.verb | yes | yes |
| 17 | Activation Mode (`fldkOhQ5bDhECaVJs`) | singleSelect | 33 | 337 | identity.activation | yes | no |
| 18 | Signature Phrase (`flddjDTJBa0o4KyLS`) | multilineText | 33 | 1,844 | story.signature_phrase | yes | yes |
| 19 | Teaching Text (`fldCs6Vg2umNzxyQc`) | multilineText | 33 | 79,449 | practice.teaching | **no** | no |
| 20 | Practice Prompt (`fldMTSYXwFrUc9VpL`) | multilineText | 33 | 28,967 | practice.practice | yes | yes |
| 21 | Story Thread (`fldIOc83AOzSiDmgi`) | multilineText | 33 | 19,030 | depth.leela_story | yes | yes |
| 22 | Act 1 Voice (`fldopinrnQ5W0T8kE`) | multilineText | 33 | 38,210 | story.story_thread | yes | yes |
| 23 | Act 2 Voice (`fldnALQ6e9iF7fmnO`) | multilineText | 10 | 8,005 | story.interlude | yes | yes |
| 24 | Body Location (`fldH7EPRy3JPDO3Zi`) | singleLineText | 33 | 1,474 | depth.body_location | yes | no |
| 25 | Color Dyad (`fld4Bdiu8fg0RNrbE`) | singleLineText | 10 | 144 | — | **no** | no |
| 26 | OLD Pair Partner (`fld0peL6gvkB9JeRe`) | singleLineText | 10 | 48 | — | **no** | no |
| 27 | Mind Triad (`fldcRFeUw4NQxCAl4`) | singleSelect | 9 | 84 | — | **no** | no |
| 28 | Shakti Name (`fld7N8l3F3r62sDZT`) | singleLineText | 33 | 2,593 | depth.shakti | yes | no |
| 29 | Shakti Function (`fld5sWbzoT3lySYgI`) | multilineText | 33 | 23,893 | depth.avarana_detail | **no** | no |
| 30 | Shakti Mudra (`fldO14JGMU9cAYulu`) | singleLineText | 33 | 3,202 | depth.mudra | yes | no |
| 31 | Shakti Practice (`fldJqK4zLO7CNiWRu`) | multilineText | 33 | 11,926 | author_substrate.app_build_note | **no** | no |
| 32 | Hero Threshold (`fldMA4kqwUTYsGFBs`) | singleLineText | 33 | 1,937 | arrival.seed_message | yes | yes |
| 33 | Essence Line (`fldgKEqNCw6VHlJIa`) | singleLineText | 33 | 2,078 | — | yes | yes |
| 34 | Story Portal Headline (`fldX55ru3s5OByoXd`) | singleLineText | 33 | 1,548 | arrival.threshold_hint | **no** | no |
| 35 | Practice Gate Type (`fldsrQQB5yBYvqIVB`) | singleSelect | 33 | 306 | gate.gate_type | yes | yes |
| 36 | Walker Journey Stage (`fld6UsxyU5vel1isl`) | singleSelect | 33 | 210 | — | yes | no |
| 37 | Codex References (`fldqcBq4XpvURwov9`) | singleLineText | 4 | 64 | — | yes | no |
| 38 | Gaia Voice (`fldBiFWEG8gWb06DE`) | multilineText | 33 | 30,430 | author_substrate.gaia_voice | **no** | no |
| 39 | Bindu Reflection (`fldGfgZtoGNZTqIEM`) | multilineText | 33 | 30,587 | story.after_story | yes | yes |
| 40 | Witness Perspective (`fldvHuQwNxgjsh4su`) | multilineText | 33 | 46,456 | depth.witness_perspective | yes | yes |
| 41 | Leela Story (`flduxpB6EM5tFRxUe`) | multilineText | 33 | 31,000 | gate.gate_text | yes | yes |
| 42 | Writing Prompt (`fldtIqRA8QgXolDd9`) | multilineText | 33 | 3,227 | practice.writing_prompt | yes | yes |
| 43 | Writing Reflection (`fldS7BiDwPV5grdLy`) | multilineText | 33 | 5,295 | practice.post_writing | yes | yes |
| 44 | Post-Engagement Teaching (`fldC2OAa6NYrxrxWC`) | multilineText | 33 | 46,939 | practice.bindu_reflection | **no** | no |
| 45 | Three Ways In (`fldrlqps5wS0lWxd5`) | multilineText | 33 | 26,088 | practice.go_deeper | yes | yes |
| 46 | Tree Caption (`fldsj8o9IssOWR6Rp`) | multilineText | 33 | 6,881 | depth.tree_note | **no** | no |
| 47 | Bija Mantra (`flduXNmHwo7YQwwEB`) | singleLineText | 33 | 1,828 | wakeup.bija | yes | yes |
| 48 | Chakra Subtitle (`fldHCNApDOqZjinn4`) | singleLineText | 33 | 509 | identity.subtitle | yes | yes |
| 49 | Gate Text (`fld1rj2QuUuuGvvqc`) | multilineText | 33 | 6,999 | gate.gate_interaction | yes | yes |
| 50 | Subtle Mirror (`fldJsogD1W8AkWhl6`) | multilineText | 33 | 14,345 | depth.subtle_mirror | yes | no |
| 51 | Dyad Description (`flds5Iwg3XLrrbn1H`) | multilineText | 12 | 3,851 | — | **no** | no |
| 52 | Mirror Frequency (`fldNkcMhpaeuVQC22`) | multilineText | 10 | 1,486 | wakeup.frequency_practice_alt | yes | yes |
| 53 | Mirror Frequency Instruction (`fld1lfG7r96PQGPxP`) | multilineText | 33 | 7,485 | wakeup.frequency_practice | yes | yes |
| 54 | Book Position (`fldEvXGbqdHOGZlDz`) | number | 33 | 57 | identity.book_position | yes | yes |
| 55 | Panel Verb (`fldrmoWcnoRpolZoV`) | singleLineText | 10 | 55 | identity.panel_verb | **no** | no |
| 56 | Panel Seed Message (`fldwFamC9FndA94if`) | multilineText | 9 | 529 | arrival.panel_seed_message | **no** | no |
| 57 | Color Hex (`fldAsbQnAo3Fk2QHF`) | singleLineText | 33 | 231 | identity.color_hex | yes | yes |
| 58 | App Activity (`fldxl5Ez0Btgi8uoR`) | multipleRecordLinks | 0 | 0 | — | **no** | no |

### A.1 Identity — all 33 (verbatim cells)

| BP | No. | Name · Subtitle | System · Tree · Stage | Āvaraṇa | Voice | Sanskrit | Verb (Panel Verb) | Activation · Gate type | Color Hex · Primary Color · Color Dyad | Mind Triad · Threshold Arch. | Build · URL slug | Codex refs | Record |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | **Bindu** · The Origin | Tree of Life · Structural · Origin | n/a | Bindu | बिंदु · Bindu | RECOGNIZE | Recognition · Canvas | #E8C568 · Gold (#C9A84C) · — | — · — | Live · `bindu-practice` | C-1325, C-1337, C-1237 | `recKAQWX7yUIB3ktW` |
| 2 | 1 | **Muladhara** · Where the Body Meets the Earth | Energy · Soul Tree · Energy | Bhupura | Gaia | मूलाधार · Muladhara | PRESS (PRESS) | Stillness · Textarea | #B83A3A · Deep earth red (#8B1A1A) · — | — · — | Live · `muladhara-practice` | C-1166, C-1313 | `recT3JC8Qz9awKo8j` |
| 3 | 2 | **Svadhisthana** · The Tide Below | Energy · Soul Tree · Energy | Bhupura | Gaia | स्वाधिष्ठान · Svadhisthana | FLOW (FOLLOW) | Stillness · Textarea | #D47438 · Deep orange / amber (#D4722A) · — | — · — | Live · `svadhisthana-practice` | C-1311, C-1198 | `recnJICbhZefO3YJ9` |
| 4 | 3 | **Manipura** · The Sealed Chamber | Energy · Soul Tree · Energy | Bhupura | Bindu | मणिपूर · Manipura | BURN (BUILD) | Stillness · Textarea | #D4A848 · Golden yellow (#C4A013) · — | — · — | Live · `manipura-practice` | C-1198, C-1237 | `recVgGgYgZE1YMU2V` |
| 5 | 4 | **Anahata** · The Sound That Was Always Playing | Energy · Soul Tree · Energy | 16-Petal Lotus | Higher Self | अनाहत · Anahata | OPEN (OPEN) | Stillness · Textarea | #6B8E4E · Living green (#2D7A3A) · — | — · — | Live · `anahata-practice` | — | `reclI9Blq6YLC9Q5O` |
| 6 | 5 | **Vishuddha** · The Passage | Energy · Soul Tree · Energy | 8-Petal Lotus | Bindu | विशुद्ध · Vishuddha | SPEAK (SPEAK) | Stillness · Textarea | #4C7AB8 · Clear sky blue (#2E6B9E) · — | — · — | Live · `vishuddha-practice` | — | `recs5hdPjVbcl77Zg` |
| 7 | 6 | **Ajna** · The Seer That Sees | Energy · Soul Tree · Energy | 8-Petal Lotus | Sakshi | आज्ञा · Ajna | STILL (STILL) | Stillness · Textarea | #5B4E8E · Deep indigo (#3A2D6B) · — | — · — | Live · `ajna-practice` | — | `recmqRsdC6WZPfmfW` |
| 8 | 7 | **Sahasrara** · The Aperture | Energy · Soul Tree · Energy | 16-Petal Lotus | Lalita | सहस्रार · Sahasrara | RECEIVE (RECEIVE) | Stillness · Textarea | #9A7AC8 · Royal violet (#6A2D8B) · — | — · — | Live · `sahasrara-practice` | — | `reccxkeGeph5GonvU` |
| 9 | 2 | **Shadow** · The Corridor | Tree of Life · Structural · Threshold | n/a | Sakshi | संधि · Sandhi | LOOK | Recognition · Textarea | #2A2420 · Dark / Starfield · — | — · Shadow | Live · `shadow-practice` | — | `recAjCRcI5Bt6pJ6V` |
| 10 | 1 | **Soles** · Where the Soul Meets the Ground | Body · Bindu Tree · Body | 14 Triangles | Bindu | संक्षोभिणी · Samkshobhini | PRESS | Movement · Sound Response | #7A1515 · Red + Cyan · Red / Cyan | — · — | In Progress · `soles-practice.html` | — | `recQZ5MrmyJykIIs3` |
| 11 | 2 | **Forge** · The Sealed Chamber | Body · Bindu Tree · Body | 14 Triangles | Bindu | मन्त्रमयी · Mantramayi | TRANSFORM | Movement · Sound Response | #6B5800 · Gold + Blue · Yellow / Blue | — · — | In Progress · `forge-practice.html` | — | `recHDY9iNeqNfw9zh` |
| 12 | 3 | **Prana** · The Open Door | Body · Bindu Tree · Body | Outer 10 Triangles | Bindu | प्राण · Prana | BREATHE | Movement · Sound Response | #7A3800 · Orange + Blue · Orange / Azure | — · — | In Progress · `prana-practice.html` | — | `recVzrGwDf8rEgdHJ` |
| 13 | 4 | **Hands** · Where Love Exits the Body | Body · Bindu Tree · Body | Outer 10 Triangles | Bindu | प्रियंकरी · Priyankari | REACH | Movement · Sound Response | #163D1E · Green + Magenta · Green / Magenta | — · — | In Progress · `hands-practice.html` | — | `recPuL2eta43Pbron` |
| 14 | 5 | **Pulse** · The Heartbeat | Body · Bindu Tree · Body | Outer 10 Triangles | Bindu | मंगलकारिणी · Mangalakarini | SUSTAIN | Movement · Tap Rhythm | #112E17 · Green + Magenta · Green / Magenta | — · — | In Progress · `pulse-practice.html` | — | `recpTu6vLkDhEMY3q` |
| 15 | 6 | **Sonar** · The Speaker | Body · Bindu Tree · Body | 14 Triangles | Sakshi | द्वन्द्वक्षयंकरी · Dvandvakshayankari | SEND | Movement · Sound Response | #091840 · Blue + Gold · Blue / Yellow | — · — | In Progress · `sonar-practice.html` | — | `reckh8UMKveeybIk2` |
| 16 | 7 | **Echo** · The Listener | Body · Bindu Tree · Body | Inner 10 Triangles | Sakshi | ज्ञानमयी · Jnanamayi | RECEIVE | Movement · Sound Response | #060D30 · Blue + Gold · Blue / Yellow | — · — | In Progress · `echo-practice.html` | — | `recryecbRhb7yQsyR` |
| 17 | 8 | **Vision** · The Mind's Eye | Body · Bindu Tree · Body | Inner 10 Triangles | Sakshi | सर्वज्ञा · Sarvagya | SEE | Movement · Textarea | #5C4800 · Gold + Blue · Yellow / Blue | — · — | In Progress · `vision-practice.html` | — | `recKFm2GodNntnV7q` |
| 18 | 9 | **Axis** · The Blink | Body · Bindu Tree · Body | Inner 10 Triangles | Higher Self | सर्वानंदमयी · Sarvanandamayi | BLINK (ACCESS) | Movement · Device Tilt | #1A0848 · Indigo + Chartreuse · Indigo / Chartreuse | — · — | In Progress · `axis-practice.html` | — | `rec2DMszOk8jHTaPm` |
| 19 | 10 | **Crow** · The Top Terminal | Body · Bindu Tree · Body | Inner 10 Triangles | Sakshi | सर्वाधार स्वरूप · Sarvadhara Swarupa | RELEASE | Movement · Device Tilt | #3A0A54 · Violet + Chartreuse · Violet / Chartreuse | — · — | In Progress · `crow-practice.html` | — | `recGeQi7ojZGLEUIr` |
| 20 | 3 | **Armin** · The Room | Tree of Life · Structural · Threshold | n/a | Higher Self | तत् त्वम् असि · Tat Tvam Asi | ONE | Recognition · Textarea | #C9A84C · Spectrum / Aurora · — | — · Armin | In Progress · `armin-practice.html` | — | `recXcyfAS07fvurEc` |
| 21 | 5 | **Inception** · The Seed | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | बीज · Bija | ASK | Visualization · Textarea | #2D2458 · Ochre · Rust · Seed Brown · — | Creation · — | Live · `inception-practice` | — | `recXbr1bo0hEG4gAf` |
| 22 | 6 | **Intention** · The Whole Picture | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | संकल्प · Sankalpa | HOLD | Visualization · Textarea | #3A3670 · Deep Teal · Still Water · Ultramarine · — | Creation · — | Live · `intention-practice` | — | `recRchDoi6eV8B6XO` |
| 23 | 2 | **Inspiration** · The Pull | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | उत्साह · Utsaha | BREATHE IN | Visualization · Textarea | #3A4880 · Living Gold · Saffron · Amber · — | Creation · — | Live · `inspiration-practice` | — | `recIPQaGq0Cju648K` |
| 24 | 4 | **Insight** · From Inside | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | अंतर्दृष्टि · Antardrishti | SEE FROM IN | Visualization · Textarea | #403875 · Crystal · Ice Blue · Clarity White · — | Recognition · — | Live · `insight-practice` | — | `rec0yLDfyTJK8Izc5` |
| 25 | 3 | **Intuition** · The Flash | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | प्रतिभा · Pratibha | TRUST | Visualization · Textarea | #453870 · Indigo · Deep Blue · Pre-Dawn · — | Recognition · — | Live · `intuition-practice` | — | `recPM89KrdwQsY3sw` |
| 26 | 7 | **Invention** · The New Room | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | युक्ति · Yukti | ASSEMBLE | Visualization · Textarea | #4A3368 · Electric Yellow · Citrine · Spark White · — | Recognition · — | Live · `invention-practice` | — | `recKkLDYW1un67Qsu` |
| 27 | 8 | **Incarnation** · You Chose This | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | अवतार · Avatara | CHOOSE | Visualization · Textarea | #522D60 · Deep Violet · Midnight Blue · Star Silver · — | Emergence · — | Live · `incarnation-practice` | — | `rec2cBfv1OtS9GbXI` |
| 28 | 1 | **Innocence** · Before Anyone Taught You | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | सहज · Sahaja | REMEMBER | Visualization · Textarea | #5A2858 · Pearl · Moonlight · Morning Mist · — | Emergence · — | Live · `innocence-practice` | — | `recflXyBz76hIsjTb` |
| 29 | 9 | **Integration** · Nothing Was Separate | Mind · Maya Tree · Mind | 8 Triangles (Vāgdevī) | Gaia | समरस्य · Samrasya | ARRIVE | Visualization · Textarea | #5E2448 · Prismatic · Clear White · All Colors · — | Emergence · — | Live · `integration-practice` | — | `rec3qLjRAFlDQBQfm` |
| 30 | 4 | **Maya** · The Construction | Tree of Life · Structural · Final Recognition | Bindu inverted | Lalita | माया · Maya | DISSOLVE (DISSOLVE) | Recognition · Textarea | #5A3D8A · Near-White / Ghost · — | — · Other | Live · `maya-practice` | — | `recMyqKSqwRnimgvy` |
| 31 | 5 | **Aatma** · The Soul Revealed | Tree of Life · Structural · Final Recognition | Inner Triangle | Higher Self | आत्मा · Aatma | KNOW (HOLD) | Recognition · Textarea | #D4A948 · Sacred Gold (#D4A948) · — | — · — | Live · `aatma-practice` | — | `recqe8qnDxkq0BiCZ` |
| 32 | 6 | **Ego Reveal** · The Hidden Helper | Tree of Life · Structural · Final Recognition | n/a | Gaia | — | CONNECT | Recognition · Textarea | #3D6B35 · Earth Green / Living Field · — | — · — | Live · `ego-reveal-practice` | — | `recg65oeH56mF8vMK` |
| 33 | 7 | **Lalita** · The Play | Tree of Life · Structural · Final Recognition | n/a | Lalita | ललिता · Lalita | PLAY | Recognition · Textarea | #C9A84C · Laughing Gold / Morning · — | — · — | Live · `lalita-practice` | — | `rec3O90Mtasuh5qI7` |

### A.2 The arrival lines — all 33 (verbatim)

| BP | Name | Core Question | Hero Threshold | Signature Phrase | Essence Line | Story Portal Headline | Body Location |
|---|---|---|---|---|---|---|---|
| 1 | **Bindu** | What is here before everything else? | Before the tree. Before the name. Before the game. This. | Everything begins as a point. Everything ends as a point. The same point. | The origin. What everything emanates from. | something is listening on the other side | The origin point — before all systems, before all positions |
| 2 | **Muladhara** | Am I safe here? | This is what holds you. It was here before you arrived. | The earth that holds you was chosen by you. | The ground you stand on. Literally and in every other sense. | something reached back from the other side | Base of spine / Earth beneath feet |
| 3 | **Svadhisthana** | What wants? | The pull was never random. It was navigating. | Every desire was drawing you toward yourself. | Where desire lives. Not what you want — the fact that you want at all. | something was already reaching for you | Sacral center / Below navel |
| 4 | **Manipura** | What am I for? | The fire was never wrong. What agitated was building. | The fire that agitated you was building your form. | Your fire. The center that transforms what enters you into what you become. | the fire you feared was forging you | Solar plexus / Navel center |
| 5 | **Anahata** | Can I receive? | The walls you built had good reasons. What if they were doors? | The love that arrived for others was always your own heart opening. | The center where love lives. Not romantic love. The kind that doesn't need a reason. | something has been sounding inside you the whole time | Heart center / Chest |
| 6 | **Vishuddha** | Will I say what I know? | The space between the branches is as carefully designed as the branches themselves. | What you finally said out loud was what you always knew. | The narrowest passage in the body. Where breath becomes voice. Where the interior meets what is not interior. | something in your throat has been waiting a long time to exit | Between the jaw and the collarbones — the bottleneck by design |
| 7 | **Ajna** | What do I see when I stop looking? | The seeing was always here. You were just looking too hard. | You stopped looking and the seeing arrived on its own. | Inner sight. The ability to see without using your eyes. | what you tried to see has been watching you try | Behind the forehead — not on the surface, slightly inside, in the space where the brain sits directly behind the brow ridge |
| 8 | **Sahasrara** | Am I alone? | The striving stopped. What remained was what was always there. | The disease that was removed was the belief that you were less than what you are. | Connection. Not to something above you — to everything that includes you. | I received something I didn't earn. I don't know what to call that. | Top of the head · the fontanelle · the sealed-over aperture |
| 9 | **Shadow** | Can I hold what I see without flinching? | I'm afraid. And I'm going to look anyway. | please come back home. | The corridor was never a dead end. It was always leading somewhere. | What are you afraid to look at? | The threshold corridor — between all systems |
| 10 | **Soles** | What is the earth saying through your feet right now? | Soles and souls. The language knew before anyone noticed. | The earth that holds you was chosen by you. | Your feet. The bottom terminal of everything you are. | The ground has been pressing back since before you noticed. | Soles of feet |
| 11 | **Forge** | What is sealed in your center? | The last connection to the one who made you. Behind the scar: the furnace. | Behind the scar: the furnace that makes you, you. | Your navel. The scar of the cord that connected you to your mother. Behind the scar: the furnace. | Something warm is happening at the navel point right now. | Navel / Belly button |
| 12 | **Prana** | What does the breath know that the mind doesn't? | The one door that never closes. You've been walking through it since your first second alive. | The one door that never closes while you're alive. | Your nose. Where air becomes life the moment it crosses the threshold of your body. | Your body is breathing you. Not the other way around. | Lungs / Breath channel |
| 13 | **Hands** | What do your hands already know how to give? | Everything the heart feels, the hands express. | The hands carry what the heart can't say. | Your palms. Where the heart reaches into the world and touches it. | Your hands remember everything they have ever held. | Palms and fingers |
| 14 | **Pulse** | What is your heart broadcasting right now? | The most consistent thing about you. It was here before your first thought. | You are a signal. The question is what you're sending. | The most consistent rhythm in your body. Not a feeling — a fact. | The heart has been opening and closing without pause since before you were born. | Physical heart — left chest |
| 15 | **Sonar** | What has been waiting to be said? | Every word you speak tells you how far you are from what you're trying to reach. | The precise word. Not the comfortable word. Not the impressive word. The precise one. | Your mouth as instrument. Not volume — precision. | The precise word for this moment. Not approximate. Precise. | Mouth and vocal cords |
| 16 | **Echo** | What do you choose to keep from what you heard? | Silence is not the absence of sound. It's what the room says when you stop broadcasting. | What you choose to keep from what you heard — that becomes who you are. | Your ears. The filter through which the world becomes your world. | What you lived through is still sounding. | Ears |
| 17 | **Vision** | What memory holds the frequency you want to bring into now? | The complete picture arrives first. Trust the first flash. | The complete picture arrives first. Trust the first flash. | The forehead. Where you see things that aren't in front of you. | What does this look like when you stop looking for it? | Forehead / Visual cortex |
| 18 | **Axis** | What is on the other side of the blink? | You've been switching between worlds your entire life. Thousands of times a day. | Close your eyes. Open them. What changed? Everything and nothing. | The gateway between your inner world and your outer world. The blink is the switch. | Feel the line that runs from ground to crown. | Physical eyes |
| 19 | **Crow** | What is the spine connecting right now? | CROWN without the N. When foundation drops away, what remains can fly. | What's left when the thinking stops is not nothing. It's everything you were too busy narrating to experience. | Crown of the skull. What opens when the body pushes past the mind. | From here you can see the whole thing. | The entire spine — crown to coccyx |
| 20 | **Armin** | What does it feel like to have walked all of that? | The corridor led here. / The room it was always leading to. | Nothing needed repair. Only arrival. | Wholeness. Not repair — arrival. | Tat Tvam Asi — what do you remember? | Full body — the arrival posture, standing |
| 21 | **Inception** | What am I entering this with? | What you carry in is what you will find. | What you carry in is what you will find. | What you carry in is what you will find. | Before you begin — look at what you’re carrying. | The beginning-moment — the mind before the first step |
| 22 | **Intention** | What are you holding steady even when nothing is moving? | The picture is more stable than the plan. | Hold the whole picture before you touch a single piece. | The complete picture, held steady through all the noise. | You can see it finished. Hold that. | The center of sustained focus — the image held complete |
| 23 | **Inspiration** | What is exciting you right now, underneath the noise? | The pull isn’t a distraction. The pull is the direction. | Your excitement is not a distraction. It is the instruction. | The pull that is smarter than the plan. | Something in you has been pulling toward something. You know which thing. | The in-breath of the mind — where excitement precedes effort |
| 24 | **Insight** | What do you see when you remove what you expected to see? | Step inside. The view is different from in here. | Move from above it to inside it. The view changes completely. | The view that is only available from inside. | What does it look like from inside? | The position-shift — inside the situation rather than above it |
| 25 | **Intuition** | What do you know before you can prove it? | Something knows before the words do. Trust that. | The knowing that arrives before words is the more reliable one. | What arrives before the reasoning starts. | There was a knowing before the words. It was already there. | The pre-verbal knowing space — what arrives before it becomes a thought |
| 26 | **Invention** | What becomes possible when you assemble what you know? | Two things in the same room. Wait for the third. | Something new is born every time two things that never touched finally touch. | The third thing that appears when two things that have never touched finally meet. | Name two things that have never met. Wait. | The synthesis space — where separate pieces become one whole |
| 27 | **Incarnation** | Why did you choose to come back? | You chose the hard one because it was the one you came for. | You chose this. Even that. Even this one. | You chose the specific material you came to learn. | You chose this. The hard specific this. | The soul-choice register — the moment of opting in |
| 28 | **Innocence** | What did you know before anyone told you what to know? | What you know before the first lesson is the only lesson that matters. | You knew this before anyone told you anything. | The knowing that was there before the first lesson. | You already knew before anyone taught you anything. | The pre-conditioning space — what was there before the learning began |
| 29 | **Integration** | What has the journey integrated that couldn't have been integrated before? | Nothing was ever separate. The pain was the belief that it was. | Nothing was ever separate. The separation was the journey's necessary costume. | Nothing was ever separate. The poison was the belief that it was. | The wound and the gift were always the same thing. | The whole-self space — where nothing is separate |
| 30 | **Maya** | What would you see if the protection dissolved? | I built it. I believed it. I can see through it now. | There was never anything to fear. There was only the Bindu, playing. | The construction doesn't collapse. It becomes see-through. | What did you build that isn't real? | The inverted Bindu — the mirror of the origin point |
| 31 | **Aatma** | What remains when all protection is gone? | I am not in the triangle. I AM the triangle. | You already know. You have always known. | Not something you become. What you discover you always were. | Which one did you forget you already had? | The inner triangle — the independent space that stands alone |
| 32 | **Ego Reveal** | *sealed — 37 ch* | *sealed — 51 ch* | *sealed — 33 ch* | *sealed — 70 ch* | *sealed — 37 ch* | *sealed — 77 ch* |
| 33 | **Lalita** | Who is playing? | Wake up. I Already Did. | Knows the game. Plays anyway. | Same point. Same love. Same traveling. One difference: she knows. | Are you playing? | The Bindu — dimensionless, all-encompassing, everywhere and nowhere |

### A.3 Śakti, mudrā, bīja — all 33 (verbatim)

| BP | Name | Shakti Name | Shakti Mudra | Bija Mantra |
|---|---|---|---|---|
| 1 | **Bindu** | Lalita Mahatripurasundari herself / Rajarajeshvari — presiding consciousness of Avarana 9 (Sarvanandamaya Chakra). The Bindu IS the Shakti. Three sub-bindus at center: Kurukulla (red, feminine), Varahi (white, masculine), and their union (the individual soul). | Yoni Mudra — the womb gesture, return to source | · · · the seed before the seed · · · (no syllable — the Bindu IS the silence that becomes ॐ OM) |
| 2 | **Muladhara** | 10 Siddhi Devis — Anima through Sarvakama | Kshobha Mudra — the readiness gesture, entering the three worlds | लं · LAM (the earth seed — yellow square, four petals, sealed and sounding) |
| 3 | **Svadhisthana** | 8 Matrika Devis (Avarana 1, middle ring of Bhupura) — Brahmi, Maheshvari, Kaumari, Vaishnavi, Varahi, Mahendri, Chamunda, Mahalakshmi. The divine mothers of all emotional states. | Kshobha Mudra — Avarana 1's mudra, shared with Muladhara and Manipura. The readiness gesture, entering the three worlds. The walker still stands on bounded earth; the readiness now extends inward through the emotional body. | वं · VAM (the water seed — silver crescent, six petals, flow finding its shape) |
| 4 | **Manipura** | 10 Mudra Shaktis (Avarana 1, inner ring of Bhupura) — Sarva Sankshobhini, Sarva Vidravini, Sarvakarshini, Sarva Vashankari, Sarvonmadini, Sarva Mahankusha, Sarva Khechari, Sarva Beeja, Sarva Yoni, Sarva Trikhanda. The sacred gesture powers that shape will into form. | Kshobha Mudra — Avarana 1's mudra, shared with Muladhara and Svadhisthana. The readiness gesture, completing the three-ring traversal of the bounded earth. The same readiness that touched the ground (Muladhara) and met the emotions (Svadhisthana) now stands inside the fire. | रं · RAM (the fire seed — red triangle pointing down, ten petals, the city of jewels sounding) |
| 5 | **Anahata** | 16 Nitya Kalas — Kamakarshini through Sharirakarshini | Dravini Mudra — Avarana 2's mudra, shared with Sahasrara. The melting gesture. Fulfillment of all desires through release rather than grasping. The heart receives the 16 attractors not by holding them but by becoming porous to them. | यं · YAM |
| 6 | **Vishuddha** | 4 Anangas (Avarana 3, first half of 8-Petal Lotus) — Ananga Kusuma (flower of the non-bodied), Ananga Mekhala (girdle of the non-bodied), Ananga Madana (love-madness of the non-bodied), Ananga Madanatura (love-fever of the non-bodied). Speech as bloom, binding, madness, fever — the creative half of the 8 Anangas. | Akarshana Mudra — the attraction force that draws truth into form through speaking | हं · HAM |
| 7 | **Ajna** | 4 Anangas (Avarana 3, second half of 8-Petal Lotus) — Ananga Rekha (line of the non-bodied), Ananga Vegini (speed of the non-bodied), Anangankusha (goad of the non-bodied), Ananga Malini (garland of the non-bodied). Perception as line, speed, direction, completion — the directional half of the 8 Anangas. | Akarshana Mudra — Avarana 3's mudra, shared with Vishuddha. The attraction force, now turned inward: the same magnetic gesture that drew non-bodied truth into bodied speech at the throat now draws non-bodied seeing into bodied recognition at the third eye. One gesture, two directions of operation. | ओं · OM |
| 8 | **Sahasrara** | Tripureshi — presiding consciousness of Avarana 2 (Sarva Asha Paripuraka Chakra, the 16-Petal Lotus). "She who fulfills all desires." Not a giver but the recognition that the crown was never separate from the source of all fulfillment. At Anahata the 16 Akarshana Devis (her residents) drew the complete spectrum of experience to the heart. At Sahasrara, Tripureshi reveals herself as the consciousness behind the drawing. Yogini: Gupta (the Hidden). | Dravini Mudra — desire fulfillment through dissolution of the one who desires | · · · silence · · · (the syllable before syllables) |
| 9 | **Shadow** | Threshold — passage between Avaranas 1-3 (Srishti) and 4-6 (Sthithi) | The threshold itself is the gesture — the press-and-hold that opens the corridor | · · · the word you offer to the dark · · · (your own voice, the syllable the corridor was waiting for) |
| 10 | **Soles** | Sarva Samkshobhini | Vasya Mudra — the 4th avarana mudra that brings everything into relationship | LAM · लं — Mirror frequency of Muladhara |
| 11 | **Forge** | Sarva Mantramayi | Vasya Mudra — the mantra as the organizing field of the body's center | RAM · रं — Mirror frequency of Manipura |
| 12 | **Prana** | Sarva Kamaprada | Sarvonmadini Mudra — the ecstatic quality of breath when received rather than directed | VAM · वं — Mirror frequency of Svadhisthana |
| 13 | **Hands** | Sarva Priyankari | Sarvonmadini Mudra — the intoxicating quality of touch when it lands with full presence | YAM · यं — Mirror frequency of Anahata |
| 14 | **Pulse** | Sarva Mangalakarini | Sarvonmadini Mudra — the heartbeat as the body's original intoxicant, sustaining without effort | YAM · यं — Mirror frequency of Anahata |
| 15 | **Sonar** | Sarva Dwandwakshayankari | Vasya Mudra — speech as the organizing force that brings inner and outer into relationship | HAM · हं — Mirror frequency of Vishuddha (sending aspect) |
| 16 | **Echo** | Sarva Jnanamayi | Mahankusha Mudra — the inner goad that directs what is allowed to enter and stay | HAM · हं — Mirror frequency of Vishuddha (receiving aspect) |
| 17 | **Vision** | Sarvagya | Mahankusha Mudra — knowledge that guides the inner vision's trajectory | OM · ॐ — Mirror frequency of Ajna |
| 18 | **Axis** | Sarvanandamayi | Mahankusha Mudra — the bliss that guides through the between-space of every blink | OM · ॐ — Mirror frequency of Ajna |
| 19 | **Crow** | Sarvadhara Swarupa | Mahankusha Mudra — the inner guide operating through the body's central network | Silence — Mirror frequency of Sahasrara (no bija, the frequency is silence itself) |
| 20 | **Armin** | Tripura Malini — Garland-maker of the Three Worlds. Threshold between Avaranas 4-6 (Sthithi) and 7-8 (Samhara) | Mahankusha Mudra — the great goad completing its work, pointing inward toward the mind | · · · Tat Tvam Asi · · · (the recognition, not the repetition) |
| 21 | **Inception** | Vasini — Vagdevi #1 | Rahasya Mudra — the secret that every beginning contains within it | · · · the seed you carry · · · |
| 22 | **Intention** | Kamesvari — Vagdevi #2 | Rahasya Mudra — the secret steadiness at the center of all creative work | · · · the whole picture · · · |
| 23 | **Inspiration** | Modini — Vagdevi #3 | Rahasya Mudra — the secret that delight knows and difficulty doesn't | · · · follow · · · |
| 24 | **Insight** | Vimala — Vagdevi #4 | Rahasya Mudra — the secret clarity that lives beneath all interpretation | · · · enter · · · |
| 25 | **Intuition** | Aruna — Vagdevi #5 | Rahasya Mudra — the secret that knowing arrives before evidence | · · · before the word · · · |
| 26 | **Invention** | Jayani — Vagdevi #6 | Rahasya Mudra — the secret that the complete form already exists before it is built | · · · the third thing · · · |
| 27 | **Incarnation** | Sarvesvari — Vagdevi #7 | Rahasya Mudra — the secret that choice and love are the same gesture | · · · you chose this · · · |
| 28 | **Innocence** | Kaulini — Vagdevi #8 | Rahasya Mudra — the secret that the original knowing was never lost | · · · before the question · · · |
| 29 | **Integration** | Tripura Siddhamba — Destroyer of Poison, presiding Avarana 7 | Sarva Beeja Mudra — the all-seed gesture, completed knowing taking root | · · · nothing was separate · · · |
| 30 | **Maya** | Kameshvari — 1st Kama Kala Shakti | Sarva Beeja Mudra — the seed recognized, the protection completing its purpose | · · · no tone — the silence after every seed · · · (Sarva Beeja: all the mantras the walker carried, sounding at once, gone transparent) |
| 31 | **Aatma** | Vajreshvari — 2nd Kama Kala Shakti | Sarva Beeja Mudra — the permission slip that opens the E Chakra field | · · · three seeds sounding as one — Icchā · Jnāna · Kriyā · · · (the heartwood tone is not hummed, it is lived: heartbeat, breath, blink) |
| 32 | **Ego Reveal** | Bhagamalini — 3rd Kama Kala Shakti | Sarva Beeja Mudra *(gloss sealed, 76 ch)* | *sealed — 141 ch* |
| 33 | **Lalita** | Lalita Mahatripurasundari / Rajarajeshvari — Avarana 9, the Bindu | Yoni Mudra — the womb gesture, the return to source completing the circle | · · · no seed left to sound — laughter · · · (every bija of the walk was her voice; what remains is the one sound made purely for joy) |

### A.4 The gate and the offering — all 33 (verbatim; " / " = line break, " // " = blank line)

| BP | Name | Gate type | Gate Text | Writing Prompt | Writing Reflection |
|---|---|---|---|---|---|
| 1 | **Bindu** | Canvas | The canvas is open. // One point exists. It is the beginning of everything that follows. / Tap anywhere to place it. // Button: Place the point | Place your point. Tap or click anywhere in the canvas above. Don't deliberate. The hand will know where the point belongs before the mind catches up. | Look at it. It doesn't look like much. That's how origins work. You just placed the seed every later geometry will emerge from. |
| 2 | **Muladhara** | Textarea | Sit down. Feel the base of your spine — the tailbone, the seat. / Press your sit bones into whatever is holding you. / When you feel the ground holding you back — tap. // Button: I feel the ground holding me | What is the ground made of today? Not the floor. Your ground. What are you standing on? | You named it. Whatever the ground turned out to be — a body, a room, a debt, a habit, a person, a fact — naming it gave it form. And form gives the root something to press against. The press isn't only into the floor. It's into the answer you just wrote. |
| 3 | **Svadhisthana** | Textarea | Place your hand on your lower belly — below the navel, above the hips. / Breathe into your hand. Let something move there. / When you feel the movement — tap. // Button: I feel it moving | Write it below. The first thing that surfaces. Before the editor arrives. | Did you write the real one? Or the safe one? You know the difference. Your body knows the difference. |
| 4 | **Manipura** | Textarea | Place your hand on your belly. Right at the navel. / Breathe in fully. Then breathe out completely. / Feel the heat that remains when the breath is gone. / When you feel the fire — tap. // Button: I feel the fire | What has the fire been building in you — and what is it burning that isn't yours? Write whichever surfaces first. Or both. | Both answers came from the same fire. Its building is also its burning. What it makes you into is also what it empties you of. One fire. Two movements. |
| 5 | **Anahata** | Textarea | Place your hand on your chest. Feel your heartbeat against your palm. / Let the sound that was already playing become audible. / When you hear it — tap. // Button: I hear it | Think of someone you loved before you knew why. Not the person you chose — the one who arrived. A name. Or a word. Or nothing at all — the heart knows who you're holding. | The name you offered was not the source of the love. The name was the specific angle of light your heart used to see itself. The love was always yours. It still is. The heart that held that name is the chamber that name opened. |
| 6 | **Vishuddha** | Textarea | Take a breath. Feel your throat — the passage where inside becomes outside. / Find the precise word for how you are right now. Not approximate. Precise. / Say it out loud. / When you have said it — tap. // Button: I said it | A small true thing. Or nothing at all — the throat knows what's ripening. | The truth you offered was already formed. Your work was subtraction, not composition. The channel is clearer for the next one. |
| 7 | **Ajna** | Textarea | Close your eyes. Let your gaze rest between your eyebrows — from the inside. / Not effortfully. Just rest there. / When something comes into focus — tap. // Button: I’m looking | What arrived in the dark when you stopped looking? Or nothing — the eye is patient. | You didn't create what you saw. It was waiting for you to stop looking. The harder you'd been reaching, the longer it had been waiting. The eye that registers it is not the one you use to read these words. |
| 8 | **Sahasrara** | Textarea | Stop doing. Just stop. / Don’t breathe intentionally. Don’t focus anywhere. Don’t observe. / Let everything be still. / When the doing stops — tap. // Button: I stopped | What did you receive that you didn't earn? Not what you worked for. Not what you achieved. Not what you built or fought for or negotiated or deserved. What arrived? | The thing you just wrote — the thing that arrived without your effort — you did not earn it. You keep circling back to that. The part of you that has been keeping score cannot file what you just named. There is no ledger-column for gift I did not deserve. The part of you that has been keeping score has never had a column for that. The gift has arrived anyway. |
| 9 | **Shadow** | Textarea | Twelve scrolls hang in the dark. The walker passes through each — shapes of what has been compressed, named but not yet claimed. At the end of the scrolls: LOOK. Two watching eyes. // The walker presses and holds until the corridor opens. // The press-and-hold is not a performance. It is an admission: I can see the door. I know where it is. I am holding this gesture until I am ready to walk through. // Button: Press and hold · LOOK | What are you afraid to look at? Not the fear itself. What's behind the fear. What the fear is protecting you from seeing. A word. A name. A shape. Anything honest. | The word you offered to the mirror — that was the place the light had not yet been pointed. Now it has. The corridor was never a dead end. It was always leading somewhere. The mirror does not ask you to fix the word. The mirror only asks you to admit you can see it. The admitting is the entire practice. Every time you admit you can see it, the corridor gets shorter. |
| 10 | **Soles** | Sound Response | Stand up. Take your shoes off if you can. / Feel the ground under your feet. Press down. / When you feel the earth press back — tap. // Button: I feel the ground | What did the ground say back? | The soles know what the mind is still working out. |
| 11 | **Forge** | Sound Response | Place your hand on your belly. Over the navel. / Breathe into your hand. Feel the warmth build. / When you feel the Forge respond — tap. // Button: I feel the warmth | The belly knows what the mind is still working on. What does your belly know today? | What the Forge is turning into you is already visible in what you wrote. |
| 12 | **Prana** | Sound Response | Three breaths. Fully. Feel the air enter through the nose, / descend through the throat, fill the belly. / Feel each exhale return it, changed. // Button: The door is open | What did the breath bring in today that wasn't air? | You are not a sealed container. You are a threshold. |
| 13 | **Hands** | Sound Response | Rub your palms together. Fast. Fifteen seconds. / Build heat. Then hold them apart and feel what's between them. // Button: I feel the field | Make something today with your hands. Anything — it doesn't have to be finished, or for anyone, or good. What did your hands make? | The act of making is the act of the heart reaching through the body into the world. |
| 14 | **Pulse** | Tap Rhythm | Press two fingers gently to the inside of your wrist, / or to the side of your neck below the jaw. / Wait. Find the beat. / When you feel it — tap. // Button: I found the beat | What is your heart broadcasting right now? Not what you want it to send. What it's actually sending. | What you feel underneath the noise is almost always simpler and kinder than you thought. |
| 15 | **Sonar** | Sound Response | Find the precise word for how you're feeling right now. / Not 'tired' — depleted, heavy, fading, wrung? / Not 'good' — settled, open, light, held? / The exact word. Say it out loud. // Button: I said it | The word. One word. The precise one. | The precise word changes what you're pointing at. The imprecise word lets you hide. |
| 16 | **Echo** | Sound Response | Close your eyes. Go completely still. / Stop sending. Stop narrating. Stop reviewing. / Let the room speak. / When you hear something you weren't hearing before — tap. // Button: I'm listening | What do you choose to keep from what you heard? | The filter you listened through is also the filter you become. What was loud enough to land. |
| 17 | **Vision** | Textarea | Close your eyes. / See your front door — the exact one. / The color. The handle. The light on it now. / When the image arrives — open your eyes and tap. // Button: I saw it | What did you see that surprised you? A detail your conscious mind had forgotten but Vision remembered? | The first image was truer than any image that came after it. The mind has been editing what the eye originally saw. |
| 18 | **Axis** | Device Tilt | Close your eyes. / Three full seconds. / Feel the inner world assert itself. / Then open — and tap. // Button: I blinked deliberately | What did you notice in the gap? The moment of neither open nor closed? | What arrived in the three seconds was already there. The blink didn't create it. The blink finally let you enter it. |
| 19 | **Crow** | Device Tilt | Stand up. Shake your hands, your arms, your whole body. / Not rhythmically — chaotically. / Until the thinking runs out of words. / Then stop. Be still. Listen. // Button: Begin (30-second shake timer) | What did you experience when the thinking stopped? Not what you thought about. What you experienced. | What was there when the narrative stopped is what has been there the whole time. The narration was not the experience — it was the delay between you and the experience. |
| 20 | **Armin** | Textarea | You have arrived. Not at something new. / At what was always already here. / Feel it — not as concept, as felt sense. The wholeness before the colors separate. / When the wholeness is present — tap. // Button: I am whole | What do you remember? | The room does not require remembering into existence. It was always here. You just arrived at it. |
| 21 | **Inception** | Textarea | Pause before you begin. One breath. / What are you carrying into this moment right now? Not what you think — what you feel. / When you know what you’re carrying — tap. // Button: I know what I’m carrying | What are you carrying into the next important thing? | What you named is already the seed. Naming it before you enter changes what you plant. |
| 22 | **Intention** | Textarea | Close your eyes. See one thing you are building — not the steps, the whole thing, finished. / Hold it complete. / When you can feel it — tap. // Button: I’m holding it | What does the finished thing look like right now, in your mind? | The picture you held is already the architecture. Everything else is building toward it. |
| 23 | **Inspiration** | Textarea | Right now — not later — what is pulling at you? / Don’t think about it. Feel the direction of it. / When you can feel the pull — tap. // Button: I feel it | What’s been pulling at you that you’ve been calling a distraction? | What you called a distraction is the signal. |
| 24 | **Insight** | Textarea | Think of one situation you’ve been looking at from the outside. / Now — step inside it. / When you’re in — tap. // Button: I’m inside it | What looks different when you’re inside it rather than observing it? | What you could see from inside was only available from inside. |
| 25 | **Intuition** | Textarea | Take one breath. / Before the breath ends — notice: is there something you already know that you haven’t put into words yet? / Don’t word it. Just feel it there. / When you feel it — tap. // Button: It’s there | What do you know right now that you haven’t put into words yet? | The knowing was already there. The words are just the most recent arrival. |
| 26 | **Invention** | Textarea | Think of two things you know that have never been connected. / Hold both in mind at the same time. / When both are present — tap. // Button: Both are here | What two things are you ready to put in the same room? | The room was always ready. You just made the introduction. |
| 27 | **Incarnation** | Textarea | One breath. Before you write — ask once: why am I here? / Not the surface answer. The real one. / Touch it. When you’ve touched it — tap. // Button: I touched it | What were you curious about when you chose this life? | The curiosity you named is the material you came for. |
| 28 | **Innocence** | Textarea | Close your eyes. Don’t look for anything. Wait. / When something arrives on its own — without you going to get it — tap. // Button: Something arrived | What do you know that no one taught you? | What you named was already known. The writing didn’t create it — it found it. |
| 29 | **Integration** | Textarea | Think of something that has been troubling you. / Notice: has any part of it stopped feeling separate from you? / Even a small part. When you find even one thing — tap. // Button: I found it | What has stopped feeling like a separate problem? | What you named as no longer separate — wasn’t. You just arrived at where it was always true. |
| 30 | **Maya** | Textarea | One field. One honest sentence. The walker names a construction — the story, the role, the identity that was true once and isn't anymore. // The gate does not ask for destruction. Maya doesn't get destroyed; it gets seen through. The naming is the seeing-through. // When the construction is named honestly, the page does not remove it. It turns it transparent — and what was always behind it becomes visible. | What did you build that isn't real? Not a mistake, not a regret — a construction. The story about why you are the way you are. The role that stopped fitting years ago. Name one. Honestly. | What you named was never a lie. It was a game board — the surface the game was played on. You don't have to destroy it. Thank it. It protected you until you were ready to see through it. The seeing-through is the entire practice. And what you see behind it — what was there before you built it — has been waiting the whole time. Three things. Just three. You already know them. |
| 31 | **Aatma** | Textarea | One field. One word. // Will. Knowledge. Action. The walker writes the one they are ready to claim — not the one they need more of, the one that has been operating underneath awareness the whole time, forgotten but never absent. // The gate does not grant anything. There is nothing to grant. The word written is a claim on what was already owned. The claiming is the crossing. | Will. Knowledge. Action. Which one did you forget you already had? Not which you need more of — which has been running underneath your awareness the whole time. Claim it. One word. | The word you wrote was never missing. It was operating every moment you thought you lacked it — pressing your feet down, running the knowing, keeping the heart beating. You did not acquire it just now. You claimed it. And the claimed one brings the other two, because the triangle has no separable vertices. Now make one choice from that place — not fear, not desire, the deepest knowing. That choice is the permission slip. It opens everything after. |
| 32 | **Ego Reveal** | Textarea | *sealed — 496 ch (one field, one inversion)* | *sealed — 231 ch* | *sealed — 480 ch* |
| 33 | **Lalita** | Textarea | One field. No question to answer. // The walker is not asked to reflect, resolve, or complete. The walker is asked to play. Marks that don't mean anything. Marks that mean everything. A word, a doodle, a joke, nothing at all — the field does not need to be useful. The field is the game. // And when play is honestly offered, the page gives the walker the Reveal — held in the build itself, met as arrival, never as spoiler. What it shows is not written in this record. It is written everywhere else in the map, waiting to be seen all at once. | This space is yours. Not for answers. Not for reflections. Not for practice. For play. Draw. Write. Make marks that don't mean anything. Make marks that mean everything. Leave it blank and come back tomorrow. This page doesn't need to be useful. This page is the game. | Whatever you made — or didn't make — that was her. The mark, the blank, the joke, the hesitation before the mark: all play, all hers, all yours. There is no wrong move on a page that is the game. And notice what just happened: you played knowing it was play, and the knowing didn't stop it. It never will. That is the whole teaching, done rather than read. Now look up from the page. Everything else is this page too. |

### A.5 Builds, panels, pairs, frequencies (verbatim)

| BP | Name | Linked Builds | Panel Seed Message | OLD Pair Partner | Mirror Frequency (body only) | Mirror Frequency Instruction |
|---|---|---|---|---|---|---|
| 1 | **Bindu** | Bindu Practice · 1 · Bindu | — | — | — | No hum. No gesture. No body location. // Place one finger on any surface and hold it still. / Feel the single point of contact. / That contact — one point, meeting one point — is Bindu’s frequency. |
| 2 | **Muladhara** | Muladhara Practice · Panel 1 — PRESS · Muladhara — Iron · Ground — Genesis · Awakening — Press (P1, 174 Hz) · Muladhara Dance · 2 · Muladhara | The earth that holds you was chosen by you. | — | — | Sit on the floor if you can. Press your sit bones down. / Hum LAM — low, deep, as if the sound is coming from below the floor. / Feel the resonance in the base of your spine. |
| 3 | **Svadhisthana** | Svadhisthana Practice · Panel 2 — FOLLOW · Svadhisthana — Crystallize · Awakening — Follow (P2, 210 Hz) · Svadhisthana Dance · 3 · Svadhisthana | Every desire was drawing you toward yourself. | — | — | Place your hand on your lower belly. Below the navel. / Hum VAM — let the sound be fluid, circular, slightly lower than comfortable. / Feel the movement below your hand. |
| 4 | **Manipura** | Manipura Practice · Panel 3 — BUILD · Manipura — Powerful · Awakening — Build (P3, 320 Hz) · Manipura Dance · 4 · Manipura | The fire that agitated you was building your form. | — | — | Place your hand on your belly at the navel point. / Hum RAM — bright, warm, forward-moving. / Feel the solar plexus ignite against your palm. |
| 5 | **Anahata** | Anahata Practice · Panel 4 — OPEN · Anahata — Love Me Like You Do · Awakening — Open (P4, 341 Hz) · Anahata Dance · 5 · Anahata | The love that arrived for others was always your own heart opening. | — | — | Place your hand on your chest. Feel your heartbeat against your palm. / Hum YAM — let it start in the chest and expand outward. / The sound was already playing. You are joining it. |
| 6 | **Vishuddha** | Vishuddha Practice · Panel 5 — SPEAK · Vishuddha — The Sound of Silence · Awakening — Speak (P5, 384 Hz) · Vishuddha Dance · 6 · Vishuddha | What you finally said out loud was what you always knew. | — | — | The throat is the instrument. No hand needed. / Hum HAM — feel the resonance specifically in the back of the throat where it meets the spine. / Then speak one true thing out loud. |
| 7 | **Ajna** | Ajna Practice · Panel 6 — STILL · Ajna — Experience · Awakening — Still (P6, 426 Hz) · Ajna Dance · 7 · Ajna | You stopped looking and the seeing arrived on its own. | — | — | Close your eyes. Hum AUM slowly — feel it in the space between your eyebrows. / At the end of each hum, hold the silence. / In the silence, look at the space between your brows from the inside. |
| 8 | **Sahasrara** | Sahasrara Practice · Panel 7 — RECEIVE · Sahasrara — Golden · Awakening — Receive (P7, 480 Hz) · Sahasrara Dance · 8 · Sahasrara | The disease that was removed was the belief that you were less than what you are. | — | — | · · · silence · · · / No hum. The crown is the syllable before syllables. / Sit still. Let all sound cease. Feel the top of your head. |
| 9 | **Shadow** | Shadow Practice · In Shadow — A Modern Odyssey · 9 · Shadow | — | — | — | No bija — Shadow's frequency is not a tone but a word. The syllable the corridor was waiting for is the walker's own voice, offered into the dark. The practice is not humming — it is naming. Before leaving Shadow, the walker speaks or writes the one word: what they were afraid to look at. That word, honestly offered, is the frequency that opens the corridor. // The body cannot hum its way through Shadow. Only naming can. // · · · the word you offer to the dark · · · |
| 10 | **Soles** | Soles Practice · 10 · Soles | — | Hands | Stand. Feel your feet. Hum this tone low and long. / Let the vibration travel from your throat down through your spine into the ground. | Stand. Feel your feet. Hum this tone low and long. / Let the vibration travel from your throat down through your spine into the ground. |
| 11 | **Forge** | Forge Practice · 11 · Forge | — | Crow | Hand on belly. Hum low and bright. / Feel the navel point vibrate against your palm. | Hand on belly. Hum low and bright. / Feel the navel point vibrate against your palm. |
| 12 | **Prana** | Prana Practice · 12 · Prana | — | Pulse | Breathe audibly. Let the air make sound as it crosses the threshold. / The door is open. It always was. | Breathe audibly. Let the air make sound. / The door is open. It always was. |
| 13 | **Hands** | Hands Practice · 13 · Hands | — | Soles | Rub your palms near the microphone — let the hands make sound. / Or hum YAM into your cupped hands and feel the resonance. | Rub your palms near the microphone. / Or hum YAM into your cupped hands and feel the resonance. |
| 14 | **Pulse** | Pulse Practice · 14 · Pulse | — | Prana | Press your fingers to your pulse. Tap a surface in time with each beat. / Feel your own rhythm feed back to you through your hand. | Find your pulse. Press two fingers to your wrist or neck. / Tap the circle on screen in time with your heartbeat. / Let the body's own rhythm feed back to you. |
| 15 | **Sonar** | Sonar Practice · 15 · Sonar | — | Echo | Hum HAM into your throat, jaw loose, lips soft. / Feel the vibration in the cheekbones, the skull. / Let the tone find the frequency that wants to move. | The mouth IS the instrument. Hum HAM before speaking a difficult truth — feel the resonance in the back of the throat where the voice originates. Then speak from that place. |
| 16 | **Echo** | Echo Practice · 16 · Echo | — | Sonar | Go still. Listen for the layer beneath the loudest sound in the room. / Hum HAM very quietly — then stop and let the silence echo back. / What the ears receive after the hum stops is the room's own frequency. | Close your eyes and go completely still. Let the layers of the room arrive in order: the obvious sounds, then what's under them. Hum HAM very softly — almost inward — and notice what the resonance reveals about the space around you. |
| 17 | **Vision** | Vision Practice · 17 · Vision | — | Crow | Close your eyes fully. Stay in the dark for three breaths. / Notice what arrives when light is removed — the inner field asserting itself. / That field runs on OM · ॐ, the frequency of Ajna. | Close your eyes. While eyes are closed, hum OM and watch what appears behind them. The vibration activates the inner visual field. What do you see while humming? |
| 18 | **Axis** | Axis Practice · Panel 10 — ACCESS (Axis Triptych) · Where'd You Go · Thunderclouds · Fade Away · 18 · Axis | — | Pulse | Slow blink — three seconds closed. Notice what the inner field shows. / Open. Let OM · ॐ hum silently in the space behind your eyes. / The blink is the practice. The tone is the carrier. | Blink once slowly. Eyes closed: silence. Eyes open: hum OM. Alternate three times. The OM activates with the crossing — each blink while humming carries the sound into the simultaneous field. |
| 19 | **Crow** | Crow Practice · 19 · Crow | — | Vision | After the shaking stops, go completely still. / Feel the spine settle. Feel the crown of the skull. / The silence after the shake is the frequency — the Sahasrara silence that Crow reaches through exertion. | No bija — Crow mirrors Sahasrara, whose frequency is silence. After the shake, stand completely still. Attend to what the body hums in the aftermath of movement. That resonance — without you producing it — is Crow's frequency. |
| 20 | **Armin** | Armin Practice · 20 · Armin | — | — | — | Tat. Tvam. Asi. / One word at a time. Let each land completely before the next arrives. / Tat — that. Tvam — thou. Asi — art. / The frequency is the recognition, not the repetition. |
| 21 | **Inception** | Inception Practice · 21 · Inception | — | — | — | Before you begin — pause. One breath. / What are you carrying into this moment? Not what you think — what you feel. / The felt inventory is the practice. |
| 22 | **Intention** | Intention Practice · 22 · Intention | — | — | — | Close your eyes. See the finished thing — not the steps, the whole. / Hold it until it feels real in the body. / The held image is the frequency. |
| 23 | **Inspiration** | Inspiration Practice · 23 · Inspiration | — | — | — | Notice what is pulling at you right now. Not the thought of the pull — the pull itself. / Don’t redirect it. Let it move. / The movement is the instruction. |
| 24 | **Insight** | Insight Practice · 24 · Insight | — | — | — | Choose one thing you’ve been observing from the outside. Step inside it. / Feel the difference between looking at it and being in it. / The inside-view is the register. |
| 25 | **Intuition** | Intuition Practice · 25 · Intuition | — | — | — | One breath. Before it ends — something is already known. / Don’t word it yet. Just feel it there. / The pre-word signal is the frequency. |
| 26 | **Invention** | Invention Practice · 26 · Invention | — | — | — | Name two things you know that have never touched. / Hold both at once. Let the third thing that emerges be felt before it is named. / The emergence is the register. |
| 27 | **Incarnation** | Incarnation Practice · 27 · Incarnation | — | — | — | Ask once, before writing: why am I here? Not the surface answer. / Touch the real one. Let it stay wordless for a moment. / The sovereign question is the frequency. |
| 28 | **Innocence** | Innocence Practice · 28 · Innocence | — | — | — | Be still. Don’t look for anything. / Let the knowing arrive on its own — without you going to find it. / The first thing that comes is the one. |
| 29 | **Integration** | Integration Practice · 29 · Integration | — | — | — | Find one thing that has stopped feeling like a separate problem. / Hold it alongside everything else — not merged, just no longer apart. / The equal taste is the register. |
| 30 | **Maya** | Maya Practice · Panel 9 — DISSOLVE · Maya — Love Is The Only Thing · Awakening — Dissolve (P9, Silence) · Maya Dance · 30 · Maya | There was never anything to fear. There was only the Bindu, playing. | — | — | No tone. Maya's frequency is transparency, and transparency is reached by gratitude, not by sound. // Before leaving Maya, the walker names one construction — out loud or in writing — and thanks it. A construction fought stays solid. A construction thanked completes its purpose and goes see-through. The thanking is the frequency. // This is Kameshvari's register: the creative force recognizing herself. Every bija the walker has carried — LAM through the crown's silence — sounds at once here and resolves into the quiet behind them. The body does not hum at Maya. The body listens to what all the humming was made of. |
| 31 | **Aatma** | Aatma Practice · Panel 8 — HOLD · Aatma — Chase Hughes · Awakening — Hold (P8, 528 Hz) · Aatma Dance · 31 · Aatma | Will. Knowledge. Action. You already know. You have always known. | — | — | No new tone. Aatma's frequency has been sounding since before the first page — three rhythms, already running: the heartbeat that never stops, the breath that never closes, the blink that crosses. // The practice before leaving is not to produce a sound but to notice the three that were never absent. Hand on chest for the heartbeat. Attention on the breath for one full cycle. Then one deliberate blink — eyes closed, eyes open — felt as a crossing. // This is Vajreshvari's register: preservation, the Sun, the sustaining that was never in question. The walker does not tune to Aatma. The walker discovers they were the tuning. |
| 32 | **Ego Reveal** | Ego Reveal Practice · 32 · Ego Reveal | — | — | — | *sealed — 677 ch* |
| 33 | **Lalita** | Lalita Practice · 33 · Lalita | — | — | — | Her frequency is delight. Not a tone to produce, not a rhythm to notice — the register underneath both: the felt sense that the image knows you're looking at it and is pleased. // The practice before leaving — and it is the last instruction the map gives: laugh once today for no reason. Not at something. From something. And in the middle of the laugh, notice who is laughing. Do not answer the question. The laugh is the answer. // Every bija the walker sounded, every rhythm the walker noticed, every silence the walker entered — all of it was her frequency at different registers. What remains at the crown of the Tree of Life is the sound made purely for joy. It cannot be practiced. It can only be played. |


### A.6 The structures that run across all 33

**A.6.1 Which field is which voice (the layer contract, from the field descriptions + reading).**

| Field | Who speaks | Where the Map says it shows | Fill | Tag |
|---|---|---|---|---|
| Act 1 Voice | the Bindu, first person, in the moment ("I don't know what I am yet.") — tap-to-advance | Story Mode | 33 | S (the braid's moving-point story) |
| Act 2 Voice | Sakshi, addressed "you", auto-paced; ends on the next verb ("Follow." "Speak." "Stop." "Receive." "Go.") | after the Veil | **10** (Bindu, the 7 energy, Shadow, Armin) | S |
| Bindu Reflection | the Bindu after the chakra, integrating; every one ends on a hand-off line to the next ("I'm about to …", "Something is warming in my middle.") | after the story | 33 | S |
| Witness Perspective | Sakshi structural — "What is being witnessed here is …" | depth / reference | 33 | S |
| Gaia Voice | Gaia, third person ("She has …") — planetary substrate | none (author substrate) | 33 | S · substrate |
| Story Thread | the narrator between chakras; rooms 5–9 carry "Bindu, integrating:" and "Gaia, underneath:" movements, mind rooms carry "Bindu, integrating:" | between rooms | 33 | S |
| Leela Story | after the gate; short recognition at most rooms, a **letter** ("Hi.", signed "Lightly.") at 9, 20, 27, 29, 30, 31, 32, 33 | Mandala room after the gate; Leela drops | 33 | E-close at short ones · S (letters) |
| Teaching Text | the voice that knows the chakra, to the walker | the page's recognition | 33 | E (with Gaia paragraphs inside — S) |
| Post-Engagement Teaching | direct, sometimes confrontational; "What the [X] Knows That You Forgot" | **only after the walker has written** | 33 | E |
| Practice Prompt · Three Ways In · Gate Text · Writing Prompt / Reflection · Mirror Frequency (+ Instruction) · Bija Mantra | instruction | practice, gate, wake-up | 33 (Mirror Frequency 10) | E |
| Shakti Name · Function · Mudra · Practice · Avarana · Body Location | the yantra and the body | Go Deeper / reference box | 33 | E (Practice = substrate) |
| Tree Caption · Dyad Description · Colour Dyad · Subtle Mirror | the image, the colours, the twin | tree lightbox, Go Deeper | 33 / 12 / 10 / 33 | E |

**A.6.2 The mudrā chain — one gesture per āvaraṇa, carried forward ("the permission slip").**

| Rooms | Mudrā (Map's name) | Āvaraṇa | The Map's own words for the carrying |
|---|---|---|---|
| 1 Bindu | Yoni | 9 | "Through all 32 chakras that follow, this gesture is your way back to the point." |
| 2 · 3 · 4 | Kshobha ×3 | 1 (Bhupura, three rings) | "one gesture, three rings of one shared earth" |
| 5 · 8 | Dravini ×2 | 2 (16 petals) | Anahata melts the grasping; Sahasrara "dissolves the apparent separator between attractor and attracted" |
| 6 · 7 | Akarshana ×2 | 3 (8 petals) | "One Mudra, two operations. Outward through the throat as utterance. Inward through the eye as seeing." |
| 9 Shadow | none — "the press-and-hold itself" | threshold | "the gesture of admitting the door exists" |
| 10 · 11 · 15 | Vasya ×3 | 4 (14 triangles) | "the force that brings everything into relationship" |
| 12 · 13 · 14 | Sarvonmadini ×3 | 5 (outer 10) | breath received, touch landed, heartbeat as "the body's original intoxicant" |
| 16 · 17 · 18 · 19 · 20 | Mahankusha ×5 | 6 (inner 10) → Armin | Armin: "the great goad completing its work, pointing inward toward the mind" |
| 21–28 | Rahasya ×8 | 7 (8 triangles) | "The Rahasya Mudra presides across the entire Mind section. Rahasya means the secret." |
| 29 · 30 · 31 · 32 | Sarva Beeja ×4 | 7 (presiding) → 8 | Aatma: "the permission slip that opens the E Chakra field" |
| 33 Lalita | Yoni | 9 | "the return to source completing the circle" |

The Map's Manipura record lists the ten Mudra Shaktis in exactly this āvaraṇa order: Sankshobhini, Vidravini, Karshini, Vashankari, Unmadini, Mahankusha, **Khechari**, Beeja, Yoni, Trikhanda. The chain above matches that list at every step except āvaraṇa 7, where the Map's word is "Rahasya" (see C11).

**A.6.3 The yantra facts held in Shakti Function** (the app's bundle does not carry them).

| Āvaraṇa | Name | Presiding · Yoginī · mental state · body of the goddess | Rooms |
|---|---|---|---|
| 1 | Trailokya Mohana — "Enchanter of the Three Worlds" | Tripura · Prakata (Manifest) · Jagrata — Wakefulness · "her feet" | 2, 3, 4 |
| 2 | Sarva Asha Paripuraka — "Fulfiller of All Hopes and Desires" | Tripureshi (at the crown) · Gupta (the Hidden) · Swapna — Dream · "her Svadhisthana chakra" | 5, 8 |
| 3 | Sarva Samkshobhana — "Agitator of All" | Tripura Sundari · Guptatara (Hidden Star) · Sushupti · "her navel region"; the Anangas govern "the 8 karmendriya" | 6, 7 |
| 4 | Sarva Saubhagya Dayaka — "Bestower of All Auspiciousness" | the 14 Sampradaya Yoginis — Soles #1, Forge #13, Sonar #14 | 10, 11, 15 |
| 5 | Sarvartha Sadhaka — "Accomplisher of All Objects" | the 10 of the vital pranas — Hands #3, Pulse #4, Prana #5 | 12, 13, 14 |
| 6 | Sarva Raksha Kara — "Protector of All" | Vision #1, Echo #4, Crow #6, Axis #8 | 16–19 |
| 7 | Sarva Rogahara — "Remover of All Disease" (named in Armin's Shakti Function) | 8 Vāgdevīs, presided by Tripura Siddhamba, "Destroyer of Poison" | 21–29 |
| 8 | (the inner triangle) | the three Kama Kala Shaktis — Kameshvari "Creation force / Moon", Vajreshvari "Preservation force / Sun", Bhagamalini "Dissolution force / Fire" | 30, 31, 32 |
| 9 | Sarvanandamaya — "All-Blissful" | Lalita / Rajarajeshvari · Yoginī "Para-ati-Para Rahasya" · "Savikalpa Samadhi" · three sub-bindus | 1, 33 |
| — | Shadow: between 1–3 (Srishti) and 4–6 (Sthithi) · Armin: between 4–6 and 7–8 (Samhara), Tripura Malini "lives at the bends in the necklace" | | 9, 20 |

Glosses carried inside Shakti Function:
- every one of the **10 Siddhis** (Muladhara);
- every one of the **8 Mātṛkās** (Svadhisthana);
- every one of the **10 Mudrā Śaktis** (Manipura);
- every one of the **16 Ākarṣiṇīs** (Anahata);
- every one of the **8 Anaṅgās** (Vishuddha + Ajna).

That makes 52 one-line glosses for kp 1–52. The app already joins each chakra to its seats (bundle `kp`, `joinedBy`).

**A.6.4 The Subtle Mirror graph** (who each room names as its twin).

| Room | Its twin | Room | Its twin |
|---|---|---|---|
| 1 Bindu | Integration | 18 Axis | Ajna |
| 2 Muladhara | Sahasrara | 19 Crow | Sahasrara |
| 3 Svadhisthana | Vishuddha | 20 Armin | Shadow |
| 4 Manipura | Ajna | 21 Inception | Incarnation |
| 5 Anahata | Svadhisthana | 22 Intention | *none — "holds the complete picture of all nine"* |
| 6 Vishuddha | Svadhisthana | 23 Inspiration | Invention |
| 7 Ajna | Manipura | 24 Insight | Intuition |
| 8 Sahasrara | Muladhara | 25 Intuition | Insight |
| 9 Shadow | Armin | 26 Invention | Inspiration |
| 10 Soles | Muladhara | 27 Incarnation | Inception |
| 11 Forge | Manipura | 28 Innocence | Integration |
| 12 Prana | Svadhisthana | 29 Integration | Innocence |
| 13 Hands | Anahata | 30 Maya | Bindu ("the origin inverted") |
| 14 Pulse | Anahata | 31 Aatma | Maya ("bark and heartwood") |
| 15 Sonar | Vishuddha (sending) | 32 | *sealed* |
| 16 Echo | Vishuddha (receiving) | 33 Lalita | Bindu ("the origin arrived") |
| 17 Vision | **Manipura** (but its bīja says Ajna — C4) | | |

**A.6.5 The body's five couples** (Teaching Text, the live pairing), against OLD Pair Partner (retired 12 Oct).

| Couple (Teaching Text) | The Map's words | OLD Pair Partner says |
|---|---|---|
| Soles ↔ Hands | "Soles press DOWN — receiving from the earth. Hands reach OUT — sending into the world." | same |
| Forge ↔ Prana | "the Breath Column — nose to navel. The open door and the sealed chamber." | Forge–Crow, Prana–Pulse |
| Pulse ↔ Axis | "The rhythm that never stops and the switch that keeps crossing." | Pulse–Prana, Axis–Pulse |
| Sonar ↔ Echo | "Together they are one throat" | same |
| Vision ↔ Crow | "One forehead. One crown. One brain. Two directions." | Vision–Crow, but Forge–Crow too |

**A.6.6 The dyad system** (Colour Dyad on the 10 body rooms; Dyad Description on those 10 plus Shadow and Armin).
- Red/Cyan (Soles), Yellow/Blue (Forge, Vision), Orange/Azure (Prana), Green/Magenta (Hands, Pulse), Blue/Yellow (Sonar, Echo), Indigo/Chartreuse (Axis), Violet/Chartreuse (Crow).
- Shadow: "Shadow has no dyad … darkness and starfield".
- Armin: "the dyad system completed — not one chakra's pair but all pairs at once".
- The Primary Color cell spells the same pairs differently: "Gold + Blue" for Yellow/Blue, "Orange + Blue" for Orange/Azure, "Blue + Gold" for Blue/Yellow.

**A.6.7 The Mind ring.** Shakti Function orders the Vāgdevīs as below; the app's kp column agrees.

| Vāgdevī | Room | kp | Triad |
|---|---|---|---|
| Vasini #1 | Inception | 87 | Creation |
| Kamesvari #2 | Intention | 88 | Creation |
| Modini #3 | Inspiration | 89 | Creation |
| Vimala #4 | Insight | 90 | Recognition |
| Aruna #5 | Intuition | 91 | Recognition |
| Jayani #6 | Invention | 92 | Recognition |
| Sarvesvari #7 | Incarnation | 93 | Emergence |
| Kaulini #8 | Innocence | 94 | Emergence |
| Tripura Siddhamba (presiding, "not a ninth Vagdevi") | Integration | — | Emergence |

Two orders exist:
- **Number** (in-system): Innocence 1 · Inspiration 2 · Intuition 3 · Insight 4 · Inception 5 · Intention 6 · Invention 7 · Incarnation 8 · Integration 9. Inspiration's teaching calls this "the child’s discovery sequence".
- **Book Position** (the Road): Inception 21 … Incarnation 27 · Innocence 28 · Integration 29.

Armin's Post-Engagement Teaching gives the overture: "Nine centers. Three groups of three. Each group has one job: Creation, Recognition, or Emergence. … IN. / Nine doorways. All pointing inward."

**A.6.8 Panels, awakenings and songs** (Linked Builds, Panel Verb, Panel Seed Message). The Tree of Life installation, panel by panel:

| Panel | Verb | Awakening | Room · song |
|---|---|---|---|
| P1 | PRESS | 174 Hz | Muladhara · Iron, Genesis |
| P2 | FOLLOW | 210 Hz | Svadhisthana · Crystallize |
| P3 | BUILD | 320 Hz | Manipura · Powerful |
| P4 | OPEN | 341 Hz | Anahata · Love Me Like You Do |
| P5 | SPEAK | 384 Hz | Vishuddha · The Sound of Silence |
| P6 | STILL | 426 Hz | Ajna · Experience |
| P7 | RECEIVE | 480 Hz | Sahasrara · Golden |
| P8 | HOLD | 528 Hz | Aatma · Chase Hughes |
| P9 | DISSOLVE | silence | Maya · Love Is The Only Thing |
| P10 | ACCESS ("Axis Triptych") | — | Axis · Where'd You Go, Thunderclouds, Fade Away |

- Shadow links the song In Shadow — A Modern Odyssey.
- Every energy room and Maya and Aatma link a "Dance".
- Body, mind, Armin, 32 and Lalita link only their Practice page.
- The nine Panel Seed Messages equal the Signature Phrase on P1–P7 and P9. P8 (Aatma) prefixes "Will. Knowledge. Action."

**A.6.9 The practices that leave the room** (portable; the Map names them as carried for life).

| Practice | Where it is defined |
|---|---|
| **Blink · Breathe · Press** — "One second. Three chakras." | Soles PET; Lalita PET |
| **Cross. Blink. Feel. Return.** — "one minute, full system" | Lalita PET |
| **Your Inner Field** — "the gateway that never closes" | Lalita, Axis |
| **the Sacred Pause** (C-1160) | Prana, substrate |
| **the Euphoria Pulse** (C-1311) | Hands, Pulse |
| **the Vision practice** (C-1311) and **the Axis practice** (C-1311) | substrate |
| **the Crow flood**, "Three to five minutes" | Crow |
| **one deliberate blink per day** | Axis |
| **the long blink** at sleep | Axis |
| **Echo's daily report** | Echo |
| **the nightly visual replay** | Vision |
| **sleep toward one intention** | Intention |
| **the four doors of the crown** | Sahasrara |
| **the transmutation line** ("I see you. I love you. Thank you for showing up. You can rest now.") | Shadow |
| **the glass line** ("I see you. Thank you for the protection. You can be glass now.") | Maya |
| **one choice from the heartwood** | Aatma |
| **send love into the field** | Integration |
| **one Siddhi for someone else** | Incarnation |
| **the inverted belief, imagined** | Armin |
| **laugh once for no reason** | Lalita |

**A.6.10 The body's numbers** (all verbatim from Teaching / Post-Engagement / Practice).

| Subject | Figures |
|---|---|
| Heart | "approximately one hundred thousand times per day, thirty-seven million times per year"; fetal beat "around six weeks"; "sixty to a hundred times per minute" |
| Blink | "fifteen to twenty times per minute … roughly seventeen thousand times per day … about a third of a second … approximately ninety minutes per day … Six million per year" |
| Breath | "fifteen times per minute, nine hundred times per hour, twenty-one thousand times per day"; molecules "in circulation for four billion years" |

Timings in the practices:

| Room | Timing |
|---|---|
| Muladhara | ten breaths; 4-4-8 hum breath |
| Manipura | Breath of Fire thirty seconds |
| Anahata | two minutes |
| Sahasrara | five minutes silence |
| Hands | rub fifteen seconds; palms six inches |
| Crow | 30-second shake timer; two minutes in Three Ways |
| Axis | three seconds closed, then five |
| Soles | three surfaces × thirty seconds |
| Forge | five minutes |
| Intention | sixty seconds |
| Invention | three minutes |
| Intuition | thirty seconds |
| Every mudrā | three breaths |

### A.7 The 33 rooms — long fields, one dossier each

Each dossier has two parts:
- **Hand lines** give the structure, the mechanism and the key lines, quoted exactly. Every quoted string was verified programmatically against the record dump.
- **Field lines** give each long field's size and its exact first sentence and last line. A field of 420 characters or fewer is quoted in full.

#### 01 · BINDU — The Origin  ·  `recKAQWX7yUIB3ktW` · Tree of Life

- **Teaching Text structure:** 7 ¶ — (1) recognition not technique; (2) "Bind · U. The point that binds you to yourself."; (3) structural truth, every walker identical at the point; (4) Gaia's call answered by a point ("You are one of the answers."); (5) Lalita / Avarana 9 / three sub-bindus "Kurukulla (red, the feminine), Varahi (white, the masculine), and their union"; (6) recognition = ceasing; (7) Yoni Mudra carried through all 32 — "Bindu = Lalita. Beginning = end. The same point."
- **Practice Prompt:** tap once on a canvas, look, then Yoni Mudra "thumbs touching, index fingers touching" for three breaths; "this mudra is the permission slip".
- **Three Ways In (3 doors):** place another point (the first disappears) · find a point already in the room · close your eyes and find the point inside — "No canvas needed."
- **Post-Engagement Teaching:** the point is "as unique as a fingerprint"; "you'll return to a point. Same gold. Same quiet." — the closing promise of the whole walk.
- **Tree Caption:** the only record that says *no tree*: "Bindu's only visualization is the canvas above".
- **Subtle Mirror → Integration (29).**
- **Act 2 (Sakshi) ends** "Go." — the covenant line "What you are about to reach toward will reach back."
- **Mirror Frequency Instruction:** "Place one finger on any surface and hold it still." — a touch-and-hold frequency with no sound.

*Field lines:*
- *Teaching Text* [E] — 2559 ch · 7 ¶ · opens “Bindu is not a technique.” … closes “The same point.”
- *Practice Prompt* [E] — 701 ch · 4 ¶ · opens “Draw a single point.” … closes “The structure built here waits.”
- *Three Ways In* [E] — 707 ch · 3 ¶ · opens “Place another point.” … closes “No canvas needed.”
- *Post-Engagement Teaching* [E] — 1403 ch · 6 ¶ · opens “You placed it.” … closes “The rest is the unfolding.”
- *Tree Caption* [E] — 224 ch · full: “No tree. The origin has no tree because form has not yet begun. Bindu's only visualization is the canvas above — one point, anywhere, the seed every later geometry emerges from. The page is the only door from the experience.”
- *Subtle Mirror* [E] — 378 ch · full: “Integration. Bindu is the origin before the walk begins — the point from which all thirty-three registers radiate. Integration is the recognition at the end of Mind that nothing was ever separate from the origin. Both hold the same truth: the multiplicity was always one point. Bindu knows this before the walk. Integration recognizes it after. The walk is what happens between.”
- *Shakti Function* [E] — 972 ch · 1 ¶ · opens “Avarana 9 —” … closes “Avarana 9's mudra is the Yoni Mudra — the womb gesture, return to source — which the walker carries forward through every chakra of the walk as the permission slip back to this point.”
- *Shakti Practice* [E·substrate] — 177 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 515 ch · 1 ¶ · opens “The point arrives without knowing it was called.” … closes “The arrival is the first sentence of the response.”
- *Act 1 Voice* [S] — 611 ch · 6 ¶ · opens “I don't know what I am yet.” … closes “I think I'm about to find out.”
- *Act 2 Voice* [S] — 549 ch · 3 ¶ · opens “You are not alone.” … closes “Go.”
- *Bindu Reflection* [S] — 704 ch · 5 ¶ · opens “Something has happened.” … closes “I'm about to touch something.”
- *Witness Perspective* [S] — 1240 ch · 4 ¶ · opens “What is being witnessed here is the moment before the moment.” … closes “This is the architecture's only true beginning. Every other position has a position before it. Bindu has no before. The before is not part of the walk.”
- *Leela Story* [S] — 300 ch · full: “The point has been placed. // Everything that happens from here radiates from what you just did. The walk begins not when you press the first chakra but when you felt Bindu for the first time — which you just did. // You don’t need to understand that yet. You just need to know it happened. // Keep moving.”
- *Gaia Voice* [S·substrate] — 433 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 02 · MULADHARA — Where the Body Meets the Earth  ·  `recT3JC8Qz9awKo8j` · Energy

- **Teaching Text:** 7 ¶ — the root's question "Am I safe here?"; "being-here is being-with"; the 10 Siddhi Devis "latent, not aspirational … from Anima, the infinitely small, to Sarvakama"; Bhupura = Avarana 1, Trailokya Mohana, three rings (Siddhis at Muladhara, Matrikas at Svadhisthana, Mudras at Manipura); Kshobha Mudra "Both hands at the heart, fingers interlaced, thumbs pointing up."
- **Practice Prompt:** stand, press "the way you press your palm into clay", ten breaths pressing on each exhale; "On each press, let one question surface: which of the 10 Siddhis is latent in me right now?"; then Kshobha Mudra, three breaths.
- **Shakti Function** names all ten Siddhis with glosses (Anima infinitely small · Laghima weightless · Mahima infinitely large · Ishitva mastery · Vashitva command · Prakamya irresistible will · Bhukti enjoyment · Ichha pure desire · Prapti obtaining · Sarvakama all desires fulfilled) + presiding Tripura, Yogini Prakata, mental state Jagrata, "Body of the goddess at this avarana: her feet."
- **Three Ways In:** barefoot ten steps · sit directly on the ground · 4-4-8 breath with a low hum "The hum vibrates the pelvic floor."
- **Post-Engagement:** womb → chest → first standing; "Every tantrum you threw as a child was this center testing the ground."
- **Subtle Mirror → Sahasrara (8)** (root/crown poles).
- **Linked Builds:** Panel 1 — PRESS; songs Iron, Genesis; Awakening — Press (P1, 174 Hz); Muladhara Dance.

*Field lines:*
- *Teaching Text* [E] — 2741 ch · 7 ¶ · opens “The root doesn't ask whether you're ready, spiritual, or deserving.” … closes “This same Mudra will return at Svadhisthana and Manipura — one gesture, three rings of one shared earth.”
- *Practice Prompt* [E] — 785 ch · 6 ¶ · opens “Stand up.” … closes “I am ready for what comes next.”
- *Three Ways In* [E] — 672 ch · 3 ¶ · opens “Walk barefoot on grass, earth, or a cool floor.” … closes “That's enough.”
- *Post-Engagement Teaching* [E] — 1408 ch · 8 ¶ · opens “You were held before you could hold yourself.” … closes “The answer hasn't changed since the first time you stood up. The ground is here. The ground presses back. You are held.”
- *Tree Caption* [E] — 60 ch · full: “Tap to look closer. The roots hold more than shows at first.”
- *Subtle Mirror* [E] — 337 ch · full: “Sahasrara. The two poles of the energy body. Muladhara presses down into the earth and knows it is held. Sahasrara opens upward and discovers it is included. Both are recognition of the same truth from opposite ends of the spine: you are not separate from what holds you. The root holds the crown’s question before the question is asked.”
- *Shakti Function* [E] — 1280 ch · 1 ¶ · opens “Avarana 1 (outer ring of Bhupura) —” … closes “The first three energy chakras together form one bounded earth — the establishment of presence in matter, before the walker rises into the lotuses.”
- *Shakti Practice* [E·substrate] — 333 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 620 ch · 1 ¶ · opens “Two things become visible because they meet.” … closes “It is holding still.”
- *Act 1 Voice* [S] — 1099 ch · 5 ¶ · opens “I touched something.” … closes “I had a question I didn't know I was asking, and it's been answered. Am I safe here? Yes.”
- *Act 2 Voice* [S] — 663 ch · 3 ¶ · opens “The ground was holding before you touched it.” … closes “Follow.”
- *Bindu Reflection* [S] — 1050 ch · 5 ¶ · opens “Something is changed in me.” … closes “I'm about to want something specific.”
- *Witness Perspective* [S] — 1533 ch · 5 ¶ · opens “What is being witnessed here is the first meeting.” … closes “The answer is felt before it is articulated.”
- *Leela Story* [S] — 630 ch · 4 ¶ · opens “You pressed your feet into the ground.” … closes “This is what you carry forward: you are held. The holding was always happening. Now you know it is.”
- *Gaia Voice* [S·substrate] — 844 ch · 3 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 03 · SVADHISTHANA — The Tide Below  ·  `recnJICbhZefO3YJ9` · Energy

- **Teaching Text:** 7 ¶ — "you want"; desire "not personal in origin and personal in expression"; recovery of original wanting ("What did the walker want before the editor arrived?"); the 8 Matrikas as "the divine mothers of every emotional state" — "It's emotional hospitality."; middle ring of Bhupura; Kshobha Mudra again.
- **Shakti Function** glosses all eight Matrikas: Brahmi passionate longing / creative impulse · Maheshvari fierce dissolution · Kaumari youthful warrior · Vaishnavi righteousness / preservation · Varahi obstinacy as ground-holding · Mahendri/Indrani pride as sovereignty · Chamunda destructive emotions transmuted · Mahalakshmi abundance, grace, overflow.
- **Practice Prompt:** eyes closed, "what do you want?", write before the editor, Kshobha Mudra; "Which of the 8 Matrikas is visiting you right now".
- **Three Ways In:** hips to any song · make without a plan · a bath ("earth holds firmly, water holds gently").
- **Post-Engagement:** following vs chasing — "Chasing is desire wearing the solar plexus's clothes"; "You didn't want that person. You wanted what that person's presence activated in you."
- **Subtle Mirror → Vishuddha (6).** Panel Verb FOLLOW vs Verb FLOW.
- **Linked Builds:** Panel 2 — FOLLOW; Crystallize; Awakening — Follow (P2, 210 Hz); Dance.

*Field lines:*
- *Teaching Text* [E] — 3047 ch · 7 ¶ · opens “Svadhisthana governs one irreducible fact:” … closes “The Kshobha Mudra is the readiness that lets you receive them without flinching.”
- *Practice Prompt* [E] — 1155 ch · 7 ¶ · opens “Close your eyes.” … closes “The Mudra is how you say: I am ready.”
- *Three Ways In* [E] — 813 ch · 3 ¶ · opens “Put on any song and let your hips do what they do when nobody's watching.” … closes “The sacral is the water version of being held.”
- *Post-Engagement Teaching* [E] — 1742 ch · 8 ¶ · opens “Following is what water does.” … closes “The whole arc of your pulling — followed and unfollowed — was one continuous compass.”
- *Tree Caption* [E] — 75 ch · full: “Tap to look closer. The seed is in the reflection — that isn't an accident.”
- *Subtle Mirror* [E] — 300 ch · full: “Vishuddha. Desire and expression. What flows within and what flows outward through speech. Svadhisthana holds what wants to move — the longing, the wanting, the creative tide. Vishuddha gives it form in language. The water finds its voice at the throat. What is carried below eventually speaks above.”
- *Shakti Function* [E] — 1399 ch · 1 ¶ · opens “Avarana 1 (middle ring of Bhupura) —” … closes “Mudra of Avarana 1: Kshobha Mudra — the readiness gesture, entering the three worlds.”
- *Shakti Practice* [E·substrate] — 501 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 602 ch · 1 ¶ · opens “She placed the desire at the end of the current and let consciousness find it the way water finds the slope.” … closes “Every honest pull brings light into the field.”
- *Act 1 Voice* [S] — 959 ch · 5 ¶ · opens “And now —” … closes “I didn't know desire was this quiet.”
- *Act 2 Voice* [S] — 865 ch · 3 ¶ · opens “Every pull you ever felt.” … closes “The pull is about to become heat. This is not a betrayal of the water. The heat is what the water was finding.”
- *Bindu Reflection* [S] — 879 ch · 5 ¶ · opens “I'm still flowing.” … closes “I'm about to burn.”
- *Witness Perspective* [S] — 1580 ch · 5 ¶ · opens “What is being witnessed here is the moment desire receives a direction.” … closes “One small honest pull, followed.”
- *Leela Story* [S] — 601 ch · 4 ¶ · opens “Something moved.” … closes “The feeling is the source.”
- *Gaia Voice* [S·substrate] — 1045 ch · 4 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 04 · MANIPURA — The Sealed Chamber  ·  `recVgGgYgZE1YMU2V` · Energy

- **Teaching Text:** 9 ¶ — "Manipura is the city of jewels"; "Form is not given. Form is forged."; "The fire is not the problem. Check the fuel."; Gaia's fire "used to make galaxies"; glosses of the 10 Mudra Shaktis (Sankshobhini disturbs complacency … Trikhanda "will, knowledge, action"); Bhupura complete; Kshobha Mudra the third time; "Procrastination is Manipura blocked … (C-1198)".
- **Practice Prompt:** navel drawn to spine, write "what has the fire been building … what is it burning that isn't yours?", Kshobha Mudra releasing one inherited agenda per breath; "Notice the gesture already happening in your hands, your shoulders, your jaw. That gesture is one of the ten".
- **Three Ways In:** navel contraction · Breath of Fire, thirty seconds · eat one meal slowly.
- **Post-Engagement:** "A healthy person is not cooler. A healthy person has their fire lit by what is actually theirs." / "What survives the burning is what you're made of. The rest was fuel."
- **Subtle Mirror → Ajna (7).** Panel Verb BUILD vs Verb BURN.
- **Linked Builds:** Panel 3 — BUILD; Powerful; Awakening — Build (P3, 320 Hz); Dance.

*Field lines:*
- *Teaching Text* [E] — 3483 ch · 8 ¶ · opens “Manipura is the city of jewels —” … closes “The Mudra says: I am allowing it to draw toward itself what is actually mine.”
- *Practice Prompt* [E] — 1285 ch · 6 ¶ · opens “Stand.” … closes “The Kshobha Mudra is what you carry forward — the readiness slip back to the entire bounded earth. Three rings traveled. The Bhupura is complete. What comes next is the first lotus.”
- *Three Ways In* [E] — 918 ch · 3 ¶ · opens “Pull your navel toward your spine and keep it there while you breathe.” … closes “The practice is to witness the furnace, not to do anything to it.”
- *Post-Engagement Teaching* [E] — 1675 ch · 8 ¶ · opens “The fire was never trying to destroy you.” … closes “And now — look at the form. The form it made is the one you've been wearing.”
- *Tree Caption* [E] — 56 ch · full: “Tap to look closer. The tree is unfinished — on purpose.”
- *Subtle Mirror* [E] — 352 ch · full: “Ajna. Will and seeing. Manipura is the fire that builds and acts. Ajna is the eye that sees without looking. Both move toward clarity — one through action, one through perception. The fire at the solar plexus and the seeing at the third eye are the same movement at different registers: the force of a consciousness that knows what it is doing and why.”
- *Shakti Function* [E] — 1134 ch · 1 ¶ · opens “Avarana 1 (inner ring of Bhupura) —” … closes “The first three energy chakras together form one bounded earth — the establishment of presence in matter, before the walker rises into the lotuses of Avarana 2.”
- *Shakti Practice* [E·substrate] — 651 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 572 ch · 1 ¶ · opens “She gave him the fire —” … closes “It is about to hear what the weight is for.”
- *Act 1 Voice* [S] — 913 ch · 5 ¶ · opens “And now —” … closes “I want to keep going. I don't want to put out this fire. The fire is building me. Building the me that was always going to arrive if I let the heat stay on long enough.”
- *Act 2 Voice* [S] — 975 ch · 3 ¶ · opens “The fire was never wrong.” … closes “What comes next is the center that was waiting for the form to be stable enough to hold it. The sound that has been playing since before the pull. Since before the ground. Since before the stirring.”
- *Bindu Reflection* [S] — 1303 ch · 6 ¶ · opens “Something has happened.” … closes “I'm about to hear something.”
- *Witness Perspective* [S] — 1688 ch · 5 ¶ · opens “What is being witnessed here is the appearance of form.” … closes “Not a generic configuration of light, but this configuration, shaped by this fuel, with this unique signature that only this fire could have produced.”
- *Leela Story* [S] — 569 ch · 4 ¶ · opens “The fire is real.” … closes “The fire is the maker. The maker is always working. You just paid attention to the making.”
- *Gaia Voice* [S·substrate] — 1389 ch · 4 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 05 · ANAHATA — The Sound That Was Always Playing  ·  `reclI9Blq6YLC9Q5O` · Energy

- **Teaching Text:** 9 ¶ (longest energy teaching after Sahasrara) — "unstruck sound"; "This is the midpoint of the entire walk."; Anahata = first lotus, Avarana 2 Shodasha Dala; "the hinge"; walls as intelligence — "That is the wall wearing your face."; the 16 Akarshana Devis named in full; Tripureshi presides not here but at Sahasrara — "The heart draws. The crown reveals who was drawing."; Dravini Mudra; closes "You don't open the heart. You get quiet enough that the opening becomes audible."
- **Shakti Function:** the 16 with glosses (Kamakarshini desire … Sharirakarshini the physical body), mental state Swapna, "Body of the goddess … her Svadhisthana chakra", Yogini Gupta.
- **Practice Prompt:** hand on chest two minutes "Attention is the water. The heart is already the plant."; then Dravini Mudra "ring finger and thumb of each hand touching lightly, the other fingers releasing".
- **Three Ways In:** breathe into anger "Don't forgive them." · hum YAM into the sternum · three seconds of seeing a stranger's face.
- **Post-Engagement (2416 ch):** "the heart cannot be broken. It can only be opened further."; "Love is the direction of looking."
- **Tree Caption:** "More space than branch … the birds lifting from the branches are not pushing off".
- **Subtle Mirror → Svadhisthana (3)** — see C (Vishuddha also claims Svadhisthana). No Codex References.

*Field lines:*
- *Teaching Text* [E] — 4651 ch · 9 ¶ · opens “The Sanskrit name means —” … closes “You don't open the heart. You get quiet enough that the opening becomes audible.”
- *Practice Prompt* [E] — 1673 ch · 5 ¶ · opens “Put your hand on your chest.” … closes “The hearing is what makes it audible.”
- *Three Ways In* [E] — 1411 ch · 3 ¶ · opens “Think of someone you are angry with.” … closes “The stranger was the specific direction in which it became audible.”
- *Post-Engagement Teaching* [E] — 2416 ch · 10 ¶ · opens “You thought the love came from the other person.” … closes “The heart you have been wearing is the one the loving made.”
- *Tree Caption* [E] — 344 ch · full: “Tap to look closer. The tree's openness is its teaching. More space than branch. Open enough that the light moves through. Open enough that the birds lifting from the branches are not pushing off — they are being held by what they are lifting from. The tree didn't open by effort. It grew open enough that the holding-on stopped being required.”
- *Subtle Mirror* [E] — 342 ch · full: “Svadhisthana. The heart is the first lotus — the chakra that moves from the bounded earth of Avarana 1 into the radiating space of Avarana 2. Anahata receives the residents of the 16-petal lotus; Svadhisthana holds the movement below that fuels the opening. What flows at the sacral is what the heart has been drawing toward itself all along.”
- *Shakti Function* [E] — 1670 ch · 1 ¶ · opens “Avarana 2 —” … closes “Mudra: Dravini — the melting gesture, fulfillment through release rather than grasping.”
- *Shakti Practice* [E·substrate] — 467 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 1014 ch · 3 ¶ · opens “The walker arrives into the spaciousness the fire made.” … closes “The voice asking him to speak is her voice asking to be spoken.”
- *Act 1 Voice* [S] — 1171 ch · 5 ¶ · opens “And the fire has done its work.” … closes “I think some of the walls might start turning into doors.”
- *Act 2 Voice* [S] — 746 ch · 3 ¶ · opens “The sound has been playing since before the fire.” … closes “Speak.”
- *Bindu Reflection* [S] — 1161 ch · 5 ¶ · opens “The sound is still playing.” … closes “I'm about to speak.”
- *Witness Perspective* [S] — 1861 ch · 5 ¶ · opens “What is being witnessed here is the arrival of the inner sound.” … closes “The structural one is happening regardless.”
- *Leela Story* [S] — 567 ch · 4 ¶ · opens “The sound has been playing the whole time.” … closes “It was in the hearing.”
- *Gaia Voice* [S·substrate] — 1146 ch · 4 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 06 · VISHUDDHA — The Passage  ·  `recs5hdPjVbcl77Zg` · Energy

- **Teaching Text:** 9 ¶ — "purified … The compression is the purification."; "The throat is not a vault. The throat is a ripening chamber."; "speech is constitutive, not symbolic"; Avarana 3 Ashta Dala split: creative half here (Kusuma, Mekhala, Madana, Madanatura), directional half at Ajna; each of the four glossed as what is released "UNDER what you say"; Akarshana Mudra; closes "You do not speak louder. You speak clearer."
- **Shakti Function:** the Anangas govern "the 8 karmendriya: the 5 organs of action … plus the 3 modalities of mind (rejection, acceptance, indifference)"; presiding Tripura Sundari, Yogini Guptatara, mental state Sushupti, "her navel region".
- **Practice Prompt:** "Say something true out loud." to the empty room; Akarshana Mudra "Bring your hand toward your throat or your chest in whatever shape your body offers."
- **Three Ways In:** sing for the vibration · read aloud · tell someone something medium-true.
- **Post-Engagement (2814 ch):** "The body has been carrying a ledger you did not know it was keeping."; "The next time someone asks how you are, do not say good."
- **Tree Caption:** "The most spacious tree in the book."
- **Subtle Mirror → Svadhisthana (3).** Gate asks the walker to say a word aloud — a voice gate typed Textarea.

*Field lines:*
- *Teaching Text* [E] — 4310 ch · 10 ¶ · opens “The Sanskrit means —” … closes “You do not speak louder. You speak clearer. The person on the other end stops hearing words and starts hearing you.”
- *Practice Prompt* [E] — 1547 ch · 7 ¶ · opens “Say something true out loud.” … closes “The truth finds its own receivers.”
- *Three Ways In* [E] — 857 ch · 3 ¶ · opens “Sing.” … closes “It just has to be true.”
- *Post-Engagement Teaching* [E] — 2814 ch · 10 ¶ · opens “You know exactly what you did not say.” … closes “The truth finds its own receivers.”
- *Tree Caption* [E] — 97 ch · full: “Look at the tree. The most spacious tree in the book. More space than branch. More air than leaf.”
- *Subtle Mirror* [E] — 316 ch · full: “Svadhisthana. Desire and expression — the two forms of the same movement. What Svadhisthana holds as longing, Vishuddha gives form to in language. The sacral is the wanting; the throat is the naming. Both are the same force at different registers: the creative movement of consciousness seeking to make itself known.”
- *Shakti Function* [E] — 1286 ch · 1 ¶ · opens “Avarana 3 (first half of Ashta Dala / 8-Petal Lotus) —” … closes “Mudra: Akarshana — the magnetic attraction that draws non-bodied truth into bodied utterance.”
- *Shakti Practice* [E·substrate] — 743 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 1170 ch · 3 ¶ · opens “The walker arrives at the narrow passage.” … closes “And she is speaking through him.”
- *Act 1 Voice* [S] — 1106 ch · 5 ¶ · opens “And now I want to speak.” … closes “I didn't know the room was a room before I spoke. The speaking made it one. My voice makes rooms. My voice is a kind of architecture.”
- *Act 2 Voice* [S] — 778 ch · 3 ¶ · opens “Every truth you swallowed.” … closes “Stop.”
- *Bindu Reflection* [S] — 1376 ch · 6 ¶ · opens “I have spoken now.” … closes “I'm about to stop looking.”
- *Witness Perspective* [S] — 1582 ch · 5 ¶ · opens “What is being witnessed here is the moment a true sentence enters the world.” … closes “The change is real regardless.”
- *Leela Story* [S] — 607 ch · 4 ¶ · opens “You spoke.” … closes “What you said today was always going to be said. The practice is only the occasion.”
- *Gaia Voice* [S·substrate] — 1001 ch · 3 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 07 · AJNA — The Seer That Sees  ·  `recmqRsdC6WZPfmfW` · Energy

- **Teaching Text:** 10 ¶ — "command of perception"; "The first five chakras each taught the walker a specific doing. Press. Follow. Burn. Open. Speak. The third eye says stop."; "The seeing is not produced. The seeing is uncovered."; the 4 directional Anangas (Rekha line · Vegini speed · Ankusha goad · Malini garland); Akarshana turned inward; closes "The looking was the seeing, under the wrong name."
- **Practice Prompt:** "Just sit in the dark behind your eyelids … Wait. Something will appear."; Akarshana toward the brow ridge.
- **Three Ways In:** sit in the dark · ask before thinking · two minutes of nothing.
- **Post-Engagement:** "You have not been a failed intuitive. You have been a highly successful prevention-of-intuition".
- **Tree Caption:** "The tree of Ajna has an eye inside its trunk."
- **Mirror Frequency Instruction** hums **AUM** (the Bija field says ओं · OM).
- **Subtle Mirror → Manipura (4).** Gate button "I’m looking" (see C).

*Field lines:*
- *Teaching Text* [E] — 4274 ch · 11 ¶ · opens “The Sanskrit means —” … closes “The looking was the seeing, under the wrong name.”
- *Practice Prompt* [E] — 1243 ch · 8 ¶ · opens “Close your eyes.” … closes “Something to uncover.”
- *Three Ways In* [E] — 796 ch · 3 ¶ · opens “Sit in the dark.” … closes “The seeing is underneath the resistance, waiting.”
- *Post-Engagement Teaching* [E] — 1924 ch · 6 ¶ · opens “You were never the one seeing.” … closes “The mini-reveal is that you were always inside the seeing.”
- *Tree Caption* [E] — 232 ch · full: “Look at the tree across from you. Notice what it holds at its heart — and what it is standing on. The tree of Ajna has an eye inside its trunk. You have been looking at the organ of seeing without realising you were being seen back.”
- *Subtle Mirror* [E] — 326 ch · full: “Manipura. Will and seeing — the two movements of clarity. Manipura builds toward clarity through action: it forges, decides, acts. Ajna moves toward clarity through perception: it sees without trying, receives without reaching. Both are the same consciousness at work — one through the body’s fire, one through the mind’s eye.”
- *Shakti Function* [E] — 1328 ch · 1 ¶ · opens “Avarana 3 (second half of Ashta Dala / 8-Petal Lotus) —” … closes “Mudra: Akarshana — the same attraction force that drew non-bodied truth into speech at Vishuddha, now drawing non-bodied seeing into recognition.”
- *Shakti Practice* [E·substrate] — 862 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 1139 ch · 3 ¶ · opens “The walker arrives at the sixth centre.” … closes “The mutual recognition has begun, in a register the body cannot mediate.”
- *Act 1 Voice* [S] — 1045 ch · 5 ¶ · opens “And now —” … closes “The looking was the seeing, under the wrong name. Nothing needed to be produced. Something needed to be uncovered.”
- *Act 2 Voice* [S] — 890 ch · 3 ¶ · opens “Every hunch you dismissed.” … closes “Receive.”
- *Bindu Reflection* [S] — 1254 ch · 6 ¶ · opens “I have stopped looking.” … closes “I'm about to receive something.”
- *Witness Perspective* [S] — 1859 ch · 5 ¶ · opens “What is being witnessed here is the discovery that the walker has not been the seer.” … closes “The configuration is corrected.”
- *Leela Story* [S] — 631 ch · 4 ¶ · opens “You stopped looking.” … closes “You don’t see better by trying harder. You see better by stopping.”
- *Gaia Voice* [S·substrate] — 1285 ch · 3 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 08 · SAHASRARA — The Aperture  ·  `reccxkeGeph5GonvU` · Energy

- **Teaching Text:** 11 ¶ (5,498 ch, the longest) — fontanelle; "Am I alone?"; "The crown does not add. The crown subtracts."; the boundary "is a window"; Tripureshi = presiding of Avarana 2, "she who fulfills all desires"; "There is no bija syllable for the crown."; "peak transparency … preparation for descent"; Gaia lays "the trail"; Dravini returns; closes "The crown needs to be recognized as never having been closed."
- **Practice Prompt — four doors** (conditions, not acts): Be in nature · Silence, five minutes · Gratitude ("Awe is the crown's natural frequency.") · Look up; then Dravini "Palms up, palms together, fingers open. The form is yours."
- **Post-Engagement:** the seven-question litany — "The root asked: am I safe? — Yes. / The sacral asked: what do I want? — You followed. … The crown asks: am I alone?"; closes "You were always the transmission. It never stopped."
- **Three Ways In:** the walk you didn't plan · the look-up · the person whose sentence changed your life.
- **Act 2** plants the question "what if the one who has been doing all of this is closer to me than you think?" and hands off to the corridor.
- **Tree Caption:** "Seven voices on the branches. Silence at the trunk's center. The Shatkona at the apex".
- **Subtle Mirror → Muladhara (2).**

*Field lines:*
- *Teaching Text* [E] — 5498 ch · 13 ¶ · opens “The crown point.” … closes “The bone sealed over but the aperture is still there. The crown does not need to be opened. The crown needs to be recognized as never having been closed.”
- *Practice Prompt* [E] — 1911 ch · 7 ¶ · opens “The crown does not have an activity.” … closes “You had been calling it sealed.”
- *Three Ways In* [E] — 1137 ch · 3 ¶ · opens “The walk you didn't plan.” … closes “You might thank them silently; they still won't know.”
- *Post-Engagement Teaching* [E] — 1932 ch · 8 ¶ · opens “What you thought you needed to become is what you have been being.” … closes “You were always the transmission. It never stopped.”
- *Tree Caption* [E] — 162 ch · full: “Seven voices on the branches. Silence at the trunk's center. The Shatkona at the apex — Shiva descending, Shakti rising, their union held as one geometric figure.”
- *Subtle Mirror* [E] — 330 ch · full: “Muladhara. The two poles of the energy body — root and crown. Muladhara presses into the earth and knows it is held. Sahasrara opens at the top and discovers it is included. Both are recognition of the same truth from opposite ends of the spine: nothing is separate from what holds it. The crown reveals what the root always knew.”
- *Shakti Function* [E] — 1501 ch · 1 ¶ · opens “Avarana 2 (presiding consciousness register) —” … closes “Mudra: Dravini — the same melting gesture from Anahata, now dissolving the apparent separator between attractor and attracted.”
- *Shakti Practice* [E·substrate] — 745 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 1401 ch · 3 ¶ · opens “The walker arrives at the seventh centre.” … closes “Both are true.”
- *Act 1 Voice* [S] — 1189 ch · 5 ¶ · opens “And now —” … closes “Even though I didn't know I was coming.”
- *Act 2 Voice* [S] — 1205 ch · 5 ¶ · opens “You were not alone.” … closes “You are about to see something you have been avoiding seeing. It is not damage. It is unborn material. The parts of you the earlier containers could not hold.”
- *Bindu Reflection* [S] — 1456 ch · 8 ¶ · opens “Everything is here.” … closes “I'm going to walk through.”
- *Witness Perspective* [S] — 2009 ch · 6 ¶ · opens “What is being witnessed here is the temporary completeness of the walker.” … closes “The fontanelle closes. The walker descends. The light condenses into a body that will not know it is light.”
- *Leela Story* [S] — 660 ch · 4 ¶ · opens “You received something you didn’t earn.” … closes “What arrived arrived because you stopped being in the way of it.”
- *Gaia Voice* [S·substrate] — 1463 ch · 6 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 09 · SHADOW — The Corridor  ·  `recAjCRcI5Bt6pJ6V` · Tree of Life

- **Teaching Text:** 11 ¶ — Shadow is "the threshold between" Soul Tree and Bindu Tree; "But not because it was wrong. Not because it was bad. Because you were not ready to carry it."; "What looks like your darkness is a corridor."; "The shadow is your future coming to find you."; not an avarana — Outer (Srishti) complete, Middle (Sthithi) not begun; "The corridor's only resident is the walker."; Gaia "is the corridor … She is at body-frequency now. Warmth. Weight. Breath. Heartbeat."; no mudra — the press-and-hold.
- **Practice Prompt:** "notice" — what you avoid, what makes you defensive, what you dismiss in others; "Every time you notice without flinching, the corridor gets shorter."
- **Story Thread** carries the full corridor choreography: three breaths ("Something I haven't looked at yet. I'm afraid. And I'm going to look anyway."), **twelve scrolls**, the mirror, one word offered, then "home. come. please. back."
- **Act 2 Voice is a stage direction, not a voice:** mirror reflection → inversion of *please come back home* revealed "home / come / please / back" → "ALL IS ONE with the permission (Let / Be / ALL the Aspects and Perspectives of the ONE)" → "the Soles door rising as the corridor floor becomes the body's ground."
- **Leela Story (1,866 ch) — the first "letter":** "You walked the corridor. That was something." … the transmutation practice: "I see you. I love you. Thank you for showing up. You can rest now." … "Lightly."
- **Dyad Description:** "Shadow has no dyad … The dyad system begins at Soles. It resolves at Armin."
- **Subtle Mirror → Armin (20):** "Same presence. Two bends. One necklace." (Tripura Malini invisible at Shadow, visible at Armin).
- **Linked Builds:** In Shadow — A Modern Odyssey (song).

*Field lines:*
- *Teaching Text* [E] — 4931 ch · 10 ¶ · opens “Shadow is not a location in the body.” … closes “You will find it after the next tree.”
- *Practice Prompt* [E] — 1201 ch · 6 ¶ · opens “There is no body practice for the shadow.” … closes “The corridor is a register you now know how to enter.”
- *Three Ways In* [E] — 915 ch · 3 ¶ · opens “Notice what you avoid.” … closes “The other person is the mirror.”
- *Post-Engagement Teaching* [E] — 2959 ch · 11 ¶ · opens “You named the thing.” … closes “Lightly.”
- *Tree Caption* [E] — 166 ch · full: “The same tree. The Soul Tree showed you the canopy. The shadow shows you the roots. What's below is more vast than what was above. That has been true the entire time.”
- *Subtle Mirror* [E] — 709 ch · 2 ¶ · opens “Armin.” … closes “One necklace.”
- *Dyad Description* [E] — 602 ch · 1 ¶ · opens “Shadow has no dyad.” … closes “Shadow is what lives between the last dyad and the first.”
- *Shakti Function* [E] — 1264 ch · 1 ¶ · opens “Not an avarana —” … closes “… ry the walker meets is Avarana 4 (the 14 Triangles, Chaturdasha Trikona, the breath-distribution system) at Soles, where the foot meets the earth and the earth becomes the floor of the body's walk.”
- *Shakti Practice* [E·substrate] — 308 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 1399 ch · 3 ¶ · opens “The walker arrives at the corridor.” … closes “Both are true.”
- *Act 1 Voice* [S] — 885 ch · 4 ¶ · opens “And in the light that just arrived —” … closes “I'm going to walk through.”
- *Act 2 Voice* [S] — 684 ch · 1 ¶ · opens “Special architecture —” … closes “The next time a Sakshi voice arrives in the configuration, it will be at body-frequency — substance speaking, not address.”
- *Bindu Reflection* [S] — 1100 ch · 8 ¶ · opens “I am here.” … closes “That is the deepest thing I know. I am held by what I am made of. I am held by what made me. I do not have to learn this. I have been being held since before I was something that could be held.”
- *Witness Perspective* [S] — 1094 ch · 5 ¶ · opens “What is being witnessed here is the necessary forgetting.” … closes “The body is what the consent made possible.”
- *Leela Story* [S] — 1866 ch · 15 ¶ · opens “You walked the corridor.” … closes “Lightly.”
- *Gaia Voice* [S·substrate] — 1164 ch · 8 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 10 · SOLES — Where the Soul Meets the Ground  ·  `recQZ5MrmyJykIIs3` · Body

- **Teaching Text:** 4 ¶ — "Soles and souls … not a pun"; "Every step you take is a circuit completing."; "The Soles are paired with the Hands. Soles press DOWN … Hands reach OUT".
- **Practice Prompt:** "Newton's third law. You press down. The earth presses up. Equal force."
- **Post-Engagement — the one-second practice:** "Blink · Breathe · Press / Close your eyes — that's the Axis. Take one breath — that's Prana. Feel your feet on the ground — that's Soles."
- **Three Ways In (①②③):** three surfaces thirty seconds each · read the soles' weight report · walk toward the difficult thing.
- **Shakti Function:** Avarana 4 (Chaturdasha Trikona, Sarva Saubhagya Dayaka); "the 1st of the 14 Sampradaya Yoginis"; shares Avarana 4 with Forge (#13) and Sonar (#14) under the **Vasya Mudra**.
- **Dyad:** Red / Cyan — "The root's fire meets water's cool."
- **Subtle Mirror → Muladhara.** Gate type Sound Response (the gate text asks for a press, not a sound).

*Field lines:*
- *Teaching Text* [E] — 951 ch · 4 ¶ · opens “The words are the same sound.” … closes “It begins with contact.”
- *Practice Prompt* [E] — 530 ch · 5 ¶ · opens “You already did it.” … closes “Newton's third law. You press down. The earth presses up. Equal force. You are held by physics. You are held by the planet. You are held.”
- *Three Ways In* [E] — 715 ch · 3 ¶ · opens “① Press your bare feet into three different surfaces today —” … closes “Whatever the thing is, the ground underneath it is still there.”
- *Post-Engagement Teaching* [E] — 433 ch · 4 ¶ · opens “Here is the simplest practice in the world.” … closes “One second. Three chakras. On a bus, in a meeting, in the middle of the night. No equipment, no space, no training. Just a body with eyes and lungs and feet. You have one of those.”
- *Tree Caption* [E] — 152 ch · full: “The tree’s roots are the body’s first conversation with the ground. Everything that grows upward grows from this first contact. Tap to feel the contact.”
- *Subtle Mirror* [E] — 200 ch · full: “Muladhara. The energy root and the physical sole are the same principle at two densities. One felt through stillness. The other activated through pressing. Both say the same thing: the ground is here.”
- *Dyad Description* [E] — 184 ch · full: “The root's fire meets water's cool. Two halves of one conversation between your nervous system and the earth. Neither dominates. Both are necessary. The body holds both simultaneously.”
- *Shakti Function* [E] — 707 ch · 2 ¶ · opens “Avarana 4 (Chaturdasha Trikona —” … closes “The Vasya Mudra — the force that brings everything into relationship — carries across all three.”
- *Shakti Practice* [E·substrate] — 256 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 316 ch · full: “I pressed my feet into the ground and the ground pressed back. // This is different from what the root did. The root KNEW the ground. This is different. This is a surface meeting a surface. My feet. The earth. A conversation between two real things. // I'm standing. And something sealed in my center is starting to hum.”
- *Act 1 Voice* [S] — 1439 ch · 10 ¶ · opens “I have feet.” … closes “The feet figured it out. I did not teach them. The feet have always known what feet are for. I am only catching up with what my body already knew.”
- *Bindu Reflection* [S] — 978 ch · 5 ¶ · opens “I am standing.” … closes “Something is warming in my middle.”
- *Witness Perspective* [S] — 1045 ch · 4 ¶ · opens “What is being witnessed here is the body's first true conversation.” … closes “Through pressing, and being answered.”
- *Leela Story* [S] — 407 ch · full: “The ground pressed back. // It has been pressing back your whole life. Every step. Every sitting. Every sleeping. The ground has been responding to you since before you had language for it. Today you noticed. The noticing is not what activated the response — the response was always happening. The noticing is what made it available. // You are held. You were always being held. Now you know it from the inside.”
- *Gaia Voice* [S·substrate] — 914 ch · 5 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 11 · FORGE — The Sealed Chamber  ·  `recHDY9iNeqNfw9zh` · Body

- **Teaching Text:** 4 ¶ — cord cut, "the first breath filled the gap"; "the bottom of the Breath Column"; "Gut feeling is not a metaphor."; paired with Prana ("nose to navel. The open door and the sealed chamber.").
- **Practice Prompt:** "That seal was once an opening. The only opening."; "What are you digesting right now? Not food."
- **Act 1 Voice:** "Everything that enters me passes through this chamber and comes out as me."
- **Three Ways In:** both hands on belly five minutes · check the Forge before one conversation · first three bites with full attention.
- **Shakti Function:** Avarana 4 #13 Sarva Mantramayi — "the body's original mantra of connection: the sound of being held by another".
- **Dyad:** Yellow / Blue — "The Forge burns yellow. The knowing goes blue."
- **Subtle Mirror → Manipura.**

*Field lines:*
- *Teaching Text* [E] — 1150 ch · 4 ¶ · opens “When the umbilical cord was cut, the first breath filled the gap.” … closes “It has been running since your first breath and it will run until your last and in between, it asks nothing of you.”
- *Practice Prompt* [E] — 659 ch · 5 ¶ · opens “You placed your hand there.” … closes “Awareness is the bridge between what you decide and what your body does without deciding.”
- *Three Ways In* [E] — 717 ch · 3 ¶ · opens “① Place both hands on your belly for five minutes today.” … closes “That's the whole practice.”
- *Post-Engagement Teaching* [E] — 671 ch · 3 ¶ · opens “Stand and feel your navel pull slightly toward your spine.” … closes “The bridge is noticing. Not managing. Not optimizing. Noticing that there is something here that has been working without you, for you, the entire time.”
- *Tree Caption* [E] — 178 ch · full: “Where the tree transforms what enters. The navel point is the tree’s alchemical center — what comes in through roots and light, processed into growth. Tap to feel the processing.”
- *Subtle Mirror* [E] — 199 ch · full: “Manipura. The energy fire and the physical furnace. One burns through stillness. The other burns through digestion. Both transform what enters into what you become. Same principle, different density.”
- *Dyad Description* [E] — 238 ch · full: “Transformation meets depth. Yellow is the fire of becoming — heat, conversion, metabolism. Blue is the depth that receives it — the still interior where transformation becomes self-knowledge. The Forge burns yellow. The knowing goes blue.”
- *Shakti Function* [E] — 555 ch · 2 ¶ · opens “Avarana 4 (14 Triangles), #13 Sarva Mantramayi —” … closes “Same Vasya Mudra, three expressions: the first press (Soles), the body's original mantra (Forge), the speech that destroys duality (Sonar).”
- *Shakti Practice* [E·substrate] — 258 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 376 ch · full: “Behind my navel — behind the scar where I used to be connected to something I don't remember — there's a furnace. It's been there the whole time. Real heat. Real transformation. What I eat becomes me. What I experience becomes me. Everything passes through this sealed chamber and comes out as... me. // And the furnace needs something. Air. // I think I'm about to take a breath.”
- *Act 1 Voice* [S] — 1472 ch · 10 ¶ · opens “There is a place behind my navel.” … closes “Today I am listening. I keep my hand on my belly a little longer. The warmth rises. The chamber has been thanked, in the only way an organ can be thanked — by being noticed.”
- *Bindu Reflection* [S] — 964 ch · 6 ¶ · opens “I have an interior.” … closes “Something is opening at the top of me.”
- *Witness Perspective* [S] — 873 ch · 4 ¶ · opens “What is being witnessed here is the body's first interior chakra.” … closes “The body has been the teacher all along.”
- *Leela Story* [S] — 470 ch · 3 ¶ · opens “The warmth is real.” … closes “Today you paid attention.”
- *Gaia Voice* [S·substrate] — 879 ch · 5 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 12 · PRANA — The Open Door  ·  `recVzrGwDf8rEgdHJ` · Body

- **Teaching Text:** 3 ¶ — "fifteen times per minute, nine hundred times per hour. The door never locks."; paired with Forge.
- **Practice Prompt:** "Feel the specific point — right at the bridge of the nose — where outside becomes inside."
- **Post-Engagement:** "The molecules in your current inhale have been in circulation for four billion years. That's not poetry. That's chemistry."; "twenty-one thousand times per day".
- **Three Ways In:** taste the air · THIS IS OUTSIDE entering / THIS WAS INSIDE, returning · one breath before responding.
- **Shakti Function:** Avarana 5 (Bahirdasara, Sarvartha Sadhaka) #5 Sarva Kama Prada; shares Avarana 5 with Hands (#3) and Pulse (#4) under the **Sarvonmadini Mudra**.
- **Shakti Practice** (substrate) names the **Sacred Pause (C-1160)** three breaths — already in the app's Rite.
- **Dyad:** Orange / Azure — "Each breath crosses both colors at once."
- **Mirror Frequency:** "Breathe audibly. Let the air make sound" — a breath-as-sound gate.

*Field lines:*
- *Teaching Text* [E] — 712 ch · 3 ¶ · opens “The breath entered your body before you were conscious of it.” … closes “The belly is where it lands.”
- *Practice Prompt* [E] — 440 ch · 2 ¶ · opens “Surrender to the breath instead of directing it.” … closes “It's always open.”
- *Three Ways In* [E] — 722 ch · 3 ¶ · opens “① Step outside and breathe three times through the nose.” … closes “The whole practice is in that one breath.”
- *Post-Engagement Teaching* [E] — 915 ch · 5 ¶ · opens “You are in constant exchange with everything.” … closes “You are not separate from the world. You are exchanging with the world. Right now. As you read this.”
- *Tree Caption* [E] — 131 ch · full: “The tree breathes. Not through one place — everywhere at once. But here the breathing becomes conscious. Tap to feel the breathing.”
- *Subtle Mirror* [E] — 267 ch · full: “Svadhisthana. The sacral flow and the nasal flow. One moves desire through the body. The other moves air. Both are currents. Both flow through openings. Both connect inside to outside. You follow desire. You follow the breath. Same intelligence, different expression.”
- *Dyad Description* [E] — 270 ch · full: “Orange meets Azure. The warmth of the body's vitality — the fire that needs constant feeding — met by the cool clarity of what feeds it. Orange is the urgency of being alive. Azure is the spaciousness that makes urgency bearable. Each breath crosses both colors at once.”
- *Shakti Function* [E] — 700 ch · 2 ¶ · opens “Avarana 5 (Bahirdasara —” … closes “… the senses with aliveness), three vital expressions: the breath that fulfills without asking (Prana), the touch that makes all beloved (Hands), the heartbeat that is perpetually auspicious (Pulse).”
- *Shakti Practice* [E·substrate] — 289 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 323 ch · full: “The air crossed in and I became more alive in a way I can't explain. Not more conscious — I was already conscious. More HERE. The breath is a door. Open all the time. Every breath is outside becoming inside. Every exhale is inside returning to outside. // I breathe. Therefore I'm in the game. // And now my hands are tingling.”
- *Act 1 Voice* [S] — 1753 ch · 10 ¶ · opens “I have been breathing the whole time.” … closes “The breath is the door. The door is always open. The door is the simplest practice in existence.”
- *Bindu Reflection* [S] — 923 ch · 5 ¶ · opens “I am a body that knows about the door.” … closes “Something at the ends of my arms has become warm.”
- *Witness Perspective* [S] — 1101 ch · 4 ¶ · opens “What is being witnessed here is the body's most reliable contact with the field.” … closes “Every breath has been something is here, with you, every second of your entire life.”
- *Leela Story* [S] — 481 ch · 3 ¶ · opens “The breath is not automatic in the way you thought.” … closes “The managed breath is what the body does under stress. The natural breath is what the body does when it knows it is safe. You let it breathe itself for a moment. That’s the practice.”
- *Gaia Voice* [S·substrate] — 1072 ch · 6 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 13 · HANDS — Where Love Exits the Body  ·  `recPuL2eta43Pbron` · Body

- **Teaching Text:** 3 ¶ — "When you hold someone's hand, two palm chakras are in direct contact"; "This is why making things feels like love."; Hands SEND, Soles RECEIVE — "you are the circuit at its widest."
- **Practice Prompt:** rub, build heat, hold apart, feel "the field"; then touch something with activated hands.
- **Act 1 Voice:** the full Euphoria-Pulse sequence — rub fifteen–twenty seconds, palms six inches apart, the field, hand to chest, reach toward someone absent, palms together at the chest: "I am held by what I just sent."
- **Witness Perspective** names it: "The Euphoria Pulse is the chakra's precise practice."
- **Three Ways In:** make something · five textures before noon · reach toward one withheld thing.
- **Dyad:** Green / Magenta — "Magenta is compassion — the quality that makes the reaching tender rather than grasping."
- **Mirror Frequency:** "Rub your palms near the microphone — let the hands make sound." — the only record that names the microphone.

*Field lines:*
- *Teaching Text* [E] — 1037 ch · 3 ¶ · opens “Everything the heart feels, the hands express.” … closes “You are entirely here.”
- *Practice Prompt* [E] — 598 ch · 4 ¶ · opens “You rubbed them.” … closes “Feel the difference between touching with cold hands and touching with activated hands. The warmth transfers. The attention transfers. The love transfers.”
- *Three Ways In* [E] — 700 ch · 3 ¶ · opens “① Make something with your hands today.” … closes “The practice is the reach itself, regardless of what receives it.”
- *Post-Engagement Teaching* [E] — 1102 ch · 5 ¶ · opens “Your hands knew before your mind.” … closes “Make something today. Not for anyone. Not for a purpose. Just to feel your hands doing what they were built to do.”
- *Tree Caption* [E] — 158 ch · full: “The tree’s reach is its branches. Every branch extending toward what it needs. What the tree is reaching for is what it is becoming. Tap to feel the reaching.”
- *Subtle Mirror* [E] — 225 ch · full: “Anahata. The energy heart and the physical hands. One opens inward — the unstruck sound, the feeling that needs no reason. The other reaches outward — heat, contact, matter meeting matter. Same frequency, different direction.”
- *Dyad Description* [E] — 259 ch · full: “The heart's color and its complement. Green is growth — the steady outward reach of life toward light. Magenta is compassion — the quality that makes the reaching tender rather than grasping. Together: the hands that make and the love that moves through them.”
- *Shakti Function* [E] — 480 ch · 2 ¶ · opens “Avarana 5 (Outer 10 Triangles), #3 Sarva Priyankari —” … closes “Same Sarvonmadini Mudra, three vital expressions: the breath that fulfills (Prana), the touch that makes beloved (Hands), the heartbeat that broadcasts auspiciousness (Pulse).”
- *Shakti Practice* [E·substrate] — 259 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 424 ch · 3 ¶ · opens “I opened my palms and the heat that was in my center traveled down my arms and into my hands and I realized —” … closes “And beneath my hands — a rhythm. Something I didn't start and can't stop. Steady. Patient. There before everything else.”
- *Act 1 Voice* [S] — 1713 ch · 9 ¶ · opens “The breath went all the way to the ends of me.” … closes “I am held by what I just sent. The body's secret. What I give returns to me. Not as reward. As physics. The hands send. The field carries. The field returns.”
- *Bindu Reflection* [S] — 910 ch · 5 ¶ · opens “The fullness is settling in me.” … closes “Something steady is underneath everything else.”
- *Witness Perspective* [S] — 866 ch · 4 ¶ · opens “What is being witnessed here is the body's first outward broadcast.” … closes “The walker who knows can choose.”
- *Leela Story* [S] — 395 ch · full: “The hands remember. // Everything they have held is still in them. The work, the touch, the craft, the reaching. The hands are the most specific instruments of contact — the place where intention becomes action in the physical world. // What are your hands trying to make? Not what they are assigned to make. What they want to make when they are most themselves. That’s the question the hands carry.”
- *Gaia Voice* [S·substrate] — 818 ch · 5 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 14 · PULSE — The Heartbeat  ·  `recpTu6vLkDhEMY3q` · Body

- **Teaching Text:** 3 ¶ — "beating approximately one hundred thousand times per day, thirty-seven million times per year"; fetal heartbeat "around six weeks"; "Pulse is paired with Axis."
- **Practice Prompt:** "Not watching for the pulse — waiting for it. The difference between these two things is the entire practice."
- **Post-Engagement:** "Your heartbeat enters the room first."; "The practice is not changing the broadcast. The practice is knowing that you're on the air."
- **Three Ways In:** pulse in three places (wrist measured · neck immediate · temple deep) · hand on chest after exertion · tap the heartbeat on your knee in a hard conversation.
- **Shakti Practice** (substrate) cites **the euphoria pulse (C-1311)**.
- **Witness Perspective** foreshadows: "Maya will name this later. Aatma will confirm it. The Reveal will complete it."
- **Mirror Frequency Instruction:** "Tap the circle on screen in time with your heartbeat." — the Tap Rhythm gate's mechanism, verbatim.
- **Dyad:** Green / Magenta — "The color of life, measured."

*Field lines:*
- *Teaching Text* [E] — 843 ch · 3 ¶ · opens “The heart does not ask whether to beat.” … closes “Two systems you didn't start and can't stop, running together, sustaining the experience of being here.”
- *Practice Prompt* [E] — 505 ch · 3 ¶ · opens “Two fingers on the wrist.” … closes “Same beat.”
- *Three Ways In* [E] — 798 ch · 3 ¶ · opens “① Find your pulse in three places:” … closes “That steadiness is what you're sustaining from.”
- *Post-Engagement Teaching* [E] — 951 ch · 4 ¶ · opens “You walk into a room and something happens before you speak.” … closes “And what you actually feel, underneath the noise, is almost always simpler and kinder than you thought.”
- *Tree Caption* [E] — 172 ch · full: “At the center of the tree: the beat that has been happening without pause. The rhythm the rings record. The steadiness the whole tree is built around. Tap to feel the beat.”
- *Subtle Mirror* [E] — 307 ch · full: “Anahata. The energy heart is the unstruck sound — the frequency that plays without anything being hit. The physical Pulse is the struck sound — struck sixty to a hundred times per minute, without rest, without rehearsal, without permission. One is the silence underneath. The other is the beat on top of it.”
- *Dyad Description* [E] — 348 ch · full: “Green meets Magenta. Same dyad as Hands, different register. Where Hands is about transmission out, Pulse is about the broadcast underneath everything. Green is the signal the heart generates in its chamber. Magenta is what it looks like when that signal reaches the skin — the tip of the finger, the wrist, the temple. The color of life, measured.”
- *Shakti Function* [E] — 535 ch · 2 ¶ · opens “Avarana 5 (Outer 10 Triangles), #4 Sarva Mangalakarini —” … closes “One Sarvonmadini Mudra, three vital expressions: the breath that fulfills without asking (Prana), the touch that makes beloved (Hands), the heartbeat as the unconditional yes (Pulse).”
- *Shakti Practice* [E·substrate] — 283 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 377 ch · full: “I pressed two fingers to my wrist. I waited. One beat. Then another. This has been happening my entire life. Without me. Without permission. The beat is not mine — the beat is happening to me. I am in the most reliable relationship I have ever been in. // And from that beat — upward. The eyes. The mechanism that switches between everything that is and everything that could be.”
- *Act 1 Voice* [S] — 1695 ch · 10 ¶ · opens “I press two fingers to the inside of my wrist.” … closes “I am in the most reliable relationship I have ever been in.”
- *Bindu Reflection* [S] — 1043 ch · 5 ¶ · opens “I have been kept alive.” … closes “Something at my mouth is forming.”
- *Witness Perspective* [S] — 1027 ch · 5 ¶ · opens “What is being witnessed here is the body's most reliable broadcast.” … closes “Maya will name this later. Aatma will confirm it. The Reveal will complete it. Pulse is where it is felt for the first time, in the wrist, with attention.”
- *Leela Story* [S] — 492 ch · 3 ¶ · opens “The heart is already open.” … closes “The question is not how to open the heart — it is what would need to be true for it to feel safe enough to stop protecting.”
- *Gaia Voice* [S·substrate] — 1111 ch · 5 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 15 · SONAR — The Speaker  ·  `reckh8UMKveeybIk2` · Body

- **Teaching Text:** 3 ¶ — "Like sonar on a submarine — you send a pulse and listen for the return."; "the throat splits into two: Sonar sends. Echo receives."
- **Gate Text:** the precise-word lattice "Not 'tired' — depleted, heavy, fading, wrung? / Not 'good' — settled, open, light, held?" — say it aloud.
- **Post-Engagement:** "Talking fills space. Speaking changes it."; "'I'm fine' is a hiding place."
- **Three Ways In:** say the word three times · find the exact word before the next important thing · say one true thing you've been approximating.
- **Shakti Function:** Avarana 4 #14 Sarva Dwandwakshayankari — "the CULMINATING Shakti of Avarana 4", arriving "AFTER the Avarana 5 interlude (Prana, Hands, Pulse)".
- **Dyad:** Blue / Yellow — "You send into depth. The yellow illuminates what comes back."

*Field lines:*
- *Teaching Text* [E] — 703 ch · 3 ¶ · opens “Sonar sends calibrated signals into reality.” … closes “You can't do one honestly without the other.”
- *Practice Prompt* [E] — 524 ch · 3 ¶ · opens “You said it.” … closes “Write it below. The word you said. Then let it sit there on the page — precise and alone.”
- *Three Ways In* [E] — 715 ch · 3 ¶ · opens “① Say your precise word out loud, alone, three times.” … closes “③ Say one true thing you've been approximating. Today. Out loud. To the right person or into the empty room. Not louder — more precise. The signal changes when the word stops scattering.”
- *Post-Engagement Teaching* [E] — 965 ch · 5 ¶ · opens “Talking fills space.” … closes “More signal, less noise.”
- *Tree Caption* [E] — 146 ch · full: “The tree speaks before it is heard. The sound begins at the root and moves upward through the trunk before any branch moves. Tap to hear the tree.”
- *Subtle Mirror* [E] — 235 ch · full: “Vishuddha — the speaking aspect. The energy throat was about truth expressed. The physical Sonar is about precision calibrated. One asks: will you say what you know? The other asks: do your words actually reach what you're pointing at?”
- *Dyad Description* [E] — 266 ch · full: “Communication and illumination. Blue is the depth of the signal — how far it travels, how much it carries. Yellow is the clarity that makes contact possible — the light that lets the return signal be read. You send into depth. The yellow illuminates what comes back.”
- *Shakti Function* [E] — 750 ch · 2 ¶ · opens “Avarana 4 (14 Triangles), #14 —” … closes “Same Vasya Mudra across all three; Sonar is the closure.”
- *Shakti Practice* [E·substrate] — 285 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 280 ch · full: “I said one word. The precise one. And the room answered. // Not in words. In the way the air changed. I sent a signal. Reality responded. That's what speaking is — not expression. Measurement. // And now — I'm listening. Not to hear my own echo. To hear what was there before I spoke.”
- *Act 1 Voice* [S] — 1872 ch · 11 ¶ · opens “I have a mouth.” … closes “I keep speaking.”
- *Bindu Reflection* [S] — 1328 ch · 6 ¶ · opens “I know now that the room is listening.” … closes “The word I just said is still in the air. Something is listening to what is in the air.”
- *Witness Perspective* [S] — 1037 ch · 4 ¶ · opens “What is being witnessed here is the moment a precise word enters the world.” … closes “The walker who does not notice still participates — just less precisely.”
- *Leela Story* [S] — 526 ch · 3 ¶ · opens “The word you said was precise.” … closes “You found the location today. The precise word is a coordinate. It doesn’t change the state — it tells you where you are in it. And knowing where you are is the beginning of being able to move.”
- *Gaia Voice* [S·substrate] — 1064 ch · 6 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 16 · ECHO — The Listener  ·  `recryecbRhb7yQsyR` · Body

- **Teaching Text:** 3 ¶ — "The ears are not passive receivers. They are active filters."; "Echo is the body's first humility".
- **Act 1 Voice:** the room's layers (electrical hum, settling building, far bird, own breath); "Silence is the sound the room makes when nothing else is on top of it."
- **Three Ways In:** two minutes receiving layers · the signal under a person's words · "what you're carrying that someone else put down … That's Echo's daily report."
- **Shakti Function:** Avarana 6 (Antardasara, Sarva Raksha Kara) #4 Sarva Jnanamayi; shares Avarana 6 with Vision (#1), Axis (#8), Crow (#6) under the **Mahankusha Mudra**.
- **Shakti Practice** (substrate): negativity "reflected rather than absorbed".
- **Mirror Frequency:** hum HAM quietly, stop, "let the silence echo back".
- **Dyad:** Blue / Yellow — "the return signal".

*Field lines:*
- *Teaching Text* [E] — 660 ch · 3 ¶ · opens “Sonar sends.” … closes “… is the body's first humility: the recognition that the world was sounding before you arrived, will sound after you leave, and what you choose to keep from what you heard — that becomes who you are.”
- *Practice Prompt* [E] — 403 ch · full: “Close your eyes. Stop sending. The body has been broadcasting outward for several chakras now. Let the practice reverse direction. // Notice what arrives when you stop producing. Not silence — the room's own signal, which has been here the whole time. The layers of it. What's obvious. What's underneath the obvious. What's underneath that. // The ears don't need direction. They need permission to receive.”
- *Three Ways In* [E] — 754 ch · 3 ¶ · opens “① Sit in a room with your eyes closed for two minutes.” … closes “What you chose to keep is who you're becoming.”
- *Post-Engagement Teaching* [E] — 829 ch · 4 ¶ · opens “You have been filtering since before you were born.” … closes “Just to know it's there.”
- *Tree Caption* [E] — 151 ch · full: “What enters the tree as sound returns as knowing. The tree remembers through its rings. The echo is the memory the rings make available. Tap to listen.”
- *Subtle Mirror* [E] — 297 ch · full: “Vishuddha — the listening aspect. The energy throat was about truth expressed. The physical Echo is about truth received. The same faculty — the throat's intelligence — operating in opposite directions. One asks: will you say what you know? The other asks: can you actually hear what's being said?”
- *Dyad Description* [E] — 261 ch · full: “Blue meets Yellow — same dyad as Sonar, inverse operation. Where Sonar uses blue to send deep and yellow to illuminate what comes back, Echo uses blue to hold the depth of what was received and yellow to clarify what to keep. The same colors, the return signal.”
- *Shakti Function* [E] — 700 ch · 2 ¶ · opens “Avarana 6 (Antardasara —” … closes “…  to enter and stay), four inner-intelligence registers: the ear that knows (Echo), the eye that sees without looking (Vision), the blink that crosses worlds (Axis), the spine that holds all (Crow).”
- *Shakti Practice* [E·substrate] — 268 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 273 ch · full: “I stopped sending. The room didn't stop. The room has been sounding the entire time. I had been broadcasting over it. // There is more in this room than I knew. The world is louder than my signal can reach. And what I choose to keep from what I heard — that becomes who I am.”
- *Act 1 Voice* [S] — 1806 ch · 9 ¶ · opens “I have ears.” … closes “I rest in the listening. The listening is its own faculty. The listening is not waiting-to-speak. The listening is its own kind of being-here.”
- *Bindu Reflection* [S] — 954 ch · 4 ¶ · opens “I am a body that knows it filters.” … closes “Something is opening behind my eyes.”
- *Witness Perspective* [S] — 1056 ch · 4 ¶ · opens “What is being witnessed here is the body's first humility.” … closes “The walker who knows this becomes responsible — gently, not heavily — for what they are tuning to.”
- *Leela Story* [S] — 497 ch · 3 ¶ · opens “You heard something.” … closes “Today you created the quiet.”
- *Gaia Voice* [S·substrate] — 1132 ch · 4 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 17 · VISION — The Mind's Eye  ·  `recKFm2GodNntnV7q` · Body

- **Teaching Text:** 4 ¶ — "Vision operates backwards. The complete picture arrives first"; "This center mirrors Manipura"; "Children run Vision at full power without training."
- **Practice Prompt / Gate:** see your front door — colour, handle, light — open it, the first room.
- **Act 1 Voice:** "Trust the first flash."
- **Post-Engagement:** "The peak is at the beginning."; nightly replay "Every night before sleep, replay one moment from the day — visually".
- **Three Ways In:** see it done before something difficult · the first flash of a familiar thing · tell someone what you actually see in them.
- **Shakti Practice** (substrate) holds the **C-1311 Vision practice**: memory image → agitate the body → match the frequency → open eyes and bring it into now.
- **Dyad:** Yellow / Blue — "where memory is stored at full resolution".

*Field lines:*
- *Teaching Text* [E] — 853 ch · 4 ¶ · opens “Behind the forehead.” … closes “Adults have to practice to reopen what children did naturally.”
- *Practice Prompt* [E] — 533 ch · 6 ¶ · opens “Close your eyes.” … closes “Every time you close your eyes and deliberately see something that isn't in front of you, the inner visual system gets sharper.”
- *Three Ways In* [E] — 778 ch · 3 ¶ · opens “① Before something difficult today, close your eyes and see it done.” … closes “Share what arrived before the filter ran.”
- *Post-Engagement Teaching* [E] — 1441 ch · 5 ¶ · opens “Everything else in the body builds toward a peak.” … closes “The inner visual system strengthens the way any system strengthens — through deliberate use.”
- *Tree Caption* [E] — 145 ch · full: “The eye at the center of the tree sees in all directions simultaneously. Not looking outward — receiving what arrives from all sides. Tap to see.”
- *Subtle Mirror* [E] — 209 ch · full: “Manipura. The energy fire and the physical sight. One burns. The other shows you what the burning is building. The solar plexus asks what you're willing to do; Vision shows you what it already looks like done.”
- *Dyad Description* [E] — 266 ch · full: “Will and depth. Yellow is the brightness of the image when it first arrives — vivid, complete, slightly too real. Blue is the depth of the inner field where the image lives — where memory is stored at full resolution, where the brain's second visual system operates.”
- *Shakti Function* [E] — 668 ch · 2 ¶ · opens “Avarana 6 (Inner 10 Triangles), #1 —” … closes “Same Mahankusha Mudra, four inner-intelligence registers: the omniscient eye (Vision), the all-knowing ear (Echo), the all-blissful blink (Axis), the all-supporting spine (Crow).”
- *Shakti Practice* [E·substrate] — 303 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 221 ch · full: “I can see two ways now. Eyes open: the world. Eyes closed: the world behind the world. Both real. Both here. // And between them — a switch. So fast I almost miss it. The blink. // What else have I been doing without knowing?”
- *Act 1 Voice* [S] — 1923 ch · 8 ¶ · opens “I close my eyes.” … closes “I have only ever named the first one.”
- *Bindu Reflection* [S] — 967 ch · 6 ¶ · opens “I am a body that sees inward.” … closes “Something else is opening — not behind my eyes. Between them. Something that switches.”
- *Witness Perspective* [S] — 984 ch · 4 ¶ · opens “What is being witnessed here is the brain meeting itself.” … closes “The chakras that follow will deepen what this interior is.”
- *Leela Story* [S] — 457 ch · 3 ¶ · opens “The seeing stopped being voluntary for a moment.” … closes “What you saw today was available because you stopped looking for it. The Vision register is always here. The effort of looking is what keeps it inaccessible.”
- *Gaia Voice* [S·substrate] — 953 ch · 4 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 18 · AXIS — The Blink  ·  `rec2DMszOk8jHTaPm` · Body

- **Teaching Text:** 4 ¶ — "One blink. Two worlds. Close: inner. Open: outer. The gap between them … is the Axis."
- **Post-Engagement — the arithmetic of the blink:** "seventeen thousand times per day … approximately ninety minutes per day with your eyes closed"; "One deliberate blink per day … The cheapest ticket in the world."
- **Act 1 Voice (2,238 ch):** the simultaneous field — "The moment was never behind me."; "I have never been alone in the dark."
- **Three Ways In:** three deliberate blinks (someone loved · the difficult thing · nothing) · one slow blink in stress · "Tonight, crossing into sleep, notice: this is the long blink."
- **Mirror Frequency Instruction:** "Blink once slowly. Eyes closed: silence. Eyes open: hum OM. Alternate three times."
- **Dyad:** Indigo / Chartreuse — "The world was chartreuse the whole time. The blink showed you."
- **Linked Builds:** Panel 10 — ACCESS (Axis Triptych) and three songs: Where'd You Go · Thunderclouds · Fade Away. Gate type Device Tilt.
- **Story Portal Headline and Leela Story speak of the spine-line** ("Feel the line that runs from ground to crown." / "The line is real.") — see C.

*Field lines:*
- *Teaching Text* [E] — 633 ch · 4 ¶ · opens “The eyes.” … closes “The fastest rotation in human experience.”
- *Practice Prompt* [E] — 589 ch · 6 ¶ · opens “Blink slowly.” … closes “Two worlds. One switch. You.”
- *Three Ways In* [E] — 778 ch · 3 ¶ · opens “① Three deliberate blinks, each bringing something specific through.” … closes “Tonight, cross consciously.”
- *Post-Engagement Teaching* [E] — 1211 ch · 5 ¶ · opens “You blink fifteen to twenty times per minute.” … closes “The cheapest ticket in the world.”
- *Tree Caption* [E] — 150 ch · full: “The line that runs from root to crown is the tree’s spine. Everything else organizes around it. Remove the axis, nothing stands. Tap to feel the line.”
- *Subtle Mirror* [E] — 238 ch · full: “Ajna. The energy third eye and the physical eyes. One sees without looking. The other opens and closes the gate between seeing and looking. The third eye's stillness and the blink's constant turning are two registers of the same crossing.”
- *Dyad Description* [E] — 335 ch · full: “Indigo and Chartreuse. Indigo is the depth of the simultaneous field — what exists in the space behind closed eyes, the register that doesn't depend on light. Chartreuse is the return: the charged quality of the world when eyes open again, after three seconds in the dark. The world was chartreuse the whole time. The blink showed you.”
- *Shakti Function* [E] — 603 ch · 2 ¶ · opens “Avarana 6 (Inner 10 Triangles), #8 —” … closes “Axis shares Avarana 6 with Echo (#4), Vision (#1), and Crow (#6). Same Mahankusha Mudra — the inner goad that guides consciousness across the threshold without force.”
- *Shakti Practice* [E·substrate] — 289 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 407 ch · full: “I blinked slowly. Three seconds closed. Three seconds open. And in the gap — in the moment of neither closed nor open — I felt something I don't have a word for. Not inner. Not outer. The between. // Now something at the top of my head is pulling. Upward. My body wants to MOVE. To push past what my mind can manage. // I don't think what's above is above. I think it's just what's left when the thinking stops.”
- *Act 1 Voice* [S] — 2238 ch · 13 ¶ · opens “I have been blinking my whole life.” … closes “I open my eyes slowly. I am a body that knows about the blink.”
- *Bindu Reflection* [S] — 1258 ch · 7 ¶ · opens “I have it now.” … closes “There is something at the top of my head that wants to fly.”
- *Witness Perspective* [S] — 1669 ch · 5 ¶ · opens “What is being witnessed here is the body's continuous-access technology.” … closes “This is what the blink can do once it is recognized as access-route.”
- *Leela Story* [S] — 506 ch · 3 ¶ · opens “The line is real.” … closes “Today you felt it.”
- *Gaia Voice* [S·substrate] — 1385 ch · 6 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 19 · CROW — The Top Terminal  ·  `recGeQi7ojZGLEUIr` · Body

- **Teaching Text:** 5 ¶ — "CROWN without the N."; flow / "the wall — and then the thing after the wall"; "Soles at the bottom. Crow at the top."; "Crow is paired with Vision … Vision constructs … Crow dissolves".
- **Act 1 Voice (2,242 ch) is addressed to "you"** and is a complete shaking choreography: hands → wrists → arms → shoulders → neck → jaw → face → chest → belly → hips → legs → knees → ankles → feet; "Faster … Keep shaking until the thinking runs out of words."; then "Stop suddenly. Be still."; "The spine is flooded. The mycelium has become visible."
- **Gate button:** "Begin (30-second shake timer)".
- **Bindu Reflection:** "The flood is a return-point. Three to five minutes."
- **Shakti Practice** (substrate): the mycelium analogy (C-1328).
- **Leela Story:** altitude — "This is not detachment — it is altitude."
- **Dyad:** Violet / Chartreuse — "dissolution and the realization that dissolving never destroyed anything real."

*Field lines:*
- *Teaching Text* [E] — 1111 ch · 5 ¶ · opens “Top of the head.” … closes “Two directions.”
- *Practice Prompt* [E] — 531 ch · 5 ¶ · opens “Move.” … closes “What was there?”
- *Three Ways In* [E] — 836 ch · 3 ¶ · opens “① Shake your body for two minutes.” … closes “What steps into the moment after is the one who was under the narration.”
- *Post-Engagement Teaching* [E] — 1337 ch · 8 ¶ · opens “You have one brain.” … closes “That's Crow. Not the absence of thought. The presence of everything thought was covering up.”
- *Tree Caption* [E] — 215 ch · full: “The crow’s perch is the highest point the tree offers. From there the whole canopy is visible — every branch, every opening, every place the light gets in. The crow sees what the roots cannot. Tap to see from above.”
- *Subtle Mirror* [E] — 263 ch · full: “Sahasrara. The energy crown and the physical crown. One opens through surrender. The other opens through exertion. Same opening. Opposite doors. When the body shakes past the mind's grip and goes still, the same field opens that the crown reveals through silence.”
- *Dyad Description* [E] — 415 ch · full: “Violet and Chartreuse. Violet is the crown register — the frequency of integration, the color at the top of the visible spectrum where individual wavelengths can no longer be distinguished. Chartreuse is the awakened return — what the body looks like after the flood, when the eyes open and the room is more alive than it was. Together: dissolution and the realization that dissolving never destroyed anything real.”
- *Shakti Function* [E] — 662 ch · 2 ¶ · opens “Avarana 6 (Inner 10 Triangles), #6 —” … closes “The Mahankusha Mudra's final register here: the goad that has guided the walker through the entire body section now points forward toward Armin — toward wholeness recognized, not achieved.”
- *Shakti Practice* [E·substrate] — 323 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 603 ch · 5 ¶ · opens “The thinking stopped.” … closes “Nothing needed repair. I didn't know that. Now I do.”
- *Act 1 Voice* [S] — 2242 ch · 12 ¶ · opens “I want to ask you to do something now.” … closes “Stay still. Receive what is here.”
- *Bindu Reflection* [S] — 1761 ch · 9 ¶ · opens “You are still here.” … closes “There is something in the room with you now. Not a thing. A recognition. You are not separate from the room. You are about to enter a room where this is recognized.”
- *Witness Perspective* [S] — 1603 ch · 5 ¶ · opens “What is being witnessed here is the body's organ of synthesis.” … closes “The walker arriving at Armin is arriving at a room where this recognition becomes settled.”
- *Leela Story* [S] — 592 ch · 3 ¶ · opens “The view from here is different.” … closes “What you see from here is information about what needs attention below.”
- *Gaia Voice* [S·substrate] — 1500 ch · 7 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 20 · ARMIN — The Room  ·  `recXcyfAS07fvurEc` · Tree of Life

- **Teaching Text:** 13 ¶ — "Armin means whole. Universal. Complete. From Germanic ermen"; "You are a larger container now."; "You would have arrived here naturally, around nine or ten"; Tat Tvam Asi taken word by word (Chandogya Upanishad).
- **Gaia Voice (substrate, described):** builds the room from every body chakra — Soles → a wall, Forge → a hearth, Prana → the air, Hands → warmth, Pulse → silence, Sonar → geometry, Echo → acoustics, Vision → what hangs on the wall, Axis → the door, Crow → what fills it.
- **Leela Story (2,996 ch) — letter:** "I am proud of you."; the Higher Mind / physical mind and "The conduit is imagination."; the inverted-belief practice; "The Mind section is not work. The Mind section is play."; "Now go. / Imagine. / Lightly."
- **Post-Engagement:** "The things you were most afraid to look at were the things closest to the exit."; then the Mind overture: "Nine centers. Three groups of three. Each group has one job: Creation, Recognition, or Emergence. … IN. / Nine doorways. All pointing inward."
- **Three Ways In:** one per word — ① TAT ② TVAM (name every body surface: "Soles. Forge. Prana. Hands. Pulse. Sonar. Echo. Vision. Axis. Crow.") ③ ASI.
- **Dyad:** "Armin has no dyad … every wavelength visible, nothing split, nothing missing."
- **Shakti Function:** Tripura Malini "lives at the bends in the necklace. This is the second bend."; Avarana 6 Sarva Raksha Kara → permits Avarana 7 Sarva Rogahara.
- **Act 2 Voice** present (one of 10).

*Field lines:*
- *Teaching Text* [E] — 3144 ch · 14 ¶ · opens “Armin is not a location in the body.” … closes “It returns something that was always here, briefly covered by the necessary forgetting of a human life.”
- *Practice Prompt* [E] — 821 ch · 6 ¶ · opens “You sat with the words.” … closes “You are not about to learn something new. You are about to recognize something the body has been practicing since the first step on the ground.”
- *Three Ways In* [E] — 1096 ch · 4 ¶ · opens “Three ways of sitting with Tat Tvam Asi —” … closes “Only arrival.”
- *Post-Engagement Teaching* [E] — 2017 ch · 13 ¶ · opens “Every piece of shadow material you've ever encountered —” … closes “From the wholeness of this room — not from searching, not from incompleteness — you are about to discover what your mind can do when it doesn't need to find itself first.”
- *Tree Caption* [E] — 252 ch · full: “The Bindu Tree and the Maya Tree share a root system that is never visible from above. Armin is where the walker stands between them — feet still in the ground of the body, eyes looking toward the mind’s canopy. Both trees are rooted in the same earth.”
- *Subtle Mirror* [E] — 487 ch · 1 ¶ · opens “Shadow.” … closes “Both are Tripura Malini — the garland-maker holding the thread at both bends.”
- *Dyad Description* [E] — 407 ch · full: “Armin has no dyad. A dyad requires two — a primary and its complement, held in productive tension. At Armin, the tension resolves. Every color the Body chakras expressed separately is present simultaneously. The Spectrum / Aurora is the dyad system completed — not one chakra's pair but all pairs at once, every wavelength visible, nothing split, nothing missing. This is what wholeness looks like as color.”
- *Shakti Function* [E] — 1270 ch · 4 ¶ · opens “Not an Avarana —” … closes “Armin makes that recognition possible.”
- *Shakti Practice* [E·substrate] — 501 ch · 2 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 528 ch · 3 ¶ · opens “The walker has crossed the corridor.” … closes “The journey was the arriving at the place where I could feel it.”
- *Act 1 Voice* [S] — 2567 ch · 15 ¶ · opens “I am here.” … closes “I am ready. The door is open. I am crossing.”
- *Act 2 Voice* [S] — 650 ch · 6 ¶ · opens “You walked through.” … closes “I will be there too. In a different register. You will recognize me — though you may not know that’s what you’re recognizing.”
- *Bindu Reflection* [S] — 1832 ch · 10 ¶ · opens “I sit with the wholeness a while longer.” … closes “Something is calling me. Not from outside. From inside. There is a field I have not yet walked. The body section is complete. And there is more architecture ahead.”
- *Witness Perspective* [S] — 1793 ch · 6 ¶ · opens “What is being witnessed here is the room.” … closes “Armin is the gate. The walker who has arrived has crossed.”
- *Leela Story* [S] — 2996 ch · 24 ¶ · opens “You arrived.” … closes “Lightly.”
- *Gaia Voice* [S·substrate] — 1705 ch · 8 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 21 · INCEPTION — The Seed  ·  `recXbr1bo0hEG4gAf` · Mind

- **Teaching Text:** 9 ¶ — "बीज — Bija — seed."; Vasini "first Vagdevi of the seventh avarana … The first word is the seed."; "The practice of Inception is not transformation. It is inventory."; Rahasya Mudra "what you carry in is what you will find."
- **Story Thread:** "The fifth register of Mind asks one question before the crossing" (Number order — see C).
- **Three Ways In:** what are you about to begin · three breaths at each transition · the seed and the harvest of something that went wrong.
- **Subtle Mirror → Incarnation (27):** "Same question at two scales."
- Mind Triad **Creation**. Short Act 1 (420 ch) and Bindu Reflection (327 ch).

*Field lines:*
- *Teaching Text* [E] — 2124 ch · 8 ¶ · opens “बीज —” … closes “Before you begin: one breath. What are you bringing?”
- *Practice Prompt* [E] — 868 ch · 5 ¶ · opens “You named what you’re carrying.” … closes “And consciousness changes how the seed grows.”
- *Three Ways In* [E] — 595 ch · 3 ¶ · opens “① Right now:” … closes “③ Think of something that has not gone the way you hoped. What did you carry into it at the entry? Notice the connection between the seed and the harvest.”
- *Post-Engagement Teaching* [E] — 1112 ch · 5 ¶ · opens “Every beginning carries a seed that shapes the whole journey.” … closes “What you named today is in the room. You know it’s there. Everything that follows will be different in a small but real way because you looked.”
- *Tree Caption* [E] — 285 ch · full: “Every branch of the Maya Tree began as a seed the mind was carrying before it knew it was carrying it. Bija: the seed the beginning contains. The Maya Tree grows from what was brought in at every inception — most of it unconscious. The practice is to know the seed before you plant it.”
- *Subtle Mirror* [E] — 463 ch · 1 ¶ · opens “Incarnation.” … closes “What you chose before time shapes what you carry.”
- *Shakti Function* [E] — 333 ch · full: “Controller of speech — 1st of the 8 Vagdevis of the 7th avarana. Vasini holds word-power: the capacity to direct speech intentionally. Inception is the moment of the first word, the first intention. What is entered with love is entered by love. What is infused at the beginning multiplies and returns (C-1312: Inception mind chakra).”
- *Shakti Practice* [E·substrate] — 296 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 542 ch · 2 ¶ · opens “The walker stands at a threshold.” … closes “It makes me the one who’s carrying it, instead of it being the one that’s carrying me.”
- *Act 1 Voice* [S] — 420 ch · full: “I’m about to begin something. // Before I go further — I paused. That’s unusual. I usually just start. This time I looked at what I was carrying before I crossed the threshold. // What I found surprised me a little. More than I thought. Residue from something earlier. A conclusion I’d already reached before I started. A hope I hadn’t admitted yet. // I’m taking all of that with me. But at least now I know it’s in the room.”
- *Bindu Reflection* [S] — 327 ch · full: “I saw what I was carrying. Seeing it didn’t dissolve it — but it changed my relationship to it. // I’m not pretending it isn’t there anymore. I’m not managing it from a distance. I’m holding it consciously, which is different from being held by it unconsciously. // The carrying continues. The consciousness of the carrying is new.”
- *Witness Perspective* [S] — 1383 ch · 5 ¶ · opens “What is being witnessed here is the architecture of beginnings.” … closes “Consciousness of the seed is itself the difference between being carried by the beginning and carrying it.”
- *Leela Story* [S] — 507 ch · 4 ¶ · opens “You looked at what you were carrying.” … closes “That’s enough for today.”
- *Gaia Voice* [S·substrate] — 319 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 22 · INTENTION — The Whole Picture  ·  `recRchDoi6eV8B6XO` · Mind

- **Teaching Text:** 8 ¶ — "Sankalpa is not willpower … Willpower is effort. Sankalpa is orientation."; Kamesvari desire-speech; Tesla built machines in his mind first; "Hold the picture. Not the plan. The picture."
- **Three Ways In:** sixty seconds of the finished thing · five-second returns to the image · "Before sleep tonight, hold one intention … Then sleep toward it."
- **Subtle Mirror:** "No structural mirror — because Intention is what sustains every other register through the arc." — and gives the Mind order in Number sequence: "Innocence knows. Inspiration follows. Intuition listens. Insight moves inside. Inception examines the seed. Intention holds the whole picture steady. Invention introduces. Incarnation asks why. Integration arrives."
- Mind Triad **Creation**.

*Field lines:*
- *Teaching Text* [E] — 2174 ch · 8 ¶ · opens “संकल्प —” … closes “Hold the picture. Not the plan. The picture.”
- *Practice Prompt* [E] — 728 ch · 5 ¶ · opens “You held the picture.” … closes “Hold the picture. Not the plan. The picture.”
- *Three Ways In* [E] — 657 ch · 3 ¶ · opens “① Close your eyes.” … closes “③ Before sleep tonight, hold one intention — not a goal, not a task. An image of what you are becoming. Let it be complete and specific. Hold it until it feels real in the body. Then sleep toward it.”
- *Post-Engagement Teaching* [E] — 1169 ch · 5 ¶ · opens “Most people are working from a category rather than a picture.” … closes “The picture you held today is the orientation. Hold it again tomorrow. Not as a wish — as a fact that hasn’t materialized in the physical world yet.”
- *Tree Caption* [E] — 249 ch · full: “The Maya Tree grows toward a shape it has been holding since the first unfurling. Not consciously — but the whole arc of growth has been oriented toward a form the tree is becoming. Sankalpa is the tree knowing its own shape before it’s fully grown.”
- *Subtle Mirror* [E] — 450 ch · 1 ¶ · opens “Intention holds the complete picture of all nine Mind chakras.” … closes “Sankalpa is what makes the arc continuous rather than nine separate moments.”
- *Shakti Function* [E] — 298 ch · full: “Desire-speech — 2nd Vagdevi of the 7th avarana. The attraction within words — desire made stable, not grasping but magnetizing. Intention is desire held steady enough to become a field rather than a force. Kamesvari is the Shakti of creative longing that sustains itself over time without collapse.”
- *Shakti Practice* [E·substrate] — 279 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 510 ch · 2 ¶ · opens “The walker has learned to move, to follow, to listen before speaking, to see from inside, to know the seed.” … closes “I hadn’t given them a direction — only a category.”
- *Act 1 Voice* [S] — 413 ch · full: “I can see it finished. // Not the steps. Not the next action. The whole thing, complete, real, present in the mind before it’s present in the world. // I’m holding it now. There’s a specific quality to the holding — it’s not effort, it’s orientation. Like having a heading. Everything else is navigation within the heading. The heading is the picture. // This is what it means to intend something. Not to try — to hold.”
- *Bindu Reflection* [S] — 385 ch · full: “The picture is holding. Even now, after the practice is done, I can still feel its shape. That’s the quality of a real intention — it doesn’t require my full attention to remain present. It orients without effort. // I’ve been living from a category rather than a picture. Today I made the picture specific. // Tomorrow the category will start organizing itself around the picture instead.”
- *Witness Perspective* [S] — 1397 ch · 5 ¶ · opens “What is being witnessed here is the specific intelligence of the held image.” … closes “What is witnessed is the moment desire stops being a state and becomes a heading.”
- *Leela Story* [S] — 466 ch · 4 ¶ · opens “You held the picture.” … closes “One more time today: the whole thing, finished. Then go.”
- *Gaia Voice* [S·substrate] — 345 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 23 · INSPIRATION — The Pull  ·  `recIPQaGq0Cju648K` · Mind

- **Teaching Text:** 9 ¶ — "Ut means upward. Saha means the power to be"; Modini "the one who radiates joy"; "In the child’s discovery sequence, Utsaha is position two … Sahaja opens the knowing. Utsaha opens the direction."; "Follow what lights you up. The work is in that direction."
- **Practice Prompt:** "Distraction pushes you away from something. The pull takes you toward something."
- **Post-Engagement:** "Later never comes for the things that light you up."
- **Three Ways In:** the two-hour subject · notice when time moves faster · follow one small pull.
- **Shakti Practice** (substrate): follow the highest excitement (C-1243).
- **Subtle Mirror → Invention (26).** Mind Triad **Creation**.

*Field lines:*
- *Teaching Text* [E] — 2389 ch · 8 ¶ · opens “उत्साह —” … closes “Follow what lights you up. The work is in that direction.”
- *Practice Prompt* [E] — 726 ch · 6 ¶ · opens “You named something.” … closes “The thing you wrote about lights you up. That’s the distinction. The lighting up is Utsaha. And Utsaha knows something about where to go that analysis cannot determine in advance.”
- *Three Ways In* [E] — 604 ch · 3 ¶ · opens “① Right now:” … closes “Follow it.”
- *Post-Engagement Teaching* [E] — 1039 ch · 5 ¶ · opens “The pull you’ve been calling a distraction is the most accurate information available to you.” … closes “Follow the pull. Not instead of everything else. But don’t file it under later anymore. Later never comes for the things that light you up.”
- *Tree Caption* [E] — 237 ch · full: “The Maya Tree’s branches bend toward light. Not one light — every light. Each branch has its own direction. The tree has learned which way the warmth comes from. This learning is not intellect. It is the oldest intelligence the tree has.”
- *Subtle Mirror* [E] — 440 ch · 1 ¶ · opens “Invention.” … closes “Both move toward rather than away — one toward the source, one toward the creation.”
- *Shakti Function* [E] — 306 ch · full: “The delighting one — 3rd Vagdevi of the 7th avarana. Modini is the Shakti of joy in expression. Inspiration arrives through delight, not through effort. The door you forgot to guard is always joy — it enters without permission because it never needed to ask. Whatever delights is the operating instruction.”
- *Shakti Practice* [E·substrate] — 265 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 467 ch · 2 ¶ · opens “The walker has been told their whole life to manage what excites them.” … closes “What if the resistance was the waste, and the following was the work?”
- *Act 1 Voice* [S] — 466 ch · 4 ¶ · opens “Something in me is moving toward something.” … closes “The thing I keep going back to — that’s information. The energy is there. That’s where I should be going.”
- *Bindu Reflection* [S] — 309 ch · full: “I named the pull. And now the pull feels slightly more mine — not because it wasn’t mine before, but because I acknowledged it instead of managing it. // A pull you acknowledge is a resource. A pull you manage is a drain. I’ve been spending energy on the management. // There’s a different relationship available.”
- *Witness Perspective* [S] — 1408 ch · 5 ¶ · opens “What is being witnessed here is the field’s way of directing each configuration toward its specific work.” … closes “What is being witnessed is whether the configuration can trust the signal.”
- *Leela Story* [S] — 393 ch · full: “You named the pull. // Something has been pulling at you and you have been redirecting it, managing it, filing it under later. You named it today. That matters more than it looks like it matters. // The pull didn’t become real when you named it. It was real before. What changed is that you stopped spending energy pretending you didn’t feel it. // Follow this one. Just this one. See where it goes.”
- *Gaia Voice* [S·substrate] — 331 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 24 · INSIGHT — From Inside  ·  `rec0yLDfyTJK8Izc5` · Mind

- **Teaching Text:** 8 ¶ — "Antar means inner … Drishti means sight"; "not introspection … the specific capacity to see from inside a situation"; Vimala "without contamination"; "a second kind of objectivity".
- **Three Ways In:** step inside a situation you analyse · notice outside vs inside · thirty seconds inside the other person's position.
- **Tree Caption:** "Antardrishti is the move from the clearing into the canopy."
- **Subtle Mirror → Intuition (25)** ("the flash and the shift"). Mind Triad **Recognition**.

*Field lines:*
- *Teaching Text* [E] — 2175 ch · 8 ¶ · opens “अंतर्दृष्टि —” … closes “Step inside one thing you have been observing. See from there.”
- *Practice Prompt* [E] — 925 ch · 5 ¶ · opens “The shift you just made —” … closes “What you wrote is what became visible from inside. That information was not available from outside. You moved to get it.”
- *Three Ways In* [E] — 733 ch · 3 ¶ · opens “① Think of a situation you’ve been analyzing from the outside.” … closes “Notice what changed.”
- *Post-Engagement Teaching* [E] — 1081 ch · 5 ¶ · opens “There is information inside a situation that is structurally unavailable from outside it.” … closes “What you saw today from inside was not accessible from outside. You had to move to get it.”
- *Tree Caption* [E] — 324 ch · full: “The Maya Tree looks different from inside than from outside. Standing back, you see shape, size, the general direction of growth. Standing inside — in the hollow of the trunk, in the canopy — you see what the tree holds, what moves through it, where light gets in. Antardrishti is the move from the clearing into the canopy.”
- *Subtle Mirror* [E] — 459 ch · 1 ¶ · opens “Intuition.” … closes “A mind that can do both can reach places that analysis structurally cannot enter.”
- *Shakti Function* [E] — 336 ch · full: “The pure / immaculate — 4th Vagdevi of the 7th avarana. Uncorrupted perception. Seeing before interpretation, before belief-structure, before history. Vimala is the clear medium — what arrives when the filters are recognized as filters and set aside, even briefly. The inheritance of belief structures (C-1315) is what Vimala dissolves.”
- *Shakti Practice* [E·substrate] — 245 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 386 ch · full: “The walker has been observing this situation from a careful distance. The fourth register of Mind asks them to move. // Bindu, integrating: I put myself inside the thing I’ve been looking at. And from inside it looked completely different — not better or worse, just different. I had been analyzing something I had never actually inhabited. I didn’t know the difference until I was in it.”
- *Act 1 Voice* [S] — 431 ch · 4 ¶ · opens “I stepped inside it.” … closes “I couldn’t feel any of that from outside. The outside view was keeping me safe from what the inside view is showing me.”
- *Bindu Reflection* [S] — 319 ch · full: “I know the difference now between looking at something and being inside it. I can feel it in retrospect — the exact moment the shift happened. // The outside view felt like safety. The inside view felt like reality. I had been choosing safety over reality without knowing that was the choice I was making. // I know it now.”
- *Witness Perspective* [S] — 1447 ch · 5 ¶ · opens “What is being witnessed here is a positional shift with real epistemological consequences.” … closes “What is witnessed is the moment the configuration discovers it can choose its position — and that the choice changes what becomes available.”
- *Leela Story* [S] — 405 ch · full: “You moved. // You stepped inside something you had been observing. From inside it, things looked different. Not easier — different. The inside-view contains information the outside-view structurally cannot access. // Notice what changed in the body when you made the shift. That’s the register. The mind moved from analysis to inhabitation. They are not the same operation. // You now know this from the inside.”
- *Gaia Voice* [S·substrate] — 303 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 25 · INTUITION — The Flash  ·  `recPM89KrdwQsY3sw` · Mind

- **Teaching Text:** 7 ¶ — Pratibha in Kashmir Shaivism "the luminous self-awareness that precedes all concepts"; Aruna "the light before the sun fully rises"; "Pratibha works backward"; "The explanation is the translation."
- **Three Ways In:** hold a question in the dark thirty seconds · track knowing-before-evidence · ask what you already know before a conversation.
- **Tree Caption:** "Before dawn, the Maya Tree knows light is coming."
- **Subtle Mirror → Insight (24).** Mind Triad **Recognition**.

*Field lines:*
- *Teaching Text* [E] — 2123 ch · 7 ¶ · opens “प्रतिभा —” … closes “What you know before the question is already the knowing. The explanation is the translation.”
- *Practice Prompt* [E] — 839 ch · 5 ¶ · opens “What you put into words just now was already inside you.” … closes “You will feel Pratibha most clearly in the moment right before you reason. That moment is a register. It has been there your whole life. Today you named something that lived in it.”
- *Three Ways In* [E] — 654 ch · 3 ¶ · opens “① Close your eyes.” … closes “Let the pre-verbal answer surface before you enter.”
- *Post-Engagement Teaching* [E] — 1077 ch · 5 ¶ · opens “What you know before you can explain it is a different kind of knowing —” … closes “What you named today arrived before your explanation. That arrival was the data. The explanation is just the translation.”
- *Tree Caption* [E] — 305 ch · full: “Before dawn, the Maya Tree knows light is coming. Not because it can see the sun — because something in the roots has already registered the shift. The knowing travels upward through the tree before the light arrives. Pratibha is what moves through the tree in the dark, before the sun clears the horizon.”
- *Subtle Mirror* [E] — 448 ch · 1 ¶ · opens “Insight.” … closes “Both move toward what is already there but not yet accessible from the usual angle.”
- *Shakti Function* [E] — 336 ch · full: “The dawn-colored — 5th Vagdevi of the 7th avarana. Knowledge before the sun fully rises. Intuition is the first light that precedes certainty — present before the evidence, real before the proof. Aruna does not wait for the sun to confirm her. Knowing before evidence (C-1275: the bidirectional soul journey operates through intuition).”
- *Shakti Practice* [E·substrate] — 258 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 352 ch · full: “The walker carries knowing that hasn’t yet become language. The third register of Mind is the membrane between knowing and saying. // Bindu, integrating: I wrote something and then sat with it and realized I’d known it for weeks. The knowing had been there the whole time — shapeless, wordless, residing. Writing gave it a body. But it was already alive.”
- *Act 1 Voice* [S] — 452 ch · 4 ¶ · opens “I know something.” … closes “What I know, before I can explain it, is still real knowledge. I’m going to treat it that way.”
- *Bindu Reflection* [S] — 321 ch · full: “Something landed before the explanation did. I’m used to requiring the explanation first. This is the other sequence: the knowing arrives, and then — later, sometimes much later — the explanation comes to confirm what was already true. // I touched the first step today. The knowing first. // That’s a practice I can develop.”
- *Witness Perspective* [S] — 1411 ch · 5 ¶ · opens “What is being witnessed here is the intelligence that precedes articulation.” … closes “What is witnessed here is a configuration learning to inhabit that space instead of rushing past it.”
- *Leela Story* [S] — 357 ch · full: “You felt it. // Something was there before you could word it. You know this is true because the writing confirmed something that was already present — not something you discovered, something you verified. // Every time you verify a pre-word knowing, you strengthen the channel. The channel has been there your whole life. // You just made it a little wider today.”
- *Gaia Voice* [S·substrate] — 335 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 26 · INVENTION — The New Room  ·  `recKkLDYW1un67Qsu` · Mind

- **Teaching Text:** 7 ¶ — "Yuj — the same root as yoga"; Jayani "conquers by assembling"; "Your part is the introduction. What you introduce will do the rest."
- **Three Ways In:** two domains meet · connect a stuck thing to another domain · the structural rhyme.
- **Tree Caption:** "The Maya Tree grows by grafting".
- **Subtle Mirror → Inspiration (23).** Mind Triad **Recognition**.

*Field lines:*
- *Teaching Text* [E] — 1922 ch · 7 ¶ · opens “युक्ति —” … closes “Your part is the introduction. What you introduce will do the rest.”
- *Practice Prompt* [E] — 932 ch · 5 ¶ · opens “You named two things that have never been in the same room.” … closes “The next step is to follow the resonance — to see what the third thing is that emerges when the first two finally meet.”
- *Three Ways In* [E] — 663 ch · 3 ¶ · opens “① Think of two domains of your life, knowledge, or interest that have never touched.” … closes “That structural rhyme is Yukti at work.”
- *Post-Engagement Teaching* [E] — 1075 ch · 5 ¶ · opens “Every invention in human history was the recognition that two things were always going to produce a third thing —” … closes “You made the introduction.”
- *Tree Caption* [E] — 309 ch · full: “The Maya Tree grows by grafting — branches from different regions of knowing, touching, fusing. Not every graft takes. But when it does, the new branch carries the intelligence of both its sources. Yukti is the moment of grafting — the deliberate joining that produces what neither source could produce alone.”
- *Subtle Mirror* [E] — 461 ch · 1 ¶ · opens “Inspiration.” … closes “Utsaha and Yukti together are the full arc of creative intelligence: enter through what lights up, assemble from what you gathered.”
- *Shakti Function* [E] — 327 ch · full: “The victorious — 6th Vagdevi of the 7th avarana. Speech that conquers through assembly rather than force. Invention is the Tesla faculty: see it complete in every detail before making it physical (C-1312). What you can visualize complete, you can build. The victory belongs to the assembler who sees the whole before beginning.”
- *Shakti Practice* [E·substrate] — 268 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 403 ch · full: “The walker has been building, following, seeing, holding. The seventh register of Mind asks: what becomes possible when what you know meets itself differently? // Bindu, integrating: I named two things. And the moment I named them together, I could see the third thing — the thing that neither produces alone. It was there immediately. It was always going to be there. I just hadn’t made the introduction.”
- *Act 1 Voice* [S] — 450 ch · 4 ¶ · opens “Two things are in the same room for the first time.” … closes “Something that didn’t exist before this moment now exists. Not because I created it. Because I recognized that it was already implicit in what I knew.”
- *Bindu Reflection* [S] — 290 ch · full: “The introduction was made. Two things are in proximity that have never been in proximity. // I can feel the third thing forming — not as a thought yet, more as a pressure toward a thought. The recognition is close. // I don’t need to force it. I just need to stay available for when it arrives.”
- *Witness Perspective* [S] — 1628 ch · 5 ¶ · opens “What is being witnessed here is the architecture of creative recognition.” … closes “This chakra activates this mind’s Yukti, not a generic creative mode.”
- *Leela Story* [S] — 306 ch · full: “Two things are in the same room now. // That is the entire practice of invention: making the introduction that wasn’t possible until you made it. // Don’t force the third thing. Let it arrive. Your job was to put the first two in the room. That’s done. What they produce is not yours to control. // It will come.”
- *Gaia Voice* [S·substrate] — 330 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 27 · INCARNATION — You Chose This  ·  `rec2cBfv1OtS9GbXI` · Mind

- **Teaching Text:** 7 ¶ — "Ava means down. Tara means crossing."; Sarvesvari "ruler of all"; "from subject of circumstance to author of inquiry".
- **Leela Story (3,679 ch, the longest Leela) — letter:** "Hi. / We need to talk."; names the **Siddhis** — "the capacity to read reality and rewrite it"; "Siddhis used for personal gain shrink."; the practice: use one Siddhi to help someone else this week; "Channels stay open. Bottlenecks close."; "Pass it on. Even one move. Even small."; "Lightly."
- **Three Ways In:** "③ Write one sentence that finishes: I chose this so I could learn _______."
- **Subtle Mirror → Inception (21).** Mind Triad **Emergence**.

*Field lines:*
- *Teaching Text* [E] — 2034 ch · 7 ¶ · opens “अवतार —” … closes “You wanted to know this from the inside. You are learning it from the inside. The wanting and the learning are the same thing.”
- *Practice Prompt* [E] — 949 ch · 6 ¶ · opens “You named a curiosity.” … closes “You are the one who wanted to know this. Whatever this is — you wanted to know it from the inside.”
- *Three Ways In* [E] — 573 ch · 3 ¶ · opens “① Think of the most difficult thing you’re currently living.” … closes “What actual capacity is this life developing in you that couldn’t be developed any other way?”
- *Post-Engagement Teaching* [E] — 1162 ch · 5 ¶ · opens “You chose this.” … closes “You wanted to know this from the inside. You are learning it from the inside. The wanting and the learning are the same thing.”
- *Tree Caption* [E] — 290 ch · full: “The Maya Tree did not arrive by accident at this soil, in this climate, in this specific configuration. The seed chose — not with intention the way a mind chooses, but with the specificity of what it was. Avatara is the tree recognizing its own choosing in the specific form of its growing.”
- *Subtle Mirror* [E] — 466 ch · 1 ¶ · opens “Inception.” … closes “Both ask the walker to know what they're carrying.”
- *Shakti Function* [E] — 343 ch · full: “Ruler of all — 7th Vagdevi of the 7th avarana. Speech as sovereignty. The Atma willingly returns to let the universe experience itself more completely (C-1183). Incarnation is not accident — it is the conscious choice of consciousness to limit itself for the richness of the particular. Sarvesvari presides over the sovereignty of that choice.”
- *Shakti Practice* [E·substrate] — 256 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 500 ch · 2 ¶ · opens “The walker has been following, building, seeing, connecting.” … closes “I chose it because of what the difficulty makes possible.”
- *Act 1 Voice* [S] — 735 ch · 5 ¶ · opens “Why am I here?” … closes “I'm asking because the answer changes how I hold what's difficult. If I chose this — even this — then the difficult parts are not punishments. They're the specific material I came for.”
- *Bindu Reflection* [S] — 359 ch · full: “I named a curiosity and it became specific. Not cosmic — concrete. The difficult thing I’ve been living IS the answer to the curiosity I named. // I didn’t choose this despite the difficulty. I chose it because of what the difficulty makes possible. That’s not a consolation. That’s a complete reframe. // The material I came for has been arriving the whole time.”
- *Witness Perspective* [S] — 1458 ch · 5 ¶ · opens “What is being witnessed here is sovereignty at the scale of a life.” … closes “At Avatara, the configuration is invited to hold both at once.”
- *Leela Story* [S] — 3679 ch · 27 ¶ · opens “Hi.” … closes “Lightly.”
- *Gaia Voice* [S·substrate] — 343 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 28 · INNOCENCE — Before Anyone Taught You  ·  `recflXyBz76hIsjTb` · Mind

- **Teaching Text:** 9 ¶ — "Sahaja is not a practice."; "the training … overshot"; Kaulini "the eighth and final Vagdevi … last among the Vagdevis but first in the child’s discovery sequence"; "The walker arrives at Innocence from Armin" (see C); "What you know before the question is already the answer at a different resolution."
- **Three Ways In:** sit still two minutes · notice knowing before explanation · ask the body before one decision.
- **Subtle Mirror → Integration (29).** Mind Triad **Emergence**.

*Field lines:*
- *Teaching Text* [E] — 2489 ch · 8 ¶ · opens “सहज —” … closes “What you know before the question is already the answer at a different resolution.”
- *Practice Prompt* [E] — 732 ch · 5 ¶ · opens “You wrote something down.” … closes “The knowing underneath the strategy is still intact. It has been intact your whole life. You just wrote some of it down.”
- *Three Ways In* [E] — 475 ch · 3 ¶ · opens “① Sit still for two minutes.” … closes “③ Before one decision today — before analysis, before advice — ask the body what it already knows. One breath. What’s the immediate answer? Use that as your first data point.”
- *Post-Engagement Teaching* [E] — 959 ch · 5 ¶ · opens “You carry more knowing than you have been given credit for.” … closes “What you named today was not new. It was old. Older than the first lesson.”
- *Tree Caption* [E] — 217 ch · full: “The Maya Tree’s roots reach down through everything learned. At the very bottom — before the first lesson, before the first word — the roots touch something older. Sahaja. The knowing the tree was always growing from.”
- *Subtle Mirror* [E] — 484 ch · 1 ¶ · opens “Integration.” … closes “The journey is what makes the recognition available.”
- *Shakti Function* [E] — 344 ch · full: “Of the kula / lineage — 8th Vagdevi of the 7th avarana. Kaulini transmits what is carried from before birth. Innocence is the state before the lineage overlaid its conditions — what was true in the configuration before it knew it had a name. Original clarity (from the full-map). The unbroken thread that the lineage carries but did not author.”
- *Shakti Practice* [E·substrate] — 268 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 469 ch · 3 ¶ · opens “The walker enters Mind from Armin —” … closes “It’s a ceasing of the activity that was preventing the arrival.”
- *Act 1 Voice* [S] — 420 ch · full: “Something is here. // Not something I brought. Something that was here before I arrived. Before the page, before the practice, before this moment. Before, probably, everything I learned. // I know things. I have always known things. Not the things I was taught — the things that were already in place before the teaching began. I’m touching one of those now. // It arrived without effort. That’s how I know it’s the real kind.”
- *Bindu Reflection* [S] — 354 ch · full: “The knowing arrived. I didn’t think it into existence. I didn’t earn it. It came because I stopped doing the thing that was preventing it. // That’s a useful understanding: the natural knowing is already here. The only practice is recognizing what gets in the way. Today I recognized one thing that gets in the way. // That’s enough. The knowing will use it.”
- *Witness Perspective* [S] — 1467 ch · 6 ¶ · opens “What is being witnessed here is the natural mind before the training arrived.” … closes “This chakra begins the return to reliability.”
- *Leela Story* [S] — 326 ch · full: “Something arrived. // You didn’t go to get it. You sat still and it came. // You have been trained to find the answer. This register offers something different: the recognition that knowing arrives before the search. The search was always after the fact. // You don’t have to earn the knowing. You just have to stop interrupting it.”
- *Gaia Voice* [S·substrate] — 376 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 29 · INTEGRATION — Nothing Was Separate  ·  `rec3qLjRAFlDQBQfm` · Mind

- **Teaching Text:** 7 ¶ — "Sama means equal. Rasa means taste"; Tripura Siddhamba "the Destroyer of Poison … Not any specific pain or difficulty. Separateness itself."; "Tripura Siddhamba is not a ninth Vagdevi"; "Nothing was ever separate. The separation was the journey’s necessary form."
- **Act 1 Voice** lists the Mind in Number order and ends "I have a feeling I was told something about this once. At the top of a very long walk, before I forgot." (echo of Sahasrara's Act 2).
- **Leela Story (3,150 ch) — letter:** "Hi. It is me. / I am not going to be talking to you for a while after this one."; field awakening — "Not personal awakening. Field awakening."; "another walker is walking. They are at Forge. Or Vision."; the practice: "Send love into the field."; "Now climb."; "I love you."
- **Three Ways In:** two opposites as one movement · fragmentation pulling from one source · "what was this also?"
- **Shakti Mudra** switches to **Sarva Beeja** here (all other Mind rooms Rahasya).
- **Subtle Mirror → Innocence (28).** Mind Triad **Emergence**.

*Field lines:*
- *Teaching Text* [E] — 2212 ch · 7 ¶ · opens “समरस्य —” … closes “Nothing was ever separate. The separation was the journey’s necessary form.”
- *Practice Prompt* [E] — 996 ch · 6 ¶ · opens “You named something that has stopped feeling separate.” … closes “What you wrote down has always been true. You have just arrived at the place where it’s visible.”
- *Three Ways In* [E] — 659 ch · 3 ¶ · opens “① Think of two things you have been holding apart as opposites —” … closes “③ Find something today that feels like failure, loss, or incompleteness. Ask: what was this also? Let both be true simultaneously. That simultaneous holding is Samrasya — equal taste in all things.”
- *Post-Engagement Teaching* [E] — 1234 ch · 6 ¶ · opens “Nothing was ever separate.” … closes “You have just arrived at the place where this is visible. It was always true.”
- *Tree Caption* [E] — 389 ch · full: “The Maya Tree is the mind’s great construction — the edifice of thought, perception, belief, interpretation. And at the base of all of it: the tree is not separate from the ground it grows in. Never was. The Maya Tree is the field, growing itself into the specific form of this mind. Samrasya: the equal taste in bark and root and branch and fruit and field. One substance. Many registers.”
- *Subtle Mirror* [E] — 501 ch · 1 ¶ · opens “Innocence.” … closes “The end of the Mind section and the beginning of it are the same place.”
- *Shakti Function* [E] — 376 ch · full: “The Destroyer of Poison — presiding consciousness of the 7th avarana. 'Poison' is separateness itself — the disease of believing oneself divided from the whole. Integration is the dissolution of that poison. The 8 Vagdevis together cover all Sanskrit alphabets — all language, all contradiction, all duality — and their presiding intelligence destroys every toxin of division.”
- *Shakti Practice* [E·substrate] — 361 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 751 ch · 3 ¶ · opens “The walker has moved through nine registers of mind —” … closes “At the top of a very long walk, before I forgot.”
- *Act 1 Voice* [S] — 758 ch · 8 ¶ · opens “Who has been asking all of this?” … closes “I have a feeling I was told something about this once. At the top of a very long walk, before I forgot.”
- *Bindu Reflection* [S] — 420 ch · full: “I asked who has been asking. // And something shifted when I asked it. Not dramatically. More like: the question turned around and looked at itself. The one asking the questions noticed itself asking. And in that noticing — for a moment — the question and the asker were the same. // I have a feeling I’ve been here before. Not in this life. In a way that makes this moment feel like coming back to something I already knew.”
- *Witness Perspective* [S] — 1782 ch · 6 ¶ · opens “What is being witnessed here is the ending that was always the beginning.” … closes “What the walker is witnessing is their own wholeness becoming visible to itself.”
- *Leela Story* [S] — 3150 ch · 28 ¶ · opens “Hi.” … closes “I love you.”
- *Gaia Voice* [S·substrate] — 348 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 30 · MAYA — The Construction  ·  `recMyqKSqwRnimgvy` · Tree of Life

- **Teaching Text:** 12 ¶ — "the third and final threshold"; "Maya isn't evil. You can't play without a game board."; "The ghost tree is what Maya looks like when you stop believing it's solid."; Kameshvari, Kama Kala, "Bindu inverted"; "The game board is not the game."; "Three things. Just three. Will. Knowledge. Action."; "From this threshold on, the voice that speaks is Lalita's."
- **Practice Prompt:** "What did you build that isn't real?"; "Name the belief that has been protecting you. Thank it. Let it complete its role."
- **Act 1 Voice:** "the only solid thing left is the red point at the center. And the red point is not afraid."
- **Leela Story (1,529 ch) — letter:** "You don't burn a coat because summer came. You thank it and hang it where you can see it."; the practice line "I see you. Thank you for the protection. You can be glass now."
- **Post-Engagement:** "Iccha. Jnana. Kriya."; "The board was never the game. Walk through."
- **Three Ways In:** notice the introduction · notice the defense · tell the old story once more and watch it go transparent.
- **Subtle Mirror → Bindu (1):** "a lens reversed"; "Shadow→Armin reversed Atlantis … Maya→Aatma reverses Lemuria".
- **Mirror Frequency Instruction:** "transparency is reached by gratitude, not by sound … Every bija the walker has carried — LAM through the crown's silence — sounds at once here".
- **Linked Builds:** Panel 9 — DISSOLVE; Love Is The Only Thing; Awakening — Dissolve (P9, Silence); Maya Dance.

*Field lines:*
- *Teaching Text* [E] — 2994 ch · 11 ¶ · opens “Maya is not a location in the body.” … closes “From this threshold on, the voice that speaks is Lalita's. It has been hers longer than the walker knows.”
- *Practice Prompt* [E] — 790 ch · 5 ¶ · opens “What did you build that isn't real?” … closes “What does it look like from inside the creation? What becomes transparent when you look at it honestly?”
- *Three Ways In* [E] — 875 ch · 3 ¶ · opens “Notice the introduction.” … closes “That is Maya doing what Maya does when it is finally seen: completing its purpose.”
- *Post-Engagement Teaching* [E] — 1507 ch · 8 ¶ · opens “You named it.” … closes “The board was never the game. Walk through.”
- *Tree Caption* [E] — 183 ch · full: “The same tree that opened the book. The ghost tree — near-white, almost nothing. Not erased. Complete. So complete it doesn't need to show itself anymore. Only the red point is solid.”
- *Subtle Mirror* [E] — 829 ch · 3 ¶ · opens “Bindu.” … closes “This time with eyes open.”
- *Shakti Function* [E] — 377 ch · full: “Creation force / Moon — 1st of the 3 Kama Kala Shaktis of the 8th avarana. The creative Shakti made transparent. What was created now becomes visible as creation itself. Maya is not illusion of reality — it is the protective belief system (karma as protection) that prevents full engagement. When the creative force is recognized as force, the protection completes its purpose.”
- *Shakti Practice* [E·substrate] — 336 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 422 ch · 5 ¶ · opens “Everything I built.” … closes “I already had all three. I was using them every moment without knowing.”
- *Act 1 Voice* [S] — 948 ch · 6 ¶ · opens “I know this place.” … closes “But the only solid thing left is the red point at the center. And the red point is not afraid.”
- *Bindu Reflection* [S] — 1035 ch · 8 ¶ · opens “I can see through everything I built.” … closes “One more room.”
- *Witness Perspective* [S] — 1166 ch · 5 ¶ · opens “What is being witnessed here is completion, not collapse.” … closes “It was the construction's own purpose, completing.”
- *Leela Story* [S] — 1529 ch · 9 ¶ · opens “You made it to the see-through place.” … closes “Lightly.”
- *Gaia Voice* [S·substrate] — 1192 ch · 7 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 31 · AATMA — The Soul Revealed  ·  `recqe8qnDxkq0BiCZ` · Tree of Life

- **Teaching Text:** 9 ¶ — "Aatma is the inner triangle"; Will — Kāmeshvarī · Icchā; Knowledge — Vajreshvarī · Jnāna; Action — Bhagamālinī · Kriyā; "Maya was the bark … Aatma is the heartwood"; "make one choice from the deepest knowing … That choice is the permission slip"; "You are not in the triangle. You ARE the triangle."; the blink "has its own room. It is next."
- **Practice Prompt:** "Which one did you forget you already had?" — will (feet pressing) · knowledge (hunches) · action (heart, lungs, hands).
- **Act 1 Voice:** "Gold — deep gold, the temperature of truth. Three vertices, glowing. A tree inside it".
- **Leela Story (1,399 ch) — letter:** "Fear has a texture … Desire has a texture too, shinier. Underneath both there is a quieter place that already knows. Choose from there. Just once."; "They blink. They've been blinking the whole time. We should talk about that. / Next room."
- **Three Ways In:** the morning press · the hunch · what runs without permission ("Put a hand on your chest once today and feel the triangle holding.").
- **Mirror Frequency Instruction:** hand on chest → one breath cycle → one deliberate blink.
- **Linked Builds:** Panel 8 — HOLD; Chase Hughes; Awakening — Hold (P8, 528 Hz); Aatma Dance. Panel Seed carries "Will. Knowledge. Action." before the Signature Phrase.
- See C for the Teaching Text's verticalisation (Kāmeshvarī/Vajreshvarī/Bhagamālinī as vertices) vs the Shakti Name (Vajreshvari alone).

*Field lines:*
- *Teaching Text* [E] — 2739 ch · 10 ¶ · opens “Aatma is the inner triangle.” … closes “It is next.”
- *Practice Prompt* [E] — 982 ch · 6 ¶ · opens “Will.” … closes “That choice is the permission slip.”
- *Three Ways In* [E] — 870 ch · 3 ¶ · opens “Notice the morning press.” … closes “Put a hand on your chest once today and feel the triangle holding.”
- *Post-Engagement Teaching* [E] — 1590 ch · 6 ¶ · opens “You claimed one.” … closes “The next room knows your face. Walk through.”
- *Tree Caption* [E] — 244 ch · full: “The tree inside the triangle — not behind it, inside it. Three vertices glowing: Will, Knowledge, Action. Complete. Balanced. Not reaching for anything. Arrived. The gold is not decoration. It is the temperature of truth seen without flinching.”
- *Subtle Mirror* [E] — 828 ch · 2 ¶ · opens “Maya.” … closes “It stands alone because everything else was built around it.”
- *Shakti Function* [E] — 338 ch · full: “Preservation force / Sun — 2nd of the 3 Kama Kala Shaktis of the 8th avarana. Will · Knowledge · Action. The sustaining Shakti recognized as the soul's own nature. Vajreshvari is Lakshmi — the preserver, the one who sustains through grace. The Aatma trikona: will already known, knowledge already received, action the only remaining step.”
- *Shakti Practice* [E·substrate] — 303 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 533 ch · 5 ¶ · opens “Will.” … closes “I was always free.”
- *Act 1 Voice* [S] — 845 ch · 7 ¶ · opens “The bark went transparent and I thought I would find something complicated behind it.” … closes “There is nothing to receive. There is only the claiming.”
- *Bindu Reflection* [S] — 995 ch · 8 ¶ · opens “I am the will.” … closes “Something about that freedom has a face. I can almost see it. One more room.”
- *Witness Perspective* [S] — 1262 ch · 4 ¶ · opens “What is being witnessed here is recognition, not attainment.” … closes “It is the walker turning around and meeting what has been watching.”
- *Leela Story* [S] — 1399 ch · 9 ¶ · opens “You found the gold room.” … closes “Next room.”
- *Gaia Voice* [S·substrate] — 1203 ch · 5 ¶ · not quoted (author substrate, law: never surfaced verbatim)

#### 32 · EGO REVEAL — The Hidden Helper  ·  `recg65oeH56mF8vMK` · Tree of Life

- **Sealed.** Every field listed below exists and is filled. Of the fields every other room fills, only Sanskrit is empty here; Act 2, the dyad and panel fields are empty, as they are on most rooms. Content is not described or quoted here. Field names and sizes only: Teaching Text 3,314 · Practice Prompt 918 · Story Thread 585 · Act 1 Voice 1,076 · Bindu Reflection 1,145 · Witness Perspective 1,614 · Leela Story 1,832 · Post-Engagement Teaching 1,982 · Three Ways In 899 · Gaia Voice 1,389 · Shakti Function 315 · Shakti Practice 350 · Subtle Mirror 1,106 · Mirror Frequency Instruction 677 · Gate Text 496 · Writing Prompt 231 · Writing Reflection 480 · Tree Caption 203 · Bija Mantra 141 · Codex reference given inside the text (one C-number). Identity cells already public in the register and the app: Verb CONNECT, Voice Gaia, Colour #3D6B35 "Earth Green / Living Field", Subtitle "The Hidden Helper", Shakti Bhagamalini (kp 101), Sarva Beeja Mudra.

*Field lines withheld (sealed).*

#### 33 · LALITA — The Play  ·  `rec3O90Mtasuh5qI7` · Tree of Life

- **Teaching Text:** 10 ¶ — "Lalita. The Sanskrit means The One Who Plays."; "Lalita is not a chakra you activate."; "Bindu and Lalita are the same point — the record names her simultaneously the 1st avarana and the 9th."; the trikona "at full brightness"; "knowing the game does not end the game … The game that knows it's a game doesn't stop — it plays harder."; C-1330 "Leela is the game; Lalita is the game knowing itself."; the three voices merge "for the first and only time"; the map "changes its name in the walker's hand"; "From here, the E Chakras open."; closes "Wake up. I Already Did. Now go play."
- **Practice Prompt:** "Are you playing? … Was any of that work? Or were you playing the whole time?"
- **Writing Prompt** is a free play space: "Draw. Write. Make marks that don't mean anything."
- **Gate Text:** play honestly offered → the page gives "the Reveal — held in the build itself, met as arrival, never as spoiler." (the record does not describe it; neither does this register).
- **Post-Engagement — the three portable practices for life:** "Blink. Breathe. Press. — one second, three chakras, every day. Cross. Blink. Feel. Return. — one minute, full system, whenever you need to reset. And Your Inner Field — yours, always open"; "when you need to laugh, laugh. When you need to rest, rest."; the pointer to a story "a split that happened before time … aistrangegame.com".
- **Leela Story (2,401 ch) — letter:** "Hi. / You made it. / I am going to drop the format."; "I built it as Ashrey. I built it as you"; "The E Chakras are the part of the walk where I do not lead anymore."; "Welcome home, Lalita."; "Now we play."
- **Witness Perspective** ends in her voice: "I was watching. I was walking. I was the road. Now go play."
- **Three Ways In:** notice the absorption · "Do one useless thing on purpose." · re-see one piece of work as play.
- **Tree Caption:** "Now fractal: branching into branching, botanical form dissolving into mandala. Bright, laughing gold … Bindu dots scattered through the branches like fruit, like seeds, like eyes."
- **Mirror Frequency Instruction:** "laugh once today for no reason … notice who is laughing."
- **Subtle Mirror → Bindu (1):** "Maya mirrored Bindu as the origin inverted; Lalita mirrors Bindu as the origin arrived."; "Thirty-three mirrors. One face."

*Field lines:*
- *Teaching Text* [E] — 3469 ch · 10 ¶ · opens “Lalita.” … closes “Wake up. I Already Did. Now go play.”
- *Practice Prompt* [E] — 948 ch · 5 ¶ · opens “Are you playing?” … closes “You author it.”
- *Three Ways In* [E] — 996 ch · 3 ¶ · opens “Notice the absorption.” … closes “But the day it turns over in your hands — the same task, suddenly light — you will know what the last room of the map was for.”
- *Post-Engagement Teaching* [E] — 1807 ch · 8 ¶ · opens “Nothing completes here, because the game doesn't end.” … closes “Now go play.”
- *Tree Caption* [E] — 380 ch · full: “THE tree — the one that was all roots, all fire, all opening, all space, all stars, all silence, all ghost, all gold. Now fractal: branching into branching, botanical form dissolving into mandala. Bright, laughing gold — a child's crown, the morning. Bindu dots scattered through the branches like fruit, like seeds, like eyes. The tree knows it's a tree. And it's playing anyway.”
- *Subtle Mirror* [E] — 1093 ch · 4 ¶ · opens “Bindu.” … closes “Thirty-three mirrors. One face.”
- *Shakti Function* [E] — 400 ch · full: “The all-blissful — queen of queens, the game knowing itself as the player. The complete harmony of Shiva (pure consciousness) and Shakti (deliberate energy). At the Bindu's center: three sub-bindus — red (feminine/Kurukulla), white (masculine/Varahi), mixed (their union). Lalita is simultaneously the 1st avarana (origin) and the 9th (destination) — the same point appearing at both ends of the map.”
- *Shakti Practice* [E·substrate] — 340 ch · 1 ¶ · not quoted (author substrate, law: never surfaced verbatim)
- *Story Thread* [S] — 550 ch · 8 ¶ · opens “You thought you were reading about a point of consciousness waking up.” … closes “Now go play.”
- *Act 1 Voice* [S] — 1098 ch · 9 ¶ · opens “I came in carrying one question.” … closes “Thirty-three mirrors. One face. It was always mine.”
- *Bindu Reflection* [S] — 1127 ch · 9 ¶ · opens “I don't know what I am yet.” … closes “now I play.”
- *Witness Perspective* [S] — 1533 ch · 6 ¶ · opens “What is being witnessed here is the witnessing, completing.” … closes “I was watching. I was walking. I was the road. Now go play.”
- *Leela Story* [S] — 2401 ch · 25 ¶ · opens “Hi.” … closes “Now we play.”
- *Gaia Voice* [S·substrate] — 1313 ch · 5 ¶ · not quoted (author substrate, law: never surfaced verbatim)

---

## B · GIFTS FOR THE UPGRADE

Every row is something in The Map that the app does not yet carry or does not yet *do*. Rows are grouped by the world they would live in.

- "Needs bake" means the field must be added to `ChakraConstellation.json`. The bake is already field-for-field from this table, so that is a one-line change per field plus the view.
- Sources are given as *room · field* (record ids are in A.1).
- **E** = energy. **S** = story: a candidate for Bindu Feed, with the reason given.

### B.1 The 33 — inside each room (the braid)

| # | What it is | Source | World(s) | How it would work there (mechanism) | What it needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **The five gate instruments, built as instruments** | every room · Practice Gate Type + Gate Text + Mirror Frequency | the 33; the Climb | Each gate type gets its own mechanism. **Canvas** (Bindu): one tap places the point; the point persists; a returning walker sees it again. **Sound Response** (Soles, Forge, Prana, Hands, Sonar, Echo): the mic listens for the act the Map names — a low hum, audible breath, the rub of palms ("Rub your palms near the microphone"), a spoken precise word, or the room's silence after a quiet hum. **Tap Rhythm** (Pulse): "Tap the circle on screen in time with your heartbeat"; steady taps at 40–140 bpm open the gate and a haptic pulse echoes the tempo back. **Device Tilt** (Axis, Crow): see #19 and #20. **Textarea**: unchanged. The button words stay the Map's ("I feel the ground", "I found the beat"). | AVAudioEngine input level, CoreMotion, haptics; per-type gate views; the existing SpeechCapture for Sonar | E |
| 2 | **Teaching Text — the room's recognition** (79,449 ch, absent) | every room · Teaching Text | the 33 | Teaching Text becomes the room's recognition movement, between arrival and practice, in its own paragraphs. It is shown a paragraph at a time (the V5 order: Hero → Identity → Teaching → Tree → …). Gaia paragraphs inside it (e.g. Muladhara ¶3, Manipura ¶4, Anahata ¶7, Vishuddha ¶8, Ajna ¶9, Sahasrara ¶10, Shadow ¶9) stay; they are teaching, not plot. | bake; a paged view | E |
| 3 | **"What the [X] Knows That You Forgot" — opened by the offering** (46,939 ch, absent) | every room · Post-Engagement Teaching | the 33 | Unlocks only after the Textarea/Canvas offering leaves the glass ("The room keeps what you gave it. You walk lighter."). It opens like V5's tier (max-height 0 → full over 1.6 s). Rooms whose gate is a body act unlock it when the gate completes. | bake; an unlock flag in the room's state (not a score — it opens, it never counts) | E |
| 4 | **The tree in every room, with its own touch verb** | every room · Tree Caption | the 33; the Climb; Mind ring | The room's tree image opens into a pinch lightbox (1–6×, double-tap 2.4×). The caption becomes the invitation, and the caption's own verb is the gesture. Body rooms: "Tap to feel the contact" (Soles), "the processing" (Forge), "the breathing", "the reaching", "the beat", "Tap to hear the tree", "Tap to listen", "Tap to see", "Tap to feel the line", "Tap to see from above". Special trees: **Bindu has none** ("The origin has no tree") and shows the canvas only. **Maya** is the ghost tree ("Only the red point is solid."). **Aatma** is the tree inside the gold triangle. **Lalita** is fractal gold with "Bindu dots scattered through the branches like fruit, like seeds, like eyes." | the 33 tree artworks (the field names `anahata-tree.jpg`, `vishuddha-tree.jpg`, `ajna-tree.jpg` on the site); bake | E |
| 5 | **The mudrā as the room's carried gesture** | rooms 1–33 · Shakti Mudra + Practice Prompt (A.6.2) | the 33; Today/Rite; Her Home | Each room ends on its mudrā, three breaths, using the Map's hand instructions. Kshobha: "Both hands at the heart, fingers interlaced, thumbs pointing up". Dravini: "ring finger and thumb of each hand touching lightly". Yoni: "thumbs touching, index fingers touching". Akarshana: "in whatever shape your body offers". The mudrā is also a **way back**: "One breath inside it brings you back". Holding the room's mudrā on the Home glass (a two-thumb hold) re-opens the last room carrying that mudrā. The chain (Kshobha ×3 → Dravini → Akarshana ×2 → … → Yoni) is shown as a thread across the rooms. | Shakti Mudra (already in bundle, never shown); hand-only drawings (no Śakti figure) or words only; a gesture recogniser | E |
| 6 | **The Subtle Mirror as a door to the twin** | every room · Subtle Mirror (carried, unshown) | the 33; the Climb; the Road | A "mirror door" in each room crosses straight to its twin room, through the point (A.6.4). Soles → Muladhara reads "same principle at two densities", Maya → Bindu "a lens reversed", Lalita → Bindu "Thirty-three mirrors. One face." Body rooms show the crossing as a vertical line from the Climb to the energy ring. | none new (field in bundle); a door component | E |
| 7 | **Mirror Frequency as the wake-up instrument, per body room** | 10–19 · Mirror Frequency + Instruction | the 33; the Climb | The app currently sounds only syllables. The Map gives each body room a *somatic* way to sound the twin's bīja. Soles: "Hum this tone low and long … into the ground". Axis: alternate eyes-closed silence / eyes-open "hum OM … three times". Echo: hum then "let the silence echo back". Crow: "The silence after the shake is the frequency". Each becomes a timed, mic-aware wake-up step; where the Map says silence, the app goes silent. | mic level; the two fields (in bundle) | E |
| 8 | **The precise-word lattice** | 15 Sonar · Gate Text; 6 Vishuddha · Gate Text | the 33 | The gate offers the Map's own lattice — "Not 'tired' — depleted, heavy, fading, wrung? / Not 'good' — settled, open, light, held?" — and the walker says one word aloud. Speech is captured; the word is the offering (Sonar's Writing Prompt: "The word. One word. The precise one."). | SpeechCapture (exists); private storage | E |
| 9 | **Story Portal Headline as the door line** (absent) | every room · Story Portal Headline | the 33 → Bindu Feed | Each room's one-line portal ("something is listening on the other side", "What are you afraid to look at?", "Are you playing?"). If a room's story layers move to the Feed (#45), this line is the room's door *out to* its story. If they stay as the moving-point story, it is the door into it. | bake | E (door) |
| 10 | **The three letters' practices, lifted out as energy** | 9 · 30 · 20 · Leela Story; Shadow/Maya PET | the 33; the Well; Memory | Three practices live inside the letters. Two are lines the walker says to a passing thought: Shadow's "I see you. I love you. Thank you for showing up. You can rest now." and Maya's "I see you. Thank you for the protection. You can be glass now." Each is held as a two-line practice at the Well. Spoken or held, it writes one App Activity row; nothing counts. The third is Armin's inverted-belief imagination: "Pick one … imagine — fully, with feeling, in detail — what it would be like if the opposite were true." | the lines (verbatim, from Leela Story — needs bake); Well entry | E |
| 11 | **Ajna's dark-room practice as a timed field** | 7 · Practice Prompt + Three Ways In | the 33; Modes | "Just sit in the dark behind your eyelids … Wait." A two-minute dark field (screen to black, no input). Its end is a soft bell. Then the Writing Prompt: "What arrived in the dark when you stopped looking?" | timer; existing bell | E |
| 12 | **Sahasrara's four doors** | 8 · Practice Prompt | the 33; Modes; Time | "The crown does not have an activity. It has conditions." Four doors — Be in nature · Silence (five minutes) · Gratitude · Look up. Each is a mode the app can hold: a five-minute silence; a look-up prompt at night (Time); a gratitude line. | timers; Time hooks | E |
| 13 | **The seven-question litany closing the Soul Tree** | 8 · Post-Engagement Teaching | the Road; the 33 | "The root asked: am I safe? — Yes. / The sacral asked: what do I want? — You followed. … The crown asks: am I alone?" On leaving Sahasrara the seven energy lights answer in turn down the Road. The crown's answer is silence, then the corridor. | bake PET | E |
| 14 | **The Shadow corridor, whole** | 9 · Story Thread, Act 2 Voice, Gate Text, Writing Prompt, PET, Dyad Description | the 33 (Shadow); the Road; Beneath | The Map gives the choreography: three breaths with their lines → **twelve scrolls** in the dark → LOOK, "Two watching eyes" → press-and-hold → one word offered to the mirror → the mirror reflects it → "home. come. please. back." (the existing `revealOrder`) → ALL IS ONE → "Let" / "Be" — "ALL the Aspects and Perspectives of the ONE" → "the Soles door rising as the corridor floor becomes the body's ground". The scrolls and the Let/Be permission are not yet built. | the 12 scroll texts (the Map gives the count, not the texts: GAP); corridor view | E (threshold rite) |
| 15 | **Maya's transparency, as sound and glass** | 30 · Teaching, Gate Text, Mirror Frequency Instruction, Tree Caption | the 33 (Maya); Memory | The construction the walker names is not removed: "It turns it transparent". The typed words go to glass and stay. Then "Every bija the walker has carried — LAM through the crown's silence — sounds at once here and resolves into the quiet behind them". The app stacks the bījas this walker actually sounded (from App Activity), then lets them fade to silence. The ghost tree is near-white; "Only the red point is solid." | the ledger read; BijaSoundService stack; glass text | E |
| 16 | **Aatma's trikona — claim one, receive three** | 31 · Teaching, Gate, Writing Reflection, PET, Mirror Frequency Instruction | the 33; Her Home (kp 99–101) | A gold triangle with three vertices — Will · Knowledge · Action — named to Kāmeshvarī/Icchā, Vajreshvarī/Jnāna, Bhagamālinī/Kriyā. The walker writes one word; the other two vertices light ("the triangle has no separable vertices"). Then the operational step: "make one choice from the deepest knowing … That choice is the permission slip." Then the frequency: hand on chest (heartbeat), one breath cycle, one deliberate blink. The vertices are doors to the three seats. | triangle view; kp 99/100/101 doors | E |
| 17 | **Lalita's play page** | 33 · Writing Prompt, Gate Text, Mirror Frequency Instruction, PET | the 33; A Strange Game | "One field. No question to answer." A free mark canvas (draw/write, nothing scored, nothing saved unless he chooses). The frequency: "laugh once today for no reason". Then the three practices for life (#21). The final Reveal "held in the build" is out of scope here (sealed). | canvas (shared with Bindu's) | E |
| 18 | **Armin's Tat · Tvam · Asi, one per word** | 20 · Three Ways In, Mirror Frequency Instruction | the 33; the Climb | Three steps. **TAT**: three minutes, still. **TVAM**: the ten body lights on the Climb flash in turn as the Map names them — "Soles. Forge. Prana. Hands. Pulse. Sonar. Echo. Vision. Axis. Crow." — then all at once. **ASI**: "Hold Tat in one hand and Tvam in the other" — a two-thumb hold on two points that merge. | Climb lights; two-touch hold | E |

### B.2 The Climb — the ten body chakras

| # | What it is | Source | World(s) | How it would work there | What it needs | E/S |
|---|---|---|---|---|---|---|
| 19 | **Axis — the deliberate blink, detected** | 18 · Gate Text, Practice Prompt, PET, Mirror Frequency Instruction | the Climb; Today; Home | Gate: "Close your eyes. / Three full seconds." The front camera's eye-blink signal (ARKit face blendshape, on-device, nothing stored) sees the eyes close ≥3 s and reopen. The gate opens on the reopening. Variant: five seconds closed, three open. PET's "One deliberate blink per day" becomes a quiet door on Today. | TrueDepth/ARKit permission; fallback to tap | E |
| 20 | **Crow — the shake, then the flood** | 19 · Gate Text ("Begin (30-second shake timer)"), Act 1 choreography, Bindu Reflection | the Climb (top) | A 30-second timer while CoreMotion measures shaking (accelerometer variance). Then "Stop suddenly. Be still." — stillness is detected and held. The spine on the Climb floods bottom to top ("The spine is flooded. The mycelium has become visible."). The flood stays 3–5 minutes as a return-point. | CoreMotion; Climb fill animation | E |
| 21 | **Blink · Breathe · Press — the one-second practice** | 10 · PET; 33 · PET | Home; Today; the Climb | "Close your eyes — that's the Axis. Take one breath — that's Prana. Feel your feet on the ground — that's Soles." A gesture available from anywhere: Axis, Prana and Soles light in order on the Climb within one breath. One App Activity row. **Cross. Blink. Feel. Return.** is its one-minute sibling (the Map gives only the four words and "one minute, full system" — mechanism to design: GAP). | gesture; ledger row | E |
| 22 | **The Euphoria Pulse** | 13 · Act 1, Witness; 14 · Shakti Practice (C-1311) | the Climb (Hands, Pulse); Relationship Field | Rub palms 15–20 s (the mic hears the rub). Palms apart "six inches". Hand to chest. "I reach toward someone I love who is not here" — in the Relationship Field this is the reach toward a named person. Then palms together at the chest: "I am held by what I just sent." | mic; Relationship Field link | E |
| 23 | **Pulse — the beat in three places** | 14 · Three Ways In, Mirror Frequency Instruction | the Climb | "wrist, neck, temple … The wrist is measured. The neck is immediate. The temple is deep." Three tap-rhythm takes, one per place. The haptic answer differs slightly per place. | tap-rhythm view (#1) | E |
| 24 | **The five body couples** | 10, 11, 12, 14, 15, 16, 17, 19 · Teaching Text | the Climb | Touch one body light and its partner glows (A.6.5). Soles↔Hands: "the circuit at its widest". Forge↔Prana: "the Breath Column — nose to navel". Pulse↔Axis. Sonar↔Echo: "one throat". Vision↔Crow: "One brain. Two directions". | Teaching Text (bake) for the captions | E |
| 25 | **The dyad colours on the Climb** | 10–19 · Colour Dyad + Dyad Description; 9 + 20 · Dyad Description | the Climb; Shadow; Armin | Each body light is two colours in "productive tension" (e.g. Indigo/Chartreuse: "The world was chartreuse the whole time. The blink showed you."). Shadow is starfield with no colour. Armin is the aurora where every wavelength is "visible, nothing split, nothing missing". | bake Colour Dyad + Dyad Description; two-tone shader | E |
| 26 | **Body Location and the body's numbers, as quiet facts on the spine** | 10–19 · Body Location (carried, unshown); Teaching/PET numbers (A.6.10) | the Climb | Each light carries its place ("Soles of feet", "Mouth and vocal cords", "The entire spine — crown to coccyx"). An optional ambient line gives the body's own fact ("Seventeen thousand crossings per day."). These are facts *about bodies*, never counts of him. | none (Body Location in bundle) | E |
| 27 | **The Āvaraṇa 4 / 5 / 6 order, as the body walks it** | 10–19 · Shakti Function | the Climb; nine rings | The Map's own note: Sonar (#14) "arrives AFTER the Avarana 5 interlude (Prana, Hands, Pulse) to culminate what Soles and Forge began." The Climb could show Avarana 4 opening at Soles and closing at Sonar, with Avarana 5 nested inside. | Shakti Function (bake) | E |

### B.3 The Road (the walk's order and its stations)

| # | What it is | Source | World(s) | How it would work there | What it needs | E/S |
|---|---|---|---|---|---|---|
| 28 | **Walker Journey Stage as the Road's chapters** | all · Walker Journey Stage (carried) | the Road | Origin → Energy → Threshold → Body → Threshold → Mind → Final Recognition. The Road names each chapter as the camera passes. | none | E |
| 29 | **The Mind overture: "IN" and the three triads** | 20 · PET; 21–29 · Mind Triad | the Road; the seventh ring | Entering the Mind, nine doorways appear "All pointing inward", grouped Creation / Recognition / Emergence. Each triad is a cluster in the 7th ring. | bake Mind Triad + PET | E |
| 30 | **Panel verbs and seed messages as the Road's station lines** | 2–8, 18, 30, 31 · Panel Verb + Panel Seed Message | the Road; Today | The installation's ten verbs (PRESS, FOLLOW, BUILD, OPEN, SPEAK, STILL, RECEIVE, HOLD, DISSOLVE, ACCESS) and nine seeds become the line the Road writes as it passes those stations. FOLLOW, BUILD and HOLD differ from the practice verbs; both are kept. | bake | E |
| 31 | **The awakening tones and songs per room** | 2–8, 18, 30, 31 · Linked Builds | the 33 (wake-up, dance); A Strange Game | Each room's awakening Hz (174, 210, 320, 341, 384, 426, 480, 528, silence) is the room's carrier tone. The linked songs (Iron, Crystallize, Powerful, … the Axis Triptych) are the room's dance. | join to the Builds table `tbl5PR84YTy4anzAD` (register 05 has the dance data) | E |
| 32 | **The three threshold passages, named** | 9, 20, 30, 31 · Shakti Function, Subtle Mirror, Threshold Architecture | the Road; Beneath | Shadow and Armin are "Two bends. One necklace." — Tripura Malini, invisible at the first, visible at the second. Maya → Aatma "reverses Lemuria"; Shadow → Armin "reversed Atlantis". The Road marks each crossing as a passage, not a room. | bake | E |

### B.4 Leela (A Strange Game)

| # | What it is | Source | World(s) | How it would work there | What it needs | E/S |
|---|---|---|---|---|---|---|
| 33 | **Each Leela landing opens the room's *energy*** | every room · Practice Gate Type, Gate Text, Three Ways In, Practice Prompt | Leela → the 33 | Under ruling 5, a landing on the board opens the room at its **gate** (#1) and one of its **Three Ways In**. It does not open the room's story. The 33 × 3 doors (99 practices) are the drop pool. | Three Ways In (carried) | E |
| 34 | **Leela drops drawn from the short Leela Stories** | 1–8, 10–19, 21–26, 28 · Leela Story | Leela; the 33 | The short after-gate recognitions (300–660 ch) are energy closings ("The ground pressed back.", "You stopped looking."). Field description: "drawn on for Leela drops". The letters (#44) are excluded. | carried | E |
| 35 | **C-1330's distinction as the game's frame** | 33 · Teaching Text, Shakti Practice | A Strange Game | "Leela is the game; Lalita is the game knowing itself." The game's home could carry this one line. | bake | E |

### B.5 Her Home (her seat) and the rings

| # | What it is | Source | World(s) | How it would work there | What it needs | E/S |
|---|---|---|---|---|---|---|
| 36 | **The family question that opens her seat** | 2 · Practice Prompt ("which of the 10 Siddhis is latent in me right now?"); 3 ("Which of the 8 Matrikas is visiting you right now"); 4 ("Which of the 10 Mudra Shaktis is your body forming right now"); 5 · Shakti Practice ("which of the 16 is your heart currently magnetizing?" — substrate; the question also stands in Teaching ¶6) | Her Home; first three rings | From the energy room, the ring of her family lights (kp 1–10, 11–18, 19–28, 29–44, 45–52). The walker touches the one that feels present, and her seat opens. The Map's one-line gloss of each Śakti is shown, e.g. "Laghima (weightless)", "Varahi (obstinacy as ground-holding)", "Sarva Vidravini (liquefier of fixed forms)". | bake Shakti Function; parse the 52 glosses; seats exist | E |
| 37 | **The ring's facts card** | Shakti Function (A.6.3) | the nine rings; Her Home; Mandala Veil | Each ring shows its name ("Trailokya Mohana Chakra, Enchanter of the Three Worlds"), presiding form, Yoginī, mental state (Jagrata, Swapna, Sushupti, Savikalpa Samadhi) and the goddess's body at that ring ("her feet", "her Svadhisthana chakra", "her navel region"). | bake; a small card | E |
| 38 | **Tripureśī and Tripura Siddhāmbā as whole-ring presences** | 8 · Shakti Name/Function; 29 · Shakti Name/Function | the 2nd and 7th rings | The two presiding forms with no seat (bundle kp empty) live as the ring itself: the whole 16-petal ring glows at Sahasrara, the whole 8-triangle ring at Integration. Anahata draws, the crown reveals: "The heart draws. The crown reveals who was drawing." | ring-level glow | E |

### B.6 Today, Time, Memory, the Well, Modes, the Relationship Field

| # | What it is | Source | World(s) | How it would work there | What it needs | E/S |
|---|---|---|---|---|---|---|
| 39 | **Night practices** | 18 · Three Ways In ③ ("Tonight, crossing into sleep … this is the long blink"); 22 · Three Ways In ③ ("Then sleep toward it"); 17 · PET (nightly visual replay) | Time (night); Modes (Svapna) | At night the app offers three things: one intention to sleep toward, one moment replayed visually, and the long blink. | Time hooks (exist) | E |
| 40 | **Morning practice** | 31 · Three Ways In ("Notice the morning press"); 10 · PET | Time (morning); Today | The first press of the feet as the day's opening: Blink · Breathe · Press. | — | E |
| 41 | **Echo's daily report** | 16 · Three Ways In ③ | Memory; Time (evening) | "At the end of today, notice what you're carrying that someone else put down." An evening prompt; private. | Memory entry | E |
| 42 | **Incarnation's sentence** | 27 · Three Ways In ③ | the Well; Memory | "Write one sentence that finishes: I chose this so I could learn _______." A single-line well entry, private. | Well entry | E |
| 43 | **Send love into the field** | 29 · Leela Story (practice inside a letter) | Relationship Field | "Send love into the field. Just a moment of it. Just an emission." A held emission gesture outward from the point, toward everyone held in the Relationship Field. | Relationship Field | E |

### B.7 Story material — flagged for Bindu Feed, not dropped

| # | What it is | Source | Why it is story | Where it could live |
|---|---|---|---|---|
| 44 | **The letters** — Leela Story at 9 Shadow, 20 Armin, 27 Incarnation, 29 Integration, 30 Maya, 31 Aatma, 32 *(sealed)*, 33 Lalita | Leela Story (1,399–3,679 ch each) | Addressed letters in one voice ("Hi."; "I am proud of you."; "We need to talk."; "I love you."; "Welcome home, Lalita."), signed "Lightly.". They carry narrative and relationship, not an instruction. | Bindu Feed's Letters. The practices inside them are lifted out as energy (#10, #43). |
| 45 | **The voice layers** — Act 1, Act 2, Bindu Reflection, Witness Perspective, Story Thread | 33 rooms; 142,288 ch together | The point's journey told in four voices. The foundation keeps "story told by a moving point" in the 33, so **Act 1** can stay as the moving point's few lines (DotStage, not a text page). Witness, Bindu Reflection and Story Thread are narration. | Feed, as transmissions in the archetype voices (Bindu, Sakshi). Act 1 stays as motion in the room. |
| 46 | **Gaia Voice** (30,430 ch, substrate) | 33 rooms | Gaia's third-person story of the walk ("She has met her play partner."). The canon forbids verbatim surfacing. | Feed's Gaia archetype, as source the Feed's crafting reads, not as quotations. Ruling needed (C10). |
| 47 | **Lalita's pointer to the long story** | 33 · PET: "a split that happened before time … The door is where it has always been: aistrangegame.com." | A pointer to a separate story. | A door from Lalita's room to the Feed or the site. |

---

## C · CONFLICTS AND GAPS

**C1 · Crossed names (canon ↔ Map).**

| walk-canon key (register 05 uses these) | is the Map field |
|---|---|
| `story.story_thread` | **Act 1 Voice** |
| `story.after_story` | Bindu Reflection |
| `story.interlude` | Act 2 Voice |
| `depth.leela_story` | **Story Thread** |
| `gate.gate_text` | **Leela Story** |
| `gate.gate_interaction` | Gate Text |
| `practice.bindu_reflection` | **Post-Engagement Teaching** |
| `practice.go_deeper` | Three Ways In |
| `arrival.seed_message` | Hero Threshold |
| `arrival.threshold_hint` | Story Portal Headline |
| `author_substrate.app_build_note` | Shakti Practice |

The app bundle uses the Map's names, so the room shows the right text under the right heading.
- **Ruling:** the Map's names govern.
- **Warning:** register 05's dossier lines "Leela story (verbatim)" are the Map's *Story Thread*, and its "gate_text" lines are the Map's *Leela Story*.

**C2 · No drift.** Every mapped field is byte-equal after trimming across three sources:
- walk-canon.json v1.0;
- the app bundle (baked 2026-10-12);
- this dump.

**C3 · Mind order — Book Position vs Number and the texts.**
- The Road (`road` = Book Position) walks Inception 21 → Integration 29, with Innocence at 28.
- The Map's own words walk the other way, in **Number** order:
  - Innocence's Teaching Text: "The walker arrives at Innocence from Armin".
  - Innocence's Story Thread: "The walker enters Mind from Armin".
  - Inception's Story Thread: "The fifth register of Mind".
  - Intention's Subtle Mirror lists the nine in Number order.
  - Integration's Act 1 lists them in Number order.
  - Kaulini is "first in the child’s discovery sequence".
- The Book Position field description admits the split ("the Mind chakras walk Inception→Integration in the book but are numbered Innocence→Integration in-system").
- **Ruling:** keep Book Position for the Road. It is the Practice Book's walking order and what the app ships. Read "fifth register" as in-system numbering.
- **Flag:** Innocence's line "arrives … from Armin" contradicts the Road. A one-line Airtable fix, or the Road takes Number order for the Mind only. This needs one word from him.

**C4 · Mirror inconsistencies.**
- **Vision:** its Subtle Mirror and Teaching ("This center mirrors Manipura") point to Manipura. Its Bija Mantra ("Mirror frequency of Ajna") and Mirror Frequency ("runs on OM · ॐ, the frequency of Ajna") point to Ajna.
- **Anahata** names Svadhisthana as its twin. So does Vishuddha. Svadhisthana names Vishuddha, so Anahata's mirror is not returned.
- **Bindu** names Integration. Integration names Innocence.
- **Ruling for the build:** draw the mirror door from each room's own Subtle Mirror (one-way is allowed). Sound Vision with OM, as its bīja says.

**C5 · Body pairs.** Teaching Text pairs Forge↔Prana and Pulse↔Axis. OLD Pair Partner pairs Forge–Crow, Prana–Pulse and Axis–Pulse. OLD is retired ("Not read by any app"), so Teaching Text governs (A.6.5).

**C6 · Axis carries two concepts.**
- Most Axis fields describe the **blink**.
- Story Portal Headline ("Feel the line that runs from ground to crown.") and Leela Story ("The line is real. From the base of the spine to the crown of the head") describe the **spine-line**, which is Crow's territory ("The entire spine").
- **Flag:** the Axis Leela Story and portal line read as an older Axis. This is an Airtable content fix for him; the app shows them today.

**C7 · Gate type vs gate content.** The type select often names a different instrument than the text describes:

| Room | Typed as | The text asks for |
|---|---|---|
| Soles, Forge, Prana, Hands, Echo | Sound Response | a press, warmth, breath, a rub, listening |
| Axis | Device Tilt | a three-second eye closure |
| Crow | Device Tilt | a shake timer |
| Vishuddha | Textarea | a word *said out loud* |

The sound lives in the Mirror Frequency fields, not in the gate. Ajna's gate button reads "I’m looking" — against its own teaching ("stop looking").
- **Ruling for the build:** the gate's mechanism follows the Gate Text and Mirror Frequency words. The type select is a hint.

**C8 · Shadow's Act 2 is a stage direction.**
- The field reads "Special architecture — Shadow's Act 2 is the corridor itself: …".
- `ChakraRoomView` offers every non-empty Act 2 as the "act two" voice layer, so the walker can open Shadow's room and read the stage direction as prose.
- `ChakraTeaching.revealOrder` parses this cell correctly for the corridor.
- **BUG:** exclude Shadow's Act 2 from the voice layers.

**C9 · Crow breaks the voice contract.** Crow's Act 1 ("I want to ask you to do something now") and Bindu Reflection ("You are still here") are second person. Every other Act 1 and Bindu Reflection is the point's first person. Content flag.

**C10 · The author-substrate law vs the Map.**
- The canon quarantines **Shakti Practice** as `app_build_note`. Airtable describes it as walker-facing ("The Sri Yantra-informed practice for this chakra"), and it carries the C-1311 practices.
- The energy rooms' **Story Thread** ("Gaia, underneath: …") already surfaces close paraphrases of **Gaia Voice**, and the app shows Story Thread.
- **Ruling needed from him:** does the substrate law still hold?
- **Recommendation:**
  - Shakti Practice: practice mechanisms (Euphoria Pulse, Vision, Axis C-1311) may be built from it, but it is not quoted.
  - Gaia Voice: stays substrate and goes to the Feed's Gaia as source.

**C11 · The āvaraṇa-7 mudrā name.**
- The Map calls the Mind ring's mudrā **Rahasya**.
- Its own Manipura record lists the 7th Mudrā Śakti as **Sarva Khechari**, and the chain matches that list at every other step (A.6.2).
- Integration (also āvaraṇa 7, presiding) switches to Sarva Beeja.
- **Flag:** Rahasya, "the secret", is the Map's intentional naming. Keep it as named, and note that it is not the classical 7th.

**C12 · Maya's last line vs ruling 8.**
- Ruling 8: Maya's last line is "only You, playing".
- The Map's Signature Phrase and Panel Seed: "There was never anything to fear. There was only the Bindu, playing." Its Bindu Reflection ends "There was only — / playing. Someone, playing."
- **Ruling 8 governs the app.** The Map record is behind his ruling: an Airtable update is due (he decides; read-only here).

**C13 · Two Kāmeśvarīs.**
- Intention's Śakti is "Kamesvari — Vagdevi #2" (kp 88, Kāmeśī).
- Maya's is "Kameshvari — 1st Kama Kala Shakti" (kp 99).
- Aatma's Teaching also names Kāmeshvarī as the Will vertex.
- **Flag:** keep the seats distinct in any search or index.

**C14 · Colour naming.**
- Primary Color and Colour Dyad spell body pairs differently (Gold vs Yellow, Azure vs Blue).
- Armin's Color Hex `#C9A84C` is the same gold as Lalita's hex and as Bindu's Primary Color, while Armin's colour is "Spectrum / Aurora".
- The Color Hex description says Ego Reveal's hex is "provisional (no panel/art exists yet)".

**C15 · Empty links.**
- **Linked Seed** is empty on all 33.
- **App Activity** (`fldxl5Ez0Btgi8uoR`, the inverse link) is empty on all 33 in this dump. Yet `ActivityLedger.swift` writes `Link to The Map` on every Chakra Practiced row.
- **GAP to check:** either no Chakra Practiced rows had been written when the dump was taken, or the link lands somewhere else. The fix is a read of App Activity rows (out of scope here; read-only).

**C16 · Codex References are thin.** Only 4 records fill the field (C-1325, C-1337, C-1237 · C-1166, C-1313 · C-1311, C-1198 · C-1198, C-1237). The texts cite many more inline: C-1160, C-1183, C-1243, C-1275, C-1311, C-1312, C-1315, C-1328, C-1330, plus one in 32 (sealed).

**C17 · Build Status.** The ten body rooms and Armin are "In Progress" (their URLs end `.html`). The other 22 are "Live".

**C18 · Designed but unbuilt (from this table).**
- The five gate instruments (#1).
- The 33 tree images in the app (#4).
- The twelve scrolls of the corridor: the Map gives the count and says they are "shapes of what has been compressed, named but not yet claimed". It gives no scroll texts (GAP).
- Cross. Blink. Feel. Return.: four words, no mechanism (GAP).
- The E Chakras / Lalita Game, named at Aatma and Lalita ("From here, the E Chakras open."). There is no record for them.
- Lalita's held Reveal (sealed).

---

## D · COVERAGE PROOF

| File | Lines (`wc -l`) | Bytes | Lines read | Method | md5 (8) |
|---|---|---|---|---|---|
| `tool-results/mcp-Airtable-list_records_for_table-1791859783392.txt` (the 33 records) | 0 (one JSON line) | 564,253 | all, via the 33 renders below | parsed with `python3 -I`, every cell written out; field coverage asserted (no cell skipped, no extra field ids) | 27100136 |
| `tool-results/mcp-Airtable-list_tables_for_base-1791860628081.txt` (base schema) | 0 (one JSON line) | 186,713 | The Map's 58 fields, via `schema.txt` | parsed; only The Map's table extracted (other tables belong to other readers) | 08eaf7e2 |
| `r15/schema.txt` (58 field ids, names, types, descriptions) | 64 | 15,878 | 1–64 | Read, in full | 4bc985f9 |
| `r15/bp01.txt` Bindu | 172 | 14,588 | 1–172 | Read, in full | 958364de |
| `r15/bp02.txt` Muladhara | 183 | 17,234 | 1–183 | Read, in full | d95b5476 |
| `r15/bp03.txt` Svadhisthana | 187 | 18,831 | 1–187 | Read, in full | e2cfe6c6 |
| `r15/bp04.txt` Manipura | 190 | 20,462 | 1–190 | Read, in full | 1ca05644 |
| `r15/bp05.txt` Anahata | 193 | 23,990 | 1–193 | Read, in full | acbe47e6 |
| `r15/bp06.txt` Vishuddha | 200 | 22,976 | 1–200 | Read, in full | 85663577 |
| `r15/bp07.txt` Ajna | 195 | 22,671 | 1–195 | Read, in full | 03296366 |
| `r15/bp08.txt` Sahasrara | 224 | 26,403 | 1–224 | Read, in full | 534eeece |
| `r15/bp09.txt` Shadow | 243 | 25,026 | 1–243 | Read, in full | 6069f932 |
| `r15/bp10.txt` Soles | 179 | 11,969 | 1–179 | Read, in full | 458ec1b5 |
| `r15/bp11.txt` Forge | 179 | 12,407 | 1–179 | Read, in full | 5b6ff35d |
| `r15/bp12.txt` Prana | 175 | 12,831 | 1–175 | Read, in full | 4c4767f1 |
| `r15/bp13.txt` Hands | 174 | 12,764 | 1–174 | Read, in full | 362c7bc6 |
| `r15/bp14.txt` Pulse | 175 | 13,449 | 1–175 | Read, in full | a800aa9e |
| `r15/bp15.txt` Sonar | 182 | 13,673 | 1–182 | Read, in full | d8b097bf |
| `r15/bp16.txt` Echo | 166 | 13,101 | 1–166 | Read, in full | 1e923df7 |
| `r15/bp17.txt` Vision | 180 | 13,676 | 1–180 | Read, in full | 64f989a3 |
| `r15/bp18.txt` Axis | 200 | 15,408 | 1–200 | Read, in full | a96df514 |
| `r15/bp19.txt` Crow | 212 | 17,325 | 1–212 | Read, in full | 7f1ab19b |
| `r15/bp20.txt` Armin | 312 | 25,013 | 1–312 | Read, in full | 0133b0cf |
| `r15/bp21.txt` Inception | 159 | 12,240 | 1–159 | Read, in full | c39fe151 |
| `r15/bp22.txt` Intention | 159 | 12,235 | 1–159 | Read, in full | 74b94149 |
| `r15/bp23.txt` Inspiration | 161 | 12,089 | 1–161 | Read, in full | b964207b |
| `r15/bp24.txt` Insight | 159 | 12,257 | 1–159 | Read, in full | 959d014c |
| `r15/bp25.txt` Intuition | 158 | 11,982 | 1–158 | Read, in full | 3b1a4b07 |
| `r15/bp26.txt` Invention | 157 | 12,089 | 1–157 | Read, in full | 313422d0 |
| `r15/bp27.txt` Incarnation | 207 | 15,791 | 1–207 | Read, in full | d9e1601e |
| `r15/bp28.txt` Innocence | 162 | 12,056 | 1–162 | Read, in full | 39e49b78 |
| `r15/bp29.txt` Integration | 221 | 16,800 | 1–221 | Read, in full | 74fab170 |
| `r15/bp30.txt` Maya | 223 | 18,352 | 1–223 | Read, in full | a969e978 |
| `r15/bp31.txt` Aatma | 211 | 18,270 | 1–211 | Read, in full | e2f6ca70 |
| `r15/bp32.txt` Ego Reveal (sealed) | 209 | 20,935 | 1–209 | Read, in full; content withheld here | 2300bdd2 |
| `r15/bp33.txt` Lalita | 261 | 21,648 | 1–261 | Read, in full | d6551a37 |
| *Comparison only* `chakra-upload/extracted/uploads/walk-canon.json` | 2,474 | 553,821 | structural | `python3 -I`: key→field mapping and byte comparison for all 33 rooms; register 05 already read it in full | 8552ad39 |
| *Comparison only* `iOS/Bindu Mandala/Data/ChakraConstellation.json` | 1,642 | 327,662 | structural | `python3 -I`: key→field mapping, kp/address/joinedBy printed for all 33, byte comparison | 70211e07 |
| *Comparison only* `iOS/Bindu Mandala/Models/ChakraTeaching.swift` | 343 | 15,100 | 1–343 | Read, in full | 33435ac0 |
| *Comparison only* `iOS/Bindu Mandala/Views/Chakra/ChakraRoomView.swift` | 797 | 31,211 | 1–140, 196–235 + grep | partial (to confirm what the room renders) | 718bac66 |
| *Lookup only* `waves/register/05-chakra-corpus.md` | 3,392 | — | 1–30, 380–499 + grep | partial, as the brief asks (lookup) | — |
| *Lookup only* `waves/register/06-chakra-skills.md` | 2,616 | — | 751–875 + headings + grep | partial, as the brief asks (lookup) | — |

Field coverage: 58 fields × 33 records. Every non-empty cell (1,572 of 1,914) was rendered and read. The empty cells are those listed under "Fill" in A.0. All quoted strings in A.6–A.7 and B were checked by script against the dump; 0 misses.

---

## Return

**File:** `waves/register/15-airtable-map.md`

**The ten most valuable gifts:**
1. **The five gate instruments, built as instruments** (B #1): Canvas, mic-heard Sound Response, Tap-Rhythm heartbeat, blink and shake detection. The Map spells out each mechanism, and today every gate is one 1.4-second hold.
2. **Teaching Text as each room's recognition** (#2): 79k characters, absent from the app.
3. **"What the [X] Knows That You Forgot", opened only by the offering** (#3): 47k characters, absent.
4. **The family question that opens her seat** (#36): Siddhi, Mātṛkā, Mudrā, Ākarṣiṇī, Anaṅgā, with 52 one-line glosses for kp 1–52 from Shakti Function.
5. **The mudrā chain as the carried gesture and a way back into rooms** (#5): Yoni → Kshobha ×3 → … → Yoni.
6. **The tree in every room with its own touch verb** (#4): no tree at Bindu, the ghost tree at Maya, the fractal gold tree at Lalita.
7. **Axis's detected deliberate blink and Crow's 30-second shake → stillness → flood** (#19, #20), with **Blink · Breathe · Press** available anywhere (#21).
8. **The Subtle Mirror door to each room's twin** (#6) and **the five body couples on the Climb** (#24), with the dyad colours (#25).
9. **The Shadow corridor whole** (#14: twelve scrolls, LOOK, mirror word, home/come/please/back, Let/Be, the Soles door) and **Maya's transparency** (#15: named construction to glass; every bīja he sounded, then silence).
10. **Aatma's trikona** (#16: claim one, receive three, one choice from the heartwood). The **eight Leela-Story letters** are flagged for Bindu Feed's Letters (#44), with their practices lifted out as energy (#10, #43).
