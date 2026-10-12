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
}

struct RiverArchive: Codable, Equatable {
    var letters: [RiverLetter] = []
    var draft: RiverDraft? = nil
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
              at now: Date = .now, calendar: Calendar = .current) -> RiverLetter? {
        guard !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              (1...KhadgamalaMap.total).contains(kp) else { return nil }
        let letter = RiverLetter(id: UUID(), khadgamalaPosition: kp, direction: .forward,
                                 body: body, writtenAt: now,
                                 addressedTo: RiverLetter.openingInstant(opening, khadgamalaPosition: kp,
                                                                         after: now, calendar: calendar),
                                 opening: opening, openedAt: nil,
                                 sealLedgeredAt: nil, openLedgeredAt: nil)
        archive.letters.append(letter)
        archive.draft = nil
        persist()
        return letter
    }

    /// Send a letter back to a moment that has already come. A moment in the
    /// future is not "back", and is held at now.
    @discardableResult
    func sendBack(body: String, to kp: Int, moment: Date, at now: Date = .now) -> RiverLetter? {
        guard !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              (1...KhadgamalaMap.total).contains(kp) else { return nil }
        let letter = RiverLetter(id: UUID(), khadgamalaPosition: kp, direction: .back,
                                 body: body, writtenAt: now, addressedTo: min(moment, now),
                                 opening: nil, openedAt: now,
                                 sealLedgeredAt: nil, openLedgeredAt: now)
        archive.letters.append(letter)
        archive.draft = nil
        persist()
        return letter
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
