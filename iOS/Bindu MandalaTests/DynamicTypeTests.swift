import XCTest
@testable import Bindu_Mandala

// MARK: - DynamicTypeTests — every size in the tree is a scaled size, or a
// written-down reason why not
//
// Brief v2 §4.3. Audit §H5 counted **152 fixed-size font sites in Views, zero
// text styles, zero `relativeTo:`** — an app that ignores the system's type
// setting completely. The repair is `Theme/Fonts.swift`'s three tokens, and the
// thing that makes a repair like this rot is a single call site added next month
// that goes straight back to `.system(size:)`.
//
// So this reads the shipping source, the way `LawsTests` and `LegibilityTests`
// do, and asks three things of it:
//
//  1. **Nothing in `Views/` declares a raw font size** except through `AppFont`.
//     `.system(size:)` and `.custom(_:size:)` without a `relativeTo:` are both
//     refused, and the exceptions are a pinned set with a sentence apiece.
//  2. **No scaled string is trapped in a fixed height.** A `.frame(height:)` in
//     the chain after a `Text` is a box that cannot grow with its contents; the
//     idiom is `minHeight`, which is the same number at the default size and a
//     floor rather than a ceiling above it.
//  3. **A string held to one line can shrink to fit.** `lineLimit(1)` on a
//     scaled font needs a `minimumScaleFactor` beside it, or the largest
//     accessibility size ends it in an ellipsis.
//
// The sizes themselves are `LegibilityTests`' business and are not re-checked
// here. Its scanner already reads `AppFont.sanskrit(…)`, `voice(…)` and
// `label(…)` as sizes, which is why this migration leaves that whole suite
// asking exactly what it asked before.

enum ScaledType {

    /// Where a fixed size is still the right answer, by exact file-and-words
    /// pin. Every one of these is a mark or a measured drawing, never a
    /// sentence — and every one has somewhere else for a walker who needs it
    /// bigger to go.
    ///
    /// Compared by exact equality, in the shape the other suites use: a new
    /// exception has to be typed in here by whoever adds it.
    static let fixedByDesign: Set<String> = [
        // ── The canvas ──────────────────────────────────────────────────────
        // The brief excepts canvas labels in as many words. These three are
        // resolved inside a `Canvas`, in world coordinates the camera scales:
        // no line box to wrap into, no stack to push. Growing the glyphs would
        // overlap the seats they name rather than make them legible. Pinching is
        // how they get bigger — a gesture the walker already has — and §4.4
        // gives the same three strings to VoiceOver, which scales with the voice
        // and not with the type.
        "Views/Mandala/MandalaCanvasLayer.swift · .system(size: 11.5)",
        "Views/Mandala/MandalaCanvasLayer.swift · .custom(AppFont.cormorant, size: 11.5)",
        "Views/Mandala/MandalaCanvasLayer.swift · .custom(AppFont.cormorantItalic, size: 11.5)",

        // ── Marks in a fixed target ─────────────────────────────────────────
        // Each is one glyph centred in a 44–47 pt disc that `HitAreaIdiomTests`
        // holds to its size. A mark grown past its own disc is clipped, not
        // read, and none of them is a word: they are `+`, `−`, `⤢`, `♪`, `×`
        // and `‹`. Naming them aloud is a separate repair — audit §H5 lists the
        // zoom column and the card's close among its unlabelled controls, and
        // giving them labels changes what the composition snapshots read, so it
        // is not folded into a type migration.
        "Views/Mandala/LivingMandalaView.swift · .system(size: 20)",
        "Views/Mandala/SignificanceCard.swift · .system(size: 22, weight: .light)",
        "Views/Common/ShaktiDetailView.swift · .system(size: 22, weight: .light)",
        "Views/Common/WellView.swift · .system(size: 22, weight: .light)",

        // ── Two drawings measured from the screen, not chosen ───────────────
        // The ceremony's ghost bīja is a watermark at 300 × the focal scale, and
        // the Rite's name is already fitted to its own box by
        // `nameSize(cap:nudge:)` and then shrunk again by `minimumScaleFactor`.
        // Neither number is a type size anybody picked; both are a rectangle
        // measured at run time, and scaling a measurement twice is how a name
        // ends up off the side of the glass.
        "Views/Recognition/RecognitionMomentView.swift · .custom(AppFont.cormorant, size: 300 * scale)",
        "Views/Today/DailyRiteView.swift · .custom(AppFont.cormorant, size: min(content.nameSize(cap: 120, nudge: 0) * 1.7, 150))",

        // ── Not this branch's file ──────────────────────────────────────────
        // `Views/Rooms/` belongs to the open Phase 3 branch, and the charter's
        // parallelism rule is that two branches touch disjoint files. Its rite
        // already sets its other five strings through `AppFont`, which now scale
        // for free; this one is the Devanāgarī drawn in three strokes, sized
        // against the room's own geometry. It is pinned rather than reached
        // into, so it is visible here the day that branch merges.
        "Views/Rooms/RiteOfEnteringView.swift · .system(size: Self.writtenSize)",
    ]

    /// The two strings that stand in a fixed box on purpose, pinned the same
    /// way. Both are marks at a fixed size — they are in `fixedByDesign` above
    /// for exactly that reason — centred in the target `HitAreaIdiomTests`
    /// holds them to: the card's close `×` in 44 × 44, and the zoom column's
    /// four glyphs in 46 × 46. A `minHeight` there would be a floor under
    /// something that cannot rise, and the *width* is the half that matters
    /// anyway: a `minWidth` would let the target creep sideways into the card's
    /// own title, or the column into the field behind it.
    static let fixedFrameByDesign: Set<String> = [
        "Views/Mandala/SignificanceCard.swift · ×",
        "Views/Mandala/LivingMandalaView.swift · label",
    ]

    /// Every `.font(…)` in a shipping view, with the source of its argument.
    static func fontCalls() -> [(file: String, line: Int, source: String)] {
        var out: [(String, Int, String)] = []
        for f in LawSource.production where f.path.hasPrefix("Views/") || f.path.hasPrefix("Theme/") {
            let chars = f.lexed.chars
            for (open, close) in TypeScanner.callRanges(of: "font", in: f.lexed.masked) {
                let source = SwiftLexer.collapse(String(chars[open..<close]))
                out.append((f.path, 1 + chars[0..<open].filter { $0 == "\n" }.count, source))
            }
        }
        return out
    }
}

final class DynamicTypeTests: XCTestCase {

    // MARK: The corpus floor

    func testTheScanReallyReachesTheShippingViews() {
        let calls = ScaledType.fontCalls()
        XCTAssertGreaterThan(calls.count, 100,
                             "the font scan found \(calls.count) sites — audit §H5 counted about "
                             + "150, so the scanner has lost the tree rather than the tree having "
                             + "lost its type")
        let files = Set(calls.map(\.file))
        XCTAssertGreaterThan(files.count, 12, "the scan is reading one corner of Views/")
    }

    // MARK: 1 · Every size goes through a scaled token

    func testNoViewDeclaresARawFontSize() {
        // The two shapes that pin a string to the glass: a system font with a
        // size, and a custom font with a size and no text style to grow against.
        let rawSystem = #"\.system\(\s*size\s*:"#
        let rawCustom = #"\.custom\([^)]*size\s*:"#

        var found: Set<String> = []
        for call in ScaledType.fontCalls() {
            // `Theme/Fonts.swift` is where the tokens are built; it is the one
            // file allowed to name a raw size, because naming one is its job.
            if call.file == "Theme/Fonts.swift" { continue }
            let raw = Rx.matches(rawSystem, call.source)
                || (Rx.matches(rawCustom, call.source) && !call.source.contains("relativeTo"))
            guard raw else { continue }
            found.insert("\(call.file) · \(call.source)")
        }

        // Compared by exact equality in both directions, the shape the other
        // suites use. A new raw size fails on the left; a pin whose site has
        // gone — renamed, reformatted, deleted — fails on the right, so the
        // ledger cannot quietly outlive the thing it excuses.
        let unpinned = found.subtracting(ScaledType.fixedByDesign).sorted()
        let stale = ScaledType.fixedByDesign.subtracting(found).sorted()
        XCTAssertTrue(unpinned.isEmpty,
                      "these call sites still nail their type to the glass — every one has to be "
                      + "an `AppFont` token, or a written-down exception in "
                      + "`ScaledType.fixedByDesign`:\n" + unpinned.joined(separator: "\n"))
        XCTAssertTrue(stale.isEmpty,
                      "these exceptions no longer describe anything in the tree; an exception that "
                      + "cannot be found is an exception nobody is reading:\n"
                      + stale.joined(separator: "\n"))
    }

    func testTheThreeTokensAreActuallyScaled() {
        guard let fonts = LawSource.production("Fonts.swift") else {
            return XCTFail("Theme/Fonts.swift is gone")
        }
        XCTAssertTrue(Rx.matches(#"func sanskrit[\s\S]{0,240}?relativeTo:"#, fonts.text),
                      "`sanskrit` no longer scales")
        XCTAssertTrue(Rx.matches(#"func voice[\s\S]{0,240}?relativeTo:"#, fonts.text),
                      "`voice` no longer scales")
        XCTAssertTrue(Rx.matches(#"func labelPointSize[\s\S]{0,600}?UIFontMetrics"#, fonts.text),
                      "`label` no longer scales — `Font.system(size:)` has no `relativeTo:` of its "
                      + "own, so this token is the one that has to go through `UIFontMetrics`")
        XCTAssertTrue(Rx.matches(#"func label\([\s\S]{0,200}?labelPointSize"#, fonts.text),
                      "`label` no longer goes through `labelPointSize`, which is where the metric's "
                      + "third-of-a-point quantisation is normalised away")
    }

    /// The mapping from a size to the style it grows against is the one
    /// judgement call in §4.3, and it is the one somebody will want to argue
    /// with. It is asserted here at the boundaries so an edit to it is
    /// deliberate.
    func testASizeIsMeasuredAgainstTheStyleItIsNearest() {
        XCTAssertEqual(AppFont.style(forSize: 11), .caption2)
        XCTAssertEqual(AppFont.style(forSize: 11.5), .caption2)
        XCTAssertEqual(AppFont.style(forSize: 12), .caption)
        XCTAssertEqual(AppFont.style(forSize: 13), .footnote)
        XCTAssertEqual(AppFont.style(forSize: 15), .subheadline)
        XCTAssertEqual(AppFont.style(forSize: 17), .body)
        XCTAssertEqual(AppFont.style(forSize: 20), .title3)
        XCTAssertEqual(AppFont.style(forSize: 23), .title2)
        XCTAssertEqual(AppFont.style(forSize: 30), .title)
        XCTAssertEqual(AppFont.style(forSize: 44), .largeTitle)
        XCTAssertEqual(AppFont.style(forSize: 84), .largeTitle)
    }

    /// At the default content size a scaled token is exactly the size it was
    /// asked for — which is the whole reason the composition snapshots recorded
    /// before this phase still pass. If this ever stops being true, every
    /// baseline in `iOS/SnapshotBaselines/` is measuring a different app.
    ///
    /// This asserts the **token**, not the metric underneath it. `UIFontMetrics`
    /// on its own quantises to a third of a point and does *not* hold this
    /// identity at half-point sizes (it answers 11.666… for 11.5); the guard
    /// below that fact is what makes the identity true of the thing that ships.
    func testAtTheDefaultSizeNothingMoved() {
        let atDefault = UITraitCollection(preferredContentSizeCategory: .large)
        for size in [11.0, 11.5, 12.0, 13.5, 14.5, 15.0, 17.0, 19.0, 23.0, 30.0, 44.0, 60.0] {
            XCTAssertEqual(AppFont.labelPointSize(size, compatibleWith: atDefault), size,
                           accuracy: 0.01,
                           "\(size) pt is not \(size) pt at the default content size")
        }
    }

    /// The half-point sizes are the ones the raw metric loses, and the ones the
    /// Rite's kicker had a quarter of a point of slack for. Named separately so
    /// the reason the normalisation exists cannot be deleted by accident.
    func testTheHalfPointStripsSurviveTheMetric() {
        let atDefault = UITraitCollection(preferredContentSizeCategory: .large)
        for size in [11.5, 12.5, 13.5] {
            let raw = UIFontMetrics(forTextStyle: AppFont.uiTextStyle(AppFont.style(forSize: size)))
                .scaledValue(for: size, compatibleWith: atDefault)
            XCTAssertNotEqual(raw, size, accuracy: 0.01,
                              "`UIFontMetrics` no longer quantises \(size) pt — if that is really "
                              + "true the normalisation in `labelPointSize` is now a no-op and can "
                              + "go, but check it on every OS the app ships to first")
            XCTAssertEqual(AppFont.labelPointSize(size, compatibleWith: atDefault), size,
                           accuracy: 0.01,
                           "a \(size) pt strip ships at \(raw) pt — 1.45% wider than it was drawn, "
                           + "which is what re-composed the Rite")
        }
    }

    /// And at the largest accessibility size it genuinely grows — every token,
    /// and the small ones by more than the large ones, which is the point of
    /// mapping a size to a style at all.
    func testAtTheLargestSizeEverythingGrowsAndTheSmallGrowMost() {
        func factor(_ size: CGFloat) -> CGFloat {
            AppFont.labelPointSize(size, compatibleWith: UITraitCollection(
                preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)) / size
        }
        XCTAssertGreaterThan(factor(11.5), 1.5, "an 11.5 pt strip barely grew")
        XCTAssertGreaterThan(factor(17), 1.5, "body copy barely grew")
        XCTAssertGreaterThan(factor(60), 1.1, "a title did not grow at all")
        XCTAssertGreaterThan(factor(11.5), factor(60),
                             "the smallest type has to grow fastest — a 60 pt name that grew like "
                             + "an 11 pt strip is four words on nine lines")
    }

    // MARK: 2 · No scaled string is trapped in a fixed height

    func testNoStringSitsInAFixedHeight() {
        var offenders: [String] = []
        for f in LawSource.production where f.path.hasPrefix("Views/") {
            let chars = f.lexed.chars
            let masked = f.lexed.masked
            for (open, close) in TypeScanner.callRanges(of: "Text", in: masked) {
                let chain = TypeScanner.trailingChain(from: close + 1, masked: masked)
                guard chain.contains(where: { $0.name == "font" }) else { continue }
                let fixed = chain.first {
                    $0.name == "frame"
                        && Rx.matches(#"(?<!min)(?<!max)[Hh]eight\s*:"#,
                                      SwiftLexer.collapse(String(chars[$0.start..<$0.end])))
                }
                guard let fixed else { continue }
                let words = TypeScanner.literalShape(between: open, and: close, in: f)
                guard !ScaledType.fixedFrameByDesign.contains("\(f.path) · \(words)") else { continue }
                let line = 1 + chars[0..<open].filter { $0 == "\n" }.count
                offenders.append("\(f.path):\(line) “\(words.prefix(48))” — "
                                 + SwiftLexer.collapse(String(chars[fixed.start..<fixed.end])))
            }
        }
        XCTAssertTrue(offenders.isEmpty,
                      "a string whose type can grow is standing in a box that cannot. The idiom is "
                      + "`.frame(minHeight:)`: the same number at the default size, a floor rather "
                      + "than a ceiling above it:\n" + offenders.joined(separator: "\n"))
    }

    // MARK: 3 · A string held to one line can shrink to fit

    func testEverySingleLineStringCanShrink() {
        var offenders: [String] = []
        for f in LawSource.production where f.path.hasPrefix("Views/") {
            let chars = f.lexed.chars
            let masked = f.lexed.masked
            for (open, close) in TypeScanner.callRanges(of: "Text", in: masked) {
                let chain = TypeScanner.trailingChain(from: close + 1, masked: masked)
                let oneLine = chain.contains {
                    $0.name == "lineLimit"
                        && SwiftLexer.collapse(String(chars[$0.start..<$0.end])) == "1"
                }
                guard oneLine else { continue }
                guard !chain.contains(where: { $0.name == "minimumScaleFactor" }) else { continue }
                let words = TypeScanner.literalShape(between: open, and: close, in: f)
                let line = 1 + chars[0..<open].filter { $0 == "\n" }.count
                offenders.append("\(f.path):\(line) “\(words.prefix(48))”")
            }
        }
        XCTAssertTrue(offenders.isEmpty,
                      "held to one line with nothing to shrink by, these end in an ellipsis at the "
                      + "largest accessibility size:\n" + offenders.joined(separator: "\n"))
    }
}
