import Foundation
import CoreGraphics
@testable import Bindu_Mandala

// MARK: - The geometric fingerprint, for a ring of three families
//
// `homes-verify.js`'s `fingerprint(chamber, t)` and `divergence(a, b)`, as
// ``CrossingRoomTests`` ports them: Design's own walks a built chamber's graph
// and writes **each object's position, scale and opacity** to two decimals, and
// `divergence` is the fraction of those components that differ, with a bar of a
// tenth.
//
// It is here rather than beside one suite because Ring 1 is **three families and
// five authored rooms**, and each of them has to be asked the same question by
// the same instrument: *could this room belong to any other Śakti?* Ring 2's own
// copy stays where it is — its slot counts are the crossing's fourteen marks and
// its numbers are the ring's measured evidence, and re-cutting them to fit a
// different ring would quietly restate what that ring proved.
//
// What is read, and why each register earns its place, is ``CrossingRoomTests``'
// reasoning unchanged: the room's four surfaces, where in the frame her mark
// falls, every mark on the surface her body puts her on in the order the room
// made them, and the stone itself on a grid — because under the renderer ruling
// a room has no objects to read, it has actions on its own material, and those
// carry exactly what Design writes down plus the verb an object could not have
// said.
enum RingOneFingerprint {

    /// Design's own bar: more than a tenth of the components differ.
    static let threshold: Double = 0.1

    /// Seven moments of one stay: the opening, the eye settling, the first
    /// adaptation, the hold, the turn, and two points past it.
    static let sampleTimes: [TimeInterval] = [0, 24, HomeMemory.firstAdaptation, 140,
                                              HomeMemory.holdEnd, 287,
                                              HomeMemory.secondAdaptationEnd]

    /// A grid over the surface, five by five.
    static let probes: [SurfaceCoordinate] = (0..<5).flatMap { u in
        (0..<5).map { v in
            SurfaceCoordinate(u: (Double(u) + 0.5) / 5, v: (Double(v) + 0.5) / 5)
        }
    }

    /// How many of the room's marks are written down, mechanism first and then
    /// her attribute's, and padded where a room has fewer.
    ///
    /// **Fixed, and deliberately smaller than the largest room.** Ring 1's rooms
    /// carry between one mark (Aṇimā's point) and a hundred and seventy (Mahimā's
    /// procession), and a window wide enough for the largest would be mostly
    /// padding in the other twenty-seven — which is the dilution the Ring 2 suite
    /// already names: enough silent components drag every real difference under
    /// the tenth while the check goes on saying green. Forty-eight is past the
    /// mark count of two thirds of the ring and well inside the rest, so every
    /// slot is carrying something in some room.
    static let slots = 48

    private static func f(_ x: Double) -> String { String(format: "%.2f", x) }

    /// One action, as Design writes one object: where it is, how large, how
    /// bright — and what it is doing, which an object could not have said.
    private static func say(_ action: SurfaceAction?, _ slot: Int) -> String {
        guard let action else { return "a|\(slot)|-" }
        return "a|\(slot)|" + action.verb.rawValue + "|" + f(action.at.u) + "|" + f(action.at.v)
            + "|" + f(action.reach) + "|" + f(action.depth) + "|" + f(action.glow)
    }

    static func at(_ scene: RoomScene, _ t: TimeInterval) -> [String] {
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
        for slot in 0..<slots {
            out.append(say(slot < actions.count ? actions[slot] : nil, slot))
        }
        // How many marks the room made at all — a room that carries a hundred and
        // seventy and one that carries six are not the same room, and a fixed
        // window cannot see the difference on its own.
        out.append("n|" + String(min(999, actions.count)))

        if let material = shaped[scene.receivingSurface] {
            for probe in probes {
                out.append("m|" + f(material.relief(at: probe) - material.grain(at: probe))
                           + "|" + f(material.emission(at: probe)))
            }
        } else {
            probes.forEach { _ in out.append("m|-") }
        }
        return out
    }

    static func of(_ room: HomeRoom) -> [String] {
        let scene = RoomScene(room: room)
        return sampleTimes.flatMap { at(scene, $0) }
    }

    /// `homes-verify.js`'s `divergence`, ported exactly.
    static func divergence(_ a: [String], _ b: [String]) -> Double {
        let n = min(a.count, b.count)
        guard n > 0 else { return 0 }
        var differing = 0
        for i in 0..<n where a[i] != b[i] { differing += 1 }
        return Double(differing) / Double(n)
    }

    // MARK: - The three families, measured against one another
    //
    // Design's `divergence` asks *could this room belong to any other Śakti?*
    // Ring 1 needs a second question that no other ring does, because it is the
    // only ring built out of **three families**: *could this room belong to
    // another family?* A Siddhi is a power exercised, a Mātṛkā is a sound that
    // makes, a Mudrā is a closure that seals — and if two sisters in one family
    // differed as much from each other as the families do from one another, the
    // brief's three passes would have produced one ring of twenty-eight rooms
    // wearing three names.
    //
    // So the measure is a comparison of two means: how far apart two rooms of one
    // family stand, against how far apart two rooms of different families stand.
    // It is asked of the rooms **the grammar speaks for**, because the five
    // authored rooms of Ring 1 are authored — Ruling 10 exempts them from the
    // grammar-only proof, and a hand-built room is an outlier in whichever family
    // it sits in, by construction rather than by defect. Their numbers are
    // printed beside the assertion rather than folded into it.

    /// One Ring 1 seat, with everything the family measure needs to say what it
    /// found.
    struct Seat {
        let position: Int
        let family: HomeArchetype
        /// `false` for the five Design authored by hand — 1, 2, 3, 4 and 6 — and
        /// the two it named and never finished, 27 and 28.
        let grammared: Bool
        let print: [String]
    }

    /// Which of Ring 1's three families a seat stands in. Position is the only
    /// key, exactly as it is in ``HomeGrammar/ringOneFamily(position:)``.
    static func family(atPosition position: Int) -> HomeArchetype {
        HomeGrammar.ringOneFamily(position: position)
    }

    /// The whole of Ring 1, fingerprinted.
    static func ringOne(_ rooms: [(row: HomesCorpus.Row, room: HomeRoom)]) -> [Seat] {
        rooms.filter { (1...28).contains($0.row.position) }
            .sorted { $0.row.position < $1.row.position }
            .map { entry in
                var grammared = false
                if case .grammar = entry.room.kind { grammared = true }
                return Seat(position: entry.row.position,
                            family: family(atPosition: entry.row.position),
                            grammared: grammared,
                            print: of(entry.room))
            }
    }

    /// The mean divergence over every pair of seats drawn from `a` and `b` —
    /// within one family when they are the same list, and between two families
    /// when they are not.
    static func meanDivergence(_ a: [Seat], _ b: [Seat]) -> Double {
        var total = 0.0, pairs = 0
        for (index, one) in a.enumerated() {
            for other in (a == b ? Array(b[(index + 1)...]) : b) {
                guard one.position != other.position else { continue }
                total += divergence(one.print, other.print)
                pairs += 1
            }
        }
        return pairs > 0 ? total / Double(pairs) : 0
    }
}

extension RingOneFingerprint.Seat: Equatable {
    static func == (a: Self, b: Self) -> Bool { a.position == b.position }
}

// MARK: - Reading a Ring 1 room without a renderer

enum RingOneStage {

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

    /// Every mark a room's own mechanism makes on the surface her body puts her
    /// on, at one instant.
    static func marks(room: HomeRoom, at t: TimeInterval) -> [SurfaceAction] {
        guard let mechanism = RoomMechanisms.forRoom(room) else { return [] }
        let stage = stage(room: room, at: t)
        return mechanism.actions(at: t, stage: stage)[stage.placement.surface] ?? []
    }
}
