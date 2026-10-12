# Wave 3 — The Origin and the 33

**Branch:** `wave/3-origin` (stacked on `wave/1-light`) · **Charter:** Build Charter II (Emergence)

One yantra, three ways through it: this wave seats the 33 chakras of The Map inside
the Mandala's yantra, at the addresses the Map was realigned to on 17 May 2026
(Codex C-1343, C-1344, C-1345), and turns the Bindu Origin into the Mandala's door.

| Piece | What it is | Where |
|---|---|---|
| **The Homecoming** | The Bindu Origin as Mandala's door. First time: the light condenses into one point, the two lines arrive, the covenant is offered. Every return: one breath — the point blinks and the yantra draws itself outward from it (G17). The covenant touch (one finger, still, one breath) hands straight into today's Recognition ceremony, two lines unchanged. | `Views/Common/HomecomingView.swift`, `BinduMandalaApp.swift` |
| **The bake** | The Map's 33 joined to the Mandala table's 102, shipped as `Data/ChakraConstellation.json`: Road order, kind, āvaraṇa, kp[], colour, verb, bīja, essence, mudrā, body place — only the Map's own values. | `Data/ChakraConstellation.json`, `Models/ChakraConstellation.swift` |
| **The constellation** | The 33 drawn as light at their addresses: energy at a whole ring, body/mind/summit at one Śakti's seat, Shadow and Armin between rings, the Bindu and Lalitā at the point. A switch (✦), and spoken where they stand. | `Views/Mandala/ChakraConstellationLayer.swift` |
| **The thresholds** | Falling through 3→4 passes the Shadow corridor (the dark closes in, then thins at one edge); 6→7 passes Armin, Tripura Mālinī's gate (a garland gathers and parts). Light, haptic and sound — never a lock. | `Views/Mandala/MandalaThresholdMoment.swift` |
| **The Road** | Walk the 33 in order (☉): one continuous camera path over the same yantra, centre → perimeter → spiralling home. A touch moves on; leaving is one touch. | `Views/Mandala/ChakraRoad.swift`, `ChakraLayerOverlay.swift` |
| **The day layer** | Folded into the Rite: grace (the ledger read back once, room-matched, then rest), the pulse as a heartbeat under the thumb (rings 4–8), three doors by the hour (one always the one-second floor), the floor itself (Blink. Breathe. Press.), and the Sakshi close. | `Services/RiteDay.swift`, `Views/Today/RiteDayLayer.swift` |

**Hooks into shared files** (kept small for the parallel waves): one `@State`, one
overlay, one canvas argument pair and one line in `updateEntered()` in
`LivingMandalaView`; two properties and one call in `MandalaCanvasLayer`; the foot of
`DailyRiteView` (grace line, button style, doors row); one read-only extension at the
end of `AirtableService`; the launch rule in `BinduMandalaApp`.

Decisions and gaps: `waves/wave-3/notes.md`.
