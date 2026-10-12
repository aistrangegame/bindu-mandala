import Foundation
import CoreGraphics

// MARK: - Wave 6 · the 33 alive — what a chakra's room is made of
//
// Pure: everything here reads one `Chakra33` (the Map's own row, baked) and
// answers a question about its room without composing a word. The room's words
// are the Map's cells, cut where the Map itself cuts them (its blank lines, its
// ①②③, its "Button:" line); the held movements and breaths carry only lines
// from his Codex, each with its entry named beside it. `ChakraTeachingTests`
// walks all of it against the shipped bake.

enum ChakraTeaching {

    // MARK: Paragraphs, as the Map writes them

    /// The cell's paragraphs: split at its own blank lines, each trimmed, the
    /// empty ones dropped. The line breaks inside a paragraph are kept.
    static func paragraphs(_ text: String?) -> [String] {
        guard let text else { return [] }
        let unified = text.replacingOccurrences(of: "\r\n", with: "\n")
        var out: [String] = []
        var current: [String] = []
        for line in unified.components(separatedBy: "\n") {
            if line.trimmingCharacters(in: .whitespaces).isEmpty {
                if !current.isEmpty {
                    out.append(current.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines))
                    current = []
                }
            } else {
                current.append(line)
            }
        }
        if !current.isEmpty {
            out.append(current.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return out.filter { !$0.isEmpty }
    }

    // MARK: Three Ways In

    /// The Map's three doors into a practice, and the line that sometimes
    /// stands before them (Armin: "Three ways of sitting with Tat Tvam Asi —
    /// one per word:").
    struct ThreeWays: Equatable {
        let intro: String?
        let ways: [String]
    }

    static let wayMarkers: Set<Character> = ["①", "②", "③", "④", "⑤"]

    /// Where the Map numbers its ways (①②③) those paragraphs are the ways and
    /// anything before them is the intro; where it does not, every paragraph
    /// is a way. The marker itself is the Map's typography, and is taken off
    /// so the door can draw its own.
    static func threeWays(_ text: String?) -> ThreeWays? {
        let p = paragraphs(text)
        guard !p.isEmpty else { return nil }
        let marked = p.indices.filter { i in p[i].first.map { Self.wayMarkers.contains($0) } ?? false }
        if let first = marked.first {
            let intro = p[..<first].joined(separator: "\n\n")
            let ways = marked.map { i -> String in
                String(p[i].dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            return ThreeWays(intro: intro.isEmpty ? nil : intro, ways: ways)
        }
        return ThreeWays(intro: nil, ways: p)
    }

    /// A way's first sentence — the door's own words — and what follows it.
    /// Cut at the first full stop, question or exclamation that ends a
    /// sentence; a way that is one sentence is all door.
    static func door(of way: String) -> (head: String, rest: String?) {
        let chars = Array(way)
        var i = 0
        while i < chars.count {
            let c = chars[i]
            if c == "\n" {
                let head = String(chars[..<i]).trimmingCharacters(in: .whitespaces)
                let rest = String(chars[(i + 1)...]).trimmingCharacters(in: .whitespacesAndNewlines)
                if !head.isEmpty { return (head, rest.isEmpty ? nil : rest) }
            }
            if c == "." || c == "?" || c == "!" {
                let next = i + 1 < chars.count ? chars[i + 1] : " "
                if next == " " || next == "\n" {
                    let head = String(chars[...i]).trimmingCharacters(in: .whitespaces)
                    let rest = String(chars[(i + 1)...]).trimmingCharacters(in: .whitespacesAndNewlines)
                    return (head, rest.isEmpty ? nil : rest)
                }
            }
            i += 1
        }
        return (way.trimmingCharacters(in: .whitespacesAndNewlines), nil)
    }

    // MARK: The gate

    /// The gate's instruction, and the words on its button — the Map writes
    /// those as its last line, "Button: I feel the ground".
    struct Gate: Equatable {
        let instruction: String
        let button: String?
    }

    static func gate(_ text: String?) -> Gate? {
        guard let text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        var lines = text.replacingOccurrences(of: "\r\n", with: "\n").components(separatedBy: "\n")
        var button: String?
        if let i = lines.lastIndex(where: { $0.trimmingCharacters(in: .whitespaces).hasPrefix("Button:") }) {
            let raw = lines[i].trimmingCharacters(in: .whitespaces)
            let label = String(raw.dropFirst("Button:".count)).trimmingCharacters(in: .whitespaces)
            button = label.isEmpty ? nil : label
            lines.remove(at: i)
        }
        let instruction = lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !instruction.isEmpty || button != nil else { return nil }
        return Gate(instruction: instruction, button: button)
    }

    /// Does the gate take his words? The Map's Textarea and Canvas gates ask
    /// for a mark; the others are a held act of the body.
    static func gateTakesWords(_ c: Chakra33) -> Bool {
        switch c.gateType ?? "" {
        case "Textarea", "Canvas": return true
        default: return false
        }
    }

    // MARK: The wake-up

    /// The bīja as a syllable to sound — "LAM" from "LAM · लं — Mirror
    /// frequency of Muladhara" — or nil where the Map's bīja is words ("· · ·
    /// the word you offer to the dark · · ·"). The poetic ones are never
    /// sounded as bījas (ledger §2d).
    static func soundedSyllable(_ bija: String?) -> String? {
        guard let bija else { return nil }
        // The syllable stands before the Map's gloss — "लं · LAM (the earth
        // seed …)", "HAM · हं — Mirror frequency of Vishuddha".
        var head = Substring(bija)
        if let stop = head.firstIndex(where: { $0 == "(" || $0 == "—" }) {
            head = head[..<stop]
        }
        let tokens = head.split(whereSeparator: { $0 == " " || $0 == "·" })
        for t in tokens {
            let s = String(t)
            if (2...4).contains(s.unicodeScalars.count),
               s.unicodeScalars.allSatisfy({ $0.value >= 65 && $0.value <= 90 }) {
                return s
            }
        }
        return nil
    }

    // MARK: The two thresholds, in the Map's words

    /// Tat · Tvam · Asi, from Armin's own Mirror Frequency Instruction ("Tat.
    /// Tvam. Asi. / One word at a time…"). Empty unless the Map gives exactly
    /// three words there, so nothing is ever typed in for it.
    static func tatTvamAsi(_ c: Chakra33) -> [String] {
        guard c.kind == .armin,
              let first = c.mirrorFrequencyInstruction?
                .replacingOccurrences(of: "\r\n", with: "\n")
                .components(separatedBy: "\n").first else { return [] }
        let words = first.components(separatedBy: ".")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        return words.count == 3 ? words : []
    }

    /// The order the Shadow's phrase is revealed in. The Map's own Act 2 Voice
    /// for Shadow says it: *"the inversion of please come back home (revealed
    /// in order home / come / please / back — the word back arriving last to
    /// re-mean the whole phrase)"*. Read from that cell; if the cell does not
    /// say it, the phrase's own words in their own order.
    static func revealOrder(_ c: Chakra33) -> [String] {
        let phraseWords = words(of: c.signaturePhrase)
        guard !phraseWords.isEmpty else { return [] }
        guard let act = c.act2Voice, let r = act.range(of: "in order ") else { return phraseWords }
        var tail = act[r.upperBound...]
        if let stop = tail.firstIndex(where: { $0 == "—" || $0 == "(" || $0 == ")" || $0 == "," || $0 == ";" }) {
            tail = tail[..<stop]
        }
        let order = tail.components(separatedBy: "/")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }
        let lowered = phraseWords.map { $0.lowercased() }
        // Only an order that is exactly the phrase's own words, re-ordered.
        guard order.count == lowered.count, Set(order) == Set(lowered) else { return phraseWords }
        return order.compactMap { w in phraseWords.first { $0.lowercased() == w } }
    }

    /// How long a threshold moment lasts now that it speaks the Map's words:
    /// the corridor or the gate (as Wave 3 drew it), then the words, one at a
    /// time, then the phrase whole. Under reduce motion, a still image.
    static let thresholdMomentSeconds: Double = 9.2
    static let thresholdMomentStillSeconds: Double = 5.0

    /// A line's words, its full stop taken off.
    static func words(of line: String?) -> [String] {
        guard let line else { return [] }
        return line.components(separatedBy: .whitespacesAndNewlines)
            .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: ".,;:!?")) }
            .filter { !$0.isEmpty }
    }

    // MARK: The door into the Home

    /// Where the room's practice leads: her seat's room for a chakra seated at
    /// one Śakti (body, mind, summit, and the point), the ring itself for an
    /// energy chakra that lives at the level of a whole āvaraṇa, and nothing
    /// for a threshold, which is a crossing and not a Home.
    enum HomeDoor: Equatable {
        case seat(Int)
        case ring(Int)
    }

    static func homeDoor(_ c: Chakra33) -> HomeDoor? {
        switch c.address {
        case .seat, .centre:
            return c.kp.first.map { HomeDoor.seat($0) }
        case .ring:
            return c.avarana.map { HomeDoor.ring($0) }
        case .threshold:
            return nil
        }
    }

    // MARK: Its game

    /// The games Wave 4 placed at this chakra's address: at one of its seats,
    /// or at its threshold crossing. In the walk's own order.
    static func games(_ c: Chakra33) -> [PlayGame] {
        if c.address == .threshold {
            guard let pair = c.crossing, pair.count == 2 else { return [] }
            let here = PlayAddress.threshold(from: pair[0], to: pair[1])
            return PlayGame.allCases.filter { $0.address == here }
        }
        let seats = Set(c.kp)
        return PlayGame.allCases.filter { g in
            guard let p = g.address.position else { return false }
            return seats.contains(p)
        }
    }

    // MARK: The Road's two stations

    /// C-1330's order ends *Atma → Gaia reveal → Lalitā play*. The Map holds
    /// both as rooms of the summit — Aatma at Book Position 31 and the reveal
    /// at 32 (canon rules room 32 the Gaia reveal: WAVES, "small canon
    /// questions") — and the Road dwells at each as a station.
    enum Station: Equatable {
        case atma
        case gaiaReveal

        /// The kicker the Road writes above the room's own name — C-1330's words.
        var kicker: String {
            switch self {
            case .atma:       return "Atma"
            case .gaiaReveal: return "the Gaia reveal"
            }
        }
    }

    static let atmaRoad = 31
    static let gaiaRevealRoad = 32

    static func station(_ c: Chakra33) -> Station? {
        guard c.kind == .summit else { return nil }
        switch c.road {
        case atmaRoad:       return .atma
        case gaiaRevealRoad: return .gaiaReveal
        default:             return nil
        }
    }
}

// MARK: - The ten body chakras on the Climb (canon A)

/// Charter II §2: *the Climb (the body). One chakra per āvaraṇa, rising. The ten
/// body chakras are touchable places at their own heights.* Their heights are
/// the body's own: the Map's Book Position walks them sole to crown (Soles,
/// Forge, Prāṇa, Hands, Pulse, Sonar, Echo, Vision, Axis, Crow), Soles stands
/// at the first band — the canon-A lens, beside canon B's seat for her in the
/// fourth āvaraṇa, both kept — and Crow at the seventh, Sahasrāra's band, which
/// is the Map's own Subtle Mirror for Crow ("the energy crown and the physical
/// crown"). The eight between stand evenly up the spine.
enum ClimbChakras {

    /// The climb fraction (0 = the first band) Soles stands at.
    static let lowest: Double = 0
    /// The climb fraction Crow stands at — the seventh band.
    static let highest: Double = 6

    /// The ten, in the Map's order, sole to crown.
    static func bodies(_ all: [Chakra33] = ChakraConstellation.all) -> [Chakra33] {
        all.filter { $0.kind == .body }.sorted { $0.road < $1.road }
    }

    /// Each body chakra's height on the climb, keyed by its Road position.
    static func heights(_ all: [Chakra33] = ChakraConstellation.all) -> [Int: Double] {
        let b = bodies(all)
        guard !b.isEmpty else { return [:] }
        var out: [Int: Double] = [:]
        for (i, c) in b.enumerated() {
            let t = b.count == 1 ? 0 : Double(i) / Double(b.count - 1)
            out[c.road] = lowest + (highest - lowest) * t
        }
        return out
    }

    /// How far one band is on the glass — the climb's own hand: a drag of one
    /// screen height (`WorldClimbView.pointsPerBand`) is one band.
    static let pointsPerBand: Double = 640

    /// Where a body chakra at `height` stands on the glass while the walker
    /// stands at `here`: on the axis (it is the spine), above or below the eye
    /// by the bands between them. Nil once it is out of reach.
    static func screenY(height: Double, here: Double, eyeY: Double,
                        reach: Double = 0.75) -> Double? {
        let d = height - here
        guard abs(d) <= reach else { return nil }
        return eyeY - d * pointsPerBand
    }

    /// How present it is: whole at the eye, gone at the edge of reach.
    static func presence(height: Double, here: Double, reach: Double = 0.75) -> Double {
        let d = abs(height - here)
        guard d < reach else { return 0 }
        let k = 1 - d / reach
        return k * k * (3 - 2 * k)
    }
}
