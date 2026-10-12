import Foundation
import Observation

// MARK: - Wave 6 · what the modes and rites keep

/// His perspective, written beside her sealed witness page (C-1280). Every
/// save is its own entry: a page rewritten keeps the earlier words in the file,
/// so nothing he wrote is ever overwritten. The newest is what the page shows.
struct WitnessWriting: Codable, Equatable, Identifiable {
    var id: UUID
    /// Her identity, 1–102.
    var khadgamalaPosition: Int
    var body: String
    var writtenAt: Date
    var ledgeredAt: Date?
}

/// One sitting with the Khaḍgamālā (Sādhana): how far in it went, and whether
/// he stayed to the offering. A place, never a count.
struct GarlandRecital: Codable, Equatable, Identifiable {
    var id: UUID
    var startedAt: Date
    var endedAt: Date
    /// The enclosure the garland had reached when he left it (1…9).
    var reachedRing: Int
    var whole: Bool
    var ledgeredAt: Date?
}

/// One evening's offering (Pūjā).
struct DayOffering: Codable, Equatable, Identifiable {
    var id: UUID
    var offeredAt: Date
    /// The day's Śakti, by position — her row is found at flush time.
    var todayPosition: Int
    var ledgeredAt: Date?
}

struct RitesArchive: Codable, Equatable {
    var witness: [WitnessWriting] = []
    var garlands: [GarlandRecital] = []
    var offerings: [DayOffering] = []
}

/// Wave 6's practice data, one JSON file in Application Support beside Wave 5's
/// (``PracticeVault``) — atomic writes, an unreadable file copied aside, nothing
/// ever deleted, and no `@Model` touched, so nothing a parallel slice does to
/// the schema can reach it.
@MainActor
@Observable
final class RitesPractice {

    static let shared = RitesPractice()
    static let fileName = "rites"

    let directory: URL
    private(set) var archive = RitesArchive()

    init(directory: URL = PracticeVault.defaultDirectory) {
        self.directory = directory
        archive = PracticeVault.read(RitesArchive.self, named: Self.fileName, in: directory) ?? RitesArchive()
    }

    // MARK: The witness page

    /// The newest words he has written beside her page, if any.
    func witness(for kp: Int) -> WitnessWriting? {
        archive.witness.last { $0.khadgamalaPosition == kp }
    }

    /// Keep what he wrote. A blank page writes nothing, and words identical to
    /// the newest are not kept twice.
    @discardableResult
    func write(witness body: String, for kp: Int, at now: Date = .now) -> WitnessWriting? {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, (1...KhadgamalaMap.total).contains(kp) else { return nil }
        if let last = witness(for: kp), last.body == body { return last }
        let w = WitnessWriting(id: UUID(), khadgamalaPosition: kp, body: body,
                               writtenAt: now, ledgeredAt: nil)
        archive.witness.append(w)
        persist()
        return w
    }

    /// Every page he has written beside, newest of each.
    var allWitness: [WitnessWriting] {
        var seen: Set<Int> = []
        var out: [WitnessWriting] = []
        for w in archive.witness.reversed() where !seen.contains(w.khadgamalaPosition) {
            seen.insert(w.khadgamalaPosition)
            out.append(w)
        }
        return out
    }

    // MARK: The garland

    @discardableResult
    func recite(startedAt: Date, endedAt: Date = .now, reachedRing: Int, whole: Bool) -> GarlandRecital {
        let g = GarlandRecital(id: UUID(), startedAt: startedAt, endedAt: endedAt,
                               reachedRing: max(1, min(9, reachedRing)), whole: whole, ledgeredAt: nil)
        archive.garlands.append(g)
        persist()
        return g
    }

    // MARK: The evening offering

    @discardableResult
    func offerTheDay(todayPosition: Int, at now: Date = .now) -> DayOffering {
        let o = DayOffering(id: UUID(), offeredAt: now, todayPosition: todayPosition, ledgeredAt: nil)
        archive.offerings.append(o)
        persist()
        return o
    }

    // MARK: To the one ledger

    /// Every act not yet handed to the ledger, each stamped as it is taken, so
    /// two overlapping sweeps cannot hand one act over twice
    /// (``PracticeLedger``'s own rule). `record` finds a Śakti's row by
    /// position; an act whose row is not yet known waits for a later sweep.
    func takeUnledgered(record: (Int) -> (id: String, name: String)?,
                        at now: Date = .now) -> [PendingActivity] {
        var out: [PendingActivity] = []
        var changed = false
        for i in archive.witness.indices where archive.witness[i].ledgeredAt == nil {
            let w = archive.witness[i]
            guard let r = record(w.khadgamalaPosition) else { continue }
            archive.witness[i].ledgeredAt = now
            changed = true
            out.append(ActivityLedger.witnessWritten(shaktiRecordId: r.id, name: r.name,
                                                     body: w.body, at: w.writtenAt))
        }
        for i in archive.garlands.indices where archive.garlands[i].ledgeredAt == nil {
            let g = archive.garlands[i]
            guard let point = record(KhadgamalaMap.total) else { continue }
            archive.garlands[i].ledgeredAt = now
            changed = true
            out.append(ActivityLedger.garlandRecited(pointRecordId: point.id, whole: g.whole,
                                                     reachedRing: g.reachedRing, at: g.endedAt))
        }
        for i in archive.offerings.indices where archive.offerings[i].ledgeredAt == nil {
            let o = archive.offerings[i]
            let r = record(o.todayPosition)
            archive.offerings[i].ledgeredAt = now
            changed = true
            out.append(ActivityLedger.dayOffered(todayRecordId: r?.id ?? "", todayName: r?.name ?? "",
                                                 at: o.offeredAt))
        }
        if changed { persist() }
        return out
    }

    private func persist() {
        try? PracticeVault.write(archive, named: Self.fileName, in: directory)
    }
}
