import XCTest
import SwiftUI
@testable import Bindu_Mandala

/// The camera is pure arithmetic — the whole navigation model, asserted off-device.
final class MandalaCameraTests: XCTestCase {

    private let size = CGSize(width: 390, height: 844)
    private func approx(_ a: CGFloat, _ b: CGFloat, _ tol: CGFloat = 0.01) -> Bool { abs(a - b) < tol }

    // MARK: fit

    func testFittedCentersTheBinduAndScalesToViewport() {
        let cam = MandalaCamera.fitted(in: size)
        let bindu = cam.binduScreen()
        XCTAssertTrue(approx(bindu.x, size.width / 2), "bindu x centered")
        XCTAssertTrue(approx(bindu.y, size.height / 2), "bindu y centered")
        XCTAssertEqual(cam.scale, min(size.width, size.height) / MandalaWorld.box * 0.94, accuracy: 0.0001)
    }

    // MARK: coordinate round-trip

    func testScreenWorldRoundTrip() {
        let cam = MandalaCamera(scale: 2.4, tx: -120, ty: 60)
        for w in [CGPoint(x: 0, y: 0), CGPoint(x: 120, y: -80), CGPoint(x: -306, y: 306)] {
            let back = cam.world(forScreen: cam.screen(for: w))
            XCTAssertTrue(approx(back.x, w.x) && approx(back.y, w.y), "round trip \(w) → \(back)")
        }
    }

    // MARK: zoom-at anchors the point under the finger

    func testZoomAtKeepsAnchorPointFixed() {
        let cam = MandalaCamera.fitted(in: size)
        let anchor = CGPoint(x: 210, y: 300)
        let worldBefore = cam.world(forScreen: anchor)
        let zoomed = cam.zoomed(at: anchor, factor: 1.7)
        let worldAfter = zoomed.world(forScreen: anchor)
        XCTAssertTrue(approx(worldBefore.x, worldAfter.x, 0.05) && approx(worldBefore.y, worldAfter.y, 0.05),
                      "the world point under the finger must not move")
        XCTAssertEqual(zoomed.scale, cam.scale * 1.7, accuracy: 0.0001)
    }

    // MARK: fly-to-seat frames the seat above center at scale 3

    func testFlyTargetFramesSeatAboveCenter() {
        let seat = CGPoint(x: 145, y: -80)
        let cam = MandalaCamera.flyTarget(to: seat, in: size)
        XCTAssertEqual(cam.scale, 3.0, accuracy: 0.0001)
        let onScreen = cam.screen(for: seat)
        XCTAssertTrue(approx(onScreen.x, size.width / 2), "seat centered horizontally")
        XCTAssertTrue(approx(onScreen.y, size.height * 0.36), "seat sits above center")
    }

    // MARK: descent frames the bindu and reaches deep scale

    func testDescentTargetFallsIntoTheBindu() {
        let cam = MandalaCamera.descentTarget(in: size)
        XCTAssertEqual(cam.scale, 5.4, accuracy: 0.0001)
        let bindu = cam.binduScreen()
        XCTAssertTrue(approx(bindu.x, size.width / 2))
        XCTAssertTrue(approx(bindu.y, size.height * 0.44))
    }

    // MARK: semantic tiers

    func testTierThresholds() {
        XCTAssertEqual(MandalaCamera(scale: 0.5, tx: 0, ty: 0).tier, 0)
        XCTAssertEqual(MandalaCamera(scale: 1.14, tx: 0, ty: 0).tier, 0)
        XCTAssertEqual(MandalaCamera(scale: 1.15, tx: 0, ty: 0).tier, 1)
        XCTAssertEqual(MandalaCamera(scale: 2.29, tx: 0, ty: 0).tier, 1)
        XCTAssertEqual(MandalaCamera(scale: 2.3, tx: 0, ty: 0).tier, 2)
    }

    // MARK: clamp

    func testScaleClamps() {
        XCTAssertEqual(MandalaCamera.clamp(0.01), MandalaCamera.minScale)
        XCTAssertEqual(MandalaCamera.clamp(99), MandalaCamera.maxScale)
        let z = MandalaCamera(scale: 5.4, tx: 0, ty: 0).zoomed(at: .zero, factor: 4)
        XCTAssertEqual(z.scale, MandalaCamera.maxScale, "zoom cannot exceed max")
    }

    // MARK: inward ring reach is monotonic with scale

    func testEnteredRingDeepensAsYouZoomIn() {
        let shallow = MandalaCamera.fitted(in: size).enteredRing(in: size)
        let deep = MandalaCamera(scale: 5.0, tx: 0, ty: 0).enteredRing(in: size)
        XCTAssertGreaterThanOrEqual(deep, shallow)
        XCTAssertGreaterThanOrEqual(deep, 1, "at deep zoom the viewport is inside at least ring 1")
    }

    // MARK: Animatable interpolates all three components

    func testAnimatableDataRoundTrips() {
        var cam = MandalaCamera(scale: 1, tx: 2, ty: 3)
        cam.animatableData = MandalaCamera(scale: 4, tx: 5, ty: 6).animatableData
        XCTAssertEqual(cam, MandalaCamera(scale: 4, tx: 5, ty: 6))
    }
}
