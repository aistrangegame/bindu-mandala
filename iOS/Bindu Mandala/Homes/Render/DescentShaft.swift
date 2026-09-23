import Foundation
import SceneKit
import UIKit

// MARK: - The shaft: her mark's own rim, repeating inward
//
// ``HomeDescent`` is the descent as arithmetic; this is the only thing that
// draws it, and it draws exactly one kind of thing: a closed rim of the room's
// own material, forty-six times, narrowing away from the walker.
//
// ─────────────────────────────────────────────────────────────────────────────
// NOT ONE SOLID, AND THAT IS ASSERTED RATHER THAN INTENDED
// ─────────────────────────────────────────────────────────────────────────────
//
// Every rim is a line loop — `SCNGeometryElement(primitiveType: .line)` — so
// there is no face anywhere in the descent for a light to sit on and nothing
// that can read as an object in the air. ``solids`` counts the meshes and
// answers zero for every one of the 102, which is the binding condition stated
// as a number, exactly as ``RoomScene/solidsInHerLayer`` states it for the room.
//
// It also means the whole descent costs one geometry per rim, built once, and
// every station is a **node transform**: a turn, a throw off the axis, an orbit,
// a swell, a closing. Nothing is rebuilt per frame, which is what lets the
// reduce-motion path pose the shaft once and draw it once, the way the room is.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE RIM IS HER OWN
// ─────────────────────────────────────────────────────────────────────────────
//
// A perfect circle turned about its own axis is a circle, so the first station
// would have nothing to show. The rim is therefore not a circle: it carries as
// many lobes as her attribute has moving parts, read off
// ``HomeAttributeActor/state(atChamberTime:)`` rather than chosen — the mark in
// her room is made by those parts, and the bore into it has their shape. Three
// is the floor, because two lobes is a lens and one is an egg, and neither reads
// as a rim when it turns.

/// The descent, built into one room.
///
/// Held by ``RoomScene``, which is the only thing that installs it: the shaft
/// stands in the **building** layer, because it is the room's own material and
/// not her mechanism, and `RoomSceneTests`' binding check would be right to fail
/// if it stood anywhere else.
final class DescentShaft {

    /// How many segments a rim is drawn with. Enough that a lobe is a curve.
    static let segments = 48

    /// How far a lobe stands off the rim, as a fraction of its radius.
    static let lobeDepth: Double = 0.085

    /// The fewest lobes a rim may carry — see the header.
    static let fewestLobes = 3

    /// The root of the whole descent, handed to the scene.
    let node = SCNNode()

    /// The forty-six rims, outermost first.
    private var rims: [SCNNode] = []
    /// The rims that carry her roots, at the etymology's station.
    private var rootRims: [SCNNode] = []

    private let bodyAltitude: Double
    private let roots: Int
    private let material: SCNMaterial

    /// Where the eye stood when the shaft was last put at a depth. Read by the
    /// tests, and by nothing in the app.
    private(set) var depth: Double = RoomUnits.eyeZ
    /// How many times the shaft has been put at a depth — the reduce-motion
    /// proof for the descent, the same shape ``RoomDriver/posesApplied`` has.
    private(set) var posesApplied = 0

    init(room: HomeRoom, roots: Int) {
        self.bodyAltitude = room.bodyAltitude
        self.roots = HomeDescent.rootCount(roots)

        let lobes = Self.lobes(of: room)
        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = RoomLightRig.colour(room.gem.bright)
        material.blendMode = .add
        material.writesToDepthBuffer = false
        material.isDoubleSided = true
        material.name = "descent"
        self.material = material

        node.name = "descent"
        // Level, at the height her mark stands at: the shaft's axis is her own
        // altitude and the eye comes to it. See ``HomeDescent/height(atTravel:bodyAltitude:)``.
        node.position = SCNVector3(0, Float(RoomUnits.height(forBodyAltitude: room.bodyAltitude)), 0)

        let geometry = Self.rim(lobes: lobes)
        geometry.materials = [material]

        for i in 0..<HomeDescent.rungs {
            let rim = SCNNode(geometry: geometry)
            rim.name = "rim"
            let radius = Float(HomeDescent.rungRadius(i))
            rim.scale = SCNVector3(radius, radius, radius)
            rim.position = SCNVector3(0, 0, Float(HomeDescent.rungDepth(i)))
            rim.castsShadow = false
            rims.append(rim)
            node.addChildNode(rim)
        }

        // Her roots: one rim each, standing where the shaft's own rims stand at
        // the etymology's station, and orbiting inward until they coincide.
        let etymologyDepth = HomeDescent.stationDepths[DescentStation.etymology.rawValue]
        for _ in 0..<self.roots {
            let rim = SCNNode(geometry: geometry)
            rim.name = "root"
            rim.scale = SCNVector3(0.5, 0.5, 0.5)
            rim.position = SCNVector3(0, 0, Float(etymologyDepth))
            rim.castsShadow = false
            rootRims.append(rim)
            node.addChildNode(rim)
        }

        put(at: RoomUnits.eyeZ, worldTime: 0)
    }

    // MARK: - Her rim

    /// How many lobes her rim carries: one per moving part of her attribute,
    /// never fewer than ``fewestLobes``. Read off her own form.
    static func lobes(of room: HomeRoom) -> Int {
        let parts = room.attribute?.state(atChamberTime: 0).parts.count ?? 0
        return max(fewestLobes, parts)
    }

    /// One rim, as a closed line loop of unit radius.
    static func rim(lobes: Int) -> SCNGeometry {
        var points = [SCNVector3]()
        points.reserveCapacity(segments)
        for i in 0..<segments {
            let a = Double(i) / Double(segments) * .pi * 2
            let r = 1 + cos(a * Double(lobes)) * lobeDepth
            points.append(SCNVector3(Float(cos(a) * r), Float(sin(a) * r), 0))
        }
        var indices = [Int32]()
        indices.reserveCapacity(segments * 2)
        for i in 0..<segments {
            indices.append(Int32(i))
            indices.append(Int32((i + 1) % segments))
        }
        return SCNGeometry(
            sources: [SCNGeometrySource(vertices: points)],
            elements: [SCNGeometryElement(indices: indices, primitiveType: .line)])
    }

    // MARK: - Putting the shaft at a depth

    /// Put the whole shaft where the eye now stands.
    ///
    /// Pure in everything but its writes, like ``RoomScene/pose(at:)``: the same
    /// depth and the same world time always produce the same shaft.
    ///
    /// `worldTime` is the āvaraṇa's own clock rather than her chamber clock —
    /// the orbits and the breath are the air of the place he is descending
    /// through, and they do not wait for him, exactly as the weather does not
    /// wait at her threshold.
    func put(at depth: Double, worldTime: TimeInterval) {
        self.depth = depth
        posesApplied += 1

        let turning = HomeDescent.presence(of: .tattva, eyeDepth: depth)
        let bodily = HomeDescent.presence(of: .location, eyeDepth: depth)
        let swelling = HomeDescent.presence(of: .quality, eyeDepth: depth)
        let closing = HomeDescent.floorClosing(eyeDepth: depth)
        let swell = HomeDescent.swell(at: worldTime)

        for (i, rim) in rims.enumerated() {
            let z = HomeDescent.rungDepth(i)
            rim.opacity = CGFloat(HomeDescent.rungLight(i, eyeDepth: depth)
                                  * (1 - HomeDescent.floorDimming * closing))

            // · her tattva — the rims turn.
            rim.eulerAngles = SCNVector3(0, 0, Float(worldTime * HomeDescent.turnRate * turning))

            // · her body — the shaft is thrown off its axis everywhere but at
            //   her own register, and breathes on Design's own period.
            let breath = 0.5 + 0.5 * sin(worldTime * HomeDescent.registerBreathRate
                                         + Double(i) * HomeDescent.registerBreathPhase)
            let thrown = HomeDescent.registerThrow(rungAt: z, bodyAltitude: bodyAltitude)
                * bodily * breath
            rim.position = SCNVector3(0, Float(thrown), Float(z))

            // · her quality — the rim swells and compacts, and says nothing else.
            // · the floor — and then the shaft closes to its own centre.
            let radius = HomeDescent.rungRadius(i) * (1 + swell * swelling)
                * (1 - (1 - HomeDescent.floorRadius) * closing)
            rim.scale = SCNVector3(Float(radius), Float(radius), Float(radius))
        }

        // · her etymology — the roots orbit inward until they are one word.
        let drawn = HomeDescent.rootDraw(at: worldTime)
        let etymology = HomeDescent.presence(of: .etymology, eyeDepth: depth)
        let etymologyDepth = HomeDescent.stationDepths[DescentStation.etymology.rawValue]
        for (k, rim) in rootRims.enumerated() {
            let offset = HomeDescent.rootOffset(k, of: rootRims.count, at: worldTime)
            rim.position = SCNVector3(Float(offset.x), Float(offset.y), Float(etymologyDepth))
            // They are a little brighter the more they are one, which is
            // Design's own `pow(draw, 3)` arriving on the rims rather than on a
            // sprite that is not there.
            rim.opacity = CGFloat(etymology * (0.34 + 0.5 * pow(drawn, 3)))
        }
    }

    // MARK: - What the shaft will answer

    /// How many meshes stand in the descent. **Zero, in every room, forever** —
    /// the binding condition, as a number, for the one part of Design's package
    /// that let it go.
    var solids: Int {
        var count = 0
        func walk(_ n: SCNNode) {
            if let geometry = n.geometry,
               geometry.elements.contains(where: { $0.primitiveType != .line }) {
                count += 1
            }
            n.childNodes.forEach(walk)
        }
        walk(node)
        return count
    }

    /// How many rims the shaft is drawn with, her roots included.
    var rimCount: Int { rims.count + rootRims.count }

    /// How lit the rim at `i` is, as the scene actually has it.
    func light(ofRim i: Int) -> Double {
        rims.indices.contains(i) ? Double(rims[i].opacity) : 0
    }

    /// Where the rim at `i` stands, as the scene actually has it.
    func place(ofRim i: Int) -> SIMD3<Double> {
        guard rims.indices.contains(i) else { return .zero }
        let p = rims[i].position
        return SIMD3(Double(p.x), Double(p.y), Double(p.z))
    }

    /// How wide the rim at `i` is, as the scene actually has it.
    func width(ofRim i: Int) -> Double {
        rims.indices.contains(i) ? Double(rims[i].scale.x) : 0
    }

    /// How far the rim at `i` has turned, as the scene actually has it.
    func turn(ofRim i: Int) -> Double {
        rims.indices.contains(i) ? Double(rims[i].eulerAngles.z) : 0
    }

    /// Where her root rims stand, as the scene actually has them.
    var rootPlaces: [SIMD3<Double>] {
        rootRims.map { SIMD3(Double($0.position.x), Double($0.position.y), Double($0.position.z)) }
    }
}
