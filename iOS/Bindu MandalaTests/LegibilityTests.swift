import XCTest
@testable import Bindu_Mandala

// MARK: - LegibilityTests — FIDELITY rule 4, read off the real screens
//
// `iOS/FIDELITY.md`, rule 4: *"meaningful text ≥ ~11 pt and ≥ ~0.5 cream alpha
// (decorative watermarks / ghost glyphs are exempt)."*
//
// Audit §H2 swept all 36 views and all 10 Theme files by hand and came back with
// **31 live sites below it** — 21 failures and 10 marginals. A hand sweep is a
// photograph: true on the day, silent the day after. This file is that sweep as
// a standing law, reading the same source the app is built from.
//
// It reuses `LawsTests`' lexer rather than growing a second one. That lexer is
// the part that knows a string literal from code, and either from a comment,
// which is the whole difficulty. What is added here is the piece `LawsTests`
// never needed: walking the **modifier chain** that trails a `Text(…)`, because
// in SwiftUI a string's size and its alpha are not inside the call — they are
// the six lines after it.
//
// Three locks, because there are three ways a screen goes dim:
//
//  1. **The site check** — every `Text` in `Views/`, with its declared size and
//     its effective alpha, against 11 pt and 0.5 α.
//  2. **The small-type check** — nothing in `Views/` declares a `.font(…)` under
//     11 pt *at all*. This is what catches type set on a container that a `Text`
//     inherits, which the site check cannot see.
//  3. **The two ghosts, pinned exactly** — "tap to enter" and "Tap anywhere to
//     close" are design intent: they are meant to be barely there. Rule 4 says
//     "barely there" still has a floor, so they sit *on* it — 11 pt, 0.5 α — and
//     this fails if they drift either way. Made legible, not promoted.
//
// What this scanner refuses to guess at
// ─────────────────────────────────────
// A `.opacity(…)` **modifier in the chain** counts only when its argument is a
// bare number. `.opacity(arrived ? 1 : 0)` is a staged arrival — rule 3's
// business, not rule 4's — and reading it as "alpha 0" would condemn every
// screen that fades in. Inside a *colour* expression the opposite holds:
// `Color.cream.opacity(lit ? 0.85 : 0.42)` is two real alphas, and the dimmer
// branch is the one a walker has to read, so the dimmer branch is judged.
//
// Exemptions are pinned sets compared by exact equality, in the shape
// `LawsTests` uses: a new one has to be typed in here, with its reason, by
// whoever adds it. No pattern lets a new site exempt itself.

// MARK: - One string on a screen

struct TypeSite {
    let file: String          // "Views/Common/WellView.swift"
    let line: Int
    /// The authored words, with interpolations kept as ⟨expr⟩ markers.
    let words: String
    /// The size its own `.font(…)` declares. `nil` = either no `.font` at all
    /// (inherited — lock 2 guards the case where a container hands down
    /// something small) or a size this scanner will not evaluate.
    let size: Double?
    /// Whether a `.font(…)` was there at all, so "inherited" and "computed, and
    /// the scanner said so" never look alike.
    let declaresFont: Bool
    /// The alpha it ends up drawn at, or `nil` when the colour is an identifier
    /// this scanner will not pretend to resolve.
    let alpha: Double?
    let chain: String

    var pin: String { "\(file):\(words)" }
    var origin: String {
        let w = words.count > 60 ? String(words.prefix(60)) + "…" : words
        return "\(file):\(line) “\(w)”"
    }
}

// MARK: - The scanner

enum TypeScanner {

    /// Every colour token in the app that is not drawn at full strength.
    /// `testTheAlphaTokenTableIsComplete` reads the theme off disk and fails if
    /// a faded token appears that is not in here — so the table cannot quietly
    /// go stale while the screens go dim.
    static let fadedTokens: [String: Double] = [
        "creamMid":    0.65,   // Color+Tokens
        "creamFaint":  0.35,
        "goldFaint":   0.12,
        "accentSoft":  0.62,   // Atmosphere
        "accentFaint": 0.24,
        "glow":        0.12,   // glowAlpha's floor
    ]

    // MARK: Sites

    static func sites(in file: SourceFile) -> [TypeSite] {
        let chars = file.lexed.chars
        let masked = file.lexed.masked
        var out: [TypeSite] = []

        for (open, close) in callRanges(of: "Text", in: masked) {
            let chain = trailingChain(from: close + 1, masked: masked)

            var size: Double?
            var sawFont = false
            var colourAlpha: Double?
            var sawColour = false
            var chainMultiplier = 1.0

            for segment in chain {
                let text = String(chars[segment.start..<segment.end])
                switch segment.name {
                case "font" where !sawFont:
                    // A `.font(font)` — AvaranaThresholdView takes a whole `Font`
                    // as a parameter — declares no size here at all, and its real
                    // size is at the call site, which this scan also reads. That
                    // is "no size", not "a size I could not read".
                    guard mentionsASize(text) else { break }
                    sawFont = true
                    size = declaredSize(in: text)
                case "foregroundStyle", "foregroundColor":
                    guard !sawColour else { break }
                    sawColour = true
                    colourAlpha = declaredAlpha(in: text)
                case "opacity":
                    // Only a bare number. A condition here is a staged arrival.
                    let arg = SwiftLexer.collapse(text)
                    if let v = Double(arg) { chainMultiplier *= v }
                default:
                    break
                }
            }

            let effective: Double?
            switch (colourAlpha, chainMultiplier) {
            case (let c?, let m):      effective = c * m
            case (nil, let m) where m < 1: effective = m
            default:                   effective = nil
            }

            out.append(TypeSite(file: file.path,
                                line: 1 + chars[0..<open].filter { $0 == "\n" }.count,
                                words: literalShape(between: open, and: close, in: file),
                                size: size,
                                declaresFont: sawFont,
                                alpha: effective,
                                chain: SwiftLexer.collapse(
                                    String(chars[close..<min(close + 260, chars.count)]))))
        }
        return out
    }

    /// Every `.font(…)` a view declares, whatever it is attached to, with the
    /// size it resolves to. A computed size (`min(nameSize(…) * 1.7, 150)`) is
    /// reported as `nil`: this scanner does not evaluate arithmetic, it says so.
    static func fontSizes(in file: SourceFile) -> [(line: Int, size: Double?, source: String)] {
        let chars = file.lexed.chars
        let masked = file.lexed.masked
        var out: [(Int, Double?, String)] = []
        for (open, close) in callRanges(of: "font", in: masked) {
            let text = String(chars[open..<close])
            guard mentionsASize(text) else { continue }
            out.append((1 + chars[0..<open].filter { $0 == "\n" }.count,
                        declaredSize(in: text),
                        SwiftLexer.collapse(text)))
        }
        return out
    }

    // MARK: Walking the source

    struct ChainSegment { let name: String; let start: Int; let end: Int }

    /// `(indexJustPastTheOpenParen, indexOfTheCloseParen)` for every call to
    /// `name` at an identifier boundary.
    static func callRanges(of name: String, in masked: [Character]) -> [(Int, Int)] {
        let needle = Array(name)
        var out: [(Int, Int)] = []
        guard masked.count >= needle.count else { return out }
        for i in 0...(masked.count - needle.count) {
            guard Array(masked[i..<i + needle.count]) == needle else { continue }
            if i > 0, isIdentifier(masked[i - 1]) { continue }
            var j = i + needle.count
            if j < masked.count, isIdentifier(masked[j]) { continue }
            while j < masked.count, masked[j] == " " || masked[j] == "\n" { j += 1 }
            guard j < masked.count, masked[j] == "(" else { continue }
            guard let close = balanced(from: j, in: masked) else { continue }
            out.append((j + 1, close))
        }
        return out
    }

    /// Walks `.modifier(…)` from `start` until the next token is not a `.`.
    static func trailingChain(from start: Int, masked: [Character]) -> [ChainSegment] {
        var out: [ChainSegment] = []
        var i = start
        while true {
            var j = i
            while j < masked.count, masked[j] == " " || masked[j] == "\n" || masked[j] == "\t" { j += 1 }
            guard j < masked.count, masked[j] == "." else { break }
            var k = j + 1
            while k < masked.count, isIdentifier(masked[k]) { k += 1 }
            guard k > j + 1 else { break }
            let name = String(masked[(j + 1)..<k])
            var m = k
            while m < masked.count, masked[m] == " " || masked[m] == "\n" { m += 1 }
            if m < masked.count, masked[m] == "(" {
                guard let close = balanced(from: m, in: masked) else { break }
                out.append(ChainSegment(name: name, start: m + 1, end: close))
                i = close + 1
            } else if m < masked.count, masked[m] == "{" {
                break                       // a trailing closure ends the chain we can read
            } else {
                out.append(ChainSegment(name: name, start: k, end: k))
                i = k
            }
        }
        return out
    }

    static func balanced(from open: Int, in masked: [Character]) -> Int? {
        var depth = 0
        var i = open
        while i < masked.count {
            if masked[i] == "(" { depth += 1 }
            if masked[i] == ")" {
                depth -= 1
                if depth == 0 { return i }
            }
            i += 1
        }
        return nil
    }

    static func isIdentifier(_ c: Character) -> Bool { c.isLetter || c.isNumber || c == "_" }

    // MARK: Reading a size

    static func mentionsASize(_ text: String) -> Bool {
        Rx.matches(#"\bsize\s*:"#, text)
            || Rx.matches(#"\b(?:sanskrit|voice|label)\s*\("#, text)
    }

    /// The smallest point size this `.font(…)` can produce. A ternary is judged
    /// by its smaller branch, because that is the one a walker has to read. A
    /// size that is *computed* returns `nil` — the scanner names what it cannot
    /// read rather than guessing a number and passing.
    static func declaredSize(in text: String) -> Double? {
        var candidates: [Double] = []
        var unreadable = false

        for arg in argumentsLabelled("size", in: text)
            + arguments(ofCallsNamed: ["sanskrit", "voice", "label"], in: text) {
            if arg.contains("(") { unreadable = true; continue }
            let numbers = Rx.all(#"[0-9]+(?:\.[0-9]+)?"#, arg).compactMap(Double.init)
            if numbers.isEmpty {
                if arg.trimmingCharacters(in: .whitespaces).isEmpty {
                    candidates.append(12)   // `AppFont.label()`'s own default
                } else {
                    unreadable = true
                }
            } else {
                candidates.append(numbers.min()!)
            }
        }
        if let least = candidates.min() { return least }
        return unreadable ? nil : nil
    }

    /// The source of every `label:` argument, cut at the comma that ends it.
    static func argumentsLabelled(_ label: String, in text: String) -> [String] {
        let chars = Array(text)
        var out: [String] = []
        let needle = Array("\(label):")
        guard chars.count >= needle.count else { return out }
        for i in 0...(chars.count - needle.count) {
            guard Array(chars[i..<i + needle.count]) == needle else { continue }
            if i > 0, isIdentifier(chars[i - 1]) { continue }
            out.append(argumentSource(from: i + needle.count, in: chars))
        }
        return out
    }

    /// The source of the single argument of `name(…)`, for the AppFont helpers.
    static func arguments(ofCallsNamed names: [String], in text: String) -> [String] {
        let chars = Array(text)
        var out: [String] = []
        for name in names {
            let needle = Array(name)
            guard chars.count >= needle.count else { continue }
            for i in 0...(chars.count - needle.count) {
                guard Array(chars[i..<i + needle.count]) == needle else { continue }
                if i > 0, isIdentifier(chars[i - 1]) { continue }
                var j = i + needle.count
                while j < chars.count, chars[j] == " " { j += 1 }
                guard j < chars.count, chars[j] == "(" else { continue }
                guard let close = balanced(from: j, in: chars) else { continue }
                out.append(String(chars[(j + 1)..<close]))
            }
        }
        return out
    }

    /// From `start`, the argument's source up to the comma or close-paren that
    /// ends it at depth zero.
    static func argumentSource(from start: Int, in chars: [Character]) -> String {
        var depth = 0
        var i = start
        var out = ""
        while i < chars.count {
            let c = chars[i]
            if c == "(" || c == "[" { depth += 1 }
            if c == ")" || c == "]" {
                if depth == 0 { break }
                depth -= 1
            }
            if c == ",", depth == 0 { break }
            out.append(c)
            i += 1
        }
        return out
    }

    // MARK: Reading an alpha

    /// The alpha this colour expression draws at, or `nil` when it is a bare
    /// identifier the scanner refuses to guess at (`LegibilityExemptions
    /// .unresolved` carries those, each with what was done instead).
    static func declaredAlpha(in text: String) -> Double? {
        var alpha = 1.0
        var known = false

        for arg in arguments(ofCallsNamed: ["opacity"], in: text) {
            let numbers = Rx.all(#"[0-9]+(?:\.[0-9]+)?"#, arg).compactMap(Double.init)
            guard let least = numbers.min() else { continue }
            alpha *= least
            known = true
        }
        for (token, value) in fadedTokens where Rx.matches("\\b\(token)\\b", text) {
            alpha *= value
            known = true
        }
        if known { return alpha }

        // Full-strength tokens (`Color.cream`, `atmo.accentBright`, `gold`) read
        // as 1.0. A bare local binding does not read at all.
        let collapsed = SwiftLexer.collapse(text)
        if Rx.matches(#"^[a-z_][A-Za-z0-9_]*$"#, collapsed) { return nil }
        return 1.0
    }

    /// The authored words of the literals inside a call, interpolations kept as
    /// markers — so two `Text(name)` sites in one file stay tellable apart.
    static func literalShape(between open: Int, and close: Int, in file: SourceFile) -> String {
        let inside = file.lexed.literals.filter { $0.start >= open && $0.start < close }
        if inside.isEmpty {
            return SwiftLexer.collapse(String(file.lexed.masked[open..<close]))
        }
        return inside.map(\.shape).joined(separator: " ")
    }
}

// MARK: - The exemptions, pinned

enum LegibilityExemptions {

    /// Rule 4's own words: *decorative watermarks / ghost glyphs are exempt*. The
    /// audit named the same two things this does. Every entry here must actually
    /// be catching a site — `testNoExemptionIsDead` fails on a pin that has
    /// stopped applying, so the list cannot grow a habit.
    static let decorative: [String: String] = [
        "Views/Common/TheHundredTwoView.swift:›":
            "the ring row's disclosure chevron. It rotates to say open or shut and says nothing; "
            + "the ring's name, its form and its seat count all sit beside it at full threshold",
        "Views/Recognition/RecognitionMomentView.swift:bijaSyllable":
            "the ceremony's 300 pt ghost bīja — a watermark behind her name, at accentFaint. "
            + "Audit §H2 exempted it by name; raising it would put a letter in front of the rite",
    ]

    /// Colours this scanner will not guess at, and what was done instead. Each is
    /// a `Text` whose foreground is a local binding: the alpha lives in the
    /// function that makes the colour, and it was raised there.
    static let unresolved: [String: String] = [
        "Views/Common/ShaktiDetailView.swift:shakti.status.label.uppercased()":
            "the embodiment pill — its colour comes from pillColor(for:) and nodeColor(_:), "
            + "whose faintest branches are asserted directly by testThePillColoursClearTheFloor",
    ]

    /// Sizes that are arithmetic rather than a number. The scanner does not
    /// evaluate them and says so instead of guessing; each is pinned with what
    /// the arithmetic can actually produce.
    static let computedSize: [String: String] = [
        "Views/Today/DailyRiteView.swift:content.name":
            "the Rite's veil name — `min(nameSize(cap: 120…) * 1.7, 150)`, never under 40 pt, and "
            + "the largest thing on the screen. It is also the one site drawn at accentFaint 0.24, "
            + "which is the point of it: a watermark her name is written into, and the door as well. "
            + "Audit §H2 exempted it on exactly that reading",
        "Views/Today/Rite/RiteBlockView.swift:c.name":
            "the Rite block's name, sized by the same composition arithmetic — 27 pt at its "
            + "smallest, drawn at full cream",
    ]

    static func reason(for site: TypeSite) -> String? {
        decorative[site.pin] ?? unresolved[site.pin] ?? computedSize[site.pin]
    }

    static var everyPin: Set<String> {
        Set(decorative.keys).union(unresolved.keys).union(computedSize.keys)
    }
}

// MARK: - The tests

final class LegibilityTests: XCTestCase {

    private let minimumSize = 11.0
    private let minimumAlpha = 0.5

    /// Every screen in the app. `Views/Spike/` is the renderer spike — a
    /// measuring rig with no walker in it — and is the one thing left out.
    private var views: [SourceFile] {
        LawSource.production.filter {
            $0.path.hasPrefix("Views/") && !$0.path.hasPrefix("Views/Spike/")
        }
    }

    /// The shipped screens. The two value checks above run over every view in the
    /// app, because the threshold is a law and not a phase's territory — but the
    /// *pinned* sets are scoped here, to the screens this phase owns. A pin is a
    /// sentence somebody has to write in **this** file, and `Views/Rooms/` is the
    /// Homes branch's to build; a lock that made another branch edit this file to
    /// go green would be friction in the wrong place.
    private var shippedViews: [SourceFile] {
        views.filter { !$0.path.hasPrefix("Views/Rooms/") }
    }

    // MARK: The corpus floor
    //
    // Every check below is a scan, and an emptied scan reads as a pass. These
    // are the numbers that make a silent scan loud instead.

    func testTheScanReachesTheScreens() {
        XCTAssertGreaterThanOrEqual(views.count, 25,
                                    "the view corpus shrank — the legibility scan may be reading nothing")
        let sites = views.flatMap { TypeScanner.sites(in: $0) }
        XCTAssertGreaterThanOrEqual(sites.count, 120,
                                    "only \(sites.count) Text sites found; the chain walker has lost the source")
        let sized = sites.filter { $0.size != nil }
        XCTAssertGreaterThanOrEqual(Double(sized.count), Double(sites.count) * 0.75,
                                    "most Text sites should declare their own size; "
                                    + "only \(sized.count) of \(sites.count) do")
        let coloured = sites.filter { $0.alpha != nil }
        XCTAssertGreaterThanOrEqual(Double(coloured.count), Double(sites.count) * 0.6,
                                    "the alpha reader has lost the source: only \(coloured.count) "
                                    + "of \(sites.count) sites resolve a colour")
    }

    /// A `.font(…)` whose size is arithmetic rather than a number is not judged
    /// by lock 1 — so the set of them is pinned. A new one is a new decision,
    /// and it fails here until somebody writes down why it cannot be read.
    func testTheOnlyUnreadableSizesAreTheTwoThatWereAlwaysArithmetic() {
        var found: [String] = []
        for file in shippedViews {
            for site in TypeScanner.sites(in: file) where site.declaresFont && site.size == nil {
                found.append(site.pin)
            }
        }
        XCTAssertEqual(Set(found), Set(LegibilityExemptions.computedSize.keys),
                       "a Text declares a size this scanner will not evaluate. Either give it a "
                       + "number, or pin it in LegibilityExemptions.computedSize with the reason "
                       + "it is safe.")
    }

    /// An exemption that has stopped applying is an exemption nobody is reading.
    /// Every pin has to be catching a live site, or it comes out.
    func testNoExemptionIsDead() {
        var live: Set<String> = []
        for file in shippedViews {
            for site in TypeScanner.sites(in: file) {
                let failsSize = (site.size.map { $0 < minimumSize } ?? false)
                let failsAlpha = (site.alpha.map { $0 < minimumAlpha - 0.0001 } ?? false)
                let unreadable = (site.declaresFont && site.size == nil) || site.alpha == nil
                if failsSize || failsAlpha || unreadable { live.insert(site.pin) }
            }
        }
        let dead = LegibilityExemptions.everyPin.subtracting(live)
        XCTAssertTrue(dead.isEmpty,
                      "these exemptions no longer apply to anything and should be deleted:\n"
                      + dead.sorted().joined(separator: "\n"))
    }

    // MARK: Lock 1 — every meaningful string clears the floor

    func testEveryMeaningfulStringIsLegible() {
        var failures: [String] = []
        for file in views {
            for site in TypeScanner.sites(in: file) {
                if LegibilityExemptions.reason(for: site) != nil { continue }
                if let size = site.size, size < minimumSize {
                    failures.append(String(format: "%@ — %.1f pt, under %.0f",
                                           site.origin, size, minimumSize))
                }
                if let alpha = site.alpha, alpha < minimumAlpha - 0.0001 {
                    failures.append(String(format: "%@ — %.2f α, under %.2f",
                                           site.origin, alpha, minimumAlpha))
                }
            }
        }
        XCTAssertTrue(failures.isEmpty,
                      "FIDELITY rule 4 wants ≥ 11 pt and ≥ 0.5 α for anything the walker reads:\n"
                      + failures.sorted().joined(separator: "\n"))
    }

    // MARK: Lock 2 — no small type anywhere in a view
    //
    // Lock 1 reads a `Text`'s own chain. Type set on a *container* — a `VStack`
    // carrying a `.font(…)` its children inherit — is invisible to it. So
    // nothing in `Views/` declares a size under 11 at all, and there is nothing
    // small left to inherit.

    func testNoViewDeclaresTypeUnderTheFloor() {
        var failures: [String] = []
        for file in views {
            for f in TypeScanner.fontSizes(in: file) {
                guard let size = f.size, size < minimumSize else { continue }
                failures.append(String(format: "%@:%d — .font declares %.1f pt · %@",
                                       file.path, f.line, size, f.source))
            }
        }
        XCTAssertTrue(failures.isEmpty,
                      "type under 11 pt in a view — a container can hand this down to any string "
                      + "inside it:\n" + failures.sorted().joined(separator: "\n"))
    }

    // MARK: Lock 3 — the two ghosts, exactly on the floor
    //
    // Audit §H3 calls both exit hints "intentional ghost-hints" — and §H2 lists
    // both as failures, which is the sentence that decides this. They stay
    // ghosts, at the floor: 11 pt, 0.5 α. Above it they would be promoted into
    // instructions, which they are not. Below it, the surface saves the settled
    // eye while the way out does not.

    func testTheTwoGhostExitHintsSitExactlyOnTheFloor() {
        let ghosts = [
            ("Views/Common/HomecomingView.swift", "tap to enter"),
            ("Views/Recognition/RecognitionMomentView.swift", "Tap anywhere to close"),
        ]
        for (path, words) in ghosts {
            guard let file = LawSource.production.first(where: { $0.path == path }) else {
                return XCTFail("\(path) is gone — the ghost-hint pin cannot be checked")
            }
            guard let site = TypeScanner.sites(in: file).first(where: { $0.words.contains(words) })
            else { return XCTFail("\(path) no longer says “\(words)”") }
            XCTAssertEqual(site.size ?? 0, minimumSize, accuracy: 0.001,
                           "“\(words)” sits exactly on rule 4's floor, never above it — \(site.chain)")
            XCTAssertEqual(site.alpha ?? 0, minimumAlpha, accuracy: 0.001,
                           "“\(words)” sits exactly on rule 4's floor, never below it — \(site.chain)")
        }
    }

    // MARK: The pill colours, which lock 1 cannot read

    func testThePillColoursClearTheFloor() {
        guard let file = LawSource.production.first(where: {
            $0.path == "Views/Common/ShaktiDetailView.swift"
        }) else { return XCTFail("ShaktiDetailView is gone") }
        let source = String(file.lexed.masked)

        for fn in ["pillColor", "nodeColor"] {
            guard let body = Rx.first("func \(fn)[\\s\\S]{0,700}?\\n    \\}", source) else {
                return XCTFail("\(fn) is gone from ShaktiDetailView")
            }
            let alphas = TypeScanner.arguments(ofCallsNamed: ["opacity"], in: body)
                .compactMap { Rx.all(#"[0-9]+(?:\.[0-9]+)?"#, $0).compactMap(Double.init).min() }
            XCTAssertFalse(alphas.isEmpty, "\(fn) no longer carries any alpha to check")
            for a in alphas {
                XCTAssertGreaterThanOrEqual(a, minimumAlpha - 0.0001,
                                            "\(fn) can draw the embodiment pill at \(a) α")
            }
        }
    }

    // MARK: The alpha table cannot go stale

    func testTheAlphaTokenTableIsComplete() {
        let themes = LawSource.production.filter { $0.path.hasPrefix("Theme/") }
        XCTAssertGreaterThanOrEqual(themes.count, 8, "the Theme corpus shrank")

        var missing: [String] = []
        for file in themes {
            for line in String(file.lexed.masked).split(separator: "\n") {
                let s = String(line)
                guard Rx.matches(#"(?:static\s+let|var)\s+[A-Za-z_][A-Za-z0-9_]*"#, s),
                      Rx.matches(#"\.opacity\(|alpha:"#, s) else { continue }
                guard let name = Rx.first(#"[A-Za-z_][A-Za-z0-9_]*"#,
                                          Rx.first(#"(?:static\s+let|var)\s+[A-Za-z_][A-Za-z0-9_]*"#, s)?
                                            .replacingOccurrences(of: "static", with: "")
                                            .replacingOccurrences(of: "let", with: "")
                                            .replacingOccurrences(of: "var", with: "") ?? "")
                else { continue }
                let values = Rx.all(#"(?:\.opacity\(|alpha:\s*)[0-9]*\.?[0-9]+"#, s)
                    .compactMap { Rx.first(#"[0-9]*\.?[0-9]+$"#, $0).flatMap(Double.init) }
                guard let least = values.min(), least < 1 else { continue }
                if TypeScanner.fadedTokens[name] == nil {
                    missing.append("\(file.path): \(name) draws at \(least)")
                }
            }
        }
        XCTAssertTrue(missing.isEmpty,
                      "a colour token draws below full strength and the legibility scanner does not "
                      + "know it — add it to TypeScanner.fadedTokens:\n" + missing.joined(separator: "\n"))
    }
}
