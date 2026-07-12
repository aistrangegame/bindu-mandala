import Foundation

/// The Daily Rite's content model — the same fields for every Śakti, with the
/// fallbacks and the 86-degradation baked in so nothing renders blank or false.
/// (Ported from `lrQuality` / `lrPrompt` / `lrNameSize`.)
struct RiteContent {
    let name: String
    let ring: Int
    let kp: Int
    /// Ruling 7: cluster is a Ring-2-only taxonomy — never surface the `.inner`
    /// default the 86 carry. `hasCluster` gates the kicker's dot + family label.
    let hasCluster: Bool
    let cluster: Cluster?
    let phonetic: String?
    let bija: String?
    let quality: String
    let prompt: String

    init(shakti s: Shakti, avaranaSubtitle: String? = nil) {
        let ring = s.ringNumber ?? 2
        self.name = s.name
        self.ring = ring
        self.kp = s.khadgamalaPosition ?? s.position
        self.hasCluster = (ring == 2)
        self.cluster = (ring == 2) ? s.cluster : nil

        let p = s.phonetic.trimmingCharacters(in: .whitespacesAndNewlines)
        self.phonetic = p.isEmpty ? nil : p
        let b = s.bija.trimmingCharacters(in: .whitespacesAndNewlines)
        self.bija = b.isEmpty ? nil : b

        // quality → her quality, else an āvaraṇa line, else empty.
        let q = s.quality.trimmingCharacters(in: .whitespacesAndNewlines)
        if !q.isEmpty {
            self.quality = q
        } else if let sub = avaranaSubtitle?.trimmingCharacters(in: .whitespacesAndNewlines), !sub.isEmpty {
            self.quality = "Of the \(RiteContent.ordinal(ring)) āvaraṇa — \(sub.lowercased())"
        } else {
            self.quality = ""
        }

        // prompt → somatic question, else her poetry's first line, else a universal invitation.
        let somatic = s.somatic.trimmingCharacters(in: .whitespacesAndNewlines)
        if !somatic.isEmpty {
            self.prompt = somatic
        } else if let first = s.somaticPoetry.split(whereSeparator: \.isNewline).first
            .map({ $0.trimmingCharacters(in: .whitespaces) }), !first.isEmpty {
            self.prompt = first
        } else {
            self.prompt = "Where do you feel her, right now?"
        }
    }

    /// VoiceOver name — her phonetic when present, else her Sanskrit name.
    var spokenName: String { phonetic ?? name }

    /// Length-tapered name size (`lrNameSize`) plus the composition's tier nudge.
    func nameSize(cap: Double, nudge: Double) -> Double {
        let L = name.count
        let base: Double
        if L <= 9        { base = cap }
        else if L <= 12  { base = min(cap, 56) }
        else if L <= 15  { base = min(cap, 48) }
        else if L <= 18  { base = min(cap, 42) }
        else             { base = min(cap, 37) }
        return base + nudge
    }

    static func ordinal(_ n: Int) -> String {
        switch n {
        case 1: return "first";  case 2: return "second"; case 3: return "third"
        case 4: return "fourth"; case 5: return "fifth";  case 6: return "sixth"
        case 7: return "seventh"; case 8: return "eighth"; case 9: return "ninth"
        default: return "\(n)th"
        }
    }
}
