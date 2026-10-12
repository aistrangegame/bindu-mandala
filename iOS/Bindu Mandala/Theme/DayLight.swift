import SwiftUI

// MARK: - The day's light
//
// Wave 1 · Slice B. The Reading §2.3 measured what the first port lost on the
// way from Design's frames to the device: the sacred geometry outside the
// Mandala canvas drawn 2–8× fainter than Design drew it — the Rite ≈2.6×,
// Recognition ≈1.9×, the Field's chips 2–4×, the threshold ≈8×. Two causes, both
// arithmetic: the ×1.7 every `LrSigil` stroke carries (`opacity={o * 1.7}`) was
// never applied, and two dimmers (a 0.9 inside the sigil, a 0.7 on the Rite's
// layer) were stacked on top of what was left.
//
// This is where the numbers Design actually drew at now live, in one place, so
// the screens read them instead of each choosing a quieter one.

enum DayLight {

    /// The prototype's `atmosphereIntensity` tweak at its shipped default.
    static let intensity: Double = 0.85

    /// The Rite's sigil layer: `0.62 + intensity × 0.42` (`TdSigil`'s `sigilO`).
    /// Her name as the veil (ether) rises to the same light.
    static var riteSigilOpacity: Double { 0.62 + intensity * 0.42 }

    /// The other surfaces' sigil layers, as Design drew them.
    static let fieldChipOpacity: Double = 1.0        // `opacity={2.4}` clamps to 1
    static let fieldRoomOpacity: Double = 0.5        // the open ring's geometry
    static let thresholdSigilOpacity: Double = 0.7   // `AvaranaThreshold`
    static let presenceSigilOpacity: Double = 0.55   // Her Presence / Recognition

    /// Today's position — the pin first (tests and screenshots), the calendar
    /// otherwise. The same rule every screen obeys (Wave 0 · B8).
    static var todayPosition: Int {
        AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition()
    }

    /// The day's atmosphere: today's Śakti lit by the hour. Before the store has
    /// her, the home ring's light stands in — never a blank ground.
    static func atmosphere(_ shaktis: [Shakti],
                           position: Int = DayLight.todayPosition,
                           at variant: TimeVariant = LunarPhaseService.currentTimeVariant()) -> Atmosphere {
        if let t = shaktis.first(where: { $0.khadgamalaPosition == position }) {
            return Atmosphere.derive(from: t, at: variant)
        }
        return Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: position,
                                 element: .ether, at: variant)
    }

    /// "I feel her": `linear-gradient(135deg, red, color-mix(red 66%, accent 34%))`.
    /// The far end of the pill carries a third of her hue.
    static func feelHerEndRGB(_ a: Atmosphere) -> (r: Double, g: Double, b: Double) {
        Atmosphere.mix((139 / 255, 26 / 255, 42 / 255), a.hue.rgb, 0.34)
    }

    static func feelHerEnd(_ a: Atmosphere) -> Color {
        Atmosphere.color(feelHerEndRGB(a))
    }
}

// MARK: - Each ring breathes at its own rate

/// The nine metabolisms (Mandala App v2): the Bhūpura holds — "the earth
/// underfoot does not breathe" — and inward of it each enclosure breathes at
/// its own period, 3 · 8 · 9 · 11 · 13 · 15 · 18 s, with the Bindu at 4 s.
enum FieldBreath {
    static func period(ring: Int) -> Double? {
        switch ring {
        case 2: return 3
        case 3: return 8
        case 4: return 9
        case 5: return 11
        case 6: return 13
        case 7: return 15
        case 8: return 18
        case 9: return 4
        default: return nil   // ring 1 holds
        }
    }

    /// 0 → 1 → 0 across one period, eased like CSS `ease-in-out` breath.
    static func phase(at t: TimeInterval, period: Double) -> Double {
        guard period > 0 else { return 0 }
        return (1 - cos(2 * .pi * t / period)) / 2
    }
}

// MARK: - The staged arrival

/// The Rite's nine beats (`living-rite-today.jsx`'s `fade(delay)`), keyed by
/// what arrives rather than by where it sits: in fire's ascension the prompt
/// stands above her name, but her name still arrives first.
enum ArrivalBeat: Int, CaseIterable {
    case strip, kicker, name, phon, know, rule, quality, prompt, foot

    /// Seconds after arrival begins.
    var delay: Double {
        switch self {
        case .strip:   return 0.10
        case .kicker:  return 0.25
        case .name:    return 0.40
        case .phon:    return 0.55
        case .know:    return 0.70
        case .rule:    return 0.80
        case .quality: return 0.90
        case .prompt:  return 1.05
        case .foot:    return 1.25
        }
    }

    init(_ block: RiteBlock) {
        switch block {
        case .kicker:          self = .kicker
        case .name, .nameSmall: self = .name
        case .phon:            self = .phon
        case .know:            self = .know
        case .rule:            self = .rule
        case .quality:         self = .quality
        case .prompt:          self = .prompt
        }
    }
}

enum StagedArrival {
    /// Each beat: `opacity 1.3s ease, transform 1.3s ease`, rising 10 pt.
    static let duration: Double = 1.3
    static let rise: CGFloat = 10
    /// The sigil comes up under the words: `opacity 2.4s ease 0.2s`.
    static let sigilDelay: Double = 0.2
    static let sigilDuration: Double = 2.4
    /// The gap before arrival begins (the prototype's 60 ms `setTimeout`).
    static let lead: Double = 0.06

    /// When the whole arrival has finished standing up.
    static var settled: Double {
        max(ArrivalBeat.foot.delay + duration, sigilDelay + sigilDuration)
    }

    /// CSS `ease` — cubic-bezier(0.25, 0.1, 0.25, 1).
    static func ease(duration: Double, delay: Double) -> Animation {
        .timingCurve(0.25, 0.1, 0.25, 1, duration: duration).delay(delay)
    }
}

extension View {
    /// One beat of a staged arrival: fade up and rise into place after `delay`.
    /// `still` (reduce motion) puts it in place with no movement at all.
    func arrives(_ arrived: Bool, after delay: Double, still: Bool,
                 duration: Double = StagedArrival.duration,
                 rise: CGFloat = StagedArrival.rise) -> some View {
        self
            .opacity(arrived ? 1 : 0)
            .offset(y: (arrived || still) ? 0 : rise)
            .animation(still ? nil : StagedArrival.ease(duration: duration, delay: delay), value: arrived)
    }
}
