import Foundation

// MARK: - U1 · D · a Score, laid on one clock
//
// `sound.md` §1.8 and S62; `the-33-architecture.md` §2 rows 61–70;
// `score-format-v2.md` §3.
//
// *"One time-coded engine runs every track of a dance from one clock
// (elapsed): phases, silence windows, beat schedule, gain law, mirror words,
// word reveal, haptics, return, ledger writes."* This file is the pure half:
// it turns a validated `ScoreV2` into
//
//   • **cues** — moments, in time order, each on one lane (sound, light,
//     motion, words, haptics, ledger), fired by `ScorePlayer` as the clock
//     passes them; and
//   • **laws** — the continuous values a frame reads at any `t` (the beat with
//     its ramps and Karishma's freeze, the binaural gain law, the song's gain,
//     the climax's global boost, whether the Return has begun).
//
// Nothing here draws or sounds. The vocabulary modules (Layer 3) and the
// mixer (Part B's SONG and BINAURAL buses) read these.
//
// The floors: nothing invented — every word and number comes from the Score;
// nothing scores him — a fruit weave that counts his dances ("You have crossed
// {n} times now.") is dropped (sound.md S56: "count lines … dropped — nothing
// counts him"); no generated voice — the only voice cues are his recordings
// named by the Score, and only with OL-3 on.

/// The lanes a cue drives (U1 brief Part D item 3).
enum ScoreLane: String, CaseIterable {
    case sound, light, motion, words, haptics, ledger
}

/// A ledger write the Score asks for. The event is named here by meaning; the
/// ledger's own vocabulary (`ActivityLedger`) names it in Airtable's words
/// when U7 wires the dance (data.md §2 D07 / §4.3: a dance reaches its return
/// → its App Activity row, linked to the room and the track).
struct ScoreLedgerWrite: Equatable {
    enum Event: Equatable {
        /// "a dance reaches its return" (data.md §4.3).
        case danceCompleted
    }
    let event: Event
    let scoreId: String
    /// The Bindu Field catalog row (`identity.airtable_record_id`).
    let trackRecordId: String?
    /// `identity.chakra`, for the room link.
    let chakra: String?
    /// The song's length, for the ledger's Duration.
    let durationSeconds: TimeInterval
    /// What the Score itself declares for the web build (§3.22 `app_activity`),
    /// carried as data so U7 can see both.
    let declaredSourceApp: String?
    let declaredActivityType: String?
}

/// One time-coded moment of a Score (sound.md S62; the-33 §2 rows 61–70).
struct ScoreCue: Equatable {
    /// Seconds on the Score's clock (negative = pre-roll).
    let time: TimeInterval
    let kind: Kind

    enum Kind: Equatable {
        /// A phase begins: its name surfaces in Cinzel (in .6 s, held 1.8 s,
        /// out 1 s; the-33 row 69).
        case phase(index: Int, name: String)
        /// A silence window begins or ends — Karishma's domain.
        case silence(index: Int, role: String?, began: Bool)
        /// The binaural beat steps (or begins a ramp toward `rampTo`).
        case beat(hz: Double, rampTo: Double?, state: String?, designed: Bool)
        /// A mirror word fires (the screen darkens, the word uppercase 1.8 s).
        case mirror(index: Int, seconds: TimeInterval)
        /// His word is revealed at the peak.
        case wordReveal(position: String?)
        /// "I Love You" at the Score's own offset from the peak.
        case iLoveYou
        /// A haptic pattern from the Score (or a hit / drop from the song).
        case haptic(name: String, pattern: HapticPattern)
        /// One of his recordings named by the Score (OL-3 only).
        case voice(file: String, volume: Double)
        /// Tier 0 — the threshold marker ("the ground is here").
        case threshold(began: Bool)
        /// Tier 4 — the climax window.
        case climax(began: Bool)
        /// A shape of Bindu's path begins (the blend law, §3.11).
        case shape(type: String, duration: TimeInterval?, maxBlend: Double?)
        /// The Return: the ensemble dissolves in this order.
        case returnBegan(order: [String])
        /// A ledger write.
        case ledger(ScoreLedgerWrite)
        /// The song's end — the fruit follows.
        case ended
    }

    var lane: ScoreLane {
        switch kind {
        case .beat, .voice: return .sound
        case .threshold, .climax, .mirror, .silence: return .light
        case .shape, .returnBegan: return .motion
        case .phase, .wordReveal, .iLoveYou, .ended: return .words
        case .haptic: return .haptics
        case .ledger: return .ledger
        }
    }
}

/// A validated Score on one clock (S62).
struct ScoreTimeline {

    let score: ScoreV2
    /// The song's length (identity.song.duration_seconds).
    let duration: TimeInterval
    /// The authored peak (config.peak_t).
    let peak: TimeInterval
    /// When the Return begins.
    let returnStart: TimeInterval
    /// Every cue, in time order (ties keep the order they were composed in).
    let cues: [ScoreCue]

    /// The Return's length when a Score leaves it open: twenty seconds — the
    /// span the Return's caps are written over (the-33 row 67: "ashrey ≤
    /// rT/20 … gaia ≤ (rT−8)/4", rT counting down from 20).
    static let defaultReturnLead: TimeInterval = 20
    /// The threshold marker when a Score has no tiers: the first 2 s and the
    /// last 1 s (the-33 row 63: "T0 threshold marker … first 2 s, last 1 s").
    static let defaultThresholdHead: TimeInterval = 2
    static let defaultThresholdTail: TimeInterval = 1
    /// The SONG bus: 0.8, faded in over 3 s (sound.md §1.2).
    static let songGain: Double = 0.8
    static let songFadeIn: TimeInterval = 3
    /// The binaural bus's band (sound.md §1.2: "Binaural stays between 0.003
    /// and 0.050").
    static let binauralFloor: Double = 0.003
    static let binauralCeiling: Double = 0.050
    /// Karishma's gain law (the-33 row 68): .045 + .015 sin(.18 t) +
    /// .025 (1 − E).
    static let karishmaBase: Double = 0.045
    static let karishmaSway: Double = 0.015
    static let karishmaSwayRate: Double = 0.18
    static let inverseDepth: Double = 0.025
    /// A song's onsets felt above this (the-33 row 70: "i·20 ms when i > .4").
    static let hitFeltAbove: Double = 0.4

    /// - Parameters:
    ///   - voiceGuidance: OL-3. nil = the Score's own default (off unless it
    ///     says on).
    ///   - audio: the song's frame data, when it has been fetched — adds the
    ///     hit and drop haptics and the bell hits.
    init(score: ScoreV2, voiceGuidance: Bool? = nil, audio: ScoreAudioData? = nil) {
        self.score = score
        let b = score.score
        let phaseEnd = b.phases.map(\.end).max() ?? 0
        let dur = b.identity.song?.durationSeconds ?? phaseEnd
        duration = dur
        peak = b.config.peakT
        let lead = b.returnPlan.startsSecondsBeforeEnd ?? b.config.returnStart ?? Self.defaultReturnLead
        let rs = max(0, dur - lead)
        returnStart = rs

        var out: [ScoreCue] = []
        func add(_ t: TimeInterval?, _ k: ScoreCue.Kind) {
            guard let t else { return }
            out.append(ScoreCue(time: t, kind: k))
        }
        let resolve: (ScoreTrigger?) -> TimeInterval? = { trigger in
            Self.resolve(trigger, peak: b.config.peakT, returnStart: rs, duration: dur,
                         phases: b.phases, silences: b.silenceWindows)
        }

        // Words: the phases.
        for (i, p) in b.phases.enumerated() { add(p.start, .phase(index: i, name: p.name)) }

        // Light: the silences.
        for (i, w) in b.silenceWindows.enumerated() {
            add(w.start, .silence(index: i, role: w.role, began: true))
            add(w.end, .silence(index: i, role: w.role, began: false))
        }

        // Sound: the beat schedule.
        var segStart: TimeInterval = 0
        for step in b.binaural.beatSchedule {
            let rampTo: Double? = {
                if case .ramp(_, let to) = step.hz { return to }
                return nil
            }()
            add(segStart, .beat(hz: step.hz.start, rampTo: rampTo, state: step.state, designed: step.designed ?? false))
            if let u = step.until { segStart = u }
        }

        // Light + words: the mirror words.
        let mirrorTimes = b.mirrorSystem?.times ?? []
        let perWord = b.mirrorSystem?.durationPerWord ?? 1.8
        for (i, t) in mirrorTimes.enumerated() { add(t, .mirror(index: i, seconds: perWord)) }

        // Words: his word at the peak, and "I Love You".
        let reveal = b.consciousnessLoop.wordReveal
        add(resolve(.named(reveal?.at ?? "peak_t")), .wordReveal(position: reveal?.position))
        if let ily = reveal?.iLoveYouAt { add(resolve(.named(ily)), .iLoveYou) }

        // Haptics: the Score's own patterns.
        for (name, spec) in (b.haptics?.patterns ?? [:]).sorted(by: { $0.key < $1.key }) {
            let pattern = HapticPattern.vibration(name, ms: spec.patternMs ?? [])
            guard !pattern.events.isEmpty else { continue }
            switch spec.firesAt {
            case .named(let s) where Self.normalised(s) == "mirror-word":
                for t in mirrorTimes { add(t, .haptic(name: name, pattern: pattern)) }
            case .named(let s) where Self.normalised(s) == "bell-hit":
                guard let audio else { continue }
                let criteria = b.haptics?.bellCriteria
                let after = criteria?["after_t"]?.double ?? 0
                let threshold = criteria?["hit_threshold"]?.double ?? Self.hitFeltAbove
                for h in audio.hits where h.t >= after && h.i >= threshold {
                    add(h.t, .haptic(name: name, pattern: pattern.scaled(h.i)))
                }
            default:
                add(resolve(spec.firesAt), .haptic(name: name, pattern: pattern))
            }
        }

        // Haptics: the song's own hits and drops, when its data is here.
        if let audio {
            for h in audio.hits {
                if let p = HapticPattern.hit(intensity: h.i) { add(h.t, .haptic(name: "hit", pattern: p)) }
            }
            for d in audio.drops { add(d, .haptic(name: "drop", pattern: .drop)) }
        }

        // Sound: his recordings named by the Score, only with OL-3 on.
        let ol3 = voiceGuidance ?? (b.optionalLayers?.ol3VoiceGuidance?.isOn ?? false)
        if ol3 {
            for v in b.voiceTriggers ?? [] { add(v.t, .voice(file: v.file, volume: v.volume ?? 0.55)) }
        }

        // Light: Tier 0 and Tier 4.
        for w in Self.thresholdWindows(tiers: b.tiers, duration: dur) {
            add(w.lowerBound, .threshold(began: true))
            add(w.upperBound, .threshold(began: false))
        }
        if let w = b.tiers?.at("t4_climax", "window")?.array, w.count == 2,
           let a = w[0].double, let z = w[1].double {
            add(a, .climax(began: true))
            add(z, .climax(began: false))
        }

        // Motion: Bindu's shapes and the Return.
        for s in b.shapeChoreography ?? [] {
            add(resolve(s.triggerAt), .shape(type: s.type, duration: s.duration, maxBlend: s.maxBlend))
        }
        var order: [String] = ["ashrey", "sakshi", "karishma", "arch", "sid", "gaia", "bindu"]
        if let d = b.returnPlan.dissolutionOrder {
            order = d
        } else if let g = b.ensemble?.generationOrder {
            order = Array(g.reversed())
        }
        add(rs, .returnBegan(order: order))

        // Ledger: the dance reaches its return.
        add(rs, .ledger(ScoreLedgerWrite(
            event: .danceCompleted,
            scoreId: b.identity.id,
            trackRecordId: b.identity.airtableRecordId,
            chakra: b.identity.chakra,
            durationSeconds: dur,
            declaredSourceApp: b.fieldConnection.appActivity?.sourceApp,
            declaredActivityType: b.fieldConnection.appActivity?.activityType)))

        add(dur, .ended)

        cues = out.enumerated()
            .sorted { $0.element.time != $1.element.time ? $0.element.time < $1.element.time : $0.offset < $1.offset }
            .map(\.element)
    }

    // MARK: Moments a Score names

    static func normalised(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespaces).lowercased().replacingOccurrences(of: "_", with: "-")
    }

    /// A trigger in seconds. Words: `peak` / `peak_t`, `return`, `end`,
    /// `start`, `phase:<name or index>`, `silence:<index>`, a number as text,
    /// or any of `peak_t` / `end` / `return` ± seconds (`"peak_t - 3"`,
    /// `"end-1"`). Indices count from 0. nil when the Score names something
    /// the clock cannot place (`bell-hit` without the song's data).
    static func resolve(_ trigger: ScoreTrigger?, peak: TimeInterval, returnStart: TimeInterval,
                        duration: TimeInterval, phases: [ScoreV2.Phase],
                        silences: [ScoreV2.SilenceWindow]) -> TimeInterval? {
        guard let trigger else { return nil }
        switch trigger {
        case .seconds(let t):
            return t
        case .named(let raw):
            let s = raw.trimmingCharacters(in: .whitespaces)
            if let v = Double(s) { return v }
            let lower = s.lowercased()
            if lower.hasPrefix("phase:") {
                let key = String(s.dropFirst("phase:".count)).trimmingCharacters(in: .whitespaces)
                if let p = phases.first(where: { $0.name.lowercased() == key.lowercased() }) { return p.start }
                if let i = Int(key), phases.indices.contains(i) { return phases[i].start }
                return nil
            }
            if lower.hasPrefix("silence:") {
                let key = String(s.dropFirst("silence:".count)).trimmingCharacters(in: .whitespaces)
                if let i = Int(key), silences.indices.contains(i) { return silences[i].start }
                return nil
            }
            return expression(lower, peak: peak, returnStart: returnStart, duration: duration)
        }
    }

    /// `base`, or `base ± n`, for base in peak / peak_t / return / end / start.
    static func expression(_ s: String, peak: TimeInterval, returnStart: TimeInterval,
                           duration: TimeInterval) -> TimeInterval? {
        let bases: [(String, TimeInterval)] = [("peak_t", peak), ("peak", peak), ("return", returnStart),
                                               ("end", duration), ("start", 0)]
        let compact = s.replacingOccurrences(of: " ", with: "")
        for (name, value) in bases where compact.hasPrefix(name) {
            let rest = compact.dropFirst(name.count)
            if rest.isEmpty { return value }
            guard let sign = rest.first, sign == "+" || sign == "-",
                  let n = Double(rest.dropFirst()) else { return nil }
            return sign == "+" ? value + n : value - n
        }
        return nil
    }

    /// Tier 0's windows: the Score's own (`[[0, 2], ["end-1", "end"]]`), or the
    /// substrate's default.
    static func thresholdWindows(tiers: ScoreJSON?, duration: TimeInterval) -> [ClosedRange<TimeInterval>] {
        func bound(_ v: ScoreJSON) -> TimeInterval? {
            if let d = v.double { return d }
            if let s = v.string { return expression(s.lowercased(), peak: 0, returnStart: 0, duration: duration) }
            return nil
        }
        if let ws = tiers?.at("t0_threshold_marker", "windows")?.array {
            return ws.compactMap { w in
                guard let pair = w.array, pair.count == 2,
                      let a = bound(pair[0]), let z = bound(pair[1]), a <= z else { return nil }
                return a...z
            }
        }
        let tailStart = max(0, duration - defaultThresholdTail)
        return [0...min(defaultThresholdHead, duration), tailStart...duration]
    }

    // MARK: The laws a frame reads

    /// The phase at `t` (its end belongs to it only for the last phase).
    func phaseIndex(at t: TimeInterval) -> Int? {
        let ps = score.score.phases
        for (i, p) in ps.enumerated() {
            if t >= p.start && (t < p.end || (i == ps.count - 1 && t <= p.end)) { return i }
        }
        return nil
    }

    func phase(at t: TimeInterval) -> ScoreV2.Phase? {
        phaseIndex(at: t).map { score.score.phases[$0] }
    }

    /// The silence window at `t`, if any.
    func silence(at t: TimeInterval) -> ScoreV2.SilenceWindow? {
        score.score.silenceWindows.first { t >= $0.start && t <= $0.end }
    }

    /// Whether the beat freezes in a silence (Karishma: "The beat holds its
    /// last value. The binaural pauses with the song."). Freezing is the law
    /// (the-33 row 68: "beat freezes inside Karishma windows"); a Score may
    /// name another behaviour.
    var beatFreezesInSilence: Bool {
        guard let o = score.score.binaural.karishmaOverride else { return true }
        let applies = o.appliesTo.map { $0.contains("silence_windows") } ?? true
        return applies && (o.behavior ?? "freeze") == "freeze"
    }

    /// The scheduled beat at `t`, ramps included, before Karishma.
    func scheduledBeat(at t: TimeInterval) -> Double? {
        var segStart: TimeInterval = 0
        for step in score.score.binaural.beatSchedule {
            let end = step.until ?? .infinity
            if t < end || step.until == nil {
                switch step.hz {
                case .steady(let v):
                    return v
                case .ramp(let a, let z):
                    guard end.isFinite, end > segStart else { return z }
                    let k = min(1, max(0, (t - segStart) / (end - segStart)))
                    return a + (z - a) * k
                }
            }
            segStart = step.until ?? segStart
        }
        return score.score.binaural.beatSchedule.last?.hz.end
    }

    /// The beat at `t`: frozen at its value when the silence began.
    func beat(at t: TimeInterval) -> Double? {
        if beatFreezesInSilence, let w = silence(at: t) { return scheduledBeat(at: w.start) }
        return scheduledBeat(at: t)
    }

    /// The Score's phase multiplier at `t`: the first window that holds it, in
    /// the Score's own order (cross lists the narrowest first).
    func phaseMultiplier(at t: TimeInterval) -> Double {
        for m in score.score.binaural.gain?.phaseMultipliers ?? [] where m.window.count == 2 {
            if t >= m.window[0] && t <= m.window[1] { return m.x }
        }
        return 1
    }

    /// The binaural's gain at `t` for the song's energy `energy` (0…1):
    /// Karishma's inverse law × the phase multiplier × the final ramp, inside
    /// the binaural band. Silent outside the song.
    func binauralGain(at t: TimeInterval, energy: Double) -> Double {
        guard t >= 0, t <= duration else { return 0 }
        let e = min(1, max(0, energy))
        var g = Self.karishmaBase + Self.karishmaSway * sin(Self.karishmaSwayRate * t)
        if (score.score.binaural.gain?.law ?? "inverse") == "inverse" { g += Self.inverseDepth * (1 - e) }
        g *= phaseMultiplier(at: t)
        if let f = score.score.binaural.gain?.finalRampSeconds, f > 0 {
            g *= min(1, max(0, (duration - t) / f))
        }
        if g <= 0 { return 0 }
        return min(Self.binauralCeiling, max(Self.binauralFloor, g))
    }

    /// The SONG bus's gain at `t`.
    func songGain(at t: TimeInterval) -> Double {
        guard t >= 0, t <= duration else { return 0 }
        return Self.songGain * min(1, t / Self.songFadeIn)
    }

    /// Tier 4's global boost at `t`: 1 + factor × (ramp in, hold, ramp out).
    func globalBoost(at t: TimeInterval) -> Double {
        guard let gb = score.score.tiers?.at("t4_climax", "roles", "global_boost")
                ?? score.score.tiers?.at("t4_climax", "global_boost"),
              let factor = gb["factor"]?.double else { return 1 }
        func pair(_ k: String) -> (Double, Double)? {
            guard let a = gb[k]?.array, a.count == 2, let x = a[0].double, let y = a[1].double else { return nil }
            return (x, y)
        }
        var w = 0.0
        if let r = pair("ramp_in"), t >= r.0, t < r.1, r.1 > r.0 { w = (t - r.0) / (r.1 - r.0) }
        if let h = pair("hold"), t >= h.0, t <= h.1 { w = 1 }
        if let r = pair("ramp_out"), t > r.0, t <= r.1, r.1 > r.0 { w = 1 - (t - r.0) / (r.1 - r.0) }
        return 1 + factor * w
    }

    /// Whether the Return has begun.
    func isReturning(at t: TimeInterval) -> Bool { t >= returnStart }

    /// Whether Tier 0's threshold marker is up.
    func isThreshold(at t: TimeInterval) -> Bool {
        Self.thresholdWindows(tiers: score.score.tiers, duration: duration).contains { $0.contains(t) }
    }

    // MARK: Words

    /// The seed types itself at the song's beat: the Score's own ms per
    /// character, else one character per beat (Svadhisthana 857 ms at 70 BPM;
    /// cross 557 at 107.7 — sound.md S56).
    var seedSecondsPerCharacter: TimeInterval? {
        let seed = score.score.consciousnessLoop.seed
        if let ms = seed?.msPerCharacter, ms > 0 { return ms / 1000 }
        guard seed?.typesAtBpm ?? false, let bpm = score.score.config.bpm, bpm > 0 else { return nil }
        return 60 / bpm
    }

    /// The fruit's weaves that may be said: every weave that counts his dances
    /// is dropped (sound.md S56 "nothing counts him").
    var fruitWeaves: [ScoreV2.Weave] {
        (score.score.consciousnessLoop.fruit?.weaves ?? []).filter { !Self.countsHim($0) }
    }

    /// A weave that counts: conditioned on how many times before, or saying
    /// `{n}`.
    static func countsHim(_ w: ScoreV2.Weave) -> Bool {
        let c = w.condition.lowercased()
        return c.contains("prior_") || c.contains("count") || c.contains("times")
            || w.text.contains("{n}")
    }
}

// MARK: - The song's frame data (§3.26)

/// `extract.py`'s output beside the mp3: streams at 0.5 s frames, the onset
/// hits and the drops (score-format-v2 §3.26; the-33 row 61 "H E B P T EB EM
/// EH ED DROPS at 0.5 s frames"). Read leniently — a hit may be `{t, i}` or
/// `[t, i]`, a drop `{t}` or a number.
struct ScoreAudioData: Equatable {
    struct Hit: Equatable {
        let t: TimeInterval
        let i: Double
    }

    let frameInterval: TimeInterval
    /// E, B, P, T, EB, EM, EH, ED.
    let streams: [String: [Double]]
    let hits: [Hit]
    let drops: [TimeInterval]

    static let streamKeys = ["E", "B", "P", "T", "EB", "EM", "EH", "ED"]

    init(frameInterval: TimeInterval = 0.5, streams: [String: [Double]], hits: [Hit], drops: [TimeInterval]) {
        self.frameInterval = frameInterval
        self.streams = streams
        self.hits = hits
        self.drops = drops
    }

    static func parse(_ data: Data) throws -> ScoreAudioData {
        let j = try ScoreJSON.parse(data)
        var streams: [String: [Double]] = [:]
        for k in streamKeys {
            if let a = j[k]?.array { streams[k] = a.compactMap(\.double) }
        }
        let hits: [Hit] = (j["H"]?.array ?? []).compactMap { h in
            if let t = h["t"]?.double, let i = h["i"]?.double { return Hit(t: t, i: i) }
            if let a = h.array, a.count >= 2, let t = a[0].double, let i = a[1].double { return Hit(t: t, i: i) }
            return nil
        }
        let drops: [TimeInterval] = (j["DROPS"]?.array ?? []).compactMap { d in d.double ?? d["t"]?.double }
        let frame = j.at("meta", "frame_interval")?.double ?? 0.5
        return ScoreAudioData(frameInterval: frame, streams: streams, hits: hits, drops: drops)
    }

    /// `SC(arr, t)`: the stream at `t`, linearly interpolated between frames.
    func sample(_ key: String, at t: TimeInterval) -> Double? {
        guard let a = streams[key] else { return nil }
        return Self.interpolate(a, at: t, frame: frameInterval)
    }

    static func interpolate(_ a: [Double], at t: TimeInterval, frame: TimeInterval) -> Double {
        guard let first = a.first, let last = a.last, frame > 0 else { return 0 }
        let x = t / frame
        if x <= 0 { return first }
        let i = Int(x)
        if i >= a.count - 1 { return last }
        let k = x - Double(i)
        return a[i] + (a[i + 1] - a[i]) * k
    }
}
