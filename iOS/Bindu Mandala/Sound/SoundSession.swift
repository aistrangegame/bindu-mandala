import AVFoundation
import UIKit

// MARK: - Upgrade U1 · B · one owner of the audio session
//
// `waves/upgrade/worlds/sound.md` S03: the conductor owns AVAudioSession.
// `.ambient` by default, so the silent switch is honoured (BC-09); `.playback`
// only while he has pressed play on a song (his act); `.playAndRecord` with
// `.defaultToSpeaker` and `.allowBluetoothA2DP` only while a listening gate is
// open, the previous category restored when it closes. Interruptions and route
// changes pause with a 0.5 s fade and resume on `.shouldResume`; headphones
// pulled pause SONG and mute BINAURAL.
//
// Today six engines still set the category themselves (BijaSoundService,
// SpeechCapture, RingAudioService, HomeSoundService, HeartRegister,
// PlayInstruments). U2 moves each `setCategory` here; U1 adds the owner and
// does not touch them.

/// The one owner of `AVAudioSession` — `sound.md` S03.
@MainActor
final class SoundSession {

    static let shared = SoundSession()

    /// What the session currently answers.
    private(set) var need: SoundSessionNeed = .ambient
    /// He pressed play on a song.
    private(set) var songPressed = false
    /// A listening gate is open.
    private(set) var listening = false

    /// Interruption began (`true`) or ended with `.shouldResume` (`false`).
    var onInterruption: ((_ began: Bool) -> Void)?
    /// The headphones were pulled out.
    var onHeadphonesGone: (() -> Void)?
    /// The route or Mono Audio changed — the binaural's rendering may change.
    var onRouteOrMonoChange: (() -> Void)?

    private var observers: [NSObjectProtocol] = []

    private init() {}

    // MARK: Asking

    func setSongPressed(_ on: Bool) {
        songPressed = on
        apply()
    }

    func setListening(_ on: Bool) {
        listening = on
        apply()
    }

    /// Configure and activate for the current need. `false` if the system refused.
    @discardableResult
    func activate() -> Bool {
        observe()
        return apply()
    }

    // MARK: The route

    /// Headphones (wired or Bluetooth) carry the output.
    var headphonesConnected: Bool {
        let ports: Set<AVAudioSession.Port> = [.headphones, .bluetoothA2DP, .bluetoothLE, .bluetoothHFP]
        return AVAudioSession.sharedInstance().currentRoute.outputs.contains { ports.contains($0.portType) }
    }

    /// Mono Audio (Accessibility) is on.
    var monoAudio: Bool { UIAccessibility.isMonoAudioEnabled }

    // MARK: Telling the system

    @discardableResult
    private func apply() -> Bool {
        need = SoundSessionNeed.need(songPressed: songPressed, listening: listening)
        guard !AppRuntime.isUnitTesting else { return true }
        let session = AVAudioSession.sharedInstance()
        do {
            switch need {
            case .ambient:
                // `.mixWithOthers` is invalid with `.ambient` (it mixes by
                // definition) and throws -50 — see HomeSoundService.configureSession.
                try session.setCategory(.ambient, mode: .default)
            case .playback:
                try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            case .listening:
                try session.setCategory(.playAndRecord, mode: .default,
                                        options: [.defaultToSpeaker, .allowBluetoothA2DP])
            }
            try session.setActive(true)
            return true
        } catch {
            return false
        }
    }

    private func observe() {
        guard observers.isEmpty, !AppRuntime.isUnitTesting else { return }
        let center = NotificationCenter.default
        let session = AVAudioSession.sharedInstance()
        observers.append(center.addObserver(forName: AVAudioSession.interruptionNotification,
                                            object: session, queue: .main) { [weak self] note in
            let type = (note.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt) ?? 0
            let options = (note.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt) ?? 0
            Task { @MainActor in
                if type == AVAudioSession.InterruptionType.began.rawValue {
                    self?.onInterruption?(true)
                } else if type == AVAudioSession.InterruptionType.ended.rawValue,
                          AVAudioSession.InterruptionOptions(rawValue: options).contains(.shouldResume) {
                    self?.apply()
                    self?.onInterruption?(false)
                }
            }
        })
        observers.append(center.addObserver(forName: AVAudioSession.routeChangeNotification,
                                            object: session, queue: .main) { [weak self] note in
            let reason = (note.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt) ?? 0
            Task { @MainActor in
                if reason == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue {
                    self?.onHeadphonesGone?()
                }
                self?.onRouteOrMonoChange?()
            }
        })
        observers.append(center.addObserver(forName: UIAccessibility.monoAudioStatusDidChangeNotification,
                                            object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor in self?.onRouteOrMonoChange?() }
        })
    }
}
