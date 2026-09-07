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
    }

    /// `Gesture Source` options — where the gesture originated.
    enum GestureSource {
        static let today   = "Today"
        static let mandala = "Mandala"
        static let well    = "Well"
        static let silence = "Silence"
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
            }
        }
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
/// items retire at `PendingQueuePolicy.maxFailures`. With no token nothing is
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
}
