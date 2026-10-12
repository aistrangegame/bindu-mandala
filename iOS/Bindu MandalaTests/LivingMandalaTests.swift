import XCTest
import CoreGraphics
@testable import Bindu_Mandala

/// Wave 5 · the Portrait as the Living Mandala: the n-fold mirror, the year
/// that accretes with no empty slots, and his strokes kept as practice data.
@MainActor
final class LivingMandalaTests: XCTestCase {

    private lazy var dir: URL = FileManager.default.temporaryDirectory
        .appendingPathComponent("living-mandala-\(UUID().uuidString)", isDirectory: true)

    override func tearDown() {
        try? FileManager.default.removeItem(at: dir)
        super.tearDown()
    }

    // MARK: The mirror

    func testEachRingMirrorsByTheSeatsItHolds() {
        // 28 in the Bhūpura, 16 in the petal ring, 8, 14 in the triangles, 10,
        // 10, 12 (the Vāk ring), 3, and the Bindu is one.
        XCTAssertEqual((1...9).map(LivingMandala.folds(forRing:)), [28, 16, 8, 14, 10, 10, 12, 3, 1])
        XCTAssertEqual((1...9).map(LivingMandala.folds(forRing:)).reduce(0, +), KhadgamalaMap.total)
        XCTAssertEqual(LivingMandala.folds(forRing: 0), 1)
        XCTAssertEqual(LivingMandala.folds(forRing: 12), 1)
    }

    func testAStrokeIsMirroredRoundTheCentre() {
        let stroke = [CGPoint(x: 0.5, y: 0), CGPoint(x: 0.6, y: 0.1)]
        let copies = LivingMandala.copies(of: stroke, folds: 4)
        XCTAssertEqual(copies.count, 4)
        XCTAssertEqual(copies[0], stroke, "the first copy is his own stroke")
        // A quarter turn carries (0.5, 0) to (0, 0.5).
        XCTAssertEqual(copies[1][0].x, 0, accuracy: 1e-9)
        XCTAssertEqual(copies[1][0].y, 0.5, accuracy: 1e-9)
        // Every copy keeps the distance from the centre.
        for copy in copies {
            for (p, q) in zip(copy, stroke) {
                XCTAssertEqual(hypot(p.x, p.y), hypot(q.x, q.y), accuracy: 1e-9)
            }
        }
        XCTAssertEqual(LivingMandala.copies(of: stroke, folds: 16).count, 16)
        XCTAssertEqual(LivingMandala.copies(of: stroke, folds: 0).count, 1)
    }

    func testTheRingIsReadFromWhereTheStrokeBegins() {
        let half = LivingMandala.halfBase
        for (i, r) in LivingMandala.ringRadiiBase.enumerated() {
            XCTAssertEqual(LivingMandala.ring(atUnitRadius: r / half), i + 1, "on the circle of ring \(i + 1)")
        }
        XCTAssertEqual(LivingMandala.ring(atUnitRadius: 1.2), 1, "beyond the rim is the Bhūpura")
        XCTAssertEqual(LivingMandala.ring(of: CGPoint(x: 0, y: -123 / half)), 2)
    }

    func testAStrokeIsThinnedButEndsWhereTheFingerDid() {
        var points: [CGPoint] = []
        for i in 0..<2_000 { points.append(CGPoint(x: Double(i) * 0.0005, y: 0)) }
        let thin = LivingMandala.thinned(points)
        XCTAssertLessThanOrEqual(thin.count, 256)
        XCTAssertEqual(thin.first, points.first)
        XCTAssertEqual(thin.last, points.last)
        XCTAssertEqual(LivingMandala.thinned([]), [])
    }

    // MARK: The year

    func testTheYearHasABeadForEachDayPractisedAndNoSlotForTheRest() throws {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        func at(_ m: Int, _ d: Int, _ h: Int) -> Date {
            cal.date(from: DateComponents(year: 2026, month: m, day: d, hour: h))!
        }
        let instants = [at(3, 2, 9), at(3, 2, 21), at(7, 14, 6), at(10, 12, 8),
                        cal.date(from: DateComponents(year: 2025, month: 12, day: 31, hour: 9))!]
        let days = LivingMandala.practiceDays(instants, inYearOf: at(10, 12, 12), calendar: cal)
        XCTAssertEqual(days.count, 3, "two moments on one day are one bead; last year is not this year")
        XCTAssertEqual(days, days.sorted())

        // C-1348 — "gaps and spaces aren't meant to be filled but fully
        // inhabited." Wave 5 spread the beads evenly so no day was a slot, which
        // erased the gaps. Now each bead stands at its own day of the year, so
        // the days between stay as space: 2 March and 14 July are far apart on
        // the rim, and nothing sits between them.
        let a = days.map { LivingMandala.dayAngle($0, calendar: cal) }
        XCTAssertEqual(a[0], 2 * .pi * 60 / 365 - .pi / 2, accuracy: 1e-9, "2 March is not at its own day")
        XCTAssertEqual(a[1], 2 * .pi * 194 / 365 - .pi / 2, accuracy: 1e-9, "14 July is not at its own day")
        XCTAssertEqual(LivingMandala.dayAngle(at(1, 1, 9), calendar: cal), -.pi / 2, accuracy: 1e-12,
                       "the year does not begin at twelve o'clock")
        // Evenly spread, three beads would be a third of the circle apart; at
        // their own days they are not — the gap is kept.
        XCTAssertGreaterThan(abs((a[1] - a[0]) - 2 * .pi / 3), 0.2, "the gaps were filled")
        for x in a {
            XCTAssertGreaterThanOrEqual(x, -.pi / 2 - 1e-12)
            XCTAssertLessThan(x, 3 * .pi / 2)
        }
    }

    // MARK: His strokes are practice data

    func testStrokesSurviveARelaunch() {
        let store = PortraitStrokeStore(directory: dir)
        let session = store.begin(at: Date(timeIntervalSince1970: 1_800_000_000))
        let points = [CGPoint(x: 0, y: -0.7), CGPoint(x: 0.05, y: -0.72), CGPoint(x: 0.1, y: -0.75)]
        let stroke = store.add(points: points, at: Date(timeIntervalSince1970: 1_800_000_010))
        XCTAssertNotNil(stroke)
        XCTAssertEqual(stroke?.ring, 2, "begun at r ≈ 0.7 — the petal ring")
        let closed = store.end(at: Date(timeIntervalSince1970: 1_800_000_020))
        XCTAssertEqual(closed?.id, session)
        XCTAssertEqual(closed?.ring, 2)

        let again = PortraitStrokeStore(directory: dir)
        XCTAssertEqual(again.strokes, store.strokes)
        XCTAssertEqual(again.unledgered().map(\.id), [session])
    }

    func testATouchIsNotAStrokeAndAnEmptySittingLeavesNoTrace() {
        let store = PortraitStrokeStore(directory: dir)
        store.begin()
        XCTAssertNil(store.add(points: [CGPoint(x: 0.2, y: 0.2)]))
        XCTAssertNil(store.end())
        XCTAssertTrue(PortraitStrokeStore(directory: dir).archive.sessions.isEmpty)
    }

    func testASittingCutShortByAKillIsClosedWithItsStrokes() {
        let store = PortraitStrokeStore(directory: dir)
        store.begin(at: Date(timeIntervalSince1970: 1_800_000_000))
        store.add(points: [CGPoint(x: 0, y: 0.1), CGPoint(x: 0.02, y: 0.12)],
                  at: Date(timeIntervalSince1970: 1_800_000_030))
        // No `end` — the app is gone.
        let relaunched = PortraitStrokeStore(directory: dir)
        XCTAssertEqual(relaunched.strokes.count, 1, "the stroke was on disk the moment his finger lifted")
        XCTAssertEqual(relaunched.archive.sessions.first?.endedAt, Date(timeIntervalSince1970: 1_800_000_030))
        XCTAssertEqual(relaunched.unledgered().count, 1, "and it still reaches the ledger")
    }

    func testASittingIsHandedToTheLedgerOnce() {
        let store = PortraitStrokeStore(directory: dir)
        store.begin()
        store.add(points: [CGPoint(x: 0, y: 0.5), CGPoint(x: 0.1, y: 0.5)])
        let s = store.end()!
        store.markLedgered(s.id)
        XCTAssertTrue(store.unledgered().isEmpty)
        XCTAssertTrue(PortraitStrokeStore(directory: dir).unledgered().isEmpty, "the stamp is on disk too")
    }

    func testTheDominantRingLinksTheLedgerRow() {
        func s(_ ring: Int) -> PortraitStroke {
            PortraitStroke(id: UUID(), session: UUID(), ring: ring, points: [], drawnAt: .now)
        }
        XCTAssertEqual(PortraitStrokeStore.dominantRing(of: [s(3), s(5), s(5)]), 5)
        XCTAssertEqual(PortraitStrokeStore.dominantRing(of: [s(4), s(6)]), 4, "a tie goes to the first")
        XCTAssertEqual(PortraitStrokeStore.dominantRing(of: []), 9)
    }

    // MARK: The vault

    func testAnUnreadableFileIsSetAsideNotOverwritten() throws {
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = PracticeVault.fileURL(named: PortraitStrokeStore.fileName, in: dir)
        try Data("{ not json".utf8).write(to: url)
        let store = PortraitStrokeStore(directory: dir)
        XCTAssertTrue(store.strokes.isEmpty)
        let aside = try FileManager.default.contentsOfDirectory(atPath: dir.path)
            .filter { $0.hasPrefix(PortraitStrokeStore.fileName + ".unreadable-") }
        XCTAssertEqual(aside.count, 1, "the unreadable copy is kept beside the store")
    }

    // MARK: The stillness of the gaze

    func testStillnessGathersAndLoosens() {
        var v = 0.0
        for _ in 0..<200 { v = StillnessSensor.next(v, motion: 0.001, dt: 0.05) }
        XCTAssertEqual(v, 1, "ten seconds of stillness steadies the field")
        v = StillnessSensor.next(v, motion: 0.5, dt: 0.2)
        XCTAssertLessThan(v, 1)
        XCTAssertEqual(StillnessSensor.next(0, motion: 1, dt: 1), 0, "never below nothing")
    }
}
