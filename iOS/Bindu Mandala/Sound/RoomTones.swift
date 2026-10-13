import Foundation

// MARK: - Upgrade U1 · B · the 33 rooms, one fixed tone each
//
// `waves/upgrade/worlds/sound.md` §1.7 (S48, S49, S55): each room keeps one
// fixed tone; practice, gate and wake-up all sit on it. The dance is the only
// exception — its song brings its own carrier for the length of the dance
// (`Tuning.songCarriers`). The awakening tones (rooms 2–8 and 31) are the canon
// panels P1–P8 of `Design/Chakra/shell/walk-canon.js` (baked from The Map /
// The Builds); the body rooms take their Map Mirror Frequency; the mind rooms
// 110 Hz (BC-09, "the rooms about the reader"); room 32 is sealed (ruling 2).

/// One room's fixed tone — a row of `sound.md` §1.7.
struct RoomTone: Equatable {

    /// What the room sounds.
    enum Kind: Equatable {
        /// The Om itself (room 1; room 33 at its highest).
        case om
        /// A fixed tone with a timbre (the awakening tones and their mirrors).
        case tone
        /// Armin's drone that never resolves.
        case drone
        /// 110 Hz with its fifth breathing every 10 s.
        case mindRoom
        /// No tone: the silence is the room's sound.
        case silence
        /// Sealed: no tone, the pulse stops (room 32, ruling 2).
        case sealed
    }

    let room: Int
    let name: String
    let kind: Kind
    /// The tone in Hz, when the room has one.
    let hz: Double?
    /// The awakening timbre (S49), when named.
    let timbre: String?
    /// Where the choice comes from (§1.7's last column).
    let source: String

    /// The wake-up binaural carrier (S50): the room tone ÷ 2.
    var wakeUpCarrier: Double? {
        guard kind == .tone, let hz else { return nil }
        return Tuning.wakeUpCarrier(roomTone: hz)
    }
}

/// The table of `sound.md` §1.7 as data, and the levels the rooms sound at.
enum RoomTones {

    /// The practice drone on the room's tone (S48).
    static let practiceGain: Double = 0.012
    /// The mind rooms' fifth breathes on this period (s).
    static let mindRoomBreath: Double = 10
    /// Armin (S55): 55 s, rising .008 → .014, never resolving.
    static let arminSeconds: Double = 55
    static let arminGains: (from: Double, to: Double) = (0.008, 0.014)
    /// Room 14's heartbeat (S48, B.4.1): lub 68, dub 52 Hz.
    static let pulseHeartbeat: (lub: Double, dub: Double) = (68, 52)
    /// Room 33: no seed — the Om at its highest.
    static let lalitaOm: Double = 0.20

    static let all: [RoomTone] = {
        var rows: [RoomTone] = [
        RoomTone(room: 1, name: "Bindu", kind: .om, hz: 136.1, timbre: nil,
                 source: "06:104 \"Om 136.1 Hz optional at Act 0\""),
        RoomTone(room: 2, name: "Muladhara", kind: .tone, hz: 174, timbre: "earth drum", source: "canon awakening P1"),
        RoomTone(room: 3, name: "Svadhisthana", kind: .tone, hz: 210, timbre: "wooden bell", source: "P2"),
        RoomTone(room: 4, name: "Manipura", kind: .tone, hz: 320, timbre: "struck gong", source: "P3"),
        RoomTone(room: 5, name: "Anahata", kind: .tone, hz: 341, timbre: "crystal bowl", source: "P4"),
        RoomTone(room: 6, name: "Vishuddha", kind: .tone, hz: 384, timbre: "singing bowl", source: "P5"),
        RoomTone(room: 7, name: "Ajna", kind: .tone, hz: 426, timbre: "shimmer, 1.5 Hz twin", source: "P6"),
        RoomTone(room: 8, name: "Sahasrara", kind: .tone, hz: 480, timbre: "distant bell", source: "P7"),
        RoomTone(room: 9, name: "Shadow", kind: .silence, hz: nil, timbre: nil,
                 source: "05:1024-1030; 06:112 — the word he offers; 2.5 Hz δ on 136.1; the pulse begins"),
        RoomTone(room: 10, name: "Soles", kind: .tone, hz: 174, timbre: "LAM", source: "Map Mirror Frequency"),
        RoomTone(room: 11, name: "Forge", kind: .tone, hz: 320, timbre: "RAM", source: "Map Mirror Frequency"),
        RoomTone(room: 12, name: "Prana", kind: .tone, hz: 210, timbre: "VAM", source: "Map Mirror Frequency"),
        RoomTone(room: 13, name: "Hands", kind: .tone, hz: 341, timbre: "YAM", source: "Map Mirror Frequency"),
        RoomTone(room: 14, name: "Pulse", kind: .tone, hz: 341, timbre: "YAM + heartbeat 68 / 52 Hz",
                 source: "Map Mirror Frequency; B.4.1"),
        RoomTone(room: 15, name: "Sonar", kind: .tone, hz: 384, timbre: "HAM, sending", source: "Map Mirror Frequency"),
        RoomTone(room: 16, name: "Echo", kind: .tone, hz: 384, timbre: "HAM, receiving — very soft, then silence",
                 source: "Map Mirror Frequency"),
        RoomTone(room: 17, name: "Vision", kind: .tone, hz: 426, timbre: "OM", source: "Map Mirror Frequency; ruling 14"),
        RoomTone(room: 18, name: "Axis", kind: .tone, hz: 426, timbre: "OM", source: "Map Mirror Frequency"),
        RoomTone(room: 19, name: "Crow", kind: .silence, hz: nil, timbre: nil,
                 source: "Map Mirror Frequency — Sahasrara's mirror"),
        RoomTone(room: 20, name: "Armin", kind: .drone, hz: 73.42, timbre: "D2 drone, never resolves", source: "06:123"),
        ]
        for room in 21...29 {
            rows.append(RoomTone(room: room, name: "Mind room", kind: .mindRoom, hz: 110,
                                 timbre: "110 Hz + its fifth breathing every 10 s",
                                 source: "BC-09 \"110 Hz (the rooms about the reader)\""))
        }
        rows += [
        RoomTone(room: 30, name: "Maya", kind: .silence, hz: nil, timbre: nil,
                 source: "P9 — the Om was always playing"),
        RoomTone(room: 31, name: "Aatma", kind: .tone, hz: 528, timbre: "Trinity, detune −2 / 0 / +2", source: "P8"),
        RoomTone(room: 32, name: "Ego Reveal", kind: .sealed, hz: nil, timbre: nil,
                 source: "ruling 2 — sealed; the pulse stops"),
        RoomTone(room: 33, name: "Lalitā", kind: .om, hz: 136.1, timbre: nil,
                 source: "05:2679-2685; P9 staging — the Om at its highest (.20, \"Go Play\")"),
        ]
        return rows
    }()

    /// Room 1…33, or nil.
    static func tone(room: Int) -> RoomTone? { all.first { $0.room == room } }

    /// The canon awakening panels and their rooms: P1–P7 are rooms 2–8, P8 is
    /// Aatma (room 31), P9 (Silence) is Maya (room 30).
    static let awakeningPanelRooms: [Int: Int] = [1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 8, 8: 31, 9: 30]
}
