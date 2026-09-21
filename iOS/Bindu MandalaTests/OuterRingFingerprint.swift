import Foundation
import CoreGraphics
import XCTest
@testable import Bindu_Mandala

// MARK: - The outer climb, measured — rings 3 to 9
//
// `homes-verify.js`'s `fingerprint(chamber, t)` and `divergence(a, b)`, as
// ``CrossingRoomTests`` first ported them and ``RingOneFingerprint`` carried
// them into a ring of three families: Design's own walks a built chamber's graph
// and writes **each object's position, scale and opacity** to two decimals, and
// `divergence` is the fraction of those components that differ, with a bar of a
// tenth.
//
// It is here, ring-parameterised, because the outer climb is **six archetypes
// built by six passes**, and every one of them has to be asked the same question
// by the same instrument: *could this room belong to any other Śakti?* A suite
// that cut its own print to fit its own ring would be restating what that ring
// proved rather than testing it — which is exactly why Ring 2's copy and Ring 1's
// were each left where they are, with their own slot counts and their own
// measured evidence.
//
// What is read, and why each register earns its place, is ``CrossingRoomTests``'
// reasoning unchanged: the room's four surfaces, where in the frame her mark
// falls, every mark on the surface her body puts her on in the order the room
// made them, and the stone itself on a grid — because under the renderer ruling a
// room has no objects to read, it has actions on its own material, and those
// carry exactly what Design writes down plus the verb an object could not have
// said.
enum OuterRingFingerprint {

    /// Design's own bar: more than a tenth of the components differ.
    static let threshold: Double = 0.1

    /// Seven moments of one stay: the opening, the eye settling, the first
    /// adaptation, the hold, the turn, and two points past it.
    static let sampleTimes: [TimeInterval] = [0, 24, HomeMemory.firstAdaptation, 140,
                                              HomeMemory.holdEnd, 287,
                                              HomeMemory.secondAdaptationEnd]

    /// **A grid over the stone the room actually worked, five by five.**
    ///
    /// Ring 2 reads its grid over the whole surface, and that is right for a ring
    /// whose fourteen marks are spread across a working face. It is wrong for the
    /// outer climb: from ring 4 outward Design's figures are halls, ``Figure``
    /// brings them into a picture 1.3 units across, and on a floor four
    /// body-heights wide the whole figure is a twentieth of the surface. Twenty-two
    /// of twenty-five fixed probes then land on undisturbed stone and read
    /// identically in every room of the ring — which is the dilution
    /// ``refusesDilution(_:)`` exists to catch, arriving inside the measure itself.
    ///
    /// So the grid spans **this room's own marks at this moment**, expanded by the
    /// widest of them so the falling-off edges are read too. Design's own
    /// fingerprint reads each object's own numbers rather than fixed points in the
    /// room, and this is the same discipline for a room whose objects are
    /// deformations.
    static func probes(over actions: [SurfaceAction]) -> [SurfaceCoordinate] {
        let live = actions.filter { $0.reach > 0 && $0.depth > 0 }
        guard let first = live.first else {
            return (0..<5).flatMap { u in
                (0..<5).map { v in
                    SurfaceCoordinate(u: (Double(u) + 0.5) / 5, v: (Double(v) + 0.5) / 5)
                }
            }
        }
        var lowU = first.at.u, highU = first.at.u
        var lowV = first.at.v, highV = first.at.v
        var widest = first.reach
        for action in live {
            lowU = Swift.min(lowU, action.at.u); highU = Swift.max(highU, action.at.u)
            lowV = Swift.min(lowV, action.at.v); highV = Swift.max(highV, action.at.v)
            widest = Swift.max(widest, action.reach)
        }
        lowU -= widest; highU += widest
        lowV -= widest; highV += widest
        return (0..<5).flatMap { u -> [SurfaceCoordinate] in
            (0..<5).map { v in
                SurfaceCoordinate(u: lowU + (highU - lowU) * (Double(u) + 0.5) / 5,
                                  v: lowV + (highV - lowV) * (Double(v) + 0.5) / 5)
            }
        }
    }

    /// How many of the room's marks are written down, mechanism first and then
    /// her attribute's, and padded where a room has fewer.
    ///
    /// **Sixteen, and it is chosen against the six builders rather than against
    /// one of them.** Design stands a fixed count of parts in every outer room:
    /// eight petals in BODILESS, fourteen shells in COSMIC, twelve gifts in
    /// GIVING, ten in REVEALING, her mode's two-to-nine nodes in SOUNDING, three
    /// corners in SOURCING — plus the one mark a reversal makes. Sixteen is past
    /// five of those and exactly at the sixth, so no room's marks are truncated
    /// and no room is mostly padding. Padding is the dilution the Ring 2 suite
    /// names: enough silent components drag every real difference under the tenth
    /// while the check goes on saying green, and ``refusesDilution(_:)`` is the
    /// guard against it. A ring whose builder stands fewer parts passes its own
    /// number rather than carrying six empty slots.
    static let slots = 16

    private static func f(_ x: Double) -> String { String(format: "%.2f", x) }

    /// One action, as Design writes one object: where it is, how large, how
    /// bright — and what it is doing, which an object could not have said.
    private static func say(_ action: SurfaceAction?, _ slot: Int) -> String {
        guard let action else { return "a|\(slot)|-" }
        return "a|\(slot)|" + action.verb.rawValue + "|" + f(action.at.u) + "|" + f(action.at.v)
            + "|" + f(action.reach) + "|" + f(action.depth) + "|" + f(action.glow)
    }

    static func at(_ scene: RoomScene, _ t: TimeInterval, slots: Int = slots) -> [String] {
        var out: [String] = []
        scene.pose(at: t)

        for surface in RoomSurfaceKind.allCases {
            out.append("s|" + surface.rawValue + "|" + f(scene.stood[surface] ?? 0))
        }

        let placement = RoomUnits.placement(bodyAltitude: scene.room.bodyAltitude, chamberTime: t)
        out.append("p|surface|" + placement.surface.rawValue)
        out.append("p|height|" + f(placement.height))
        out.append("p|depth|" + f(placement.depth))
        out.append("p|footprint|" + f(placement.footprint))
        out.append("p|pitch|" + f(RoomUnits.eyePitch(toward: placement)))

        let shaped = scene.shaped(at: t)
        let actions = shaped[scene.receivingSurface]?.actions ?? []
        for slot in 0..<Swift.max(0, slots) {
            out.append(say(slot < actions.count ? actions[slot] : nil, slot))
        }
        // How many marks the room made at all — a fixed window cannot see the
        // difference between a room of three and a room of fourteen on its own.
        out.append("n|" + String(min(999, actions.count)))

        if let material = shaped[scene.receivingSurface] {
            for probe in probes(over: actions) {
                out.append("m|" + f(material.relief(at: probe) - material.grain(at: probe))
                           + "|" + f(material.emission(at: probe)))
            }
        } else {
            (0..<25).forEach { _ in out.append("m|-") }
        }
        return out
    }

    static func of(_ room: HomeRoom, slots: Int = slots) -> [String] {
        let scene = RoomScene(room: room)
        return sampleTimes.flatMap { at(scene, $0, slots: slots) }
    }

    /// `homes-verify.js`'s `divergence`, ported exactly.
    static func divergence(_ a: [String], _ b: [String]) -> Double {
        let n = min(a.count, b.count)
        guard n > 0 else { return 0 }
        var differing = 0
        for i in 0..<n where a[i] != b[i] { differing += 1 }
        return Double(differing) / Double(n)
    }

    // MARK: - One seat of the outer climb

    struct Seat {
        let position: Int
        let ring: Int
        let archetype: HomeArchetype?
        /// `false` for a seat Design authored by hand, which Ruling 10 exempts
        /// from the grammar-only proof.
        let grammared: Bool
        let print: [String]
    }

    /// One whole ring of the outer climb, fingerprinted, in position order.
    static func ring(_ ring: Int,
                     _ rooms: [(row: HomesCorpus.Row, room: HomeRoom)],
                     slots: Int = slots) -> [Seat] {
        rooms.filter { $0.row.ring == ring }
            .sorted { $0.row.position < $1.row.position }
            .map { entry in
                var grammared = false
                var archetype: HomeArchetype?
                if case .grammar(let reading) = entry.room.kind {
                    grammared = true
                    archetype = reading.archetype
                }
                return Seat(position: entry.row.position,
                            ring: entry.row.ring,
                            archetype: archetype,
                            grammared: grammared,
                            print: of(entry.room, slots: slots))
            }
    }

    /// **The measure cannot be passed by dilution.**
    ///
    /// A print padded with components that read the same in every room of a ring
    /// drags every real difference toward the threshold while the divergence goes
    /// on saying green. Ring 2's suite named it; this is the guard, and it is
    /// asked of the print itself rather than of any pair: fewer than half the
    /// components may be constant across the ring.
    static func refusesDilution(_ seats: [Seat]) -> (constant: Int, total: Int) {
        guard let first = seats.first else { return (0, 0) }
        let total = first.print.count
        var constant = 0
        for index in 0..<total where seats.allSatisfy({ index < $0.print.count
                                                        && $0.print[index] == first.print[index] }) {
            constant += 1
        }
        return (constant, total)
    }
}

// MARK: - Reading an outer room without a renderer

enum OuterRingStage {

    /// The room at one instant, as a mechanism is handed it.
    static func stage(room: HomeRoom, at t: TimeInterval) -> RoomStage {
        var materials: [RoomSurfaceKind: RoomMaterial] = [:]
        for kind in RoomSurfaceKind.allCases {
            materials[kind] = RoomMaterial(surface: kind, seed: room.position)
        }
        return RoomStage(placement: RoomUnits.placement(bodyAltitude: room.bodyAltitude,
                                                        chamberTime: t),
                         settling: HomeGrammar.settling(chamberTime: t),
                         deep: HomeGrammar.deepProgress(chamberTime: t),
                         materials: materials)
    }

    /// Every mark a room's **own mechanism** makes on the surface her body puts
    /// her on, at one instant.
    ///
    /// Her attribute is deliberately not in this reading. Design adds the
    /// attribute to whatever room she has — *"the room is the mechanism; the
    /// attribute is the one thing acting inside it"* — so a check about what the
    /// **room** does reads the room, and a check about what her attribute does
    /// reads ``RoomInscription``.
    static func marks(room: HomeRoom, at t: TimeInterval) -> [SurfaceAction] {
        guard let mechanism = RoomMechanisms.forRoom(room) else { return [] }
        let stage = stage(room: room, at: t)
        return mechanism.actions(at: t, stage: stage)[stage.placement.surface] ?? []
    }

    /// Where the room's own surfaces stand at one instant.
    static func stations(room: HomeRoom, at t: TimeInterval) -> [RoomSurfaceKind: Double] {
        guard let mechanism = RoomMechanisms.forRoom(room) else { return [:] }
        return mechanism.stations(at: t, stage: stage(room: room, at: t))
    }
}

// MARK: - The legibility register, for the outer climb

/// Design's first verification check — *neither black nor blown out at both
/// adaptations* — driven off an offscreen capture, because the renderer ruling
/// recorded that SwiftUI cannot screenshot a `CAMetalLayer` and the register has
/// to go around it.
///
/// Shared for the same reason the fingerprint is: six passes, one ruler.
enum OuterRingCapture {

    /// Big enough that a mark is several pixels across, small enough that a whole
    /// ring of captures is seconds rather than minutes.
    static let size = CGSize(width: 320, height: 640)

    /// The two moments a room has to be legible at.
    static let moments: [(String, TimeInterval)] = [
        ("the first adaptation", HomeMemory.firstAdaptation),
        ("past the second", HomeMemory.secondAdaptationEnd),
    ]

    /// `topFraction` reads only the top of the frame, for the surfaces a
    /// whole-frame reading cannot see past the floor.
    static func luminance(of image: CGImage,
                          topFraction: Double = 1) -> (min: Double, max: Double, mean: Double) {
        let side = 64
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        guard let context = CGContext(data: &pixels, width: side, height: side,
                                      bitsPerComponent: 8, bytesPerRow: side * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return (0, 0, 0) }
        context.draw(image, in: CGRect(x: 0, y: 0, width: side, height: side))

        // `CGContext` draws bottom-up, so the top of the frame is the end of the
        // buffer.
        let rows = Swift.max(1, Int(Double(side) * Swift.min(1, Swift.max(0, topFraction))))
        var low = 1.0, high = 0.0, total = 0.0
        var counted = 0
        for index in stride(from: (side - rows) * side * 4, to: pixels.count, by: 4) {
            let luma = (0.2126 * Double(pixels[index])
                        + 0.7152 * Double(pixels[index + 1])
                        + 0.0722 * Double(pixels[index + 2])) / 255
            low = Swift.min(low, luma)
            high = Swift.max(high, luma)
            total += luma
            counted += 1
        }
        return (low, high, counted > 0 ? total / Double(counted) : 0)
    }

    /// Design's own three floors, asserted at both adaptations: not black, not
    /// blown out, and not flat — a flat render means either nothing is lit or the
    /// material has no relief for the light to fall across, which is the defect
    /// Design's verification pass hit with Ring 1's Mātṛkās.
    /// **`@MainActor`, and it is not a formality.** `SCNRenderer.snapshot` renders
    /// through the main thread's own queue: called from an XCTest case that is not
    /// main-actor, it does not fail — it **blocks forever**, with the test process
    /// sitting at nought per cent and nothing in the log. Phase 3.6 lost a run to
    /// exactly that, and `RoomCaptureTests` has been `@MainActor` since Phase 3.1
    /// for the same reason. A suite that calls this is main-actor too, which is
    /// what the annotation is for: the compiler says so instead of the clock.
    @MainActor
    static func assertLegible(_ room: HomeRoom, called what: String,
                              file: StaticString = #filePath, line: UInt = #line) {
        let scene = RoomScene(room: room)
        for (when, t) in moments {
            guard let image = scene.capture(size: size, atSceneTime: t) else {
                return XCTFail("\(what) could not be rendered offscreen — no Metal device?",
                               file: file, line: line)
            }
            let spread = luminance(of: image)
            print("ROOM_CAPTURE {\"room\":\"\(what)\",\"when\":\"\(when)\","
                  + String(format: "\"meanLuma\":%.4f,\"minLuma\":%.4f,\"maxLuma\":%.4f}",
                           spread.mean, spread.min, spread.max))

            XCTAssertGreaterThan(spread.mean, 0.01,
                                 "\(what), \(when): the room rendered black",
                                 file: file, line: line)
            XCTAssertLessThan(spread.mean, 0.9,
                              "\(what), \(when): the room blew out to white",
                              file: file, line: line)
            XCTAssertGreaterThan(spread.max - spread.min, 0.02,
                                 """
                                 \(what), \(when): the render is flat. Either nothing is lit, or \
                                 the material has no relief for the light to fall across.
                                 """,
                                 file: file, line: line)
        }
    }
}
