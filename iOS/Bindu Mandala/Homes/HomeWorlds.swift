import Foundation

// MARK: - The nine worlds
//
// A port of `Claude Design Round 2/homes/homes-worlds.js` — the pure half.
// Design's file is one continuous vertical world, the body from Feet to
// Totality, where each āvaraṇa is *weather* rather than palette: its own air,
// its own light physics, its own material, its own clock.
//
// What ports here is everything that is not a mesh: the ring character table,
// the world table, the veil→fog law and the tempo→world-clock law. What does
// not port is geometry and shaders — those wait on the renderer ruling
// (charter §2.4), and this file is written so either renderer can draw from it.
// Nothing here imports SceneKit, SwiftUI, or any view.
//
// ── Law 1, position is identity, and Airtable is the source of truth ────────
// Design's JavaScript hard-codes four strings the app *syncs from the base*:
// the āvaraṇa's name, its presiding Form, its Yoginī class and its mental
// state. Those four are Airtable's, not Design's. They live in this table only
// as the value shown when the base has not been reached yet, and
// ``HomeWorlds/world(ring:live:)`` overlays the live row on top of them.
// The other nine — gem, dhātu, clock, body region, fog, veil, tempo, verb,
// bīja — are carried by no Airtable field the app reads, so Design's table is
// their only source. They were cross-checked against
// `Claude Chat/bindu-mandala-expansion.md`, which agrees row for row.

/// How a ring *behaves*, beneath whatever it is called.
///
/// From Design: the Yoginī class is how **veiled** the world is (secrecy
/// deepens inward), the mental state sets the world's **tempo**, the Mudrā verb
/// is what the ring **does**, and the presiding Form is who holds it.
struct RingCharacter: Equatable {
    /// Āvaraṇa 1–9.
    let ring: Int
    /// The presiding Form. Airtable's `Presiding Form` overrides this.
    let form: String
    /// Śṛṣṭi / Sthiti / Saṃhāra — creation, maintenance, dissolution.
    let phase: String
    /// The Yoginī class. Airtable's `Yogini Class` overrides this.
    let yogini: String
    /// How veiled the world is, 0 at the Bhūpura to 1 at the Bindu.
    /// Monotone inward, and the only thing that scales fog density.
    let veil: Double
    /// The mental state. Airtable's `Mental State` overrides this.
    let state: String
    /// The world clock's rate. **Not monotone** — see ``HomeWorlds/tempi``.
    let tempo: Double
    /// The Mudrā verb: what this ring does.
    let verb: String
    /// The ring's bīja, as the expansion doc's āvaraṇa table carries it.
    let bija: String
}

/// A fog colour as Design authored it — a packed 24-bit RGB hex, kept in that
/// form so the value can be diffed against the JavaScript at a glance, with
/// normalised components for whichever renderer is ruled.
struct FogColor: Equatable {
    let hex: Int

    var red: Double { Double((hex >> 16) & 0xFF) / 255 }
    var green: Double { Double((hex >> 8) & 0xFF) / 255 }
    var blue: Double { Double(hex & 0xFF) / 255 }
}

/// One āvaraṇa as a world: what it is called, what it is made of, what light it
/// is lit by, what clock it keeps, and what air stands in it.
struct HomeWorld: Equatable {
    /// Āvaraṇa 1–9.
    let ring: Int
    /// The āvaraṇa's name. Airtable's `Sanskrit Name` overrides this.
    let name: String
    /// The ring's gem — its light. Design and the expansion doc only.
    let gem: String
    /// The ring's dhātu — its material. Design and the expansion doc only.
    let dhatu: String
    /// The ring's clock, in words. Design and the expansion doc only.
    let clock: String
    /// The body region the ring stands in. Design and the expansion doc only.
    ///
    /// Deliberately *not* overlaid from Airtable's `Subtle Body Chakra`: that
    /// field names a cakra, which is a different thing from the body region
    /// Design's vertical world is built on, and overlaying one onto the other
    /// would be a rename, not a correction.
    let region: String
    /// The weather in one line — what the air *does*, not how it looks.
    let weather: String
    /// The fog's colour, before the veil touches it.
    let fog: FogColor
    /// The fog's density, before the veil touches it.
    let fogDensity: Double
    /// The ring's character.
    let character: RingCharacter

    /// Fog density after the veil: `density × (1 + veil × 0.55)`.
    ///
    /// The Bhūpura is unveiled and its air is exactly as authored; the Bindu is
    /// wholly veiled and stands in 1.55× the fog. This is the *only* thing the
    /// veil scales.
    var veiledFogDensity: Double {
        fogDensity * (1 + character.veil * HomeWorlds.veilFogScale)
    }
}

/// The nine worlds, and the two clocks that must never be confused.
enum HomeWorlds {

    /// Āvaraṇa numbers, in order of descent.
    static let rings = Array(1...9)

    /// The veil's grip on the fog. `density × (1 + veil × 0.55)`.
    static let veilFogScale: Double = 0.55

    // MARK: - RING_CHARACTER

    /// Design's `RING_CHARACTER`, verbatim.
    static let ringCharacter: [Int: RingCharacter] = [
        1: RingCharacter(ring: 1, form: "Tripurā", phase: "Śṛṣṭi",
                         yogini: "Prakaṭa — manifest", veil: 0.00,
                         state: "Jāgrat — waking", tempo: 1.00,
                         verb: "AGITATE", bija: "Aim"),
        2: RingCharacter(ring: 2, form: "Tripureśī", phase: "Śṛṣṭi",
                         yogini: "Gupta — secret", veil: 0.12,
                         state: "Svapna — dreaming", tempo: 0.82,
                         verb: "LIQUEFY", bija: "Klīm"),
        3: RingCharacter(ring: 3, form: "Tripurasundarī", phase: "Śṛṣṭi",
                         yogini: "Guptatara — more secret", veil: 0.24,
                         state: "Suṣupti — deep sleep", tempo: 0.62,
                         verb: "DRAW", bija: "Sauḥ"),
        4: RingCharacter(ring: 4, form: "Tripuravāsinī", phase: "Sthiti",
                         yogini: "Sampradāya — lineage", veil: 0.36,
                         state: "Turīya begins", tempo: 0.72,
                         verb: "OPEN", bija: "Hrīm"),
        5: RingCharacter(ring: 5, form: "Tripuraśrī", phase: "Sthiti",
                         yogini: "Kulottīrṇa — beyond clan", veil: 0.48,
                         state: "Turīya deepening", tempo: 0.66,
                         verb: "VOICE", bija: "Hsraim"),
        6: RingCharacter(ring: 6, form: "Tripuramālinī", phase: "Sthiti",
                         yogini: "Nigarbha — in the womb", veil: 0.60,
                         state: "Turīyātīta begins", tempo: 0.50,
                         verb: "STILL", bija: "Hsklhrīm"),
        7: RingCharacter(ring: 7, form: "Tripurasiddhā", phase: "Saṃhāra",
                         yogini: "Rahasya — secret", veil: 0.72,
                         state: "Pure witness", tempo: 0.44,
                         verb: "WITNESS", bija: "Hsauḥ"),
        8: RingCharacter(ring: 8, form: "Tripurāmbā", phase: "Saṃhāra",
                         yogini: "Atirahasya — most secret", veil: 0.86,
                         state: "Source-consciousness", tempo: 0.36,
                         verb: "SEED", bija: "Aim Klīm Sauḥ"),
        9: RingCharacter(ring: 9, form: "Mahātripurasundarī", phase: "Saṃhāra",
                         yogini: "Parāparāraharasya", veil: 1.00,
                         state: "Pure being", tempo: 0.28,
                         verb: "ARRIVE", bija: "Hrīm"),
    ]

    /// The veil by ring, 1…9 — monotone inward, ending closed.
    static let veils: [Double] = [0.00, 0.12, 0.24, 0.36, 0.48, 0.60, 0.72, 0.86, 1.00]

    /// The tempo by ring, 1…9.
    ///
    /// **Not monotone, and deliberately so.** Ring 3 (Suṣupti, 0.62) runs
    /// slower than ring 4 (Turīya begins, 0.72): deep sleep is the slowest
    /// thing in the outer half, and the fourth is where the world quickens
    /// again as the witness opens. Design chose it; it ports exactly, and
    /// nothing here may "fix" it into a descending ramp.
    static let tempi: [Double] = [1.00, 0.82, 0.62, 0.72, 0.66, 0.50, 0.44, 0.36, 0.28]

    // MARK: - WORLDS

    /// Design's `WORLDS`, verbatim but for the four Airtable-owned strings,
    /// which are the base's and are overlaid by ``world(ring:live:)``.
    static let worlds: [Int: HomeWorld] = {
        let rows: [(n: Int, name: String, gem: String, dhatu: String, clock: String,
                    region: String, weather: String, fog: Int, density: Double)] = [
            (1, "Trailokyamohana", "Topaz", "Rasa", "day–night", "Feet",
             "low light raking a vast floor, swinging horizon to horizon", 0x1d1206, 0.0125),
            (2, "Sarvāśāparipūraka", "Sapphire", "Rakta", "the hour", "Pelvis",
             "the air pulses — blood-warm waves through cold blue", 0x0a1330, 0.017),
            (3, "Sarvasaṅkṣobhaṇa", "Coral", "Māṃsa", "the day", "Navel",
             "churn — the all-agitating. The air will not settle", 0x2a0c06, 0.021),
            (4, "Sarvasaubhāgyadāyaka", "Diamond", "Medas", "lunar fortnight", "Heart",
             "light split — three spectra crawling over glossy ground", 0x0b1219, 0.014),
            (5, "Sarvārthasādhaka", "Emerald", "Asthi", "lunar month", "Throat",
             "the world has bones; light arrives only in shafts between ribs", 0x06180e, 0.018),
            (6, "Sarvarakṣākara", "Ruby", "Majjā", "season", "Forehead",
             "nothing is lit from outside — every solid glows from within", 0x1a0409, 0.022),
            (7, "Sarvarogahara", "Pearl", "Śukra", "solar half-year", "Crown",
             "sourceless — luminous fog and no shadow anywhere", 0xd8d2c4, 0.034),
            (8, "Sarvasiddhiprada", "Cat's eye", "Ojas", "year", "Above crown",
             "one travelling band of light; everything else waits in the dark", 0x0f0b04, 0.015),
            (9, "Sarvānandamaya", "All gems", "Tejas", "kāla–akāla", "Totality",
             "every gem at once, which is the same as no weather at all", 0x141008, 0.009),
        ]
        var out: [Int: HomeWorld] = [:]
        for row in rows {
            guard let character = ringCharacter[row.n] else { continue }
            out[row.n] = HomeWorld(ring: row.n, name: row.name, gem: row.gem,
                                   dhatu: row.dhatu, clock: row.clock,
                                   region: row.region, weather: row.weather,
                                   fog: FogColor(hex: row.fog),
                                   fogDensity: row.density,
                                   character: character)
        }
        return out
    }()

    // MARK: - Lookup

    /// The character of ring 1–9, or `nil` outside it. Callers guard; nothing
    /// here invents a tenth āvaraṇa.
    static func character(ring: Int) -> RingCharacter? { ringCharacter[ring] }

    /// The world of ring 1–9 as Design authored it, or `nil` outside it.
    static func world(ring: Int) -> HomeWorld? { worlds[ring] }

    // MARK: - The live base overlays the table (law 1)

    /// The four strings the āvaraṇa row owns in Airtable. Every one optional:
    /// the base may not have been reached, and a field may be empty. Absent and
    /// empty both mean "the base has nothing to say here", and the authored
    /// value stands — degrade by guarding empties, never by blanking.
    struct LiveFacts: Equatable {
        var sanskritName: String?
        var presidingForm: String?
        var yogini: String?
        var mentalState: String?

        init(sanskritName: String? = nil, presidingForm: String? = nil,
             yogini: String? = nil, mentalState: String? = nil) {
            self.sanskritName = sanskritName
            self.presidingForm = presidingForm
            self.yogini = yogini
            self.mentalState = mentalState
        }
    }

    /// The live āvaraṇa row, reduced to the four strings this layer reads.
    static func liveFacts(from avarana: Avarana) -> LiveFacts {
        LiveFacts(sanskritName: avarana.sanskritName,
                  presidingForm: avarana.presidingForm,
                  yogini: avarana.yogini,
                  mentalState: avarana.mentalState)
    }

    /// The world of ring 1–9 with the live base laid over the authored table.
    ///
    /// Law 1: Airtable is the source of truth for all names and content. Where
    /// Design's JavaScript and the synced row disagree on the āvaraṇa's name,
    /// its presiding Form, its Yoginī class or its mental state, the row wins.
    /// Where the row is silent, Design's value stands rather than a blank.
    static func world(ring: Int, live: LiveFacts?) -> HomeWorld? {
        guard let base = world(ring: ring) else { return nil }
        guard let live else { return base }

        let character = RingCharacter(
            ring: base.character.ring,
            form: preferring(live.presidingForm, over: base.character.form),
            phase: base.character.phase,
            yogini: preferring(live.yogini, over: base.character.yogini),
            veil: base.character.veil,
            state: preferring(live.mentalState, over: base.character.state),
            tempo: base.character.tempo,
            verb: base.character.verb,
            bija: base.character.bija
        )
        return HomeWorld(ring: base.ring,
                         name: preferring(live.sanskritName, over: base.name),
                         gem: base.gem, dhatu: base.dhatu, clock: base.clock,
                         region: base.region, weather: base.weather,
                         fog: base.fog, fogDensity: base.fogDensity,
                         character: character)
    }

    /// The live string when it carries something; the authored one otherwise.
    private static func preferring(_ live: String?, over authored: String) -> String {
        guard let live else { return authored }
        let trimmed = live.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? authored : trimmed
    }

    // MARK: - The two clocks

    /// The world's clock, scaled by the ring's tempo.
    ///
    /// This is the **only** clock tempo touches. It drives the world's weather —
    /// the day–night swing at the Feet, the year's meridian above the crown —
    /// and nothing else. Outside 1…9 the raw time is returned unscaled.
    static func worldClock(_ seconds: TimeInterval, ring: Int) -> TimeInterval {
        guard let tempo = ringCharacter[ring]?.tempo else { return seconds }
        return seconds * tempo
    }

    /// The room's adaptation clock — returned **unscaled, always**.
    ///
    /// Deliberately an identity function with a name, so that a room reaching
    /// for "the clock" cannot reach the tempo by accident. Tempo belongs to the
    /// weather. The adaptation clock belongs to ``HomeMemory``: the first
    /// adaptation at 62 seconds, the hold's end at 227, the second at 347.
    ///
    /// Conflating the two would let a slow ring hand the walker a cheaper
    /// second adaptation than a fast one — a depth bought by which āvaraṇa she
    /// happened to be standing in rather than by how long she stayed. That is
    /// the never-measure law (charter §2.2) at the timing layer, and it is why
    /// this function exists and why it does nothing.
    static func adaptationClock(_ seconds: TimeInterval, ring: Int) -> TimeInterval {
        _ = ring
        return seconds
    }
}
