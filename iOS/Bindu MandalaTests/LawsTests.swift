import XCTest
@testable import Bindu_Mandala

// MARK: - LawsTests — the Build Charter's five laws, asserted against real source
//
// `BUILD-CHARTER.md` §3 names this suite and says to create it first. It lists
// five checks:
//
//   1. a measuring-out-loud detector across every walker-facing string and view
//   2. a verbatim match of both Recognition lines at every site
//   3. no name-keyed Śakti lookups outside display
//   4. no figural asset or description in any render path
//   5. the App Activity writer is the only event writer
//
// ─────────────────────────────────────────────────────────────────────────────
// WHO OWNS WHICH LAW
// ─────────────────────────────────────────────────────────────────────────────
//
// Three of the five are already proven *behaviourally* elsewhere. This file
// does not copy those proofs — it proves the other half: that the source
// itself has no room to grow a new way of breaking them.
//
//  Law 2 · never measure
//    `HomesHarnessTests` — Design's nine MEASURING patterns over every string
//        the instrument **composes at run time**: every ledger row under every
//        shipped name and every phase of the moon, the morning summons, the
//        Rite, the shipped Śakti data. It says so in its own header: it reads
//        composed strings, and the view layer is not in its reach.
//    `LawsTests` (here) — the **view layer**. Every `Text`, every accessibility
//        label, every `Button` title in the real `.swift` files: the words that
//        are typed into them *and* the values that are bound into them. The
//        harness cannot see these, because most of them are never composed by a
//        function it can call.
//
//  Law 3 · the two Recognition lines — sole owner, here. Every literal at every
//        site, byte for byte. `BinduMandalaUITests` waits for the Act 1 line on
//        a running app; that proves it reaches the screen, not that it is
//        unaltered everywhere else.
//
//  Law 1 · position is identity
//    `HomesHarnessTests` — the behaviour: `KhadgamalaMap` resolves by position
//        alone, and two same-named sisters stay two through letter, recognition
//        log, room memory and ledger (`testTheShippedPathsKeepTwoSameNamedSistersApart`,
//        `testHerMomentsNarrowsByNameButNeverIdentifiesByIt`).
//    `LawsTests` (here) — the statics: there is no name-keyed lookup in the
//        source to run in the first place, the ghost file is unreferenced, and
//        every uniqueness constraint and every per-Śakti store API is a position.
//
//  Law 4 · aniconic — sole owner, here. The asset catalogue and every drawing
//        primitive in the render path.
//
//  R17 · App Activity is the single record
//    `ActivityLedgerTests` / `RecognitionDedupTests` — the payloads, formulas
//        and dedup arithmetic, row by row.
//    `LawsTests` (here) — the **topology**: which table each HTTP verb reaches,
//        and where the ledger's vocabulary is allowed to exist at all.
//
// ─────────────────────────────────────────────────────────────────────────────
// HOW THESE READ THE SOURCE
// ─────────────────────────────────────────────────────────────────────────────
//
// Every check reads the real `.swift` files off disk at run time, found from
// `#filePath`. Nothing is hand-copied. A corpus typed out inside a test goes
// stale the day after it is written and then passes while the app breaks — the
// last review caught exactly that, so it is not done here.
//
// The cost of scanning is that an emptied scan reads as a pass. So every check
// asserts a **corpus floor** before it asserts anything else: if the scanner
// stops finding source, or a refactor moves the thing being scanned out of
// reach, the suite fails loudly instead of going quietly green.
//
// Where a law needs an exception, the exception is a **pinned set** compared by
// exact equality, never a substring test — a new entry must be written down
// here, with a reason, by whoever adds it. Two of the laws (a practice measure
// reaching a screen; a figural asset) have no exception mechanism at all.

// MARK: - A Swift lexer, enough of one

/// One piece of a string literal: authored text, or an interpolated expression.
enum LiteralPiece: Equatable {
    case text(String)
    case expr(String)
}

/// A string literal as it sits in the source: its authored words, the
/// expressions interpolated into it, and its *shape* — the two interleaved, so
/// a digit that straddles the boundary ("⟨kp⟩ of 102") is still visible.
struct SourceLiteral: Equatable {
    let pieces: [LiteralPiece]
    /// Character offset of the opening delimiter in the file.
    let start: Int

    /// The authored words only, escapes resolved, interpolations removed.
    var text: String {
        pieces.reduce(into: "") { if case .text(let t) = $1 { $0 += t } }
    }

    var interpolations: [String] {
        pieces.compactMap { if case .expr(let e) = $0 { return e } else { return nil } }
    }

    /// Words and interpolation markers in source order: `⟨content.kp⟩ of 102`.
    var shape: String {
        pieces.reduce(into: "") {
            switch $1 {
            case .text(let t): $0 += t
            case .expr(let e): $0 += "⟨\(e)⟩"
            }
        }
    }
}

/// Comments out, string literals separated from code, interpolations kept whole.
/// Small on purpose: it has to be right about comments, escapes and nesting, and
/// nothing else.
enum SwiftLexer {

    struct Lexed {
        let chars: [Character]
        let literals: [SourceLiteral]
        /// The file with every comment and every string literal blanked to
        /// spaces, so walking parentheses sees only code.
        let masked: [Character]
    }

    static func lex(_ source: String) -> Lexed {
        let chars = Array(source)
        var masked = chars
        var literals: [SourceLiteral] = []
        var i = 0

        while i < chars.count {
            let c = chars[i]

            if c == "/", i + 1 < chars.count, chars[i + 1] == "/" {
                var j = i
                while j < chars.count, chars[j] != "\n" { masked[j] = " "; j += 1 }
                i = j
                continue
            }

            if c == "/", i + 1 < chars.count, chars[i + 1] == "*" {
                var depth = 1
                masked[i] = " "; masked[i + 1] = " "
                var j = i + 2
                while j < chars.count, depth > 0 {
                    if chars[j] == "/", j + 1 < chars.count, chars[j + 1] == "*" {
                        depth += 1; masked[j] = " "; masked[j + 1] = " "; j += 2
                    } else if chars[j] == "*", j + 1 < chars.count, chars[j + 1] == "/" {
                        depth -= 1; masked[j] = " "; masked[j + 1] = " "; j += 2
                    } else {
                        masked[j] = " "; j += 1
                    }
                }
                i = j
                continue
            }

            // `#"…"#` / `##"…"##`. A `#` that is not a raw-string opener is
            // `#if`, `#filePath`, `#Predicate` — stepped over, not consumed.
            if c == "#" {
                var hashes = 0
                var j = i
                while j < chars.count, chars[j] == "#" { hashes += 1; j += 1 }
                if j < chars.count, chars[j] == "\"" {
                    let scanned = scanString(chars, from: j, hashes: hashes)
                    literals.append(SourceLiteral(pieces: scanned.pieces, start: i))
                    for k in i..<scanned.end { masked[k] = " " }
                    i = scanned.end
                } else {
                    i = j
                }
                continue
            }

            if c == "\"" {
                let scanned = scanString(chars, from: i, hashes: 0)
                literals.append(SourceLiteral(pieces: scanned.pieces, start: i))
                for k in i..<scanned.end { masked[k] = " " }
                i = scanned.end
                continue
            }

            i += 1
        }

        return Lexed(chars: chars, literals: literals, masked: masked)
    }

    /// `start` is the opening quote (after any `#`). Returns the index just past
    /// the closing delimiter.
    private static func scanString(_ chars: [Character],
                                   from start: Int,
                                   hashes: Int) -> (end: Int, pieces: [LiteralPiece]) {
        let n = chars.count
        var pieces: [LiteralPiece] = []
        var buf = ""

        let isMulti = start + 2 < n && chars[start + 1] == "\"" && chars[start + 2] == "\""
        let closeLen = isMulti ? 3 : 1
        var i = start + closeLen

        func closesHere(_ k: Int) -> Bool {
            guard k + closeLen + hashes <= n else { return false }
            for q in 0..<closeLen where chars[k + q] != "\"" { return false }
            for q in 0..<hashes where chars[k + closeLen + q] != "#" { return false }
            return true
        }

        func flush() {
            if !buf.isEmpty { pieces.append(.text(buf)); buf = "" }
        }

        while i < n {
            if closesHere(i) { i += closeLen + hashes; break }

            if chars[i] == "\\" {
                // In a raw string the escape is `\` followed by the same number
                // of `#`s that opened it.
                var k = i + 1
                var isEscape = true
                for _ in 0..<hashes {
                    if k < n, chars[k] == "#" { k += 1 } else { isEscape = false; break }
                }
                guard isEscape, k < n else { buf.append(chars[i]); i += 1; continue }

                if chars[k] == "(" {
                    flush()
                    let inner = scanInterpolation(chars, from: k + 1)
                    pieces.append(.expr(inner.expr))
                    i = inner.end
                    continue
                }

                switch chars[k] {
                case "n":  buf.append("\n")
                case "t":  buf.append("\t")
                case "r":  buf.append("\r")
                case "0":  buf.append("\0")
                case "\\": buf.append("\\")
                case "\"": buf.append("\"")
                case "'":  buf.append("'")
                case "u":
                    var k2 = k + 1
                    if k2 < n, chars[k2] == "{" {
                        k2 += 1
                        var hex = ""
                        while k2 < n, chars[k2] != "}" { hex.append(chars[k2]); k2 += 1 }
                        if let v = UInt32(hex, radix: 16), let s = Unicode.Scalar(v) {
                            buf.append(Character(s))
                        }
                        i = min(k2 + 1, n)
                        continue
                    }
                    buf.append("u")
                default:   buf.append(chars[k])
                }
                i = k + 1
                continue
            }

            buf.append(chars[i])
            i += 1
        }

        flush()
        return (i, pieces)
    }

    /// `start` is just past the `(`. Returns the index just past the matching
    /// `)`, and the expression's source with whitespace collapsed.
    private static func scanInterpolation(_ chars: [Character],
                                          from start: Int) -> (end: Int, expr: String) {
        let n = chars.count
        var depth = 1
        var i = start
        var out = ""

        while i < n {
            let c = chars[i]

            if c == "\"" {
                let scanned = scanString(chars, from: i, hashes: 0)
                out += String(chars[i..<scanned.end])
                i = scanned.end
                continue
            }
            if c == "(" { depth += 1 }
            if c == ")" {
                depth -= 1
                if depth == 0 { return (i + 1, collapse(out)) }
            }
            out.append(c)
            i += 1
        }
        return (i, collapse(out))
    }

    static func collapse(_ s: String) -> String {
        s.split(whereSeparator: { $0 == " " || $0 == "\n" || $0 == "\t" }).joined(separator: " ")
    }
}

// MARK: - A call site, extracted from real source

/// One `Text(…)` / `.accessibilityLabel(…)` / `URLRequest(…)` in the tree: what
/// it is called, the raw source of its argument list, and the literals inside.
struct CallSite {
    let file: String
    let callee: String
    /// Everything between the parentheses, whitespace collapsed.
    let argument: String
    let literals: [SourceLiteral]
    /// The same argument list with every string literal and comment blanked to
    /// spaces: the *expressions* alone, with none of the authored words. A
    /// check that is about what is bound into a string reads this; a check that
    /// is about the words reads `literals`.
    let argumentCode: String
    /// Character offset of the callee's first letter, for ordering.
    let start: Int

    var interpolations: [String] { literals.flatMap(\.interpolations) }

    /// Surfaces whose whole argument list *is* what the walker reads. A
    /// `Button`'s argument carries its action as well as its title, and a room
    /// that records a dwell when it is pressed is not a room that says one —
    /// so those callees contribute their interpolations and their words, and
    /// not the code they also happen to hold.
    static let speaksItsWholeArgument: Set<String> = [
        "Text", "accessibilityLabel", "accessibilityValue", "accessibilityHint",
        "accessibilityInputLabels", "navigationTitle", "navigationBarTitle",
        "help", "Label", "SharePreview",
    ]

    /// Every expression this call can put in front of the walker: the ones
    /// interpolated inside its strings, and — where the whole argument is
    /// speech — the one passed to it directly.
    var expressions: [String] {
        interpolations + (CallSite.speaksItsWholeArgument.contains(callee) ? [argumentCode] : [])
    }
    var origin: String {
        let a = argument.count > 140 ? String(argument.prefix(140)) + "…" : argument
        return "\(file) · \(callee)(\(a))"
    }
}

/// One `.swift` file of the shipping app, lexed once.
struct SourceFile {
    let path: String      // relative to the production root, e.g. "Views/Common/WellView.swift"
    let name: String      // "WellView.swift"
    let text: String
    let lexed: SwiftLexer.Lexed

    var literals: [SourceLiteral] { lexed.literals }

    /// Every call to any of `names`, with its literals. A name is matched only
    /// at an identifier boundary, so `ShareButton(` is not `Button(`; a leading
    /// `.` is allowed, because the modifiers are member calls.
    func calls(to names: [String]) -> [CallSite] {
        var found: [CallSite] = []
        let masked = lexed.masked

        for name in names {
            let needle = Array(name)
            var s = 0
            while let hit = SourceFile.index(of: needle, in: masked, from: s) {
                s = hit + 1
                if hit > 0, SourceFile.isIdentifier(masked[hit - 1]) { continue }
                var j = hit + needle.count
                if j < masked.count, SourceFile.isIdentifier(masked[j]) { continue }
                while j < masked.count, masked[j] == " " || masked[j] == "\n" { j += 1 }
                guard j < masked.count, masked[j] == "(" else { continue }

                var depth = 1
                var k = j + 1
                while k < masked.count, depth > 0 {
                    if masked[k] == "(" { depth += 1 }
                    else if masked[k] == ")" { depth -= 1 }
                    k += 1
                }
                guard depth == 0 else { continue }

                let argStart = j + 1
                let argEnd = k - 1
                let inside = lexed.literals.filter { $0.start > j && $0.start < argEnd }
                found.append(CallSite(
                    file: path,
                    callee: name,
                    argument: SwiftLexer.collapse(String(lexed.chars[argStart..<argEnd])),
                    literals: inside,
                    argumentCode: SwiftLexer.collapse(String(masked[argStart..<argEnd])),
                    start: hit))
            }
        }
        return found.sorted { $0.start < $1.start }
    }

    private static func isIdentifier(_ c: Character) -> Bool {
        c.isLetter || c.isNumber || c == "_"
    }

    private static func index(of needle: [Character], in hay: [Character], from: Int) -> Int? {
        guard !needle.isEmpty, hay.count >= needle.count else { return nil }
        var i = max(0, from)
        while i <= hay.count - needle.count {
            var ok = true
            for q in 0..<needle.count where hay[i + q] != needle[q] { ok = false; break }
            if ok { return i }
            i += 1
        }
        return nil
    }
}

// MARK: - Regex, kept short

enum Rx {
    static func matches(_ pattern: String, _ s: String, ignoresCase: Bool = false) -> Bool {
        first(pattern, s, ignoresCase: ignoresCase) != nil
    }

    static func first(_ pattern: String, _ s: String, ignoresCase: Bool = false) -> String? {
        all(pattern, s, ignoresCase: ignoresCase).first
    }

    /// Every whole match, in order.
    static func all(_ pattern: String, _ s: String, ignoresCase: Bool = false) -> [String] {
        guard let re = try? NSRegularExpression(pattern: pattern,
                                                options: ignoresCase ? [.caseInsensitive] : [])
        else { return [] }
        let ns = s as NSString
        return re.matches(in: s, options: [], range: NSRange(location: 0, length: ns.length))
            .map { ns.substring(with: $0.range) }
    }

    /// Every match, as its capture groups (group 0 first).
    static func groups(_ pattern: String, _ s: String, ignoresCase: Bool = false) -> [[String]] {
        guard let re = try? NSRegularExpression(pattern: pattern,
                                                options: ignoresCase ? [.caseInsensitive] : [])
        else { return [] }
        let ns = s as NSString
        return re.matches(in: s, options: [], range: NSRange(location: 0, length: ns.length))
            .map { m in
                (0..<m.numberOfRanges).map { i in
                    m.range(at: i).location == NSNotFound ? "" : ns.substring(with: m.range(at: i))
                }
            }
    }
}

// MARK: - The corpus, read off disk

enum LawSource {

    /// `…/iOS/Bindu MandalaTests/LawsTests.swift` → the repository root.
    ///
    /// Symlinks are resolved here and nowhere else, because on macOS `/tmp` is a
    /// symlink to `/private/tmp`: a checkout under one would have `#filePath`
    /// saying `/tmp/…` while the directory walker says `/private/tmp/…`, and
    /// every path in this file would be wrong in a way the naked eye skips over.
    static let repoRoot: URL = URL(fileURLWithPath: #filePath)
        .resolvingSymlinksInPath()
        .deletingLastPathComponent()   // Bindu MandalaTests
        .deletingLastPathComponent()   // iOS
        .deletingLastPathComponent()   // repo root

    static let productionRoot = repoRoot.appendingPathComponent("iOS/Bindu Mandala", isDirectory: true)
    static let unitTestRoot  = repoRoot.appendingPathComponent("iOS/Bindu MandalaTests", isDirectory: true)
    static let uiTestRoot    = repoRoot.appendingPathComponent("iOS/Bindu MandalaUITests", isDirectory: true)

    /// Every shipping `.swift` file, lexed once.
    static let production: [SourceFile] = swiftFiles(under: productionRoot)
    static let unitTests:  [SourceFile] = swiftFiles(under: unitTestRoot)
    static let uiTests:    [SourceFile] = swiftFiles(under: uiTestRoot)

    static func swiftFiles(under root: URL) -> [SourceFile] {
        guard let walker = FileManager.default.enumerator(at: root, includingPropertiesForKeys: nil)
        else { return [] }
        var out: [SourceFile] = []
        for case let url as URL in walker where url.pathExtension == "swift" {
            guard let text = try? String(contentsOf: url, encoding: .utf8) else { continue }
            out.append(SourceFile(path: relativePath(of: url, under: root),
                                  name: url.lastPathComponent,
                                  text: text,
                                  lexed: SwiftLexer.lex(text)))
        }
        return out.sorted { $0.path < $1.path }
    }

    /// "Views/Common/WellView.swift", computed from path components rather than
    /// by trimming a string prefix — a trim that misses produces something that
    /// still looks like a path ("/privateViews/Common/WellView.swift") and then
    /// quietly fails every `hasPrefix("Views/")` and every pinned site.
    static func relativePath(of url: URL, under root: URL) -> String {
        let base = root.resolvingSymlinksInPath().standardizedFileURL.pathComponents
        let full = url.resolvingSymlinksInPath().standardizedFileURL.pathComponents
        guard full.count > base.count, Array(full.prefix(base.count)) == base else {
            return url.lastPathComponent
        }
        return full.dropFirst(base.count).joined(separator: "/")
    }

    static func production(_ name: String) -> SourceFile? {
        production.first { $0.name == name }
    }

    static func unitTest(_ name: String) -> SourceFile? {
        unitTests.first { $0.name == name }
    }

    /// Every SwiftUI surface that puts words, or a value, in front of the
    /// walker. Leaf surfaces only — a container that takes a `@ViewBuilder`
    /// would swallow the calls nested inside it and report them twice.
    static let walkerFacingCallees = [
        "Text", "accessibilityLabel", "accessibilityValue", "accessibilityHint",
        "accessibilityInputLabels", "navigationTitle", "navigationBarTitle",
        "Button", "Label", "TextField", "SecureField", "Toggle", "Picker",
        "SharePreview", "alert", "confirmationDialog", "help",
    ]

    /// Every walker-facing call in the shipping app.
    static let walkerFacing: [CallSite] = production.flatMap { $0.calls(to: walkerFacingCallees) }

    /// The `var` names a `@Model` declares, read from the model's own source —
    /// so a property added tomorrow is covered by these laws today.
    static func modelProperties(of fileName: String) -> [String] {
        guard let f = production(fileName) else { return [] }
        // Comments are already blanked in `masked`, so a documented property
        // name inside a doc comment cannot be mistaken for a declaration.
        return Rx.groups(#"(?:^|\n)\s*(?:@Attribute\([^)]*\)\s*)?var\s+([A-Za-z_][A-Za-z0-9_]*)\s*:"#,
                         String(f.lexed.masked))
            .map { $0[1] }
    }
}

// MARK: - Law 2 · never measure — the view layer

/// The charter, §2.2: *"Felt data is unlimited. No count, streak, percentage, or
/// visit number is ever shown to the walker."*
///
/// Two independent detectors, because there are two ways to measure out loud.
/// **Words** — "Day 4", "62%", "a nine-day streak" — are caught by Design's nine
/// MEASURING patterns, run over the authored text of every walker-facing call.
/// **Values** — a count, a visit, a dwell bound into a string — are caught by
/// reading the *expressions*, with the literals blanked out, and refusing any
/// that touches the practice record.
enum NeverMeasure {

    // MARK: Design's nine, and the proof they have not drifted

    /// `homes-verify.js`'s `MEASURING`, as `HomesHarnessTests` ports it. They are
    /// restated here rather than shared, because the harness keeps its port
    /// private — and `testTheNinePatternsAreTheHarnessOwn` reads the harness's
    /// file off disk and asserts these are character-for-character the same, so
    /// the two copies cannot drift apart unnoticed.
    static let measuring: [(pattern: String, ignoresCase: Bool, catches: String)] = [
        (#"\b\d+\s*(?:of|\/)\s*\d+\b"#,       true,  "3 of 9"),
        (#"\b\d+\s*%"#,                        false, "62% there"),
        (#"\bvisit(?:s)?\s*[:=]\s*\d+"#,       true,  "visits: 4"),
        (#"\bstreak\b"#,                       true,  "a nine-day streak"),
        (#"\bprogress\b"#,                     true,  "your progress"),
        (#"\blevel\s*\d"#,                     true,  "Level 2"),
        (#"\bscore\b"#,                        true,  "her score"),
        (#"\bday\s*\d+\b"#,                    true,  "Day 11"),
        (#"\b\d+\s*(?:times|visits)\b"#,       true,  "felt 7 times"),
    ]

    static func measuresOutLoud(_ text: String) -> [String] {
        measuring.compactMap { Rx.matches($0.pattern, text, ignoresCase: $0.ignoresCase) ? $0.pattern : nil }
    }

    // MARK: The practice record — no exception exists for any of these

    /// A value from any of these reaching a walker-facing string is a Law-2
    /// breach. There is no allowlist, no pin, and no shape that redeems it: if a
    /// check below ever needs one of these to pass, the copy is wrong, not the
    /// check.
    static let practiceSymbols: [(what: String, pattern: String)] = [
        ("the server's recognition count", #"\bserverRecognitionCount\b"#),
        ("a recognition count",            #"\brecognitionCount\b"#),
        ("Airtable's Recognition Count",   #"Recognition Count"#),
        ("a visit count",                  #"\bvisitCount\b"#),
        ("visits",                         #"\bvisits\b"#),
        ("a dwell",                        #"[Dd]well"#),
        ("a streak",                       #"[Ss]treak\b"#),
        ("a score",                        #"\b[Ss]core\b"#),
        ("a percentage",                   #"[Pp]ercent"#),
        ("how often she was felt",         #"\b(timesFelt|feltCount|momentCount|recognitionTotal|crossingCount|silenceCount)\b"#),
        ("a silence duration",             #"\bdurationSec\b"#),
        ("the recognition log",            #"\bRecognitionLogStore\b"#),
        ("what a room remembers",          #"\bHomeMemory(Store)?\b"#),
    ]

    /// Which of the above `expression` touches, if any.
    static func practiceTouched(in expression: String) -> [String] {
        practiceSymbols.compactMap { Rx.matches($0.pattern, expression) ? $0.what : nil }
    }

    // MARK: Counting — structure may be counted, practice may not

    /// Every `…​.count` / `…Count` in an expression.
    static func countExpressions(in expression: String) -> [String] {
        Rx.all(#"[A-Za-z_][A-Za-z0-9_.]*(?:\.count|Count)\b"#, expression)
    }

    /// The counts the instrument is allowed to say out loud, pinned by exact
    /// equality so a new one cannot slip in under a substring rule.
    ///
    /// Every one of these counts the **mandala**, not the walking: they are the
    /// same number on the day the app is installed and ten years later. A count
    /// of anything the practitioner did is refused above, by `practiceSymbols`,
    /// before this set is ever consulted — so this pin cannot be used to launder
    /// a practice measure into a screen.
    static let structuralCounts: Set<String> = [
        "avarana.shaktiCount",          // how many seats this āvaraṇa holds — 28, 16, 8, …
        "seats.count",                  // the same number, counted from the ring's own roster
        "familyCount",                  // how many sisters share her family
        "ShaktiStatus.allCases.count",  // the four stages of embodiment
    ]

    // MARK: The one legitimate digit — a seat in the garland

    /// `102` is the size of the khaḍgamālā: fixed before the app existed and
    /// unchanged by anything the walker does. A digit is identity, not
    /// measurement, only when **both** halves hold — the bound is the garland,
    /// and the value is her position in it.
    ///
    /// Everything else fails: "3 of 9" (a ring count), "2 of 4" (a ladder),
    /// "⟨visits⟩ of 102" (a practice measure wearing identity's clothes), and
    /// "⟨kp⟩ of ⟨seats.count⟩" (a bound that is not the garland). The exception
    /// is keyed to *what the number is*, never to the shape it arrives in.
    static func isIdentity(numerator: String, denominator: String) -> Bool {
        let boundIsTheGarland: Bool
        if denominator == "102" {
            boundIsTheGarland = true
        } else if let e = marker(denominator) {
            boundIsTheGarland = e == "KhadgamalaMap.total"
        } else {
            boundIsTheGarland = false
        }
        guard boundIsTheGarland else { return false }

        guard let value = marker(numerator) else { return false }
        guard Rx.matches(#"\b(kp|khadgamalaPosition)\b"#, value) else { return false }
        // A position that has been counted, averaged or totalled is no longer a
        // position — belt and braces over `practiceSymbols`.
        guard practiceTouched(in: value).isEmpty else { return false }
        guard !Rx.matches(#"(?i)count|total|times|percent"#, value) else { return false }
        return true
    }

    /// Every interpolation stood in for by a digit, so a measuring phrase that
    /// straddles the boundary is still legible: `day ⟨n⟩` reads as "day 7", the
    /// thing Design's pattern was written to catch. Without this the words scan
    /// sees "day  " and the expression scan sees a bare `n`, and the phrase goes
    /// through the gap between them.
    ///
    /// Deliberately pessimistic — an interpolation that could never be a number
    /// is still probed as one. That costs nothing here, because a hit is not a
    /// verdict: it has to be either her khaḍgamālā position or a written-down
    /// exception before it passes.
    static func probe(_ shape: String) -> String {
        Rx.all(#"⟨[^⟩]*⟩"#, shape).reduce(shape) { $0.replacingOccurrences(of: $1, with: "7") }
    }

    /// `⟨expr⟩` → `expr`; digits → nil.
    static func marker(_ operand: String) -> String? {
        guard operand.hasPrefix("⟨"), operand.hasSuffix("⟩") else { return nil }
        return String(operand.dropFirst().dropLast())
    }

    /// Operand · separator · operand — "⟨kp⟩ of 102", "⟨kp⟩ · 102", "3 of 9".
    ///
    /// This finds candidates; it never grants anything. Only `isIdentity` does
    /// that, and only for her seat in the garland — so a pair that is merely
    /// shaped like a fraction ("⟨name⟩ · ⟨quality⟩") comes back here, is
    /// refused, and is then judged by the probe like every other string. It is
    /// deliberately not filtered down to pairs with literal digits: the day
    /// `102` is written as `KhadgamalaMap.total`, her seat must still be
    /// recognisable as her seat.
    static func digitShapes(in shape: String) -> [(whole: String, numerator: String, denominator: String)] {
        Rx.groups(#"(⟨[^⟩]*⟩|\d+)\s*(?:of|\/|·)\s*(⟨[^⟩]*⟩|\d+)"#, shape, ignoresCase: true)
            .map { (whole: $0[0], numerator: $0[1], denominator: $0[2]) }
    }

    /// The digit shapes that are neither a khaḍgamālā position nor a practice
    /// measure, kept with their reasoning written out, pinned by exact text.
    ///
    /// **`ShaktiDetailView`'s embodiment ladder.** The screen already draws four
    /// circles with the reached ones lit; the accessibility label says the same
    /// thing aloud. The rung is `ShaktiStatus` — mapped · exploring · active ·
    /// embodied — which she moves by a deliberate press on the status pill
    /// (`advanceStatus`: *"never automatic"*), and which no amount of practice
    /// advances on its own. So the digit is bound to a choice, not to anything
    /// felt, and deleting it would leave VoiceOver with less than the screen
    /// gives everyone else, against FIDELITY's parity rule.
    ///
    /// It is the closest thing in the tree to a progress readout, and it is
    /// written out here rather than dissolved into a broader rule, so that
    /// whoever owns that file can overrule it on sight. Reword it, move it, or
    /// add a second, and this suite goes red.
    static let pinnedNonIdentityDigits: Set<String> = [
        "Views/Common/ShaktiDetailView.swift · Embodiment: ⟨shakti.status.label⟩, level ⟨level + 1⟩ of ⟨ShaktiStatus.allCases.count⟩",
    ]
}

// MARK: - Law 3 · the two Recognition lines

/// Charter §2.3: *"The two Recognition lines stay verbatim, at every site,
/// forever."* Not "in spirit", not "capitalised to taste" — these exact words,
/// in this exact case.
enum RecognitionLines {

    static let feltHere = "she was felt here"
    static let feltBack = "and she felt you back"
    static let both = [feltHere, feltBack]

    /// The shape each line takes, loose enough to catch a rewording and tight
    /// enough not to catch the app's other sentences about being felt. Every
    /// match must come back **byte-identical** to the canonical line.
    ///
    /// These deliberately do not fire on the instrument's neighbouring copy —
    /// "She has not been felt here yet.", "You have always felt them.",
    /// "she is felt, not measured" — which says something else and is free to.
    static let shapes: [(pattern: String, canonical: String)] = [
        (#"(?i)\bshe\s+\w+\s+felt\s+here\b"#,             feltHere),
        (#"(?i)\b(?:and\s+)?she\s+\w+\s+you\s+back\b"#,   feltBack),
    ]

    /// A literal carrying this fragment, in any case, must carry the whole
    /// canonical line — which catches a truncation the shape patterns would
    /// happily match ("she felt you back", with the "and" dropped).
    static let fragments: [(fragment: String, canonical: String)] = [
        ("you back", feltBack),
        ("was felt here", feltHere),
    ]

    /// Act 1 is set in small caps: `Text("she was felt here · …".uppercased())`.
    /// That is typography, not a rewording — the words in the source are the
    /// words of the law, and the type treatment has been on that line since the
    /// ceremony was first built. It is pinned to one site so it stays one site,
    /// and so `.capitalized`, which really would change the sentence, cannot
    /// appear anywhere near either line.
    static let pinnedCaseTreatments: Set<String> = [
        "Views/Recognition/RecognitionMomentView.swift · uppercased",
    ]
}

// MARK: - Law 1 · position is identity

/// Charter §2.1: *"`khadgamalaPosition` 1–102 is the only key."* The harness
/// proves the behaviour — two Kāmeśvarīs stay two. This proves there is no way
/// to write the other thing: a name used as a key.
enum PositionIsIdentity {

    /// Source shapes that key a Śakti by what she is called. Display formatting
    /// is the only legitimate use of a name, and formatting never compares,
    /// filters, or subscripts by one.
    static let nameKeyedShapes: [(what: String, pattern: String)] = [
        ("a name-keyed map",             #"(?i)\bby_?name\b"#),
        ("a name-keyed map",             #"\[\s*String\s*:\s*(Shakti|Avarana|NityaDevi)\s*\]"#),
        ("a lookup by name",             #"\b\w*[Ss]hakti\s*\(\s*named\s*:"#),
        ("a lookup by name",             #"\bindex\s*\(\s*forName\s*:"#),
        ("a name in a predicate",        #"Predicate[\s\S]{0,200}?\.name\s*=="#),
        ("the ghost file",               #"all[-_]shaktis[-_]data"#),
    ]

    /// The lookup family: whatever their closures test, it must not be a name.
    /// Ordering is presentation and is deliberately not in this list — the Well
    /// may sort by name; it may not *find* by one.
    static let lookupCallees = ["first", "firstIndex", "last", "lastIndex", "filter", "contains"]

    /// The one place the instrument speaks a name to the server:
    /// `ActivityLedger.moments(shaktiName:)` narrows App Activity by the name in
    /// the link's primary field, because Airtable can only filter on what it can
    /// see. It is not identity, and `HomesHarnessTests`
    /// (`testHerMomentsNarrowsByNameButNeverIdentifiesByIt`) proves it: two
    /// same-named sisters produce identical rows and are still told apart, by
    /// the record id, client-side. Pinned so a second one cannot appear quietly.
    static let pinnedNameNarrowing: Set<String> = [
        "Data/ActivityLedger.swift · moments(shaktiName:)",
    ]

    /// Comparing one name to another is legitimate **only** to decide what to
    /// print. Every such comparison in the tree is written down here, so that a
    /// new one has to be classified by hand before it can compile.
    ///
    /// `LalitaSourceView`: `if lalita.name != shortName` — the hero shows her
    /// short name large and her full name beneath it, and this suppresses the
    /// second line when the two are the same word. Both sides are already
    /// display strings for the same Śakti; nothing is selected, found or keyed.
    static let pinnedDisplayComparisons: Set<String> = [
        "Views/Mandala/LalitaSourceView.swift · lalita.name != shortName",
    ]

    /// A `.name` reached from inside one of these is a lookup, not a label.
    static let lookupHeads = #"(?<![A-Za-z0-9_])(?:first|firstIndex|last|lastIndex|filter|contains|partition|removeAll|drop|prefix)"#
}

// MARK: - Law 4 · aniconic

/// Charter §2.4: *"No figural imagery for any Śakti. Forms are shapes performing
/// actions."*
///
/// The check is about what is **drawn**, and it is careful about what is not.
/// Her content fields carry iconographic prose out of Airtable — that is the
/// tradition's own language and it is data, not a picture — and the somatic
/// fields name places in the body ("throat", "heart", "skin") because that is
/// where she is felt. Neither is a figure. So the law is asserted where a figure
/// could actually appear: the asset catalogue, and the drawing primitives.
enum Aniconic {

    static let figuralVocabulary = #"(?i)\b(face|faces|eye|eyes|hand|hands|bodies|figure|figures|figural|goddess|deity|portrait|torso|limb|limbs|smile|mouth|breast|feet|foot|arm|arms|lip|lips|nude|naked|idol|murti|statue|photo|photograph|avatar|person|people|woman|women|girl|man|men)\b"#

    /// Every way a picture can reach the screen. `SharePreview` is deliberately
    /// not here: it takes a *title* and an image, and the image it is given is
    /// the app's own shapes already rendered by `ImageRenderer` — which the
    /// `Image` scan and the empty catalogue both cover.
    static let drawingCallees = ["Image", "UIImage", "NSImage", "AsyncImage"]

    static let imageExtensions: Set<String> = [
        "png", "jpg", "jpeg", "heic", "heif", "gif", "webp", "tiff", "bmp",
        "svg", "usdz", "scn", "dae", "obj",
    ]

    /// The only literal any drawing primitive in the shipping tree is handed —
    /// a disclosure chevron. Pinned by exact equality: a second one has to be
    /// written down here, where the law is, before it can be drawn.
    static let pinnedDrawnLiterals: Set<String> = ["chevron.right"]

    /// The whole asset catalogue. An app icon and a tint colour.
    static let pinnedCatalogue: Set<String> = ["AppIcon.appiconset", "AccentColor.colorset"]

    /// The only image file in the shipping tree.
    static let pinnedImageFiles: Set<String> = ["Assets.xcassets/AppIcon.appiconset/AppIcon.png"]

    /// Her fields that describe a form. They are read from Airtable and stored;
    /// they may not be put on a screen, because putting them on a screen is
    /// exactly the figure the law refuses — drawn in words instead of pixels.
    static let iconographicFields = ["iconography", "codexPortrait"]

    /// Shapes performing actions. The render path must actually be made of
    /// these, or "no figural asset" means only "no assets".
    static let geometricPrimitives = [
        "Circle", "Ellipse", "Rectangle", "RoundedRectangle", "Capsule", "Path",
        "Canvas", "Arc", "LinearGradient", "RadialGradient", "AngularGradient",
    ]
}

// MARK: - R17 · App Activity is the single record

/// Charter §2.5: every event is a ledger row; *"the Mandala table holds only
/// Śaktis and Avaraṇas and never event rows."* `ActivityLedgerTests` proves each
/// row's payload. This proves the topology: which table each verb reaches, and
/// where the ledger's vocabulary is allowed to exist at all.
enum LedgerIsTheRecord {

    /// What makes a row an *event* row. If any of this appears outside the
    /// ledger's own file, something else has learned to write events.
    static let eventVocabulary = [
        "Shakti Recognized", "Ring Crossed", "Silence Held", "Letter Written",
        "Activity Type",
    ]

    /// The Mandala table's old event discriminator. It must not exist anywhere.
    static let retiredDiscriminator = "Row Type"

    static let ledgerFile = "Data/ActivityLedger.swift"

    /// The event vocabulary spoken to the console rather than to Airtable. A log
    /// line is developer text and writes nothing, so it is allowed — and pinned,
    /// so the allowance stays one line long.
    static let pinnedLoggedVocabulary: Set<String> = [
        "Data/AirtableService.swift · Ring Crossed row already on server — skipping create",
    ]

    /// Where every literal handed to `os.Logger` starts, so the vocabulary check
    /// can tell a message from a payload.
    static func loggedLiteralStarts(in f: SourceFile) -> Set<Int> {
        var out: Set<Int> = []
        for call in f.calls(to: ["notice", "error", "debug", "info", "fault", "critical", "trace"]) {
            for l in call.literals { out.insert(l.start) }
        }
        return out
    }

    /// One HTTP request in the shipping tree.
    struct HTTPSite {
        let file: String
        let variable: String
        /// The URL with its interpolations kept: `…/⟨Self.baseId⟩/⟨Self.tableId⟩/⟨recordId⟩`.
        let urlShape: String
        /// `nil` means no `httpMethod` was set — URLSession's default, a GET.
        let method: String?
        let hasBody: Bool

        var table: String {
            if urlShape.contains("⟨ActivityLedger.tableId⟩") { return "App Activity" }
            if urlShape.contains("⟨Self.tableId⟩") { return "Mandala" }
            if urlShape.contains("tableId") { return "either (resolved at run time)" }
            return "unknown"
        }

        /// The last path segment, if it is an interpolation — a PATCH addressed
        /// by record id ends in one, a create never does.
        var lastSegment: String? {
            urlShape.split(separator: "/").last.map(String.init)
        }

        var origin: String { "\(file) · \(variable) · \(method ?? "GET") \(urlShape)" }
    }

    /// Read the request sites out of one file: which variable, which URL, which
    /// verb, and whether a body was attached.
    ///
    /// Paired by **position**, not by name. `AirtableService` calls its request
    /// `req` in five different functions; a name-keyed map would fold all five
    /// into whichever verb was assigned last, and report one POST as five.
    static func httpSites(in f: SourceFile) -> [HTTPSite] {
        struct Decl { let name: String; let shape: String; let isRequest: Bool; let at: Int }
        var decls: [Decl] = []
        var shapeByVar: [String: String] = [:]

        // `URLComponents` first, so a request built from `comps.url` can inherit
        // the shape the components were given.
        for callee in ["URLComponents", "URLRequest"] {
            for site in f.calls(to: [callee]) {
                let before = SwiftLexer.collapse(
                    String(f.lexed.chars[max(0, site.start - 90)..<site.start]))
                guard let name = Rx.groups(#"(?:var|let)\s+([A-Za-z_][A-Za-z0-9_]*)\s*(?::[^=]*)?=\s*$"#,
                                           before).last?[1]
                else { continue }

                var shape = ""
                if let lit = site.literals.first(where: { $0.shape.contains("http") }) {
                    shape = lit.shape
                } else if let src = Rx.first(#"[A-Za-z_][A-Za-z0-9_]*(?=\.url\b)"#, site.argumentCode),
                          let inherited = shapeByVar[src] {
                    shape = inherited
                }
                shapeByVar[name] = shape
                decls.append(Decl(name: name, shape: shape,
                                  isRequest: callee == "URLRequest", at: site.start))
            }
        }

        let verbs = f.assignments(to: "httpMethod").compactMap { a -> (name: String, verb: String, at: Int)? in
            guard let lit = f.lexed.literals.first(where: { $0.start > a.at && $0.start < a.at + 28 })
            else { return nil }
            return (a.variable, lit.text, a.at)
        }
        let bodies = f.assignments(to: "httpBody")

        let requests = decls.filter(\.isRequest).sorted { $0.at < $1.at }
        return requests.enumerated().map { i, d in
            // This request owns the assignments between its own declaration and
            // the next declaration that reuses its name.
            let scopeEnd = requests.dropFirst(i + 1).first { $0.name == d.name }?.at ?? Int.max
            let verb = verbs.first { $0.name == d.name && $0.at > d.at && $0.at < scopeEnd }?.verb
            let hasBody = bodies.contains { $0.variable == d.name && $0.at > d.at && $0.at < scopeEnd }
            return HTTPSite(file: f.path, variable: d.name, urlShape: d.shape,
                            method: verb, hasBody: hasBody)
        }
    }

    static var allHTTPSites: [HTTPSite] {
        LawSource.production.flatMap { httpSites(in: $0) }
    }

    /// The Shakti-row field names the Mandala PATCHes carry, read from
    /// `AirtableService`'s own constants rather than typed out here.
    static var mandalaPatchFields: [String] {
        guard let f = LawSource.production("AirtableService.swift") else { return [] }
        return Rx.groups(#"static\s+let\s+fld[A-Za-z0-9_]*\s*=\s*"([^"]+)""#, f.text).map { $0[1] }
    }
}

// MARK: - Assignments, for the HTTP topology

extension SourceFile {
    /// Every `<variable>.<member> = …` in the file, with the character offset of
    /// the member, so an assignment can be paired with the declaration it
    /// follows rather than with a variable of the same name three functions away.
    func assignments(to member: String) -> [(variable: String, at: Int)] {
        let masked = lexed.masked
        let needle = Array("." + member)
        var out: [(variable: String, at: Int)] = []
        var i = 0

        while let hit = SourceFile.index(of: needle, in: masked, from: i) {
            i = hit + 1
            var j = hit + needle.count
            if j < masked.count, SourceFile.isIdentifier(masked[j]) { continue }
            while j < masked.count, masked[j] == " " { j += 1 }
            guard j + 1 < masked.count, masked[j] == "=", masked[j + 1] != "=" else { continue }

            var k = hit - 1
            var name = ""
            while k >= 0, SourceFile.isIdentifier(masked[k]) {
                name = String(masked[k]) + name
                k -= 1
            }
            guard !name.isEmpty else { continue }
            out.append((name, hit))
        }
        return out
    }
}

// MARK: - Closure bodies, for the lookup family

extension SourceFile {
    /// Every `first { … }` / `filter(where: { … })` body in the file, paired
    /// with the head that opened it. Trailing-closure form and parenthesised
    /// form both, because the lookup family is written either way.
    ///
    /// Matched positionally: five `first {`s in one file are five closures, not
    /// the first one read five times.
    func lookupClosures(head: String) -> [(head: String, body: String)] {
        let text = String(lexed.masked)
        guard let re = try? NSRegularExpression(
            pattern: head + #"\s*(?:\(\s*(?:where\s*:)?\s*)?\{"#) else { return [] }

        let ns = text as NSString
        var out: [(head: String, body: String)] = []

        for m in re.matches(in: text, options: [], range: NSRange(location: 0, length: ns.length)) {
            guard let r = Range(m.range, in: text) else { continue }
            var depth = 0
            var i = text.index(before: r.upperBound)   // the `{` the head opened
            var body = ""
            while i < text.endIndex {
                let c = text[i]
                if c == "{" { depth += 1 }
                if c == "}" {
                    depth -= 1
                    if depth == 0 { body.append(c); break }
                }
                body.append(c)
                i = text.index(after: i)
            }
            guard depth == 0, !body.isEmpty else { continue }
            out.append((SwiftLexer.collapse(String(text[r])), SwiftLexer.collapse(body)))
        }
        return out
    }
}

// MARK: - The suite

@MainActor
final class LawsTests: XCTestCase {

    // MARK: - The corpus itself
    //
    // Every check below reads real files. If the reading stops working — a
    // moved directory, a renamed target, a refactor that empties a scan — the
    // checks would all pass while proving nothing. This runs first and loudly.

    func testTheCorpusIsReallyTheShippingApp() {
        XCTAssertTrue(FileManager.default.fileExists(atPath: LawSource.productionRoot.path),
                      "the shipping source is not where `#filePath` says it should be: \(LawSource.productionRoot.path)")

        XCTAssertGreaterThanOrEqual(LawSource.production.count, 60,
                                    "only \(LawSource.production.count) shipping files were read — the scanner has lost the tree")
        XCTAssertGreaterThanOrEqual(LawSource.unitTests.count, 20,
                                    "the unit-test target was not found")

        // The files the laws below name by hand must actually be among them.
        let names = Set(LawSource.production.map(\.name))
        for expected in ["AirtableService.swift", "ActivityLedger.swift", "Shakti.swift",
                         "HomeMemory.swift", "KhadgamalaMap.swift", "RecognitionMomentView.swift",
                         "ShaktiDetailView.swift", "WellView.swift", "DailyRiteView.swift",
                         "TheHundredTwoView.swift", "LalitaSourceView.swift"] {
            XCTAssertTrue(names.contains(expected), "\(expected) is missing from the corpus")
        }

        // The lexer found words, expressions and calls — not an empty tree.
        let literals = LawSource.production.flatMap(\.literals)
        XCTAssertGreaterThanOrEqual(literals.count, 800,
                                    "only \(literals.count) string literals were lexed")
        XCTAssertGreaterThanOrEqual(literals.flatMap(\.interpolations).count, 180,
                                    "the lexer is not seeing interpolations")
        XCTAssertGreaterThanOrEqual(LawSource.walkerFacing.count, 150,
                                    "only \(LawSource.walkerFacing.count) walker-facing calls were found")
        XCTAssertGreaterThanOrEqual(LawSource.walkerFacing.flatMap(\.literals).count, 80,
                                    "the walker-facing scan found almost no words")

        // And it is reading *code* too, not only strings.
        let code = LawSource.production.reduce(0) { $0 + $1.lexed.masked.count }
        XCTAssertGreaterThanOrEqual(code, 200_000, "the masked-code corpus is too small to be the app")
    }

    func testTheLexerHandlesWhatSwiftActuallyWrites() {
        let f = synthetic(#"""
        // "not a literal" and \(not an interpolation)
        /* nor /* this */ "one" */
        let a = "plain"
        let b = "seat \(kp) of 102"
        let c = #"raw \(not interpolated)"#
        let d = "nested \(x ? "yes" : "no") done"
        let e = "escaped \" quote and \u{201C}curly\u{201D}"
        """#)

        let texts = f.literals.map(\.text)
        XCTAssertTrue(texts.contains("plain"))
        XCTAssertTrue(texts.contains(#"raw \(not interpolated)"#))
        XCTAssertTrue(texts.contains("escaped \" quote and \u{201C}curly\u{201D}"))
        XCTAssertFalse(texts.contains("not a literal"), "a comment was lexed as a string")
        XCTAssertFalse(texts.contains("one"), "a string inside a block comment was lexed")

        let b = f.literals.first { $0.shape.contains("of 102") }
        XCTAssertEqual(b?.shape, "seat ⟨kp⟩ of 102")
        XCTAssertEqual(b?.text, "seat  of 102")

        let d = f.literals.first { $0.text.hasPrefix("nested") }
        XCTAssertEqual(d?.interpolations, [#"x ? "yes" : "no""#],
                       "an interpolation holding its own strings must come back whole")
    }

    // MARK: - Law 2 · never measure, in the view layer
    //
    // `HomesHarnessTests` reads every string the instrument *composes*. Nothing
    // here repeats that. These read the *views*, which it says it cannot.

    /// The nine patterns in this file must be the harness's nine, character for
    /// character. Read out of `HomesHarnessTests.swift` on disk rather than
    /// remembered, so a change to Design's port fails here instead of quietly
    /// leaving two different detectors in one suite.
    func testTheNinePatternsAreTheHarnessOwn() throws {
        let harness = try XCTUnwrap(LawSource.unitTest("HomesHarnessTests.swift"),
                                    "the harness is gone — the two ports cannot be compared")
        let ported = harness.calls(to: ["Pattern"])
        XCTAssertEqual(ported.count, 9, "the harness carries \(ported.count) MEASURING patterns, not nine")

        // `Pattern(js:pattern:ignoresCase:catches:)` — the second literal is the body.
        let theirs = ported.compactMap { $0.literals.count >= 2 ? $0.literals[1].text : nil }
        XCTAssertEqual(theirs.count, 9, "a Pattern(…) in the harness no longer carries two literals")
        XCTAssertEqual(theirs, NeverMeasure.measuring.map(\.pattern),
                       """
                       this file's MEASURING has drifted from the harness's port of \
                       `homes-verify.js`. They must stay the same nine.
                       """)
    }

    /// The detector's own proof. A check like this is worthless if it cannot
    /// fail, so every rule below is shown catching the thing it exists for and
    /// letting the instrument's real vocabulary through.
    func testTheDetectorCatchesWhatItIsFor() {
        for p in NeverMeasure.measuring {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(p.catches).contains(p.pattern),
                          "\(p.pattern) failed to catch \"\(p.catches)\"")
        }
        for clean in ["She is waiting.", "Kāmākarṣiṇī — first recognition",
                      "Where do you feel her, right now?", "Ninth Āvaraṇa — crossed",
                      "she was felt here", "and she felt you back",
                      "Of the second āvaraṇa — the sixteen petals"] {
            XCTAssertTrue(NeverMeasure.measuresOutLoud(clean).isEmpty,
                          "false positive on \"\(clean)\"")
        }

        // Practice values are refused wherever they are written.
        for measured in ["shakti.serverRecognitionCount", "memory.accumulatedDwell",
                         "room.visits", "store.longestDwell", "currentStreak",
                         "HomeMemoryStore(context: c).compression(for: kp)"] {
            XCTAssertFalse(NeverMeasure.practiceTouched(in: measured).isEmpty,
                           "\"\(measured)\" slipped past the practice detector")
        }
        for structural in ["seats.count", "content.kp", "shakti.khadgamalaPosition",
                           "avarana.shaktiCount", "shakti.quality"] {
            XCTAssertTrue(NeverMeasure.practiceTouched(in: structural).isEmpty,
                          "false positive on \"\(structural)\": \(NeverMeasure.practiceTouched(in: structural))")
        }

        // The identity exception: both halves must hold, and nothing else does.
        XCTAssertTrue(NeverMeasure.isIdentity(numerator: "⟨content.kp⟩", denominator: "102"))
        XCTAssertTrue(NeverMeasure.isIdentity(numerator: "⟨kp⟩", denominator: "⟨KhadgamalaMap.total⟩"))
        XCTAssertFalse(NeverMeasure.isIdentity(numerator: "3", denominator: "9"),
                       "a bare fraction is not identity")
        XCTAssertFalse(NeverMeasure.isIdentity(numerator: "⟨kp⟩", denominator: "9"),
                       "the bound must be the garland, not a ring")
        XCTAssertFalse(NeverMeasure.isIdentity(numerator: "⟨kp⟩", denominator: "⟨seats.count⟩"),
                       "a bound that can change is not the garland")
        XCTAssertFalse(NeverMeasure.isIdentity(numerator: "⟨memory.visits⟩", denominator: "102"),
                       "a visit count wearing identity's clothes is still a visit count")
        XCTAssertFalse(NeverMeasure.isIdentity(numerator: "⟨recognitionCount⟩", denominator: "102"))
        XCTAssertFalse(NeverMeasure.isIdentity(numerator: "⟨level + 1⟩", denominator: "⟨ShaktiStatus.allCases.count⟩"),
                       "the embodiment ladder is not a khaḍgamālā position — it is pinned, not allowed")

        // End to end, over source the scanner has never seen.
        let bad = synthetic(#"""
        struct Bad: View {
            var body: some View {
                Text("felt \(memory.visits) times")
                Text("\(memory.visits) of 102")
                Text("day \(n) of your practice")
                Text("\(kp) of 102")
                    .accessibilityLabel("Your progress: 62%")
            }
        }
        """#)
        let calls = bad.calls(to: LawSource.walkerFacingCallees)
        XCTAssertGreaterThanOrEqual(calls.count, 5, "the synthetic view was not read")

        let measuredWords = calls.flatMap { c in c.literals.flatMap { NeverMeasure.measuresOutLoud($0.text) } }
        XCTAssertFalse(measuredWords.isEmpty, "\"62%\" and \"felt … times\" must be caught in the words")

        let practice = calls.flatMap { c in c.expressions.flatMap(NeverMeasure.practiceTouched) }
        XCTAssertFalse(practice.isEmpty, "`memory.visits` must be caught in the expressions")

        var allowed = 0
        var refused: [String] = []
        for c in calls {
            for lit in c.literals {
                var remaining = lit.shape
                var sawHerSeat = false
                for d in NeverMeasure.digitShapes(in: lit.shape)
                where NeverMeasure.isIdentity(numerator: d.numerator, denominator: d.denominator) {
                    remaining = remaining.replacingOccurrences(of: d.whole, with: " her seat ")
                    sawHerSeat = true
                }
                if sawHerSeat { allowed += 1 }
                if !NeverMeasure.measuresOutLoud(NeverMeasure.probe(remaining)).isEmpty {
                    refused.append(lit.shape)
                }
            }
        }
        XCTAssertEqual(allowed, 1, "only `\\(kp) of 102` is her seat")
        XCTAssertEqual(refused.count, 4,
                       """
                       four of the five synthetic strings measure: the visit count, the visit count \
                       dressed as a position, "day N", and the percentage. Caught: \(refused)
                       """)
        // The probe is what catches the one that straddles the boundary.
        XCTAssertTrue(refused.contains { $0.contains("day ⟨n⟩") },
                      "`day \\(n) of your practice` measures, and only the probe can see it")
    }

    /// The words. Every authored string in a `Text`, an accessibility label, a
    /// button, an alert — run against Design's nine.
    func testNoWalkerFacingViewMeasuresOutLoud() {
        var offences: [String] = []
        var read = 0
        for call in LawSource.walkerFacing {
            for lit in call.literals {
                read += 1
                let hits = NeverMeasure.measuresOutLoud(lit.text)
                if !hits.isEmpty {
                    offences.append("\(call.origin) — \"\(lit.text)\" trips \(hits.joined(separator: ", "))")
                }
            }
        }
        XCTAssertGreaterThanOrEqual(read, 80, "the detector read \(read) strings — too few to be the view layer")
        XCTAssertTrue(offences.isEmpty,
                      """
                      \(offences.count) walker-facing string(s) measure out loud — a Law-2 breach. \
                      Change the copy; never weaken the pattern.
                      \(offences.joined(separator: "\n"))
                      """)
    }

    /// The values. No count, visit, dwell or recognition total may be bound into
    /// anything the walker reads. `HomeMemory`'s properties are read from the
    /// model's own source, so a property added tomorrow is covered today.
    func testNoPracticeValueIsBoundIntoAViewString() {
        // Everything a room remembers, straight off the model — minus the
        // identity key it is filed under, which is not a measure.
        let roomMemory = LawSource.modelProperties(of: "HomeMemory.swift")
            .filter { $0 != "khadgamalaPosition" }
        XCTAssertGreaterThanOrEqual(roomMemory.count, 6,
                                    "HomeMemory's properties were not read: \(roomMemory)")
        for expected in ["visits", "accumulatedDwell", "longestDwell", "lastDwell",
                         "lastVisit", "deepestAdaptation"] {
            XCTAssertTrue(roomMemory.contains(expected), "HomeMemory.\(expected) went missing from the model scan")
        }

        // Her row's measurement mirror. Her `lastFelt` is a moment, not a
        // measure, and is deliberately not on this list.
        let mirrors = ["serverRecognitionCount"]
        XCTAssertTrue(LawSource.modelProperties(of: "Shakti.swift").contains("serverRecognitionCount"),
                      "Shakti.serverRecognitionCount went missing from the model scan")

        var offences: [String] = []
        var read = 0
        for call in LawSource.walkerFacing {
            for expr in call.expressions where !expr.isEmpty {
                read += 1
                for what in NeverMeasure.practiceTouched(in: expr) {
                    offences.append("\(call.origin) — binds \(what): \(expr)")
                }
                for prop in roomMemory where Rx.matches(#"\b\#(prop)\b"#, expr) {
                    offences.append("\(call.origin) — binds HomeMemory.\(prop), which never reaches a screen: \(expr)")
                }
                for m in mirrors where Rx.matches(#"\b\#(m)\b"#, expr) {
                    offences.append("\(call.origin) — binds \(m): \(expr)")
                }
            }
        }
        XCTAssertGreaterThanOrEqual(read, 100, "only \(read) expressions were read from the view layer")
        XCTAssertTrue(offences.isEmpty,
                      """
                      \(offences.count) walker-facing string(s) bind the practitioner's own practice \
                      into what she reads — a Law-2 breach with no exception. The instrument may know \
                      all of this; it may not say it.
                      \(offences.joined(separator: "\n"))
                      """)
    }

    /// The mandala may be counted. The walking may not. Every count that
    /// reaches a screen is pinned by exact equality, so a new one has to be
    /// written down and argued for.
    func testOnlyTheMandalaItselfIsEverCounted() {
        var found: Set<String> = []
        for call in LawSource.walkerFacing {
            for expr in call.expressions {
                found.formUnion(NeverMeasure.countExpressions(in: expr))
            }
        }
        XCTAssertFalse(found.isEmpty, "no counts at all were found — the scan is not reading expressions")
        XCTAssertEqual(found, NeverMeasure.structuralCounts,
                       """
                       the set of counts the instrument says out loud has changed. Each one must be a \
                       fact about the mandala — the same number on the first day and the ten-thousandth \
                       — never a count of anything she did. Classify it in `structuralCounts`, with a \
                       reason, or take the digit off the screen.
                       """)
        // And the pin cannot launder a practice measure: these two rules are
        // independent, and the practice rule wins.
        for c in found {
            XCTAssertTrue(NeverMeasure.practiceTouched(in: c).isEmpty,
                          "\(c) is pinned as structural but reads as practice — the pin does not override Law 2")
        }
    }

    /// The only digit the walker may see is a seat in the garland.
    ///
    /// Every walker-facing string is probed with its interpolations standing as
    /// digits, so a number that arrives at run time is read as the number it is.
    /// Her khaḍgamālā position is struck out first — it is identity, not
    /// measurement — and whatever Design's nine still find in what is left must
    /// be written down, with a reason, or taken off the screen.
    func testTheOnlyDigitShapeIsASeatInTheGarland() {
        var identity: [String] = []
        var offences: Set<String> = []
        var probed = 0

        for call in LawSource.walkerFacing {
            for lit in call.literals {
                probed += 1
                var remaining = lit.shape
                var sawHerSeat = false
                for d in NeverMeasure.digitShapes(in: lit.shape)
                where NeverMeasure.isIdentity(numerator: d.numerator, denominator: d.denominator) {
                    remaining = remaining.replacingOccurrences(of: d.whole, with: " her seat ")
                    sawHerSeat = true
                }
                if sawHerSeat { identity.append("\(call.file) · \(lit.shape)") }

                if !NeverMeasure.measuresOutLoud(NeverMeasure.probe(remaining)).isEmpty {
                    offences.insert("\(call.file) · \(lit.shape)")
                }
            }
        }

        XCTAssertGreaterThanOrEqual(probed, 80, "only \(probed) walker-facing strings were probed")
        XCTAssertGreaterThanOrEqual(identity.count, 2,
                                    "her position should be on screen in at least two places: \(identity)")
        XCTAssertEqual(offences, NeverMeasure.pinnedNonIdentityDigits,
                       """
                       a number that is neither her khaḍgamālā position nor a refused practice measure \
                       reached the walker. Take it off the screen, or write it into \
                       `pinnedNonIdentityDigits` with the reason it is not a measurement.
                       """)
    }

    // MARK: - Law 3 · the two Recognition lines

    func testBothRecognitionLinesAreVerbatimAtEverySite() {
        var sites: [String: [String]] = [:]
        for f in LawSource.production {
            for lit in f.literals {
                for line in RecognitionLines.both where lit.text.contains(line) {
                    sites[line, default: []].append(f.path)
                }
            }
        }

        let here = sites[RecognitionLines.feltHere] ?? []
        let back = sites[RecognitionLines.feltBack] ?? []

        XCTAssertGreaterThanOrEqual(here.count, 5,
                                    "\"\(RecognitionLines.feltHere)\" is written at \(here.count) place(s); it was at 5")
        XCTAssertGreaterThanOrEqual(Set(here).count, 2,
                                    "\"\(RecognitionLines.feltHere)\" should be in at least two files: \(Set(here))")
        XCTAssertGreaterThanOrEqual(back.count, 1,
                                    "\"\(RecognitionLines.feltBack)\" is not written anywhere")

        for expected in ["Views/Recognition/RecognitionMomentView.swift",
                         "Views/Common/ShaktiDetailView.swift"] {
            XCTAssertTrue(here.contains(expected), "\(expected) no longer says \"\(RecognitionLines.feltHere)\"")
        }
        XCTAssertTrue(back.contains("Views/Recognition/RecognitionMomentView.swift"),
                      "the ceremony no longer says \"\(RecognitionLines.feltBack)\"")
    }

    /// A well-meant rewording must fail the build. Anything in the tree shaped
    /// like one of the two lines has to *be* one of the two lines.
    func testNothingNearlySaysTheRecognitionLines() {
        // The UI test target too: it is where the line is asserted on a running
        // app, and a reworded expectation there would hide a reworded line.
        let corpus = LawSource.production + LawSource.uiTests
        var read = 0
        var offences: [String] = []

        for f in corpus {
            for lit in f.literals {
                read += 1
                for (pattern, canonical) in RecognitionLines.shapes {
                    for m in Rx.all(pattern, lit.text) where m != canonical {
                        offences.append("\(f.path) — \"\(m)\" is not \"\(canonical)\"")
                    }
                }
                for (fragment, canonical) in RecognitionLines.fragments
                where lit.text.lowercased().contains(fragment) && !lit.text.contains(canonical) {
                    offences.append("\(f.path) — \"\(lit.text)\" carries \"\(fragment)\" without \"\(canonical)\"")
                }
            }
        }

        XCTAssertGreaterThanOrEqual(read, 800, "only \(read) literals were read")
        XCTAssertTrue(offences.isEmpty,
                      """
                      the Recognition lines have drifted. They are verbatim, at every site, forever:
                      "\(RecognitionLines.feltHere)" / "\(RecognitionLines.feltBack)"
                      \(offences.joined(separator: "\n"))
                      """)

        // The near-miss detector can fail: prove it on strings it has never seen.
        for wrong in ["She Was Felt Here", "she was Felt here", "she is felt here",
                      "she were felt here", "she feels you back",
                      "she felt you back", "And She Felt You Back", "she felt you back again"] {
            let caught = RecognitionLines.shapes.contains { s in
                Rx.all(s.pattern, wrong).contains { $0 != s.canonical }
            } || RecognitionLines.fragments.contains { f in
                wrong.lowercased().contains(f.fragment) && !wrong.contains(f.canonical)
            }
            XCTAssertTrue(caught, "\"\(wrong)\" slipped past the near-miss detector")
        }
        // …and it must let the real lines through, in their real settings.
        for right in ["she was felt here · 6:14 AM", "and she felt you back · 6:14:03 AM",
                      "'she was felt here · today,' h:mm a", "she was felt here",
                      "She has not been felt here yet.", "You have always felt them.",
                      "she is felt, not measured"] {
            let caught = RecognitionLines.shapes.contains { s in
                Rx.all(s.pattern, right).contains { $0 != s.canonical }
            } || RecognitionLines.fragments.contains { f in
                right.lowercased().contains(f.fragment) && !right.contains(f.canonical)
            }
            XCTAssertFalse(caught, "false positive on \"\(right)\"")
        }
    }

    /// The ceremony's two acts, and the one type treatment either line is
    /// allowed to carry.
    func testTheCeremonyStillSpeaksBothLines() throws {
        let view = try XCTUnwrap(LawSource.production("RecognitionMomentView.swift"))
        let texts = view.calls(to: ["Text"])
        XCTAssertGreaterThanOrEqual(texts.count, 3, "the ceremony has stopped rendering text")

        let act1 = texts.filter { c in c.literals.contains { $0.text.contains(RecognitionLines.feltHere) } }
        let act2 = texts.filter { c in c.literals.contains { $0.text.contains(RecognitionLines.feltBack) } }
        XCTAssertEqual(act1.count, 1, "Act 1 should be spoken exactly once in the ceremony")
        XCTAssertEqual(act2.count, 1, "Act 2 should be spoken exactly once in the ceremony")

        var treatments: Set<String> = []
        for f in LawSource.production {
            for call in f.calls(to: LawSource.walkerFacingCallees) {
                guard call.literals.contains(where: { l in
                    RecognitionLines.both.contains { l.text.contains($0) }
                }) else { continue }
                for t in ["uppercased", "lowercased", "capitalized"] where call.argument.contains(t + "(") {
                    treatments.insert("\(f.path) · \(t)")
                }
            }
        }
        XCTAssertEqual(treatments, RecognitionLines.pinnedCaseTreatments,
                       """
                       the case treatment on a Recognition line changed. Act 1 is set in small caps and \
                       always has been; `.capitalized` would rewrite the sentence and is never allowed.
                       """)
    }

    // MARK: - Law 1 · position is identity

    func testNoNameKeyedShaktiLookupExists() {
        var offences: [String] = []
        for f in LawSource.production {
            let code = String(f.lexed.masked)
            for (what, pattern) in PositionIsIdentity.nameKeyedShapes {
                for m in Rx.all(pattern, code) {
                    offences.append("\(f.path) — \(what): \(SwiftLexer.collapse(m))")
                }
            }
        }
        XCTAssertTrue(offences.isEmpty,
                      """
                      a Śakti is being keyed by her name. Names collide across rings — Kāmeśvarī sits \
                      in Ring 7 and Ring 8 — so a name is never identity. Key on khaḍgamālā position.
                      \(offences.joined(separator: "\n"))
                      """)

        // The detector can fail.
        let bad = synthetic("""
        let byName = [String: Shakti]()
        let x = all.first(where: { $0.name == wanted })
        """)
        let caught = PositionIsIdentity.nameKeyedShapes.contains {
            Rx.matches($0.pattern, String(bad.lexed.masked))
        }
        XCTAssertTrue(caught, "the name-keyed detector caught nothing in a file written to break it")
    }

    /// The lookup family — `first`, `filter`, `contains`, … — must never reach
    /// for a name. Display may compare names; finding may not.
    func testNoLookupClosureFindsAShaktiByName() {
        var offences: [String] = []
        var closures = 0
        for f in LawSource.production {
            for c in f.lookupClosures(head: PositionIsIdentity.lookupHeads) {
                closures += 1
                if Rx.matches(#"\.name\b"#, c.body) {
                    offences.append("\(f.path) — \(c.head) … \(c.body.prefix(120))")
                }
            }
        }
        XCTAssertGreaterThanOrEqual(closures, 20,
                                    "only \(closures) lookup closures were found — the scan is not reading them")
        XCTAssertTrue(offences.isEmpty,
                      """
                      a lookup is finding a Śakti by her name.
                      \(offences.joined(separator: "\n"))
                      """)

        // Every name comparison in the tree, classified.
        var comparisons: Set<String> = []
        for f in LawSource.production {
            for m in Rx.all(#"[A-Za-z_][A-Za-z0-9_.]*\.name\s*[!=]=\s*[A-Za-z_$][A-Za-z0-9_.]*"#,
                            String(f.lexed.masked)) {
                comparisons.insert("\(f.path) · \(SwiftLexer.collapse(m))")
            }
            for m in Rx.all(#"[A-Za-z_$][A-Za-z0-9_.]*\s*[!=]=\s*[A-Za-z_][A-Za-z0-9_.]*\.name\b"#,
                            String(f.lexed.masked)) {
                comparisons.insert("\(f.path) · \(SwiftLexer.collapse(m))")
            }
        }
        XCTAssertEqual(comparisons, PositionIsIdentity.pinnedDisplayComparisons,
                       """
                       a name is being compared somewhere new. Display formatting is the only \
                       legitimate use of a name — write the site into `pinnedDisplayComparisons` \
                       with the reason nothing is being selected by it, or key on position instead.
                       """)
    }

    /// Everything that files a Śakti — the uniqueness constraints, the store
    /// APIs, the SwiftData predicates — files her by position.
    func testEveryPerShaktiKeyIsAPosition() {
        var uniques: [(file: String, property: String, type: String)] = []
        for f in LawSource.production {
            for g in Rx.groups(#"@Attribute\(\s*\.unique\s*\)\s*var\s+([A-Za-z_][A-Za-z0-9_]*)\s*:\s*([A-Za-z_][A-Za-z0-9_]*)"#,
                               String(f.lexed.masked)) {
                uniques.append((f.path, g[1], g[2]))
            }
        }
        XCTAssertGreaterThanOrEqual(uniques.count, 4, "no uniqueness constraints were found")
        for u in uniques {
            XCTAssertEqual(u.type, "Int", "\(u.file): \(u.property) is unique but is not a number")
            XCTAssertTrue(u.property.hasSuffix("Position") || u.property.hasSuffix("Number"),
                          "\(u.file): \(u.property) is the uniqueness key and is not a position")
        }

        // Every SwiftData predicate in the tree keys on a position.
        var predicates: [String] = []
        for f in LawSource.production {
            for m in Rx.all(#"#Predicate\s*(?:<[^>]*>)?\s*\{[^}]*\}"#, String(f.lexed.masked)) {
                predicates.append("\(f.path) · \(SwiftLexer.collapse(m))")
            }
        }
        XCTAssertGreaterThanOrEqual(predicates.count, 4, "no SwiftData predicates were found")
        for p in predicates {
            XCTAssertTrue(p.contains("khadgamalaPosition"),
                          "a predicate keys on something other than her position: \(p)")
        }

        // The per-Śakti stores are asked for a position, never for a name.
        for name in ["RecognitionLogStore.swift", "HomeMemoryStore.swift"] {
            guard let f = LawSource.production(name) else { XCTFail("\(name) is missing"); continue }
            let signatures = Rx.groups(#"func\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)"#,
                                       String(f.lexed.masked))
            XCTAssertGreaterThanOrEqual(signatures.count, 3, "\(name): no functions were read")
            for s in signatures {
                XCTAssertFalse(Rx.matches(#"\b(name|shaktiName|shortName)\s*:\s*String"#, s[2]),
                               "\(name).\(s[1]) takes a name: \(s[2])")
            }
            XCTAssertTrue(signatures.contains { Rx.matches(#"khadgamalaPosition|position"#, $0[2]) },
                          "\(name) no longer takes a position at all")
        }
    }

    /// `all-shaktis-data.js` is a ghost: never read, never diffed against.
    func testTheGhostFileIsUnreferenced() {
        var offences: [String] = []
        for f in LawSource.production {
            // Code and words, not comments — the charter's own note that the
            // file is a ghost is allowed to be written down.
            let surfaces = [String(f.lexed.masked)] + f.literals.map(\.text)
            for s in surfaces where Rx.matches(#"(?i)all[-_]shaktis[-_]data"#, s) {
                offences.append(f.path)
            }
        }
        XCTAssertTrue(offences.isEmpty, "the ghost is being read: \(offences)")

        // And nothing JavaScript is bundled into the app.
        let js = (FileManager.default.enumerator(at: LawSource.productionRoot, includingPropertiesForKeys: nil)?
            .compactMap { $0 as? URL }
            .filter { $0.pathExtension == "js" }) ?? []
        XCTAssertTrue(js.isEmpty, "a .js file is inside the shipping app: \(js.map(\.lastPathComponent))")
    }

    // MARK: - Law 4 · aniconic

    /// There is no picture of her anywhere, because there is no picture at all.
    func testTheAssetCatalogueHoldsNoFigure() {
        let catalogues = [
            LawSource.productionRoot.appendingPathComponent("Assets.xcassets"),
            LawSource.productionRoot.appendingPathComponent("Preview Content/Preview Assets.xcassets"),
        ]
        let setExtensions: Set<String> = [
            "imageset", "appiconset", "symbolset", "colorset", "dataset",
            "spriteatlas", "texturesets", "cubetextureset", "arresourcegroup",
        ]

        var entries: Set<String> = []
        var readOne = false
        for c in catalogues {
            guard let walker = FileManager.default.enumerator(at: c, includingPropertiesForKeys: nil) else { continue }
            readOne = true
            for case let u as URL in walker where setExtensions.contains(u.pathExtension) {
                entries.insert(u.lastPathComponent)
            }
        }
        XCTAssertTrue(readOne, "the asset catalogue could not be read at \(catalogues.map(\.path))")
        XCTAssertFalse(entries.isEmpty, "the catalogue scan found nothing at all — it is not reading")

        XCTAssertEqual(entries, Aniconic.pinnedCatalogue,
                       """
                       the asset catalogue changed. Nothing figural may enter it, and an image set for \
                       a Śakti may never enter it at all: forms are shapes performing actions.
                       """)
        for e in entries {
            XCTAssertFalse(e.hasSuffix(".imageset") || e.hasSuffix(".symbolset"),
                           "\(e) is a picture in the catalogue")
            XCTAssertNil(Rx.first(Aniconic.figuralVocabulary, e),
                         "\(e) names a figure")
        }

        // And on disk: one app icon, and nothing else drawn.
        var images: Set<String> = []
        if let walker = FileManager.default.enumerator(at: LawSource.productionRoot, includingPropertiesForKeys: nil) {
            for case let u as URL in walker where Aniconic.imageExtensions.contains(u.pathExtension.lowercased()) {
                images.insert(LawSource.relativePath(of: u, under: LawSource.productionRoot))
            }
        }
        XCTAssertEqual(images, Aniconic.pinnedImageFiles,
                       "an image file entered the shipping app")
    }

    /// Nothing that draws is handed a figure, and almost nothing draws.
    func testNoDrawingPrimitiveIsHandedAFigure() {
        var literals: Set<String> = []
        var sites: [String] = []
        for f in LawSource.production {
            for call in f.calls(to: Aniconic.drawingCallees) {
                sites.append("\(f.path) · \(call.callee)(\(call.argument))")
                for l in call.literals { literals.insert(l.text) }
            }
        }
        XCTAssertGreaterThanOrEqual(sites.count, 2,
                                    "the drawing-primitive scan found \(sites.count) sites — it is not reading")
        XCTAssertEqual(literals, Aniconic.pinnedDrawnLiterals,
                       """
                       a drawing primitive is being handed something new: \(sites.joined(separator: " | ")). \
                       If it is a shape, say so here; if it is a picture of her, Law 4 refuses it.
                       """)
        for l in literals {
            XCTAssertNil(Rx.first(Aniconic.figuralVocabulary, l), "a figure is being drawn: \"\(l)\"")
        }

        // Nothing loads a picture from disk or from the network, either.
        for f in LawSource.production {
            let code = String(f.lexed.masked)
            for forbidden in [#"\bAsyncImage\b"#, #"UIImage\s*\(\s*named\s*:"#,
                              #"UIImage\s*\(\s*contentsOfFile\s*:"#, #"\bImage\s*\(\s*decorative\s*:"#] {
                XCTAssertFalse(Rx.matches(forbidden, code),
                               "\(f.path) loads an image — nothing in this instrument is drawn from a file")
            }
        }

        // The detector can fail.
        let bad = synthetic(#"""
        Image("kameshvari-portrait")
        Image(systemName: "person.fill")
        """#)
        let found = bad.calls(to: Aniconic.drawingCallees).flatMap { $0.literals.map(\.text) }
        XCTAssertEqual(found.count, 2, "the drawing scan missed a synthetic breach")
        XCTAssertTrue(found.allSatisfy { Rx.first(Aniconic.figuralVocabulary, $0) != nil },
                      "the figural vocabulary let \(found) through")
    }

    /// Her iconographic prose is real data out of Airtable, and it stays data.
    /// Drawn in words is still drawn.
    func testHerIconographicProseNeverReachesARenderPath() {
        let props = LawSource.modelProperties(of: "Shakti.swift")
        XCTAssertGreaterThanOrEqual(props.count, 25, "Shakti's properties were not read: \(props.count)")
        for field in Aniconic.iconographicFields {
            XCTAssertTrue(props.contains(field),
                          "Shakti.\(field) is gone — this check would then be proving nothing")
        }

        var offences: [String] = []
        for call in LawSource.walkerFacing {
            for expr in call.expressions {
                for field in Aniconic.iconographicFields where Rx.matches(#"\b\#(field)\b"#, expr) {
                    offences.append("\(call.origin) — renders \(field)")
                }
            }
        }
        XCTAssertTrue(offences.isEmpty,
                      """
                      a Śakti's iconographic prose is being put on a screen. It describes a form, and \
                      Law 4 refuses the form whether it arrives as pixels or as sentences.
                      \(offences.joined(separator: "\n"))
                      """)

        // The somatic fields are deliberately *not* on that list. "throat",
        // "heart", "skin" name where she is felt in the walker's own body —
        // that is the practice, not a picture of a goddess — and a check that
        // flagged them would be noise pretending to be a law.
        for somatic in ["bodilyLocation", "somatic", "somaticPoetry"] {
            XCTAssertTrue(props.contains(somatic), "Shakti.\(somatic) went missing")
            XCTAssertFalse(Aniconic.iconographicFields.contains(somatic),
                           "\(somatic) is somatic data, not iconography — it may be spoken")
        }
    }

    /// "Forms are shapes performing actions" is only a law if the render path is
    /// really made of shapes. It is: the whole instrument is drawn from
    /// primitives, and the one `Image` that exists is a chevron.
    func testTheRenderPathIsMadeOfShapes() {
        var primitives = 0
        var renderFiles = 0
        for f in LawSource.production where f.path.hasPrefix("Views/") || f.path.hasPrefix("Theme/") {
            renderFiles += 1
            let code = String(f.lexed.masked)
            for p in Aniconic.geometricPrimitives {
                primitives += Rx.all(#"\b\#(p)\s*[({]"#, code).count
            }
        }
        XCTAssertGreaterThanOrEqual(renderFiles, 25, "the render path was not found")
        XCTAssertGreaterThanOrEqual(primitives, 150,
                                    "only \(primitives) geometric primitives in the render path — it is no longer drawn from shapes")

        let imageSites = LawSource.production.flatMap { $0.calls(to: ["Image"]) }
        XCTAssertGreaterThanOrEqual(imageSites.count, 2,
                                    "the Image scan found \(imageSites.count) sites — it is not reading")
        XCTAssertTrue(imageSites.contains { $0.argumentCode.contains("uiImage") },
                      "the Portrait is an Image rendered from the app's own shapes")
        XCTAssertTrue(imageSites.contains { $0.argumentCode.contains("systemName") },
                      "the disclosure chevron is an Image")

        // Every `Image` in the tree is one of exactly two things: a symbol from
        // the system's own set, or a picture the app drew itself from shapes.
        // There is no third kind, and a third kind is how a figure would arrive.
        let acceptedImageLabels = ["systemName", "uiImage", "cgImage", "nsImage"]
        for site in imageSites {
            XCTAssertTrue(acceptedImageLabels.contains { site.argumentCode.contains($0) },
                          """
                          \(site.origin) draws something that is neither a system symbol nor a picture \
                          the app rendered from its own shapes — `Image("name")` reaches into the asset \
                          catalogue, and the catalogue is where a figure would arrive.
                          """)
        }
    }

    // MARK: - R17 · App Activity is the only event writer

    /// One POST in the whole tree, and it goes to the ledger.
    func testTheOnlyPostInTheTreeGoesToTheLedger() {
        let sites = LedgerIsTheRecord.allHTTPSites
        XCTAssertGreaterThanOrEqual(sites.count, 4,
                                    "only \(sites.count) HTTP requests were found — the scan is not reading them")
        XCTAssertTrue(sites.allSatisfy { !$0.urlShape.isEmpty },
                      "a request's URL could not be resolved: \(sites.filter { $0.urlShape.isEmpty }.map(\.origin))")

        let verbs = Set(sites.compactMap(\.method))
        XCTAssertEqual(verbs, ["POST", "PATCH"],
                       "the instrument writes with \(verbs.sorted()) — it creates only ledger rows and updates only Śakti rows")

        let posts = sites.filter { $0.method == "POST" }
        XCTAssertEqual(posts.count, 1,
                       "there is exactly one create in this app, the ledger's: found \(posts.map(\.origin))")
        guard let post = posts.first else { return }
        XCTAssertEqual(post.table, "App Activity",
                       "the one POST does not go to App Activity: \(post.origin)")
        XCTAssertFalse(post.urlShape.contains("⟨Self.tableId⟩"),
                       "the one POST touches the Mandala table: \(post.origin)")
        XCTAssertEqual(post.lastSegment, "⟨ActivityLedger.tableId⟩",
                       "a create addresses a table, never a record: \(post.origin)")
        XCTAssertTrue(post.hasBody, "the ledger create carries no body — the scan has lost it")
    }

    /// The Mandala table is only ever updated, one record at a time, and never
    /// created into. A row that does not already exist cannot be made there,
    /// which is what "it never holds event rows" means in HTTP.
    func testTheMandalaTableReceivesOnlyRecordAddressedPatches() {
        let sites = LedgerIsTheRecord.allHTTPSites
        let patches = sites.filter { $0.method == "PATCH" }
        XCTAssertGreaterThanOrEqual(patches.count, 3,
                                    "only \(patches.count) PATCHes were found: \(patches.map(\.origin))")

        for p in patches {
            XCTAssertEqual(p.table, "Mandala", "a PATCH goes somewhere unexpected: \(p.origin)")
            XCTAssertTrue(Rx.matches(#"(?i)⟨[^⟩]*(recordid|\.id)[^⟩]*⟩"#, p.lastSegment ?? ""),
                          """
                          a Mandala PATCH is not addressed by record id: \(p.origin). A write that is \
                          not aimed at one existing Śakti row could create one.
                          """)
        }

        // Nothing writes a body without declaring a verb.
        for s in sites where s.hasBody {
            XCTAssertNotNil(s.method, "a request carries a body with no method: \(s.origin)")
        }

        // The whole write topology, in one line.
        let topology = Set(sites.compactMap { s in s.method.map { "\($0) → \(s.table)" } })
        XCTAssertEqual(topology, ["POST → App Activity", "PATCH → Mandala"],
                       """
                       the write topology changed. Every event is a ledger row; the Mandala table holds \
                       only Śaktis and Avaraṇas, and receives only state updates on rows that exist.
                       """)
    }

    /// What makes a row an event row lives in one file. If the vocabulary
    /// spreads, something else has learned to write events.
    func testTheLedgersVocabularyLivesOnlyInTheLedger() {
        var logged: Set<String> = []
        for word in LedgerIsTheRecord.eventVocabulary {
            var files: Set<String> = []
            for f in LawSource.production {
                let messages = LedgerIsTheRecord.loggedLiteralStarts(in: f)
                for lit in f.literals where lit.text.contains(word) {
                    if messages.contains(lit.start) {
                        logged.insert("\(f.path) · \(lit.text)")
                    } else {
                        files.insert(f.path)
                    }
                }
            }
            XCTAssertEqual(files, [LedgerIsTheRecord.ledgerFile],
                           """
                           "\(word)" is written in \(files.sorted()) — an event type is named where it \
                           can be written. The vocabulary belongs to the ledger; everywhere else refers \
                           to it through `ActivityLedger.ActivityType`.
                           """)
        }
        XCTAssertEqual(logged, LedgerIsTheRecord.pinnedLoggedVocabulary,
                       """
                       the ledger's vocabulary is being spoken somewhere new. A log line writes nothing \
                       and is allowed; pin it here so the allowance cannot quietly become a payload.
                       """)

        // The Mandala table's retired event discriminator exists nowhere.
        for f in LawSource.production {
            XCTAssertFalse(f.literals.contains { $0.text.contains(LedgerIsTheRecord.retiredDiscriminator) },
                           "\(f.path) still knows the word \"\(LedgerIsTheRecord.retiredDiscriminator)\"")
        }

        // And the payload builder has exactly one caller: the one POST.
        var callers: [String] = []
        for f in LawSource.production {
            for _ in Rx.all(#"ActivityLedger\.fields\s*\(\s*for\s*:"#, String(f.lexed.masked)) {
                callers.append(f.path)
            }
        }
        XCTAssertEqual(callers, ["Data/AirtableService.swift"],
                       "the ledger payload is built in \(callers) — there should be one writer")
    }

    /// The two tables, at run time: different ids, and no field in common
    /// between what the ledger writes and what the Mandala row receives.
    func testNoMandalaWriteCarriesAnEventField() {
        let mandalaFields = Set(LedgerIsTheRecord.mandalaPatchFields)
        XCTAssertEqual(mandalaFields, ["Last Felt", "Recognition Count", "Status", "Letter"],
                       """
                       the Mandala PATCH fields changed. The Mandala row carries per-Śakti *state*; \
                       anything that happened belongs in App Activity.
                       """)
        XCTAssertNotEqual(ActivityLedger.tableId, AirtableService.tableId,
                          "the ledger and the spine must be two tables")

        let m = Moment()
        let rows: [PendingActivity] = [
            ActivityLedger.recognition(m, shaktiName: "Kāmeśvarī", isFirst: true),
            ActivityLedger.recognition(m, shaktiName: "Kāmeśvarī", isFirst: false),
            ActivityLedger.crossing(ring: 9, feltAt: m.feltAt),
            ActivityLedger.silence(shaktiRecordId: m.shaktiRecordId, name: "Kāmeśvarī",
                                   durationSec: 128.5, at: m.feltAt),
            PendingActivity(type: ActivityLedger.ActivityType.letterWritten,
                            linkRecordId: m.shaktiRecordId,
                            name: ActivityLedger.letterWritten(shaktiName: "Kāmeśvarī").name,
                            detail: ActivityLedger.letterWritten(shaktiName: "Kāmeśvarī").detail,
                            at: m.feltAt),
        ]

        for row in rows {
            let keys = Set(ActivityLedger.fields(for: row).keys)
            XCTAssertFalse(keys.isEmpty, "\(row.type) writes no fields")
            XCTAssertTrue(keys.contains(ActivityLedger.Field.activityType),
                          "\(row.type) is not typed as an event")
            XCTAssertTrue(keys.isDisjoint(with: mandalaFields),
                          """
                          \(row.type) shares \(keys.intersection(mandalaFields).sorted()) with the \
                          Mandala row's state fields — an event must not be writable as state.
                          """)
        }

        // The four event types are exactly the ledger's own.
        XCTAssertEqual(Set(rows.map(\.type)),
                       [ActivityLedger.ActivityType.shaktiRecognized,
                        ActivityLedger.ActivityType.ringCrossed,
                        ActivityLedger.ActivityType.silenceHeld,
                        ActivityLedger.ActivityType.letterWritten])
    }

    // MARK: - Fixtures

    /// A file the scanners have never seen, so a detector can be shown failing.
    private func synthetic(_ source: String, named: String = "Synthetic.swift") -> SourceFile {
        SourceFile(path: named, name: named, text: source, lexed: SwiftLexer.lex(source))
    }

    /// One recognition, in the shape `AirtableService` hands to the ledger.
    private struct Moment: RecognitionMoment {
        let shaktiRecordId = "recSeven"
        let note: String? = nil
        let source = ActivityLedger.GestureSource.mandala
        let feltAt = Date(timeIntervalSince1970: 1_789_000_000)
        let lunarDay = 11
        let moonPhase = "Waning Crescent"
    }
}
