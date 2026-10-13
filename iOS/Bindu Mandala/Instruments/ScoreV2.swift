import Foundation

// MARK: - U1 · D · Score Format v2.0, typed
//
// `bindu-field/references/score-format-v2.md` §2–§3 (the format), summarised in
// `waves/upgrade/worlds/the-33-architecture.md` §2 row 61 ("Swift `ScoreV2:
// Codable` mirroring the … sections") and `sound.md` §1.8 / S62.
//
// The format names twenty-four sections and lists twenty-five; every one is
// here. Nine are required (identity, config, anchors, phases, silence_windows,
// binaural, consciousness_loop, return, field_connection). The sections the
// player runs are typed; the sections that are *names pointing into a
// vocabulary module* (§3.18 "Every entry is a name pointing into the
// vocabulary module, not a drawing instruction") stay `ScoreJSON`, so a Score
// may say anything there without the app refusing it.
//
// Every optional field decodes from absent or null. Keys are the format's own
// snake_case, written out in each `CodingKeys` — no key strategy, because a
// strategy would also rewrite the keys inside the free `ScoreJSON` sections.

/// A Bindu Score, v2.0 (score-format-v2.md §2).
struct ScoreV2: Codable, Equatable {

    /// `"bindu-score/v2.0"`.
    let schema: String
    let score: Body
    /// The `extract.py` output beside the mp3 (`<id>-data.json`), §3.26.
    let audioDataRef: String?

    static let schemaV2 = "bindu-score/v2.0"

    enum CodingKeys: String, CodingKey {
        case schema, score
        case audioDataRef = "audio_data_ref"
    }

    /// The twenty-five sections.
    struct Body: Codable, Equatable {
        let identity: Identity
        let reading: Reading?
        let metaphor: Metaphor?
        let config: Config
        let anchors: Anchors
        let phases: [Phase]
        let silenceWindows: [SilenceWindow]
        let silenceFootprintPct: Double?
        let bloom: Bloom?
        let ensemble: Ensemble?
        let spatialMemory: ScoreJSON?
        let path: [PathStep]?
        let geometry: ScoreJSON?
        let shapeChoreography: [Shape]?
        let mirrorSystem: MirrorSystem?
        let binaural: Binaural
        let consciousnessLoop: ConsciousnessLoop
        let returnPlan: Return
        let tiers: ScoreJSON?
        let haptics: Haptics?
        let voiceTriggers: [VoiceTrigger]?
        let optionalLayers: OptionalLayers?
        let fieldConnection: FieldConnection
        let crossDance: ScoreJSON?
        let resonanceLink: ScoreJSON?
        let personalOffering: ScoreJSON?

        enum CodingKeys: String, CodingKey {
            case identity, reading, metaphor, config, anchors, phases
            case silenceWindows = "silence_windows"
            case silenceFootprintPct = "silence_footprint_pct"
            case bloom, ensemble
            case spatialMemory = "spatial_memory"
            case path, geometry
            case shapeChoreography = "shape_choreography"
            case mirrorSystem = "mirror_system"
            case binaural
            case consciousnessLoop = "consciousness_loop"
            case returnPlan = "return"
            case tiers, haptics
            case voiceTriggers = "voice_triggers"
            case optionalLayers = "optional_layers"
            case fieldConnection = "field_connection"
            case crossDance = "cross_dance"
            case resonanceLink = "resonance_link"
            case personalOffering = "personal_offering"
        }
    }

    // MARK: §3.1 identity

    struct Identity: Codable, Equatable {
        let id: String
        let verb: String?
        let registryNumber: Double?
        let title: String?
        let song: Song?
        let chakra: String?
        let trackId: Double?
        let airtableRecordId: String?
        let category: String?
        let version: String?
        let composedBy: String?
        let composedAt: String?

        enum CodingKeys: String, CodingKey {
            case id, verb
            case registryNumber = "registry_number"
            case title, song, chakra
            case trackId = "track_id"
            case airtableRecordId = "airtable_record_id"
            case category, version
            case composedBy = "composed_by"
            case composedAt = "composed_at"
        }
    }

    struct Song: Codable, Equatable {
        let title: String?
        let artist: String?
        let durationSeconds: Double?

        enum CodingKeys: String, CodingKey {
            case title, artist
            case durationSeconds = "duration_seconds"
        }
    }

    // MARK: §3.2 reading · §3.3 metaphor

    struct Reading: Codable, Equatable {
        let recognitionStatement: String?
        let seedPhrase: String?
        let arcShape: String?
        let element: String?

        enum CodingKeys: String, CodingKey {
            case recognitionStatement = "recognition_statement"
            case seedPhrase = "seed_phrase"
            case arcShape = "arc_shape"
            case element
        }
    }

    struct Metaphor: Codable, Equatable {
        let name: String?
        /// The Layer 3 module the renderer loads; absent → Layer 1 only.
        let vocabularyModule: String?
        let oneLine: String?
        let elements: [String]?
        let palette: ScoreJSON?

        enum CodingKeys: String, CodingKey {
            case name
            case vocabularyModule = "vocabulary_module"
            case oneLine = "one_line"
            case elements, palette
        }
    }

    // MARK: §3.4 config · §3.5 anchors

    struct Config: Codable, Equatable {
        let binduHue: Double?
        let darkRatio: Double?
        /// Authored, not extracted (§4).
        let peakT: Double
        let returnStart: Double?
        let bpm: Double?
        let hitThreshold: Double?
        let hitCount: Double?
        let frameInterval: Double?

        enum CodingKeys: String, CodingKey {
            case binduHue = "bindu_hue"
            case darkRatio = "dark_ratio"
            case peakT = "peak_t"
            case returnStart = "return_start"
            case bpm
            case hitThreshold = "hit_threshold"
            case hitCount = "hit_count"
            case frameInterval = "frame_interval"
        }
    }

    struct Anchors: Codable, Equatable {
        let peakT: PeakAnchor?
        let phasesAuthored: Bool?
        let silenceWindowsSource: String?
        let mirrorTimesAuthored: Bool?

        enum CodingKeys: String, CodingKey {
            case peakT = "peak_t"
            case phasesAuthored = "phases_authored"
            case silenceWindowsSource = "silence_windows_source"
            case mirrorTimesAuthored = "mirror_times_authored"
        }
    }

    struct PeakAnchor: Codable, Equatable {
        let value: Double?
        let extracted: Double?
        let authored: Bool?
        let reason: String?
        /// A batch peak not yet listened to (V42: "Peaks marked needs_listening
        /// stay flagged until he listens").
        let needsListening: Bool?

        enum CodingKeys: String, CodingKey {
            case value, extracted, authored, reason
            case needsListening = "needs_listening"
        }
    }

    // MARK: §3.6 phases · §3.7 silence_windows

    struct Phase: Codable, Equatable {
        let name: String
        let start: Double
        let end: Double
        let character: String?
    }

    struct SilenceWindow: Codable, Equatable {
        let start: Double
        let end: Double
        let role: String?
    }

    // MARK: §3.8 bloom · §3.9 ensemble

    struct Bloom: Codable, Equatable {
        let stages: Double?
        let riseRate: Double?
        let fallRate: Double?
        let thresholds: [String: Double]?
        let systems: [String]?

        enum CodingKeys: String, CodingKey {
            case stages
            case riseRate = "rise_rate"
            case fallRate = "fall_rate"
            case thresholds, systems
        }
    }

    struct Ensemble: Codable, Equatable {
        let generationOrder: [String]?
        let dancers: [String: Dancer]?
        let leitmotifs: [String: String]?

        enum CodingKeys: String, CodingKey {
            case generationOrder = "generation_order"
            case dancers, leitmotifs
        }
    }

    struct Dancer: Codable, Equatable {
        /// A number, `"dynamic"` (Ashrey), or null (a batch draft).
        let hue: ScoreJSON?
        let baseR: Double?
        let orbitR: Double?
        let maxGhost: Double?
        /// The stream it reads — universal (§3.9: "this assignment is universal
        /// and should not vary").
        let reads: String?

        enum CodingKeys: String, CodingKey {
            case hue
            case baseR = "base_r"
            case orbitR = "orbit_r"
            case maxGhost = "max_ghost"
            case reads
        }
    }

    // MARK: §3.11 path · §3.13 shape_choreography

    struct PathStep: Codable, Equatable {
        let phase: String?
        let mode: String?
        let maxBlend: Double?
        let plateau: Double?
        let side: Double?
        let radius: Double?
        let duration: Double?
        let triggerAt: ScoreTrigger?
        let rampIn: Double?
        let inverting: Bool?
        let position: String?

        enum CodingKeys: String, CodingKey {
            case phase, mode
            case maxBlend = "max_blend"
            case plateau, side, radius, duration
            case triggerAt = "trigger_at"
            case rampIn = "ramp_in"
            case inverting, position
        }
    }

    struct Shape: Codable, Equatable {
        /// arc · heart · infinity · spiral · circle · flower, or others as composed.
        let type: String
        let triggerAt: ScoreTrigger?
        let duration: Double?
        let plateau: Double?
        let maxBlend: Double?
        let radius: Double?
        let side: Double?
        let rampIn: Double?

        enum CodingKeys: String, CodingKey {
            case type
            case triggerAt = "trigger_at"
            case duration, plateau
            case maxBlend = "max_blend"
            case radius, side
            case rampIn = "ramp_in"
        }
    }

    // MARK: §3.14 mirror_system

    struct MirrorSystem: Codable, Equatable {
        let times: [Double]?
        let durationPerWord: Double?
        /// Sixteen consonant-skeleton families, five words each — the words
        /// verbatim per Score.
        let families: [String: [String]]?
        let familyTheme: String?
        let eventTriggers: [EventTrigger]?

        enum CodingKeys: String, CodingKey {
            case times
            case durationPerWord = "duration_per_word"
            case families
            case familyTheme = "family_theme"
            case eventTriggers = "event_triggers"
        }
    }

    struct EventTrigger: Codable, Equatable {
        let condition: String
        let darkness: Double?
    }

    // MARK: §3.15 binaural

    struct Binaural: Codable, Equatable {
        let carrier: Carrier
        let beatSchedule: [BeatStep]
        let gain: Gain?
        let karishmaOverride: KarishmaOverride?
        let spatial: Spatial?
        /// thunderclouds' subtractive event (Appendix B) — shape not yet fixed
        /// by any shipped Score.
        let carrierDropout: ScoreJSON?

        enum CodingKeys: String, CodingKey {
            case carrier
            case beatSchedule = "beat_schedule"
            case gain
            case karishmaOverride = "karishma_override"
            case spatial
            case carrierDropout = "carrier_dropout"
        }
    }

    struct Carrier: Codable, Equatable {
        let hz: Double
        let note: String?
        /// absent_fifth · absent_root · present_root · imposed.
        let derivation: String?
        let derivationOf: String?
        let confidence: String?
        let heldBy: String?
        let fixed: Bool?
        /// Required when `derivation` is `imposed` (rule 14).
        let reason: String?

        enum CodingKeys: String, CodingKey {
            case hz, note, derivation
            case derivationOf = "derivation_of"
            case confidence
            case heldBy = "held_by"
            case fixed, reason
        }
    }

    struct BeatStep: Codable, Equatable {
        /// The step's end; null on the final step.
        let until: Double?
        let hz: ScoreBeatHz
        let state: String?
        let role: String?
        /// A beat placed rather than found (cross's Schumann and 2.69 Hz).
        let designed: Bool?
        let ramp: Bool?
    }

    struct Gain: Codable, Equatable {
        let law: String?
        let formula: String?
        let heldBy: String?
        let phaseMultipliers: [PhaseMultiplier]?
        let finalRampSeconds: Double?

        enum CodingKeys: String, CodingKey {
            case law, formula
            case heldBy = "held_by"
            case phaseMultipliers = "phase_multipliers"
            case finalRampSeconds = "final_ramp_seconds"
        }
    }

    struct PhaseMultiplier: Codable, Equatable {
        let window: [Double]
        let x: Double
        let role: String?
    }

    struct KarishmaOverride: Codable, Equatable {
        /// "freeze": the beat holds its last value.
        let behavior: String?
        let appliesTo: [String]?

        enum CodingKeys: String, CodingKey {
            case behavior
            case appliesTo = "applies_to"
        }
    }

    struct Spatial: Codable, Equatable {
        let trueBinaural: Bool?
        let pan: String?
        let gyroTiltToPan: Double?

        enum CodingKeys: String, CodingKey {
            case trueBinaural = "true_binaural"
            case pan
            case gyroTiltToPan = "gyro_tilt_to_pan"
        }
    }

    // MARK: §3.16 consciousness_loop

    struct ConsciousnessLoop: Codable, Equatable {
        let seed: Seed?
        let wordReveal: WordReveal?
        let fruit: Fruit?

        enum CodingKeys: String, CodingKey {
            case seed
            case wordReveal = "word_reveal"
            case fruit
        }
    }

    struct Seed: Codable, Equatable {
        let text: String?
        let namedVariant: String?
        let typesAtBpm: Bool?
        let msPerCharacter: Double?

        enum CodingKeys: String, CodingKey {
            case text
            case namedVariant = "named_variant"
            case typesAtBpm = "types_at_bpm"
            case msPerCharacter = "ms_per_character"
        }
    }

    struct WordReveal: Codable, Equatable {
        /// `"peak_t"`, a number, or `"peak_t ± n"`.
        let at: String?
        let position: String?
        let iLoveYouAt: String?

        enum CodingKeys: String, CodingKey {
            case at, position
            case iLoveYouAt = "i_love_you_at"
        }
    }

    struct Fruit: Codable, Equatable {
        let core: String?
        let weaves: [Weave]?
        let secondWordPrompt: String?

        enum CodingKeys: String, CodingKey {
            case core, weaves
            case secondWordPrompt = "second_word_prompt"
        }
    }

    struct Weave: Codable, Equatable {
        let condition: String
        let text: String
    }

    // MARK: §3.17 return

    struct Return: Codable, Equatable {
        let name: String?
        let startsSecondsBeforeEnd: Double?
        let dissolutionOrder: [String]?
        let karishmaFinalBloom: Bool?
        let binduEnding: String?
        let adaptive: Bool?
        let dissolutionSchedule: ScoreJSON?

        enum CodingKeys: String, CodingKey {
            case name
            case startsSecondsBeforeEnd = "starts_seconds_before_end"
            case dissolutionOrder = "dissolution_order"
            case karishmaFinalBloom = "karishma_final_bloom"
            case binduEnding = "bindu_ending"
            case adaptive
            case dissolutionSchedule = "dissolution_schedule"
        }
    }

    // MARK: §3.19 haptics · §3.20 voice_triggers · §3.21 optional_layers

    struct Haptics: Codable, Equatable {
        let patterns: [String: HapticSpec]?
        let bellCriteria: ScoreJSON?

        enum CodingKeys: String, CodingKey {
            case patterns
            case bellCriteria = "bell_criteria"
        }
    }

    struct HapticSpec: Codable, Equatable {
        /// `"peak_t"`, `"mirror-word"`, `"bell-hit"`, or seconds.
        let firesAt: ScoreTrigger?
        let patternMs: [Double]?
        let intensityFactor: String?
        let description: String?

        enum CodingKeys: String, CodingKey {
            case firesAt = "fires_at"
            case patternMs = "pattern_ms"
            case intensityFactor = "intensity_factor"
            case description
        }
    }

    struct VoiceTrigger: Codable, Equatable {
        /// Seconds; negative is pre-roll.
        let t: Double
        let file: String
        let voice: String?
        let context: String?
        let volume: Double?
    }

    struct OptionalLayers: Codable, Equatable {
        let ol1PinkNoiseFloor: Layer?
        let ol2PreRollResonance: Layer?
        let ol3VoiceGuidance: Layer?

        enum CodingKeys: String, CodingKey {
            case ol1PinkNoiseFloor = "ol1_pink_noise_floor"
            case ol2PreRollResonance = "ol2_pre_roll_resonance"
            case ol3VoiceGuidance = "ol3_voice_guidance"
        }
    }

    struct Layer: Codable, Equatable {
        /// "on" / "off".
        let defaultState: String?
        let note: String?
        let text: String?

        enum CodingKeys: String, CodingKey {
            case defaultState = "default"
            case note, text
        }

        var isOn: Bool { defaultState?.lowercased() == "on" }
    }

    // MARK: §3.22 field_connection

    struct FieldConnection: Codable, Equatable {
        let readsOnLoad: [String]?
        /// The web pools' writes — a list of `{pool, op, kind, fields}`.
        let writesAtFruit: ScoreJSON?
        let legacyDualWrite: Bool?
        let appActivity: AppActivity?

        enum CodingKeys: String, CodingKey {
            case readsOnLoad = "reads_on_load"
            case writesAtFruit = "writes_at_fruit"
            case legacyDualWrite = "legacy_dual_write"
            case appActivity = "app_activity"
        }
    }

    struct AppActivity: Codable, Equatable {
        let sourceApp: String?
        let activityType: String?
        let implemented: Bool?

        enum CodingKeys: String, CodingKey {
            case sourceApp = "source_app"
            case activityType = "activity_type"
            case implemented
        }
    }
}

// MARK: - Values the format allows in two shapes

/// A beat: one value, or a ramp `[from, to]` across its step (score-format
/// §3.15; cross's `"hz": [7.0, 9.0], "ramp": true`).
enum ScoreBeatHz: Codable, Equatable {
    case steady(Double)
    case ramp(from: Double, to: Double)

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let v = try? c.decode(Double.self) {
            self = .steady(v)
            return
        }
        let a = try c.decode([Double].self)
        guard let first = a.first, let last = a.last else {
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "an empty beat")
        }
        self = a.count == 1 ? .steady(first) : .ramp(from: first, to: last)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .steady(let v): try c.encode(v)
        case .ramp(let a, let b): try c.encode([a, b])
        }
    }

    var start: Double {
        switch self {
        case .steady(let v): return v
        case .ramp(let a, _): return a
        }
    }

    var end: Double {
        switch self {
        case .steady(let v): return v
        case .ramp(_, let b): return b
        }
    }
}

/// A moment a Score names: seconds, or a word — `"peak"`, `"peak_t"`,
/// `"return"`, `"phase:<n>"`, `"silence:<n>"`, `"mirror-word"`, `"bell-hit"`
/// (§3.13 `trigger_at`, §3.19 `fires_at`).
enum ScoreTrigger: Codable, Equatable {
    case seconds(Double)
    case named(String)

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let v = try? c.decode(Double.self) {
            self = .seconds(v)
        } else {
            self = .named(try c.decode(String.self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .seconds(let v): try c.encode(v)
        case .named(let s): try c.encode(s)
        }
    }
}
