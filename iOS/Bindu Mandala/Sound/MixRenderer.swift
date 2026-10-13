import Foundation

// MARK: - Upgrade U1 · B · the mixer's voice, as pure render code
//
// `waves/upgrade/worlds/sound.md` §1.2–1.6: the synthesised buses — FLOOR (the
// Om stack + pink noise), WORLD (the world's bed, crossfading), HER/ROOM (a
// room's fixed tone or her carrier held), BINAURAL (true L/R or a pulse) and
// ACCENT (bells, threshold tones, struck tones) — summed, never muted, under
// one master and a hard ceiling at −1 dBFS. SONG is an `AVAudioPlayerNode`
// beside this in `SoundMixer`; HAPTIC is Part D's.
//
// No engine here: `SoundMixer` runs this inside an `AVAudioSourceNode`, and the
// tests run it offline (`render(frames:)`) and measure what comes out.
//
// Threading: the main actor only ever *posts* `MixCommand`s; the render thread
// takes them at the top of a block (`NSLock.try()`, never waiting) and owns
// every other field. Tests post and render on one thread.

/// A world bed reduced to what the renderer sounds — built from `WorldBed` (`sound.md` §1.5, S22, S28).
struct BedSpec: Equatable {
    enum Source: Equatable {
        /// Partials in Hz (detune applied by the renderer).
        case partials([VoicePartial], fundamental: Double)
        /// Ring `ring`'s Design ground (`HomeCarrier.ground(forRing:)`).
        case ringGround(ring: Int)
    }

    let source: Source
    /// Base lowpass cutoff (Hz) the world breath sweeps; nil = unfiltered.
    let lowpass: Double?
    /// The bed's level.
    let level: Double

    /// The bed a `WorldBed` sounds on the WORLD bus in ring `ring`, or nil
    /// (no bed; pink noise rides FLOOR; a Score's recording rides SONG).
    static func make(_ bed: WorldBed, ring: Int = 1) -> BedSpec? {
        switch bed {
        case .none, .pinkNoise, .score:
            return nil
        case let .partials(fundamental, partials, lowpass, _):
            return BedSpec(source: .partials(partials, fundamental: fundamental),
                           lowpass: lowpass, level: WorldVoices.bedLevel)
        case .ringGround(let rule):
            let r = max(1, min(9, ring))
            return BedSpec(source: .ringGround(ring: r), lowpass: WorldVoices.ringGroundLowpass,
                           level: rule.level(ring: r) * WorldVoices.ringGroundMaster)
        }
    }
}

/// What sounds on the HER / ROOM bus — `sound.md` §1.2, §1.7, S47.
struct HerSpec: Equatable {
    var hz: Double
    var gain: Double
    /// The mind rooms: the fifth (× 1.5) breathing 0 → gain over this period.
    var fifthBreathPeriod: Double? = nil
    /// Armin: the gain moves linearly to this over `rampSeconds`.
    var rampTo: Double? = nil
    var rampSeconds: Double = 0

    /// A 33 room's practice drone on its fixed tone (S48), or nil for a room
    /// whose sound is silence, the Om, or sealed.
    static func room(_ tone: RoomTone) -> HerSpec? {
        guard let hz = tone.hz else { return nil }
        switch tone.kind {
        case .tone:
            return HerSpec(hz: hz, gain: RoomTones.practiceGain)
        case .mindRoom:
            return HerSpec(hz: hz, gain: RoomTones.practiceGain, fifthBreathPeriod: RoomTones.mindRoomBreath)
        case .drone:
            return HerSpec(hz: hz, gain: RoomTones.arminGains.from,
                           rampTo: RoomTones.arminGains.to, rampSeconds: RoomTones.arminSeconds)
        case .om, .silence, .sealed:
            return nil
        }
    }

    /// Her carrier held at `amount` (Her Presence: .3 → gain .03, S47).
    static func carrier(_ hz: Double, amount: Double) -> HerSpec {
        HerSpec(hz: hz, gain: max(0, min(1, amount)) * HomeCarrier.carrierLevel)
    }
}

/// The binaural's carrier, beat and gain (S57); its rendering from `MixLaw`.
struct BinauralSpec: Equatable {
    var carrier: Double
    var beat: Double
    var gain: Double
    var rendering: MixLaw.BinauralRendering
}

/// A struck sound on the ACCENT bus — `sound.md` S09, S26, S27.
enum SoundAccent: Equatable {
    /// The enclosure bell, inward crossings only (Design's `lrRingChime`).
    case bell(ring: Int)
    /// The ring's bīja falling after its bell (180 ms later).
    case fallingMantra(ring: Int, vowel: Tuning.MantraVowel)
    /// A world's threshold tone (or the menu's hum at 0.010).
    case threshold(hz: Double, peak: Double)
    /// A plain struck tone: 12 ms attack, exponential decay.
    case tone(hz: Double, seconds: Double, peak: Double)
}

/// A message from the main actor to the render thread — one per mixer move of `sound.md` §1.2–1.3.
enum MixCommand {
    case master(Double)
    case om(level: Double, tau: Double)
    case pinkNoise(Double)
    case bed(BedSpec?)
    case her(HerSpec?)
    case binaural(BinauralSpec?)
    case accent(SoundAccent)
    case scene(Set<SoundBus>)
    case layers([SoundBus: Double])
}

// MARK: - Render-owned voices

private enum Wave {
    static func value(_ shape: HomeWave, _ phase: Double, _ increment: Double) -> Double {
        switch shape {
        case .sine:
            return sin(phase * 2 * .pi)
        case .triangle:
            return 4 * abs(phase - 0.5) - 1
        case .saw:
            var v = 2 * phase - 1
            if phase < increment {
                let t = phase / increment
                v -= t + t - t * t - 1
            } else if phase > 1 - increment {
                let t = (phase - 1) / increment
                v -= t * t + t + t + 1
            }
            return v
        }
    }
}

private struct BedPartial {
    var wave: HomeWave
    var freq: Double
    var gain: Double
    var phase: Double = 0
}

/// One bed, alive while it sounds or fades.
private final class BedVoice {
    let spec: BedSpec
    var partials: [BedPartial] = []
    var ground: HomeGround?
    var filter = HomeBiquad()
    /// Seconds since it began.
    var age: Double = 0
    /// Seconds since it began to leave, or nil while it stays.
    var leaving: Double?
    let rise: Double
    // Rings 4, 5 step; ring 8 collapses.
    var stepTimer: Double = 0
    var triadTimer: Double = 0

    init(spec: BedSpec, sampleRate: Double, rise: Double, seed: inout UInt64) {
        self.spec = spec
        self.rise = rise
        switch spec.source {
        case let .partials(list, fundamental):
            partials = list.map { p in
                // ±2 cents of random detune per partial.
                seed = seed &* 6364136223846793005 &+ 1442695040888963407
                let unit = Double(seed >> 11) / Double(UInt64(1) << 53)
                let cents = (unit * 2 - 1) * WorldVoices.detuneCents
                return BedPartial(wave: p.wave, freq: fundamental * p.ratio * HomeCarrier.cents(cents), gain: p.gain)
            }
        case .ringGround(let ring):
            ground = BedVoice.makeGround(ring: ring, sampleRate: sampleRate)
        }
        if let lp = spec.lowpass {
            filter.setLowpass(frequency: lp, q: WorldVoices.lowpassQ, sampleRate: sampleRate)
        }
    }

    /// HomeSoundService's own ground for a ring (its `makeGrounds`, one ring).
    static func makeGround(ring: Int, sampleRate: Double) -> HomeGround {
        let hz = Tuning.root(ring: ring)
        let spec = HomeCarrier.ground(forRing: ring)
        let g = HomeGround()
        g.amRate = spec.amRate
        g.amDepth = spec.amDepth
        g.target = 1
        g.current = 1
        if let band = spec.band {
            var f = HomeBiquad()
            f.setBandpass(frequency: hz * band.multiple, q: band.q, sampleRate: sampleRate)
            g.band = f
        }
        for partial in spec.partials {
            var p = HomePartial()
            p.wave = partial.wave
            p.freq = hz * partial.multiple
            p.gain = partial.gain
            p.throughBand = partial.throughBand
            p.lfoRate = partial.lfoRate
            p.lfoDepth = partial.lfoDepth
            p.freqCoef = partial.glideTau > 0 ? 1 - exp(-1.0 / (partial.glideTau * sampleRate)) : 1
            g.partials.append(p)
            g.targetFreqs.append(p.freq)
        }
        let technique = HomeCarrier.technique(forRing: ring)
        if technique == .stepped { g.stepBase = hz }
        if technique == .triad { g.triadBase = hz }
        return g
    }

    /// The crossfade gain now (equal power in, equal power out).
    var fade: Double {
        let inGain = WorldVoices.equalPower(t: age, duration: rise).incoming
        guard let leaving else { return inGain }
        return inGain * WorldVoices.equalPower(t: leaving).out
    }

    var finished: Bool { (leaving ?? 0) >= WorldVoices.outgoingStop }

    func tick(dt: Double) {
        age += dt
        if leaving != nil { leaving! += dt }
        guard let g = ground, case .ringGround(let ring) = spec.source else { return }
        switch HomeCarrier.technique(forRing: ring) {
        case .stepped where !g.targetFreqs.isEmpty:
            stepTimer += dt
            if stepTimer >= HomeCarrier.stepPeriod(forRing: ring) {
                stepTimer = 0
                g.stepIndex = (g.stepIndex + 1) % HomeCarrier.steps.count
                g.targetFreqs[0] = g.stepBase * HomeCarrier.steps[g.stepIndex]
            }
        case .triad where g.targetFreqs.count >= 3:
            triadTimer += dt
            if triadTimer >= HomeCarrier.triadPeriod {
                triadTimer = 0
                g.triadCollapsed.toggle()
                let open = HomeCarrier.ground(forRing: 8).partials
                g.targetFreqs[1] = g.triadCollapsed ? g.triadBase : g.triadBase * open[1].multiple
                g.targetFreqs[2] = g.triadCollapsed ? g.triadBase : g.triadBase * open[2].multiple
            }
        default:
            break
        }
    }

    func sample(sampleRate sr: Double) -> Double {
        var x = 0.0
        if let g = ground {
            x = g.render(sampleRate: sr)
        } else {
            for k in partials.indices {
                var p = partials[k]
                let inc = p.freq / sr
                p.phase += inc
                if p.phase >= 1 { p.phase -= 1 }
                x += Wave.value(p.wave, p.phase, inc) * p.gain
                partials[k] = p
            }
        }
        if spec.lowpass != nil { x = filter.process(x) }
        return x * spec.level * fade
    }
}

/// One struck sound in the pool. Scalars only: a struct holding arrays would
/// copy on every sample.
private struct AccentVoice {
    enum Kind { case bell, threshold, tone }
    var active = false
    var kind: Kind = .tone
    var freq: Double = 0
    var peak: Double = 0
    var duration: Double = 0
    /// Negative while waiting to begin (a mantra's 180 ms).
    var age: Double = 0
    var p0 = 0.0, p1 = 0.0, p2 = 0.0, p3 = 0.0
    var filter = HomeBiquad()
}

// MARK: - The renderer

/// The synthesised buses of `sound.md` §1.2, summed under one master and a
/// hard ceiling at −1 dBFS (S04). Render-thread owned; see the file header.
final class MixRenderer {

    let sampleRate: Double

    // Control → render.
    private let lock = NSLock()
    private var pending: [MixCommand] = []

    // Master.
    private var masterTarget: Double = 0
    private var masterCurrent: Double = 0

    // FLOOR: the Om.
    private var omTarget: Double = 0
    private var omCurrent: Double = 0
    private var omCoef: Double
    private var omPhases: (Double, Double, Double) = (0, 0, 0)

    // FLOOR: pink noise.
    private var pinkTarget: Double = 0
    private var pinkCurrent: Double = 0
    private var pinkState: (Double, Double, Double, Double, Double, Double, Double) = (0, 0, 0, 0, 0, 0, 0)
    private var pinkFilter = HomeBiquad()
    private var noiseSeed: UInt64 = 0x2545F4914F6CDD1D

    // WORLD.
    private var bed: BedVoice?
    private var outgoing: [BedVoice] = []
    private var detuneSeed: UInt64 = 0x9E3779B97F4A7C15

    // HER / ROOM.
    private var her: HerSpec?
    private var herFreq: Double = 0
    private var herGainTarget: Double = 0
    private var herGainCurrent: Double = 0
    private var herRampFrom: Double = 0
    private var herRampAge: Double = 0
    private var herPhase: Double = 0
    private var herFifthPhase: Double = 0

    // BINAURAL.
    private var binaural: BinauralSpec?
    private var binCarrier: Double = Tuning.Om.root
    private var binBeat: Double = 0
    private var binGainTarget: Double = 0
    private var binGainCurrent: Double = 0
    private var binRendering: MixLaw.BinauralRendering = .stereo
    private var binPhaseL: Double = 0
    private var binPhaseR: Double = 0
    private var binPulsePhase: Double = 0

    // ACCENT.
    private var accents = [AccentVoice](repeating: AccentVoice(), count: MixRenderer.accentVoices)
    private var duckCurrent: Double = 0

    // The scene and the layers, by bus index.
    private var scene = [Bool](repeating: true, count: SoundBus.allCases.count)
    private var layer = [Double](repeating: 1, count: SoundBus.allCases.count)

    // Clocks.
    private var time: Double = 0
    private var controlCounter = 0

    /// How many struck sounds may ring at once; the oldest yields.
    static let accentVoices = 16
    static let controlInterval = 32

    // MARK: What the tests (and the walk's trace) can read after a render

    /// The Om's level now (before the master).
    private(set) var omLevel: Double = 0
    /// The duck now, 0 … 1.
    var duck: Double { duckCurrent }
    /// The WORLD bed's crossfade × level now (the bed in front).
    var bedGain: Double { (bed?.fade ?? 0) * (bed?.spec.level ?? 0) }
    /// Beds still fading out.
    var outgoingCount: Int { outgoing.count }
    var activeAccents: Int { accents.filter { $0.active }.count }
    var binauralGain: Double { binGainCurrent }
    var herGain: Double { herGainCurrent }
    var master: Double { masterCurrent }
    /// The largest |sample| before the ceiling, since the last reset.
    private(set) var unlimitedPeak: Double = 0
    func resetPeak() { unlimitedPeak = 0 }
    /// Seconds rendered.
    var seconds: Double { time }

    init(sampleRate: Double = 44_100) {
        self.sampleRate = sampleRate
        self.omCoef = 1 - exp(-1.0 / (MixLaw.omWakeTau * sampleRate))
        pinkFilter.setLowpass(frequency: MixLaw.pinkNoiseLowpass, q: 0.707, sampleRate: sampleRate)
    }

    // MARK: Control side

    func post(_ command: MixCommand) {
        lock.lock()
        pending.append(command)
        lock.unlock()
    }

    // MARK: Render side

    private func coef(_ tau: Double) -> Double { 1 - exp(-1.0 / (max(0.001, tau) * sampleRate)) }

    private func index(_ bus: SoundBus) -> Int {
        switch bus {
        case .floor: return 0
        case .world: return 1
        case .her: return 2
        case .binaural: return 3
        case .song: return 4
        case .accent: return 5
        case .haptic: return 6
        }
    }

    private func takeCommands() {
        guard lock.try() else { return }
        let commands = pending
        pending.removeAll(keepingCapacity: true)
        lock.unlock()
        for c in commands { apply(c) }
    }

    private func apply(_ command: MixCommand) {
        switch command {
        case .master(let level):
            masterTarget = max(0, min(1, level))
        case let .om(level, tau):
            omTarget = max(0, level)
            omCoef = coef(tau)
        case .pinkNoise(let gain):
            pinkTarget = max(0, gain)
        case .bed(let spec):
            if let current = bed {
                current.leaving = 0
                outgoing.append(current)
                // Keep at most two fading; the oldest goes.
                while outgoing.count > 2 { outgoing.removeFirst() }
            }
            if let spec {
                let rise = bed == nil && outgoing.isEmpty ? WorldVoices.bedRise : WorldVoices.crossfade
                bed = BedVoice(spec: spec, sampleRate: sampleRate, rise: rise, seed: &detuneSeed)
            } else {
                bed = nil
            }
        case .her(let spec):
            her = spec
            if let spec {
                if herGainCurrent < 0.00002 { herFreq = spec.hz }
                herGainTarget = spec.gain
                herRampFrom = spec.gain
                herRampAge = 0
            } else {
                herGainTarget = 0
            }
        case .binaural(let spec):
            binaural = spec
            if let spec, spec.rendering != .off {
                if binGainCurrent < 0.00002 { binCarrier = spec.carrier; binBeat = spec.beat }
                binGainTarget = MixLaw.clampBinaural(spec.gain)
                binRendering = spec.rendering
            } else {
                binGainTarget = 0
            }
        case .accent(let accent):
            fire(accent)
        case .scene(let buses):
            for bus in SoundBus.allCases { scene[index(bus)] = bus == .floor || buses.contains(bus) }
        case .layers(let gains):
            for bus in SoundBus.allCases { layer[index(bus)] = max(0, min(1, gains[bus] ?? 1)) }
        }
    }

    private func fire(_ accent: SoundAccent) {
        var v = AccentVoice()
        v.active = true
        switch accent {
        case .bell(let ring):
            v.kind = .bell
            v.freq = Tuning.bell(ring: ring)
            v.duration = Tuning.BellVoice.duration
            v.peak = MixLaw.clampEvent(Tuning.BellVoice.designPeak)
            v.filter.setLowpass(frequency: Tuning.BellVoice.lowpassFrom, q: 0.707, sampleRate: sampleRate)
        case let .fallingMantra(ring, vowel):
            v.kind = .tone
            v.freq = Tuning.fallingMantra(ring: ring, vowel: vowel)
            v.duration = Tuning.fallingMantraDuration(ring: ring)
            v.peak = MixLaw.clampEvent(Tuning.fallingMantraGain * MixLaw.clampEvent(Tuning.BellVoice.designPeak))
            v.age = -Tuning.fallingMantraDelay
        case let .threshold(hz, peak):
            v.kind = .threshold
            v.freq = hz
            v.duration = WorldVoices.Threshold.duration
            v.peak = MixLaw.clampEvent(peak)
        case let .tone(hz, seconds, peak):
            v.kind = .tone
            v.freq = hz
            v.duration = max(MixLaw.minimumAttack * 2, seconds)
            v.peak = MixLaw.clampEvent(peak)
        }
        var slot = accents.firstIndex { !$0.active }
        if slot == nil { slot = accents.indices.max { accents[$0].age < accents[$1].age } }
        if let slot { accents[slot] = v }
    }

    /// `a` → `b` exponentially over `span` at `t` (Web Audio's
    /// `exponentialRampToValueAtTime`).
    private static func expRamp(_ a: Double, _ b: Double, _ t: Double, _ span: Double) -> Double {
        guard span > 0 else { return b }
        guard a > 0, b > 0 else { return 0 }
        return a * pow(b / a, max(0, min(1, t / span)))
    }

    /// Design's bell envelope for one partial (or the master): .0001 → g in
    /// 12 ms, then → .0001 at `d`.
    private static func bellEnvelope(_ g: Double, _ t: Double, _ d: Double) -> Double {
        let a = Tuning.BellVoice.attack
        if t < 0 || t >= d { return 0 }
        if t < a { return expRamp(0.0001, g, t, a) }
        return expRamp(g, 0.0001, t - a, d - a)
    }

    private func accentSample(_ v: inout AccentVoice, dt: Double) -> Double {
        v.age += dt
        let t = v.age
        if t < 0 { return 0 }
        if t >= v.duration { v.active = false; return 0 }
        let f = v.freq
        switch v.kind {
        case .bell:
            let d = Tuning.BellVoice.duration
            let parts = Tuning.BellVoice.partials
            var sum = 0.0
            v.p0 += f * parts[0].ratio * dt; if v.p0 >= 1 { v.p0 -= 1 }
            v.p1 += f * parts[1].ratio * dt; if v.p1 >= 1 { v.p1 -= 1 }
            v.p2 += f * parts[2].ratio * dt; if v.p2 >= 1 { v.p2 -= 1 }
            v.p3 += f * parts[3].ratio * dt; if v.p3 >= 1 { v.p3 -= 1 }
            sum += sin(v.p0 * 2 * .pi) * Self.bellEnvelope(parts[0].gain, t, d * parts[0].durationFraction)
            sum += sin(v.p1 * 2 * .pi) * Self.bellEnvelope(parts[1].gain, t, d * parts[1].durationFraction)
            sum += sin(v.p2 * 2 * .pi) * Self.bellEnvelope(parts[2].gain, t, d * parts[2].durationFraction)
            sum += sin(v.p3 * 2 * .pi) * Self.bellEnvelope(parts[3].gain, t, d * parts[3].durationFraction)
            if controlCounter == 0 {
                let span = d * Tuning.BellVoice.lowpassFraction
                let cutoff = Self.expRamp(Tuning.BellVoice.lowpassFrom, Tuning.BellVoice.lowpassTo, t, span)
                v.filter.setLowpass(frequency: cutoff, q: 0.707, sampleRate: sampleRate)
            }
            return v.filter.process(sum) * Self.bellEnvelope(v.peak, t, d)
        case .threshold:
            v.p0 += f * dt; if v.p0 >= 1 { v.p0 -= 1 }
            v.p1 += f * WorldVoices.Threshold.partialRatio * dt; if v.p1 >= 1 { v.p1 -= 1 }
            let x = sin(v.p0 * 2 * .pi) + WorldVoices.Threshold.partialGain * sin(v.p1 * 2 * .pi)
            return x * WorldVoices.thresholdEnvelope(t: t, peak: v.peak)
        case .tone:
            v.p0 += f * dt; if v.p0 >= 1 { v.p0 -= 1 }
            let a = MixLaw.minimumAttack
            let env = t < a ? v.peak * t / a : Self.expRamp(v.peak, 0.0001, t - a, v.duration - a)
            return sin(v.p0 * 2 * .pi) * env
        }
    }

    private func pinkSample() -> Double {
        noiseSeed ^= noiseSeed << 13
        noiseSeed ^= noiseSeed >> 7
        noiseSeed ^= noiseSeed << 17
        let white = Double(noiseSeed >> 11) / Double(UInt64(1) << 53) * 2 - 1
        var s = pinkState
        // Paul Kellet's seven coefficients.
        s.0 = 0.99886 * s.0 + white * 0.0555179
        s.1 = 0.99332 * s.1 + white * 0.0750759
        s.2 = 0.96900 * s.2 + white * 0.1538520
        s.3 = 0.86650 * s.3 + white * 0.3104856
        s.4 = 0.55000 * s.4 + white * 0.5329522
        s.5 = -0.7616 * s.5 - white * 0.0168980
        let pink = (s.0 + s.1 + s.2 + s.3 + s.4 + s.5 + s.6 + white * 0.5362) * 0.11
        s.6 = white * 0.115926
        pinkState = s
        return pinkFilter.process(pink)
    }

    /// Bus multipliers now: scene × layer × duck (`MixLaw.duckMultiplier`).
    /// The Om (FLOOR) stands in every scene and is never ducked.
    private func multipliers() -> (floor: Double, world: Double, her: Double, binaural: Double, accent: Double) {
        func bus(_ b: SoundBus) -> Double {
            let i = index(b)
            let inScene = b == .floor || scene[i]
            return inScene ? layer[i] * MixLaw.duckMultiplier(b, depth: duckCurrent) : 0
        }
        return (bus(.floor), bus(.world), bus(.her), bus(.binaural), bus(.accent))
    }

    /// Render `frames` samples into `left` and `right` (right may be nil for
    /// a mono destination: then left carries the mono sum).
    func render(left: UnsafeMutablePointer<Float>, right: UnsafeMutablePointer<Float>?, frames: Int) {
        takeCommands()
        let sr = sampleRate
        let dt = 1.0 / sr
        let ceiling = MixLaw.limiterCeiling
        let masterUp = coef(MixLaw.wakeTau)
        let masterDown = coef(MixLaw.muteTau)
        let herCoef = coef(HomeCarrier.Tau.carrierGain)
        let herFreqCoef = coef(HomeCarrier.Tau.carrierFreq)
        let binCoef = coef(1.0)
        let duckUp = coef(MixLaw.duckAttackTau)
        let duckDown = coef(MixLaw.duckReleaseTau)
        let pinkCoef = coef(1.0)
        let om = Tuning.Om.partials

        var m = multipliers()
        for i in 0..<frames {
            if controlCounter == 0 {
                m = multipliers()
                // The world breath sweeps every bed's cutoff (S08).
                let sweep = 1 + WorldVoices.breathDepth * sin(2 * .pi * WorldVoices.breathHz * time)
                if let b = bed, let lp = b.spec.lowpass {
                    b.filter.setLowpass(frequency: lp * sweep, q: WorldVoices.lowpassQ, sampleRate: sr)
                }
                for b in outgoing {
                    if let lp = b.spec.lowpass {
                        b.filter.setLowpass(frequency: lp * sweep, q: WorldVoices.lowpassQ, sampleRate: sr)
                    }
                }
            }

            // Master.
            masterCurrent += (masterTarget - masterCurrent) * (masterTarget > masterCurrent ? masterUp : masterDown)

            // FLOOR — the Om, its breath upward only, and pink noise.
            omCurrent += (omTarget - omCurrent) * omCoef
            let breath = 1 + MixLaw.omBreathDepth * (0.5 + 0.5 * sin(2 * .pi * MixLaw.omBreathHz * time))
            omLevel = omCurrent * breath
            omPhases.0 += om[0].hz * dt; if omPhases.0 >= 1 { omPhases.0 -= 1 }
            omPhases.1 += om[1].hz * dt; if omPhases.1 >= 1 { omPhases.1 -= 1 }
            omPhases.2 += om[2].hz * dt; if omPhases.2 >= 1 { omPhases.2 -= 1 }
            var floor = (sin(omPhases.0 * 2 * .pi) * om[0].gain
                         + sin(omPhases.1 * 2 * .pi) * om[1].gain
                         + sin(omPhases.2 * 2 * .pi) * om[2].gain) * omLevel
            pinkCurrent += (pinkTarget - pinkCurrent) * pinkCoef
            if pinkCurrent > 0.00002 || pinkTarget > 0 { floor += pinkSample() * pinkCurrent }

            // WORLD.
            var world = 0.0
            if let b = bed {
                b.tick(dt: dt)
                world += b.sample(sampleRate: sr)
            }
            if !outgoing.isEmpty {
                for b in outgoing {
                    b.tick(dt: dt)
                    world += b.sample(sampleRate: sr)
                }
                if controlCounter == 0 { outgoing.removeAll { $0.finished } }
            }

            // HER / ROOM.
            var herOut = 0.0
            if let h = her, let to = h.rampTo, h.rampSeconds > 0 {
                herRampAge += dt
                herGainTarget = herRampFrom + (to - herRampFrom) * min(1, herRampAge / h.rampSeconds)
            }
            herGainCurrent += (herGainTarget - herGainCurrent) * herCoef
            if herGainCurrent > 0.00002 {
                if let h = her { herFreq += (h.hz - herFreq) * herFreqCoef }
                herPhase += herFreq * dt; if herPhase >= 1 { herPhase -= 1 }
                herOut = sin(herPhase * 2 * .pi) * herGainCurrent
                if let period = her?.fifthBreathPeriod, period > 0 {
                    herFifthPhase += herFreq * Tuning.fifthRatio * dt; if herFifthPhase >= 1 { herFifthPhase -= 1 }
                    let swell = (1 - cos(2 * .pi * time / period)) / 2
                    herOut += sin(herFifthPhase * 2 * .pi) * herGainCurrent * swell
                }
            }

            // BINAURAL.
            var binL = 0.0, binR = 0.0
            binGainCurrent += (binGainTarget - binGainCurrent) * binCoef
            if binGainCurrent > 0.00002 {
                if let b = binaural {
                    binCarrier += (b.carrier - binCarrier) * binCoef
                    binBeat += (b.beat - binBeat) * binCoef
                }
                binPhaseL += binCarrier * dt; if binPhaseL >= 1 { binPhaseL -= 1 }
                switch binRendering {
                case .stereo:
                    binPhaseR += (binCarrier + binBeat) * dt; if binPhaseR >= 1 { binPhaseR -= 1 }
                    binL = sin(binPhaseL * 2 * .pi) * binGainCurrent
                    binR = sin(binPhaseR * 2 * .pi) * binGainCurrent
                case .pulse, .off:
                    // An isochronic pulse on the same carrier: AM at the beat, depth .5.
                    binPulsePhase += binBeat * dt; if binPulsePhase >= 1 { binPulsePhase -= 1 }
                    let am = 1 - MixLaw.pulseDepth * (0.5 + 0.5 * cos(binPulsePhase * 2 * .pi))
                    binL = sin(binPhaseL * 2 * .pi) * binGainCurrent * am
                    binR = binL
                }
            }

            // ACCENT, and the duck it asks for.
            var accent = 0.0
            var ringing = false
            for k in accents.indices where accents[k].active {
                var v = accents[k]
                accent += accentSample(&v, dt: dt)
                if v.active && v.age >= 0 { ringing = true }
                accents[k] = v
            }
            let duckTarget = ringing ? 1.0 : 0.0
            duckCurrent += (duckTarget - duckCurrent) * (duckTarget > duckCurrent ? duckUp : duckDown)

            // The sum, the master, the ceiling.
            let mono = floor * m.floor + world * m.world + herOut * m.her + accent * m.accent
            let l = (mono + binL * m.binaural) * masterCurrent
            let r = (mono + binR * m.binaural) * masterCurrent
            unlimitedPeak = max(unlimitedPeak, abs(l), abs(r))
            let lc = max(-ceiling, min(ceiling, l))
            let rc = max(-ceiling, min(ceiling, r))
            if let right {
                left[i] = Float(lc)
                right[i] = Float(rc)
            } else {
                left[i] = Float((lc + rc) / 2)
            }

            time += dt
            controlCounter = (controlCounter + 1) % Self.controlInterval
        }
    }

    /// Offline: render `frames` stereo samples into arrays (tests, the walk).
    func render(frames: Int) -> (left: [Float], right: [Float]) {
        var l = [Float](repeating: 0, count: frames)
        var r = [Float](repeating: 0, count: frames)
        l.withUnsafeMutableBufferPointer { lp in
            r.withUnsafeMutableBufferPointer { rp in
                if let lb = lp.baseAddress, let rb = rp.baseAddress {
                    render(left: lb, right: rb, frames: frames)
                }
            }
        }
        return (l, r)
    }

    /// Offline: render `seconds` (convenience).
    func render(seconds: Double) -> (left: [Float], right: [Float]) {
        render(frames: Int(seconds * sampleRate))
    }
}
