import Foundation
import Combine

// MARK: - Upgrade U1 · B · mute and volume (ruling 10 lifted "no controls")
//
// `waves/upgrade/worlds/sound.md` S06 and §4 "Local stores": one key family
// `sound.*` replaces `lr_sound` (read live, not once); default ON (BC-09 governs
// over Design's default-off chimes); master volume 0.8; one gain per layer;
// binaural mode Auto / Always / Off; haptics on/off. A convenience in
// UserDefaults — not practice data.

/// How the BINAURAL bus is offered (S06, S80).
enum SoundBinauralMode: String, CaseIterable {
    /// True L/R on headphones; an isochronic pulse on the speaker.
    case auto
    /// True L/R wherever (a pulse only under Mono Audio).
    case always
    case off
}

/// His sound settings — `sound.md` S06. Read live by the mixer.
@MainActor
final class SoundSettings: ObservableObject {

    static let shared = SoundSettings()

    enum Key {
        static let masterOn = "sound.master.on"
        static let masterVolume = "sound.master.volume"
        static let layerPrefix = "sound.layer."
        static let binauralMode = "sound.binaural.mode"
        static let hapticsOn = "sound.haptics.on"
        /// The Mandala's old switch, migrated once into `sound.master.on`.
        static let legacy = "lr_sound"
    }

    private let defaults: UserDefaults

    @Published private(set) var masterOn: Bool
    @Published private(set) var masterVolume: Double
    @Published private(set) var binauralMode: SoundBinauralMode
    @Published private(set) var hapticsOn: Bool
    @Published private(set) var layers: [SoundBus: Double]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        // Migrate `lr_sound` once: its value becomes the master switch when no
        // `sound.master.on` has been written yet. `lr_sound` itself is left for
        // the screens that still read it until U2 moves them here.
        if defaults.object(forKey: Key.masterOn) == nil,
           let legacy = defaults.object(forKey: Key.legacy) as? Bool {
            defaults.set(legacy, forKey: Key.masterOn)
        }
        masterOn = (defaults.object(forKey: Key.masterOn) as? Bool) ?? true
        let volume = (defaults.object(forKey: Key.masterVolume) as? Double) ?? MixLaw.defaultMasterVolume
        masterVolume = max(0, min(1, volume))
        binauralMode = SoundBinauralMode(rawValue: defaults.string(forKey: Key.binauralMode) ?? "") ?? .auto
        hapticsOn = (defaults.object(forKey: Key.hapticsOn) as? Bool) ?? true
        var l: [SoundBus: Double] = [:]
        for bus in SoundBus.allCases {
            if let g = defaults.object(forKey: Key.layerPrefix + bus.rawValue) as? Double {
                l[bus] = max(0, min(1, g))
            }
        }
        layers = l
    }

    /// The level the master stands at: the volume, or nothing when muted.
    var effectiveMaster: Double { masterOn ? masterVolume : 0 }

    /// One layer's gain (default 1).
    func layerGain(_ bus: SoundBus) -> Double { layers[bus] ?? 1 }

    /// The glyph's tap.
    func toggleMute() { setMasterOn(!masterOn) }

    func setMasterOn(_ on: Bool) {
        masterOn = on
        defaults.set(on, forKey: Key.masterOn)
    }

    func setMasterVolume(_ value: Double) {
        masterVolume = max(0, min(1, value))
        defaults.set(masterVolume, forKey: Key.masterVolume)
    }

    func setLayer(_ bus: SoundBus, gain: Double) {
        let g = max(0, min(1, gain))
        layers[bus] = g
        defaults.set(g, forKey: Key.layerPrefix + bus.rawValue)
    }

    func setBinauralMode(_ mode: SoundBinauralMode) {
        binauralMode = mode
        defaults.set(mode.rawValue, forKey: Key.binauralMode)
    }

    func setHapticsOn(_ on: Bool) {
        hapticsOn = on
        defaults.set(on, forKey: Key.hapticsOn)
    }
}
