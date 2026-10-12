import XCTest
@testable import Bindu_Mandala

/// The pure half of the App Activity ledger: the payload each event type
/// writes, the first/return decision, the crossing vocabulary, the formulas
/// the reads use, the restore mappers, and the queue item's tolerance for
/// what build 36 left in UserDefaults. No network, no store.
final class ActivityLedgerTests: XCTestCase {

    // MARK: fixtures

    /// 2026-09-06T14:34:41.097Z — the sealed plist's queued moment: synodic
    /// day 25, Waning Crescent (the backfill's lunar self-check agrees).
    private let instant = Date(timeIntervalSinceReferenceDate: 810_398_081.097376)

    private let newYork = TimeZone(identifier: "America/New_York")!
    private let utcZone = TimeZone(secondsFromGMT: 0)!

    private func utc(_ year: Int, _ month: Int, _ day: Int,
                     _ hour: Int, _ minute: Int, _ second: Int) -> Date {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0)!
        return c.date(from: DateComponents(year: year, month: month, day: day,
                                           hour: hour, minute: minute, second: second))!
    }

    /// The queued recognition's shape, as `AirtableService.PendingRecognition` carries it.
    private struct Moment: RecognitionMoment {
        var shaktiRecordId = "recShakti"
        var note: String? = nil
        var source = "Today"
        var feltAt: Date
        var lunarDay = 25
        var moonPhase = "Waning Crescent"
    }

    private func row(_ id: String,
                     type: String?,
                     link: [String]? = nil,
                     feltAt: String? = nil,
                     activityDate: String? = nil,
                     notes: String? = nil,
                     ring: Int? = nil) -> ActivityLedger.Row {
        ActivityLedger.Row(id: id, fields: .init(activityType: type,
                                                activityDate: activityDate,
                                                feltAt: feltAt,
                                                notes: notes,
                                                linkToMandala: link,
                                                descentRing: ring))
    }

    // MARK: vocabulary

    func testTableAndSourceAppAreTheLedgersOwn() {
        XCTAssertEqual(ActivityLedger.tableId, "tblJlBeiHnqGpYrL7")
        XCTAssertEqual(ActivityLedger.sourceApp, "Mandala")
        XCTAssertEqual(ActivityLedger.ActivityType.shaktiRecognized, "Shakti Recognized")
        XCTAssertEqual(ActivityLedger.ActivityType.letterWritten, "Letter Written")
        XCTAssertEqual(ActivityLedger.ActivityType.ringCrossed, "Ring Crossed")
        XCTAssertEqual(ActivityLedger.ActivityType.silenceHeld, "Silence Held")
        XCTAssertEqual(ActivityLedger.Field.notes, "Notes")
        XCTAssertEqual(ActivityLedger.Field.linkToMandala, "Link to Mandala")
        XCTAssertEqual(ActivityLedger.Field.feltAt, "Felt At")
        XCTAssertEqual(ActivityLedger.Field.gestureSource, "Gesture Source")
        XCTAssertEqual(ActivityLedger.Field.durationSec, "Duration (sec)")
    }

    func testLunarFixtureIsWhatTheDetailTextsAssume() {
        XCTAssertEqual(LunarPhaseService.phaseName(at: instant), "Waning Crescent")
        XCTAssertEqual(LunarPhaseService.currentDay(at: instant), 25)
    }

    // MARK: recognition — first vs return

    func testFirstRecognitionIsTheMilestoneRow() {
        let m = Moment(note: "I love you", source: "Today", feltAt: instant)
        let a = ActivityLedger.recognition(m, shaktiName: "Sarva-Sammohinī", isFirst: true)
        XCTAssertEqual(a.type, "Shakti Recognized")
        XCTAssertEqual(a.linkRecordId, "recShakti")
        XCTAssertEqual(a.name, "Sarva-Sammohinī — first recognition", "unchanged from build 36")
        XCTAssertEqual(a.detail, "Felt here for the first time · Waning Crescent")
        XCTAssertEqual(a.at, instant)
        XCTAssertEqual(a.gestureSource, "Today")
        XCTAssertEqual(a.lunarDay, 25)
        XCTAssertEqual(a.moonPhase, "Waning Crescent")
        XCTAssertEqual(a.notes, "I love you")
        XCTAssertNil(a.descentRing)
        XCTAssertNil(a.durationSec)
        XCTAssertEqual(a.failCount, 0)
    }

    func testReturnRecognitionIsFeltAgain() {
        let m = Moment(source: "Mandala", feltAt: instant)
        let a = ActivityLedger.recognition(m, shaktiName: "Nāmākarṣiṇī", isFirst: false)
        XCTAssertEqual(a.name, "Nāmākarṣiṇī — felt again")
        XCTAssertEqual(a.detail, "Felt here again · Waning Crescent")
        XCTAssertEqual(a.gestureSource, "Mandala")
        XCTAssertNil(a.notes)
    }

    func testRecognitionWithoutANameFallsBackQuietly() {
        let a = ActivityLedger.recognition(Moment(feltAt: instant), shaktiName: "", isFirst: true)
        XCTAssertEqual(a.name, "A Śakti — first recognition")
    }

    func testWasFirstTable() {
        // count read before this gesture's PATCH
        XCTAssertTrue(ActivityLedger.wasFirst(serverCount: 0, patchAlreadyLanded: false))
        XCTAssertFalse(ActivityLedger.wasFirst(serverCount: 1, patchAlreadyLanded: false))
        XCTAssertFalse(ActivityLedger.wasFirst(serverCount: 7, patchAlreadyLanded: false))
        // a retry whose PATCH landed: the count read already includes her
        XCTAssertTrue(ActivityLedger.wasFirst(serverCount: 1, patchAlreadyLanded: true))
        XCTAssertFalse(ActivityLedger.wasFirst(serverCount: 2, patchAlreadyLanded: true))
        XCTAssertTrue(ActivityLedger.wasFirst(serverCount: 0, patchAlreadyLanded: true))
    }

    // MARK: crossing — names, forms, links

    func testCrossingUsesTheOrdinalWordsAndEnclosureForms() {
        let nine = ActivityLedger.crossing(ring: 9, feltAt: instant)
        XCTAssertEqual(nine.type, "Ring Crossed")
        XCTAssertEqual(nine.name, "Ninth Āvaraṇa — crossed")
        XCTAssertEqual(nine.detail, "Fell inward to the Bindu · Waning Crescent")
        XCTAssertEqual(nine.linkRecordId, "recqdC3D38TWFkf1M", "the Avaraṇa row, not a Śakti")
        XCTAssertEqual(nine.gestureSource, "Mandala")
        XCTAssertEqual(nine.descentRing, 9)
        XCTAssertEqual(nine.at, instant)
        XCTAssertNil(nine.lunarDay)
        XCTAssertNil(nine.moonPhase)
        XCTAssertNil(nine.notes)

        let one = ActivityLedger.crossing(ring: 1, feltAt: instant)
        XCTAssertEqual(one.name, "First Āvaraṇa — crossed")
        XCTAssertEqual(one.detail, "Fell inward to the Bhūpura · Waning Crescent")
        XCTAssertEqual(one.linkRecordId, "rec0XhDKfxW8UVyaB")

        let seven = ActivityLedger.crossing(ring: 7, feltAt: instant)
        XCTAssertEqual(seven.name, "Seventh Āvaraṇa — crossed")
        XCTAssertEqual(seven.detail, "Fell inward to the Vāk Ring · Waning Crescent")
    }

    func testEnclosureFormsForAllNineRings() {
        let forms = (1...9).map(Avarana.enclosureForm(forRing:))
        XCTAssertEqual(forms, ["Bhūpura", "16-Petal Lotus", "8-Petal Lotus", "14 Triangles",
                               "10 Outer Triangles", "10 Inner Triangles", "Vāk Ring",
                               "Mūla Trikoṇa", "Bindu"])
        XCTAssertEqual(Avarana.enclosureForm(forRing: 0), "")
        XCTAssertEqual(Avarana.enclosureForm(forRing: 10), "")
    }

    func testAvaranaRecordIdInvertsTheStaticMap() {
        let ids = (1...9).compactMap(AirtableService.avaranaRecordId(forRing:))
        XCTAssertEqual(ids.count, 9, "every ring has its row")
        XCTAssertEqual(Set(ids).count, 9, "and no two rings share one")
        XCTAssertEqual(AirtableService.avaranaRecordId(forRing: 2), "recspOpR95DVcOEvn")
        XCTAssertNil(AirtableService.avaranaRecordId(forRing: 0))
        XCTAssertNil(AirtableService.avaranaRecordId(forRing: 10))
    }

    func testOrdinalWords() {
        XCTAssertEqual((1...9).map(ActivityLedger.ordinal),
                       ["First", "Second", "Third", "Fourth", "Fifth",
                        "Sixth", "Seventh", "Eighth", "Ninth"])
    }

    // MARK: silence

    func testSilenceRowLinksHerAndCarriesTheDuration() {
        let a = ActivityLedger.silence(shaktiRecordId: "recS", name: "Sarva-Sammohinī",
                                       durationSec: 2056, at: instant)
        XCTAssertEqual(a.type, "Silence Held")
        XCTAssertEqual(a.linkRecordId, "recS")
        XCTAssertEqual(a.name, "Sarva-Sammohinī — silence held")
        XCTAssertEqual(a.detail, "Dwelt past the first adaptation · Waning Crescent")
        XCTAssertEqual(a.gestureSource, "Silence")
        XCTAssertEqual(a.durationSec, 2056)
        XCTAssertEqual(a.lunarDay, 25)
        XCTAssertEqual(a.moonPhase, "Waning Crescent")
        XCTAssertNil(a.notes, "no Notes on a silence")
        XCTAssertNil(a.descentRing)
        XCTAssertEqual(ActivityLedger.silence(shaktiRecordId: "recS", name: "",
                                              durationSec: 1, at: instant).name,
                       "A Śakti — silence held")
    }

    // MARK: payload

    func testRecognitionPayload() {
        let m = Moment(note: "I love you", source: "Today", feltAt: instant)
        let a = ActivityLedger.recognition(m, shaktiName: "Sarva-Sammohinī", isFirst: true)
        let f = ActivityLedger.fields(for: a, timeZone: newYork)
        XCTAssertEqual(f["Source App"] as? String, "Mandala")
        XCTAssertEqual(f["Activity Type"] as? String, "Shakti Recognized")
        XCTAssertEqual(f["Activity Name"] as? String, "Sarva-Sammohinī — first recognition")
        XCTAssertEqual(f["Detail"] as? String, "Felt here for the first time · Waning Crescent")
        XCTAssertEqual(f["Link to Mandala"] as? [String], ["recShakti"])
        XCTAssertEqual(f["Activity Date"] as? String, "2026-09-06")
        XCTAssertEqual(f["Felt At"] as? String, "2026-09-06T14:34:41Z")
        XCTAssertEqual(f["Gesture Source"] as? String, "Today")
        XCTAssertEqual(f["Lunar Day"] as? Int, 25)
        XCTAssertEqual(f["Moon Phase"] as? String, "Waning Crescent")
        XCTAssertEqual(f["Notes"] as? String, "I love you")
        XCTAssertNil(f["Descent Ring"])
        XCTAssertNil(f["Duration (sec)"])
        XCTAssertEqual(f.count, 11)
        XCTAssertTrue(JSONSerialization.isValidJSONObject(["fields": f, "typecast": true]))
    }

    func testCrossingPayload() {
        let f = ActivityLedger.fields(for: ActivityLedger.crossing(ring: 9, feltAt: instant),
                                      timeZone: newYork)
        XCTAssertEqual(f["Activity Type"] as? String, "Ring Crossed")
        XCTAssertEqual(f["Activity Name"] as? String, "Ninth Āvaraṇa — crossed")
        XCTAssertEqual(f["Detail"] as? String, "Fell inward to the Bindu · Waning Crescent")
        XCTAssertEqual(f["Link to Mandala"] as? [String], ["recqdC3D38TWFkf1M"])
        XCTAssertEqual(f["Felt At"] as? String, "2026-09-06T14:34:41Z")
        XCTAssertEqual(f["Descent Ring"] as? Int, 9)
        XCTAssertEqual(f["Gesture Source"] as? String, "Mandala")
        XCTAssertNil(f["Lunar Day"])
        XCTAssertNil(f["Moon Phase"])
        XCTAssertNil(f["Notes"])
        XCTAssertNil(f["Duration (sec)"])
        XCTAssertTrue(JSONSerialization.isValidJSONObject(["fields": f, "typecast": true]))
    }

    func testSilencePayload() {
        let a = ActivityLedger.silence(shaktiRecordId: "recS", name: "Sarva-Sammohinī",
                                       durationSec: 2056.5, at: instant)
        let f = ActivityLedger.fields(for: a, timeZone: newYork)
        XCTAssertEqual(f["Activity Type"] as? String, "Silence Held")
        XCTAssertEqual(f["Duration (sec)"] as? Double, 2056.5)
        XCTAssertEqual(f["Gesture Source"] as? String, "Silence")
        XCTAssertEqual(f["Lunar Day"] as? Int, 25)
        XCTAssertEqual(f["Moon Phase"] as? String, "Waning Crescent")
        XCTAssertEqual(f["Link to Mandala"] as? [String], ["recS"])
        XCTAssertNil(f["Notes"])
        XCTAssertNil(f["Descent Ring"])
    }

    func testLetterWrittenPayloadIsUnchangedPlusFeltAt() {
        // The four-argument `logActivity` shape build 36 queued — no payload
        // members — now gains only Felt At.
        let a = PendingActivity(type: "Letter Written", linkRecordId: "recL",
                                name: "A letter to Nāmākarṣiṇī", detail: "First letter written",
                                at: instant)
        let f = ActivityLedger.fields(for: a, timeZone: newYork)
        XCTAssertEqual(f["Source App"] as? String, "Mandala")
        XCTAssertEqual(f["Activity Type"] as? String, "Letter Written")
        XCTAssertEqual(f["Activity Name"] as? String, "A letter to Nāmākarṣiṇī")
        XCTAssertEqual(f["Detail"] as? String, "First letter written")
        XCTAssertEqual(f["Link to Mandala"] as? [String], ["recL"])
        XCTAssertEqual(f["Activity Date"] as? String, "2026-09-06")
        XCTAssertEqual(f["Felt At"] as? String, "2026-09-06T14:34:41Z")
        XCTAssertEqual(f.count, 7, "nothing else is invented for a letter")
    }

    func testNotesIsOmittedWhenBlankAndTrimmedOtherwise() {
        func notes(_ n: String?) -> Any? {
            var a = ActivityLedger.recognition(Moment(feltAt: instant), shaktiName: "X", isFirst: false)
            a.notes = n
            return ActivityLedger.fields(for: a)["Notes"]
        }
        XCTAssertNil(notes(nil))
        XCTAssertNil(notes(""))
        XCTAssertNil(notes("   \n\t "))
        XCTAssertEqual(notes("  her words \n") as? String, "her words")
    }

    func testLinkIsOmittedWhenEmpty() {
        let a = PendingActivity(type: "Ring Crossed", linkRecordId: "",
                                name: "n", detail: "d", at: instant)
        XCTAssertNil(ActivityLedger.fields(for: a)["Link to Mandala"])
    }

    func testActivityDateIsTheLocalDayOfTheInjectedZone() {
        // 02:30Z on the 7th is still the evening of the 6th in New York.
        let lateEvening = utc(2026, 9, 7, 2, 30, 0)
        let a = PendingActivity(type: "Shakti Recognized", linkRecordId: "r",
                                name: "n", detail: "d", at: lateEvening)
        XCTAssertEqual(ActivityLedger.fields(for: a, timeZone: newYork)["Activity Date"] as? String,
                       "2026-09-06")
        XCTAssertEqual(ActivityLedger.fields(for: a, timeZone: utcZone)["Activity Date"] as? String,
                       "2026-09-07")
        XCTAssertEqual(ActivityLedger.fields(for: a, timeZone: TimeZone(identifier: "Asia/Kolkata")!)["Activity Date"] as? String,
                       "2026-09-07")
        XCTAssertEqual(ActivityLedger.activityDate(lateEvening, timeZone: newYork), "2026-09-06")
    }

    func testFeltAtIsSecondPrecisionZAndMatchesTheDedupKey() {
        let a = PendingActivity(type: "Shakti Recognized", linkRecordId: "r",
                                name: "n", detail: "d", at: instant)
        let feltAt = ActivityLedger.fields(for: a)["Felt At"] as? String
        XCTAssertEqual(feltAt, "2026-09-06T14:34:41Z")
        XCTAssertEqual(feltAt, RecognitionDedup.writtenFeltAt(instant),
                       "the exact string the Shakti-row Last Felt guard compares against")
        XCTAssertFalse(feltAt!.contains("."))
    }

    // MARK: formulas

    func testEscapedQuotesAndBackslashes() {
        XCTAssertEqual(ActivityLedger.escaped("Sarva-Sammohinī"), "Sarva-Sammohinī")
        XCTAssertEqual(ActivityLedger.escaped("it's"), "it\\'s")
        XCTAssertEqual(ActivityLedger.escaped("a\\b"), "a\\\\b")
        XCTAssertEqual(ActivityLedger.escaped("it's \\ done"), "it\\'s \\\\ done")
    }

    func testDedupFormulaUsesTheRecognitionDedupWindow() {
        let f = ActivityLedger.dedup(type: "Shakti Recognized", around: instant)
        XCTAssertEqual(
            f,
            "AND({Source App}='Mandala', {Activity Type}='Shakti Recognized', IS_AFTER({Felt At}, '2026-09-06T14:33:41Z'), IS_BEFORE({Felt At}, '2026-09-06T14:35:41Z'))"
        )
        let w = RecognitionDedup.window(around: instant)
        XCTAssertTrue(f.contains(w.lower) && f.contains(w.upper), "same ±60 s math as the Mandala check")
        XCTAssertTrue(ActivityLedger.dedup(type: "Ring Crossed", around: instant)
                        .contains("{Activity Type}='Ring Crossed'"))
    }

    func testMomentsFormulaNarrowsByNameInTheLinkAndEscapes() {
        XCTAssertEqual(
            ActivityLedger.moments(shaktiName: "Nāmākarṣiṇī"),
            "AND({Source App}='Mandala', {Activity Type}='Shakti Recognized', FIND('Nāmākarṣiṇī', ARRAYJOIN({Link to Mandala})))"
        )
        XCTAssertEqual(
            ActivityLedger.moments(shaktiName: "O'Kāla"),
            "AND({Source App}='Mandala', {Activity Type}='Shakti Recognized', FIND('O\\'Kāla', ARRAYJOIN({Link to Mandala})))"
        )
        XCTAssertEqual(
            ActivityLedger.moments(shaktiName: "  "),
            "AND({Source App}='Mandala', {Activity Type}='Shakti Recognized')",
            "a blank name narrows nothing rather than FIND('')"
        )
    }

    func testRestoreFormulas() {
        XCTAssertEqual(
            ActivityLedger.restoreRecognitions,
            "AND({Source App}='Mandala', OR({Activity Type}='Shakti Recognized', {Activity Type}='Silence Held'))"
        )
        XCTAssertEqual(
            ActivityLedger.restoreCrossings,
            "AND({Source App}='Mandala', {Activity Type}='Ring Crossed')"
        )
    }

    // MARK: rows as the API returns them

    func testRowDecodesByFieldName() throws {
        let json = """
        {"id":"recRow","createdTime":"2026-09-07T13:00:00.000Z","fields":{
          "Activity Name":"Sarva-Sammohinī — felt again","Source App":"Mandala",
          "Activity Type":"Shakti Recognized","Activity Date":"2026-09-06",
          "Detail":"Felt here again · Waning Crescent","Notes":"I love you",
          "Link to Mandala":["recShakti"],"Felt At":"2026-09-06T14:34:41.000Z",
          "Lunar Day":25,"Moon Phase":"Waning Crescent","Gesture Source":"Today",
          "Descent Ring":9,"Duration (sec)":2056.5}}
        """
        let r = try JSONDecoder().decode(ActivityLedger.Row.self, from: Data(json.utf8))
        XCTAssertEqual(r.id, "recRow")
        XCTAssertEqual(r.fields.activityType, "Shakti Recognized")
        XCTAssertEqual(r.fields.activityName, "Sarva-Sammohinī — felt again")
        XCTAssertEqual(r.fields.activityDate, "2026-09-06")
        XCTAssertEqual(r.fields.detail, "Felt here again · Waning Crescent")
        XCTAssertEqual(r.fields.notes, "I love you")
        XCTAssertEqual(r.fields.linkToMandala, ["recShakti"])
        XCTAssertEqual(r.fields.feltAt, "2026-09-06T14:34:41.000Z")
        XCTAssertEqual(r.fields.lunarDay, 25)
        XCTAssertEqual(r.fields.moonPhase, "Waning Crescent")
        XCTAssertEqual(r.fields.gestureSource, "Today")
        XCTAssertEqual(r.fields.descentRing, 9)
        XCTAssertEqual(r.fields.durationSec, 2056.5)
    }

    func testRowWithOnlyTheLegacyFieldsDecodes() throws {
        let json = #"{"id":"recOld","fields":{"Activity Type":"Shakti Recognized","Activity Date":"2026-07-13","Link to Mandala":["recShakti"]}}"#
        let r = try JSONDecoder().decode(ActivityLedger.Row.self, from: Data(json.utf8))
        XCTAssertNil(r.fields.feltAt)
        XCTAssertNil(r.fields.notes)
        XCTAssertEqual(r.fields.activityDate, "2026-07-13")
    }

    func testRowMatchesIsLinkPlusFeltAtToTheSecond() {
        let hers = row("r", type: "Shakti Recognized", link: ["recShakti"],
                       feltAt: "2026-09-06T14:34:41.000Z")
        XCTAssertTrue(ActivityLedger.rowMatches(hers, linkRecordId: "recShakti", feltAt: instant))
        XCTAssertFalse(ActivityLedger.rowMatches(hers, linkRecordId: "recOther", feltAt: instant))
        XCTAssertFalse(ActivityLedger.rowMatches(hers, linkRecordId: "recShakti",
                                                 feltAt: instant.addingTimeInterval(1)))
        let noKey = row("r", type: "Shakti Recognized", link: ["recShakti"], feltAt: nil)
        XCTAssertFalse(ActivityLedger.rowMatches(noKey, linkRecordId: "recShakti", feltAt: instant))
    }

    // MARK: restore — recognitions

    private let byRecord: [String: (kp: Int, ring: Int)] = [
        "recShakti": (kp: 40, ring: 2),
        "recDeep":   (kp: 99, ring: 8),
    ]

    func testRecognitionEntriesMapFeltAndSilenceOldestFirst() {
        let rows = [
            row("later", type: "Shakti Recognized", link: ["recShakti"],
                feltAt: "2026-09-06T14:34:41.000Z", notes: "I love you"),
            row("silence", type: "Silence Held", link: ["recDeep"],
                feltAt: "2026-05-31T02:12:29.000Z"),
            row("earlier", type: "Shakti Recognized", link: ["recShakti"],
                feltAt: "2026-06-12T19:01:00Z", notes: "Atlas emergence"),
        ]
        let e = ActivityLedger.recognitionEntries(from: rows, byRecord: byRecord, timeZone: newYork)
        XCTAssertEqual(e.count, 3)
        XCTAssertEqual(e.map(\.timestamp), [utc(2026, 5, 31, 2, 12, 29),
                                            utc(2026, 6, 12, 19, 1, 0),
                                            utc(2026, 9, 6, 14, 34, 41)], "oldest first")
        XCTAssertEqual(e[0].gesture, .silence)
        XCTAssertEqual(e[0].kp, 99)
        XCTAssertEqual(e[0].ring, 8)
        XCTAssertNil(e[0].note)
        XCTAssertEqual(e[1].gesture, .felt)
        XCTAssertEqual(e[1].note, "Atlas emergence")
        XCTAssertEqual(e[2].kp, 40)
        XCTAssertEqual(e[2].ring, 2)
        XCTAssertEqual(e[2].note, "I love you")
    }

    func testLegacyMilestoneWithoutFeltAtRestoresAtNoonOfItsLocalDay() {
        // Build 36 wrote milestones with Activity Date only. The day is true;
        // the hour is not known — noon in the zone keeps the day stable.
        let legacy = row("old", type: "Shakti Recognized", link: ["recShakti"],
                         activityDate: "2026-07-13")
        let e = ActivityLedger.recognitionEntries(from: [legacy], byRecord: byRecord, timeZone: newYork)
        XCTAssertEqual(e.count, 1)
        XCTAssertEqual(e[0].timestamp, utc(2026, 7, 13, 16, 0, 0), "noon EDT")
        XCTAssertEqual(e[0].gesture, .felt)
        XCTAssertEqual(ActivityLedger.recognitionEntries(from: [legacy], byRecord: byRecord,
                                                         timeZone: utcZone)[0].timestamp,
                       utc(2026, 7, 13, 12, 0, 0))
    }

    func testFeltAtWinsOverActivityDateWhenBothArePresent() {
        let r = row("r", type: "Shakti Recognized", link: ["recShakti"],
                    feltAt: "2026-09-06T14:34:41.000Z", activityDate: "2026-09-06")
        let e = ActivityLedger.recognitionEntries(from: [r], byRecord: byRecord, timeZone: newYork)
        XCTAssertEqual(e.first?.timestamp, utc(2026, 9, 6, 14, 34, 41))
    }

    // MARK: restore — a backfill milestone beside its migrated twin

    /// The 09-07 backfill's 38 milestone rows carry `Activity Date` only; the
    /// migration brings the same first recognitions in with their instants.
    /// One moment, one entry — at the true instant, with her words.
    func testLegacyMilestoneBesideItsMigratedTwinRestoresOnceAtTheInstant() {
        let milestone = row("milestone", type: "Shakti Recognized", link: ["recShakti"],
                            activityDate: "2026-05-20")
        let migrated = row("migrated", type: "Shakti Recognized", link: ["recShakti"],
                           feltAt: "2026-05-21T01:12:00.000Z", activityDate: "2026-05-20",
                           notes: "Atlas emergence")
        let e = ActivityLedger.recognitionEntries(from: [milestone, migrated],
                                                  byRecord: byRecord, timeZone: newYork)
        XCTAssertEqual(e.count, 1)
        XCTAssertEqual(e[0].timestamp, utc(2026, 5, 21, 1, 12, 0))
        XCTAssertEqual(e[0].note, "Atlas emergence")
        // The twin is known by the day the row states, so a device in a zone
        // where 01:12Z is already the 21st still folds it…
        XCTAssertEqual(ActivityLedger.recognitionEntries(from: [milestone, migrated],
                                                         byRecord: byRecord, timeZone: utcZone).count, 1)
        // …and by the instant's day in the zone when the twin states no day.
        let unstated = row("migrated", type: "Shakti Recognized", link: ["recShakti"],
                           feltAt: "2026-05-21T01:12:00.000Z", notes: "Atlas emergence")
        XCTAssertEqual(ActivityLedger.recognitionEntries(from: [milestone, unstated],
                                                         byRecord: byRecord, timeZone: newYork).count, 1)
    }

    /// kp35 and kp41 were felt only in May, before sync-live: their milestone
    /// rows have no migrated twin. Felt again months later, the May first-felt
    /// must still come home — a later instant shadows nothing but its own day.
    func testLegacyMilestoneOnAnotherDayThanHerTimestampedRowsIsKept() {
        let rows = [
            row("milestone", type: "Shakti Recognized", link: ["recShakti"],
                activityDate: "2026-05-20"),
            row("later", type: "Shakti Recognized", link: ["recShakti"],
                feltAt: "2026-09-06T14:34:41.000Z", activityDate: "2026-09-06"),
        ]
        let e = ActivityLedger.recognitionEntries(from: rows, byRecord: byRecord, timeZone: newYork)
        XCTAssertEqual(e.map(\.timestamp), [utc(2026, 5, 20, 16, 0, 0), utc(2026, 9, 6, 14, 34, 41)],
                       "May at noon EDT, then September at its instant")
    }

    /// Shadowing is per type and per link: a silence held that day, or another
    /// Śakti felt that day, is not her milestone's twin.
    func testOnlyHerOwnTimestampedRecognitionShadowsHerMilestone() {
        let rows = [
            row("milestone", type: "Shakti Recognized", link: ["recShakti"],
                activityDate: "2026-05-20"),
            row("silence", type: "Silence Held", link: ["recShakti"],
                feltAt: "2026-05-20T16:00:00.000Z", activityDate: "2026-05-20"),
            row("other", type: "Shakti Recognized", link: ["recDeep"],
                feltAt: "2026-05-20T17:00:00.000Z", activityDate: "2026-05-20"),
        ]
        let e = ActivityLedger.recognitionEntries(from: rows, byRecord: byRecord, timeZone: newYork)
        XCTAssertEqual(e.count, 3)
        XCTAssertEqual(e.filter { $0.gesture == .felt && $0.kp == 40 }.count, 1, "her milestone survives")
    }

    // MARK: Her Moments — the rows to show

    func testMomentRowsFoldTheShadowedMilestoneAndKeepTheUnshadowedOneLast() {
        let newest = row("newest", type: "Shakti Recognized", link: ["recShakti"],
                         feltAt: "2026-09-06T14:34:41.000Z", activityDate: "2026-09-06")
        let migrated = row("migrated", type: "Shakti Recognized", link: ["recShakti"],
                           feltAt: "2026-05-21T01:12:00.000Z", activityDate: "2026-05-20")
        let milestone = row("milestone", type: "Shakti Recognized", link: ["recShakti"],
                            activityDate: "2026-05-20")
        XCTAssertEqual(ActivityLedger.momentRows([newest, migrated, milestone], limit: 5,
                                                 timeZone: newYork).map(\.id),
                       ["newest", "migrated"], "one moment, shown once")
        XCTAssertEqual(ActivityLedger.momentRows([newest, milestone], limit: 5,
                                                 timeZone: newYork).map(\.id),
                       ["newest", "milestone"], "an unshadowed milestone shows, after the timestamped rows")
        XCTAssertEqual(ActivityLedger.momentRows([milestone, newest], limit: 5,
                                                 timeZone: newYork).map(\.id),
                       ["newest", "milestone"], "wherever the server placed the blank")
        XCTAssertEqual(ActivityLedger.momentRows([newest, milestone], limit: 1,
                                                 timeZone: newYork).map(\.id),
                       ["newest"], "limit cuts the oldest")
    }

    func testRecognitionEntriesSkipWhatCannotBePlaced() {
        let rows = [
            row("letter", type: "Letter Written", link: ["recShakti"], feltAt: "2026-09-06T14:34:41.000Z"),
            row("crossing", type: "Ring Crossed", link: ["recqdC3D38TWFkf1M"], feltAt: "2026-07-25T15:38:17.000Z", ring: 9),
            row("avaranaSilence", type: "Silence Held", link: ["recqdC3D38TWFkf1M"], feltAt: "2026-05-31T02:12:29.000Z"),
            row("unlinked", type: "Shakti Recognized", link: [], feltAt: "2026-09-06T14:34:41.000Z"),
            row("noLink", type: "Shakti Recognized", link: nil, feltAt: "2026-09-06T14:34:41.000Z"),
            row("noInstant", type: "Shakti Recognized", link: ["recShakti"]),
            row("badDate", type: "Shakti Recognized", link: ["recShakti"], activityDate: "July 13"),
            row("untyped", type: nil, link: ["recShakti"], feltAt: "2026-09-06T14:34:41.000Z"),
        ]
        XCTAssertTrue(ActivityLedger.recognitionEntries(from: rows, byRecord: byRecord, timeZone: newYork).isEmpty,
                      "never coerced to now, never filed under a Śakti it is not")
    }

    func testBlankNotesRestoreAsNoNote() {
        let r = row("r", type: "Shakti Recognized", link: ["recShakti"],
                    feltAt: "2026-09-06T14:34:41.000Z", notes: "  \n")
        XCTAssertNil(ActivityLedger.recognitionEntries(from: [r], byRecord: byRecord).first?.note)
    }

    // MARK: restore — crossings

    func testCrossingsMapRingAndDateOldestFirst() {
        let rows = [
            row("nine", type: "Ring Crossed", link: ["recqdC3D38TWFkf1M"], feltAt: "2026-07-25T15:38:17.000Z", ring: 9),
            row("three", type: "Ring Crossed", link: ["recp4X5tuGdLuHCVw"], feltAt: "2026-07-14T20:00:00Z", ring: 3),
        ]
        let c = ActivityLedger.crossings(from: rows)
        XCTAssertEqual(c.map(\.ring), [3, 9])
        XCTAssertEqual(c.map(\.date), [utc(2026, 7, 14, 20, 0, 0), utc(2026, 7, 25, 15, 38, 17)])
    }

    func testCrossingsGuardRingRangeAndRequireAReadableFeltAt() {
        let rows = [
            row("zero", type: "Ring Crossed", feltAt: "2026-07-25T15:38:17.000Z", ring: 0),
            row("ten", type: "Ring Crossed", feltAt: "2026-07-25T15:38:17.000Z", ring: 10),
            row("noRing", type: "Ring Crossed", feltAt: "2026-07-25T15:38:17.000Z"),
            row("noDate", type: "Ring Crossed", ring: 5),
            row("badDate", type: "Ring Crossed", feltAt: "yesterday", ring: 5),
            row("dateOnly", type: "Ring Crossed", activityDate: "2026-07-25", ring: 5),
            row("notACrossing", type: "Shakti Recognized", feltAt: "2026-07-25T15:38:17.000Z", ring: 5),
        ]
        XCTAssertTrue(ActivityLedger.crossings(from: rows).isEmpty,
                      "a stray row must never rewrite a crossing's date")
    }

    func testCrossingsFeedDescentRestoreShape() {
        let s = DescentState(currentRing: 2, deepestReached: 2, crossings: [])
        let rows = [
            row("three", type: "Ring Crossed", feltAt: "2026-07-14T20:00:00Z", ring: 3),
            row("nine", type: "Ring Crossed", feltAt: "2026-07-25T15:38:17.000Z", ring: 9),
        ]
        s.restore(from: ActivityLedger.crossings(from: rows))
        XCTAssertEqual(s.deepestReached, 9)
        XCTAssertEqual(s.crossings.count, 2)
        XCTAssertEqual(s.enteredCurrentAt, utc(2026, 7, 25, 15, 38, 17))
    }

    func testServerDateReadsBothForms() {
        XCTAssertEqual(ActivityLedger.serverDate("2026-07-13T21:25:33.000Z"), utc(2026, 7, 13, 21, 25, 33))
        XCTAssertEqual(ActivityLedger.serverDate("2026-07-13T21:25:33Z"), utc(2026, 7, 13, 21, 25, 33))
        XCTAssertNil(ActivityLedger.serverDate(nil))
        XCTAssertNil(ActivityLedger.serverDate(""))
        XCTAssertNil(ActivityLedger.serverDate("2026-07-13"))
    }

    // MARK: queue item — build 36 compatibility

    func testBuildThirtySixQueuedJSONStillDecodes() throws {
        // Exactly what build 36's `JSONEncoder` wrote: six members, the date
        // as seconds since the reference date, ids already stamped.
        let json = #"[{"id":"7D1E2F3A-0000-4000-8000-000000000001","type":"Shakti Recognized","linkRecordId":"recShakti","name":"Nāmākarṣiṇī — first recognition","detail":"Felt here for the first time · Waning Crescent","at":810398081.097376,"failCount":1}]"#
        let queue = try JSONDecoder().decode([PendingActivity].self, from: Data(json.utf8))
        XCTAssertEqual(queue.count, 1)
        let item = queue[0]
        XCTAssertEqual(item.id, "7D1E2F3A-0000-4000-8000-000000000001")
        XCTAssertEqual(item.type, "Shakti Recognized")
        XCTAssertEqual(item.linkRecordId, "recShakti")
        XCTAssertEqual(item.name, "Nāmākarṣiṇī — first recognition")
        XCTAssertEqual(item.detail, "Felt here for the first time · Waning Crescent")
        XCTAssertEqual(item.at.timeIntervalSinceReferenceDate, 810_398_081.097376, accuracy: 0.000_001)
        XCTAssertEqual(item.failCount, 1)
        XCTAssertNil(item.gestureSource)
        XCTAssertNil(item.lunarDay)
        XCTAssertNil(item.moonPhase)
        XCTAssertNil(item.descentRing)
        XCTAssertNil(item.durationSec)
        XCTAssertNil(item.notes)
        // …and it drains as a ledger row with only Felt At added.
        let f = ActivityLedger.fields(for: item, timeZone: newYork)
        XCTAssertEqual(f["Felt At"] as? String, "2026-09-06T14:34:41Z")
        XCTAssertEqual(f["Activity Date"] as? String, "2026-09-06")
        XCTAssertNil(f["Notes"])
        XCTAssertNil(f["Gesture Source"])
    }

    func testPreIdQueuedJSONIsStampedByTheQueueStorage() {
        let legacy = Data(#"[{"type":"Letter Written","linkRecordId":"recL","name":"A letter to X","detail":"First letter written","at":800000000,"failCount":0}]"#.utf8)
        let (queue, stamped): ([PendingActivity], Bool) = PendingQueueStorage.decode(legacy)
        XCTAssertTrue(stamped)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue[0].type, "Letter Written")
        XCTAssertNotNil(UUID(uuidString: queue[0].id))
    }

    func testQueueItemRoundTripsWithTheDefaultDateStrategy() throws {
        var a = ActivityLedger.recognition(Moment(note: "I love you", source: "Well", feltAt: instant),
                                           shaktiName: "Sarva-Sammohinī", isFirst: false)
        a.failCount = 2
        let data = try JSONEncoder().encode([a])
        let text = String(decoding: data, as: UTF8.self)
        XCTAssertFalse(text.contains("2026-"), "the date stays a number, as build 36 wrote it")
        XCTAssertTrue(text.contains("\"gestureSource\":\"Well\""))
        let back = try JSONDecoder().decode([PendingActivity].self, from: data)
        XCTAssertEqual(back, [a])
        XCTAssertEqual(back[0].notes, "I love you")
        XCTAssertEqual(back[0].lunarDay, 25)
    }

    func testEachNewItemGetsItsOwnId() {
        let a = ActivityLedger.crossing(ring: 3, feltAt: instant)
        let b = ActivityLedger.crossing(ring: 3, feltAt: instant)
        XCTAssertNotEqual(a.id, b.id)
        XCTAssertNotNil(UUID(uuidString: a.id))
    }

    // MARK: - The margin · `Note Left`

    /// The word itself, and that it is not the letter's word. `Letter Written`
    /// already owns "written", and a letter is to *her* while a note is to the
    /// instrument; two near-identical types would read as one thing to every
    /// other Bindu instrument that shares this ledger.
    func testTheMarginHasItsOwnVerbAndItIsNotTheLettersOwn() {
        XCTAssertEqual(ActivityLedger.ActivityType.noteLeft, "Note Left")
        XCTAssertNotEqual(ActivityLedger.ActivityType.noteLeft,
                          ActivityLedger.ActivityType.letterWritten)
    }

    /// The whole payload of a note, field by field — including the two keys
    /// that must be **absent**.
    func testANoteCarriesHisWordsAndNoLinkAndNoGesture() {
        let item = ActivityLedger.noteLeft(body: "the way out is hard to find", at: instant)
        let f = ActivityLedger.fields(for: item, timeZone: newYork)

        XCTAssertEqual(f[ActivityLedger.Field.sourceApp] as? String, "Mandala")
        XCTAssertEqual(f[ActivityLedger.Field.activityType] as? String, "Note Left")
        XCTAssertEqual(f[ActivityLedger.Field.activityName] as? String,
                       "A note left in the instrument")
        XCTAssertEqual(f[ActivityLedger.Field.notes] as? String, "the way out is hard to find")
        XCTAssertEqual(f[ActivityLedger.Field.activityDate] as? String, "2026-09-06")
        XCTAssertEqual(f[ActivityLedger.Field.feltAt] as? String, "2026-09-06T14:34:41Z")
        XCTAssertEqual(f[ActivityLedger.Field.lunarDay] as? Int, 25)
        XCTAssertEqual(f[ActivityLedger.Field.moonPhase] as? String, "Waning Crescent")
        XCTAssertEqual(f[ActivityLedger.Field.detail] as? String,
                       "Left in the instrument · Waning Crescent")

        XCTAssertNil(f[ActivityLedger.Field.linkToMandala],
                     "a note is about the app, not about a Śakti — it links to nothing")
        XCTAssertNil(f[ActivityLedger.Field.gestureSource],
                     "the four gesture sources name where a gesture toward a Śakti began; "
                     + "a note is not one, and a fifth option would dilute a shared vocabulary")
        XCTAssertNil(f[ActivityLedger.Field.descentRing])
        XCTAssertNil(f[ActivityLedger.Field.durationSec])
    }

    /// **His words are never quoted into a composed string.** The primary column
    /// is a constant, so a note that happened to read "day 3 of this" can never
    /// reach the nine MEASURING patterns `HomesHarnessTests` runs over composed
    /// ledger text — which would have left only two ways out, weakening the
    /// harness or censoring his sentence.
    func testHisWordsReachExactlyOneFieldAndNeverTheName() {
        let measuring = "day 3 of this — 62% of the rooms are a streak"
        let f = ActivityLedger.fields(for: ActivityLedger.noteLeft(body: measuring, at: instant))
        XCTAssertEqual(f[ActivityLedger.Field.notes] as? String, measuring)
        for key in [ActivityLedger.Field.activityName, ActivityLedger.Field.detail] {
            let composed = f[key] as? String ?? ""
            XCTAssertFalse(composed.contains("day 3"), "\(key) is carrying his words")
            XCTAssertFalse(composed.contains("62%"), "\(key) is carrying his words")
        }
    }

    /// A blank note is never posted at all: `fields(for:)` omits an empty Notes,
    /// and a row with no words is not a note.
    func testABlankNoteWritesNoNotesField() {
        let f = ActivityLedger.fields(for: ActivityLedger.noteLeft(body: "   \n ", at: instant))
        XCTAssertNil(f[ActivityLedger.Field.notes])
    }

    /// `at` is the note's own instant, never the flush time — a note queued
    /// offline for three days still lands on the day he wrote it.
    func testAQueuedNoteKeepsTheDayItWasWrittenOn() {
        let written = utc(2026, 9, 6, 23, 10, 0)
        let f = ActivityLedger.fields(for: ActivityLedger.noteLeft(body: "written late", at: written),
                                      timeZone: newYork)
        XCTAssertEqual(f[ActivityLedger.Field.activityDate] as? String, "2026-09-06",
                       "a late-evening note is filed under his day, not tomorrow's UTC date")
        XCTAssertEqual(f[ActivityLedger.Field.feltAt] as? String, "2026-09-06T23:10:00Z")
    }

    // MARK: the dedup key — type + Felt At to the second + his words

    /// The retry the unlinked-item hole would otherwise have written twice: the
    /// very row the create wrote, read back, matches.
    func testTheRowTheCreateWroteIsRecognisedOnTheRetry() {
        let item = ActivityLedger.noteLeft(body: " the way out is hard to find ", at: instant)
        let f = ActivityLedger.fields(for: item)
        let asServerReturnsIt = row("recA", type: f[ActivityLedger.Field.activityType] as? String,
                                    feltAt: "2026-09-06T14:34:41.000Z",
                                    notes: f[ActivityLedger.Field.notes] as? String)
        XCTAssertTrue(ActivityLedger.noteRowMatches(asServerReturnsIt,
                                                    feltAt: instant,
                                                    body: "the way out is hard to find"))
    }

    /// Two notes in the same second with different words are two notes, and the
    /// key separates them — which is the whole reason the body is in it.
    func testTwoDifferentNotesInOneSecondAreTwoNotes() {
        let mine = row("recA", type: "Note Left",
                       feltAt: "2026-09-06T14:34:41.000Z", notes: "the first thing")
        XCTAssertFalse(ActivityLedger.noteRowMatches(mine, feltAt: instant, body: "the second thing"))
    }

    /// The same words at another second are another note.
    func testTheSameWordsAtAnotherSecondAreAnotherNote() {
        let mine = row("recA", type: "Note Left",
                       feltAt: "2026-09-06T14:34:42.000Z", notes: "the same thing")
        XCTAssertFalse(ActivityLedger.noteRowMatches(mine, feltAt: instant, body: "the same thing"))
    }

    /// Another event type at the same second is never a note.
    func testAnotherEventAtTheSameSecondIsNeverANote() {
        let mine = row("recA", type: "Shakti Recognized",
                       feltAt: "2026-09-06T14:34:41.000Z", notes: "the same thing")
        XCTAssertFalse(ActivityLedger.noteRowMatches(mine, feltAt: instant, body: "the same thing"))
    }

    /// A row with no words cannot answer for a note, and neither can a blank
    /// body — an empty key would collapse everything onto everything.
    func testAnEmptyBodyMatchesNothing() {
        let wordless = row("recA", type: "Note Left", feltAt: "2026-09-06T14:34:41.000Z")
        XCTAssertFalse(ActivityLedger.noteRowMatches(wordless, feltAt: instant, body: "something"))
        let real = row("recB", type: "Note Left",
                       feltAt: "2026-09-06T14:34:41.000Z", notes: "something")
        XCTAssertFalse(ActivityLedger.noteRowMatches(real, feltAt: instant, body: "  "))
    }

    /// The dedup fetch reads its own columns and is **not** a widening of
    /// `RecognitionDedup.readFields`, which four other call sites share.
    func testTheNoteDedupReadsItsOwnColumns() {
        XCTAssertEqual(ActivityLedger.noteDedupFields, ["Activity Type", "Felt At", "Notes"])
        XCTAssertNotEqual(ActivityLedger.noteDedupFields, RecognitionDedup.readFields)
    }

    /// **The check that had to exist, and the one shape of test that could ever
    /// have caught this.**
    ///
    /// Every other test on this page hands `noteRowMatches` a `Row` built in
    /// Swift with every field populated. The live path never sees such a row:
    /// `noteExistsOnServer` passes `noteDedupFields` as `fields[]`, and Airtable
    /// answers with *only* those columns. So this decodes the page the fetch
    /// actually receives — the JSON, narrowed exactly as the request narrows it
    /// — and asks the question the device asks.
    ///
    /// It was red before `Activity Type` joined the list: `Row.Fields` decodes
    /// with `decodeIfPresent`, `activityType` came back `nil`, and
    /// `noteRowMatches`' opening guard rejected every live row. The dedup could
    /// not return true on any device. A POST that lands but whose response is
    /// lost — a timeout, a dropped connection, a kill between the create
    /// returning and the stamp — left `ledgeredAt` nil, the next sweep re-posted,
    /// and the ledger held his note twice; a later restore then put both copies
    /// in his margin, in his own words, with no delete path.
    func testTheDedupAsksForEveryColumnItsMatchThenReads() throws {
        // The page, narrowed by `fields[]` to exactly `noteDedupFields`.
        var fields: [String: String] = [:]
        for name in ActivityLedger.noteDedupFields {
            switch name {
            case ActivityLedger.Field.activityType: fields[name] = "Note Left"
            case ActivityLedger.Field.feltAt:       fields[name] = "2026-09-06T14:34:41.000Z"
            case ActivityLedger.Field.notes:        fields[name] = "the way out is hard to find"
            default: XCTFail("the dedup asks for \(name) and this test does not know what it is")
            }
        }
        let payload: [String: Any] = ["records": [["id": "recDUP", "fields": fields]]]
        let data = try JSONSerialization.data(withJSONObject: payload)
        struct Page: Decodable { let records: [ActivityLedger.Row] }
        let rows = try JSONDecoder().decode(Page.self, from: data).records

        XCTAssertTrue(rows.contains {
            ActivityLedger.noteRowMatches($0, feltAt: instant,
                                          body: "the way out is hard to find")
        }, """
        The note the instrument already posted is not recognised when it is read \
        back the way the fetch actually reads it, so the create runs again and the \
        ledger holds his note twice. Every column `noteRowMatches` reads must be \
        named in `noteDedupFields` — `fields[]` is a narrowing, and what is left \
        out of it arrives nil however plainly the server holds it.
        """)
    }

    /// And the same guarantee stated structurally, so it survives a future
    /// column joining the match rule: the recognition dedup is consistent
    /// (asks for neither `Activity Type` nor checks it — its formula narrows the
    /// type already), the restore is consistent the other way (asks for it and
    /// checks it), and the note dedup must be one or the other and never split.
    func testNoDedupEverChecksAColumnItDidNotAskFor() {
        XCTAssertTrue(ActivityLedger.noteDedupFields.contains(ActivityLedger.Field.activityType),
                      "noteRowMatches opens by requiring Activity Type — the fetch must ask for it")
        XCTAssertTrue(ActivityLedger.noteDedupFields.contains(ActivityLedger.Field.feltAt))
        XCTAssertTrue(ActivityLedger.noteDedupFields.contains(ActivityLedger.Field.notes))
        // The recognition path's own consistency, asserted beside it so the two
        // rules are read together rather than drifting apart again.
        XCTAssertFalse(RecognitionDedup.readFields.contains(ActivityLedger.Field.activityType),
                       "rowMatches does not check Activity Type, so its fetch must not need to")
    }

    func testTheNoteDedupFormulaNarrowsToTheMarginAndTheWindow() {
        let f = ActivityLedger.dedup(type: ActivityLedger.ActivityType.noteLeft, around: instant)
        XCTAssertTrue(f.contains("{Source App}='Mandala'"))
        XCTAssertTrue(f.contains("{Activity Type}='Note Left'"))
        XCTAssertTrue(f.contains("IS_AFTER({Felt At}, '2026-09-06T14:33:41Z')"))
        XCTAssertTrue(f.contains("IS_BEFORE({Felt At}, '2026-09-06T14:35:41Z')"))
    }

    // MARK: the path home

    func testTheRestoreFormulaAsksForEveryNoteThisInstrumentWrote() {
        XCTAssertEqual(ActivityLedger.restoreNotes,
                       "AND({Source App}='Mandala', {Activity Type}='Note Left')")
    }

    /// After a reinstall the ledger is the only place his margin still exists.
    /// Oldest first, words trimmed, the instant from `Felt At`.
    func testTheMarginComesHomeFromTheLedger() {
        let rows = [
            row("r1", type: "Note Left", feltAt: "2026-09-06T14:34:41.000Z", notes: " later "),
            row("r2", type: "Note Left", feltAt: "2026-09-05T09:00:00.000Z", notes: "earlier"),
            row("r3", type: "Shakti Recognized", feltAt: "2026-09-05T10:00:00.000Z", notes: "hers"),
        ]
        let back = ActivityLedger.marginNotes(from: rows)
        XCTAssertEqual(back.map(\.body), ["earlier", "later"])
        XCTAssertEqual(back[0].createdAt, utc(2026, 9, 5, 9, 0, 0))
    }

    /// A row with no instant takes noon of its stated day — and one with
    /// neither, or with no words, is skipped rather than coerced to now. A note
    /// dated today that he wrote in March would be a lie about his own margin.
    func testANoteIsNeverDatedNow() {
        let rows = [
            row("r1", type: "Note Left", activityDate: "2026-03-02", notes: "no instant"),
            row("r2", type: "Note Left", notes: "no day at all"),
            row("r3", type: "Note Left", feltAt: "2026-09-06T14:34:41.000Z", notes: "  "),
        ]
        let back = ActivityLedger.marginNotes(from: rows, timeZone: newYork)
        XCTAssertEqual(back.map(\.body), ["no instant"])
        var c = Calendar(identifier: .gregorian)
        c.timeZone = newYork
        XCTAssertEqual(c.component(.hour, from: back[0].createdAt), 12)
    }

    // MARK: the path home stays open

    /// **The door that used to close for good.**
    ///
    /// The restore was guarded on the phone holding no notes at all, and it sat
    /// at the end of a sync that a dead network aborts before reaching it. So:
    /// reinstall with no signal, write one note, and `MarginNote` is never empty
    /// again — the guard returned on every launch for the rest of the install's
    /// life, and every note written before the reinstall stayed in Airtable and
    /// never came back to his list. This stages exactly that sequence against
    /// the rule that replaced it.
    func testANoteWrittenBeforeTheFirstSyncDoesNotStrandEveryEarlierNote() {
        let fromTheLedger = [
            (createdAt: utc(2026, 8, 1, 9, 0, 0), body: "the ring two drone is too loud"),
            (createdAt: utc(2026, 8, 3, 18, 30, 0), body: "a way to withdraw a word"),
        ]
        // What his phone holds after the reinstall: the one note he wrote while
        // the restore could not run.
        let onThePhone = [(createdAt: utc(2026, 9, 6, 14, 34, 41), body: "written on the train")]

        let missing = ActivityLedger.notesMissingLocally(restored: fromTheLedger, local: onThePhone)
        XCTAssertEqual(missing.map(\.body),
                       ["the ring two drone is too loud", "a way to withdraw a word"],
                       "his earlier notes did not come home — under the old emptiness guard this "
                       + "is the launch after which they never could")
    }

    /// Idempotent, which is what lets it run on every sync forever instead of
    /// once, behind a door, on a launch that has to go perfectly.
    func testTheMergeBringsNothingBackTwiceHoweverOftenItRuns() {
        let ledger = [
            (createdAt: utc(2026, 8, 1, 9, 0, 0), body: "the ring two drone is too loud"),
            (createdAt: utc(2026, 8, 3, 18, 30, 0), body: "a way to withdraw a word"),
        ]
        var phone: [ActivityLedger.RestoredNote] = []
        for _ in 0..<5 {
            let missing = ActivityLedger.notesMissingLocally(restored: ledger, local: phone)
            phone.append(contentsOf: missing)
        }
        XCTAssertEqual(phone.map(\.body),
                       ["the ring two drone is too loud", "a way to withdraw a word"],
                       "the merge duplicated his margin by running more than once")
    }

    /// A note the phone wrote and posted comes back from the ledger with its
    /// sub-second detail filed off, because `Felt At` carries seconds and no
    /// fraction. Comparing raw `Date`s would call every note he ever wrote a
    /// note the phone has never seen — and re-insert all of them, every sync.
    func testASecondIsThePrecisionThatSurvivesTheRoundTrip() {
        let written = utc(2026, 9, 6, 14, 34, 41).addingTimeInterval(0.789)
        let asTheLedgerReturnsIt = [(createdAt: utc(2026, 9, 6, 14, 34, 41),
                                     body: "the way out is hard to find")]
        let onThePhone = [(createdAt: written, body: "the way out is hard to find")]
        XCTAssertTrue(ActivityLedger.notesMissingLocally(restored: asTheLedgerReturnsIt,
                                                         local: onThePhone).isEmpty,
                      "the restore would insert a second copy of a note the phone already holds "
                      + "every time it ran")
    }

    /// If two identical rows ever do reach the server, only one note comes back
    /// to his margin.
    func testTwoIdenticalLedgerRowsComeHomeAsOneNote() {
        let twice = [
            (createdAt: utc(2026, 9, 6, 14, 34, 41), body: "said once"),
            (createdAt: utc(2026, 9, 6, 14, 34, 41), body: "said once"),
        ]
        XCTAssertEqual(ActivityLedger.notesMissingLocally(restored: twice, local: []).count, 1)
    }

    /// Two notes a second apart with different words are two notes, here as in
    /// the create-time key — the merge and the dedup share one identity.
    func testTheMergeKeepsTwoDifferentNotesWrittenInTheSameSecond() {
        let both = [
            (createdAt: utc(2026, 9, 6, 14, 34, 41), body: "the first thing"),
            (createdAt: utc(2026, 9, 6, 14, 34, 41), body: "the second thing"),
        ]
        XCTAssertEqual(ActivityLedger.notesMissingLocally(restored: both, local: []).count, 2)
    }
}
