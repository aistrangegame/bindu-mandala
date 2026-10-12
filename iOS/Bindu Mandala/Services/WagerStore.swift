import Foundation
import Observation

/// The Wager (Wave 5 · padakarshini A12): *"watch for her today… did she
/// appear?"* — catching her in the act. Placed in the morning (any time, in
/// truth), answered from the evening on.
///
/// Both answers close it, and neither is a verdict: "she appeared" and "not
/// this time" are the same act of having watched. Nothing is tallied, nothing
/// carries forward, and an unanswered wager is never a debt — it simply waits
/// on her screen until he says.
struct Wager: Codable, Equatable, Identifiable {
    var id: UUID
    var khadgamalaPosition: Int
    var placedAt: Date
    var resolvedAt: Date?
    var appeared: Bool?
    var ledgeredAt: Date?
}

struct WagerArchive: Codable, Equatable {
    var wagers: [Wager] = []
}

@MainActor
@Observable
final class WagerStore {

    static let shared = WagerStore()
    static let fileName = "wagers"
    /// The evening opens at this local hour: from then the day's watch may be
    /// answered. A wager from an earlier day may be answered at any hour.
    static let eveningHour = 17

    let directory: URL
    private(set) var archive: WagerArchive = WagerArchive()

    init(directory: URL = PracticeVault.defaultDirectory) {
        self.directory = directory
        archive = PracticeVault.read(WagerArchive.self, named: Self.fileName, in: directory) ?? WagerArchive()
    }

    /// Her open watch, if he is watching for her.
    func openWager(for kp: Int) -> Wager? {
        archive.wagers.last { $0.khadgamalaPosition == kp && $0.resolvedAt == nil }
    }

    /// Watch for her. One open watch per Śakti; placing again returns it.
    @discardableResult
    func place(for kp: Int, at now: Date = .now) -> Wager {
        if let open = openWager(for: kp) { return open }
        let w = Wager(id: UUID(), khadgamalaPosition: kp, placedAt: now,
                      resolvedAt: nil, appeared: nil, ledgeredAt: nil)
        archive.wagers.append(w)
        persist()
        return w
    }

    /// May this watch be answered yet? From the evening of the day it was
    /// placed, or on any later day.
    static func canResolve(_ wager: Wager, at now: Date, calendar: Calendar = .current) -> Bool {
        guard wager.resolvedAt == nil else { return false }
        if !calendar.isDate(now, inSameDayAs: wager.placedAt) { return now > wager.placedAt }
        return calendar.component(.hour, from: now) >= eveningHour
    }

    @discardableResult
    func resolve(_ id: UUID, appeared: Bool, at now: Date = .now) -> Wager? {
        guard let i = archive.wagers.firstIndex(where: { $0.id == id }),
              archive.wagers[i].resolvedAt == nil else { return nil }
        archive.wagers[i].resolvedAt = now
        archive.wagers[i].appeared = appeared
        persist()
        return archive.wagers[i]
    }

    // MARK: Wave 6 · she might appear today (C-1195)

    /// **Energy recedes when it is watched** (C-1195: *"energy recedes when
    /// told, even in anticipation of telling, and returns unobserved"*). The
    /// Wager asked him to watch for her and then, in the evening, pressed a
    /// question for an answer. Now nothing is placed and nothing asks: her
    /// screen says only that she might appear today, and if — in passing — he
    /// noticed her, he may say so, at any hour. That is the one act; there is no
    /// "not this time", because nothing was owed.
    ///
    /// An open watch from before (Wave 5) is answered by this same noticing, so
    /// no record is orphaned and none is lost. Noticing twice in one day is
    /// one noticing.
    @discardableResult
    func notice(for kp: Int, at now: Date = .now, calendar: Calendar = .current) -> Wager {
        if let open = openWager(for: kp), let answered = resolve(open.id, appeared: true, at: now) {
            return answered
        }
        if let today = noticedToday(for: kp, at: now, calendar: calendar) { return today }
        let w = Wager(id: UUID(), khadgamalaPosition: kp, placedAt: now,
                      resolvedAt: now, appeared: true, ledgeredAt: nil)
        archive.wagers.append(w)
        persist()
        return w
    }

    /// The noticing of her today, if he has said so.
    func noticedToday(for kp: Int, at now: Date = .now, calendar: Calendar = .current) -> Wager? {
        archive.wagers.last {
            $0.khadgamalaPosition == kp && $0.appeared == true
                && $0.resolvedAt.map { calendar.isDate($0, inSameDayAs: now) } == true
        }
    }

    func unledgered() -> [Wager] {
        archive.wagers.filter { $0.resolvedAt != nil && $0.ledgeredAt == nil }
    }

    func markLedgered(_ id: UUID, at now: Date = .now) {
        guard let i = archive.wagers.firstIndex(where: { $0.id == id }) else { return }
        archive.wagers[i].ledgeredAt = now
        persist()
    }

    private func persist() {
        try? PracticeVault.write(archive, named: Self.fileName, in: directory)
    }
}
