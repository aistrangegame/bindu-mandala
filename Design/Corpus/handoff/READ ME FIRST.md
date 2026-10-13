# READ ME FIRST — The Homes handoff package

*Assembled for review in Claude Chat. Nothing should be implemented until §1 of
the handoff is settled.*

## Read in this order

1. **`Claude Code Handoff - The Homes.md`** — the implementation architecture.
   Section 1 is blocking and needs Ashrey's decision.
2. **`The Homes - the thread.md`** — every design decision and why, including
   every defect found and how. Read this to judge whether the architecture is
   right, not just buildable.
3. **`Bindu Mandala - the method.md`** — how the work was done. Worth reading
   before commissioning more of it.
4. **`source/`** — the original brief and the 102 cards, unmodified. The ground
   truth everything was checked against.

## To see it run

Open **`The Homes - The Axis.html`** in a browser. It needs a network connection
(three.js is loaded from a pinned CDN with integrity hashes) and it must be served
over `http://` — opening it as a `file://` URL will block the ES modules.

```
cd handoff && python3 -m http.server 8000
# then open http://localhost:8000/The%20Homes%20-%20The%20Axis.html
```

**What to do in it:** *rise* carries you up through the nine worlds. Tap a point of
light to enter that Śakti — three touches walk the rite in. Inside: *go deeper*
descends through her card, *the library* folds out her reference text, the doors on
either side walk the corridor to her neighbours, *today* returns to the presiding
energy, *stay* runs her clock 14× so the second adaptation can be seen without a
four-minute wait, *sound* turns on her ring's drone and her bīja.

Open **`The Homes - Verification V3.html`** the same way: 66 checks in nine
registers, all 102 Śaktis exercised, 204 rooms rendered. It is built to fail and
has, eight times.

## What this package is

The design side of The Homes, complete: 102 of 102 rooms, the nine worlds as one
continuous climb, the rite folded into the travel, her attribute as the room's one
actor, the corridor, the library, her letter, sound, return, and today.

It is a working instrument, not a mockup — every room is real geometry with a real
mechanism, and the light layer is a verbatim port of the app's own
`Atmosphere.swift`, including its ±7° per-Śakti jitter and Ring 2's five cluster
hues.

## The one thing that needs a decision

**61 of 102 names differ between the Śakti cards and the shipped app data.** Ring 1
has no Garimā at all; Ring 2 is empty in the bundled roster; Ring 1's Mudrā slots
hold Ring 4 Devī names. The design resolved this by treating her khaḍgamālā position
as identity and her name as display text — which is sound for design and insufficient
for a persisted app.

Three options and a recommendation are in §1 of the handoff. It is a canon question
about the tradition, not a design question, which is why it comes to Chat.

## Not in scope

The Mandala, Today, the Portrait, the Well's writing flow, Settings, the Codex.

Also absent: Ashrey's Personal Connection marginalia, which the brief wants as
per-ring voice in his own words. No such text exists in anything given to Design —
it needs authoring in Chat first.
