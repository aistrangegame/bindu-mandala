import XCTest
@testable import Bindu_Mandala

/// Wave 6 · Slice D — memory, the sister apps and the live data. Storage
/// round-trips, the river's restore and its dedup, the one breath clock, the
/// Score's tolerant decoding, the Codex write's shape, and the laws the new
/// words keep (no figure of his practice, no count on a screen).
@MainActor
final class WaveSixMemoryTests: XCTestCase {

    private var directories: [URL] = []

    override func tearDown() {
        for d in directories { try? FileManager.default.removeItem(at: d) }
        directories = []
        super.tearDown()
    }

    private func freshDirectory() -> URL {
        let d = FileManager.default.temporaryDirectory
            .appendingPathComponent("wave-six-\(UUID().uuidString)", isDirectory: true)
        directories.append(d)
        return d
    }

    private func utc(_ y: Int, _ mo: Int, _ d: Int, _ h: Int, _ mi: Int, _ s: Int = 0) -> Date {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0)!
        return c.date(from: DateComponents(year: y, month: mo, day: d, hour: h, minute: mi, second: s))!
    }

    private var utcCalendar: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(secondsFromGMT: 0)!
        return c
    }

    // MARK: - Letters, widened — storage round trips

    func testALetterToAnAgeWithAVoiceSurvivesARelaunch() throws {
        let dir = freshDirectory()
        let store = CorrespondenceStore(directory: dir)
        let at = utc(2026, 10, 12, 14, 0)
        let back = try XCTUnwrap(store.sendBack(body: "you were brave", to: 31,
                                                moment: utc(1995, 6, 1, 9, 0), at: at,
                                                recipient: RiverRecipient(kind: .age, age: 9),
                                                voiceFile: "voice-x.m4a"))
        let forward = try XCTUnwrap(store.seal(body: "", to: 40, opening: .purnima, at: at,
                                               recipient: RiverRecipient(kind: .laterSelf),
                                               voiceFile: "voice-y.m4a"),
                                    "his voice alone is a letter")
        let light = try XCTUnwrap(store.sendLight(to: utc(2024, 3, 12, 22, 0), through: 42,
                                                  words: "  I see you  ", at: at))
        XCTAssertEqual(light.words, "I see you")

        let again = CorrespondenceStore(directory: dir)
        XCTAssertEqual(again.letters.count, 2)
        XCTAssertEqual(again.letters.first { $0.id == back.id }?.recipient, RiverRecipient(kind: .age, age: 9))
        XCTAssertEqual(again.letters.first { $0.id == back.id }?.voiceFile, "voice-x.m4a")
        XCTAssertEqual(again.letters.first { $0.id == forward.id }?.recipient?.kind, .laterSelf)
        XCTAssertEqual(again.lights, [light])
        XCTAssertNil(store.seal(body: "  ", to: 40, opening: .purnima, at: at),
                     "blank words and no voice seal nothing")
    }

    func testAnArchiveWrittenBeforeWaveSixStillReads() throws {
        let dir = freshDirectory()
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        // A Wave 5 file: no recipient, no voice, no lights.
        let wave5 = """
        {"letters":[{"id":"8C3A3A40-0000-4000-8000-000000000001","khadgamalaPosition":31,
        "direction":"back","body":"old words","writtenAt":800000000,"addressedTo":790000000,
        "openedAt":800000000,"openLedgeredAt":800000000}]}
        """
        try Data(wave5.utf8).write(to: PracticeVault.fileURL(named: CorrespondenceStore.fileName, in: dir))
        let store = CorrespondenceStore(directory: dir)
        XCTAssertEqual(store.letters.count, 1, "the Wave 5 river still decodes")
        XCTAssertNil(store.letters.first?.recipient)
        XCTAssertTrue(store.lights.isEmpty)
    }

    func testTheNameKeptIsHisAndEveryNameStays() {
        let dir = freshDirectory()
        let memory = BinduMemory(directory: dir)
        XCTAssertNil(memory.higherSelfName)
        XCTAssertNotNil(memory.keep(name: "  Ram  ", at: utc(2026, 10, 1, 9, 0)))
        XCTAssertNil(memory.keep(name: "Ram", at: utc(2026, 10, 2, 9, 0)), "the same name twice is one line")
        XCTAssertNotNil(memory.keep(name: "Rāma", at: utc(2026, 10, 3, 9, 0)))
        let again = BinduMemory(directory: dir)
        XCTAssertEqual(again.higherSelfName, "Rāma")
        XCTAssertEqual(again.archive.history.map(\.name), ["Ram", "Rāma"], "nothing he kept is overwritten")
        again.restore(name: "Other", keptAt: .now)
        XCTAssertEqual(again.higherSelfName, "Rāma", "the ledger never replaces a name the phone holds")
    }

    func testCodexNotesAndPlayTracesSurviveARelaunch() {
        let dir = freshDirectory()
        let notes = CodexNoteStore(directory: dir)
        XCTAssertNil(notes.keep(body: "   ", spoken: .typed, origin: nil))
        XCTAssertNotNil(notes.keep(body: "a word of mine", spoken: .spoken, origin: "the month"))
        XCTAssertEqual(CodexNoteStore(directory: dir).notes.map(\.body), ["a word of mine"])

        let traces = PlayTraceStore(directory: dir)
        traces.note(game: "rosary", position: 55, ring: 4, at: utc(2026, 10, 1, 9, 0))
        XCTAssertEqual(PlayTraceStore(directory: dir).traces.map(\.position), [55])
    }

    // MARK: - The river, home from the ledger

    private func row(_ id: String, type: String, name: String? = nil, detail: String? = nil,
                     feltAt: Date?, notes: String? = nil, link: String) -> ActivityLedger.Row {
        var f = ActivityLedger.Row.Fields()
        f.activityType = type
        f.activityName = name
        f.detail = detail
        f.feltAt = feltAt.map { RecognitionDedup.writtenFeltAt($0) }
        f.notes = notes
        f.linkToMandala = [link]
        return ActivityLedger.Row(id: id, fields: f)
    }

    func testRiverLettersComeHomeFromTheLedgerOnceEach() throws {
        let written = utc(2026, 9, 20, 18, 30, 12)
        let moment = utc(1995, 6, 1, 9, 0)
        let forwardAt = utc(2026, 9, 21, 7, 0, 3)
        let back = ActivityLedger.letterSealed(shaktiRecordId: "recA", name: "Kāmākarṣiṇī", forward: false,
                                               opensOn: nil, body: "to the boy", at: written,
                                               to: ActivityLedger.recipientWords(RiverRecipient(kind: .age, age: 9)),
                                               moment: moment)
        XCTAssertEqual(back.name, "A letter to himself at nine — sent back")

        let rows = [
            row("r1", type: back.type, name: back.name, detail: back.detail, feltAt: written,
                notes: "to the boy", link: "recA"),
            // The same row twice (a retried POST that landed) — one letter.
            row("r2", type: back.type, name: back.name, detail: back.detail, feltAt: written,
                notes: "to the boy", link: "recA"),
            row("r3", type: "Letter Sealed", name: "A letter to Nāmākarṣiṇī — sealed",
                detail: "Sealed forward · opens on the full moon · Oct 6, 2026",
                feltAt: forwardAt, notes: "see you there", link: "recB"),
            // A voice-only letter: its sound lived on the phone; nothing to restore.
            row("r4", type: "Letter Sealed", name: "A letter to Nāmākarṣiṇī — sent back",
                detail: "Sent back to a moment", feltAt: written, notes: nil, link: "recB"),
            // A stranger's link is passed over, never guessed.
            row("r5", type: "Letter Sealed", name: "A letter to x — sent back",
                detail: "Sent back to a moment", feltAt: written, notes: "lost", link: "recZ"),
        ]
        let byRecord = ["recA": 31, "recB": 40]
        let restored = ActivityLedger.riverLetters(from: rows, byRecord: byRecord, now: written,
                                                   timeZone: TimeZone(secondsFromGMT: 0)!)
        let unique = ActivityLedger.riverLettersMissingLocally(restored: restored, local: [])
        XCTAssertEqual(unique.count, 2, "two letters, each once: \(unique.map(\.body))")

        let boy = try XCTUnwrap(unique.first { $0.body == "to the boy" })
        XCTAssertEqual(boy.direction, .back)
        XCTAssertEqual(boy.khadgamalaPosition, 31)
        XCTAssertEqual(boy.addressedTo, moment, "the moment it was sent to comes home with it")
        XCTAssertEqual(boy.recipient, RiverRecipient(kind: .age, age: 9))
        XCTAssertNotNil(boy.sealLedgeredAt, "it came from the ledger; it is never written there again")

        let there = try XCTUnwrap(unique.first { $0.body == "see you there" })
        XCTAssertEqual(there.direction, .forward)
        XCTAssertEqual(there.opening, .purnima)
        XCTAssertEqual(there.addressedTo,
                       RiverLetter.openingInstant(.purnima, khadgamalaPosition: 40, after: forwardAt,
                                                  calendar: utcCalendar))
        XCTAssertNil(there.openedAt)

        // On a phone that already holds them, nothing comes twice.
        let dir = freshDirectory()
        let store = CorrespondenceStore(directory: dir)
        XCTAssertEqual(store.mergeRestored(letters: restored), 2)
        XCTAssertEqual(store.mergeRestored(letters: restored), 0, "the merge is idempotent")
        XCTAssertEqual(CorrespondenceStore(directory: dir).letters.count, 2)
    }

    func testALetterWrittenHereIsNotBroughtBackAsASecond() throws {
        let dir = freshDirectory()
        let store = CorrespondenceStore(directory: dir)
        let at = utc(2026, 10, 1, 12, 0, 0).addingTimeInterval(0.42) // sub-second, as the phone writes
        let local = try XCTUnwrap(store.sendBack(body: "mine", to: 31, moment: utc(2026, 9, 1, 9, 0), at: at))
        let sealed = ActivityLedger.letterSealed(shaktiRecordId: "recA", name: "A", forward: false,
                                                 opensOn: nil, body: local.body, at: local.writtenAt,
                                                 moment: local.addressedTo)
        let rows = [row("r1", type: sealed.type, name: sealed.name, detail: sealed.detail,
                        feltAt: local.writtenAt, notes: sealed.notes, link: "recA")]
        let restored = ActivityLedger.riverLetters(from: rows, byRecord: ["recA": 31])
        XCTAssertEqual(store.mergeRestored(letters: restored), 0,
                       "the instant to the second and the words are one letter")
    }

    func testLightAndNameComeHomeToo() throws {
        let sent = utc(2026, 10, 2, 8, 0)
        let moment = utc(2024, 3, 12, 22, 0)
        let item = ActivityLedger.lightSentBack(shaktiRecordId: "recA", name: "Kāmākarṣiṇī",
                                                moment: moment, words: "I see you", at: sent)
        XCTAssertEqual(item.type, "Light Sent Back")
        XCTAssertEqual(item.notes, "I see you")
        let kept = ActivityLedger.nameKept(pointRecordId: "recP", name: "Ram", at: sent)
        XCTAssertEqual(kept.linkRecordId, "recP", "linked, so a retried POST stays one row")
        XCTAssertEqual(kept.notes, "Ram")

        let rows = [row("l1", type: item.type, name: item.name, detail: item.detail, feltAt: sent,
                        notes: item.notes, link: "recA"),
                    row("n1", type: kept.type, name: kept.name, detail: kept.detail, feltAt: sent,
                        notes: "Ram", link: "recP")]
        let lights = ActivityLedger.lightsSentBack(from: rows, byRecord: ["recA": 31])
        XCTAssertEqual(lights.map(\.moment), [moment])
        XCTAssertEqual(ActivityLedger.latestNameKept(from: rows)?.name, "Ram")

        let store = CorrespondenceStore(directory: freshDirectory())
        XCTAssertEqual(store.mergeRestored(lights: lights), 1)
        XCTAssertEqual(store.mergeRestored(lights: lights), 0)
    }

    func testRecipientWordsRoundTrip() {
        for r in [RiverRecipient(kind: .memory), RiverRecipient(kind: .pastSelf),
                  RiverRecipient(kind: .laterSelf), RiverRecipient(kind: .age, age: 9)] {
            let words = ActivityLedger.recipientWords(r)
            XCTAssertNotNil(words)
            XCTAssertEqual(ActivityLedger.recipient(fromWords: words ?? ""), r)
        }
        XCTAssertNil(ActivityLedger.recipientWords(RiverRecipient(kind: .her)), "her is her name")
        XCTAssertFalse(RiverRecipient.Kind.laterSelf.allows(.back))
        XCTAssertFalse(RiverRecipient.Kind.memory.allows(.forward))
    }

    // MARK: - Each world its own clock
    //
    // U0 · retired (VER-L-0741): `testOneBreathClockAndTheRingsAreItsMultiples`
    // — "one 8 s breath clock" is lifted. What the verification world keeps is
    // each clock in its own world: the nine metabolisms (ring 1 holds; rings
    // 2–9 at Design's 3/8/9/11/13/15/18/4 s).

    func testEachRingKeepsItsOwnMetabolism() {
        XCTAssertNil(FieldBreath.period(ring: 1), "ring 1 holds")
        XCTAssertEqual((2...9).compactMap { FieldBreath.period(ring: $0) }, [3, 8, 9, 11, 13, 15, 18, 4])
    }

    // MARK: - The live Score

    func testTheScoreDecodesTolerantly() throws {
        let s = try XCTUnwrap(ShaktiScore.decode("""
        {"light": {"hue": "390", "glow": 1.4},
         "tempo": {"breath_s": 9, "rate": 0.1},
         "sound": {"carrier_hz": "136.1", "fifth": "Absent", "ground": 0.5}}
        """))
        XCTAssertEqual(s.light.hue ?? -1, 30, accuracy: 1e-9, "hue wraps into the circle")
        XCTAssertEqual(s.light.glow, 1, "glow is held to 0…1")
        XCTAssertEqual(s.breathing.breath, 9)
        XCTAssertEqual(s.breathing.rate, 0.25, "a rate is held to its range")
        XCTAssertEqual(s.sound.carrierHz ?? 0, 136.1, accuracy: 1e-9)
        XCTAssertEqual(s.sound.fifth, .ground)
        XCTAssertEqual(s.sound.ground, 0.5)

        let hex = try XCTUnwrap(ShaktiScore.decode(##"{"light":{"color":"#00FF00"}}"##))
        XCTAssertEqual(hex.light.hue ?? -1, 120, accuracy: 1e-9)
        XCTAssertTrue(try XCTUnwrap(ShaktiScore.decode("{}")).isEmpty, "an empty Score leaves the grammar whole")
        XCTAssertNil(ShaktiScore.decode("not json"), "a broken Score is no Score — the grammar stands")
        XCTAssertNil(ShaktiScore.decode("[1,2]"))
        let badHz = try XCTUnwrap(ShaktiScore.decode(#"{"sound":{"carrier_hz": 5}}"#))
        XCTAssertNil(badHz.sound.carrierHz, "a carrier no ear can hear is not taken")
    }

    func testTheAbsentFifthIsGroundFromTheFirstBeat() {
        XCTAssertEqual(HomeCarrier.groundFifthRatio, 0.75)
        XCTAssertGreaterThan(HomeCarrier.groundFifthGain(amount: 0.05), 0, "present from the first beat")
        XCTAssertEqual(HomeCarrier.groundFifthGain(amount: 1), HomeCarrier.groundFifthLevel, accuracy: 1e-12)
        XCTAssertLessThan(HomeCarrier.groundFifthLevel, HomeCarrier.carrierLevel, "beneath the carrier")
        // The Mandala's own fifth still arrives as completion…
        XCTAssertEqual(HomeCarrier.fifthGain(b: 0, ring: 3, score: nil), 0)
        XCTAssertEqual(HomeCarrier.fifthGain(b: 1, ring: 3, score: nil), HomeCarrier.fifthLevel)
        // …unless her Score says otherwise.
        XCTAssertEqual(HomeCarrier.fifthGain(b: 0, ring: 3, score: .granted), HomeCarrier.fifthLevel)
        XCTAssertEqual(HomeCarrier.fifthGain(b: 1, ring: 9, score: .ground), 0)
    }

    // MARK: - The raw Codex write

    func testTheCodexWriteIsHisNoteWithStatusUnset() {
        let note = PendingCodexNote(body: "  The month landed.\nAnd more.  ", at: utc(2026, 10, 12, 23, 30),
                                    spoken: .spoken)
        let f = CodexWrite.fields(for: note, timeZone: TimeZone(secondsFromGMT: 0)!)
        XCTAssertEqual(f[CodexWrite.FieldID.sourceApp] as? String, "Bindu Mandala")
        XCTAssertEqual(f[CodexWrite.FieldID.rawMemo] as? String, "The month landed.\nAnd more.")
        XCTAssertEqual(f[CodexWrite.FieldID.title] as? String, "The month landed.")
        XCTAssertEqual(f[CodexWrite.FieldID.date] as? String, "2026-10-12")
        XCTAssertNil(f[CodexWrite.FieldID.status], "Status is never written — no automation fires unasked")
        XCTAssertEqual(f.count, 4)
        XCTAssertEqual(CodexWrite.tableId, "tblDF4OCMcRoxkQjU")
        XCTAssertNotEqual(CodexWrite.tableId, ActivityLedger.tableId)
        // Nothing of the event ledger's vocabulary reaches the Codex.
        XCTAssertFalse(f.keys.contains(ActivityLedger.Field.activityType))

        let formula = CodexWrite.dedupFormula(for: note, timeZone: TimeZone(secondsFromGMT: 0)!)
        XCTAssertTrue(formula.contains("'Bindu Mandala'"))
        XCTAssertTrue(formula.contains("2026-10-12"))

        var r = CodexWrite.Row(id: "rec1", fields: .init())
        r.fields.rawMemo = "The month landed.\\\nAnd  more.\n"
        XCTAssertTrue(CodexWrite.rowMatches(r, body: note.body), "the same words, as rich text returns them")
        r.fields.rawMemo = "Something else"
        XCTAssertFalse(CodexWrite.rowMatches(r, body: note.body))

        let long = String(repeating: "a", count: 200)
        XCTAssertEqual(CodexWrite.title(for: long).count, 80)
    }

    func testTheCodexQueueItemSurvivesItsOwnEncoding() throws {
        let item = PendingCodexNote(body: "word", at: utc(2026, 10, 12, 9, 0))
        let data = try JSONEncoder().encode([item])
        let (queue, stamped): ([PendingCodexNote], Bool) = PendingQueueStorage.decode(data)
        XCTAssertFalse(stamped)
        XCTAssertEqual(queue, [item])
        XCTAssertNil(PendingQueuePolicy.maxFailures, "a Codex note waits as long as it must")
    }

    // MARK: - Live ring and Śakti facts

    func testRingFactsCarryTheNewFieldsAndStillReadTheOld() throws {
        let old = #"{"2":{"gem":"g","siddhi":"s"}}"#
        let decoded = try JSONDecoder().decode([String: RingFactsCache.Facts].self, from: Data(old.utf8))
        XCTAssertNil(decoded["2"]?.mudra, "a cache written before Wave 6 still decodes")
        XCTAssertEqual(RingFactsCache.phaseWords("Srishti"), "Sṛṣṭi")
        XCTAssertEqual(RingFactsCache.phaseWords("Samhara"), "Saṃhāra")
        XCTAssertNil(RingFactsCache.phaseWords("  "))
    }

    func testTheSisterIsFoundByPositionNeverByName() {
        // The base, in its own link order: 53 ↔ 19 namesakes; 55 → its Mudrā
        // namesake first, then every Karṣiṇī; a Karṣiṇī → 55.
        let related: [Int: [Int]] = [53: [19], 19: [53], 55: [21, 29, 30], 21: [55], 29: [55], 7: []]
        func r(_ kp: Int) -> [Int] { related[kp] ?? [] }
        XCTAssertEqual(ShaktiFactsCache.sister(of: 53, related: r), 19)
        XCTAssertEqual(ShaktiFactsCache.sister(of: 55, related: r), 21, "her namesake comes first")
        XCTAssertEqual(ShaktiFactsCache.sister(of: 29, related: r), 55)
        XCTAssertNil(ShaktiFactsCache.sister(of: 7, related: r), "most have no third door")
    }

    // MARK: - Grace reads the sisters

    func testGraceSpeaksASisterAppsMomentInItsOwnVerb() {
        let now = utc(2026, 10, 12, 9, 0)
        var f = ActivityLedger.Row.Fields()
        f.activityType = "Chapter Completed"
        f.sourceApp = "Learning"
        f.feltAt = RecognitionDedup.writtenFeltAt(utc(2026, 10, 9, 21, 0))
        f.linkToMandala = ["recHer"]
        let line = GraceChannel.choose(rows: [ActivityLedger.Row(id: "g1", fields: f)],
                                       herRecordId: "recHer", sisterRecordIds: [],
                                       names: ["recHer": "Kāmākarṣiṇī"], now: now,
                                       calendar: utcCalendar, lastSurfaced: nil, surfaced: [])
        XCTAssertEqual(line?.text, "Three nights ago, you finished a door in your reading. It was standing in this room.")
        XCTAssertTrue(GraceChannel.fields.contains(ActivityLedger.Field.sourceApp))
        XCTAssertNil(GraceChannel.sisterVerb(for: "Something Unknown"), "silence when nothing fits")
    }

    // MARK: - Her screen deepens

    /// U0 rewrite (VER-L-0812): deepening is offered, never withheld. The
    /// assertions that each layer stays shut until enough returns
    /// (`open(visits:available:)` as a gate) and the no-digit clause on the
    /// titles are retired; U4 gives every layer a direct door beside the slow
    /// one. What stays: a return is counted by her position alone, a sheet is
    /// not a return, and the layers are her own words in order.
    func testHerScreenKnowsAReturnByPositionAndHoldsHerLayers() {
        let suite = "wave6-deepening-\(UUID().uuidString)"
        let d = UserDefaults(suiteName: suite)!
        defer { d.removePersistentDomain(forName: suite) }
        let t0 = utc(2026, 10, 1, 9, 0)
        XCTAssertEqual(HerDeepening.arrive(40, now: t0, d), 1)
        XCTAssertEqual(HerDeepening.arrive(40, now: t0.addingTimeInterval(60), d), 1,
                       "back from a sheet is not a return")
        XCTAssertEqual(HerDeepening.arrive(40, now: t0.addingTimeInterval(3_600), d), 2)
        XCTAssertEqual(HerDeepening.visits(41, d), 0, "her position is the only key")

        let layers = HerDeepening.layers(function: "She draws.", mentalState: " ", siddhi: "Aṇimā",
                                         etymology: nil, qualities: "x", ringNotes: "The ring.")
        XCTAssertEqual(layers.map(\.title), ["what she does", "what her ring gives", "how she is known", "her enclosure"])
        XCTAssertEqual(HerDeepening.open(visits: 99, available: layers.count), layers.count,
                       "every layer can be open")
    }

    // MARK: - The month and the book

    func testTheMonthIsWitnessedFromHisRecordAndNeverMeasured() {
        let month = utc(2026, 9, 15, 12, 0)
        let acts: [MonthReading.Act] = [
            .init(kind: .felt, at: utc(2026, 9, 2, 9, 0), kp: 31, words: nil),
            .init(kind: .felt, at: utc(2026, 9, 2, 9, 5), kp: 31, words: "warm in the chest"),
            .init(kind: .felt, at: utc(2026, 9, 9, 9, 0), kp: 55, words: nil),
            .init(kind: .letter, at: utc(2026, 9, 9, 10, 0), kp: 55, words: "to you, at last"),
            .init(kind: .played, at: utc(2026, 9, 20, 10, 0), kp: nil, words: nil),
            .init(kind: .felt, at: utc(2026, 10, 1, 9, 0), kp: 40, words: "outside the month"),
        ]
        let names = [31: "Ahaṅkārākarṣiṇī", 55: "Sarva-Ākarṣiṇī", 40: "Nāmākarṣiṇī"]
        let r = MonthReading.read(month: month, acts: acts, name: { names[$0] ?? "" }, calendar: utcCalendar)
        XCTAssertEqual(r.glyphs.count, 3, "one glyph per day walked; no slot for a day not walked")
        XCTAssertEqual(r.glyphs.first?.met, [31], "a dot is her, once")
        XCTAssertEqual(r.glyphs.map(\.sealed), [false, true, false], "an ember is a state")
        XCTAssertEqual(r.touched, [2, 4])
        XCTAssertTrue(r.letter.contains("Ahaṅkārākarṣiṇī"))
        XCTAssertTrue(r.letter.contains("you set letters into the river"))
        XCTAssertFalse(r.letter.contains("Nāmākarṣiṇī"), "only this month's record")
        XCTAssertEqual(r.turningLine, "“to you, at last”", "the turning is his own words")
        XCTAssertEqual(r.deeper, "You wrote: “warm in the chest”")
        // The month is composed from his record, so a digit here would be a
        // quantity of his practice (how many days, how many met): the narrow
        // floor keeps this clause (V33).
        for text in [r.letter, r.witness, r.turningLine ?? "", r.deeper ?? ""] {
            XCTAssertNil(text.rangeOfCharacter(from: .decimalDigits), "a number reached the month: \(text)")
            XCTAssertTrue(NeverMeasure.measuresOutLoud(text).isEmpty, text)
        }

        let quiet = MonthReading.read(month: utc(2026, 8, 1, 0, 0), acts: acts, name: { _ in "" },
                                      calendar: utcCalendar)
        XCTAssertTrue(quiet.isQuiet)
        XCTAssertEqual(quiet.witness, "A quiet month. Quiet is not empty.")
    }

    func testTheBooksMiddlePageIsADoor() {
        func page(_ i: Int) -> ArchiveBook.Page {
            .init(id: "p\(i)", kind: .note, at: Date(timeIntervalSince1970: Double(1_000 - i)),
                  heading: "", words: "w\(i)")
        }
        let book = ArchiveBook.bind((0..<5).map(page))
        XCTAssertEqual(book.count, 6)
        XCTAssertEqual(ArchiveBook.doorIndex(in: book), 2)
        XCTAssertEqual(book.first?.id, "p4", "oldest first")
        XCTAssertEqual(ArchiveBook.doorIndex(in: ArchiveBook.bind([])), 0, "an empty book is its door")
        XCTAssertEqual(ArchiveBook.patina(.now), 0, accuracy: 1e-6)
    }

    // MARK: - Play feeds the Portrait as states

    func testPlayLayersAreStatesThatCoolNeverCounts() {
        let now = utc(2026, 10, 12, 9, 0)
        let once = [PlayTrace(game: "drum", position: nil, ring: 1, at: now)]
        let many = Array(repeating: once[0], count: 40)
        XCTAssertEqual(PlayLayers.warmth(lastFed: PlayLayers.lastFed(.roots, traces: once), now: now),
                       PlayLayers.warmth(lastFed: PlayLayers.lastFed(.roots, traces: many), now: now),
                       "forty games and one game draw the same layer")
        XCTAssertEqual(PlayLayers.warmth(lastFed: nil, now: now), 0, "dormant")
        let cooled = PlayLayers.warmth(lastFed: now.addingTimeInterval(-200 * 86_400), now: now)
        XCTAssertGreaterThan(cooled, 0.24, "it cools to an ember, never to nothing")
        XCTAssertTrue(Set(PlayLayers.wheelOrder).isSubset(of: Set(PlayGame.allCases.map(\.rawValue))),
                      "every spoke is a real game")
    }

    // MARK: - The heart register

    func testTheHeartRegisterIsAuthoredScaleNotARecording() {
        XCTAssertEqual(HeartRegister.droneRatios, [0.5, 1, 1.5, 2])
        XCTAssertEqual(HeartRegister.hz(sa: 100, semitones: 12), 200, accuracy: 1e-9)
        XCTAssertEqual(HeartRegister.answerSeconds, BreathClock.breath, "his answer is one breath long")
        for phrase in HeartRegister.phrases {
            XCTAssertTrue(phrase.allSatisfy { (-12...12).contains($0) })
        }
    }
}
