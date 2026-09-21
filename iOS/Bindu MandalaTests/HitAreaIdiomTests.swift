import XCTest
@testable import Bindu_Mandala

// MARK: - HitAreaIdiomTests — FIDELITY rule 4's other half, held in the source
//
// Rule 4: *"Interactive controls ≥ 44 × 44 pt (add
// `.frame(minHeight: 44).contentShape(Rectangle())` or vertical padding to
// inline links)."* Audit §H4 inspected all 28 `Button` sites and both
// non-`Button` interactives and came back with **eight** under the bar — the
// worst a bare `Text` about 19 pt tall, which happened to be the way *out* of
// the Bindu.
//
// `HitAreaTests` in the UI target measures six of the eight on a running app,
// which is the better proof: `XCUIElement.frame` is the frame iOS hit-tests.
// This file is the second lock, and the only lock on the two a simulator cannot
// reach — Detail's hold-to-cross pill, which appears only when a Śakti is ready
// to cross, and the Field's "the threshold ›", which needs an āvaraṇa row that
// lives only in Airtable.
//
// It asserts the *idiom*, not a number it cannot compute: rule 4's own
// `.frame(minHeight: 44)` with a `.contentShape` to make the grown box
// tappable. A source check cannot know a font's line height, so it does not
// pretend to — it proves the floor is declared, and the running app proves the
// floor is met.
//
// The arithmetic beside each one
// ──────────────────────────────
// Every growth is paid for, point for point, out of a padding or a spacing in
// the same view, so the drawn composition does not move. `FeltRegisterSnapshots`
// is the proof of that half, across three device classes, against the geometry
// of `main` before this phase. Read the two together: this one says the target
// is big enough, that one says nothing moved to make it so. The third test here
// keeps the ledger honest between builds, and the fourth keeps the growth
// *outside* every shape that is actually drawn — a capsule padded from within
// is a different screen, not a bigger button.

enum HitArea {

    /// One of the eight, found by the words on it rather than by a line number:
    /// the audit's line numbers are three phases stale.
    struct Control {
        let file: String
        /// A fragment of the `Text`'s literal shape — its words, or the
        /// expression that stands in for them.
        let words: String
        /// A modifier that tells this site apart from its twin. Detail draws the
        /// same status label twice: once as a pill that does nothing, once as
        /// the one you hold to cross. Only the second is a control.
        var identifiedBy: String?
        /// Where it stood in §H4, and what paid for the growth.
        let note: String
    }

    static let eight: [Control] = [
        Control(file: "Views/Mandala/LalitaSourceView.swift",
                words: "↑ return to the field",
                note: "≈19 pt — the padding was on the Button, outside the label; moved inside, 62 pt"),
        Control(file: "Views/Common/ShaktiDetailView.swift",
                words: "shakti.status.label.uppercased()",
                identifiedBy: "onLongPressGesture",
                note: "≈25 pt — 20 pt below the capsule, the pill stack's spacing gives the 20 back"),
        Control(file: "Views/Common/TheHundredTwoView.swift",
                words: "the threshold ›",
                note: "≈37 pt — vertical padding 10 → 14, the row's own padding gives the 8 back"),
        Control(file: "Views/Memory/DescentFilmView.swift",
                words: "close",
                note: "≈37 pt — vertical padding 12 → 16, the block beneath gives the 8 back"),
        Control(file: "Views/Memory/PortraitMandalaView.swift",
                words: "hold this image",
                note: "≈41 pt — 4 pt under the capsule, and “close” gives up its 4 pt of top padding"),
        Control(file: "Views/Today/Rite/RiteBlockView.swift",
                words: "know her ›",
                note: "≈42 pt — 2 pt above the words, 2 pt off the block's top padding"),
        // Two of the eight have no `Text` chain of their own to find them by and
        // are checked on their own below: Settings' rename field is a
        // `TextField`, and Today's celestial strip is a whole `HStack` — a line
        // and the chevron after it — so the padding that makes it a control sits
        // on the row, not on either string in it.
    ]

    typealias Chain = [(name: String, source: String)]

    /// Every `Text(…)` in the file whose literal shape contains `words`, with
    /// the modifiers trailing it — the same walk `LegibilityTests` uses.
    static func chains(after words: String, in file: SourceFile) -> [Chain] {
        let chars = file.lexed.chars
        let masked = file.lexed.masked
        var out: [Chain] = []
        for (open, close) in TypeScanner.callRanges(of: "Text", in: masked) {
            let shape = TypeScanner.literalShape(between: open, and: close, in: file)
            guard shape.contains(words) else { continue }
            out.append(TypeScanner.trailingChain(from: close + 1, masked: masked).map {
                ($0.name, SwiftLexer.collapse(String(chars[$0.start..<$0.end])))
            })
        }
        return out
    }

    static func chain(for control: Control, in file: SourceFile) -> Chain? {
        let all = chains(after: control.words, in: file)
        guard let marker = control.identifiedBy else { return all.first }
        return all.first { chain in chain.contains { $0.name == marker } }
    }
}

final class HitAreaIdiomTests: XCTestCase {

    private func file(_ path: String) -> SourceFile? {
        LawSource.production.first { $0.path == path }
    }

    // MARK: The corpus floor
    //
    // Every check here is a search, and a search that finds nothing reads as a
    // pass. This is what makes a lost pin loud.

    func testTheEightAreStillFindable() {
        XCTAssertEqual(HitArea.eight.count, 6,
                       "six of the eight are found by their words; the rename field and the "
                       + "celestial strip are rows, and are pinned on their own below")
        for control in HitArea.eight {
            guard let f = file(control.file) else {
                XCTFail("\(control.file) is gone — the hit-area pin cannot be checked")
                continue
            }
            XCTAssertNotNil(HitArea.chain(for: control, in: f),
                            "\(control.file) no longer offers “\(control.words)”"
                            + (control.identifiedBy.map { " with .\($0)" } ?? "")
                            + " — the pin has to be re-found by its text, never repaired by guessing")
        }
    }

    // MARK: Rule 4's idiom, at every one of the eight

    func testEveryUndersizedControlDeclaresTheFloor() {
        var failures: [String] = []
        for control in HitArea.eight {
            guard let f = file(control.file), let chain = HitArea.chain(for: control, in: f)
            else { continue }

            let declares44 = chain.contains {
                $0.name == "frame" && Rx.matches(#"minHeight\s*:\s*44"#, $0.source)
            }
            if !declares44 {
                failures.append("\(control.file) · “\(control.words)”: no .frame(minHeight: 44) "
                                + "— \(control.note)")
            }
            if !chain.contains(where: { $0.name == "contentShape" }) {
                failures.append("\(control.file) · “\(control.words)”: no .contentShape, so the "
                                + "grown box is not tappable")
            }
        }
        XCTAssertTrue(failures.isEmpty,
                      "FIDELITY rule 4 wants ≥ 44 × 44 for anything a thumb has to find:\n"
                      + failures.joined(separator: "\n"))
    }

    // MARK: The two that are not a string — a field, and a whole row

    /// Today's celestial strip is the moon's line *and* the chevron after it, so
    /// what a thumb presses is the `HStack`, and the padding that makes it a
    /// control is on the row. Read the strip's own function rather than either
    /// string inside it.
    func testTheCelestialStripDeclaresTheFloor() {
        guard let f = file("Views/Today/DailyRiteView.swift") else {
            return XCTFail("DailyRiteView is gone")
        }
        guard let strip = Rx.first(#"private func celestialStrip[\s\S]*?\n    \}"#, f.text) else {
            return XCTFail("`celestialStrip` is gone from DailyRiteView")
        }
        XCTAssertTrue(Rx.matches(#"\.frame\(minHeight:\s*44\)"#, strip),
                      "the celestial strip — ≈38 pt in audit §H4 — declares no 44 pt floor")
        XCTAssertTrue(Rx.matches(#"\.contentShape\("#, strip),
                      "the celestial strip's grown row is not tappable")
        XCTAssertTrue(strip.contains("VStack(spacing: -1)"),
                      "the strip's 8 pt of new touch area is no longer paid for out of its spacing")
    }

    func testTheRenameFieldDeclaresTheFloor() {
        guard let f = file("Views/Common/SettingsView.swift") else {
            return XCTFail("SettingsView is gone")
        }
        guard let body = Rx.first(#"struct FieldNameField[\s\S]*"#, f.text) else {
            return XCTFail("FieldNameField is gone from SettingsView")
        }
        XCTAssertTrue(Rx.matches(#"\.frame\(minHeight:\s*44\)"#, body),
                      "the rename field — ≈42 pt in audit §H4 — declares no 44 pt floor")
        XCTAssertTrue(Rx.matches(#"\.contentShape\("#, body),
                      "the rename field's grown box is not tappable")
    }

    // MARK: The growth is paid for — the numbers, not just the intent
    //
    // Each line is the *other side* of a growth above. Remove a compensation
    // without removing its growth and the composition moves; the snapshot suite
    // would find it on three device classes, but a whole build later. This finds
    // it here, in a second.

    func testEveryGrowthHasItsCompensationBesideIt() {
        let ledger: [(path: String, needle: String, why: String)] = [
            ("Views/Common/TheHundredTwoView.swift", ".padding(.top, avarana == nil ? 8 : 4)",
             "the threshold row's 8 pt of new target comes out of this padding (was 8) — and "
             + "only when there is an āvaraṇa, because without one the whole caption collapses "
             + "and there is no grown target to pay for"),
            ("Views/Common/TheHundredTwoView.swift", ".padding(.bottom, avarana == nil ? 12 : 8)",
             "and out of this one (was 12), under the same condition"),
            ("Views/Memory/DescentFilmView.swift", ".padding(.bottom, 10)",
             "CLOSE's 8 pt comes out of the dots' bottom padding (was 14)"),
            ("Views/Memory/DescentFilmView.swift", ".padding(.bottom, 20)",
             "and out of the button's own bottom padding (was 24)"),
            ("Views/Today/DailyRiteView.swift", "VStack(spacing: -1)",
             "the celestial strip's 8 pt comes out of the strip's spacing (was 7)"),
            ("Views/Common/ShaktiDetailView.swift", "VStack(spacing: -12)",
             "the crossing pill's 20 pt comes out of the pill stack's spacing (was 8)"),
            ("Views/Today/Rite/RiteBlockView.swift", ".padding(.top, 8)",
             "“know her ›”'s 2 pt comes off the block's top padding (was 10)"),
            ("Views/Common/SettingsView.swift", ".padding(.top, 4)",
             "the rename field's 2 pt comes off the hint's top padding (6 spelled out, minus 2)"),
            ("Views/Memory/PortraitMandalaView.swift", "Button(\"close\") { dismiss() }",
             "the export pill's 4 pt comes off “close”, which no longer carries .padding(.top, 4)"),
        ]
        var failures: [String] = []
        for entry in ledger {
            guard let f = file(entry.path) else {
                failures.append("\(entry.path) is gone")
                continue
            }
            if !f.text.contains(entry.needle) {
                failures.append("\(entry.path): `\(entry.needle)` is gone — \(entry.why)")
            }
        }
        XCTAssertTrue(failures.isEmpty,
                      "a hit area grew and nothing beside it gave the points back:\n"
                      + failures.joined(separator: "\n"))
    }

    // MARK: Nothing grew inside something that is drawn
    //
    // The one idiom this phase may not reach for. A capsule is the *background
    // of a padded label*, so padding added before the background grows the ring
    // the walker sees. Every `.frame(minHeight: 44)` here sits after the
    // `.background(…)` it belongs to, if there is one at all.

    func testTheGrowthIsAlwaysOutsideTheDrawnShape() {
        var failures: [String] = []
        for control in HitArea.eight {
            guard let f = file(control.file), let chain = HitArea.chain(for: control, in: f)
            else { continue }
            guard let background = chain.firstIndex(where: { $0.name == "background" }),
                  let floor = chain.firstIndex(where: {
                      $0.name == "frame" && Rx.matches(#"minHeight\s*:\s*44"#, $0.source)
                  })
            else { continue }
            if floor < background {
                failures.append("\(control.file) · “\(control.words)”: the 44 pt floor is declared "
                                + "before .background, so the shape it draws grew too")
            }
        }
        XCTAssertTrue(failures.isEmpty, failures.joined(separator: "\n"))
    }
}
