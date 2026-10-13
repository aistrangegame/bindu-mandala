import SwiftUI

// MARK: - U1 · Look · one language per world, every token as a value (visual.md §1.3, §1.4)
//
// Each world wears one of the thirteen studio languages ("the world picks one,
// never two at once", R13:791); where a world has an inner room in a second
// language, entering it is a designed crossing and only one language is on
// screen at any moment. This file is §1.3's table and §1.4's token rows as
// Swift values. Views read roles (ground, surface, ink, ink-2, voice, spark),
// never hexes.
//
// Where a language names no value for a role, the role falls back by the
// precedence of §1.11.1 to the Mandala house token (the cream ink above all) —
// never to an invented colour. Where the source gives a value only as a range
// or as a live colour (her accent, the hour's ground), the token holds the
// static value the source does give and the comment names the live source.

/// The thirteen studio languages (rupakarshini, R13:11–40). Implements
/// `visual.md` §1.3 and §2 #1.
enum StudioLanguage: String, CaseIterable {
    case mandala, feed, linen, ascent, chakra, leela, play, field, candle, being, lalita, learning, blink
}

/// The colour roles of one language on one ground. Implements `visual.md` §1.4
/// (ground · surface · ink · ink-2 · voice · spark) and §2 #2 (role grammar).
struct WorldColours: Equatable {
    /// The ground at the centre of the glass.
    let ground: LookColor
    /// The ground at the rim, where the ground is a radial (nil = flat).
    var groundRim: LookColor? = nil
    var surface: LookColor? = nil
    /// Text: always ≥ 4.5 : 1 on `ground` (asserted for every world).
    let ink: LookColor
    /// Secondary text: ≥ 4.5 : 1 on `ground` where the language names one.
    var ink2: LookColor? = nil
    /// The voice / sig / gold of the language.
    var voice: LookColor? = nil
    var spark: LookColor? = nil
    /// The language's own named tokens (door reds, tokens, arrows, sky stops…).
    var named: [String: LookColor] = [:]
}

/// The type of one language: its display face, its UI face and, where it has
/// one, its voice (the italic register). Implements `visual.md` §1.3 / §1.4 type rows.
struct WorldTypes: Equatable {
    let display: TypeToken
    let ui: TypeToken
    var voice: TypeToken? = nil
}

/// One language as worn: its colours and type. A world's inner room is one of
/// these. Implements `visual.md` §1.3 "Inner crossing into".
struct LanguageStyle: Equatable {
    let language: StudioLanguage
    let colours: WorldColours
    let type: WorldTypes
}

/// Everything a world looks like: its language, colours, type, space, motion,
/// breath, chrome level and point. Implements `visual.md` §1.4 "Every token,
/// ported to SwiftUI — per world".
struct WorldStyle: Equatable {
    let world: WorldID
    let main: LanguageStyle
    /// The inner room in a second language, entered by a designed crossing.
    var inner: LanguageStyle? = nil
    /// Corner radius where the language sets one.
    var radius: CGFloat? = nil
    /// The language's step tempo (seconds per step) where it has one.
    var tempo: Double? = nil
    /// The crossing the world is entered by (§5 Doors).
    let arrival: MotionCurve

    var language: StudioLanguage { main.language }
    var colours: WorldColours { main.colours }
    var type: WorldTypes { main.type }
    var space: [CGFloat] { LookSpace.scale }
    var breath: Double? { WorldBreath.period(world) }
    var chrome: ChromeStep { ChromeStep.atRest(world) }
    var point: PointLook { PointLook.forWorld(world) }

    /// Every language this world may show (never two at once).
    var languages: [StudioLanguage] { [main.language] + (inner.map { [$0.language] } ?? []) }

    static let all: [WorldStyle] = WorldID.allCases.map { WorldStyle.of($0) }

    // MARK: - The fifteen

    static func of(_ world: WorldID) -> WorldStyle {
        switch world {
        case .home:         return home
        case .today:        return today
        case .mandala:      return mandala
        case .rings:        return rings
        case .herHome:      return herHome
        case .herPresence:  return herPresence
        case .climb:        return climb
        case .the33:        return the33
        case .game:         return game
        case .modes:        return modes
        case .time:         return time
        case .memory:       return memory
        case .well:         return well
        case .beneath:      return beneath
        case .relationship: return relationship
        }
    }

    private static func hex(_ s: String) -> LookColor { LookColor(hex: s) }

    private static let systemCaps11 = TypeToken(.systemCaps, 11, tracking: 0.22, uppercase: true)

    /// §1.4.1 — mandala · silence. Chrome 0 %, breath 4 s, arrives by the Waking.
    static let home = WorldStyle(
        world: .home,
        main: LanguageStyle(
            language: .mandala,
            colours: WorldColours(ground: HouseTokens.silence, groundRim: HouseTokens.ground,
                                  surface: HouseTokens.veil, ink: HouseTokens.cream, ink2: HouseTokens.ink2,
                                  voice: HouseTokens.gold,
                                  named: ["pointCore": HouseTokens.ember, "pointHalo": HouseTokens.crimson,
                                          "pointHaloLit": HouseTokens.crimsonLit, "mote": HouseTokens.gold,
                                          "moteMet": hex("#D8D2C4")]),
            type: WorldTypes(display: TypeToken(.cormorantLight, 15, tracking: 0.18),          // date + moon
                             ui: systemCaps11,                                                  // .22 em
                             voice: TypeToken(.cormorantLightItalic, 26))),                    // greeting
        arrival: LookMotion.waking)

    /// §1.4.2 — feed · prayer carrying her palette; linen before noon. Her
    /// accent and ground are live (`ShaktiPalette`); the prayer ground is static.
    static let today = WorldStyle(
        world: .today,
        main: LanguageStyle(
            language: .feed,
            colours: WorldColours(ground: hex("#050408"), surface: hex("#171420"), ink: hex("#EDE8E3"),
                                  ink2: HouseTokens.ink2, voice: HouseTokens.gold,
                                  named: ["field": hex("#0E0C12"), "light": hex("#EDE3CE"),
                                          "stoneNave": hex("#D9D2C4"), "stoneNaveLight": hex("#FBF9F4"),
                                          "stoneInk": hex("#16131B")]),
            type: WorldTypes(display: TypeToken(.cormorantLight, 64),                              // her name (56 SE, 72 max)
                             ui: TypeToken(.systemCaps, 13, tracking: 0.2, uppercase: true),
                             voice: TypeToken(.cormorantLightItalic, 20))),                        // somatic
        inner: linenMorning,
        arrival: LookMotion.blinkLids)

    /// The linen morning page (Today and Time before noon, §1.4.2).
    static let linenMorning = LanguageStyle(
        language: .linen,
        colours: WorldColours(ground: hex("#F6EFE2"), surface: hex("#FBF6EB"), ink: hex("#25201A"),
                              voice: hex("#AF5132"),                                  // ember as text (4.52)
                              named: ["emberGraphic": hex("#B8593A")]),
        type: WorldTypes(display: TypeToken(TypeFace(family: .instrumentSerif), 33),
                         ui: TypeToken(TypeFace(family: .geist), 17),
                         voice: TypeToken(TypeFace(family: .geistMono), 11)))

    /// §1.4.3 — mandala. The indigo well; chrome 100 % at whole instrument.
    static let mandala = WorldStyle(
        world: .mandala,
        main: LanguageStyle(
            language: .mandala,
            colours: WorldColours(ground: hex("#0A0611"), groundRim: hex("#030105"), surface: HouseTokens.veil,
                                  ink: HouseTokens.cream, ink2: HouseTokens.ink2, voice: HouseTokens.gold,
                                  named: ["skyMid": hex("#050308"), "bhupura": HouseTokens.goldWarm,
                                          "bindu": HouseTokens.crimson, "veil": HouseTokens.veil]),
            type: WorldTypes(display: TypeToken(.cormorantLight, 34),
                             ui: TypeToken(.systemCaps, 11, tracking: 0.32, uppercase: true))),
        arrival: LookMotion.veilDark)

    /// §1.4.4 — mandala · ring-n. The ring's own wash, deep and text are
    /// `RingLook.of(n)`; this is the world's frame on the house ground.
    static let rings = WorldStyle(
        world: .rings,
        main: LanguageStyle(
            language: .mandala,
            colours: WorldColours(ground: HouseTokens.ground, ink: HouseTokens.cream, ink2: HouseTokens.ink2,
                                  voice: HouseTokens.gold),
            type: WorldTypes(display: TypeToken(.cormorantLight, 28),
                             ui: TypeToken(.systemCaps, 11, tracking: 0.32, uppercase: true),
                             voice: TypeToken(.cormorantItalic, 15))),
        arrival: LookMotion.veilDark)

    /// §1.4.5 — mandala · per-being. Her palette at her ring's depth (live);
    /// the room's ground `#040103`.
    static let herHome = WorldStyle(
        world: .herHome,
        main: LanguageStyle(
            language: .mandala,
            colours: WorldColours(ground: hex("#040103"), ink: HouseTokens.cream, ink2: HouseTokens.ink2,
                                  voice: HouseTokens.gold),
            type: WorldTypes(display: TypeToken(.cormorantLight, 38),
                             ui: TypeToken(.systemCaps, 11, uppercase: true),
                             voice: TypeToken(.cormorantItalic, 15))),
        arrival: LookMotion.veilDark)

    /// §1.4.6 — feed identity header on her palette. Her deep ground is live;
    /// the house ground stands under it.
    static let herPresence = WorldStyle(
        world: .herPresence,
        main: LanguageStyle(
            language: .feed,
            colours: WorldColours(ground: HouseTokens.ground, ink: HouseTokens.cream, ink2: HouseTokens.ink2,
                                  voice: HouseTokens.gold),
            type: WorldTypes(display: TypeToken(.cormorantMedium, 26),
                             ui: TypeToken(.systemCaps, 12, tracking: 0.18, uppercase: true),
                             voice: TypeToken(.cormorantItalic, 18))),
        arrival: LookMotion.veilDark)

    /// §1.4.7 — ascent. Bands 1–6 wear the Axis's own dark; from band 7 the
    /// ascent sky (`inner`), ink flipping at mean ground luminance .6.
    static let climb = WorldStyle(
        world: .climb,
        main: LanguageStyle(
            language: .ascent,
            colours: WorldColours(ground: hex("#0A0A0C"), groundRim: hex("#3A3A44"), ink: HouseTokens.cream,
                                  named: ["envMid": hex("#1A1A20"), "door": hex("#B8322B"),
                                          "doorDeep": hex("#5F1814"), "doorHot": hex("#D94A3E")]),
            type: WorldTypes(display: TypeToken(.cormorantLightItalic, 26),
                             ui: TypeToken(TypeFace(family: .inter), 11, tracking: 0.28, uppercase: true),
                             voice: TypeToken(.cormorantLightItalic, 22))),
        inner: ascentSky,
        arrival: LookMotion.veilDark)

    /// The ascent sky above band 7 (§1.4.7): stops `#D8B658 0 · #C9A84C .18 ·
    /// #D4B76A .32 · #E6D29A .50 · #F4E9CF .68 · #FAF6EC .82 · #FBFAF6 .92 ·
    /// #FFFFFF 1` from (0.5, 1.10).
    static let ascentSky = LanguageStyle(
        language: .ascent,
        colours: WorldColours(ground: hex("#F4E9CF"), groundRim: hex("#FFFFFF"), ink: hex("#3A2E15"),
                              ink2: hex("#4A3C1E"),
                              named: ["ink3": hex("#5A4B28"), "door": hex("#B8322B"), "skyBase": hex("#D8B658")]),
        type: WorldTypes(display: TypeToken(.cormorantLightItalic, 26),
                         ui: TypeToken(TypeFace(family: .inter), 11, tracking: 0.28, uppercase: true)))

    /// The sky's stops, in order (location, colour).
    static let ascentSkyStops: [(Double, LookColor)] = [
        (0, hex("#D8B658")), (0.18, hex("#C9A84C")), (0.32, hex("#D4B76A")), (0.50, hex("#E6D29A")),
        (0.68, hex("#F4E9CF")), (0.82, hex("#FAF6EC")), (0.92, hex("#FBFAF6")), (1, hex("#FFFFFF")),
    ]

    /// The Climb's ink switches to the ascent ink above this mean luminance.
    static let ascentInkFlipLuminance = 0.6

    /// §1.4.8 — chakra, all 33. Room hue is the Map's Color Hex (`CanonColour`).
    static let the33 = WorldStyle(
        world: .the33,
        main: LanguageStyle(
            language: .chakra,
            colours: WorldColours(ground: hex("#0C0A12"), groundRim: hex("#020205"),
                                  ink: LookColor(hex: "#F0E8DC", alpha: 0.92), ink2: hex("#99948F"),
                                  voice: hex("#C9A84C"), spark: hex("#E8C568"),
                                  named: ["line": LookColor(hex: "#F0E8DC", alpha: 0.10),
                                          "child": hex("#C47820"), "childInk": hex("#F0B85A"),
                                          "mirror": hex("#C8CCD8"), "cream": hex("#F8F1DF"),
                                          "creamSurface": hex("#EADCBA"), "creamInk": hex("#3A2E15"),
                                          "dot": HouseTokens.ember]),
            type: WorldTypes(display: TypeToken(.cormorantLight, 34, tracking: 0.06, uppercase: true),
                             ui: TypeToken(TypeFace(family: .dmSans), 11, tracking: 0.16, uppercase: true))),
        arrival: LookMotion.veilDark)

    /// §1.4.9 — leela (board); each game in play.
    static let game = WorldStyle(
        world: .game,
        main: LanguageStyle(
            language: .leela,
            colours: WorldColours(ground: hex("#E3E9EA"), surface: hex("#F2F5F4"), ink: hex("#1D2631"),
                                  ink2: hex("#56616C"), voice: hex("#B08A33"),
                                  named: ["line": hex("#C5CFD2"), "token": hex("#0F7C7A"),
                                          "tokenText": hex("#007573"), "arrows": hex("#B08A33"),
                                          "snakes": hex("#6A4C9C"),
                                          "darkSlate": hex("#1B2230"), "darkCard": hex("#232B3A"),
                                          "darkInk": hex("#E6ECEE"), "darkToken": hex("#3FB8B4"),
                                          "darkArrows": hex("#D6B25C"), "darkSnakes": hex("#A58ADB")]),
            type: WorldTypes(display: TypeToken(TypeFace(family: .lora), 17),
                             ui: TypeToken(TypeFace(family: .dmSans), 13))),
        inner: play,
        arrival: LookMotion.veilLight)

    /// Play (§1.4.9): cloth, paper and the ten sketch grounds.
    static let play = LanguageStyle(
        language: .play,
        colours: WorldColours(ground: hex("#0F4A50"), surface: hex("#0B3E43"), ink: hex("#F3ECDD"),
                              ink2: hex("#A7C6C1"), voice: hex("#F2B632"), spark: hex("#F6D27A"),
                              named: ["lilac": hex("#C2B2F4"), "paper": hex("#F4EBDA"), "paperInk": hex("#2B2621"),
                                      "paperQuiet": hex("#6E655B"),
                                      "choose": hex("#3B2A55"), "talk": hex("#1D2F5E"), "manage": hex("#1F4D2B"),
                                      "join": hex("#6E4A1E"), "turn": hex("#7A2E1E"), "trace": hex("#22205A"),
                                      "still": hex("#0E5566"), "beat": hex("#5E1B2B"), "release": hex("#123A4A"),
                                      "seal": hex("#6A5A3E")]),
        type: WorldTypes(display: TypeToken(TypeFace(family: .gloock), 40),
                         ui: TypeToken(TypeFace(family: .newsreader), 17)))

    /// §1.4.10 — field; Pūjā wears candle. Each mode tints `hsl(h, 55, 68)` by
    /// its element (`ElementLayout.tint`).
    static let modes = WorldStyle(
        world: .modes,
        main: LanguageStyle(
            language: .field,
            colours: WorldColours(ground: hex("#020208"), groundRim: hex("#05050F"), ink: hex("#F5E2D6"),
                                  ink2: hex("#887D79"), voice: hex("#D46453"), spark: hex("#C4A862"),
                                  named: ["line": LookColor(hex: "#FFFFFF", alpha: 0.08)]),
            type: WorldTypes(display: TypeToken(TypeFace(family: .lora, weight: .light, italic: true), 64),
                             ui: TypeToken(TypeFace(family: .dmSans), 13),
                             voice: TypeToken(TypeFace(family: .dmMono), 76))),             // readouts
        inner: candle,
        radius: 10,
        arrival: LookMotion.veilDark)

    /// Candle (Pūjā, §1.4.10): no sound. Cinzel's size is not given in §1.4.10;
    /// it takes the field's UI size until Design names one.
    static let candle = LanguageStyle(
        language: .candle,
        colours: WorldColours(ground: hex("#100A08"), surface: hex("#1A1410"), ink: hex("#E8D9B8"),
                              ink2: hex("#928672"), voice: hex("#C9A84C"), spark: hex("#E8C162"),
                              named: ["unreachedDecor": hex("#6B5A3E"), "unreachedText": hex("#8E7D5F")]),
        type: WorldTypes(display: TypeToken(TypeFace(family: .cinzel), 13, tracking: 0.32),
                         ui: TypeToken(TypeFace(family: .lora, italic: true), 13)))

    /// §1.4.11 — mandala relit by the hour; linen before noon. The ground is
    /// the hour's (`TimeVariant.bg`); the house ground stands for it here.
    static let time = WorldStyle(
        world: .time,
        main: LanguageStyle(
            language: .mandala,
            colours: WorldColours(ground: HouseTokens.ground, ink: HouseTokens.cream, ink2: HouseTokens.ink2,
                                  voice: HouseTokens.gold),
            type: WorldTypes(display: TypeToken(.cormorantLight, 15, tracking: 0.18),
                             ui: TypeToken(.cormorantLight, 15, tracking: 0.18, uppercase: true))),  // Roman-numeral caps
        inner: linenMorning,
        arrival: LookMotion.veilDark)

    /// §1.4.12 — being (day); the printed record on the candle sheet.
    static let memory = WorldStyle(
        world: .memory,
        main: LanguageStyle(
            language: .being,
            colours: WorldColours(ground: hex("#FAF6EE"), surface: hex("#F4EFE6"), ink: hex("#2E2A24"),
                                  ink2: hex("#5A5349"), voice: hex("#5F7355"), spark: hex("#BE5A4E"),
                                  named: ["voiceGraphic": hex("#7C8F6E"), "deep": hex("#19160F"),
                                          "duskTop": hex("#2B261F"), "duskMid": hex("#211E19"),
                                          "duskInk": hex("#F4EFE6"), "duskInk2": hex("#9E9991"),
                                          "gaia": hex("#7A9B6E"), "sakshi": hex("#6E8597"), "grace": hex("#C2918E"),
                                          "bindu": hex("#BE5A4E"), "hold": hex("#928A7E"), "chant": hex("#C3A359")]),
            type: WorldTypes(display: TypeToken(TypeFace(family: .fraunces, weight: .light), 33),
                             ui: TypeToken(TypeFace(family: .spectral), 17))),
        inner: candleSheet,
        arrival: LookMotion.veilLight)

    /// The printed record (§1.4.12).
    static let candleSheet = LanguageStyle(
        language: .candle,
        colours: WorldColours(ground: hex("#FBF5E6"), ink: hex("#2A1F14"), voice: hex("#9D4439")),
        type: WorldTypes(display: TypeToken(TypeFace(family: .cinzel), 17, tracking: 0.32),
                         ui: TypeToken(TypeFace(family: .spectral), 17)))

    /// §1.4.13 — lalita · under; the Descent into learning · dark. The face
    /// changes at the crossing: Newsreader 300 Italic.
    static let well = WorldStyle(
        world: .well,
        main: LanguageStyle(
            language: .lalita,
            colours: WorldColours(ground: hex("#0E0C14"), groundRim: hex("#07060C"), surface: hex("#07060C"),
                                  ink: HouseTokens.cream, ink2: hex("#B9B2C9"), voice: hex("#8E7AB5"),
                                  named: ["muted": hex("#8D86A0")]),
            type: WorldTypes(display: TypeToken(TypeFace(family: .newsreader, weight: .light, italic: true), 24),
                             ui: TypeToken(TypeFace(family: .newsreader, weight: .light, italic: true), 17))),
        inner: learningDark,
        tempo: 1.2,
        arrival: LookMotion.descent)

    /// Learning · dark (§1.4.13): "every screen change passes through the ember".
    static let learningDark = LanguageStyle(
        language: .learning,
        colours: WorldColours(ground: hex("#0A0806"), groundRim: hex("#080605"), surface: hex("#14100A"),
                              ink: hex("#F4ECDA"), voice: hex("#DD3E16"), spark: hex("#F3B05A"),
                              named: ["whiteHot": hex("#FFFCF4"), "seedMid": hex("#F7C478"), "seedEdge": hex("#DA3B12")]),
        type: WorldTypes(display: TypeToken(TypeFace(family: .ebGaramond), 24),
                         ui: TypeToken(TypeFace(family: .spaceMono), 11, uppercase: true)))

    /// §1.4.14 — blink: fifteen temperatures warming inward.
    static let beneath = WorldStyle(
        world: .beneath,
        main: LanguageStyle(
            language: .blink,
            colours: WorldColours(ground: beneathTemperatures[0], ink: hex("#DBD5CC"), ink2: hex("#807E79"),
                                  voice: hex("#C8A96E"),
                                  named: ["ember": hex("#7A2F14"), "emberLit": hex("#94472C"),
                                          "flashLavender": hex("#C9A8E8")]),
            type: WorldTypes(display: TypeToken(TypeFace(family: .lora), 19),
                             ui: TypeToken(TypeFace(family: .dmSans), 11, tracking: 3.0 / 11.0, uppercase: true))),
        inner: learningDark,
        arrival: LookMotion.descent)

    /// Beneath's fifteen section temperatures, outer → the point.
    static let beneathTemperatures: [LookColor] = [
        "#0A0A0C", "#09090E", "#0C0904", "#07090E", "#080808", "#0C0A07", "#0E0B09", "#0A0A0C",
        "#0A0A0C", "#09090E", "#0D0907", "#080A0E", "#090B09", "#0C0A08", "#0F0B09",
    ].map { LookColor(hex: $0) }

    /// §1.4.15 — lalita night; a Person is a paper room.
    static let relationship = WorldStyle(
        world: .relationship,
        main: LanguageStyle(
            language: .lalita,
            colours: WorldColours(ground: hex("#1A1826"), surface: hex("#23202F"), ink: hex("#ECE7DD"),
                                  ink2: hex("#B6B0C2"), voice: hex("#B3B3DD"), spark: hex("#F9E3A7"),
                                  named: ["muted": hex("#8D879D"), "sig": hex("#8E7AB5")]),
            type: WorldTypes(display: TypeToken(TypeFace(family: .instrumentSans, weight: .medium), 40, tracking: -0.02),
                             ui: TypeToken(TypeFace(family: .instrumentSans), 17),
                             voice: TypeToken(TypeFace(family: .instrumentSans, weight: .medium), 12, tracking: 0.18, uppercase: true))),
        inner: relationshipPaper,
        radius: 20,
        tempo: 0.6,
        arrival: LookMotion.veilDark)

    /// A Person's paper room (§1.4.15), tempo 350 ms.
    static let relationshipPaper = LanguageStyle(
        language: .lalita,
        colours: WorldColours(ground: hex("#FBF8F1"), surface: hex("#FFFFFF"), ink: hex("#2B2620"),
                              ink2: hex("#57503F"), voice: hex("#D39562"),
                              named: ["surface2": hex("#F4F0E7"), "line": hex("#E2DBCD"), "muted": hex("#756C5D")]),
        type: WorldTypes(display: TypeToken(TypeFace(family: .instrumentSans, weight: .medium), 26),
                         ui: TypeToken(TypeFace(family: .instrumentSans), 17)))

    /// `personHue(name)`: `n = n·31 + scalar` (UInt32 wrap), `hue = round((n ×
    /// 137.508) mod 360)` (§1.4.15). The three existing connections take their
    /// Śakti's mandala hue instead (ruling 11).
    static func personHue(_ name: String) -> Double {
        var n: UInt32 = 0
        for s in name.unicodeScalars { n = n &* 31 &+ s.value }
        return (Double(n) * 137.508).truncatingRemainder(dividingBy: 360).rounded()
    }
}

// MARK: - The world's style in the environment (§1.3: each world root carries its language)

private struct WorldStyleKey: EnvironmentKey {
    static let defaultValue: WorldStyle = WorldStyle.home
}

extension EnvironmentValues {
    /// The style of the world this view stands in. A world root sets it once
    /// (`.worldStyle(.of(world))`); everything inside reads roles from it.
    var worldStyle: WorldStyle {
        get { self[WorldStyleKey.self] }
        set { self[WorldStyleKey.self] = newValue }
    }
}

extension View {
    /// Set the world's style for everything inside (one language at a time).
    func worldStyle(_ style: WorldStyle) -> some View {
        environment(\.worldStyle, style)
    }
}
