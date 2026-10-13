import Foundation

// MARK: - U1 · D · the Score player
//
// `sound.md` §1.8 / S62; `the-33-architecture.md` §2 row 61.
//
// *"One clock. It runs from the SONG player's sample time, or a free clock
// when there is no song."* The player owns no audio: Part B's mixer plays the
// song on its SONG bus and hands the player its sample time through
// `ScoreClockSource`; a songless Score (her own dance, S45) runs on
// `FreeScoreClock`. On each frame the player reads the one clock and fires
// every cue the clock has passed, in order, once. A seek re-syncs to the real
// playback position without firing what was skipped ("hit index re-syncs to
// the real playback position"); "animation starts only once currentTime > 0".
//
// *"Only Scores with status Drafted or higher play"* — `ScoreCatalogRow`
// reads that from the Bindu Field row. *"Edit the JSON in Airtable, and the
// next fetch performs differently. No rebuild."* — nothing here caches a Score
// beyond the row it was given.
//
// The controls he asked for (C-1350: play/pause, scrub, binaural on/off, full
// screen) are the dance's view; it calls `play()`, `pause()`, `seek(to:)`.
// The song never follows him into another world: `stop()` on leaving.

/// The SONG bus's playback position, for the one clock (sound.md §1.8 "One
/// clock … the SONG player's sample time"; Part B's mixer conforms in U2).
/// nil while nothing is playing.
protocol ScoreClockSource: AnyObject {
    var scoreTime: TimeInterval? { get }
}

/// The free clock for a Score with no song (S62: "or a free clock for
/// songless Scores"). Pure: the host time is handed in.
struct FreeScoreClock: Equatable {
    private(set) var anchorHost: TimeInterval?
    private(set) var anchorTime: TimeInterval = 0

    var isRunning: Bool { anchorHost != nil }

    mutating func start(at host: TimeInterval) {
        guard anchorHost == nil else { return }
        anchorHost = host
    }

    mutating func pause(at host: TimeInterval) {
        anchorTime = time(at: host)
        anchorHost = nil
    }

    mutating func seek(to t: TimeInterval, at host: TimeInterval) {
        anchorTime = t
        if anchorHost != nil { anchorHost = host }
    }

    func time(at host: TimeInterval) -> TimeInterval {
        guard let a = anchorHost else { return anchorTime }
        return anchorTime + max(0, host - a)
    }
}

/// Plays one validated Score from one clock (S62).
@MainActor
final class ScorePlayer: ObservableObject {

    @Published private(set) var time: TimeInterval = 0
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var phaseName: String?
    @Published private(set) var hasEnded: Bool = false

    let timeline: ScoreTimeline
    /// What the validator warned about (never a refusal).
    let warnings: [ScoreFinding]

    /// The song's clock; when set, it is the one clock.
    weak var songClock: ScoreClockSource?
    /// Every fired cue, in order.
    var onCue: (ScoreCue) -> Void = { _ in }
    /// Haptic cues are played on `HapticLibrary` unless this is off.
    var feelsHaptics: Bool = true

    private var free = FreeScoreClock()
    private var cursor: Int = 0
    private var lastTime: TimeInterval?
    private let host: () -> TimeInterval
    private var loop: Task<Void, Never>?

    /// The frame the player reads its clock at (≈ 30 Hz is enough for cues;
    /// the views draw on their own frame).
    static let frame: Duration = .milliseconds(33)

    init(score: LoadedScore, voiceGuidance: Bool? = nil, audio: ScoreAudioData? = nil,
         host: @escaping () -> TimeInterval = { ProcessInfo.processInfo.systemUptime }) {
        self.timeline = ScoreTimeline(score: score.score, voiceGuidance: voiceGuidance, audio: audio)
        self.warnings = score.warnings
        self.host = host
    }

    /// Validate, then build — or refuse (U1 brief Part D item 3).
    static func load(_ json: String, voiceGuidance: Bool? = nil, audio: ScoreAudioData? = nil) throws -> ScorePlayer {
        ScorePlayer(score: try ScoreLoader.load(json), voiceGuidance: voiceGuidance, audio: audio)
    }

    // MARK: Controls

    func play() {
        guard !isPlaying else { return }
        if songClock == nil { free.start(at: host()) }
        isPlaying = true
        run()
    }

    func pause() {
        guard isPlaying else { return }
        free.pause(at: host())
        isPlaying = false
        loop?.cancel()
        loop = nil
    }

    /// Scrub. Nothing between here and there fires.
    func seek(to t: TimeInterval) {
        let target = min(max(t, 0), timeline.duration)
        free.seek(to: target, at: host())
        resync(to: target)
    }

    /// Leave the dance: the song stops at the world's edge.
    func stop() {
        pause()
        free = FreeScoreClock()
        cursor = 0
        lastTime = nil
        time = 0
        phaseName = nil
        hasEnded = false
    }

    // MARK: The one clock

    /// The clock's reading now: the song's sample time, or the free clock.
    var clockTime: TimeInterval? {
        if let songClock { return songClock.scoreTime }
        return free.time(at: host())
    }

    /// One frame: read the clock, fire what it passed.
    func tick() {
        guard let t = clockTime else { return }
        // With a song, nothing moves until it really plays.
        if songClock != nil, t <= 0 { return }
        advance(to: t)
    }

    /// Fire every cue the clock has passed since the last reading — once, in
    /// order. A reading earlier than the last is a seek: re-sync, fire nothing.
    @discardableResult
    func advance(to t: TimeInterval) -> [ScoreCue] {
        if let last = lastTime, t < last {
            resync(to: t)
            return []
        }
        var fired: [ScoreCue] = []
        let cues = timeline.cues
        while cursor < cues.count, cues[cursor].time <= t {
            fired.append(cues[cursor])
            cursor += 1
        }
        lastTime = t
        publish(t)
        for c in fired { deliver(c) }
        return fired
    }

    private func resync(to t: TimeInterval) {
        cursor = timeline.cues.firstIndex { $0.time > t } ?? timeline.cues.count
        lastTime = t
        hasEnded = t >= timeline.duration
        publish(t)
    }

    private func publish(_ t: TimeInterval) {
        if time != t { time = t }
        let name = timeline.phase(at: t)?.name
        if phaseName != name { phaseName = name }
    }

    private func deliver(_ c: ScoreCue) {
        switch c.kind {
        case .haptic(_, let pattern):
            if feelsHaptics { HapticLibrary.shared.play(pattern) }
        case .ended:
            hasEnded = true
        default:
            break
        }
        onCue(c)
    }

    private func run() {
        guard loop == nil else { return }
        loop = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                self.tick()
                if self.hasEnded {
                    self.isPlaying = false
                    break
                }
                try? await Task.sleep(for: ScorePlayer.frame)
            }
            self?.loop = nil
        }
    }
}

// MARK: - The Bindu Field catalog row (where Scores come from)

/// A Score's status on its catalog row (score-format-v2 §7: Unscored ·
/// Drafted · Verified).
enum ScoreStatus: String, Equatable {
    case unscored = "Unscored"
    case drafted = "Drafted"
    case verified = "Verified"

    /// "Only Scores with status Drafted or higher play" (sound.md §1.8).
    var plays: Bool { self != .unscored }
}

/// One Bindu Field row, as the player needs it (sound.md §4 data contract;
/// score-format-v2 §7).
struct ScoreCatalogRow: Equatable {
    let recordId: String
    let verb: String?
    let status: ScoreStatus
    let scoreJSON: String?
    let audioURL: String?
    let carrierHz: Double?
    let trackId: Double?

    var isPlayable: Bool { status.plays && !(scoreJSON ?? "").isEmpty }
}

/// The Bindu Field table (`app248ZTWhYJlvQj2` / `tblv3WvMZ90Sfhun6`) as the
/// Score player reads it (sound.md §4; score-format-v2 §7).
enum ScoreCatalog {

    static let base = "app248ZTWhYJlvQj2"
    static let table = "tblv3WvMZ90Sfhun6"

    /// Field ids (sound.md §4, verified against the 13 Oct snapshot's
    /// `fieldNames`) and the names the API uses without
    /// `returnFieldsByFieldId`.
    enum Field {
        static let scoreJSON = ("fldxIm6qUXLcdrRuR", "Score JSON")
        static let status = ("fldOSMHwD7IxshwO7", "Score Status")
        static let audioURL = ("fldUIY8v9p49QyF0B", "Audio URL")
        static let carrierHz = ("fld4oIQGckv2c9DvO", "Carrier Hz")
        static let verb = ("fldrYExLmEjx4wxVt", "Verb")
        static let trackId = ("fldimw5ZGOBg0j738", "Track ID")
    }

    /// The rows of an API page (`{"records": [{"id", "fields"}]}`), keyed by
    /// field id or by name; a select may be its name or `{id, name, color}`.
    static func rows(fromPage data: Data) throws -> [ScoreCatalogRow] {
        let page = try ScoreJSON.parse(data)
        return (page["records"]?.array ?? []).compactMap(row)
    }

    static func row(_ r: ScoreJSON) -> ScoreCatalogRow? {
        guard let id = r["id"]?.string, let f = r["fields"] else { return nil }
        func cell(_ key: (String, String)) -> ScoreJSON? { f[key.0] ?? f[key.1] }
        let statusName = cell(Field.status).flatMap { $0.string ?? $0["name"]?.string }
        return ScoreCatalogRow(recordId: id,
                               verb: cell(Field.verb)?.string,
                               status: statusName.flatMap(ScoreStatus.init(rawValue:)) ?? .unscored,
                               scoreJSON: cell(Field.scoreJSON)?.string,
                               audioURL: cell(Field.audioURL)?.string,
                               carrierHz: cell(Field.carrierHz)?.double,
                               trackId: cell(Field.trackId)?.double)
    }
}
