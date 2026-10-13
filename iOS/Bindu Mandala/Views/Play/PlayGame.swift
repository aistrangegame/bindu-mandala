import SwiftUI

// MARK: - Wave 4 · Play — the games and their addresses
//
// Lalitā at the Bindu is the play that knows itself. Every real game in the
// corpus is a physical verb with a skill in it, and each one lives at an
// address in the yantra: a Śakti's seat, a whole ring, or a threshold between
// rings. The same games are gathered again at the centre as Lalitā's field
// (`PlayFieldView`), so none of them is ever hidden.
//
// **Position is identity.** A seat address is a khaḍgamālā position and
// nothing else; the Śakti there is found by that position at run time and
// whatever her row says is who she is. The positions below were read off the
// Mandala table (`fldI0aV1sfOeNybHI`) and The Map (`tblwpmyKOeMxEEHd7`) on
// 2026-10-12 — the names are in `PlayAddressTests`, never in this file, so no
// screen can be keyed by one.

/// Where a game lives in the yantra.
enum PlayAddress: Equatable, Hashable {
    /// One Śakti's seat — her khaḍgamālā position, 1…102.
    case seat(Int)
    /// A whole āvaraṇa (the energy chakras live at the level of a ring).
    case ring(Int)
    /// A threshold crossing between two rings — Shadow at 3→4, Armin at 6→7.
    case threshold(from: Int, to: Int)
    /// All 102 positions at once: the rosary.
    case garland

    /// The ring this address sits in, for light and for the ledger link.
    var ring: Int {
        switch self {
        case .seat(let kp):           return KhadgamalaMap.ringNumber(forKhadgamala: kp)
        case .ring(let r):            return r
        case .threshold(_, let to):   return to
        case .garland:                return 9
        }
    }

    /// Her position, when the address is one seat.
    var position: Int? {
        if case .seat(let kp) = self { return kp }
        return nil
    }
}

/// How a game ends. Never a screen that congratulates him: either her
/// Recognition, or stillness — the light gathered to one point, breathing.
enum PlayHandoff: Equatable {
    case recognition
    case stillness
}

/// The real games, each with its verb and its address (WAVES.md, "The game
/// reading").
enum PlayGame: String, CaseIterable, Identifiable, Hashable {
    case corridor
    case pulse
    case spineWalk
    case echo
    case fingerGarden
    case rain
    case drum
    case rootSystem
    case waterLevel
    case fire
    case shakeToClear
    case door
    case yantraTrace
    case rosary
    case bijaTones
    case coherence
    // Wave 6 · Slice E — every game the corpus held that Wave 4 had not yet
    // brought home, the Sacred Experiences, Leela's board, Turn and Join, the
    // japa and the bhakti, and the year's own small practices.
    case seed
    case mandalaCompletion
    case twelve
    case bodyMap
    case shadowTranslator
    case mirrorMaze
    case letter
    case worldInABox
    case colourRivers
    case shadowScrolls
    case stillAjna
    case flash
    case tatTvamAsi
    case leela
    case turn
    case join
    case ramJapa
    case bhakti
    case sandhya
    case greatWheel

    var id: String { rawValue }

    /// The game's own name — written into the ledger's `Detail`, spoken to a
    /// voice, never a heading on the glass.
    var title: String {
        switch self {
        case .corridor:     return "The Corridor"
        case .pulse:        return "Pulse"
        case .spineWalk:    return "Spine Walk"
        case .echo:         return "Echo"
        case .fingerGarden: return "Finger Garden"
        case .rain:         return "Rain"
        case .drum:         return "The Drum"
        case .rootSystem:   return "Root System"
        case .waterLevel:   return "Water Level"
        case .fire:         return "The Fire"
        case .shakeToClear: return "Shake to Clear"
        case .door:         return "The Door"
        case .yantraTrace:  return "Śrī Yantra"
        case .rosary:       return "The Garland"
        case .bijaTones:    return "Bīja Tones"
        case .coherence:    return "Coherence"
        case .seed:              return "The Seed"
        case .mandalaCompletion: return "Mandala Completion"
        case .twelve:            return "The Twelve"
        case .bodyMap:           return "Body Map"
        case .shadowTranslator:  return "Shadow Translator"
        case .mirrorMaze:        return "Mirror Maze"
        case .letter:            return "The Letter"
        case .worldInABox:       return "The World in a Box"
        case .colourRivers:      return "Colour Rivers"
        case .shadowScrolls:     return "The Scrolls"
        case .stillAjna:         return "Still · Ājñā"
        case .flash:             return "Flash · Intuition"
        case .tatTvamAsi:        return "Tat Tvam Asi"
        case .leela:             return "Leela on the Thirty-Three"
        case .turn:              return "Turn"
        case .join:              return "Join"
        case .ramJapa:           return "Rām Japa"
        case .bhakti:            return "Bhakti at Maṇipūra"
        case .sandhya:           return "The Sandhyā"
        case .greatWheel:        return "The Great Wheel"
        }
    }

    /// The physical verb — the one word Lalitā's field writes under its light.
    var verb: String {
        switch self {
        case .corridor:     return "walk"
        case .pulse:        return "catch"
        case .spineWalk:    return "rise"
        case .echo:         return "call"
        case .fingerGarden: return "grow"
        case .rain:         return "breathe"
        case .drum:         return "press"
        case .rootSystem:   return "root"
        case .waterLevel:   return "balance"
        case .fire:         return "tend"
        case .shakeToClear: return "clear"
        case .door:         return "become small"
        case .yantraTrace:  return "draw"
        case .rosary:       return "turn"
        case .bijaTones:    return "tune"
        case .coherence:    return "meet"
        case .seed:              return "plant"
        case .mandalaCompletion: return "make whole"
        case .twelve:            return "order"
        case .bodyMap:           return "listen"
        case .shadowTranslator:  return "turn over"
        case .mirrorMaze:        return "steer"
        case .letter:            return "seal"
        case .worldInABox:       return "gather"
        case .colourRivers:      return "pour"
        case .shadowScrolls:     return "unroll"
        case .stillAjna:         return "wait"
        case .flash:             return "trust"
        case .tatTvamAsi:        return "arrive"
        case .leela:             return "throw"
        case .turn:              return "align"
        case .join:              return "bring together"
        case .ramJapa:           return "breathe the name"
        case .bhakti:            return "offer"
        case .sandhya:           return "greet the sun"
        case .greatWheel:        return "spin the year"
        }
    }

    /// The one line of words a game is given, and only for its first breaths:
    /// the verb, said once, then the light carries it.
    var hint: String {
        switch self {
        case .corridor:     return "step at the pace your body allows"
        case .pulse:        return "find your heartbeat and tap with it"
        case .spineWalk:    return "carry the light up the spine — rest where it glows"
        case .echo:         return "tap a call, then wait — she answers"
        case .fingerGarden: return "touch the earth and stay"
        case .rain:         return "press to call the rain · breathe out across the glass"
        case .drum:         return "strike with the earth's own beat"
        case .rootSystem:   return "rest your fingers and do not move"
        case .waterLevel:   return "hold the phone level and let the water settle"
        case .fire:         return "lay a stick on when the flame asks"
        case .shakeToClear: return "shake the phone — let it all scatter"
        case .door:         return "hold lightly, and become small"
        case .yantraTrace:  return "draw from the glowing point along the line"
        case .rosary:       return "pull the thread down · rest on a bead to feel her"
        case .bijaTones:    return "choose a ring, then tap with its tone"
        case .coherence:    return "left thumb holds the breath in · right taps the heart"
        case .seed:              return "press the seed into the earth and stay"
        case .mandalaCompletion: return "draw the petal that is waiting, from its root to its tip"
        case .twelve:            return "touch to hear · drag one light onto another to change places"
        case .bodyMap:           return "rest a finger on each centre · press as it feels"
        case .shadowTranslator:  return "touch what you carry · circle it slowly to turn it over"
        case .mirrorMaze:        return "one word · tilt to guide it through the lenses"
        case .letter:            return "write · draw the page down to fold it · press the wax"
        case .worldInABox:       return "tilt the box · touch what has arrived"
        case .colourRivers:      return "drag to pour · let the colours meet"
        case .shadowScrolls:     return "draw each scroll down, slowly"
        case .stillAjna:         return "rest your thumbs and close your eyes · the screen will wait"
        case .flash:             return "one breath · then touch the light the moment it appears"
        case .tatTvamAsi:        return "hold for each word · then bring two fingers together"
        case .leela:             return "hold the die, then let it go"
        case .turn:              return "turn the rings until their marks meet at the top"
        case .join:              return "bring the two lights together gently"
        case .ramJapa:           return "hold as the breath comes in · let go as it leaves"
        case .bhakti:            return "circle the lamp around her light, slowly, sunwise"
        case .sandhya:           return "greet the junction of the day"
        case .greatWheel:        return "spin the year and let it come to rest at today"
        }
    }

    /// The games played with the phone's own body.
    var usesMotion: Bool {
        switch self {
        case .waterLevel, .shakeToClear, .rain: return true
        case .mirrorMaze, .stillAjna, .sandhya, .worldInABox, .leela: return true
        default: return false
        }
    }

    /// The address — the walk's table, with every position checked against
    /// the rows (`PlayAddressTests` pins each to her name).
    var address: PlayAddress {
        switch self {
        case .corridor:     return .threshold(from: 3, to: 4)   // Shadow
        case .pulse:        return .seat(70)                     // Pulse · Sarva-Maṅgalakāriṇī
        case .spineWalk:    return .seat(84)                     // Axis · Sarvānandamayī
        case .echo:         return .seat(80)                     // Echo · Sarvajñānamayī
        case .fingerGarden: return .seat(69)                     // Hands · Sarva-Priyaṅkarī
        case .rain:         return .seat(71)                     // Prāṇa · Sarva-Kāmapradā
        case .drum:         return .seat(53)                     // Soles · Sarva-Saṅkṣobhiṇī (Devī)
        case .rootSystem:   return .seat(4)                      // Mūlādhāra · Garimā
        case .waterLevel:   return .seat(15)                     // Svādhiṣṭhāna · Vārāhī
        case .fire:         return .seat(65)                     // Forge · Sarva-Mantramayī
        case .shakeToClear: return .seat(82)                     // Crow · Sarvādhārasvarūpā
        case .door:         return .seat(94)                     // Innocence · Kaulinī
        case .yantraTrace:  return .seat(102)                    // the Bindu · Mahātripurasundarī
        case .rosary:       return .garland                      // all 102
        case .bijaTones:    return .ring(1)                      // the bījas — any ring; opens at the first
        case .coherence:    return .seat(70)                     // Pulse; the Rite's breath
        // Wave 6 · Slice E — each read against the rows on 2026-10-12
        // (`PlayAddressTests` pins every seat to her name).
        case .seed:              return .seat(26)                // Sarva-Bīja (Mudrā) — the seed that holds everything
        case .mandalaCompletion: return .ring(7)                 // Integration — the whole ring, nothing was separate
        case .twelve:            return .ring(7)                 // the Vāk ring, twelve voices
        case .bodyMap:           return .seat(77)                // Vision · Sarvajñā
        case .shadowTranslator:  return .seat(101)               // Ego Reveal · Bhagamālinī — the inversion
        case .mirrorMaze:        return .seat(30)                // Buddhyākarṣiṇī — the mind that reflects
        case .letter:            return .seat(88)                // Intention · Kāmeśī
        case .worldInABox:       return .ring(9)                 // Lalitā's field as a living world
        case .colourRivers:      return .seat(20)                // Sarva-Vidrāviṇī (Mudrā) — melting, fluid
        case .shadowScrolls:     return .threshold(from: 3, to: 4)   // Shadow
        case .stillAjna:         return .seat(51)                // Ājñā · Anaṅga-Aṅkuśā, between the eyes
        case .flash:             return .seat(91)                // Intuition · Aruṇā
        case .tatTvamAsi:        return .threshold(from: 6, to: 7)   // Armin
        case .leela:             return .seat(102)               // Lalitā — the game knowing itself
        case .turn:              return .ring(8)                 // the three made one
        case .join:              return .seat(92)                // Invention · Jayinī — the third thing
        // Wave 6.1 · his decision (12 Oct): at Ātmākarṣiṇī, beside the Higher
        // Self in the Trinity. The name is his, never hers: it still ends in
        // stillness (`handoff`), never in her Recognition.
        case .ramJapa:           return .seat(42)                // Ātmākarṣiṇī — the Higher Self's seat
        case .bhakti:            return .seat(24)                // Maṇipūra · Sarva-Mahāṅkuśā, navel hook
        case .sandhya:           return .ring(2)                 // the lotus that follows the sun
        case .greatWheel:        return .ring(1)                 // the year, the outermost ground of time
        }
    }

    /// How it ends.
    var handoff: PlayHandoff {
        switch self {
        case .corridor, .waterLevel, .shakeToClear, .bijaTones:
            return .stillness
        case .mandalaCompletion, .twelve, .letter, .worldInABox, .shadowScrolls,
             .tatTvamAsi, .turn, .ramJapa, .sandhya, .greatWheel:
            return .stillness
        case .rosary:
            // A held bead hands to her; a whole round hands to stillness.
            return .stillness
        default:
            return .recognition
        }
    }

    /// The light the game is played in — its address's ring, on the indigo
    /// sky, never red as anything but her own fire.
    var hue: Color {
        switch self {
        case .corridor:     return Color(red: 0.66, green: 0.55, blue: 0.92)
        case .pulse:        return Color(red: 0.50, green: 0.90, blue: 0.74)
        case .spineWalk:    return Color(red: 0.76, green: 0.70, blue: 0.98)
        case .echo:         return Color(red: 0.97, green: 0.85, blue: 0.44)
        case .fingerGarden: return Color(red: 0.78, green: 0.91, blue: 0.44)
        case .rain:         return Color(red: 0.56, green: 0.78, blue: 0.97)
        case .drum:         return Color(red: 0.91, green: 0.62, blue: 0.42)
        case .rootSystem:   return Color(red: 0.80, green: 0.60, blue: 0.38)
        case .waterLevel:   return Color(red: 0.50, green: 0.78, blue: 0.94)
        case .fire:         return Color(red: 0.98, green: 0.66, blue: 0.32)
        case .shakeToClear: return Color(red: 0.88, green: 0.72, blue: 0.97)
        case .door:         return Color(red: 0.97, green: 0.80, blue: 0.52)
        case .yantraTrace:  return Color(red: 0.95, green: 0.78, blue: 0.48)
        case .rosary:       return Color(red: 0.95, green: 0.84, blue: 0.62)
        case .bijaTones:    return Color(red: 0.96, green: 0.86, blue: 0.50)
        case .coherence:    return Color(red: 0.94, green: 0.63, blue: 0.72)
        case .seed:              return Color(red: 0.50, green: 0.90, blue: 0.74)
        case .mandalaCompletion: return Color(red: 0.91, green: 0.58, blue: 0.48)
        case .twelve:            return Color(red: 0.75, green: 0.69, blue: 0.97)
        case .bodyMap:           return Color(red: 0.55, green: 0.88, blue: 0.70)
        case .shadowTranslator:  return Color(red: 0.75, green: 0.63, blue: 0.91)
        case .mirrorMaze:        return Color(red: 0.88, green: 0.72, blue: 0.97)
        case .letter:            return Color(red: 0.50, green: 0.78, blue: 0.94)
        case .worldInABox:       return Color(red: 0.85, green: 0.78, blue: 0.97)
        case .colourRivers:      return Color(red: 0.97, green: 0.75, blue: 0.38)
        case .shadowScrolls:     return Color(red: 0.75, green: 0.69, blue: 0.97)
        case .stillAjna:         return Color(red: 0.66, green: 0.63, blue: 0.94)
        case .flash:             return Color(red: 0.50, green: 0.78, blue: 0.94)
        case .tatTvamAsi:        return Color(red: 0.88, green: 0.72, blue: 0.97)
        case .leela:             return Color(red: 0.36, green: 0.80, blue: 0.78)
        case .turn:              return Color(red: 0.93, green: 0.55, blue: 0.40)
        case .join:              return Color(red: 0.93, green: 0.80, blue: 0.40)
        case .ramJapa:           return Color(red: 0.98, green: 0.82, blue: 0.56)
        case .bhakti:            return Color(red: 0.97, green: 0.74, blue: 0.36)
        case .sandhya:           return Color(red: 0.98, green: 0.70, blue: 0.46)
        case .greatWheel:        return Color(red: 0.83, green: 0.66, blue: 0.40)
        }
    }

    /// The ground each game is played on — deep, and warmer with depth.
    var ground: Color {
        switch address.ring {
        case 1:  return Color(red: 0.07, green: 0.04, blue: 0.03)
        case 2:  return Color(red: 0.06, green: 0.03, blue: 0.06)
        case 3:  return Color(red: 0.04, green: 0.03, blue: 0.08)
        case 4:  return Color(red: 0.03, green: 0.05, blue: 0.07)
        case 5:  return Color(red: 0.03, green: 0.06, blue: 0.05)
        case 6:  return Color(red: 0.03, green: 0.04, blue: 0.09)
        case 7:  return Color(red: 0.06, green: 0.04, blue: 0.08)
        case 8:  return Color(red: 0.08, green: 0.04, blue: 0.05)
        default: return Color(red: 0.08, green: 0.03, blue: 0.04)
        }
    }
}

// MARK: - The address table, read both ways

enum PlayAddressBook {

    /// Every game whose address is this seat, in the walk's order.
    static func games(atPosition kp: Int) -> [PlayGame] {
        PlayGame.allCases.filter { $0.address == .seat(kp) }
    }

    /// The door on her Detail: the game at her seat when there is one, and
    /// otherwise the garland opened at her own bead — so every one of the 102
    /// can be played with, and position stays the only key.
    static func door(forPosition kp: Int) -> PlayGame {
        games(atPosition: kp).first ?? .rosary
    }

    /// Every seat that holds a game.
    static var seatedPositions: [Int] {
        PlayGame.allCases.compactMap { $0.address.position }
    }

    /// Every game at exactly this address, in the walk's order — a seat, a
    /// ring or a threshold.
    static func games(at address: PlayAddress) -> [PlayGame] {
        PlayGame.allCases.filter { $0.address == address }
    }

    /// Every game whose address lies in this ring — its seats, the ring
    /// itself, and the threshold that opens onto it (the garland excepted).
    static func games(inRing ring: Int) -> [PlayGame] {
        PlayGame.allCases.filter { $0.address != .garland && $0.address.ring == ring }
    }
}

// MARK: - Her position, for play

extension Shakti {
    /// Her khaḍgamālā position — the only key play uses. A Ring-2 row that has
    /// not yet been seeded with one falls back to its legacy petal position,
    /// the same fallback the Recognition ceremony files her under.
    var playPosition: Int { khadgamalaPosition ?? (position + 28) }
}

// MARK: - The entry point other waves call

/// The public way into play. Wave 3's Shadow threshold calls
/// `PlayField.open(.corridor)`; anything already inside a full-screen cover
/// builds `PlayField.host(.corridor) { … }` itself, because a cover cannot be
/// raised from beneath another.
enum PlayField {

    /// Posted with a `PlayGame` raw value (or `nil` for the whole field).
    static let openNotification = Notification.Name("BinduPlayFieldOpen")

    /// Ask the shell to open one game, or Lalitā's whole field.
    static func open(_ game: PlayGame? = nil) {
        NotificationCenter.default.post(name: openNotification, object: game?.rawValue)
    }

    /// One game, hosted, ready to put in a cover.
    /// `fromRoom` is the Map record of the chakra room the game was opened
    /// from (U0 · C14): its `Played` row then carries `Link to The Map`.
    static func host(_ game: PlayGame,
                     atPosition kp: Int? = nil,
                     fromRoom mapRecordId: String? = nil,
                     onClose: @escaping () -> Void) -> PlayGameHost {
        PlayGameHost(game: game, startPosition: kp, mapRecordId: mapRecordId, onClose: onClose)
    }
}
