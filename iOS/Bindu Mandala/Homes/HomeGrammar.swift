import Foundation

// MARK: - The grammar
//
// Ported from `Claude Design Round 2/homes/homes-grammar.js`.
//
// This is the layer that makes a room **hers** rather than anyone else's. Her
// ring gives the archetype; her own Airtable fields tune it — her tattva sets
// the physics, her bodily location sets the altitude, her khaḍgamālā position
// sets the phase, so no two neighbours move alike.
//
//   ring 1 · Siddhis / Mātṛkās / Mudrās  → three families, split by position
//   ring 2 · the Karṣiṇīs                → CROSSED
//   ring 3 · the Anaṅgas                 → BODILESS   effect with no source
//   ring 4 · Sampradāya                  → COSMIC     one gesture, world-scale
//   ring 5 · Kulottīrṇa                  → GIVING     something arrives
//   ring 6 · Nigarbha                    → REVEALING  the veil thins
//   ring 7 · Vāsinīs                     → SOUNDING   the room is her syllable
//   ring 8 · the Triad                   → SOURCING   will, act, form
//   ring 9 · the Bindu                   → no grammar archetype; authored
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THIS FILE IS, AND IS NOT
// ─────────────────────────────────────────────────────────────────────────────
//
// **Pure logic only.** No SceneKit, no SwiftUI, no geometry, no shaders. The
// renderer ruling (charter §2.4) decides how a room is *drawn*; it does not
// touch what a room *is*. Everything here — the classifier, the displacement
// kernel, the archetype formulas, the altitude curve, the family dispatch and
// the label composition — ports one-to-one and is drawable either way.
//
// **No bundled roster.** Design's JavaScript carries its own 102-card file
// because it could not reach Airtable; the app can. Every input here is read
// from ``Shakti`` — `tattva`, `quality`, `bodilyLocation`, `bija`,
// `khadgamalaPosition`, `ringNumber` — which the sync fills from the base.
// There is deliberately no `SYLLABLE`, no `CROSSED` and no `ATTRIBUTE` table in
// this file: those are Design's stand-ins for the base, and copying them would
// be the ghost-roster the laws exist to prevent.
//
// **Position is identity.** Every formula below keys off `khadgamalaPosition`
// 1–102 and nothing else.
//
// **Never measure.** No composed label carries a number, and nothing here reads
// a visit count, a streak or a percentage. The only clock it knows is the
// chamber clock of the *current* stay.

// MARK: - Her physics

/// How a thing moves in her room. Read from her tattva, never chosen.
///
/// Fifty kinds plus ``breathe``, which is the classifier's fall-through. An
/// audit of Design's first pass found 78 of 102 rooms falling through to that
/// one generic motion — the classifier knew a dozen words where the cards speak
/// a whole vocabulary. The fifty rules below read the five elements, the three
/// powers, the senses and the recurring principles, so a room's motion comes
/// from *her* tattva rather than from a default.
enum HomePhysics: String, CaseIterable, Equatable {
    case arrest, expand, widen, shrink, flow, well, settle, flare, lift, open
    case stir, draw, waver, merge, dart, encircle, point, reach, trace, dissolve
    case fill, compress, spring, sustain, sound, clarify, assert, lean, swell, ground
    case incline, arrive, bloom, recur, call, turn, persist, land, stand, rest
    case thread, rise, align, brighten, unbind, mend, tint, converge, centre, surge
    /// The fall-through. Never a rule's verdict — only the absence of one.
    case breathe
}

/// A three-axis offset, in the room's own units. The renderer decides what a
/// unit is; the grammar decides where the thing goes.
struct HomeOffset: Equatable {
    var x: Double
    var y: Double
    var z: Double

    static let zero = HomeOffset(x: 0, y: 0, z: 0)
}

// MARK: - Her archetype

/// What kind of room hers is. Her ring gives it; Ring 1 splits three ways.
enum HomeArchetype: String, CaseIterable, Equatable {
    // Ring 1 · three families
    case siddhi, matrka, mudra
    // Ring 2
    case crossed
    // Rings 3–8
    case bodiless, cosmic, giving, revealing, sounding, sourcing
}

// MARK: - Her words

/// The two things a room can say: what it says while the eye is still settling,
/// and what it says once the second adaptation has arrived and the room has
/// reversed its own premise.
///
/// Both read as language. Neither ever carries a number — see
/// ``HomeGrammar/secondAdaptationSwitch`` and `HomeGrammarTests`.
struct HomeLabel: Equatable {
    /// Before the switch: her quality, spoken in the room's own voice.
    let near: String
    /// After it: the room's premise, reversed.
    let deep: String

    /// Which of the two the room is saying, at a given depth.
    func text(deepProgress: Double) -> String {
        deepProgress > HomeGrammar.secondAdaptationSwitch ? deep : near
    }
}

// MARK: - The grammar itself

enum HomeGrammar {

    // MARK: · The physics classifier

    /// One rule of the classifier. `js` is the literal as `homes-grammar.js`
    /// writes it, kept beside the port so drift is visible on sight.
    struct PhysicsRule {
        let js: String
        let pattern: String
        let kind: HomePhysics
    }

    /// **The order is load-bearing.** First match wins, and Design's ordering is
    /// a set of deliberate priorities, not a tidy list: `source` fires before
    /// `icch`, so a Śakti whose tattva names both the will and the source
    /// resolves to ``HomePhysics/spring`` and not to ``HomePhysics/incline``.
    /// That is why kp 99 and kp 101 land in the same physics.
    ///
    /// A reordering that looks tidier is a silent behaviour change. If this
    /// array is ever re-sorted, `testTheRuleOrderIsLoadBearing` fails, and it is
    /// the sort that is wrong.
    ///
    /// The patterns carry no `/i`: Design's classifier lowercases its input
    /// first (see ``physics(tattva:quality:)``), and the port does the same.
    static let physicsRules: [PhysicsRule] = [
        PhysicsRule(js: #"/stambha|paralyz|cosmic stillness/"#,
                    pattern: #"stambha|paralyz|cosmic stillness"#, kind: .arrest),
        PhysicsRule(js: #"/vik[āa]sa|jṛmbha|yawn|expansion/"#,
                    pattern: #"vik[āa]sa|jṛmbha|yawn|expansion"#, kind: .expand),
        PhysicsRule(js: #"/mahat|vastness/"#,
                    pattern: #"mahat|vastness"#, kind: .widen),
        PhysicsRule(js: #"/aṇu|atomic|smallness/"#,
                    pattern: #"aṇu|atomic|smallness"#, kind: .shrink),
        PhysicsRule(js: #"/dravat|liquef|melting|fluid/"#,
                    pattern: #"dravat|liquef|melting|fluid"#, kind: .flow),
        PhysicsRule(js: #"/apaḥ|\bjala\b|water/"#,
                    pattern: #"apaḥ|\bjala\b|water"#, kind: .well),
        PhysicsRule(js: #"/pṛthiv|pṛthv|bh[ūu]mi|earth|weighted/"#,
                    pattern: #"pṛthiv|pṛthv|bh[ūu]mi|earth|weighted"#, kind: .settle),
        PhysicsRule(js: #"/tejas|agni|\bfire\b|fierce/"#,
                    pattern: #"tejas|agni|\bfire\b|fierce"#, kind: .flare),
        PhysicsRule(js: #"/v[āa]yu|\bair\b|lightness/"#,
                    pattern: #"v[āa]yu|\bair\b|lightness"#, kind: .lift),
        PhysicsRule(js: #"/[āa]k[āa][śs]a|\bkhe\b|ether|sky|void|freedom/"#,
                    pattern: #"[āa]k[āa][śs]a|\bkhe\b|ether|sky|void|freedom"#, kind: .open),
        PhysicsRule(js: #"/kṣobha|agitat|stir/"#,
                    pattern: #"kṣobha|agitat|stir"#, kind: .stir),
        PhysicsRule(js: #"/[āa]karṣaṇa|karṣaṇa|magnet|attract/"#,
                    pattern: #"[āa]karṣaṇa|karṣaṇa|magnet|attract"#, kind: .draw),
        PhysicsRule(js: #"/moha|bewilder|unm[āa]da|intoxicat|\bmada\b/"#,
                    pattern: #"moha|bewilder|unm[āa]da|intoxicat|\bmada\b"#, kind: .waver),
        PhysicsRule(js: #"/advaita|non-dual/"#,
                    pattern: #"advaita|non-dual"#, kind: .merge),
        PhysicsRule(js: #"/vega|veloc|impulse|lightning|kriy[āa]/"#,
                    pattern: #"vega|veloc|impulse|lightning|kriy[āa]"#, kind: .dart),
        PhysicsRule(js: #"/p[āa][śs]a|\bbind\b|mekhal|embrace|encircl|rakṣa|protect/"#,
                    pattern: #"p[āa][śs]a|\bbind\b|mekhal|embrace|encircl|rakṣa|protect"#, kind: .encircle),
        PhysicsRule(js: #"/aṅku[śs]a|goad|hook|direct/"#,
                    pattern: #"aṅku[śs]a|goad|hook|direct"#, kind: .point),
        PhysicsRule(js: #"/virah|longing|separation/"#,
                    pattern: #"virah|longing|separation"#, kind: .reach),
        PhysicsRule(js: #"/rekh|outline|suggest/"#,
                    pattern: #"rekh|outline|suggest"#, kind: .trace),
        PhysicsRule(js: #"/pralaya|kṣaya|\blaya\b|vin[āa][śs]|dissolution|liberation/"#,
                    pattern: #"pralaya|kṣaya|\blaya\b|vin[āa][śs]|dissolution|liberation"#, kind: .dissolve),
        PhysicsRule(js: #"/p[ūu]rṇa|sampat|abundance|fullness|wholeness/"#,
                    pattern: #"p[ūu]rṇa|sampat|abundance|fullness|wholeness"#, kind: .fill),
        PhysicsRule(js: #"/b[īi]ja|seed|potential/"#,
                    pattern: #"b[īi]ja|seed|potential"#, kind: .compress),
        // ── `source` fires HERE, and `icch` only nine rules later. ──────────
        PhysicsRule(js: #"/yoni|source|bhaga/"#,
                    pattern: #"yoni|source|bhaga"#, kind: .spring),
        PhysicsRule(js: #"/sthiti|sustenance|preserv/"#,
                    pattern: #"sthiti|sustenance|preserv"#, kind: .sustain),
        PhysicsRule(js: #"/v[āa]c|[śs]abda|mantra|speech|sound/"#,
                    pattern: #"v[āa]c|[śs]abda|mantra|speech|sound"#, kind: .sound),
        PhysicsRule(js: #"/jñ[āa]na|buddhi|sarvajñ|knowing|knowledge|insight/"#,
                    pattern: #"jñ[āa]na|buddhi|sarvajñ|knowing|knowledge|insight"#, kind: .clarify),
        PhysicsRule(js: #"/ahaṅk[āa]ra|\bego\b|i-mak/"#,
                    pattern: #"ahaṅk[āa]ra|\bego\b|i-mak"#, kind: .assert),
        PhysicsRule(js: #"/[śs]rotra|tvak|cakṣus|jihv|ghr[āa]ṇa|indriya|sense|touch|taste|scent|form\b/"#,
                    pattern: #"[śs]rotra|tvak|cakṣus|jihv|ghr[āa]ṇa|indriya|sense|touch|taste|scent|form\b"#, kind: .lean),
        PhysicsRule(js: #"/[āa]nanda|bliss|joy|āhl[āa]da/"#,
                    pattern: #"[āa]nanda|bliss|joy|āhl[āa]da"#, kind: .swell),
        PhysicsRule(js: #"/[āa]dh[āa]ra|support|foundation/"#,
                    pattern: #"[āa]dh[āa]ra|support|foundation"#, kind: .ground),
        // ── …and `icch` HERE, which is why the ordering cannot be sorted. ───
        PhysicsRule(js: #"/icch|saṅkalpa|\bwill\b|willing/"#,
                    pattern: #"icch|saṅkalpa|\bwill\b|willing"#, kind: .incline),
        PhysicsRule(js: #"/siddhi|phala|pr[āa]pti|attain|fulfil|accomplish/"#,
                    pattern: #"siddhi|phala|pr[āa]pti|attain|fulfil|accomplish"#, kind: .arrive),
        PhysicsRule(js: #"/saundarya|sundarat|puṣpa|beauty|adornment/"#,
                    pattern: #"saundarya|sundarat|puṣpa|beauty|adornment"#, kind: .bloom),
        PhysicsRule(js: #"/smṛti|smaraṇa|memory|recollect/"#,
                    pattern: #"smṛti|smaraṇa|memory|recollect"#, kind: .recur),
        PhysicsRule(js: #"/n[āa]ma|\bname\b/"#,
                    pattern: #"n[āa]ma|\bname\b"#, kind: .call),
        PhysicsRule(js: #"/[āa]tm|\bself\b|witness/"#,
                    pattern: #"[āa]tm|\bself\b|witness"#, kind: .turn),
        PhysicsRule(js: #"/amṛta|deathless|immortal|upastha/"#,
                    pattern: #"amṛta|deathless|immortal|upastha"#, kind: .persist),
        PhysicsRule(js: #"/[śs]ar[īi]ra|\bmanas\b|\bbody\b/"#,
                    pattern: #"[śs]ar[īi]ra|\bmanas\b|\bbody\b"#, kind: .land),
        PhysicsRule(js: #"/dhairya|courage|steadi|fortitude/"#,
                    pattern: #"dhairya|courage|steadi|fortitude"#, kind: .stand),
        PhysicsRule(js: #"/citta|mind-sub/"#,
                    pattern: #"citta|mind-sub"#, kind: .rest),
        PhysicsRule(js: #"/\bkula\b|lineage/"#,
                    pattern: #"\bkula\b|lineage"#, kind: .thread),
        PhysicsRule(js: #"/[īi][śs]vara|ai[śs]varya|sovereign|lordship/"#,
                    pattern: #"[īi][śs]vara|ai[śs]varya|sovereign|lordship"#, kind: .rise),
        PhysicsRule(js: #"/saṃyama|integrat|va[śs]ya|yield/"#,
                    pattern: #"saṃyama|integrat|va[śs]ya|yield"#, kind: .align),
        PhysicsRule(js: #"/maṅgala|auspicious/"#,
                    pattern: #"maṅgala|auspicious"#, kind: .brighten),
        PhysicsRule(js: #"/duḥkha|p[āa]pa|sorrow|error|obstacle|vighna/"#,
                    pattern: #"duḥkha|p[āa]pa|sorrow|error|obstacle|vighna"#, kind: .unbind),
        PhysicsRule(js: #"/[āa]rogya|healing|whole/"#,
                    pattern: #"[āa]rogya|healing|whole"#, kind: .mend),
        PhysicsRule(js: #"/rañjana|colour|color|aesthetic/"#,
                    pattern: #"rañjana|colour|color|aesthetic"#, kind: .tint),
        PhysicsRule(js: #"/tri-eka|three-as-one|trinity/"#,
                    pattern: #"tri-eka|three-as-one|trinity"#, kind: .converge),
        PhysicsRule(js: #"/para-bindu|totality|source-beauty/"#,
                    pattern: #"para-bindu|totality|source-beauty"#, kind: .centre),
        PhysicsRule(js: #"/[śs]akti|s[āa]marthya|power|capacity/"#,
                    pattern: #"[śs]akti|s[āa]marthya|power|capacity"#, kind: .surge),
    ]

    /// The fifty, compiled, in order. A pattern that fails to compile is simply
    /// absent, which `testTheClassifierIsWhole` turns into a loud failure
    /// rather than a crash at static-initialisation time.
    static let compiledPhysicsRules: [(rule: PhysicsRule, regex: NSRegularExpression)] =
        physicsRules.compactMap { rule in
            guard let re = try? NSRegularExpression(pattern: rule.pattern, options: []) else { return nil }
            return (rule: rule, regex: re)
        }

    /// Her tattva, read for physics. Not decoration — it decides how things move.
    ///
    /// Design's `physics(card)`: the tattva and the quality are joined with a
    /// space, lowercased, and matched against the rules in order. **First match
    /// wins**, and ``HomePhysics/breathe`` is the fall-through.
    static func physics(tattva: String, quality: String) -> HomePhysics {
        let subject = (tattva + " " + quality).lowercased()
        let range = NSRange(subject.startIndex..<subject.endIndex, in: subject)
        for entry in compiledPhysicsRules
        where entry.regex.firstMatch(in: subject, options: [], range: range) != nil {
            return entry.rule.kind
        }
        return .breathe
    }

    // MARK: · The displacement kernel

    /// How her physics moves a thing, in her own phase.
    ///
    /// A pure function of `(kind, time, phase, amplitude)` — the same four
    /// inputs always give the same offset, and nothing here reads the clock, the
    /// memory or the walker. `time` is the **chamber clock of this stay**, in
    /// seconds; `phase` is a turn 0–1; `amplitude` is the room's own scale.
    static func displace(_ kind: HomePhysics,
                         time t: Double,
                         phase: Double,
                         amplitude amp: Double) -> HomeOffset {
        let p = phase * .pi * 2
        func s(_ f: Double) -> Double { sin(t * f + p) }
        func c(_ f: Double) -> Double { cos(t * f + p) }
        func pulse(_ f: Double) -> Double { abs(sin(t * f + p)) }
        func o(_ x: Double, _ y: Double, _ z: Double) -> HomeOffset { HomeOffset(x: x, y: y, z: z) }

        switch kind {
        case .arrest:   return o(0, 0, 0)
        case .expand:   return o(0, s(0.09) * amp * 1.6, 0)
        case .widen:    return o(s(0.06) * amp * 2.2, 0, c(0.06) * amp * 2.2)
        case .shrink:   return o(s(0.14) * amp * 0.2, 0, pulse(0.1) * -amp * 1.4)
        case .flow:     return o(s(0.21) * amp, s(0.13) * amp * 0.5, 0)
        case .well:     return o(0, pulse(0.11) * amp * 1.5, 0)
        case .settle:   return o(0, -pulse(0.07) * amp * 1.3, 0)
        case .flare:    return o(s(0.6) * amp * 0.4, pulse(0.5) * amp * 0.9, 0)
        case .lift:     return o(s(0.12) * amp * 0.4, (0.5 + 0.5 * s(0.1)) * amp * 1.7, 0)
        case .open:     return o(s(0.05) * amp * 1.8, c(0.04) * amp * 1.2, s(0.045) * amp * 1.8)
        case .stir:     return o(c(0.42) * amp, s(0.51) * amp * 0.4, s(0.33) * amp)
        case .draw:     return o(0, 0, s(0.11) * amp * 1.4)
        case .waver:    return o(s(0.16) * amp * 1.3, s(0.09) * amp * 0.6, 0)
        case .merge:    return o(-s(0.08) * amp * 0.3, 0, 0)
        case .dart:     return o(s(0.9) * amp * 0.5, 0, s(1.3) * amp * 0.4)
        case .encircle: return o(c(0.24) * amp, 0, s(0.24) * amp)
        case .point:    return o(0, 0, -pulse(0.17) * amp)
        case .reach:    return o(0, pulse(0.13) * amp * 1.2, -pulse(0.13) * amp)
        case .trace:    return o(s(0.19) * amp * 1.5, c(0.19) * amp * 0.7, 0)
        case .dissolve: return o(s(0.3) * amp * 0.6, -pulse(0.09) * amp * 0.8, c(0.27) * amp * 0.6)
        case .fill:     return o(0, (0.5 + 0.5 * s(0.055)) * amp * 1.4, 0)
        case .compress: return o(s(0.2) * amp * 0.15, 0, -pulse(0.06) * amp * 0.5)
        case .spring:   return o(0, pulse(0.16) * amp * 1.8, -pulse(0.16) * amp * 0.5)
        case .sustain:  return o(0, s(0.045) * amp * 0.35, 0)
        case .sound:    return o(0, s(1.6) * amp * 0.3 + s(0.2) * amp * 0.5, 0)
        case .clarify:  return o(s(0.1) * amp * 0.25, 0, -(0.5 + 0.5 * s(0.08)) * amp)
        case .assert:   return o(0, pulse(0.19) * amp * 0.9, pulse(0.19) * amp * 0.5)
        case .lean:     return o(s(0.13) * amp * 1.1, 0, -pulse(0.13) * amp * 0.7)
        case .swell:    return o(s(0.07) * amp * 0.8, (0.5 + 0.5 * c(0.07)) * amp, s(0.07) * amp * 0.8)
        case .ground:   return o(0, -amp * 0.5 - pulse(0.04) * amp * 0.3, 0)
        case .incline:  return o(s(0.1) * amp * 0.5, s(0.1) * amp * 0.4, -pulse(0.1) * amp * 0.9)
        case .arrive:   return o(0, 0, -amp * (0.5 + 0.5 * s(0.075)))
        case .bloom:    return o(c(0.09) * amp * 1.3, pulse(0.09) * amp * 0.5, s(0.09) * amp * 1.3)
        case .recur:    return o(s(0.24) * amp * 0.9, 0, s(0.12) * amp * 0.9)
        case .call:     return o(0, s(0.3) * amp * 0.4, -s(0.15) * amp * 1.1)
        case .turn:     return o(c(0.055) * amp * 1.2, 0, s(0.055) * amp * 1.2)
        case .persist:  return o(0, s(0.033) * amp * 0.5, 0)
        case .land:     return o(0, -(0.5 + 0.5 * c(0.06)) * amp * 1.2, 0)
        case .stand:    return o(0, s(0.03) * amp * 0.18, 0)
        case .rest:     return o(s(0.04) * amp * 0.3, s(0.035) * amp * 0.2, 0)
        case .thread:   return o(s(0.1) * amp * 0.6, c(0.05) * amp * 0.4, s(0.2) * amp * 0.8)
        case .rise:     return o(0, (0.5 + 0.5 * s(0.05)) * amp * 1.5, 0)
        case .align:    return o(s(0.12) * amp * (0.5 + 0.5 * c(0.03)), 0, 0)
        case .brighten: return o(0, s(0.11) * amp * 0.6, 0)
        case .unbind:   return o(s(0.17) * amp * 1.2, pulse(0.085) * amp * 0.7, 0)
        case .mend:     return o(s(0.14) * amp * 0.5, s(0.07) * amp * 0.5, s(0.21) * amp * 0.5)
        case .tint:     return o(s(0.18) * amp * 0.9, c(0.14) * amp * 0.9, 0)
        case .converge: return o(c(0.1) * amp * (1 - pulse(0.05)), s(0.1) * amp * (1 - pulse(0.05)), 0)
        case .centre:   return o(0, 0, 0)
        case .surge:    return o(0, pulse(0.28) * amp * 1.3, 0)
        // Design's `default`. In Swift the fall-through has a name, so the
        // switch is exhaustive and a new kind cannot be forgotten.
        case .breathe:  return o(0, s(0.14) * amp * 0.7, 0)
        }
    }

    /// The two kinds that do not move at all: her physics is stillness, and
    /// stillness is not a missing case. `testTheKernelIsAPureFunction` holds
    /// this set, so a hand that quietly zeroes a third one is caught.
    static let stillKinds: Set<HomePhysics> = [.arrest, .centre]

    // MARK: · Her altitude

    /// One zone of the body, and where in the room it puts her.
    struct BodyZone {
        let js: String
        let pattern: String
        let altitude: Double
    }

    /// Design's `ZONES`, in order, carrying `/i`. **First match wins**, and here
    /// too the order decides: "between the eyes" reaches the *eyes* rule before
    /// it reaches the *third eye* one, so it sits at 0.26 rather than 0.20.
    /// That is Design's reading, not a slip, and the test pins it.
    static let bodyZones: [BodyZone] = [
        // The one place Design's literal is widened, and only by a
        // transliteration: the base writes `Mūlādhāra` with its diacritics, but
        // an un-diacritic'd row must not silently fall to the middle of the
        // body. Carried over from the attribute layer when the two zone tables
        // were unified into this one.
        BodyZone(js: #"/soles|feet|mūlādhāra/i"#,
                 pattern: #"soles|feet|mūlādhāra|muladhara"#, altitude: 0.94),
        BodyZone(js: #"/belly|navel|yoni|abundance/i"#,
                 pattern: #"belly|navel|yoni|abundance"#, altitude: 0.66),
        BodyZone(js: #"/solar plexus/i"#,
                 pattern: #"solar plexus"#, altitude: 0.6),
        BodyZone(js: #"/waist/i"#,
                 pattern: #"waist"#, altitude: 0.68),
        BodyZone(js: #"/diaphragm/i"#,
                 pattern: #"diaphragm"#, altitude: 0.56),
        BodyZone(js: #"/sternum|chest|heart/i"#,
                 pattern: #"sternum|chest|heart"#, altitude: 0.46),
        BodyZone(js: #"/throat|palate|mouth/i"#,
                 pattern: #"throat|palate|mouth"#, altitude: 0.34),
        BodyZone(js: #"/behind the eyes|eyes|face/i"#,
                 pattern: #"behind the eyes|eyes|face"#, altitude: 0.26),
        BodyZone(js: #"/forehead|third eye|between the eyes/i"#,
                 pattern: #"forehead|third eye|between the eyes"#, altitude: 0.2),
        BodyZone(js: #"/crown|above/i"#,
                 pattern: #"crown|above"#, altitude: 0.1),
        BodyZone(js: #"/spine|whole body|whole field|cellular|totality|converge/i"#,
                 pattern: #"spine|whole body|whole field|cellular|totality|converge"#, altitude: 0.5),

        // ── the words the shipped rows actually speak ───────────────────────
        //
        // **Appended, never interleaved.** Design's eleven are its own reading
        // and are untouched; every one of these stands behind all eleven, so no
        // location that resolved before resolves anywhere else now. "Forehead"
        // still reaches the brow before it reaches `head`, and "above the head"
        // still reaches the crown.
        //
        // They are here because Design's `ZONES` were written against Design's
        // own card vocabulary — *"Forehead, eyes"*, *"Solar plexus, shoulders"*,
        // *"Bridge of the nose"* — and the base does not write its rows that way.
        // `Shakti.bodilyLocation` on the sixteen that actually ship says `head`,
        // `solar`, `ears`, `skin`, `tongue`, `nose`, `temples`, `sacrum`. Against
        // Design's eleven, **eleven of the sixteen Karṣiṇīs fell to the middle of
        // the body** — which is to say her mark sat at exactly the same height in
        // eleven of the home ring's rooms, and the eye inclined the same way in
        // all of them. Altitude is one of the five channels that make a room hers
        // (handoff §4.3) and it was carrying nothing across most of Ring 2.
        //
        // Each altitude is interpolated between zones Design already fixed rather
        // than invented: the crown at 0.10, the brow at 0.20, the eyes at 0.26,
        // the mouth at 0.34, the chest at 0.46, the solar plexus at 0.60, the
        // waist at 0.68 and the soles at 0.94.
        //
        // `skin` is deliberately **not** here. Sparśā is felt wherever skin meets
        // world — palms, lips, soles — and a location that is everywhere resolves
        // to the middle. That is the honest reading, and it is the one the
        // fall-through already gives, so a rule saying it again would only make
        // the table longer.
        //
        // The world regions' two gaps are also untouched: nothing here matches
        // `Pelvis`, and `Above crown` still reaches `crown|above` first.
        // `testTheWorldRegionVocabularyHasTwoGaps` holds both.

        /// The base writes the solar plexus with its first word only.
        BodyZone(js: #"/solar/i"#, pattern: #"solar"#, altitude: 0.6),
        /// The head as a whole, which is neither the crown nor the face: the
        /// midpoint of Design's crown (0.10) and mouth (0.34).
        BodyZone(js: #"/\bhead\b/i"#, pattern: #"\bhead\b"#, altitude: 0.22),
        /// The temple sits at the outer brow, between Design's brow and eyes.
        BodyZone(js: #"/temple/i"#, pattern: #"temple"#, altitude: 0.23),
        /// The bridge of the nose, just under the eyes.
        BodyZone(js: #"/\bnose\b|nostril/i"#, pattern: #"\bnose\b|nostril"#, altitude: 0.28),
        /// The ear canal, between the eyes and the mouth.
        BodyZone(js: #"/\bears?\b|skull/i"#, pattern: #"\bears?\b|skull"#, altitude: 0.3),
        /// The tongue is in the mouth, and takes the mouth's own height rather
        /// than a new one.
        BodyZone(js: #"/tongue/i"#, pattern: #"tongue"#, altitude: 0.34),
        /// The base of the spine, above the pelvic floor: between Design's waist
        /// (0.68) and the mūlādhāra (0.94).
        BodyZone(js: #"/sacrum|sacral/i"#, pattern: #"sacrum|sacral"#, altitude: 0.8),
    ]

    static let compiledBodyZones: [(zone: BodyZone, regex: NSRegularExpression)] =
        bodyZones.compactMap { zone in
            guard let re = try? NSRegularExpression(pattern: zone.pattern, options: [.caseInsensitive])
            else { return nil }
            return (zone: zone, regex: re)
        }

    /// Where on the body she lives, as `0` at the crown and `1` at the soles.
    ///
    /// Driven off `Shakti.bodilyLocation`. A location the vocabulary does not
    /// know sits at the middle — the same place the spine and the whole body
    /// sit, which is the honest answer rather than a guess.
    static func bodyAltitude(bodilyLocation: String) -> Double {
        let range = NSRange(bodilyLocation.startIndex..<bodilyLocation.endIndex, in: bodilyLocation)
        for entry in compiledBodyZones
        where entry.regex.firstMatch(in: bodilyLocation, options: [], range: range) != nil {
            return entry.zone.altitude
        }
        return 0.5
    }

    /// Her height in the room. The near rings stand a little taller.
    ///
    /// Design: `(0.5 - alt) * 9` in rings 1–3, `* 8` everywhere else.
    static func altitude(ring: Int, bodyAltitude alt: Double) -> Double {
        (0.5 - alt) * ((1...3).contains(ring) ? 9 : 8)
    }

    // MARK: · The family dispatch

    /// Ring 1's three families, split by khaḍgamālā position.
    /// Design's `R1_FAMILY`: up to 10 Siddhi, up to 18 Mātṛkā, else Mudrā.
    static func ringOneFamily(position pos: Int) -> HomeArchetype {
        pos <= 10 ? .siddhi : (pos <= 18 ? .matrka : .mudra)
    }

    /// What kind of room hers is.
    ///
    /// Ring 9 — the Bindu — has **no grammar archetype**. Her room is authored,
    /// and resolves elsewhere; `nil` here is the grammar declining to speak for
    /// her, not a gap.
    static func archetype(ring: Int, position pos: Int) -> HomeArchetype? {
        switch ring {
        case 1: return ringOneFamily(position: pos)
        case 2: return .crossed
        case 3: return .bodiless
        case 4: return .cosmic
        case 5: return .giving
        case 6: return .revealing
        case 7: return .sounding
        case 8: return .sourcing
        default: return nil
        }
    }

    // MARK: · The per-archetype formulas

    /// How many steps around her archetype's turn. Her position takes one of
    /// them, so no two neighbours move alike.
    ///
    /// `nil` where the archetype gives no per-Śakti phase: SOUNDING phases its
    /// nodes by their own index within her mode, and SOURCING by which of the
    /// three corners is lit.
    static func phaseDivisor(for archetype: HomeArchetype) -> Int? {
        switch archetype {
        case .bodiless, .matrka:                      return 8
        case .cosmic:                                 return 14
        case .giving, .revealing, .siddhi, .mudra:    return 10
        case .crossed:                                return 16
        case .sounding, .sourcing:                    return nil
        }
    }

    /// Design's `(card.pos % N) / N` — her turn of her archetype's cycle.
    static func phase(archetype: HomeArchetype, position pos: Int) -> Double? {
        guard let n = phaseDivisor(for: archetype) else { return nil }
        return Double(mod(pos, n)) / Double(n)
    }

    /// RING 7 · her row's mode number — how many standing waves the wall holds.
    /// Design: `2 + (card.pos % 8)`.
    static func soundingMode(position pos: Int) -> Int { 2 + mod(pos, 8) }

    /// RING 1 · MĀTṚKĀ — how many letters her row governs.
    /// Design: `5 + ((card.pos - 11) % 4) * 3`.
    static func matrkaLetterCount(position pos: Int) -> Int { 5 + mod(pos - 11, 4) * 3 }

    /// RING 8 · SOURCING — which corner of the innermost triangle is hers.
    /// Design: `card.pos - 99` — `0` icchā, `1` kriyā, `2` jñāna.
    static func sourcingCorner(position pos: Int) -> Int { pos - 99 }

    /// A modulo that stays non-negative, so a position outside an archetype's
    /// own band still yields a phase in `0..<1` rather than a negative turn.
    /// Inside the bands Design uses, it is identical to JavaScript's `%`.
    static func mod(_ a: Int, _ n: Int) -> Int {
        guard n != 0 else { return 0 }
        let r = a % n
        return r < 0 ? r + abs(n) : r
    }

    // MARK: · The chamber clock

    /// Where the switch sits: past the second adaptation, and nowhere near a
    /// number the walker can see.
    static let secondAdaptationSwitch: Double = 0.45

    /// Design's `smooth` — `clamp01` then smoothstep.
    static func smooth(_ t: Double) -> Double {
        let x = min(1, max(0, t))
        return x * x * (3 - 2 * x)
    }

    /// Design's `deep(t)`: how far into the second adaptation this stay has
    /// come, `0`–`1`, on the chamber clock of the current visit.
    ///
    /// The marks come from ``HomeMemory`` — `HOLD_END` and the span to
    /// `SECOND_END` — so the grammar and the memory cannot drift apart.
    static func deepProgress(chamberTime t: Double) -> Double {
        let span = HomeMemory.secondAdaptationEnd - HomeMemory.holdEnd
        return smooth((t - HomeMemory.holdEnd) / span)
    }

    /// Design's `k = smooth(t / 62)`: the first adaptation's own ramp — the eye
    /// settling, before anything reverses.
    static func settling(chamberTime t: Double) -> Double {
        smooth(t / HomeMemory.firstAdaptation)
    }

    // MARK: · Her words

    /// The tag that follows the middle dot: what this kind of room is, said in
    /// the room's own voice, and what it says instead once the premise reverses.
    ///
    /// `bija` is her seed syllable where she carries one — read from the base
    /// via `Shakti.bijaSyllable`, never from a bundled table. Most of the 102
    /// carry none, and the tag then falls back to Design's own words.
    static func tag(for archetype: HomeArchetype,
                    position pos: Int,
                    bija: String? = nil,
                    quality: String = "",
                    tattva: String = "") -> (near: String, deep: String) {
        switch archetype {
        case .siddhi:
            return ("lent, not shown", "the capacity was never lent")
        case .matrka:
            return (bija ?? "the mouth before sound",
                    "the letters were never separate from the voice")
        case .mudra:
            return ("a seal you stand inside", "the seal has opened its hand")
        case .crossed:
            // The key pairing, marked as such in the base: at kp 44 the body
            // and the mind are the crossing, so her reversal names them.
            //
            // Everywhere else in the ring the reversal is **read off her own
            // row**: the faculty she draws out of her quality, the thing she is
            // given out of her tattva. Design writes the same sentence from a
            // `CROSSED` table of its own — `34: ['form','ear']`, and so on — and
            // that table cannot be ported, because it is keyed to Design's card
            // tattvas and the base's are different ones. A bundled copy of it
            // would be the ghost roster law 1 exists to prevent, and it would be
            // a *wrong* ghost: Design's card gives Rūpā the ear, and the row the
            // app actually syncs gives her fire.
            //
            // Without this, fifteen of the sixteen say the same thing at the one
            // moment the room turns over — which is the home ring reversing into
            // one sentence, whoever the walker came to see.
            if pos == crossingKeyPosition { return (crossingNear, "body and mind were one point") }
            guard let crossed = crossing(quality: quality, tattva: tattva) else {
                return (crossingNear, "the drawing and the drawn are one")
            }
            // Design's own shape — `the ${near} and the ${far} were one sense` —
            // without its last word. Design's crossings are a faculty and a sense
            // organ, so "sense" is true of every one of them; the base's are a
            // faculty and an element, and calling earth a sense would be the
            // sentence saying something the row does not.
            return (crossingNear, "the \(crossed.faculty) and the \(crossed.organ) were one")
        case .bodiless:
            return ("and nothing there to feel", "the effect was the only body")
        case .cosmic:
            return ("at the scale of worlds", "the gesture had no centre to leave")
        case .giving:
            return ("arriving, unasked", "the giving and the given are one")
        case .revealing:
            return ("already here, behind the veil", "it was never hidden · you were the veil")
        case .sounding:
            return (bija ?? "the room is her sound", "you are inside the syllable")
        case .sourcing:
            let corner = sourcingCorner(position: pos)
            let near = ["will, before there is anything to will",
                        "the act, before there is a deed",
                        "form, before there is a thing"]
            let deep = ["will was already act and form",
                        "the act was already will and form",
                        "form was already will and act"]
            guard corner >= 0, corner < near.count else {
                return ("at the source", "the three were never apart")
            }
            return (near[corner], deep[corner])
        }
    }

    // MARK: · RING 2 · the crossing, read off her row

    /// Design's key pairing, by position and never by name.
    static let crossingKeyPosition = 44

    /// The near words every Karṣiṇī shares. Design's own
    /// `${low(card.quality)} · drawn toward the centre`, whose first half the
    /// composition in ``label(archetype:position:quality:bija:tattva:)`` supplies.
    static let crossingNear = "drawn toward the centre"

    /// **The faculty she draws, and the thing she is given.**
    ///
    /// Two live fields and no table. `nil` where the row cannot say it — a blank
    /// tattva, or a pairing that is not a crossing because the two words are the
    /// same word. Cittā is the real case of the second: her quality draws
    /// consciousness and her tattva gives Pure Consciousness, so there is nothing
    /// crossed about her and she keeps the ring's own sentence instead of a
    /// sentence that says one thing twice.
    static func crossing(quality: String, tattva: String) -> (faculty: String, organ: String)? {
        let faculty = drawnFaculty(from: quality)
        let organ = givenTattva(from: tattva)
        guard !faculty.isEmpty, !organ.isEmpty else { return nil }
        guard !faculty.contains(organ), !organ.contains(faculty) else { return nil }
        return (faculty, organ)
    }

    /// What her quality says she draws. The base writes the sixteen as *"She who
    /// attracts Touch"*; what is left once the drawing is taken out of it is the
    /// faculty. A quality written any other way is returned whole, because a
    /// quality is already her own word.
    static func drawnFaculty(from quality: String) -> String {
        var text = quality.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        for opening in ["she who attracts ", "she who draws ", "she who attracts", "she who draws"]
        where text.hasPrefix(opening) {
            text = String(text.dropFirst(opening.count))
            break
        }
        if text.hasPrefix("the ") { text = String(text.dropFirst(4)) }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// What her tattva gives her, in its own first word.
    ///
    /// The base writes *"Earth (Pṛthivī)"* and Design's cards write *"Pṛthivī —
    /// earth"*; either way the head of the line is the tattva's own name and
    /// everything after the bracket or the dash is its gloss. A tattva that
    /// carries a whole sentence — the base does that at Ātmā and Amṛtā — is cut
    /// at its first stop for the same reason.
    static func givenTattva(from tattva: String) -> String {
        let head = tattva.lowercased().prefix { character in
            !"(—–-.,;:/".contains(character)
        }
        var text = head.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.hasPrefix("the ") { text = String(text.dropFirst(4)) }
        return text
    }

    /// SOURCING is the one archetype whose near words are not prefixed by her
    /// quality. Design wrote the three corners as whole sentences — "will,
    /// before there is anything to will" — and a quality in front of them says
    /// the same thing twice. Everywhere else the composition is uniform.
    static func prefixesQuality(_ archetype: HomeArchetype) -> Bool {
        archetype != .sourcing
    }

    /// Her quality, spoken in the room's own voice: the lowercased quality, a
    /// middle dot, then the archetype's tag. Derived from her card, so no two
    /// siblings ever read alike — the uniqueness test applied to language.
    ///
    /// Both halves read as language. Neither is ever a measurement: nothing
    /// here can put a count, a streak, a percentage or a visit number into a
    /// room's mouth, and `HomeGrammarTests` runs Design's nine `MEASURING`
    /// patterns over every label the grammar can compose.
    static func label(archetype: HomeArchetype,
                      position pos: Int,
                      quality: String,
                      bija: String? = nil,
                      tattva: String = "") -> HomeLabel {
        let t = tag(for: archetype, position: pos, bija: bija, quality: quality, tattva: tattva)
        guard prefixesQuality(archetype) else {
            return HomeLabel(near: t.near, deep: t.deep)
        }
        let spoken = quality
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        let near = spoken.isEmpty ? t.near : "\(spoken) · \(t.near)"
        return HomeLabel(near: near, deep: t.deep)
    }

    // MARK: · One Śakti, read whole

    /// Everything the grammar knows about one room, before anything is drawn.
    struct Reading: Equatable {
        /// Her khaḍgamālā position, 1–102. The only key.
        let position: Int
        let ring: Int
        let archetype: HomeArchetype
        let physics: HomePhysics
        /// `0` crown … `1` soles.
        let bodyAltitude: Double
        /// Her height in the room's own units.
        let altitude: Double
        /// Her turn of her archetype's cycle, where the archetype gives one.
        let phase: Double?
        /// RING 7 only — her row's mode number.
        let soundingMode: Int?
        /// RING 1 · MĀTṚKĀ only — how many letters her row governs.
        let matrkaLetterCount: Int?
        /// RING 8 only — which corner of the innermost triangle is hers.
        let sourcingCorner: Int?
        let label: HomeLabel

        /// Where a thing at this phase stands, at this moment of this stay.
        func displacement(time: Double, amplitude: Double) -> HomeOffset {
            HomeGrammar.displace(physics, time: time, phase: phase ?? 0, amplitude: amplitude)
        }

        /// **What her room's premise becomes** past the second adaptation.
        ///
        /// The deep term, and the thing this type was missing. The Phase 3.1
        /// review found the second adaptation was one generic intensification in
        /// all 102 rooms, and located the reason exactly here: *"the
        /// `HomeGrammar.Reading` the pose receives carries no deep term it could
        /// read."* ``HomeLabel/deep`` said what the reversal *was* in words and
        /// nothing said what the room should *do*.
        ///
        /// It is her archetype's, because that is whose premise it is — Design
        /// authors one reversal per archetype in `homes-grammar.js`, and the
        /// eight rooms it wrote by hand carry their own instead
        /// (``RoomMechanisms/forRoom(_:)``).
        var becoming: HomeBecoming { .archetype(archetype) }
    }

    /// Read one Śakti into her room's grammar, from plain values.
    ///
    /// `nil` for Ring 9 and for any ring outside 1–8: the Bindu's room is
    /// authored, and the grammar declines rather than inventing one.
    static func read(position pos: Int,
                     ring: Int,
                     tattva: String,
                     quality: String,
                     bodilyLocation: String,
                     bija: String? = nil) -> Reading? {
        guard let archetype = archetype(ring: ring, position: pos) else { return nil }
        let alt = bodyAltitude(bodilyLocation: bodilyLocation)
        return Reading(
            position: pos,
            ring: ring,
            archetype: archetype,
            physics: physics(tattva: tattva, quality: quality),
            bodyAltitude: alt,
            altitude: altitude(ring: ring, bodyAltitude: alt),
            phase: phase(archetype: archetype, position: pos),
            soundingMode: archetype == .sounding ? soundingMode(position: pos) : nil,
            matrkaLetterCount: archetype == .matrka ? matrkaLetterCount(position: pos) : nil,
            sourcingCorner: archetype == .sourcing ? sourcingCorner(position: pos) : nil,
            label: label(archetype: archetype, position: pos, quality: quality,
                         bija: bija, tattva: tattva)
        )
    }
}

// MARK: - Read from the base, never from a bundled roster

extension HomeGrammar {

    /// Read one Śakti's room straight off her row.
    ///
    /// Her `khadgamalaPosition` is identity; her `ringNumber`, `tattva`,
    /// `quality`, `bodilyLocation` and `bija` all come from Airtable through the
    /// sync. A row that has not yet been re-keyed — no khaḍgamālā position, or
    /// no ring — has no room the grammar can speak for, and returns `nil`
    /// rather than a guess at one.
    static func read(_ shakti: Shakti) -> Reading? {
        guard let pos = shakti.khadgamalaPosition, let ring = shakti.ringNumber else { return nil }
        return read(
            position: pos,
            ring: ring,
            tattva: shakti.tattva,
            quality: shakti.quality,
            bodilyLocation: shakti.bodilyLocation,
            bija: shakti.bijaSyllable
        )
    }
}
