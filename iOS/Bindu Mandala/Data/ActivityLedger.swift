import Foundation

// MARK: - App Activity ledger (pure vocabulary, payload, formulas, mappers)

/// The shared **App Activity** table (`tblJlBeiHnqGpYrL7`, same base as the
/// Mandala) is the body-wide ledger every Bindu instrument writes to. Ruling
/// of 2026-09-07: **events belong in the ledger; the spine stays the spine.**
/// Every practice event — a recognition from any screen, a new-deepest ring
/// crossing, the silence dwell, a letter written — is one row here and nowhere
/// else, with the practitioner's words in the ledger's own `Notes`. The Mandala
/// table keeps definitions plus per-Śakti state (Last Felt, Recognition Count,
/// Letter, Status — the PATCHes are untouched).
///
/// Everything in this file is pure: names, payload shapes, formulas and the
/// restore mappers. No network, no SwiftData, no UserDefaults — so all of it
/// is unit-tested without a token. `AirtableService` owns the HTTP.
///
/// Conventions the ledger keeps (body-wide):
///   • `Activity Type` is a past-participle verb phrase; options are additive.
///   • `Activity Date` is the practitioner's *local* calendar day of the event.
///   • `Felt At` is the exact instant, second precision `…Z` — the very string
///     `RecognitionDedup.writtenFeltAt` produces, so the Shakti-row
///     idempotency guard (Last Felt equals this second) keeps matching.
///   • `Notes` is the practitioner's text — written only when non-blank, never
///     metadata. Nothing here composes a Notes value.
///   • The table is addressed by field *names* throughout (writes, formulas,
///     and reads without `returnFieldsByFieldId`).
enum ActivityLedger {

    /// App Activity, base `app248ZTWhYJlvQj2`.
    static let tableId = "tblJlBeiHnqGpYrL7"

    /// This instrument's `Source App` option.
    static let sourceApp = "Mandala"

    // MARK: Field names (meta ids in the doc comments)

    enum Field {
        /// `fldqAZ3xmkQwHaJQm` — primary field.
        static let activityName  = "Activity Name"
        /// `fldHPuwmYPa3Ry91q` — singleSelect (Learning · Mandala · Field · Feed · Being · Chakras · Mirror).
        static let sourceApp     = "Source App"
        /// `fldXNRBZy6QvIP8yz` — singleSelect; `Ring Crossed` / `Silence Held` are born by `typecast:true`.
        static let activityType  = "Activity Type"
        /// `fldMcikl2kbVRFv4G` — date (local calendar day, `yyyy-MM-dd`).
        static let activityDate  = "Activity Date"
        /// `fldFWURRpDmzcSAvl` — singleLineText.
        static let detail        = "Detail"
        /// `fldVyj4hkzxcrIBoJ` — multilineText; the practitioner's words.
        static let notes         = "Notes"
        /// `fldzsEMInQmNIxTNu` — link to the Mandala table (her Shakti row, or the Avaraṇa row).
        static let linkToMandala = "Link to Mandala"

        // The six event fields, created 2026-09-07 via the Airtable MCP (plan step 0).

        /// `fldWAR0B4pNxjTwEJ` — dateTime, stored UTC, displayed America/New_York; written second-precision `…Z`.
        static let feltAt        = "Felt At"
        /// `fldJc7iCzxZOSdO4D` — number, precision 0 — synodic day 1…30.
        static let lunarDay      = "Lunar Day"
        /// `fldMpjvAsT64v85bh` — singleLineText — "Waning Crescent" etc.
        static let moonPhase     = "Moon Phase"
        /// `fldP3wq8QTgxeTDuC` — singleSelect: Today `selGxDFvn0Yu7W1qJ` · Mandala `selo5F9IaokSkEbLK`
        /// · Well `sel8WmHGvD9CYnSEk` · Silence `selZX7daPpNj7dAMI` (named apart from `Source App`).
        static let gestureSource = "Gesture Source"
        /// `fldi7SOuep57UoXzi` — number, precision 0 — the ring crossed into (1…9).
        static let descentRing   = "Descent Ring"
        /// `fldrIOx1id7Esm2fd` — number, precision 2 — how long the silence was held.
        static let durationSec   = "Duration (sec)"
        /// `fldkF65ySNGGkeugH` — multipleRecordLinks to The Map (`tblwpmyKOeMxEEHd7`),
        /// reverse `fldxl5Ez0Btgi8uoR`. Wave 6: a chakra-level act names its
        /// chakra here, by the Map record id the bake carries.
        static let linkToMap     = "Link to The Map"
    }

    // MARK: Activity Type options

    enum ActivityType {
        /// Every recognition — the first *is* the milestone; later ones are "felt again".
        static let shaktiRecognized = "Shakti Recognized"
        /// The first letter written for a Śakti (unchanged from build 36).
        static let letterWritten    = "Letter Written"
        /// Each new-deepest descent crossing (`DescentState.enter → true`).
        static let ringCrossed      = "Ring Crossed"
        /// The R11 silence dwell.
        static let silenceHeld      = "Silence Held"
        /// Once ever: the 102nd Śakti felt for the first time.
        static let fullCircle       = "Full Circle"
        /// Once ever: a second adaptation reached, in any room.
        static let firstDwelling    = "First Dwelling"
        /// A note the practitioner left in the margin of the instrument — an
        /// idea, a wish, something broken. Born on first write by
        /// `typecast: true`, as `Ring Crossed` and `Silence Held` were.
        ///
        /// **Not `Note Written`.** `Letter Written` already owns "written", and
        /// a letter is to *her* while a note is to the instrument; two
        /// near-identical types would be read as the same thing by every other
        /// Bindu instrument that shares this ledger. "Left" is his own verb:
        /// *"go into the settings and leave a note."*
        static let noteLeft         = "Note Left"
        /// Wave 2 · the Gates of Release. Going inward through an āvaraṇa he
        /// sets down its Mental State — the act is the row, the words are the
        /// ring's own. Born on first write by `typecast: true`.
        static let stateSetDown     = "State Set Down"
        /// Wave 2 · coming out through an āvaraṇa he receives its Siddhi.
        /// Born on first write by `typecast: true`.
        static let siddhiReceived   = "Siddhi Received"
        /// Wave 4 · Play. One game played at a Śakti's address (or a ring's, or
        /// a threshold's), linked to her row — or to the Avaraṇa row when the
        /// game lives at the level of a whole ring. Born on first write by
        /// `typecast: true`. **Storage may count; the screen may not**: the row
        /// carries how long the game was played in `Duration (sec)`, and nothing
        /// about it is ever shown to him.
        static let played           = "Played"

        // Wave 5 · memory and words. All born on first write by `typecast: true`.

        /// A river letter set down — sealed forward to her day, or sent back to
        /// a moment. One row per letter; his words ride in `Notes` so the
        /// ledger, like everywhere else, holds the practitioner's own text.
        static let letterSealed     = "Letter Sealed"
        /// A sealed letter opened on its day.
        static let letterOpened     = "Letter Opened"
        /// One sitting at the Portrait — his strokes mirrored by the ring.
        static let portraitDrawn    = "Portrait Drawn"
        /// A watch for her answered: "watch for her today… did she appear?"
        /// Wave 6 (C-1195): now only "she appeared", noticed in passing when
        /// he wishes — nothing asks.
        static let wagerResolved    = "Wager Resolved"

        // Wave 6 · modes, rites and his laws. All born on first write by
        // `typecast: true`; builders in `ActivityLedgerRites.swift`.

        /// His own perspective, written beside her sealed witness page (C-1280).
        /// His words ride in `Notes`.
        static let witnessWritten   = "Witness Written"
        /// The Khaḍgamālā recited — Sādhana, the 102 names in turn.
        static let garlandRecited   = "Garland Recited"
        /// The day offered at evening — Pūjā.
        static let dayOffered       = "Day Offered"
        // Wave 6 · B · the game's own structure. Both born on first write by
        // `typecast: true`.

        /// A Leela drop came and was answered — carried into the day, or held
        /// in silence. Either is the same act; the row says which and grades
        /// nothing. Rare by construction (``LeelaDrops``).
        static let leelaDrop        = "Leela Drop"
        /// Knowledge, Will and Action closed in her room — the activation
        /// cycle (master brief §4). *"Light is what enters when these three
        /// close."* Linked to her row; how long it took is the archive's, never
        /// his.
        static let lightEntered     = "Light Entered"
        /// Wave 6 · the 33 alive. One practice walked in a chakra's room — its
        /// gate, or a held movement or breath — linked to its chakra in `Link
        /// to The Map` (and to her seat or its ring in `Link to Mandala` when it
        /// has one). Born on first write by `typecast: true`. His words, when
        /// he gives any, ride in `Notes`; nothing here composes them.
        static let chakraPracticed  = "Chakra Practiced"
        // Wave 6 · memory and the sister apps. Born on first write by `typecast: true`.

        /// Light — appreciation — sent back to a moment he felt lost (C-1126).
        /// Linked to the Śakti whose light was sent; his few words, if any, in
        /// `Notes`; the moment itself in `Detail`, so it survives a reinstall.
        static let lightSentBack    = "Light Sent Back"
        /// The name his higher self gave, kept in Bindu memory (C-1325). Linked
        /// to the point's own row (kp 102); the name, his words, in `Notes`.
        static let nameKept         = "Name Kept"
    }

    // MARK: - The two once-ever milestones

    /// The two milestones Build Brief v2 puts in Phase 3.6 — and only the two.
    ///
    /// The brief named three. **`Deepest Ring Reached` is dropped**, and the
    /// reasoning is in `DECISIONS.md` under the charter's §4 table: `Ring
    /// Crossed` already fires once per new-deepest ring (`DescentState.enter`
    /// returns `true` only on a crossing that goes deeper than any before it),
    /// so a `Deepest Ring Reached` row would duplicate it exactly, row for row
    /// and instant for instant.
    ///
    /// Both of the survivors are **once ever, not once per anything**, which is
    /// a different guard from every other row in this file: a recognition is
    /// once per gesture, a `Silence Held` is once per visit, a `Letter Written`
    /// is once per Śakti. These are once in a practice. A local flag alone
    /// cannot carry that — it is per-install, so a reinstall or a second device
    /// would log the milestone again, which is exactly what the letter ledger
    /// did until §0.6's server-derived reconcile. So each of these carries the
    /// same two-part guard the letter has: a local set, and a read of the
    /// ledger's own view that unions into it
    /// (`AirtableService.reconcileLedgeredMilestones`).
    ///
    /// Neither is ever shown. They are rows in the archive, and law 2 means the
    /// walker is never told that his circle closed or that he dwelt for the
    /// first time — the instrument knows; he does not get a score.
    enum Milestone: String, CaseIterable, Equatable {
        /// The 102nd first-felt: every seat of the khaḍgamālā has been stood in.
        case fullCircle
        /// The first time any room's second adaptation was reached.
        case firstDwelling

        /// Its `Activity Type` option, born on first write by `typecast: true`.
        var activityType: String {
            switch self {
            case .fullCircle:   return ActivityType.fullCircle
            case .firstDwelling: return ActivityType.firstDwelling
            }
        }
    }

    /// How many Śaktis have to have been felt for the circle to have closed:
    /// all of them. Read off ``KhadgamalaMap`` rather than typed, because the
    /// number of seats is that file's fact and not this one's.
    static var fullCircleAt: Int { KhadgamalaMap.total }

    /// Has the circle closed? `felt` is how many **distinct** Śaktis the ledger
    /// holds a `Shakti Recognized` row for, counted *after* this gesture's row.
    ///
    /// `>=` and not `==`: a base that somehow held 103 would otherwise never
    /// close the circle at all, and a milestone that can be missed by a stray
    /// row is worse than one that fires a row late.
    static func isFullCircle(felt: Int) -> Bool { felt >= fullCircleAt }

    /// A `Full Circle` row, linked to the Śakti whose first recognition closed
    /// it. No Notes, no count anywhere in the words — *every seat* is a fact
    /// about the khaḍgamālā, not a number about him.
    static func fullCircle(shaktiRecordId: String, name shaktiName: String,
                           at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "A Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.fullCircle,
            linkRecordId: shaktiRecordId,
            name: "The khaḍgamālā — come full circle",
            detail: "Every seat has been felt · closed at \(name) · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.mandala,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at)
        )
    }

    /// A `First Dwelling` row, linked to the Śakti in whose room the second
    /// adaptation was first reached. `Duration (sec)` carries the chamber clock
    /// it was reached on — the archive's own record of how long it took, and
    /// never a thing the walker is shown.
    static func firstDwelling(shaktiRecordId: String, name shaktiName: String,
                              chamberTime: Double, at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "A Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.firstDwelling,
            linkRecordId: shaktiRecordId,
            name: "\(name) — the first dwelling",
            detail: "A second adaptation reached · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.silence,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            durationSec: chamberTime
        )
    }

    /// `Gesture Source` options — where the gesture originated.
    enum GestureSource {
        static let today   = "Today"
        static let mandala = "Mandala"
        static let field   = "Field"     // born by typecast on first write
        static let room    = "Room"      // born by typecast on first write
        static let well    = "Well"
        static let silence = "Silence"
        static let play    = "Play"      // Wave 4 — born by typecast on first write
    }

    // MARK: - Builders

    /// A `Shakti Recognized` row. The first recognition of a Śakti is the
    /// milestone (no second row): first vs return is decided from the Shakti
    /// row's count read before the create — see `wasFirst`.
    static func recognition(_ moment: RecognitionMoment,
                            shaktiName: String,
                            isFirst: Bool) -> PendingActivity {
        let name = shaktiName.isEmpty ? "A Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.shaktiRecognized,
            linkRecordId: moment.shaktiRecordId,
            name: isFirst ? "\(name) — first recognition" : "\(name) — felt again",
            detail: isFirst ? "Felt here for the first time · \(moment.moonPhase)"
                            : "Felt here again · \(moment.moonPhase)",
            at: moment.feltAt,
            gestureSource: moment.source,
            lunarDay: moment.lunarDay,
            moonPhase: moment.moonPhase,
            notes: moment.note
        )
    }

    /// A `Ring Crossed` row for a new-deepest crossing into `ring`, linked to
    /// the Avaraṇa row. Subsumes R16's "Deepest Ring Reached".
    static func crossing(ring: Int, feltAt: Date) -> PendingActivity {
        PendingActivity(
            type: ActivityType.ringCrossed,
            linkRecordId: AirtableService.avaranaRecordId(forRing: ring) ?? "",
            name: "\(ordinal(ring)) Āvaraṇa — crossed",
            detail: "Fell inward to the \(Avarana.enclosureForm(forRing: ring)) · \(LunarPhaseService.phaseName(at: feltAt))",
            at: feltAt,
            gestureSource: GestureSource.mandala,
            descentRing: ring
        )
    }

    /// The words of a `Letter Written` row — the first letter written for a
    /// Śakti, unchanged from build 36.
    ///
    /// `AirtableService.saveLetter` owns the *when* (the `ledgeredLetters`
    /// guard, the record id, the instant); this owns the *words*, so the felt
    /// register can read the very strings that ship instead of a copy of them.
    /// Kept as name + detail rather than a `PendingActivity` because the letter
    /// path logs through `logActivity(type:linkedShaktiRecordId:…)` and carries
    /// no moon or lunar day.
    static func letterWritten(shaktiName: String) -> (name: String, detail: String) {
        let name = shaktiName.isEmpty ? "a Śakti" : shaktiName
        return (name: "A letter to \(name)", detail: "First letter written")
    }

    /// A `Silence Held` row for the R11 dwell, linked to her Shakti row. No
    /// Notes, and the caller issues no Shakti PATCH for it.
    static func silence(shaktiRecordId: String,
                        name shaktiName: String,
                        durationSec: Double,
                        at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "A Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.silenceHeld,
            linkRecordId: shaktiRecordId,
            name: "\(name) — silence held",
            detail: "Dwelt past the first adaptation · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.silence,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            durationSec: durationSec
        )
    }

    // MARK: - Wave 2 · the Gates of Release, and Mauna

    /// A `State Set Down` row: going inward, he held and offered this
    /// āvaraṇa's Mental State. Linked to the Avaraṇa row; the words are the
    /// ring's own (`Mental State`), never his and never generated. No Notes.
    ///
    /// Wave 6 (C-1230, *"it has to be something to get, not something to give
    /// up"*): the gate is an offering, and the row says so. The type keeps its
    /// name — the ledger's vocabulary is a record other instruments read, and
    /// every earlier row carries it.
    static func stateSetDown(ring: Int, state: String, at: Date) -> PendingActivity {
        let words = state.trimmingCharacters(in: .whitespacesAndNewlines)
        let said = words.isEmpty ? "Offered at the gate" : "Offered · \(words)"
        return PendingActivity(
            type: ActivityType.stateSetDown,
            linkRecordId: AirtableService.avaranaRecordId(forRing: ring) ?? "",
            name: "\(ordinal(ring)) Āvaraṇa — offered",
            detail: "\(said) · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.mandala,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            descentRing: ring
        )
    }

    /// A `Siddhi Received` row: coming out, he received this āvaraṇa's
    /// Siddhi. Linked to the Avaraṇa row; the words are the ring's own.
    static func siddhiReceived(ring: Int, siddhi: String, at: Date) -> PendingActivity {
        let words = siddhi.trimmingCharacters(in: .whitespacesAndNewlines)
        let said = words.isEmpty ? "Received on the way out" : "Received · \(words)"
        return PendingActivity(
            type: ActivityType.siddhiReceived,
            linkRecordId: AirtableService.avaranaRecordId(forRing: ring) ?? "",
            name: "\(ordinal(ring)) Āvaraṇa — received",
            detail: "\(said) · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.mandala,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            descentRing: ring
        )
    }

    /// Mauna — the silence held at the point. Its own `Silence Held` row,
    /// linked to the Śakti who sits at the point (Lalitā, kp 102), and never a
    /// recognition: a silence is not "felt" (Wave 0 · B3). `Duration (sec)` is
    /// the archive's record of how long it was held, and is never shown.
    static func mauna(shaktiRecordId: String,
                      name shaktiName: String,
                      durationSec: Double,
                      at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "The point" : shaktiName
        return PendingActivity(
            type: ActivityType.silenceHeld,
            linkRecordId: shaktiRecordId,
            name: "\(name) — mauna, the silence at the point",
            detail: "Held at the centre · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.silence,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            durationSec: durationSec
        )
    }

    // MARK: - Play (Wave 4)

    /// A `Played` row: one game, played at its address. `place` is what the
    /// game was played *at* — her name, or "Fourth Āvaraṇa", or the Shadow
    /// crossing — and `game` is the game's own name. `seconds` is how long it
    /// was played: a fact the archive keeps and the walker is never shown.
    /// No Notes: words a game sets down are released from the view; the act
    /// stays in the record, and the act is this row.
    static func played(game: String,
                       place: String,
                       linkRecordId: String,
                       seconds: Double,
                       at: Date) -> PendingActivity {
        let site = place.isEmpty ? "Lalitā's field" : place
        return PendingActivity(
            type: ActivityType.played,
            linkRecordId: linkRecordId,
            name: "\(site) — played",
            detail: "\(game) · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.play,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            durationSec: max(0, seconds)
        )
    }

    // MARK: - Wave 6 · the 33 alive

    /// A `Chakra Practiced` row: one practice walked in a chakra's room.
    ///
    /// `mapRecordId` is the chakra's own Map record — it fills `Link to The
    /// Map`, which is how the ledger knows *which* of the 33 (and is the dedup
    /// key when nothing in the Mandala table stands for it: the two
    /// thresholds). `mandalaLink` is her Shakti row for a seated chakra or the
    /// Avaraṇa row for a ring-level one, or empty. `practice` is the practice's
    /// own name ("the gate", "Ham · Het · Hum" …). `words` are his — the
    /// offering, or the memory he chose to keep — and go to `Notes` untouched.
    static func chakraPracticed(mapRecordId: String,
                                chakraName: String,
                                practice: String,
                                mandalaLink: String,
                                words: String?,
                                seconds: Double?,
                                at: Date) -> PendingActivity {
        let name = chakraName.isEmpty ? "A chakra" : chakraName
        let what = practice.isEmpty ? "practiced in its room" : practice
        var row = PendingActivity(
            type: ActivityType.chakraPracticed,
            linkRecordId: mandalaLink,
            name: "\(name) — practiced",
            detail: "\(what) · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.mandala,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            durationSec: seconds.map { max(0, $0) },
            notes: words
        )
        row.linkToMap = mapRecordId.isEmpty ? nil : [mapRecordId]
        return row
    }

    /// The ledger columns the Map-keyed dedup reads: the Map link and the
    /// instant — the same shape as `RecognitionDedup.readFields`, which four
    /// other call sites share and so is deliberately not widened.
    static let mapDedupFields = [Field.linkToMap, Field.feltAt]

    /// True only when the row links `mapRecordId` in `Link to The Map` *and*
    /// carries `feltAt` to the second — the key the create wrote, which a
    /// queued retry repeats and a genuine second practice never can.
    static func mapRowMatches(_ row: Row, mapRecordId: String, feltAt: Date) -> Bool {
        RecognitionDedup.rowMatches(links: row.fields.linkToMap,
                                    feltAt: row.fields.feltAt,
                                    linkRecordId: mapRecordId,
                                    feltAt: feltAt)
    }

    // MARK: - The margin

    /// The `Activity Name` every note carries — a **constant**, the same on
    /// every row.
    ///
    /// The obvious alternative was the note's first line, so the ledger's
    /// primary column would be scannable in Airtable, and it is refused for a
    /// reason that is not cosmetic: his words would then flow into a *composed*
    /// ledger string, and `HomesHarnessTests` runs Design's nine MEASURING
    /// patterns over exactly those. A note that happened to read "day 3 of this"
    /// would fail the harness, and the only ways out would be weakening the
    /// harness or censoring his sentence. This file's own convention already
    /// settles it — *"`Notes` is the practitioner's text … never metadata.
    /// Nothing here composes a Notes value."* His words live in one field, and
    /// are never quoted into another.
    static let noteLeftName = "A note left in the instrument"

    /// A `Note Left` row. **No link**: a note is about the app, not about a
    /// Śakti, so `Link to Mandala` is empty and `fields(for:)` omits the key.
    /// **No `Gesture Source`**: those four options name where a gesture *toward
    /// a Śakti* began, and a note is not one; a fifth option would dilute a
    /// vocabulary other instruments read. The moon is carried because it is
    /// free, pure and invisible to him, and it lets a note be found beside
    /// whatever practice surrounded it.
    ///
    /// `at` is the note's own `createdAt` and never the flush time.
    static func noteLeft(body: String, at: Date) -> PendingActivity {
        PendingActivity(
            type: ActivityType.noteLeft,
            linkRecordId: "",
            name: noteLeftName,
            detail: "Left in the instrument · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            notes: body
        )
    }

    // MARK: - Wave 5 · memory and words

    /// A river letter set down. Forward letters are "sealed"; back letters are
    /// "sent back". Linked to her Shakti row, so the create-time dedup (type +
    /// link + `Felt At` to the second) keeps a retried POST to one row. `Notes`
    /// carries his words — the ledger is the one place they are kept off the
    /// phone — and nothing here composes them.
    static func letterSealed(shaktiRecordId: String, name shaktiName: String,
                             forward: Bool, opensOn: String?, body: String,
                             at: Date, to recipient: String? = nil,
                             moment: Date? = nil) -> PendingActivity {
        let her = shaktiName.isEmpty ? "a Śakti" : shaktiName
        // Wave 6 · a letter may go to an age, a memory or a self — still held
        // in her river, so still linked to her row.
        let name = (recipient ?? "").isEmpty ? her : (recipient ?? her)
        let detail: String
        if forward {
            let when = (opensOn ?? "").isEmpty ? "her day" : (opensOn ?? "her day")
            detail = "Sealed forward · opens on \(when)"
        } else if let moment {
            // The moment, written as the ledger writes every instant, so the
            // letter returns to it after a reinstall.
            detail = "Sent back to a moment · \(RecognitionDedup.writtenFeltAt(moment)) · \(LunarPhaseService.phaseName(at: at))"
        } else {
            detail = "Sent back to a moment · \(LunarPhaseService.phaseName(at: at))"
        }
        return PendingActivity(
            type: ActivityType.letterSealed,
            linkRecordId: shaktiRecordId,
            name: forward ? "A letter to \(name) — sealed" : "A letter to \(name) — sent back",
            detail: detail,
            at: at,
            gestureSource: GestureSource.well,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            notes: body
        )
    }

    /// A sealed letter opened on its day. No Notes: the words went in once,
    /// with the seal.
    static func letterOpened(shaktiRecordId: String, name shaktiName: String,
                             at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "a Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.letterOpened,
            linkRecordId: shaktiRecordId,
            name: "A letter to \(name) — opened",
            detail: "Opened on its day · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.well,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at)
        )
    }

    /// One sitting at the Portrait, linked to the Avaraṇa row of the ring most
    /// drawn in. No count of strokes anywhere — a sitting is one act.
    static func portraitDrawn(ring: Int, at: Date) -> PendingActivity {
        PendingActivity(
            type: ActivityType.portraitDrawn,
            linkRecordId: AirtableService.avaranaRecordId(forRing: ring) ?? "",
            name: "The Portrait — drawn in the \(ordinal(ring)) Āvaraṇa",
            detail: "Strokes mirrored by the ring · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at)
        )
    }

    /// A watch for her, answered. Either answer is the same act of having
    /// watched; the words say what he said and grade nothing.
    static func wagerResolved(shaktiRecordId: String, name shaktiName: String,
                              appeared: Bool, at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "A Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.wagerResolved,
            linkRecordId: shaktiRecordId,
            // Wave 6 (C-1195): noticed in passing, never watched for.
            name: appeared ? "\(name) — noticed in passing" : "\(name) — left open",
            detail: (appeared ? "She appeared" : "Watched for, and left open")
                + " · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at)
        )
    }

    // MARK: - Wave 6 · B · the game's own structure

    /// A `Leela Drop` row. `chakra` is the Map row the drop's words were drawn
    /// from (provenance); `carried` is whether he took the action into his day
    /// or held the moment in silence — both are answers, neither is a grade.
    /// No link (The Map is not the Mandala table) and no Notes: the words were
    /// the game's, not his.
    static func leelaDrop(chakra: String, carried: Bool, at: Date) -> PendingActivity {
        let site = chakra.isEmpty ? "The play" : chakra
        return PendingActivity(
            type: ActivityType.leelaDrop,
            linkRecordId: "",
            name: "Leela — a drop from \(site)",
            detail: (carried ? "Carried into the day" : "Held in silence")
                + " · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at)
        )
    }

    /// A `Light Entered` row: the activation cycle closed in her room —
    /// Knowledge, Will, Action. `family` is the gesture family her element
    /// asked for ("fire", "water", … or "presence" where no gesture was asked).
    /// `seconds` is the archive's record of the cycle and is never shown.
    static func lightEntered(shaktiRecordId: String, name shaktiName: String,
                             family: String, seconds: Double, at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "A Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.lightEntered,
            linkRecordId: shaktiRecordId,
            name: "\(name) — knowledge, will, action",
            detail: "\(family) · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.room,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            durationSec: max(0, seconds)
        )
    }

    // MARK: - Wave 6 · light sent back, and the name kept

    /// Light sent back to a moment he felt lost. Linked to her row (the Śakti
    /// whose light he sent); the moment in `Detail`, as the ledger writes every
    /// instant; his words — if he set any beside the light — in `Notes`.
    static func lightSentBack(shaktiRecordId: String, name shaktiName: String,
                              moment: Date, words: String?, at: Date) -> PendingActivity {
        let name = shaktiName.isEmpty ? "a Śakti" : shaktiName
        return PendingActivity(
            type: ActivityType.lightSentBack,
            linkRecordId: shaktiRecordId,
            name: "Light sent back — through \(name)",
            detail: "To a moment once lost · \(RecognitionDedup.writtenFeltAt(moment)) · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            gestureSource: GestureSource.well,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            notes: words
        )
    }

    /// The name his higher self gave, kept. Linked to the point's row; the name
    /// itself in `Notes` and nowhere else.
    static func nameKept(pointRecordId: String, name: String, at: Date) -> PendingActivity {
        PendingActivity(
            type: ActivityType.nameKept,
            linkRecordId: pointRecordId,
            name: "A name kept in Bindu memory",
            detail: "Kept at the point · \(LunarPhaseService.phaseName(at: at))",
            at: at,
            lunarDay: LunarPhaseService.currentDay(at: at),
            moonPhase: LunarPhaseService.phaseName(at: at),
            notes: name
        )
    }

    /// Who a river letter is to, in the ledger's words. `nil` means her.
    static func recipientWords(_ r: RiverRecipient?) -> String? {
        guard let r else { return nil }
        switch r.kind {
        case .her:       return nil
        case .memory:    return "a memory"
        case .pastSelf:  return "his past self"
        case .laterSelf: return "his later self"
        case .age:
            guard let a = r.age, a >= 0 else { return "himself, at an age" }
            return "himself at \(spelled(a))"
        }
    }

    /// The reverse of ``recipientWords(_:)`` — a restored letter's recipient.
    /// `nil` for her (or for words it does not know).
    static func recipient(fromWords words: String) -> RiverRecipient? {
        switch words {
        case "a memory":           return RiverRecipient(kind: .memory)
        case "his past self":      return RiverRecipient(kind: .pastSelf)
        case "his later self":     return RiverRecipient(kind: .laterSelf)
        case "himself, at an age": return RiverRecipient(kind: .age)
        default:
            let prefix = "himself at "
            guard words.hasPrefix(prefix) else { return nil }
            let rest = String(words.dropFirst(prefix.count))
            let f = NumberFormatter()
            f.locale = Locale(identifier: "en_US")
            f.numberStyle = .spellOut
            guard let n = f.number(from: rest)?.intValue else { return RiverRecipient(kind: .age) }
            return RiverRecipient(kind: .age, age: n)
        }
    }

    /// A whole number in words ("nine", "forty-two") — an age is spoken, never
    /// written as a figure in a composed line.
    static func spelled(_ n: Int) -> String {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US")
        f.numberStyle = .spellOut
        return f.string(from: NSNumber(value: n)) ?? "an age"
    }

    // MARK: - Wave 6 · the river, restored from the ledger

    /// Every row the river's restore reads: its four acts.
    static var restoreRiver: String {
        let types = [ActivityType.letterSealed, ActivityType.letterOpened,
                     ActivityType.lightSentBack, ActivityType.nameKept]
        return and([isMandala, "OR(" + types.map { isType($0) }.joined(separator: ", ") + ")"])
    }

    /// An instant written by ``RecognitionDedup/writtenFeltAt(_:)``, found
    /// anywhere inside a composed `Detail`.
    static func instant(in detail: String?) -> Date? {
        guard let detail else { return nil }
        let pattern = #"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z"#
        guard let range = detail.range(of: pattern, options: .regularExpression) else { return nil }
        return serverDate(String(detail[range]))
    }

    /// Ledger rows → river letters, oldest first, each one already ledgered (it
    /// came *from* the ledger). `byRecord` maps a Shakti record id to her
    /// position. A row with no words (a voice-only letter, whose sound lived
    /// only on the phone) or no known link is skipped — never invented.
    ///
    /// A forward letter's day is found again from its opening and the instant
    /// it was sealed (the real moon is deterministic); a back letter returns to
    /// the moment its `Detail` names, or — written before Wave 6 — to the day it
    /// was sent. A `Letter Opened` row on the same link, on or after the day,
    /// opens the earliest such letter.
    static func riverLetters(from rows: [Row], byRecord: [String: Int],
                             now: Date = .now,
                             timeZone: TimeZone = .current) -> [RiverLetter] {
        var openings: [String: [Date]] = [:]
        for row in rows where row.fields.activityType == ActivityType.letterOpened {
            guard let link = row.fields.linkToMandala?.first,
                  let at = serverDate(row.fields.feltAt) else { continue }
            openings[link, default: []].append(at)
        }
        for k in Array(openings.keys) { openings[k]?.sort() }

        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = timeZone
        let sealedRows = rows
            .filter { $0.fields.activityType == ActivityType.letterSealed }
            .sorted { (serverDate($0.fields.feltAt) ?? .distantPast) < (serverDate($1.fields.feltAt) ?? .distantPast) }

        var out: [RiverLetter] = []
        for row in sealedRows {
            let body = (row.fields.notes ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !body.isEmpty,
                  let link = row.fields.linkToMandala?.first,
                  let kp = byRecord[link],
                  let written = serverDate(row.fields.feltAt)
                    ?? legacyTimestamp(activityDate: row.fields.activityDate, timeZone: timeZone)
            else { continue }
            let detail = row.fields.detail ?? ""
            let forward = detail.hasPrefix("Sealed forward")
            var letter = RiverLetter(id: UUID(), khadgamalaPosition: kp,
                                     direction: forward ? .forward : .back,
                                     body: body, writtenAt: written,
                                     addressedTo: written, opening: nil, openedAt: nil,
                                     sealLedgeredAt: now, openLedgeredAt: nil)
            if let name = row.fields.activityName,
               name.hasPrefix("A letter to "),
               let dash = name.range(of: " — ", options: .backwards) {
                let start = name.index(name.startIndex, offsetBy: "A letter to ".count)
                if start <= dash.lowerBound {
                    letter.recipient = recipient(fromWords: String(name[start..<dash.lowerBound]))
                }
            }
            if forward {
                let opening = RiverLetter.Opening.allCases.first { detail.contains("opens on \($0.words)") }
                    ?? .purnima
                letter.opening = opening
                letter.addressedTo = RiverLetter.openingInstant(opening, khadgamalaPosition: kp,
                                                                after: written, calendar: cal)
                if var held = openings[link],
                   let i = held.firstIndex(where: { $0 >= letter.addressedTo.addingTimeInterval(-1) }) {
                    letter.openedAt = held[i]
                    letter.openLedgeredAt = now
                    held.remove(at: i)
                    openings[link] = held
                }
            } else {
                letter.addressedTo = min(instant(in: detail) ?? written, written)
                letter.openedAt = written
                letter.openLedgeredAt = now
            }
            out.append(letter)
        }
        return out
    }

    /// The key two copies of one river letter share: her position, the instant
    /// it was set down to the second, and its words.
    static func riverIdentity(_ letter: RiverLetter) -> String {
        "\(letter.khadgamalaPosition)\u{1F}" + RecognitionDedup.writtenFeltAt(letter.writtenAt)
            + "\u{1F}" + letter.body.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Which restored letters this phone does not already hold. Idempotent, so
    /// it may run on every sync; duplicates *within* the ledger collapse too.
    static func riverLettersMissingLocally(restored: [RiverLetter],
                                           local: [RiverLetter]) -> [RiverLetter] {
        var seen = Set(local.map { riverIdentity($0) })
        var out: [RiverLetter] = []
        for r in restored {
            let key = riverIdentity(r)
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            out.append(r)
        }
        return out
    }

    /// Ledger rows → lights sent back (the moment, her position, his words).
    static func lightsSentBack(from rows: [Row], byRecord: [String: Int],
                               now: Date = .now) -> [LightSentBack] {
        var out: [LightSentBack] = []
        for row in rows where row.fields.activityType == ActivityType.lightSentBack {
            guard let link = row.fields.linkToMandala?.first, let kp = byRecord[link],
                  let at = serverDate(row.fields.feltAt),
                  let moment = instant(in: row.fields.detail) else { continue }
            let words = (row.fields.notes ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            out.append(LightSentBack(id: UUID(), khadgamalaPosition: kp, moment: moment,
                                     words: words.isEmpty ? nil : words,
                                     sentAt: at, ledgeredAt: now))
        }
        return out.sorted { $0.sentAt < $1.sentAt }
    }

    /// The newest name kept, from the ledger — the name, and when.
    static func latestNameKept(from rows: [Row]) -> (name: String, at: Date)? {
        var best: (name: String, at: Date)? = nil
        for row in rows where row.fields.activityType == ActivityType.nameKept {
            guard let at = serverDate(row.fields.feltAt) else { continue }
            let name = (row.fields.notes ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty else { continue }
            if best == nil || at > best!.at { best = (name, at) }
        }
        return best
    }

    /// The ledger columns a note's idempotency check reads. Deliberately **not**
    /// a widening of `RecognitionDedup.readFields`, which four other call sites
    /// share: a note has no link to compare, and its body does the work the link
    /// does everywhere else.
    ///
    /// **Every column ``noteRowMatches`` reads is named here, and that is the
    /// whole point of the list.** `fields[]` is a narrowing: Airtable returns
    /// *only* what this array names, and `Row.Fields` decodes every key with
    /// `decodeIfPresent`, so a column left out arrives as `nil` in a row that
    /// plainly carries it on the server. It stood for one revision without
    /// `Activity Type` while `noteRowMatches` opened by requiring it — so the
    /// guard read `nil != "Note Left"` on every live row, the check could never
    /// return true, and the retry after a POST whose response was lost wrote his
    /// note to the ledger a second time. Every unit test was green throughout,
    /// because each of them hand-built a `Row` with the field already set.
    /// `ActivityLedgerTests.testTheDedupAsksForEveryColumnItsMatchThenReads`
    /// decodes the page the fetch actually receives, which is the only shape of
    /// test that could ever have seen it.
    static let noteDedupFields = [Field.activityType, Field.feltAt, Field.notes]

    /// Is this ledger row the same note? The key is `Activity Type` (already
    /// narrowed by the fetch) + `Felt At` to the second + the trimmed body.
    ///
    /// **The body is the disambiguator, and that is precisely why it is in the
    /// key.** Two notes a second apart with different words are two notes, and
    /// both are written — the key separates them. Two rows at the same second
    /// with the same words are not two notes; they are one note posted twice (a
    /// double-tapped save, or a retry after a POST whose response was lost), and
    /// collapsing them is the right answer. The guard is server-derived by
    /// construction, which is the shape the `Letter Written` wound taught the
    /// house to prefer over a per-install flag.
    static func noteRowMatches(_ row: Row, feltAt: Date, body: String) -> Bool {
        guard row.fields.activityType == ActivityType.noteLeft else { return false }
        guard let raw = row.fields.feltAt,
              let server = RecognitionDedup.normalizedServerFeltAt(raw),
              server == RecognitionDedup.writtenFeltAt(feltAt) else { return false }
        let mine = body.trimmingCharacters(in: .whitespacesAndNewlines)
        let theirs = (row.fields.notes ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return !mine.isEmpty && mine == theirs
    }

    /// The notes restore: every `Note Left` row this instrument wrote.
    static var restoreNotes: String {
        and([isMandala, isType(ActivityType.noteLeft)])
    }

    typealias RestoredNote = (createdAt: Date, body: String)

    /// Ledger rows → the practitioner's notes, oldest first — the path home
    /// after a reinstall or a store recovery, where the ledger holds every note
    /// and the phone holds none. `createdAt` comes from `Felt At`, falling back
    /// to noon of `Activity Date` for a row that somehow carries no instant;
    /// a row with neither, or with no words, is skipped and **never coerced to
    /// now** — a note dated today that he wrote in March would be a lie about
    /// his own margin.
    static func marginNotes(from rows: [Row],
                            timeZone: TimeZone = .current) -> [RestoredNote] {
        var out: [RestoredNote] = []
        for row in rows {
            guard row.fields.activityType == ActivityType.noteLeft else { continue }
            let body = (row.fields.notes ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !body.isEmpty else { continue }
            guard let when = serverDate(row.fields.feltAt)
                    ?? legacyTimestamp(activityDate: row.fields.activityDate, timeZone: timeZone)
            else { continue }
            out.append((createdAt: when, body: body))
        }
        return out.sorted { $0.createdAt < $1.createdAt }
    }

    /// The key two copies of one note share: the instant **to the second**, and
    /// the words. It is exactly the key `noteRowMatches` compares by, said once
    /// so the create-time guard and the restore-time merge cannot drift apart.
    ///
    /// Second precision is not a rounding-off — it is the only precision that
    /// survives the round trip. `Felt At` is written by
    /// `RecognitionDedup.writtenFeltAt`, which carries seconds and no fraction,
    /// so a note whose `createdAt` holds sub-second detail locally comes back
    /// from the ledger without it. Comparing the raw `Date`s would say *this is
    /// a note the phone has never seen* about every note the phone wrote.
    static func noteIdentity(createdAt: Date, body: String) -> String {
        RecognitionDedup.writtenFeltAt(createdAt)
            + "\u{1F}"
            + body.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Which of the ledger's notes this phone does not already hold.
    ///
    /// **This is what replaced "restore only when the phone is empty", and the
    /// emptiness guard is a path that closes for good.** The old rule ran the
    /// restore only when `MarginNote` was empty, and it ran at the end of a sync
    /// that a dead network aborts before reaching it. So: a reinstall with no
    /// signal, one note written, and the local table is never empty again — the
    /// guard returns on every launch for the rest of the install's life and
    /// every note he wrote before the reinstall stays in Airtable and never
    /// comes back to his list. Authored words, unrecoverable from anywhere else.
    ///
    /// Merging on identity has no such door: it is idempotent, so it may run on
    /// every sync forever, and it is the same answer whether the phone holds
    /// none of the ledger's notes, some of them, or all.
    ///
    /// Duplicates *within* the ledger collapse too — if two identical rows ever
    /// reach the server, only one note comes back to his margin.
    static func notesMissingLocally(restored: [RestoredNote],
                                    local: [RestoredNote]) -> [RestoredNote] {
        var seen = Set(local.map { noteIdentity(createdAt: $0.createdAt, body: $0.body) })
        var out: [RestoredNote] = []
        for r in restored {
            let key = noteIdentity(createdAt: r.createdAt, body: r.body)
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            out.append(r)
        }
        return out
    }

    /// Is this recognition her first? `serverCount` is the Shakti row's
    /// `Recognition Count` as read *before* this gesture's PATCH. On a retry
    /// whose PATCH already landed (Last Felt equals this second) the count
    /// read already includes her, so 1 still means first.
    static func wasFirst(serverCount: Int, patchAlreadyLanded: Bool) -> Bool {
        patchAlreadyLanded ? serverCount <= 1 : serverCount <= 0
    }

    /// "First" … "Ninth" — the ring words used across the instrument.
    static let ordinals = ["", "First", "Second", "Third", "Fourth", "Fifth",
                           "Sixth", "Seventh", "Eighth", "Ninth"]

    static func ordinal(_ ring: Int) -> String {
        (1...9).contains(ring) ? ordinals[ring] : "Ring \(ring)"
    }

    // MARK: - Payload

    /// The `fields` object for one POST to App Activity. `Activity Date` is
    /// the local calendar day of `at` in `timeZone` (device zone by default —
    /// a late-evening moment is not filed under tomorrow's UTC date); `Felt At`
    /// is `at` to the second in `Z`. Optional payload members are written only
    /// when present; `Link to Mandala` only when non-empty; `Notes` only when
    /// non-blank (trimmed, as the Mandala-table create wrote it).
    static func fields(for item: PendingActivity,
                       timeZone: TimeZone = .current) -> [String: Any] {
        var f: [String: Any] = [
            Field.sourceApp:    sourceApp,
            Field.activityType: item.type,
            Field.activityName: item.name,
            Field.detail:       item.detail,
            Field.activityDate: activityDate(item.at, timeZone: timeZone),
            Field.feltAt:       RecognitionDedup.writtenFeltAt(item.at),
        ]
        if !item.linkRecordId.isEmpty {
            f[Field.linkToMandala] = [item.linkRecordId]
        }
        if let s = item.gestureSource, !s.isEmpty { f[Field.gestureSource] = s }
        if let d = item.lunarDay                   { f[Field.lunarDay] = d }
        if let p = item.moonPhase, !p.isEmpty      { f[Field.moonPhase] = p }
        if let r = item.descentRing                { f[Field.descentRing] = r }
        if let s = item.durationSec                { f[Field.durationSec] = s }
        if let n = item.notes?.trimmingCharacters(in: .whitespacesAndNewlines), !n.isEmpty {
            f[Field.notes] = n
        }
        // Wave 6 · a multipleRecordLinks field takes an array of record ids.
        if let map = item.linkToMap?.filter({ !$0.isEmpty }), !map.isEmpty {
            f[Field.linkToMap] = map
        }
        return f
    }

    /// `yyyy-MM-dd` of `date` in `timeZone`.
    static func activityDate(_ date: Date, timeZone: TimeZone) -> String {
        let fmt = DateFormatter()
        fmt.calendar = Calendar(identifier: .gregorian)
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = timeZone
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: date)
    }

    // MARK: - Formulas (`filterByFormula` takes field names)

    /// A value made safe inside a single-quoted formula literal: backslashes
    /// and apostrophes are backslash-escaped.
    static func escaped(_ s: String) -> String {
        s.replacingOccurrences(of: "\\", with: "\\\\")
         .replacingOccurrences(of: "'", with: "\\'")
    }

    private static func and(_ clauses: [String]) -> String {
        "AND(" + clauses.joined(separator: ", ") + ")"
    }

    /// `{Source App}='Mandala'` — every Mandala read starts here.
    private static let isMandala = "{\(Field.sourceApp)}='\(sourceApp)'"

    private static func isType(_ type: String) -> String {
        "{\(Field.activityType)}='\(escaped(type))'"
    }

    /// The create-time idempotency check: rows of `type` within
    /// `RecognitionDedup.windowSeconds` of `feltAt` (a handful at most). The
    /// caller then matches link + `Felt At` to the second — `rowMatches`.
    static func dedup(type: String, around feltAt: Date) -> String {
        let w = RecognitionDedup.window(around: feltAt)
        return and([isMandala, isType(type),
                    "IS_AFTER({\(Field.feltAt)}, '\(w.lower)')",
                    "IS_BEFORE({\(Field.feltAt)}, '\(w.upper)')"])
    }

    /// Her Moments: `Shakti Recognized` rows narrowed by her name in the link's
    /// primary field (names repeat across rings, so the caller keeps the
    /// record-id match client-side). A blank name narrows nothing.
    static func moments(shaktiName: String) -> String {
        let name = shaktiName.trimmingCharacters(in: .whitespacesAndNewlines)
        var clauses = [isMandala, isType(ActivityType.shaktiRecognized)]
        if !name.isEmpty {
            clauses.append("FIND('\(escaped(name))', ARRAYJOIN({\(Field.linkToMandala)}))")
        }
        return and(clauses)
    }

    /// The recognition-log restore: every `Shakti Recognized` and `Silence Held` row.
    static var restoreRecognitions: String {
        and([isMandala,
             "OR(\(isType(ActivityType.shaktiRecognized)), \(isType(ActivityType.silenceHeld)))"])
    }

    /// The descent restore: every `Ring Crossed` row.
    static var restoreCrossings: String {
        and([isMandala, isType(ActivityType.ringCrossed)])
    }

    /// Every row of one `Activity Type` — the shape the server-derived dedups
    /// read by. `Letter Written`'s links, and the two once-ever milestones.
    static func ofType(_ type: String) -> String {
        "{\(Field.activityType)}='\(escaped(type))'"
    }

    /// The two milestones as the server holds them: any row of either type,
    /// written by this instrument. One read answers both guards.
    static var ledgeredMilestones: String {
        and([isMandala,
             "OR(" + Milestone.allCases.map { isType($0.activityType) }.joined(separator: ", ") + ")"])
    }

    // MARK: - Rows as the API returns them (field names; no `returnFieldsByFieldId`)

    struct Row: Decodable, Equatable {
        let id: String
        var fields: Fields

        struct Fields: Decodable, Equatable {
            var activityType: String? = nil
            var activityName: String? = nil
            var detail: String? = nil
            var activityDate: String? = nil
            var feltAt: String? = nil
            var notes: String? = nil
            var linkToMandala: [String]? = nil
            var gestureSource: String? = nil
            var lunarDay: Int? = nil
            var moonPhase: String? = nil
            var descentRing: Int? = nil
            var durationSec: Double? = nil
            /// Wave 6 · `Link to The Map` — read only by the Map-keyed dedup.
            var linkToMap: [String]? = nil
            /// Wave 6 · which instrument wrote the row — grace reads the sisters'.
            var sourceApp: String? = nil

            enum CodingKeys: String, CodingKey {
                case activityType  = "Activity Type"
                case activityName  = "Activity Name"
                case detail        = "Detail"
                case activityDate  = "Activity Date"
                case feltAt        = "Felt At"
                case notes         = "Notes"
                case linkToMandala = "Link to Mandala"
                case gestureSource = "Gesture Source"
                case lunarDay      = "Lunar Day"
                case moonPhase     = "Moon Phase"
                case descentRing   = "Descent Ring"
                case durationSec   = "Duration (sec)"
                case linkToMap     = "Link to The Map"
                case sourceApp     = "Source App"
            }
        }
    }

    /// **Which of the once-ever milestones the ledger already holds**, read off
    /// the rows a milestone read returns.
    ///
    /// Pure, and that is deliberate: the guard that matters for `Full Circle`
    /// and `First Dwelling` is the *server-derived* half, and a guard that can
    /// only be exercised by making a network call is a guard nothing checks. A
    /// reinstall is this function against a cleared local set.
    static func ledgered(in rows: [Row]) -> Set<Milestone> {
        let held = Set(rows.compactMap { $0.fields.activityType })
        return Set(Milestone.allCases.filter { held.contains($0.activityType) })
    }

    /// True only when the row links `linkRecordId` *and* carries `feltAt` to
    /// the second — the key the create wrote. Same key and match rule as the
    /// Mandala-table check (`RecognitionDedup.rowMatches`).
    static func rowMatches(_ row: Row, linkRecordId: String, feltAt: Date) -> Bool {
        RecognitionDedup.rowMatches(links: row.fields.linkToMandala,
                                    feltAt: row.fields.feltAt,
                                    linkRecordId: linkRecordId,
                                    feltAt: feltAt)
    }

    // MARK: - Restore mappers

    typealias RestoredRecognition = (timestamp: Date, kp: Int, ring: Int,
                                     note: String?, gesture: RecognitionEntry.Gesture)
    typealias RestoredCrossing = (ring: Int, date: Date)

    /// Ledger rows → local recognition entries, oldest first. `byRecord` maps
    /// a Shakti record id to (Khaḍgamālā position, ring); a row whose link is
    /// not a known Śakti (an Avaraṇa-linked legacy silence, an empty link) is
    /// skipped, as are rows of any other type. `Silence Held` → `.silence`,
    /// `Shakti Recognized` → `.felt`. A legacy milestone that predates
    /// `Felt At` is tolerated: its instant is noon of `Activity Date` in
    /// `timeZone` (the day is true; the hour is not known) — unless a row of
    /// the same type and link carries `Felt At` on that same day, in which
    /// case the two are one moment written twice (`isShadowed`) and only the
    /// timestamped row restores. A row with neither is skipped — never
    /// coerced to now.
    static func recognitionEntries(from rows: [Row],
                                   byRecord: [String: (kp: Int, ring: Int)],
                                   timeZone: TimeZone = .current) -> [RestoredRecognition] {
        let timestampedDays = timestampedDayKeys(in: rows, timeZone: timeZone)
        var out: [RestoredRecognition] = []
        for row in rows {
            let gesture: RecognitionEntry.Gesture
            switch row.fields.activityType {
            case ActivityType.shaktiRecognized: gesture = .felt
            case ActivityType.silenceHeld:      gesture = .silence
            default:                            continue
            }
            guard let rec = row.fields.linkToMandala?.first, let map = byRecord[rec] else { continue }
            guard !isShadowed(row, by: timestampedDays) else { continue }
            guard let ts = serverDate(row.fields.feltAt)
                    ?? legacyTimestamp(activityDate: row.fields.activityDate, timeZone: timeZone)
            else { continue }
            // Her words come back as written; a blank Notes is no note.
            let isBlank = row.fields.notes?
                .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
            out.append((timestamp: ts, kp: map.kp, ring: map.ring,
                        note: isBlank ? nil : row.fields.notes,
                        gesture: gesture))
        }
        return out.sorted { $0.timestamp < $1.timestamp }
    }

    /// Ledger rows → descent crossings, oldest first, for `DescentState.restore`.
    /// Only `Ring Crossed` rows with a ring in 1…9 *and* a readable `Felt At`
    /// count — a stray row must never rewrite a crossing's date.
    static func crossings(from rows: [Row]) -> [RestoredCrossing] {
        rows.compactMap { row -> RestoredCrossing? in
            guard row.fields.activityType == ActivityType.ringCrossed,
                  let ring = row.fields.descentRing, (1...9).contains(ring),
                  let date = serverDate(row.fields.feltAt) else { return nil }
            return (ring: ring, date: date)
        }
        .sorted { $0.date < $1.date }
    }

    // MARK: - A legacy row beside its timestamped twin

    /// The 2026-09-07 backfill wrote the ledger's milestone rows with
    /// `Activity Date` only (`Felt At` did not exist yet); the migration then
    /// brings the same recognitions in with their true instants. Both rows
    /// stand for one moment, so a `Felt At`-less row is *shadowed* when a row
    /// of the same type and link carries `Felt At` on the same day — the day
    /// as the timestamped row states it (`Activity Date`) or as `timeZone`
    /// reads its instant, so a device in another zone still knows the twin.
    /// A legacy row whose day has no timestamped twin (a Śakti felt only
    /// before sync-live, then felt again months later) is not shadowed and
    /// keeps its noon restore: shadowing folds a duplicate, never history.

    /// `type|link|yyyy-MM-dd` for every row with a readable `Felt At`.
    static func timestampedDayKeys(in rows: [Row], timeZone: TimeZone) -> Set<String> {
        var keys = Set<String>()
        for row in rows {
            guard let type = row.fields.activityType,
                  let instant = serverDate(row.fields.feltAt) else { continue }
            for link in row.fields.linkToMandala ?? [] {
                keys.insert(dayKey(type, link, activityDate(instant, timeZone: timeZone)))
                if let stated = row.fields.activityDate {
                    keys.insert(dayKey(type, link, stated))
                }
            }
        }
        return keys
    }

    /// True for a `Felt At`-less row whose type, link and `Activity Date`
    /// match a key from `timestampedDayKeys` — the same moment, already
    /// carried with its instant.
    static func isShadowed(_ row: Row, by keys: Set<String>) -> Bool {
        guard serverDate(row.fields.feltAt) == nil,
              let type = row.fields.activityType,
              let day = row.fields.activityDate else { return false }
        return (row.fields.linkToMandala ?? []).contains { keys.contains(dayKey(type, $0, day)) }
    }

    private static func dayKey(_ type: String, _ link: String, _ day: String) -> String {
        "\(type)|\(link)|\(day)"
    }

    /// Her Moments: from the rows that matched one Śakti's record id, newest
    /// first as the server sorted them, the rows to show — at most `limit`.
    /// Timestamped rows lead; a `Felt At`-less milestone is dropped when
    /// shadowed and otherwise follows them (her first recognition is the
    /// oldest by construction).
    static func momentRows(_ matched: [Row], limit: Int, timeZone: TimeZone = .current) -> [Row] {
        let keys = timestampedDayKeys(in: matched, timeZone: timeZone)
        let timestamped = matched.filter { serverDate($0.fields.feltAt) != nil }
        let legacy = matched.filter { serverDate($0.fields.feltAt) == nil && !isShadowed($0, by: keys) }
        return Array((timestamped + legacy).prefix(limit))
    }

    /// `Felt At` as the API returns it (`…Z` with or without milliseconds) → Date.
    static func serverDate(_ raw: String?) -> Date? {
        guard let raw else { return nil }
        let fractional = ISO8601DateFormatter()
        fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = fractional.date(from: raw) { return d }
        let plain = ISO8601DateFormatter()
        plain.formatOptions = [.withInternetDateTime]
        return plain.date(from: raw)
    }

    /// Noon of a `yyyy-MM-dd` `Activity Date` in `timeZone`, for rows written
    /// before `Felt At` existed. `nil` when the date is missing or unreadable.
    static func legacyTimestamp(activityDate: String?, timeZone: TimeZone) -> Date? {
        guard let activityDate else { return nil }
        let fmt = DateFormatter()
        fmt.calendar = Calendar(identifier: .gregorian)
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = timeZone
        fmt.dateFormat = "yyyy-MM-dd"
        guard let day = fmt.date(from: activityDate) else { return nil }
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = timeZone
        return cal.date(bySettingHour: 12, minute: 0, second: 0, of: day)
    }
}

// MARK: - Recognition moment

/// What a recognition gesture carries into the ledger: the queued
/// recognition's own members, so `ActivityLedger.recognition(_:shaktiName:isFirst:)`
/// takes the queue item as it is.
protocol RecognitionMoment {
    var shaktiRecordId: String { get }
    var note: String? { get }
    /// `Gesture Source` — "Today" / "Mandala" / "Well".
    var source: String { get }
    var feltAt: Date { get }
    var lunarDay: Int { get }
    var moonPhase: String { get }
}

// MARK: - Queue item

/// One unfulfilled App Activity write held in UserDefaults until the network
/// returns (`pendingActivities`). `failCount` is bumped per failed flush;
/// items are never retired (`PendingQueuePolicy.maxFailures` is nil). With no token nothing is
/// bumped.
///
/// The members after `failCount` arrived with the ledger rewire and are all
/// optional with `nil` defaults, so a queue written by build 36 (type, link,
/// name, detail, at, failCount — and an id once stamped) still decodes and
/// drains into the ledger. Encoded with the default `JSONEncoder` /
/// `JSONDecoder` date strategy, as before — do not set one.
struct PendingActivity: Codable, PendingQueueItem, Equatable {
    var id: String = UUID().uuidString
    let type: String
    let linkRecordId: String
    let name: String
    let detail: String
    let at: Date
    var failCount: Int = 0

    /// `Gesture Source` — Today · Mandala · Well · Silence.
    var gestureSource: String? = nil
    var lunarDay: Int? = nil
    var moonPhase: String? = nil
    var descentRing: Int? = nil
    var durationSec: Double? = nil
    /// The practitioner's words, written to `Notes` only when non-blank.
    var notes: String? = nil
    /// Wave 6 · `Link to The Map` — the chakra's Map record id(s). Optional
    /// with a `nil` default like every member after `failCount`, so a queue
    /// written before Wave 6 still decodes and drains, and is never dropped.
    var linkToMap: [String]? = nil
}
