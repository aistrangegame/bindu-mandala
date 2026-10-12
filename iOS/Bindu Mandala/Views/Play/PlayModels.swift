import SwiftUI

// MARK: - Wave 4 · one shape for every game
//
// A game is a model on the play clock: it advances, it draws its light into a
// `Canvas`, and it feels touches from the `TouchSenseSurface`. Models are
// classes that publish nothing — the timeline redraws them, so a game can run
// at sixty frames without re-rendering a single view.

protocol PlayModel: AnyObject {
    /// One frame. Physics, sound and haptics happen here and in the touches.
    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion)
    /// The light. `breath` is wall-clock seconds for ornament; `still` is
    /// reduce-motion, which quiets the ornament and never the game.
    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool)

    func began(_ s: TouchSample, session: PlaySession)
    func moved(_ s: TouchSample, session: PlaySession)
    func ended(_ s: TouchSample, session: PlaySession)

    /// A name the game shows beneath its light — the garland's bead.
    var hasCaption: Bool { get }
    func caption(names: [Int: String]) -> String

    /// Wave 6 · his own word, for the games that ask for one (Mirror Maze,
    /// the Letter, Flash). The game raises `session.ask(true)`; the host
    /// gives what he wrote here. Words a game is given are play: released
    /// from the view when the game ends, never kept on the glass — except the
    /// Letter, which seals them into his river, where they are kept.
    func give(word: String, session: PlaySession)

    /// Wave 6 · her own words, by position, for the games whose answers come
    /// from her rows (charter law 8: authored, never generated). Called once
    /// as the game opens.
    func meet(_ words: [Int: PlayWords])
}

/// What a game may read of a Śakti's row: her name and her own words.
struct PlayWords: Equatable {
    var name: String
    var appreciation: String
    var function: String
    var quality: String
}

extension PlayModel {
    func moved(_ s: TouchSample, session: PlaySession) {}
    func ended(_ s: TouchSample, session: PlaySession) {}
    var hasCaption: Bool { false }
    func caption(names: [Int: String]) -> String { "" }
    func give(word: String, session: PlaySession) {}
    func meet(_ words: [Int: PlayWords]) {}
}

/// Frame-to-frame time, clamped so a stalled frame never becomes a leap.
struct FrameClock {
    private var last: Double? = nil

    mutating func tick(_ now: Double) -> Double {
        defer { last = now }
        guard let l = last else { return 0 }
        return min(max(now - l, 0), 1.0 / 20)
    }
}

/// A light that rings outward from where something happened.
struct PlayRipple {
    let center: CGPoint
    let born: Double
    let color: Color
    var life: Double = 1.6
    var reach: CGFloat = 140

    func phase(_ now: Double) -> Double { (now - born) / life }
    func alive(_ now: Double) -> Bool { phase(now) < 1 }

    func draw(in ctx: GraphicsContext, now: Double, width: CGFloat = 1.2) {
        let p = phase(now)
        guard p >= 0, p < 1 else { return }
        let r = 6 + reach * CGFloat(1 - pow(1 - p, 2.2))
        let a = 0.55 * (1 - p)
        ctx.stroke(Path(ellipseIn: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2)),
                   with: .color(color.opacity(a)), lineWidth: width)
    }
}

enum PlayModels {
    static func make(_ game: PlayGame, startPosition: Int?) -> any PlayModel {
        switch game {
        case .corridor:     return CorridorModel()
        case .pulse:        return PulseModel()
        case .spineWalk:    return SpineWalkModel()
        case .echo:         return EchoModel()
        case .fingerGarden: return FingerGardenModel()
        case .rain:         return RainModel()
        case .drum:         return DrumModel()
        case .rootSystem:   return RootSystemModel()
        case .waterLevel:   return WaterLevelModel()
        case .fire:         return FireModel()
        case .shakeToClear: return ShakeToClearModel()
        case .door:         return DoorModel()
        case .yantraTrace:  return YantraTraceModel()
        case .rosary:       return RosaryModel(startingAt: startPosition ?? KhadgamalaMap.total)
        case .bijaTones:    return BijaTonesModel()
        case .coherence:    return CoherenceModel()
        case .seed:              return SeedModel(store: PlayGardenStore.shared)
        case .mandalaCompletion: return MandalaCompletionModel()
        case .twelve:            return TwelveModel()
        case .bodyMap:           return BodyMapModel()
        case .shadowTranslator:  return ShadowTranslatorModel()
        case .mirrorMaze:        return MirrorMazeModel()
        case .letter:            return LetterModel(to: startPosition ?? 88)
        case .worldInABox:       return WorldInABoxModel(store: PlayGardenStore.shared)
        case .colourRivers:      return ColourRiversModel()
        case .shadowScrolls:     return ShadowScrollsModel()
        case .stillAjna:         return StillAjnaModel()
        case .flash:             return FlashModel()
        case .tatTvamAsi:        return TatTvamAsiModel()
        case .leela:             return LeelaModel()
        case .turn:              return TurnModel()
        case .join:              return JoinModel()
        case .ramJapa:           return RamJapaModel()
        case .bhakti:            return BhaktiModel()
        case .sandhya:           return SandhyaModel(now: Date())
        case .greatWheel:        return GreatWheelModel(now: Date(), store: PlayGardenStore.shared)
        }
    }

    /// The point's pitch (charter §3 law 5).
    static let pointHz: Double = 136.1
}
