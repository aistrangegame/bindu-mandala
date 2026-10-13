import AVFoundation
import Foundation

// MARK: - Upgrade U1 · B · the mixer
//
// `waves/upgrade/worlds/sound.md` §1.2–1.3, S01–S07: seven buses summed under
// one master, one owner of the session, sound on by first touch, each world's
// voice crossing in over 2.6 s, its threshold tone once, the Om under
// everything, one song at a time.
//
// **What it wraps and what it replaces.** `SoundConductor` stays the entrance
// every existing engine calls (claim / release / strike); its arbiter's
// "one bed at a time" is replaced by `MixLaw.conductorGains`, which U2 swaps in
// with one line. `HomeSoundService` stays her carrier's whole graph (S41) and is
// reused here for the ring grounds (`HomeCarrier.ground(forRing:)` voiced by
// `HomeGround`); `TreeOfLife.omFloor` is the Om's floor; `BreathClock` is not
// touched (the world breath, 0.08 Hz, is the renderer's own clock, S08). U1
// wires no screen to this mixer: U2 moves the Om, the beds and every
// `setCategory` here, so nothing sounds twice.

/// The one mixer — `sound.md` §1.2 (S01). Main-actor API; the render thread
/// only ever reads `MixCommand`s (`MixRenderer`).
@MainActor
final class SoundMixer {

    static let shared = SoundMixer()

    let settings: SoundSettings
    let session: SoundSession
    let store: RecordingStore
    /// The synthesised buses. Exposed so the tests (and the walk) can render
    /// offline exactly what the engine would play.
    let renderer: MixRenderer

    private let sampleRate: Double = 44_100
    private var engine: AVAudioEngine?
    private var source: AVAudioSourceNode?
    private var submix: AVAudioMixerNode?
    private var limiter: AVAudioUnitEffect?
    private var songPlayer: AVAudioPlayerNode?
    private var songMixer: AVAudioMixerNode?

    /// Sound has woken (the first touch).
    private(set) var isAwake = false
    /// The world whose scene is sounding.
    private(set) var world: WorldID?
    /// The ring he stands in (ring-ground beds, thresholds).
    private(set) var ring = 1
    /// How deep (0 Home … 9 the source) — the Om's floor follows it.
    private(set) var depth = 0
    private var swell: Double?
    private var lastBinaural: (carrier: Double, beat: Double, gain: Double)?
    private(set) var songSlot = SongSlot()
    private var songFade: Task<Void, Never>?

    /// No engine and no session in a unit-test host; the renderer still runs.
    private var allowed: Bool { !AppRuntime.isUnitTesting }

    init(settings: SoundSettings? = nil, session: SoundSession? = nil,
         store: RecordingStore? = nil, sampleRate: Double = 44_100) {
        self.settings = settings ?? SoundSettings.shared
        self.session = session ?? SoundSession.shared
        self.store = store ?? RecordingStore.shared
        self.renderer = MixRenderer(sampleRate: sampleRate)
        self.session.onInterruption = { [weak self] began in self?.interrupted(began) }
        self.session.onHeadphonesGone = { [weak self] in self?.headphonesGone() }
        self.session.onRouteOrMonoChange = { [weak self] in self?.reassertBinaural() }
    }

    // MARK: First touch (S05)

    /// Nothing sounds at launch. The first touch anywhere starts the engine
    /// and the Om rises from 0 to its floor over 2.4 s (τ 1.2 s). Idempotent.
    func wakeOnFirstTouch() {
        guard !isAwake else { return }
        isAwake = true
        renderer.post(.layers(settings.layers))
        renderer.post(.master(settings.effectiveMaster))
        postOm(tau: MixLaw.omWakeTau)
        guard allowed else { return }
        session.activate()
        buildEngine()
    }

    // MARK: Worlds (S09, S22)

    /// Cross into `world`: its scene, its bed crossfading in over 2.6 s (the
    /// departing bed out, stopped at 2.9 s), its threshold tone once. A song
    /// never follows him into another world (S07, S62).
    func enter(_ world: WorldID, ring: Int = 1, herCarrier: Double? = nil) {
        let voice = WorldVoices.voice(for: world)
        let crossing = self.world != world
        self.world = world
        self.ring = max(1, min(9, ring))
        renderer.post(.scene(voice.buses))
        renderer.post(.bed(BedSpec.make(voice.bed, ring: self.ring)))
        if case .pinkNoise(let gain) = voice.bed {
            renderer.post(.pinkNoise(gain))
        } else {
            renderer.post(.pinkNoise(0))
        }
        if crossing {
            renderer.post(.her(nil))
            stopBinaural()
            if songSlot.current != nil { stopSong() }
        }
        if isAwake {
            renderer.post(.accent(.threshold(hz: voice.thresholdHz(ring: self.ring, herCarrier: herCarrier),
                                             peak: voice.thresholdPeak)))
        }
    }

    /// The constellation menu: a world-point hums its threshold at 0.010 as
    /// the finger passes (S09).
    func hum(_ world: WorldID) {
        guard isAwake else { return }
        let voice = WorldVoices.voice(for: world)
        renderer.post(.accent(.threshold(hz: voice.thresholdHz(ring: ring),
                                         peak: WorldVoices.Threshold.menuHum)))
    }

    /// The ring changes inside a ring-ground world (the Mandala's glass, the
    /// rings, the Climb): its ground crossfades in.
    func setRing(_ r: Int) {
        let next = max(1, min(9, r))
        guard next != ring else { return }
        ring = next
        guard let world else { return }
        let voice = WorldVoices.voice(for: world)
        if case .ringGround = voice.bed { renderer.post(.bed(BedSpec.make(voice.bed, ring: next))) }
    }

    // MARK: The Om (S16, S17, S23)

    func setDepth(_ d: Int) {
        depth = max(0, min(9, d))
        postOm(tau: MixLaw.omWakeTau)
    }

    /// Raise the Om (`nil` gives it back to its floor). Never below the floor,
    /// never above 0.20.
    func swellOm(_ level: Double?, tau: Double = MixLaw.omWakeTau) {
        swell = level
        postOm(tau: tau)
    }

    private func postOm(tau: Double) {
        guard isAwake else { return }
        renderer.post(.om(level: MixLaw.omLevel(depth: depth, swell: swell), tau: tau))
    }

    // MARK: Accents, her, the room, the binaural, pink noise

    /// A bell, a falling mantra, a threshold, a struck tone — clamped to 0.075.
    /// An inward crossing is a bell and, 180 ms later, its falling mantra (S26, S27).
    func strike(_ accent: SoundAccent) {
        guard isAwake else { return }
        renderer.post(.accent(accent))
    }

    /// HER / ROOM: her carrier held, or a room's fixed tone (nil lets it go).
    func setHer(_ spec: HerSpec?) { renderer.post(.her(spec)) }

    /// A 33 room's fixed tone (§1.7). Room 33 lifts the Om to its highest;
    /// rooms of silence and the sealed room sound nothing on HER.
    func enterRoom(_ room: Int) {
        guard let tone = RoomTones.tone(room: room) else { return }
        renderer.post(.her(HerSpec.room(tone)))
        if room == 33 { swellOm(RoomTones.lalitaOm) }
    }

    /// The binaural on `carrier` with `beat`, its gain kept in 0.003–0.050;
    /// true L/R or a pulse by the Sound sheet's mode, Mono Audio and the route.
    func setBinaural(carrier: Double, beat: Double, gain: Double) {
        lastBinaural = (carrier, beat, gain)
        let rendering = MixLaw.binauralRendering(mode: settings.binauralMode,
                                                 monoAudio: session.monoAudio,
                                                 headphones: session.headphonesConnected)
        renderer.post(.binaural(BinauralSpec(carrier: carrier, beat: beat,
                                             gain: MixLaw.clampBinaural(gain), rendering: rendering)))
    }

    func stopBinaural() {
        lastBinaural = nil
        renderer.post(.binaural(nil))
    }

    private func reassertBinaural() {
        guard let b = lastBinaural else { return }
        setBinaural(carrier: b.carrier, beat: b.beat, gain: b.gain)
    }

    /// The pink-noise floor (S58), on under Scores, the Well and Beneath.
    func setPinkNoise(_ on: Bool) {
        renderer.post(.pinkNoise(on ? MixLaw.pinkNoiseGain : 0))
    }

    // MARK: Mute and volume (S06)

    func toggleMute() {
        settings.toggleMute()
        renderer.post(.master(settings.effectiveMaster))
    }

    func setMasterVolume(_ v: Double) {
        settings.setMasterVolume(v)
        renderer.post(.master(settings.effectiveMaster))
    }

    func setLayer(_ bus: SoundBus, gain: Double) {
        settings.setLayer(bus, gain: gain)
        renderer.post(.layers(settings.layers))
    }

    // MARK: Listening gates (S03, S54)

    func openListening() { session.setListening(true) }
    func closeListening() { session.setListening(false) }

    // MARK: SONG — one source at a time (S02, S04, S64)

    /// He pressed play on `path`: any other song fades out over 2 s; the same
    /// song pressed again stops.
    func pressSong(_ path: String) {
        switch songSlot.press(path) {
        case let .start(session, stopping):
            self.session.setSongPressed(true)
            let fadeOld = stopping != nil
            songFade?.cancel()
            songFade = Task { @MainActor [weak self] in
                guard let self else { return }
                if fadeOld { await self.fadeSong(to: 0, over: MixLaw.songSwapFade) }
                guard self.songSlot.isCurrent(session.id) else { return }
                await self.play(session)
            }
        case .stop:
            stopSong()
        }
    }

    /// Stop whatever song plays (2 s fade).
    func stopSong() {
        _ = songSlot.stop()
        songFade?.cancel()
        songFade = Task { @MainActor [weak self] in
            guard let self else { return }
            await self.fadeSong(to: 0, over: MixLaw.songSwapFade)
            if self.songSlot.current == nil {
                self.songPlayer?.stop()
                self.session.setSongPressed(false)
            }
        }
    }

    private func play(_ s: SongSlot.Session) async {
        guard allowed else { return }
        do {
            let url = try await store.localURL(for: s.path)
            guard songSlot.isCurrent(s.id) else { return }
            buildEngine()
            guard let engine, let player = songPlayer, let mixer = songMixer else { return }
            let file = try AVAudioFile(forReading: url)
            player.stop()
            engine.disconnectNodeOutput(player)
            engine.connect(player, to: mixer, format: file.processingFormat)
            mixer.outputVolume = 0
            let id = s.id
            player.scheduleFile(file, at: nil) { [weak self] in
                Task { @MainActor in self?.songEnded(id) }
            }
            if !engine.isRunning { try engine.start() }
            player.play()
            // 0 → 0.8, +0.015 every 50 ms.
            while songSlot.isCurrent(id), Double(mixer.outputVolume) < MixLaw.songGain {
                mixer.outputVolume = Float(min(MixLaw.songGain, Double(mixer.outputVolume) + MixLaw.songFadeStep))
                try? await Task.sleep(for: .seconds(MixLaw.songFadeTick))
                if Task.isCancelled { return }
            }
        } catch {
            songSlot.finished(s.id)
            session.setSongPressed(songSlot.current != nil)
        }
    }

    private func fadeSong(to target: Double, over seconds: Double) async {
        guard let mixer = songMixer else { return }
        let start = Double(mixer.outputVolume)
        let steps = max(1, Int(seconds / MixLaw.songFadeTick))
        for k in 1...steps {
            mixer.outputVolume = Float(start + (target - start) * Double(k) / Double(steps))
            try? await Task.sleep(for: .seconds(MixLaw.songFadeTick))
        }
    }

    private func songEnded(_ id: Int) {
        guard songSlot.isCurrent(id) else { return }
        songSlot.finished(id)
        session.setSongPressed(false)
    }

    // MARK: Leaving

    /// The app leaves the foreground: everything fades and lets go.
    func letGo() {
        renderer.post(.master(0))
        renderer.post(.bed(nil))
        renderer.post(.her(nil))
        renderer.post(.binaural(nil))
        _ = songSlot.stop()
        songFade?.cancel()
        songPlayer?.stop()
        session.setSongPressed(false)
        isAwake = false
        world = nil
        guard allowed else { return }
        let engine = self.engine
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(MixLaw.leavingFade))
            engine?.pause()
        }
    }

    // MARK: Session events (S03)

    private func interrupted(_ began: Bool) {
        if began {
            renderer.post(.master(0))
            songPlayer?.pause()
        } else {
            if let engine, !engine.isRunning { try? engine.start() }
            renderer.post(.master(settings.effectiveMaster))
            if songSlot.current != nil { songPlayer?.play() }
        }
    }

    private func headphonesGone() {
        songPlayer?.pause()
        renderer.post(.binaural(nil))
    }

    // MARK: The graph

    /// source (synth buses) ─┐
    ///                       ├─ submix ─ limiter ─ main mixer
    /// song player ─ songMix ┘
    private func buildEngine() {
        guard allowed else { return }
        if let engine {
            if !engine.isRunning { try? engine.start() }
            return
        }
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2) else { return }
        let engine = AVAudioEngine()
        let renderer = self.renderer
        let source = AVAudioSourceNode(format: format) { _, _, frameCount, abl in
            let buffers = UnsafeMutableAudioBufferListPointer(abl)
            guard buffers.count > 0,
                  let left = buffers[0].mData?.assumingMemoryBound(to: Float.self) else { return noErr }
            let right = buffers.count > 1 ? buffers[1].mData?.assumingMemoryBound(to: Float.self) : nil
            renderer.render(left: left, right: right, frames: Int(frameCount))
            return noErr
        }
        let submix = AVAudioMixerNode()
        let songMixer = AVAudioMixerNode()
        songMixer.outputVolume = 0
        let player = AVAudioPlayerNode()
        let limiter = AVAudioUnitEffect(audioComponentDescription: AudioComponentDescription(
            componentType: kAudioUnitType_Effect,
            componentSubType: kAudioUnitSubType_PeakLimiter,
            componentManufacturer: kAudioUnitManufacturer_Apple,
            componentFlags: 0,
            componentFlagsMask: 0))

        _ = engine.mainMixerNode
        engine.attach(source)
        engine.attach(submix)
        engine.attach(songMixer)
        engine.attach(player)
        engine.attach(limiter)
        engine.connect(source, to: submix, format: format)
        engine.connect(player, to: songMixer, format: nil)
        engine.connect(songMixer, to: submix, format: format)
        engine.connect(submix, to: limiter, format: format)
        engine.connect(limiter, to: engine.mainMixerNode, format: format)
        do {
            try engine.start()
        } catch {
            return
        }
        self.engine = engine
        self.source = source
        self.submix = submix
        self.limiter = limiter
        self.songPlayer = player
        self.songMixer = songMixer
    }
}
