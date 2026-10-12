import Foundation

// MARK: - Wave 6 · a month, read (pure)
//
// Two designs meet here. Bindu Being's **Month Mirror** reads a month as one
// letter that builds — the field gathered, what moved through it, the turning,
// the line witnessed last, a place to answer — and its **MonthSitting**
// answers "does this land?" with *it lands · say more · leave my own word*.
// Bindu Feed's **Portrait** gives each day walked a **glyph** (coloured by the
// day's room, a dot per presence met, an ember for what was sealed) and reads
// the month as a letter built only from what is true.
//
// The laws both keep, and this file keeps:
//   • **Words only from his own record.** Every line is assembled from what he
//     did and wrote — her names, his letters, his notes, his own words — and a
//     few fixed joining words. Nothing is generated or guessed.
//   • **A practice count becomes a state and nothing else** (LawsDrawnMeasure).
//     A ring is touched or not, a day has an ember or not; nothing is weighed,
//     ranked or tallied, and no composed line carries a number. The month is
//     witnessed, never measured. A quiet month is said plainly and kindly.

struct MonthReading: Equatable {

    /// One thing he did, in the month — the reading's only input shape.
    struct Act: Equatable {
        enum Kind: Equatable { case felt, silence, letter, light, note, codex, drawing, played }
        var kind: Kind
        var at: Date
        /// Her position, when the act was with her.
        var kp: Int?
        /// His own words, when the act carried any.
        var words: String?
    }

    /// A day walked: the ring he first stood in that day, the Śaktis met (a
    /// dot each — each dot is *her*), and an ember when anything was sealed or
    /// sent. States only: an ember is there or not; nothing is tallied.
    struct DayGlyph: Equatable, Identifiable {
        var day: Date
        var ring: Int
        var met: [Int]
        var sealed: Bool
        var id: Date { day }
    }

    struct Arc: Equatable {
        var ring: Int
        /// Her names, as met — the record's own.
        var names: [String]
        /// One sentence of his from that ring, if he left any there.
        var his: String?
    }

    var monthStart: Date
    var glyphs: [DayGlyph] = []
    /// The rings the month touched — each lit or not, never weighed.
    var touched: Set<Int> = []
    var arc: [Arc] = []
    /// The turning: one day, and his words that day (or whom he met).
    var turningDay: Date?
    var turningLine: String?
    /// The month witnessed — the letter, built only from what is true.
    var letter: String = ""
    /// "Say more": one more sentence of his own from the month.
    var deeper: String?
    /// The witness line — offered, never insisted.
    var witness: String = ""

    var isQuiet: Bool { glyphs.isEmpty }

    /// Read a month. `name` resolves a position to her name.
    static func read(month: Date, acts all: [Act], name: (Int) -> String,
                     calendar: Calendar = .current) -> MonthReading {
        let start = calendar.dateInterval(of: .month, for: month)?.start ?? calendar.startOfDay(for: month)
        let end = calendar.date(byAdding: .month, value: 1, to: start) ?? start.addingTimeInterval(31 * 86_400)
        let acts = all.filter { $0.at >= start && $0.at < end }.sorted { $0.at < $1.at }
        var r = MonthReading(monthStart: start)

        // The days, as glyphs.
        let byDay = Dictionary(grouping: acts) { calendar.startOfDay(for: $0.at) }
        r.glyphs = byDay.keys.sorted().map { (day: Date) -> DayGlyph in
            let dayActs = byDay[day] ?? []
            let firstRing = dayActs.compactMap { $0.kp }.first.map { KhadgamalaMap.ringNumber(forKhadgamala: $0) }
            let ring = firstRing ?? KhadgamalaMap.ringNumber(forKhadgamala: DailyEnergyService.todaysPosition(
                for: day.addingTimeInterval(12 * 3_600), calendar: calendar))
            var met: [Int] = []
            for a in dayActs where a.kind == .felt || a.kind == .silence {
                if let kp = a.kp, !met.contains(kp) { met.append(kp) }
            }
            let sealed = dayActs.contains { $0.kind == .letter || $0.kind == .light }
            return DayGlyph(day: day, ring: max(1, ring), met: met, sealed: sealed)
        }

        // The rings touched.
        for a in acts {
            guard let kp = a.kp else { continue }
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            if ring >= 1 { r.touched.insert(ring) }
        }

        // What moved: each ring touched, outermost first, with her names and
        // one sentence of his from there.
        for ring in r.touched.sorted() {
            var names: [String] = []
            var his: String? = nil
            for a in acts {
                guard let kp = a.kp, KhadgamalaMap.ringNumber(forKhadgamala: kp) == ring else { continue }
                let n = name(kp)
                if a.kind == .felt || a.kind == .silence, !n.isEmpty, !names.contains(n) { names.append(n) }
                if his == nil, let w = sentence(a.words) { his = w }
            }
            if !names.isEmpty || his != nil { r.arc.append(Arc(ring: ring, names: names, his: his)) }
        }

        // The turning: the latest day that carries his own words; else the
        // first day walked.
        let withWords = acts.filter { sentence($0.words) != nil }
        if let last = withWords.last, let words = sentence(last.words) {
            r.turningDay = calendar.startOfDay(for: last.at)
            r.turningLine = "“\(words)”"
        } else if let firstDay = r.glyphs.first {
            r.turningDay = firstDay.day
            if let kp = firstDay.met.first, !name(kp).isEmpty {
                r.turningLine = "You stopped for \(name(kp))."
            }
        }

        // The letter — only what is true.
        r.letter = letter(acts: acts, name: name)
        // Say more — the first sentence of his own in the month (the turning
        // already holds the last).
        if withWords.count > 1, let first = sentence(withWords.first?.words) {
            r.deeper = "You wrote: “\(first)”"
        }
        r.witness = witnessLine(touched: r.touched, quiet: acts.isEmpty)
        return r
    }

    /// The month's letter, from the record alone.
    static func letter(acts: [Act], name: (Int) -> String) -> String {
        guard !acts.isEmpty else {
            return "This month asked nothing of you. The yantra stood open the whole time."
        }
        var order: [Int] = []
        for a in acts where a.kind == .felt {
            if let kp = a.kp, !order.contains(kp) { order.append(kp) }
        }
        var parts: [String] = []
        let met = order.map { name($0) }.filter { !$0.isEmpty }
        if !met.isEmpty { parts.append("This month you met \(SakshiClose.list(met))") }
        if acts.contains(where: { $0.kind == .letter }) { parts.append("you set letters into the river") }
        if acts.contains(where: { $0.kind == .light }) { parts.append("you sent light back to a moment once lost") }
        if acts.contains(where: { $0.kind == .drawing }) { parts.append("your hand drew in her rings") }
        if acts.contains(where: { $0.kind == .played }) { parts.append("you played at her addresses") }
        if acts.contains(where: { $0.kind == .note || $0.kind == .codex }) { parts.append("you left your own words") }
        if parts.isEmpty { return "This month you came, and the yantra knew it." }
        var text = parts[0]
        if parts.count > 1 { text += "; " + SakshiClose.phrases(Array(parts.dropFirst())) }
        return text + "."
    }

    /// The witness line: one quiet observation of *where*, never how much.
    static func witnessLine(touched: Set<Int>, quiet: Bool) -> String {
        if quiet { return "A quiet month. Quiet is not empty." }
        let rings = touched.sorted()
        switch rings.count {
        case 0:
            return "The month kept its own counsel. Just noticing."
        case 1:
            return "The month stayed in the \(ChakraConstellation.ordinal(rings[0])) enclosure. Just noticing."
        case 2:
            return "The month moved between the \(ChakraConstellation.ordinal(rings[0])) and the \(ChakraConstellation.ordinal(rings[1])) enclosures. Just noticing."
        default:
            return "The month moved across the yantra. Just noticing."
        }
    }

    /// His words as one sentence: the first line, trimmed; nil when blank.
    static func sentence(_ raw: String?) -> String? {
        guard let raw else { return nil }
        let first = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n", omittingEmptySubsequences: true).first.map(String.init) ?? ""
        let t = first.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return nil }
        return t.count > 160 ? String(t.prefix(159)) + "…" : t
    }
}
