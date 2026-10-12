import Foundation
import CoreGraphics
import Observation

/// One point of a stroke, in the Portrait's unit coordinates (see `LivingMandala`).
struct StrokePoint: Codable, Equatable {
    var x: Double
    var y: Double

    init(x: Double, y: Double) { self.x = x; self.y = y }
    init(_ p: CGPoint) { x = Double(p.x); y = Double(p.y) }
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
}

/// One stroke he drew into the Portrait. `ring` is the ring it was begun in,
/// and so the ring that mirrors it.
struct PortraitStroke: Codable, Equatable, Identifiable {
    var id: UUID
    var session: UUID
    var ring: Int
    var points: [StrokePoint]
    var drawnAt: Date
}

/// One sitting at the Portrait — from "draw" to "set it down". It is the unit
/// the ledger hears about: **one** `Portrait Drawn` row per session, however
/// many strokes it holds.
struct StrokeSession: Codable, Equatable, Identifiable {
    var id: UUID
    var startedAt: Date
    var endedAt: Date?
    /// The ring most drawn in (the first, on a tie) — the Avaraṇa the ledger
    /// row links to.
    var ring: Int
    /// When this session was handed to the ledger. `nil` until then, so a
    /// session drawn offline, or before her base was reachable, is retried on
    /// every later sweep and never dropped.
    var ledgeredAt: Date?
}

struct PortraitArchive: Codable, Equatable {
    var strokes: [PortraitStroke] = []
    var sessions: [StrokeSession] = []
}

/// His strokes — practice data. Every stroke is written to disk the moment his
/// finger lifts, so nothing drawn is ever only in memory.
@MainActor
@Observable
final class PortraitStrokeStore {

    static let shared = PortraitStrokeStore()
    static let fileName = "portrait-strokes"

    let directory: URL
    private(set) var archive: PortraitArchive = PortraitArchive()
    private(set) var openSession: UUID? = nil

    init(directory: URL = PracticeVault.defaultDirectory) {
        self.directory = directory
        var loaded = PracticeVault.read(PortraitArchive.self, named: Self.fileName, in: directory)
            ?? PortraitArchive()
        // A session the app was killed inside is closed at its last stroke —
        // its strokes are already on disk and stay exactly where they are.
        let strokes = loaded.strokes
        for i in loaded.sessions.indices where loaded.sessions[i].endedAt == nil {
            let id = loaded.sessions[i].id
            let last = strokes.filter { $0.session == id }.map(\.drawnAt).max()
            loaded.sessions[i].endedAt = last ?? loaded.sessions[i].startedAt
        }
        let drawnIn = Set(strokes.map(\.session))
        loaded.sessions.removeAll { !drawnIn.contains($0.id) }
        archive = loaded
    }

    var strokes: [PortraitStroke] { archive.strokes }

    /// Begin a sitting. Returns the open one if he is already drawing.
    @discardableResult
    func begin(at date: Date = .now) -> UUID {
        if let open = openSession { return open }
        let id = UUID()
        openSession = id
        archive.sessions.append(StrokeSession(id: id, startedAt: date, endedAt: nil, ring: 9, ledgeredAt: nil))
        return id
    }

    /// Lay a stroke down. A stroke of fewer than two points is a touch, not a
    /// line, and is not kept.
    @discardableResult
    func add(points: [CGPoint], at date: Date = .now) -> PortraitStroke? {
        let thin = LivingMandala.thinned(points)
        guard thin.count >= 2, let first = thin.first else { return nil }
        let session = begin(at: date)
        let stroke = PortraitStroke(id: UUID(), session: session,
                                    ring: LivingMandala.ring(of: first),
                                    points: thin.map(StrokePoint.init),
                                    drawnAt: date)
        archive.strokes.append(stroke)
        if let i = archive.sessions.firstIndex(where: { $0.id == session }) {
            archive.sessions[i].ring = Self.dominantRing(of: archive.strokes.filter { $0.session == session })
        }
        persist()
        return stroke
    }

    /// Set the sitting down. A sitting with no strokes leaves no trace.
    @discardableResult
    func end(at date: Date = .now) -> StrokeSession? {
        guard let id = openSession else { return nil }
        openSession = nil
        guard let i = archive.sessions.firstIndex(where: { $0.id == id }) else { return nil }
        guard archive.strokes.contains(where: { $0.session == id }) else {
            archive.sessions.remove(at: i)
            persist()
            return nil
        }
        archive.sessions[i].endedAt = date
        persist()
        return archive.sessions[i]
    }

    /// Closed sessions the ledger has not yet been handed.
    func unledgered() -> [StrokeSession] {
        archive.sessions.filter { $0.endedAt != nil && $0.ledgeredAt == nil }
    }

    func markLedgered(_ id: UUID, at date: Date = .now) {
        guard let i = archive.sessions.firstIndex(where: { $0.id == id }) else { return }
        archive.sessions[i].ledgeredAt = date
        persist()
    }

    /// The instants he drew at — for the year's accretion.
    var drawingInstants: [Date] { archive.strokes.map(\.drawnAt) }

    static func dominantRing(of strokes: [PortraitStroke]) -> Int {
        var tally: [Int: Int] = [:]
        for s in strokes { tally[s.ring, default: 0] += 1 }
        var best = strokes.first?.ring ?? 9
        var bestN = 0
        for s in strokes {
            let n = tally[s.ring] ?? 0
            if n > bestN { best = s.ring; bestN = n }
        }
        return best
    }

    private func persist() {
        do {
            try PracticeVault.write(archive, named: Self.fileName, in: directory)
        } catch {
            // Held in memory and written again on the next stroke; the last good
            // file on disk is untouched by a failed atomic write.
        }
    }
}
