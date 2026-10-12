import Foundation

// MARK: - Wave 6 · the body chakras as movement and breath (from his Codex)
//
// C-1311: *"the seven chakras … require almost like a stillness so the energy
// can sort of move … these chakras, your eyes and your heart, they require like
// movement, they require activation."* Each practice below is one he recorded,
// held in the room of the chakra it belongs to. Each is light and haptics, held
// for as long as he holds it, and never a score: nothing is counted on the
// glass, nothing fails, and a practice ends by settling.
//
// **The words are his.** Every line is lifted from the Codex entry named beside
// it (lightly cleaned of the voice memo's ums), in his own person — the record
// speaking back to him. Nothing here speaks for a Śakti. The fear practice never
// names a fear: his memo named his, and those words stay in the Codex.

enum ChakraMovement: String, CaseIterable, Identifiable {
    /// Pulse, Hands — shake the hand fast enough and the heart sends a pulse.
    case euphoriaPulse
    /// Sonar, Viśuddha — the roar of the mouth, then the throat's silence.
    case roarAndSilence
    /// Vision — a memory named, held while the body vibrates, brought into now.
    case lastMemories
    /// Echo, Viśuddha, Sonar — HAM receive · HET hold · HUM transmit.
    case hamHetHum
    /// Mūlādhāra — fear passing in waves, then a breath of prāṇa.
    case fearInWaves
    /// Soles — an emotion felt through the whole body until it dissipates.
    case feelingThrough
    /// Crow — restlessness allowed; the light moves with him.
    case restlessness
    /// Anāhata — awareness goes out and comes home to the heart.
    case heartHome

    var id: String { rawValue }

    /// The practice's own name: the heading in the room, and the `Detail` of
    /// its ledger row.
    var title: String {
        switch self {
        case .euphoriaPulse:  return "the euphoria pulse"
        case .roarAndSilence: return "roar, and silence"
        case .lastMemories:   return "last memories"
        case .hamHetHum:      return "Ham · Het · Hum"
        case .fearInWaves:    return "fear, in waves"
        case .feelingThrough: return "feeling it through"
        case .restlessness:   return "restlessness, allowed"
        case .heartHome:      return "hṛdayam, home"
        }
    }

    /// Where the practice comes from — provenance, spoken to a voice only.
    var codex: String {
        switch self {
        case .euphoriaPulse, .roarAndSilence, .lastMemories: return "C-1311"
        case .hamHetHum:      return "C-1342"
        case .fearInWaves:    return "C-1166 · C-1168 · C-1180"
        case .feelingThrough: return "C-1145 · C-1177"
        case .restlessness:   return "C-1170"
        case .heartHome:      return "C-1174"
        }
    }

    /// His lines, in the order the practice reaches them.
    var lines: [String] {
        switch self {
        case .euphoriaPulse:
            // C-1311
            return ["The moment you close your eyes.",
                    "Shake your hand — shake it fast enough.",
                    "In that shaking your heart generates a euphoria pulse,",
                    "sending out your love energy into the entire space."]
        case .roarAndSilence:
            // C-1311
            return ["The roar of the mouth.",
                    "The silence of the vishuddha."]
        case .lastMemories:
            // C-1311 — his memo used a photo; this keeps only the memory.
            return ["Close your eyes.",
                    "A last memory, or any kind of memory you want to anchor yourself to.",
                    "Vibrate enough to occupy the same state you were in, in that moment.",
                    "Bring that moment to the here and now by simply opening your eyes."]
        case .hamHetHum:
            // C-1342
            return ["Echo · Vishuddha · Sonar.",
                    "Knowledge · Will · Action."]
        case .fearInWaves:
            // C-1166 (C-1168, C-1180 the same waves)
            return ["I let it wash all over me.",
                    "I held my breath.",
                    "A deep breath of life, of prana.",
                    "This is all an illusion."]
        case .feelingThrough:
            // C-1145, C-1177
            return ["Not the thought, not the word, not the action. It's the feeling.",
                    "Feel it in your hands, in your fingers. Feel it in your legs.",
                    "Feel it all over your body. Feel it in your feet, in your toes.",
                    "Allowing that feeling to just permeate through every cell of your body.",
                    "Realign."]
        case .restlessness:
            // C-1170
            return ["Energy is just surging through the body.",
                    "This openingness, this awakeness."]
        case .heartHome:
            // C-1174 — the word his entry turns on; the rest is the light.
            return ["Hṛdayam."]
        }
    }

    /// Ham · Het · Hum, as C-1342 sets them down: the syllable, the breath, and
    /// the line where the session gave one.
    struct Breath: Equatable {
        let syllable: String
        let breath: String
        let line: String?
        /// Seconds of this third of the breath — the Rite's own 4-4-4 floor.
        let seconds: Double
    }

    static let hamHetHumBreaths: [Breath] = [
        Breath(syllable: "HAM", breath: "inhale · receive", line: "I am being made aware", seconds: 4),
        Breath(syllable: "HET", breath: "hold", line: nil, seconds: 4),
        Breath(syllable: "HUM", breath: "exhale · transmit", line: "I realize it is possible", seconds: 4),
    ]

    // MARK: Which room holds which

    /// The practices each room holds, keyed by the chakra's Road position (the
    /// Map's Book Position — a chakra's identity, as kp is a Śakti's).
    static let byRoad: [Int: [ChakraMovement]] = [
        2:  [.fearInWaves],                 // Mūlādhāra — the root's cleansing (C-1166)
        5:  [.heartHome],                   // Anāhata — the hṛdayam (C-1174)
        6:  [.hamHetHum, .roarAndSilence],  // Viśuddha — HET, and the silence (C-1342, C-1311)
        10: [.feelingThrough],              // Soles — to the feet, to the toes (C-1145)
        13: [.euphoriaPulse],               // Hands — the shaking hand (C-1311)
        14: [.euphoriaPulse],               // Pulse — the physical heart (C-1311)
        15: [.hamHetHum, .roarAndSilence],  // Sonar — HUM, and the roar (C-1342, C-1311)
        16: [.hamHetHum],                   // Echo — HAM (C-1342)
        17: [.lastMemories],                // Vision — the memory seen (C-1311)
        19: [.restlessness],                // Crow — the kundalini's road (C-1170, C-1328)
    ]

    static func practices(for c: Chakra33) -> [ChakraMovement] {
        byRoad[c.road] ?? []
    }

    /// Which third of Ham · Het · Hum this room is: Echo receives, Viśuddha
    /// holds, Sonar transmits (C-1342's sequence). Nil elsewhere.
    static func breathIndex(forRoad road: Int) -> Int? {
        switch road {
        case 16: return 0
        case 6:  return 1
        case 15: return 2
        default: return nil
        }
    }

    // MARK: The held clock

    /// How much shaking is enough: the integral of the phone's user
    /// acceleration (in g, above a resting floor) over time. Never shown.
    static let pulseCharge: Double = 2.4
    /// Below this the phone is held, not shaken.
    static let shakeFloor: Double = 0.35

    /// One frame of shaking, integrated: what is above the floor accrues; a
    /// still hand lets it ebb, slowly, so a pause is not a loss.
    static func charge(_ current: Double, shake: Double, dt: Double) -> Double {
        let gain = max(0, shake - shakeFloor) * dt
        let ebb = shake < shakeFloor ? 0.25 * dt : 0
        return max(0, current + gain - ebb)
    }

    /// How long a roar must be held before its release is the silence.
    static let roarHold: Double = 1.2
    /// How many waves may wash before the illusion line (C-1166: "a couple of
    /// times"; C-1180: three). Structure, never shown.
    static let fearWaves = 3
}
