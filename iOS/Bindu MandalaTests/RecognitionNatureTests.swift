import XCTest
@testable import Bindu_Mandala

/// The six natures of Recognition (Wave 1 · Slice C).
///
/// The port had flattened Design's six responses — flare, pool, disperse,
/// bloom, settle, radiate — into one scale-breath. These pin each one back to
/// Design's own numbers (`LR_RECOG` and the `lrResp…` keyframes), prove the six
/// are really six, and hold the ceremony's surviving principles: practice data
/// first, nothing grades him, the timeline lands both lines in order.
final class RecognitionNatureTests: XCTestCase {

    // MARK: Element → nature

    func testEveryElementHasItsOwnNature() {
        XCTAssertEqual(RecognitionNature.of(.fire), .flare)
        XCTAssertEqual(RecognitionNature.of(.water), .pool)
        XCTAssertEqual(RecognitionNature.of(.air), .disperse)
        XCTAssertEqual(RecognitionNature.of(.ether), .bloom)
        XCTAssertEqual(RecognitionNature.of(.earth), .settle)
        XCTAssertEqual(RecognitionNature.of(.light), .radiate)

        let natures = Set(Element.allCases.map(RecognitionNature.of))
        XCTAssertEqual(natures.count, Element.allCases.count, "two elements share a nature")
        XCTAssertEqual(natures, Set(RecognitionNature.allCases), "a nature is unreachable from any element")
    }

    /// Every Śakti reaches a nature through her element, whatever her ring —
    /// the 86 by the ring table, Ring 2 by her tattva.
    func testEveryRingReachesANature() {
        for ring in 0...10 {
            let n = RecognitionNature.of(Element.forRing(ring))
            XCTAssertTrue(RecognitionNature.allCases.contains(n))
        }
    }

    // MARK: The six are six

    /// The defect this slice exists to undo: six natures that move as one.
    func testNoTwoNaturesMoveAlike() {
        let all = RecognitionNature.allCases
        for (i, a) in all.enumerated() {
            for b in all[(i + 1)...] {
                let same = a.peak == b.peak && a.rest == b.rest
                    && a.ripple == b.ripple && a.glowY == b.glowY && a.repeats == b.repeats
                XCTAssertFalse(same, "\(a) and \(b) move identically — the natures have flattened again")
            }
        }
    }

    func testEachNatureMovesInItsOwnDirection() {
        // Fire rises — upward is negative y — and only fire travels vertically.
        XCTAssertLessThan(RecognitionNature.flare.peak.dy, 0)
        XCTAssertEqual(RecognitionNature.flare.peak.dx, 0)
        // Air drifts sideways and only air travels horizontally.
        XCTAssertGreaterThan(RecognitionNature.disperse.peak.dx, 0)
        XCTAssertEqual(RecognitionNature.disperse.peak.dy, 0)
        for n in RecognitionNature.allCases where n != .flare && n != .disperse {
            XCTAssertEqual(n.peak.dx, 0, "\(n) drifts sideways")
            XCTAssertEqual(n.peak.dy, 0, "\(n) rises")
        }
        // Ether blooms once and holds; every other nature keeps answering.
        XCTAssertFalse(RecognitionNature.bloom.repeats)
        for n in RecognitionNature.allCases where n != .bloom { XCTAssertTrue(n.repeats, "\(n) stops") }
        // Ether opens widest; earth barely stirs; light shines brightest.
        let amplitude: (RecognitionNature) -> Double = { $0.peak.scale - $0.rest.scale }
        let widest = RecognitionNature.allCases.max(by: { amplitude($0) < amplitude($1) })
        let stillest = RecognitionNature.allCases.min(by: { amplitude($0) < amplitude($1) })
        let brightest = RecognitionNature.allCases.max(by: { $0.peak.opacity < $1.peak.opacity })
        XCTAssertEqual(widest, RecognitionNature.bloom)
        XCTAssertEqual(stillest, RecognitionNature.settle)
        XCTAssertEqual(brightest, RecognitionNature.radiate)
    }

    // MARK: Design's numbers

    /// `lrRespFlare` … `lrRespRadiate`, keyframe for keyframe.
    func testTheResponsesAreDesignsKeyframes() {
        // rest scale, rest light, drift, rise, peak scale, peak light
        let expected: [RecognitionNature: [Double]] = [
            .flare:    [1.0, 0.32, 0.0, -16.0, 1.06, 0.58],
            .pool:     [1.0, 0.40, 0.0, 0.0, 1.07, 0.58],
            .disperse: [1.0, 0.30, 20.0, 0.0, 1.04, 0.52],
            .bloom:    [0.9, 0.30, 0.0, 0.0, 1.16, 0.60],
            .settle:   [1.0, 0.34, 0.0, 0.0, 1.015, 0.46],
            .radiate:  [1.0, 0.40, 0.0, 0.0, 1.05, 0.72],
        ]
        for n in RecognitionNature.allCases {
            guard let e = expected[n], e.count == 6 else { return XCTFail("\(n) has no keyframes in this test") }
            XCTAssertEqual(n.rest.scale, e[0], accuracy: 1e-9, "\(n) rest scale")
            XCTAssertEqual(n.rest.opacity, e[1], accuracy: 1e-9, "\(n) rest light")
            XCTAssertEqual(n.rest.dx, 0)
            XCTAssertEqual(n.rest.dy, 0)
            XCTAssertEqual(n.peak.dx, e[2], accuracy: 1e-9, "\(n) drift")
            XCTAssertEqual(n.peak.dy, e[3], accuracy: 1e-9, "\(n) rise")
            XCTAssertEqual(n.peak.scale, e[4], accuracy: 1e-9, "\(n) peak scale")
            XCTAssertEqual(n.peak.opacity, e[5], accuracy: 1e-9, "\(n) peak light")
        }
    }

    /// `LR_RECOG`, row for row.
    func testWhereEachNatureLivesIsDesigns() {
        // fy, focal, respDur, rippleDur, rippleN, motes
        let rows: [RecognitionNature: [Double]] = [
            .flare:    [0.60, 0.96, 5.5, 4.6, 4, 12],
            .pool:     [0.50, 0.62, 6.5, 6.4, 4, 10],
            .disperse: [0.44, 0.40, 6.0, 4.0, 5, 14],
            .bloom:    [0.45, 0.45, 4.8, 5.6, 3, 10],
            .settle:   [0.54, 0.92, 7.5, 7.6, 2, 6],
            .radiate:  [0.44, 0.44, 3.8, 3.6, 5, 12],
        ]
        for n in RecognitionNature.allCases {
            guard let r = rows[n], r.count == 6 else { return XCTFail("\(n) has no LR_RECOG row in this test") }
            XCTAssertEqual(n.focalY, r[0], accuracy: 1e-9, "\(n) fy")
            XCTAssertEqual(n.glowY, r[1], accuracy: 1e-9, "\(n) focal")
            XCTAssertEqual(n.cycle, r[2], accuracy: 1e-9, "\(n) respDur")
            XCTAssertEqual(n.rippleDuration, r[3], accuracy: 1e-9, "\(n) rippleDur")
            XCTAssertEqual(Double(n.rippleCount), r[4], accuracy: 1e-9, "\(n) rippleN")
            XCTAssertEqual(Double(n.motes), r[5], accuracy: 1e-9, "\(n) motes")
        }
        XCTAssertEqual(RecognitionNature.flare.ripple, .rise)
        XCTAssertEqual(RecognitionNature.disperse.ripple, .wide)
        for n in RecognitionNature.allCases where n != .flare && n != .disperse {
            XCTAssertEqual(n.ripple, .ring, "\(n) ripples")
        }
    }

    /// `lrRipple`, `lrRippleRise`, `lrRippleWide`.
    func testTheRipplesEndWhereDesignsEnd() {
        XCTAssertEqual(RecognitionNature.pool.rippleEnd,
                       .init(scaleX: 34, scaleY: 34, rise: 0, startOpacity: 0.5))
        XCTAssertEqual(RecognitionNature.flare.rippleEnd,
                       .init(scaleX: 30, scaleY: 30, rise: 120, startOpacity: 0.55))
        XCTAssertEqual(RecognitionNature.disperse.rippleEnd,
                       .init(scaleX: 52, scaleY: 20, rise: 0, startOpacity: 0.5))
    }

    /// A repeating nature autoreverses, so one leg is half Design's cycle; the
    /// port had used the whole cycle per leg and breathed at half speed.
    func testTheTempoIsDesignsCycleNotTwiceIt() {
        for n in RecognitionNature.allCases {
            if n.repeats {
                XCTAssertEqual(n.swing, n.cycle / 2, accuracy: 1e-9, "\(n)")
            } else {
                XCTAssertEqual(n.swing, n.cycle, accuracy: 1e-9, "\(n)")
            }
            XCTAssertEqual(n.bijaSwing, n.swing * 1.3, accuracy: 1e-9, "\(n) bīja")
        }
    }

    // MARK: Poses

    func testThePoseRunsFromRestToPeakAndNoFurther() {
        for n in RecognitionNature.allCases {
            XCTAssertEqual(n.pose(at: 0), n.rest)
            XCTAssertEqual(n.pose(at: 1), n.peak)
            XCTAssertEqual(n.pose(at: -3), n.rest, "\(n) overshoots below rest")
            XCTAssertEqual(n.pose(at: 7), n.peak, "\(n) overshoots past its peak")
            let mid = n.pose(at: 0.5)
            XCTAssertEqual(mid.scale, (n.rest.scale + n.peak.scale) / 2, accuracy: 1e-9)
            XCTAssertEqual(mid.opacity, (n.rest.opacity + n.peak.opacity) / 2, accuracy: 1e-9)
            XCTAssertEqual(mid.dy, n.peak.dy / 2, accuracy: 1e-9)
        }
    }

    /// Light stands in the air: no nature ever goes dark, and none is ever
    /// pushed past full.
    func testEveryPoseIsLight() {
        for n in RecognitionNature.allCases {
            for step in 0...10 {
                let p = n.pose(at: Double(step) / 10)
                XCTAssertGreaterThan(p.opacity, 0.25, "\(n) dims to nothing")
                XCTAssertLessThanOrEqual(p.opacity, 1)
                XCTAssertGreaterThan(p.scale, 0.8)
            }
        }
    }

    // MARK: Felt back

    func testEveryNatureIsFeltInTheHand() {
        for n in RecognitionNature.allCases {
            XCTAssertGreaterThan(n.pulse.intensity, 0, "\(n) is not felt")
            XCTAssertLessThanOrEqual(n.pulse.intensity, 1)
            XCTAssertGreaterThan(n.answerDuration, 0.5, "\(n) answers too fast to be seen")
            XCTAssertLessThan(n.answerDuration, RecognitionTimeline.note - RecognitionTimeline.act2 + 2,
                              "\(n)'s answer is still travelling long after the note has arrived")
        }
        XCTAssertEqual(RecognitionNature.settle.pulse.style, .heavy, "earth lands with weight")
        XCTAssertEqual(RecognitionNature.flare.pulse.style, .rigid, "fire is a spark")
    }

    // MARK: The timeline

    /// Design's staged arrival: name, phrase, the first line, a held beat,
    /// the second line alone, then the note.
    func testTheCeremonyArrivesInDesignsOrder() {
        let beats = [RecognitionTimeline.name, RecognitionTimeline.phrase, RecognitionTimeline.act1,
                     RecognitionTimeline.act2, RecognitionTimeline.note, RecognitionTimeline.autoClose]
        XCTAssertEqual(beats, beats.sorted(), "the ceremony's beats are out of order")
        XCTAssertEqual(Set(beats).count, beats.count, "two beats land together")
        XCTAssertEqual(RecognitionTimeline.name, 0.3, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.phrase, 1.1, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.act1, 2.6, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.act2, 4.3, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.note, 5.4, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.collapse, 0.62, accuracy: 1e-9)
        // "and she felt you back" lands in stillness: a held beat after Act 1
        // has fully arrived, and the note only after Act 2 has.
        XCTAssertGreaterThanOrEqual(RecognitionTimeline.act2 - RecognitionTimeline.act1,
                                    RecognitionTimeline.arrive)
        XCTAssertGreaterThanOrEqual(RecognitionTimeline.note - RecognitionTimeline.act2, 1)
        // The debug close waits for the whole ceremony to have landed.
        XCTAssertGreaterThanOrEqual(RecognitionTimeline.autoClose,
                                    RecognitionTimeline.note + RecognitionTimeline.arrive / 2)
    }

    // MARK: The after-glow

    func testTheAfterGlowFallsAwayOnDesignsCurve() {
        let d = RecognitionTimeline.afterGlow
        XCTAssertEqual(RecognitionTimeline.afterGlowStrength(at: 0), 1, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.afterGlowStrength(at: d), 0, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.afterGlowStrength(at: d / 2), 0.25, accuracy: 1e-9, "k², not linear")
        XCTAssertEqual(RecognitionTimeline.afterGlowStrength(at: -1), 1, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.afterGlowStrength(at: d * 4), 0, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.afterGlowStrength(at: 1, duration: 0), 0)
        var last = 2.0
        for step in 0...20 {
            let k = RecognitionTimeline.afterGlowStrength(at: d * Double(step) / 20)
            XCTAssertLessThanOrEqual(k, last, "the after-glow brightens again")
            last = k
        }
    }

    /// Brief: a residue, not a second ceremony.
    func testTheAfterGlowIsBrief() {
        XCTAssertGreaterThan(RecognitionTimeline.afterGlow, 1)
        XCTAssertLessThanOrEqual(RecognitionTimeline.afterGlow, 3)
        XCTAssertEqual(RecognitionTimeline.closeDuration(reduceMotion: false),
                       RecognitionTimeline.collapse + RecognitionTimeline.afterGlow, accuracy: 1e-9)
        XCTAssertEqual(RecognitionTimeline.closeDuration(reduceMotion: true),
                       RecognitionTimeline.reducedAfterGlow, accuracy: 1e-9)
        XCTAssertLessThan(RecognitionTimeline.reducedAfterGlow, RecognitionTimeline.afterGlow)
    }

    // MARK: The surviving principles, in the source

    private func code(_ name: String) throws -> String {
        let f = try XCTUnwrap(LawSource.production(name), "\(name) is not in the shipping corpus")
        return String(f.lexed.masked)
    }

    /// **Practice data first.** The recognition is written before a single
    /// light moves, and his note and the ledger write are committed before the
    /// ceremony starts to gather — so no after-glow can ever cost the record.
    func testThePracticeIsWrittenBeforeAnyLightMoves() throws {
        let view = try code("RecognitionMomentView.swift")

        let stage = try XCTUnwrap(Rx.first(#"private func stage\(\) \{[\s\S]*?\n    \}"#, view),
                                  "stage() is gone")
        let record = try XCTUnwrap(stage.range(of: "store.record("), "the ceremony no longer writes the recognition")
        for motion in ["withAnimation", "asyncAfter"] {
            if let first = stage.range(of: motion) {
                XCTAssertLessThan(record.lowerBound, first.lowerBound,
                                  "\(motion) runs before the recognition is written")
            }
        }

        let close = try XCTUnwrap(Rx.first(#"private func beginClose\(\) \{[\s\S]*?\n    \}"#, view),
                                  "beginClose() is gone")
        let commit = try XCTUnwrap(close.range(of: "commitClose()"), "the close no longer commits his words")
        let gather = try XCTUnwrap(close.range(of: "closing = true"), "the close no longer gathers")
        XCTAssertLessThan(commit.lowerBound, gather.lowerBound, "the ceremony gathers before his note is kept")

        XCTAssertTrue(view.contains("source: src"), "where she was felt from no longer reaches the ledger")
        XCTAssertTrue(view.contains("object: src.rawValue"), "the settle no longer says where she was felt from")
        let raw = try XCTUnwrap(LawSource.production("RecognitionMomentView.swift")).text
        XCTAssertTrue(raw.contains("RECOGNIZE_AUTOCLOSE"), "the headless close path is gone")
    }

    /// **Nothing grades him.** The ceremony's light is the same answer on the
    /// first day and the ten-thousandth: none of the Recognition files can
    /// reach how often she has been felt.
    func testTheCeremonyCannotKnowHowOftenSheHasBeenFelt() throws {
        let files = LawSource.production.filter { $0.path.hasPrefix("Views/Recognition/") }
        XCTAssertGreaterThanOrEqual(files.count, 3, "the Recognition folder went missing")
        for f in files {
            let body = String(f.lexed.masked)
            for id in ["serverRecognitionCount", "recognitionCount", "countByKp", "feltCount",
                       "visitCount", "HomeMemory", "ActivityLedger", "streak"] {
                XCTAssertFalse(body.contains(id), "\(f.path) reaches \(id)")
            }
        }
    }

    /// **The light is light.** No asset, no picture: the ceremony is drawn
    /// from gradients, shapes and rays.
    func testTheCeremonysLightIsNeverAFigure() throws {
        for name in ["RecognitionLight.swift", "RecognitionNature.swift", "RecognitionMomentView.swift"] {
            let body = try code(name)
            XCTAssertFalse(Rx.matches(#"\bImage\s*\("#, body), "\(name) draws an Image")
            XCTAssertFalse(Rx.matches(#"\bUIImage\s*\("#, body), "\(name) loads a picture")
        }
    }
}
