import Foundation

// MARK: - Upgrade U1 · A · the Address
//
// `waves/upgrade/worlds/spine-and-home.md` §2 G #51 (the journey carries
// position, chakra and day) and J #71 (`Place = (world, kp?, chakra?, day, sub)`).
// An address is where he stands: a world, and on it the three threads — her
// position (kp 1–102, which is her identity), the chakra on the Road (1–33)
// and the day — plus the sub-place (a game, a ring, a card) and the camera or
// scroll anchor, so back returns to exactly where he was.

/// The fifteen worlds travel in the journey file and in deep links by their
/// raw values (which never change — `Services/WorldID.swift`).
extension WorldID: Codable {}

/// Where he stands — `spine-and-home.md` §2 G #51 and J #71.
struct Address: Codable, Hashable {

    var world: WorldID
    /// Her khaḍgamālā position, 1–102 — position is identity.
    var kp: Int?
    /// The chakra on the Road, 1–33.
    var chakra: Int?
    /// The day the world is opened on (Today, Time, Memory, the Well).
    var day: Day?
    /// A place inside the world: a game, a ring, a card, a room.
    var sub: String?
    /// The camera, scroll step or zoom he left the world at (#51).
    var anchor: Anchor?

    init(_ world: WorldID,
         kp: Int? = nil,
         chakra: Int? = nil,
         day: Day? = nil,
         sub: String? = nil,
         anchor: Anchor? = nil) {
        self.world = world
        self.kp = kp
        self.chakra = chakra
        self.day = day
        self.sub = sub
        self.anchor = anchor
    }

    /// The centre, the Bindu, with nothing open on it.
    static let home = Address(.home)

    /// Her positions in the garland (`spine-and-home.md` §2 E #47: kp 1–102).
    static let kpRange = 1...102
    /// The Road (`spine-and-home.md` §2 E #47: chakra 1–33).
    static let chakraRange = 1...33

    /// The sub-place a gift lands on at Home: her card, already open (§2 J #72).
    static let cardSub = "card"
    /// The sub-place prefix a Leela drop is presented under in A Strange Game (§2 J #74).
    static let leelaSubPrefix = "leela."

    // MARK: U2 · the sub-places the spine names

    /// U2 · The source at Home — Lalitā source, the arrival from the inside
    /// (`spine-and-home.md` §2 #25, #36: "hold the point → straight to the
    /// source"). Always keyed by kp 102, never `shaktis.last`.
    static let sourceSub = "source"
    /// U2 · Her position at the source: the point's own seat.
    static let sourceKP = 102
    /// U2 · The place the point's hold falls to (§2 C #36).
    static let source = Address(.home, kp: sourceKP, sub: sourceSub)

    /// U2 · A ring inside the Nine Rings world is the sub-place `ring.<n>`
    /// (`mandala-and-rings.md` §1A: "a Veil row crosses to that ring in the
    /// nine rings world").
    static let ringSubPrefix = "ring."

    /// U2 · The Nine Rings world opened on ring `n` (1–9).
    static func ringPlace(_ n: Int) -> Address {
        Address(.rings, sub: ringSubPrefix + String(min(max(n, 1), 9)))
    }

    /// U2 · The ring this address opens on, when its sub-place names one.
    var ringNumber: Int? {
        guard let sub, sub.hasPrefix(Self.ringSubPrefix),
              let n = Int(sub.dropFirst(Self.ringSubPrefix.count)), (1...9).contains(n) else { return nil }
        return n
    }

    /// U2 · The Leela drop this address presents, when its sub-place names one.
    var leelaDropID: String? {
        guard world == .game, let sub, sub.hasPrefix(Self.leelaSubPrefix) else { return nil }
        let id = String(sub.dropFirst(Self.leelaSubPrefix.count))
        return id.isEmpty ? nil : id
    }

    /// Every thread within its range; a sub-place, when named, is not blank.
    var isValid: Bool {
        if let kp, !Self.kpRange.contains(kp) { return false }
        if let chakra, !Self.chakraRange.contains(chakra) { return false }
        if let sub, sub.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return false }
        return true
    }

    /// The same place without the camera: two addresses are the same place when
    /// they differ only in where the camera was left.
    var place: Address {
        var a = self
        a.anchor = nil
        return a
    }

    // MARK: The day

    /// A calendar day (Gregorian), written `yyyy-MM-dd` in the journey and in links.
    struct Day: Codable, Hashable, Comparable {
        let year: Int
        let month: Int
        let day: Int

        private static var gregorian: Calendar {
            var c = Calendar(identifier: .gregorian)
            c.timeZone = TimeZone(secondsFromGMT: 0) ?? c.timeZone
            return c
        }

        /// Nil for a day that does not exist (31 April, 30 February …).
        init?(year: Int, month: Int, day: Int) {
            var parts = DateComponents()
            parts.year = year
            parts.month = month
            parts.day = day
            let cal = Self.gregorian
            guard let date = cal.date(from: parts) else { return nil }
            let back = cal.dateComponents([.year, .month, .day], from: date)
            guard back.year == year, back.month == month, back.day == day else { return nil }
            self.year = year
            self.month = month
            self.day = day
        }

        /// The day a moment falls on, in the given calendar (his own, by default).
        init(_ date: Date, calendar: Calendar = .current) {
            let c = calendar.dateComponents([.year, .month, .day], from: date)
            self.year = c.year ?? 1970
            self.month = c.month ?? 1
            self.day = c.day ?? 1
        }

        /// `2026-10-13`.
        init?(iso: String) {
            let parts = iso.split(separator: "-", omittingEmptySubsequences: false)
            guard parts.count == 3,
                  let y = Int(parts[0]), let m = Int(parts[1]), let d = Int(parts[2]) else { return nil }
            self.init(year: y, month: m, day: d)
        }

        var iso: String { String(format: "%04d-%02d-%02d", year, month, day) }

        /// The neighbouring day on the day thread (±1, §2 E #48).
        func adding(days n: Int) -> Day {
            let cal = Self.gregorian
            var parts = DateComponents()
            parts.year = year
            parts.month = month
            parts.day = day
            guard let date = cal.date(from: parts),
                  let moved = cal.date(byAdding: .day, value: n, to: date) else { return self }
            return Day(moved, calendar: cal)
        }

        static func < (a: Day, b: Day) -> Bool {
            (a.year, a.month, a.day) < (b.year, b.month, b.day)
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let raw = try container.decode(String.self)
            guard let d = Day(iso: raw) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "not a day: \(raw)")
            }
            self = d
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(iso)
        }
    }

    // MARK: The camera

    /// Where the camera, the scroll or the zoom was left (§2 G #51: camera
    /// (scale, offset) | scroll step | zoom z, breath phase). Device-local: it
    /// travels in the journey, never in a link.
    struct Anchor: Codable, Hashable {
        var scale: Double?
        var offsetX: Double?
        var offsetY: Double?
        var scrollStep: Int?
        var zoom: Double?
        var breathPhase: Double?
    }
}
