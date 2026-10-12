import Foundation
import Observation

/// A letter in the river (Wave 5 · the Correspondence, Codex C-1346).
///
/// The Well's first form — one letter per Śakti, `ShaktiLetter`, keyed by her
/// position and edited in place — is untouched. The river carries letters
/// *beside* it: written once, set down, never edited again.
///
///   • **back** — to a moment that has already happened. It arrives where it was
///     sent at once: the past has already come.
///   • **forward** — to her day in the lunar cycle. **Sealed with no peek**: the
///     body is not shown, not summarised, not hinted at, until the day comes;
///     then it is revealed word by word.
///
/// Every word is his. Nothing in the instrument writes a body, completes one,
/// or answers one. There is no reply.
struct RiverLetter: Codable, Equatable, Identifiable {

    enum Direction: String, Codable { case back, forward }

    /// Where a forward letter is sent: a day the real moon (or her own turn of
    /// the cycle) will bring round.
    enum Opening: String, Codable, CaseIterable, Identifiable {
        /// The next Pūrṇimā — the full moon's tithi begins.
        case purnima
        /// The next Amāvasyā — the dark moon's tithi begins.
        case amavasya
        /// When this very tithi comes round again, one lunar month on.
        case tithiReturns
        /// When she next presides over the day (the 6 am turn of the 102).
        case herDay

        var id: String { rawValue }

        var words: String {
            switch self {
            case .purnima:      return "the full moon"
            case .amavasya:     return "the dark moon"
            case .tithiReturns: return "when this moon returns"
            case .herDay:       return "her next day"
            }
        }
    }

    var id: UUID
    /// Her identity, 1–102.
    var khadgamalaPosition: Int
    var direction: Direction
    var body: String
    var writtenAt: Date
    /// Back: the moment it was sent to. Forward: the instant it opens.
    var addressedTo: Date
    var opening: Opening?
    /// When he opened it. A forward letter is revealed once, word by word; after
    /// that it rests in the river with the rest.
    var openedAt: Date?
    var sealLedgeredAt: Date?
    var openLedgeredAt: Date?
    /// Wave 6 · who the letter is to. `nil` (every letter before Wave 6) is her.
    var recipient: RiverRecipient? = nil
    /// Wave 6 · his own voice, kept beside the words: a file name inside
    /// `Practice/voice/`. The words (`body`) are what he said, set down on the
    /// phone; the sound is his and is never generated.
    var voiceFile: String? = nil

    /// Still sealed: forward, its day not yet come.
    func isSealed(at now: Date) -> Bool {
        direction == .forward && now < addressedTo
    }

    /// Its day has come and he has not yet opened it.
    func isDue(at now: Date) -> Bool {
        direction == .forward && now >= addressedTo && openedAt == nil
    }

    /// May its words be shown? Back letters always; forward letters only once
    /// opened.
    func isReadable(at now: Date) -> Bool {
        direction == .back || (openedAt != nil && now >= addressedTo)
    }

    /// Paper yellowing by real time: 0 when written, approaching 1 over the
    /// years (≈ 0.63 at eight months). A fact about the page, never about him.
    func patina(at now: Date) -> Double {
        let days = max(0, now.timeIntervalSince(writtenAt) / 86_400)
        return 1 - exp(-days / 240)
    }

    /// The instant a forward letter written `now` to her opens.
    static func openingInstant(_ opening: Opening, khadgamalaPosition kp: Int,
                               after now: Date, calendar: Calendar = .current) -> Date {
        switch opening {
        case .purnima:
            return Panchanga.nextStart(ofTithi: 15, after: now)
        case .amavasya:
            return Panchanga.nextStart(ofTithi: 30, after: now)
        case .tithiReturns:
            return Panchanga.nextStart(ofTithi: Panchanga.tithi(at: now), after: now)
        case .herDay:
            let today = calendar.startOfDay(for: now)
            for offset in 1...420 {
                guard let day = calendar.date(byAdding: .day, value: offset, to: today),
                      let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: day)
                else { continue }
                if DailyEnergyService.todaysPosition(for: noon, calendar: calendar) == kp {
                    return calendar.date(bySettingHour: DailyEnergyService.dayBoundaryHour,
                                         minute: 0, second: 0, of: day) ?? noon
                }
            }
            return Panchanga.nextStart(ofTithi: 15, after: now)
        }
    }
}

/// An unfinished letter, kept so that nothing he has typed is ever lost to a
/// dismissed sheet or a killed app. It is his, and it is never sent by itself.
struct RiverDraft: Codable, Equatable {
    var khadgamalaPosition: Int
    var direction: RiverLetter.Direction
    var body: String
    var opening: RiverLetter.Opening
    var addressedTo: Date
    var recipient: RiverRecipient? = nil
    var voiceFile: String? = nil
}

/// Wave 6 · who a river letter is to (C-1346): her, or himself at an age, a
/// memory, his past self, his later self. A letter to a memory names the
/// memory in its own first line — his words, kept in one place.
struct RiverRecipient: Codable, Equatable, Hashable {
    enum Kind: String, Codable, CaseIterable, Identifiable {
        case her, age, memory, pastSelf, laterSelf
        var id: String { rawValue }

        /// The composer's own words for each.
        var words: String {
            switch self {
            case .her:       return "her"
            case .age:       return "myself, at an age"
            case .memory:    return "a memory"
            case .pastSelf:  return "my past self"
            case .laterSelf: return "my later self"
            }
        }

        /// Which way a letter to this one may go.
        func allows(_ d: RiverLetter.Direction) -> Bool {
            switch self {
            case .her, .age:  return true
            case .memory, .pastSelf: return d == .back
            case .laterSelf:  return d == .forward
            }
        }
    }
    var kind: Kind
    var age: Int? = nil

    /// The heading a page carries: "to Kāmākarṣiṇī", "to myself at nine".
    func heading(herName: String) -> String {
        switch kind {
        case .her:       return "to \(herName)"
        case .age:       return age.map { "to myself at \(ActivityLedger.spelled($0))" } ?? "to myself, at an age"
        case .memory:    return "to a memory"
        case .pastSelf:  return "to my past self"
        case .laterSelf: return "to my later self"
        }
    }
}

/// Wave 6 · appreciation sent back (C-1126, C-1101, C-1253): light, not
/// words, sent to a dated moment he felt lost — "to help complete the loop".
/// It never marks the day as a bad one; the Portrait's bead for that day warms.
struct LightSentBack: Codable, Equatable, Identifiable {
    var id: UUID
    /// The Śakti whose light was sent (today's, unless he chose another).
    var khadgamalaPosition: Int
    /// The moment it was sent to.
    var moment: Date
    /// A few words of his beside the light, if he set any.
    var words: String?
    var sentAt: Date
    var ledgeredAt: Date?
}

struct RiverArchive: Codable, Equatable {
    var letters: [RiverLetter] = []
    var draft: RiverDraft? = nil
    /// Wave 6 · optional so every archive written before it still decodes.
    var lights: [LightSentBack]? = nil
}

@MainActor
@Observable
final class CorrespondenceStore {

    static let shared = CorrespondenceStore()
    static let fileName = "correspondence"

    let directory: URL
    private(set) var archive: RiverArchive = RiverArchive()

    init(directory: URL = PracticeVault.defaultDirectory) {
        self.directory = directory
        archive = PracticeVault.read(RiverArchive.self, named: Self.fileName, in: directory) ?? RiverArchive()
    }

    var letters: [RiverLetter] { archive.letters }
    var draft: RiverDraft? { archive.draft }

    /// Is any letter still sealed? (The Portrait's eye closes while one is.)
    func hasSealed(at now: Date = .now) -> Bool {
        archive.letters.contains { $0.isSealed(at: now) }
    }

    /// Seal a letter forward. Blank words seal nothing.
    @discardableResult
    func seal(body: String, to kp: Int, opening: RiverLetter.Opening,
              at now: Date = .now, calendar: Calendar = .current,
              recipient: RiverRecipient? = nil, voiceFile: String? = nil) -> RiverLetter? {
        guard Self.hasSomething(body: body, voiceFile: voiceFile),
              (1...KhadgamalaMap.total).contains(kp) else { return nil }
        var letter = RiverLetter(id: UUID(), khadgamalaPosition: kp, direction: .forward,
                                 body: body, writtenAt: now,
                                 addressedTo: RiverLetter.openingInstant(opening, khadgamalaPosition: kp,
                                                                         after: now, calendar: calendar),
                                 opening: opening, openedAt: nil,
                                 sealLedgeredAt: nil, openLedgeredAt: nil)
        letter.recipient = (recipient?.kind == .her) ? nil : recipient
        letter.voiceFile = voiceFile
        archive.letters.append(letter)
        archive.draft = nil
        persist()
        return letter
    }

    /// Send a letter back to a moment that has already come. A moment in the
    /// future is not "back", and is held at now.
    @discardableResult
    func sendBack(body: String, to kp: Int, moment: Date, at now: Date = .now,
                  recipient: RiverRecipient? = nil, voiceFile: String? = nil) -> RiverLetter? {
        guard Self.hasSomething(body: body, voiceFile: voiceFile),
              (1...KhadgamalaMap.total).contains(kp) else { return nil }
        var letter = RiverLetter(id: UUID(), khadgamalaPosition: kp, direction: .back,
                                 body: body, writtenAt: now, addressedTo: min(moment, now),
                                 opening: nil, openedAt: now,
                                 sealLedgeredAt: nil, openLedgeredAt: now)
        letter.recipient = (recipient?.kind == .her) ? nil : recipient
        letter.voiceFile = voiceFile
        archive.letters.append(letter)
        archive.draft = nil
        persist()
        return letter
    }

    /// Words, or his voice: either is a letter. Neither is nothing.
    static func hasSomething(body: String, voiceFile: String?) -> Bool {
        !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !(voiceFile ?? "").isEmpty
    }

    // MARK: Wave 6 · light sent back

    var lights: [LightSentBack] { archive.lights ?? [] }

    /// Send light — appreciation, not words — back to a moment he felt lost.
    /// A moment in the future is held at now.
    @discardableResult
    func sendLight(to moment: Date, through kp: Int, words: String? = nil,
                   at now: Date = .now) -> LightSentBack? {
        guard (1...KhadgamalaMap.total).contains(kp) else { return nil }
        let trimmed = words?.trimmingCharacters(in: .whitespacesAndNewlines)
        let light = LightSentBack(id: UUID(), khadgamalaPosition: kp, moment: min(moment, now),
                                  words: (trimmed ?? "").isEmpty ? nil : trimmed,
                                  sentAt: now, ledgeredAt: nil)
        var all = archive.lights ?? []
        all.append(light)
        archive.lights = all
        persist()
        return light
    }

    func unledgeredLights() -> [LightSentBack] {
        lights.filter { $0.ledgeredAt == nil }
    }

    func markLightLedgered(_ id: UUID, at now: Date = .now) {
        guard var all = archive.lights, let i = all.firstIndex(where: { $0.id == id }) else { return }
        all[i].ledgeredAt = now
        archive.lights = all
        persist()
    }

    // MARK: Wave 6 · the path home after a reinstall

    /// Merge letters the ledger holds and this phone does not, on identity —
    /// idempotent, so it may run on every sync; nothing already here is touched.
    /// Returns how many came home (for the log only; never shown).
    @discardableResult
    func mergeRestored(letters restored: [RiverLetter]) -> Int {
        let missing = ActivityLedger.riverLettersMissingLocally(restored: restored,
                                                                local: archive.letters)
        guard !missing.isEmpty else { return 0 }
        archive.letters.append(contentsOf: missing)
        archive.letters.sort { $0.writtenAt < $1.writtenAt }
        persist()
        return missing.count
    }

    /// The same for lights: one light per (position, moment, instant sent).
    @discardableResult
    func mergeRestored(lights restored: [LightSentBack]) -> Int {
        func key(_ l: LightSentBack) -> String {
            "\(l.khadgamalaPosition)\u{1F}" + RecognitionDedup.writtenFeltAt(l.moment)
                + "\u{1F}" + RecognitionDedup.writtenFeltAt(l.sentAt)
        }
        var all = archive.lights ?? []
        var seen = Set(all.map(key))
        var added = 0
        for l in restored where !seen.contains(key(l)) {
            seen.insert(key(l))
            all.append(l)
            added += 1
        }
        guard added > 0 else { return 0 }
        archive.lights = all.sorted { $0.sentAt < $1.sentAt }
        persist()
        return added
    }

    /// He has opened a letter whose day has come. Opening a sealed one is
    /// refused: there is no peek.
    @discardableResult
    func open(_ id: UUID, at now: Date = .now) -> Bool {
        guard let i = archive.letters.firstIndex(where: { $0.id == id }) else { return false }
        guard archive.letters[i].direction == .forward,
              now >= archive.letters[i].addressedTo else { return false }
        if archive.letters[i].openedAt == nil {
            archive.letters[i].openedAt = now
            persist()
        }
        return true
    }

    func saveDraft(_ draft: RiverDraft?) {
        guard archive.draft != draft else { return }
        archive.draft = draft
        persist()
    }

    // MARK: The ledger's half

    func unledgeredSeals() -> [RiverLetter] {
        archive.letters.filter { $0.sealLedgeredAt == nil }
    }

    func unledgeredOpenings() -> [RiverLetter] {
        archive.letters.filter { $0.direction == .forward && $0.openedAt != nil && $0.openLedgeredAt == nil }
    }

    func markSealLedgered(_ id: UUID, at now: Date = .now) {
        guard let i = archive.letters.firstIndex(where: { $0.id == id }) else { return }
        archive.letters[i].sealLedgeredAt = now
        persist()
    }

    func markOpenLedgered(_ id: UUID, at now: Date = .now) {
        guard let i = archive.letters.firstIndex(where: { $0.id == id }) else { return }
        archive.letters[i].openLedgeredAt = now
        persist()
    }

    private func persist() {
        try? PracticeVault.write(archive, named: Self.fileName, in: directory)
    }
}
