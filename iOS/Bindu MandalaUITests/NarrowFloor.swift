import Foundation

// MARK: - The narrow measuring floor, for the running app (U0 · ruling 10, V33)
//
// The UI target cannot see the unit target's `Measuring` / `NeverMeasure`, so
// the same four patterns are restated here — Design's `homes-verify.js`
// MEASURING, narrowed to the ones that can say nothing but a quantity of his
// practice: a visit count, a streak, a score, "felt N times". Numbers,
// ordinals, dates, timers, seat numbers, Design's figures, "progress",
// percentages and "again" are allowed (ruling 10).
//
// `NarrowFloorSelfTest` in `TheWalk.swift` proves the four still catch what
// they exist for and let the lifted words through, so this copy cannot go
// quietly blind.
enum NarrowFloor {

    static let patterns: [String] = [
        #"\bvisit(?:s)?\s*[:=]\s*\d+"#,
        #"\bstreak\b"#,
        #"\bscore\b"#,
        #"\b\d+\s*(?:times|visits)\b"#,
    ]

    /// An ordinal turned into a tally of him — "your third time", "the second
    /// visit". Her seat may be the third of the hundred and two; nothing may be
    /// his third anything.
    static let ordinals = ["first", "second", "third", "fourth", "fifth"]
    static let hisTails = [" time", " visit", " turn"]

    /// The floor patterns this text trips, if any.
    static func trips(_ text: String) -> [String] {
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        var hits: [String] = patterns.filter { p in
            guard let re = try? NSRegularExpression(pattern: p, options: [.caseInsensitive]) else { return true }
            return re.firstMatch(in: text, options: [], range: range) != nil
        }
        let lowered = text.lowercased()
        for o in ordinals { for t in hisTails where lowered.contains(o + t) { hits.append(o + t) } }
        return hits
    }

    /// True when the text says a quantity of his practice.
    static func saysAQuantityOfHisPractice(_ text: String) -> Bool { !trips(text).isEmpty }
}
