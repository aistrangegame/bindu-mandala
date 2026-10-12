import Foundation

/// Wave 6 · Slice E — what play leaves behind on the phone.
///
/// Three things live here, beside the river and the wagers in
/// `PracticeVault` (files, never a new `@Model`, for the reasons that file
/// gives):
///   • **traces** — one per game played, so the World in a Box can stand one
///     object for every practice (never a total) and the Great Wheel can light
///     the days he played (presence only, never a density);
///   • **seeds** — The Seed grows by real time from the moment it was
///     planted, so the planting must outlive the app;
///   • **the world's last visit** — gifts arrive while he is away.
///
/// The ledger stays the one record of events (R17): every trace here is also
/// a `Played` row in App Activity, written by the play host. This file is the
/// phone's own memory of the same acts, kept so the world can be drawn
/// offline. Nothing here is ever deleted.
///
/// Not isolated to an actor on purpose, as `PlaySession` is not: every caller
/// is on the main thread (touches, timelines, the host's hand-off), and the
/// game models that read it run inside a `Canvas`.
struct PlayTrace: Codable, Equatable {
    var game: String
    var at: Date
}

struct SeedPlanting: Codable, Equatable, Identifiable {
    var id: UUID
    var khadgamalaPosition: Int
    var plantedAt: Date
}

struct PlayGardenArchive: Codable, Equatable {
    var traces: [PlayTrace] = []
    var seeds: [SeedPlanting] = []
    var worldVisitedAt: Date? = nil
}

final class PlayGardenStore {

    static let shared = PlayGardenStore()
    static let fileName = "play-garden"

    let directory: URL
    private(set) var archive: PlayGardenArchive = PlayGardenArchive()

    init(directory: URL = PracticeVault.defaultDirectory) {
        self.directory = directory
        archive = PracticeVault.read(PlayGardenArchive.self, named: Self.fileName, in: directory)
            ?? PlayGardenArchive()
    }

    var traces: [PlayTrace] { archive.traces }

    /// One game played. Called once per game, beside its ledger row.
    func record(game: String, at now: Date = .now) {
        archive.traces.append(PlayTrace(game: game, at: now))
        persist()
    }

    /// The seed growing now: the newest planting.
    var growingSeed: SeedPlanting? { archive.seeds.last }

    @discardableResult
    func plant(at kp: Int, at now: Date = .now) -> SeedPlanting {
        let s = SeedPlanting(id: UUID(), khadgamalaPosition: kp, plantedAt: now)
        archive.seeds.append(s)
        persist()
        return s
    }

    var worldVisitedAt: Date? { archive.worldVisitedAt }

    func visitWorld(at now: Date = .now) {
        archive.worldVisitedAt = now
        persist()
    }

    /// The local days (start of day) on which he played.
    func playedDays(calendar: Calendar = .current) -> Set<Date> {
        Set(archive.traces.map { calendar.startOfDay(for: $0.at) })
    }

    private func persist() {
        try? PracticeVault.write(archive, named: Self.fileName, in: directory)
    }
}
