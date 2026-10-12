import Foundation
import CoreGraphics

/// The places in **his** body where a Śakti speaks (Wave 5 · The Body as
/// Scripture). This is a map of regions of light — never a figure, and never
/// hers: it is the walker's own body, drawn as places, and she is found in it
/// by her own row's `bodilyLocation`.
///
/// A row may name several places ("Heart / hands", "Mouth / belly / whole
/// body"), so a Śakti may light in several regions. A row that names nowhere
/// this vocabulary knows lives in the whole field — the honest answer for
/// "wherever healing is needed".
enum SomaticRegion: String, CaseIterable, Identifiable {
    case crown, brow, senses, throat, heart, hands, solar, belly, root, soles, spine, field

    var id: String { rawValue }

    /// The words he reads beneath the light.
    var words: String {
        switch self {
        case .crown:  return "the crown"
        case .brow:   return "the brow"
        case .senses: return "the senses"
        case .throat: return "the throat and mouth"
        case .heart:  return "the heart"
        case .hands:  return "the hands"
        case .solar:  return "the solar plexus"
        case .belly:  return "the belly"
        case .root:   return "the root"
        case .soles:  return "the soles"
        case .spine:  return "the spine"
        case .field:  return "the whole field"
        }
    }

    /// Patterns over the row's words, diacritics and case folded away first.
    var pattern: String {
        switch self {
        case .crown:  return #"crown|bindu point|above"#
        case .brow:   return #"third eye|forehead|between the eyes|behind the eyes|brow|temple|\bhead\b"#
        case .senses: return #"(?<!third )\beyes?\b|face|\bears?\b|nose|nostril|skull|sense|olfactory|aesthetic|perceptual"#
        case .throat: return #"throat|mouth|tongue|palate|\blips?\b|lung|breath|vowel"#
        case .heart:  return #"heart|chest|sternum|shoulder"#
        case .hands:  return #"\bhands?\b|palm"#
        case .solar:  return #"solar|diaphragm|navel"#
        case .belly:  return #"belly|\bgut\b|waist|body's centre|center of gravity|abundance"#
        case .root:   return #"muladhara|sit-bones|sacrum|sacral|pelvi|yoni"#
        case .soles:  return #"\bsoles?\b|\bfeet\b|\bfoot\b"#
        case .spine:  return #"spine|back-body|back of|drawn-back"#
        case .field:  return #"whole|field|everywhere|periphery|horizon|joint|fluid|lymph|wherever|converge|skin|cellular"#
        }
    }

    private static let compiled: [(SomaticRegion, NSRegularExpression)] = allCases.compactMap { r in
        guard let re = try? NSRegularExpression(pattern: r.pattern, options: [.caseInsensitive]) else { return nil }
        return (r, re)
    }

    /// Every region her row names. Never empty.
    static func regions(forBodilyLocation raw: String) -> Set<SomaticRegion> {
        let folded = raw.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
        let range = NSRange(folded.startIndex..<folded.endIndex, in: folded)
        var out = Set<SomaticRegion>()
        for (region, re) in compiled where re.firstMatch(in: folded, options: [], range: range) != nil {
            out.insert(region)
        }
        return out.isEmpty ? [.field] : out
    }

    /// Where the region's light stands on the map, in unit space (0…1 across,
    /// 0…1 down). Two-sided places stand twice.
    var anchors: [CGPoint] {
        switch self {
        case .crown:  return [CGPoint(x: 0.5, y: 0.07)]
        case .brow:   return [CGPoint(x: 0.5, y: 0.145)]
        case .senses: return [CGPoint(x: 0.36, y: 0.2), CGPoint(x: 0.64, y: 0.2)]
        case .throat: return [CGPoint(x: 0.5, y: 0.285)]
        case .heart:  return [CGPoint(x: 0.5, y: 0.40)]
        case .hands:  return [CGPoint(x: 0.14, y: 0.56), CGPoint(x: 0.86, y: 0.56)]
        case .solar:  return [CGPoint(x: 0.5, y: 0.505)]
        case .belly:  return [CGPoint(x: 0.5, y: 0.6)]
        case .root:   return [CGPoint(x: 0.5, y: 0.7)]
        case .soles:  return [CGPoint(x: 0.4, y: 0.94), CGPoint(x: 0.6, y: 0.94)]
        case .spine:  return [CGPoint(x: 0.5, y: 0.82)]
        case .field:  return [CGPoint(x: 0.12, y: 0.12)]
        }
    }
}

/// Everyday sensory doorways (Codex C-1337): each energy is met in a plain
/// touch of the world — heat, cold, water, earth, breath, space. The doorway is
/// read from her own element; the line that walks through it is hers, from
/// her row, never written here.
enum SensoryDoorway: String, Equatable {
    case heat, water, earth, breath, space

    var words: String {
        switch self {
        case .heat:   return "through heat"
        case .water:  return "through water"
        case .earth:  return "through earth"
        case .breath: return "through breath"
        case .space:  return "through space and sound"
        }
    }

    /// Her tattva → the doorway. `nil` when her row names no element.
    static func forTattva(_ tattva: String) -> SensoryDoorway? {
        let t = tattva.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
        if t.contains("fire") || t.contains("agni") || t.contains("tejas") { return .heat }
        if t.contains("water") || t.contains("jala") || t.contains("apas") { return .water }
        if t.contains("earth") || t.contains("prthvi") || t.contains("prithvi") { return .earth }
        if t.contains("air") || t.contains("vayu") { return .breath }
        if t.contains("ether") || t.contains("space") || t.contains("akasa") || t.contains("akasha") { return .space }
        return nil
    }

    /// The one line from her rows that walks through the doorway: the first
    /// line of her somatic signature, else her somatic prompt. `nil` when her
    /// rows hold neither — then no doorway is shown.
    static func line(somaticSignature: String, somaticPrompt: String) -> String? {
        for source in [somaticSignature, somaticPrompt] {
            let first = source.split(whereSeparator: \.isNewline)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .first { !$0.isEmpty }
            if let first { return first }
        }
        return nil
    }
}
