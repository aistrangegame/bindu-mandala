# Wave 0 — Ground

**Branch:** `wave/0-ground` · **Charter:** Build Charter II (Emergence)

Wave 0 makes the instrument trustworthy enough to carry the waves that open it. Its work is foundations, not new spectacle. Everything here either protects his practice data or removes something that would quietly fight the waves after it.

## A · Bring home what was only on the Mac
- [x] The four local-only branches are preserved on GitHub as `archive/*`: practitioner-notes, ring-4-cosmic, ring-5-giving, ring-9-bindu.
- [x] **The margin** (practitioner notes) is merged: schema V3 with a lightweight stage, `Note Left` written to the ledger, and the four loss paths fixed in its own audit.
- [ ] Verified green on "Waves — test".

## B · Defects found in the reading — all nine fixed (see DECISIONS.md, 2026-10-12)
1. **The dust motes are invisible on fire and water days and in the Portrait.** The rise/fall opacity envelope animates 0→0 and the frames in between are never drawn. Also, positive delays leave the motes standing still for up to 20 s. Fix: drive each mote from a `TimelineView` clock as a pure function of time, with the phase offset so motes are mid-flight when the screen opens.
2. **A felt seat on the Mandala only lights after the server confirms.** `hasBeenFelt` reads only the server count. It should merge the local recognition entries, so a seat lights offline and before Airtable answers.
3. **A Silence Held is drawn as "felt"** in the Field, the Portrait and Her Moments. A silence is its own gesture and must not light a seat as felt.
4. **Feeling her from a room or her Detail jumps the app to the Portrait.** After Recognition he should stay where he was. The Portrait still settles her point the next time it opens.
5. **Recognitions can be dropped from the offline queue after 3 failures.** Practice events are never dropped. Keep retrying them with backoff, forever.
6. **The Detail always reports gesture source `.mandala`.** Carry the real origin: Rite, Mandala, Field, room.
7. **The letter editor loses text on a background kill.** It has no `scenePhase` save (found by the margin's audit). Save on `.inactive`, as the margin does.
8. **`ENERGY_POS` is read first-wins in one place and last-wins in another.** Make it one rule.
9. **The `logVerification` dump runs on every sync.** Remove it.

## C · Data (Airtable, live, done from the chat session) — done
- **Spellings:** Vaśinī, Stambhinī, Jṛmbhiṇī, Mṛtyupraśamanī, and the 2nd āvaraṇa as Sarvāśāparipūraka.
- **Function** for the 16 Karṣiṇīs, in the voice of the other 86.
- **Recognition Count / Last Felt** recomputed from the App Activity ledger (59 recognitions, 45 Śaktis) so the mirror agrees with the record.
- The **Khadgamala Position** description corrected to 1–102.
- **Bīja** stays empty where tradition gives no individual syllable (truth floor). It is not invented.

## D · The ring's own data, read live — done (`RingFactsCache`, no schema change)
Gem, Dhātu, Time Cycle, Avarana Beeja and Goddess Body Region are decoded from the Avarana rows. The values typed into Swift stay only as an offline fallback.

## E · Checks that would fight the waves
Source-reading tests that only enforced a lifted rule are rewritten in the wave that lifts that rule. In Wave 0 nothing visual changes, so the composition lock stays until Wave 1 re-baselines it.

## Done when
- "Waves — test" is green.
- Merged to `main`, and TestFlight delivers.
- He walks it and nothing he had is missing.
