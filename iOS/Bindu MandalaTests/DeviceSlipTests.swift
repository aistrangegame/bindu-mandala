import XCTest
import SwiftUI
@testable import Bindu_Mandala

// MARK: - DeviceSlipTests — the three slips only a phone could find
//
// `AUDIT-REPORT-DEVICE.md`'s Also-observed list is what a session on Neev and
// two simulators saw that no code read had caught. Four of its items are this
// phase's (§4.5); three are fixed here, and the fourth needs hardware.
//
//  5 · "Minor Mandala z-order: a bright seat glow renders partly under the zoom
//      control column (both widths)." The controls carried a flat
//      `ground.opacity(0.55)` disc — one value all the way to its rim — so a lit
//      seat behind the column had a hard dark circle stamped over it. The fix is
//      a wash: dense under the glyph, where it has to be for the glyph to read,
//      and gone to nothing at the rim, so her light carries through.
//
//  6 · "The quality-description paragraph (Detail, both kp 29 and kp 45) and the
//      Settings sheet title render in a system sans rather than Cormorant." Two
//      strings out of the app's own mouth in somebody else's voice.
//
//  7 · "Staged first paint under host load" — **not fixed, and not fixable
//      here**: it is a frame-timing observation that needs an instrumented run
//      on the phone. It belongs with G5, which is still BLOCKED. Said plainly.
//
//  … and from Session 1's §H5 / FIDELITY rule 3: reduce motion switched on
//      *mid-session* never stopped a mote already looping, because the
//      environment was read once, at appear.
//
// (Item 4, the SE-width Well header collision, was fixed in Phase 2 and is not
// re-opened here.)
//
// What a test can prove about each
// ────────────────────────────────
// A gradient's stops and a font's face are values in the source: read them, and
// the assertion is exact. A mote's loop is a SwiftUI internal with no seam to
// reach through, so what is asserted is the seam that was missing — that the
// view answers the *change*, and that nothing starts a repeat outside the one
// gated function. That is the defect, stated precisely.

final class DeviceSlipTests: XCTestCase {

    private func source(_ name: String) -> SourceFile? { LawSource.production(name) }

    // MARK: 4.5 a — her light carries through the zoom column

    func testTheZoomControlsSitOnAWashThatClearsAtTheRim() {
        guard let f = source("LivingMandalaView.swift") else {
            return XCTFail("LivingMandalaView is gone")
        }

        XCTAssertFalse(f.text.contains("Circle().fill(Color.ground.opacity(0.55))"),
                       "the flat disc is back: one opacity out to the rim stamps a hard dark "
                       + "circle over any seat behind the column (device audit, Also-observed 5)")

        guard let wash = Rx.first(#"controlWash: RadialGradient \{[\s\S]*?\n    \}"#, f.text) else {
            return XCTFail("the zoom controls no longer sit on `controlWash`")
        }

        let stops = Rx.groups(#"opacity\(([0-9.]+)\), location: ([0-9.]+)"#, wash)
            .compactMap { g -> (alpha: Double, at: Double)? in
                guard let a = Double(g[1]), let l = Double(g[2]) else { return nil }
                return (a, l)
            }
        XCTAssertGreaterThanOrEqual(stops.count, 3,
                                    "a two-stop wash is a disc with a soft edge, not a wash")

        guard let centre = stops.first, let rim = stops.last else { return }
        XCTAssertEqual(rim.at, 1.0, accuracy: 0.001, "the last stop must be the rim")
        XCTAssertEqual(rim.alpha, 0.0, accuracy: 0.001,
                       "the wash has to reach *nothing* at the rim — anything above zero is still "
                       + "an edge drawn over her")
        XCTAssertGreaterThanOrEqual(centre.alpha, 0.6,
                                    "under the glyph the ground must stay dense enough for the "
                                    + "glyph to read against a lit seat")

        // Monotone: every stop at least as clear as the one inside it. A wash
        // that brightens on its way out has a ring in it.
        for (a, b) in zip(stops, stops.dropFirst()) {
            XCTAssertGreaterThan(b.at, a.at, "the wash's stops must run outward")
            XCTAssertLessThanOrEqual(b.alpha, a.alpha + 0.0001,
                                     "the wash brightens between \(a.at) and \(b.at) — that is a ring")
        }
    }

    // MARK: 4.5 b — the two strings that spoke in a system sans

    func testTheQualityParagraphSpeaksInCormorant() {
        guard let f = source("ShaktiDetailView.swift") else {
            return XCTFail("ShaktiDetailView is gone")
        }
        guard let site = TypeScanner.sites(in: f).first(where: {
            $0.words == "shakti.qualityDescription"
        }) else { return XCTFail("the Detail no longer prints her quality description") }

        let font = site.chain.prefix(160)
        XCTAssertTrue(font.contains("AppFont.cormorant"),
                      "the one body paragraph on the Detail is still set in a system sans "
                      + "(device audit, Also-observed 6) — \(font)")
        XCTAssertFalse(font.contains(".font(.system("),
                       "the system face is back on the quality paragraph — \(font)")
    }

    func testTheSettingsTitleSpeaksInCormorant() {
        guard let f = source("SettingsView.swift") else { return XCTFail("SettingsView is gone") }
        XCTAssertTrue(Rx.matches(#"placement:\s*\.principal"#, f.text),
                      "Settings still takes its title from `.navigationTitle` alone, which is the "
                      + "system's face (device audit, Also-observed 6)")
        guard let item = Rx.first(#"ToolbarItem\(placement: \.principal\)[\s\S]{0,400}?\n {16}\}"#, f.text)
        else { return XCTFail("the principal toolbar item is gone") }
        XCTAssertTrue(item.contains("AppFont.cormorant"),
                      "the Settings title is in the toolbar but not in Cormorant")
        XCTAssertTrue(item.contains("\"Settings\""),
                      "the principal item says something other than the sheet's own name")
        // The accessible title stays: VoiceOver and the back stack read it.
        XCTAssertTrue(f.text.contains(#".navigationTitle("Settings")"#),
                      "`.navigationTitle` was removed — VoiceOver and the back stack lose the name")
    }

    // MARK: 4.5 c — reduce motion, answered mid-session

    func testTheMotesAnswerAReduceMotionChangeAndNotOnlyAnAppearance() {
        guard let f = source("DustMotesView.swift") else { return XCTFail("DustMotesView is gone") }

        XCTAssertTrue(Rx.matches(#"\.onChange\(of: reduceMotion\)"#, f.text),
                      "a mote still reads reduce-motion only at appear, so a loop already running "
                      + "never stops when the walker turns the setting on mid-session")

        // Every repeat lives inside the one gated function. A second
        // `repeatForever` anywhere else in this file is a loop that no change of
        // the setting can reach. Counted on the *masked* source, so the sentence
        // above this test's own fix does not count as a second loop.
        let code = String(f.lexed.masked)
        guard let follow = Rx.first(#"private func follow\(\) \{[\s\S]*?\n        \}"#, code) else {
            return XCTFail("`follow()` is gone — the gate has no body")
        }
        let repeatsInFile = Rx.all(#"repeatForever"#, code).count
        let repeatsInGate = Rx.all(#"repeatForever"#, follow).count
        XCTAssertEqual(repeatsInFile, repeatsInGate,
                       "\(repeatsInFile - repeatsInGate) repeating animation(s) in DustMotesView "
                       + "start outside the reduce-motion gate")

        XCTAssertTrue(follow.contains("guard !reduceMotion"),
                      "`follow()` starts the loop without asking the setting first")
        XCTAssertTrue(follow.contains("disablesAnimations"),
                      "turning the setting on has to *replace* the running repeat — an assignment "
                      + "inside an animated transaction would simply animate to the new value")
    }

    /// FIDELITY rule 3 over the whole of `Views/`, not just the motes: every
    /// `repeatForever` sits in a file that reads reduce-motion. The mid-session
    /// hole was only visible because the gate existed — this keeps the gate.
    func testEveryRepeatingAnimationStillLivesBesideAReduceMotionGate() {
        var failures: [String] = []
        for file in LawSource.production where file.path.hasPrefix("Views/")
            && !file.path.hasPrefix("Views/Spike/") {
            let repeats = Rx.all(#"repeatForever"#, String(file.lexed.masked)).count
            guard repeats > 0 else { continue }
            if !file.text.contains("reduceMotion") {
                failures.append("\(file.path): \(repeats) repeating animation(s), no reduce-motion gate")
            }
        }
        XCTAssertTrue(failures.isEmpty, failures.joined(separator: "\n"))
    }

    // MARK: 4.5 d — the one that needs hardware, named rather than skipped

    func testStagedFirstPaintIsRecordedAsNeedingHardware() {
        // Also-observed 7 is "staged first paint under host load — verify paint
        // latency on hardware". It is a timing observation made while a Mac was
        // building, on a simulator that shares that Mac's CPU. There is nothing
        // in the source to assert and nothing a simulator can measure that would
        // mean anything; it belongs with the G5 baseline, which is BLOCKED on the
        // phone in both audit sessions. This test exists so the item is *carried*
        // rather than quietly dropped: it fails if the decisions log stops
        // saying so.
        let decisions = LawSource.repoRoot.appendingPathComponent("DECISIONS.md")
        guard let text = try? String(contentsOf: decisions, encoding: .utf8) else {
            return XCTFail("DECISIONS.md is gone — the charter's §4 record")
        }
        XCTAssertTrue(text.lowercased().contains("staged first paint"),
                      "the one 4.5 item that needs hardware is no longer written down in "
                      + "DECISIONS.md, which is the only place it is carried")
    }
}
