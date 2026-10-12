import Foundation
import SceneKit
import UIKit

// MARK: - The room is shaped like her seat
//
// Wave 1 · Slice D. Until now every one of the 102 rooms was the same box —
// three walls of stone around a floor — and Design had already named that as a
// failure of its own first board: *"I built one perspective box for all of
// them… That is decoration."* The older Rite of Entering shaped each room like
// the seat it stands in, and `rite-core.jsx` writes the shape beside every
// world:
//
//     1 square · 2 petal · 3 petal · 4 tri-up · 5 tri-down · 6 tri-up ·
//     7 tri-down · 8 tri-up · 9 circle
//
// So a Bhūpura room is a square court, a lotus room is a ring of petals (sixteen
// in the second āvaraṇa, eight in the third), a triangle room is a triangle in
// plan — pointing away from him where the yantra's triangle points up, opening
// away from him where it points down — and the Bindu's room is round.
//
// **The shell is still the room's own stone, and the stations still move it.**
// Every panel is a wall in the sense ``RoomScene`` already means: it stands at a
// base position, the reversal can bring it toward the room's centre (never all
// the way to the walker) or lift it away. What changed is where the walls stand
// and how many there are; the enclosure arithmetic reads them the same way.
//
// And where wall meets floor there is a **seam of light** — the seat's own plan,
// drawn on the ground in her lifted hue — so the shape is legible even where the
// world's fog has closed over the walls themselves.

/// The plan of one seat.
enum SeatShape: Equatable {
    /// The Bhūpura's square court.
    case square
    /// A lotus ring of `count` petals.
    case petal(count: Int)
    /// A triangle in plan. `pointsAway` is the yantra's upward triangle: its
    /// apex is beyond her mark and the room narrows away from him. Otherwise the
    /// room opens away from him, and the far wall is the triangle's base.
    case triangle(pointsAway: Bool)
    /// The Bindu.
    case circle

    /// Design's own table, by āvaraṇa (`rite-core.jsx`'s `room:`).
    static func forRing(_ ring: Int) -> SeatShape {
        switch ring {
        case 1: return .square
        case 2: return .petal(count: 16)
        case 3: return .petal(count: 8)
        case 4, 6, 8: return .triangle(pointsAway: true)
        case 5, 7: return .triangle(pointsAway: false)
        case 9: return .circle
        default: return .square
        }
    }

    /// Design's word for the seat, as the older rite's dwelling card writes it.
    var seatWord: String {
        switch self {
        case .square:   return "the bhūpura"
        case .petal:    return "a lotus petal"
        case .triangle: return "a triangle"
        case .circle:   return "the bindu"
        }
    }
}

/// One panel of a shell, as numbers: where it stands, which way it faces, how
/// big it is. Pure, so the plan can be asserted without a renderer.
struct ShellPanel: Equatable {
    /// Where the panel's centre stands on the floor plan.
    let x: Double
    let z: Double
    /// The rotation about the vertical axis. A panel at yaw zero faces the
    /// walker (its normal is +z).
    let yaw: Double
    let width: Double
    let height: Double
    /// Whether the panel is cut as a petal rather than a plain wall.
    let isPetal: Bool
    /// The point a station closes the panel toward — the seat's own centre.
    let centreX: Double
    let centreZ: Double
    /// Whether the panel also shortens as it closes. A triangle closes by
    /// shrinking about its own centroid — every side toward it and every side
    /// shorter by the same fraction — so its walls can never cross one another
    /// in front of him. A ring of petals or a court closes by drawing in.
    var shrinksAsItCloses: Bool = false

    /// How far the panel stands from the seat's centre.
    var standOff: Double {
        let dx = x - centreX, dz = z - centreZ
        return (dx * dx + dz * dz).squareRoot()
    }
}

enum RoomShell {

    /// How tall every panel stands — the walls' height before Wave 1, kept so
    /// the stations' rise reads the same in every room.
    static var panelHeight: Double { RoomUnits.roomHeight * 1.6 }

    /// The panels of one seat.
    static func panels(for shape: SeatShape) -> [ShellPanel] {
        let half = RoomUnits.halfExtent
        let h = panelHeight
        switch shape {

        case .square:
            // The court as it always stood: two sides and the far wall. The
            // sides are drawn in so the court is a little deeper than wide.
            return [
                ShellPanel(x: -half * 0.65, z: 0, yaw: .pi / 2, width: RoomUnits.extent,
                           height: h, isPetal: false, centreX: 0, centreZ: 0),
                ShellPanel(x: half * 0.65, z: 0, yaw: -.pi / 2, width: RoomUnits.extent,
                           height: h, isPetal: false, centreX: 0, centreZ: 0),
                ShellPanel(x: 0, z: -half, yaw: 0, width: RoomUnits.extent,
                           height: h, isPetal: false, centreX: 0, centreZ: 0),
            ]

        case .petal(let count):
            // A ring of petals round a centre a little beyond her mark, with
            // the ones behind him left out — he stands in the lotus's mouth.
            let n = max(4, count)
            let radius = half * 0.62
            let centreZ = -RoomUnits.roomHeight * 0.55
            let step = 2 * Double.pi / Double(n)
            let width = 2 * Double.pi * radius / Double(n) * 1.18
            var out: [ShellPanel] = []
            for k in 0..<n {
                let theta = -Double.pi + (Double(k) + 0.5) * step
                guard abs(theta) <= Double.pi * 0.75 else { continue }
                out.append(ShellPanel(x: radius * sin(theta),
                                      z: centreZ - radius * cos(theta),
                                      yaw: -theta, width: width, height: h,
                                      isPetal: true, centreX: 0, centreZ: centreZ))
            }
            return out

        case .triangle(let pointsAway):
            if pointsAway {
                // The apex beyond her, the base corners beside him.
                let apex = (x: 0.0, z: -half)
                let corners = [(x: -half * 0.9, z: half * 0.2), (x: half * 0.9, z: half * 0.2)]
                let centroid = (corners[0].z + corners[1].z + apex.z) / 3
                return corners.map { c in
                    side(from: c, to: apex, height: h, centreZ: centroid)
                }
            } else {
                // The apex at his back — behind even where the rite's crossing
                // begins, so he never looks at the outside of his own room —
                // and the base across the far end.
                let apex = (x: 0.0, z: RoomUnits.eyeZ + RoomUnits.approachStandOff
                                       + RoomUnits.roomHeight * 0.25)
                let corners = [(x: -half * 0.9, z: -half), (x: half * 0.9, z: -half)]
                let centroid = (corners[0].z + corners[1].z + apex.z) / 3
                var out = corners.map { c in
                    side(from: apex, to: c, height: h, centreZ: centroid)
                }
                var base = ShellPanel(x: 0, z: -half, yaw: 0, width: half * 1.8,
                                      height: h, isPetal: false,
                                      centreX: 0, centreZ: centroid)
                base.shrinksAsItCloses = true
                out.append(base)
                return out
            }

        case .circle:
            // Round, open only where he came in: the panels behind him are left
            // out, as the lotus's are, so the rite's crossing walks him through
            // the opening rather than up to the outside of a drum.
            let n = 16
            let radius = half * 0.6
            let centreZ = -RoomUnits.roomHeight * 0.45
            let step = 2 * Double.pi / Double(n)
            let width = 2 * Double.pi * radius / Double(n) * 1.03
            var out: [ShellPanel] = []
            for k in 0..<n {
                let theta = -Double.pi + (Double(k) + 0.5) * step
                guard abs(theta) <= Double.pi * 0.75 else { continue }
                out.append(ShellPanel(x: radius * sin(theta), z: centreZ - radius * cos(theta),
                                      yaw: -theta, width: width, height: h, isPetal: false,
                                      centreX: 0, centreZ: centreZ))
            }
            return out
        }
    }

    /// A straight wall between two points on the plan.
    ///
    /// A plane's width runs along its local x, and a rotation `φ` about the
    /// vertical takes local x to `(cos φ, 0, −sin φ)`, so `φ = atan2(−dz, dx)`.
    private static func side(from a: (x: Double, z: Double), to b: (x: Double, z: Double),
                             height: Double, centreZ: Double) -> ShellPanel {
        let dx = b.x - a.x, dz = b.z - a.z
        var panel = ShellPanel(x: (a.x + b.x) / 2, z: (a.z + b.z) / 2,
                               yaw: atan2(-dz, dx),
                               width: (dx * dx + dz * dz).squareRoot(),
                               height: height, isPetal: false,
                               centreX: 0, centreZ: centreZ)
        panel.shrinksAsItCloses = true
        return panel
    }

    // MARK: - Built

    /// A panel as geometry: a plane of the room's stone, or a petal cut from it.
    static func geometry(for panel: ShellPanel, material: SCNMaterial) -> SCNGeometry {
        let geometry: SCNGeometry
        if panel.isPetal {
            let shape = SCNShape(path: petalPath(width: panel.width, height: panel.height),
                                 extrusionDepth: CGFloat(RoomUnits.roomHeight * 0.02))
            geometry = shape
        } else {
            geometry = SCNPlane(width: CGFloat(panel.width), height: CGFloat(panel.height))
        }
        geometry.materials = [material]
        return geometry
    }

    /// A lotus petal: wide in its lower middle, pointed at the top, rounded at
    /// the foot. Centred on the origin in the plane's own x–y.
    static func petalPath(width: Double, height: Double) -> UIBezierPath {
        let w = CGFloat(width), h = CGFloat(height)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: -h / 2))
        // A quadratic's widest point is half its control's reach, so the
        // control stands a whole petal-width out to make the petal that wide.
        path.addQuadCurve(to: CGPoint(x: 0, y: h / 2), controlPoint: CGPoint(x: w, y: -h * 0.12))
        path.addQuadCurve(to: CGPoint(x: 0, y: -h / 2), controlPoint: CGPoint(x: -w, y: -h * 0.12))
        path.close()
        // SceneKit tessellates a path at its flatness, in its own units — and a
        // petal is a few units tall, so the default would cut it into a handful
        // of facets.
        path.flatness = 0.02
        return path
    }

    /// The seam of light where a panel meets the floor: the seat's plan, drawn
    /// on the ground. A child of the panel, so it travels with the wall when a
    /// station moves it.
    static func seam(for panel: ShellPanel, panelCentreY: Double, colour: UIColor) -> SCNNode {
        let thickness = CGFloat(RoomUnits.roomHeight * 0.006)
        let line = SCNBox(width: CGFloat(panel.width * (panel.isPetal ? 0.42 : 0.98)),
                          height: thickness, length: thickness, chamferRadius: 0)
        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = UIColor.black
        material.emission.contents = colour
        material.emission.intensity = 1.6
        material.blendMode = .add
        material.writesToDepthBuffer = false
        material.name = "seam"
        line.materials = [material]
        let node = SCNNode(geometry: line)
        node.name = "seam"
        node.castsShadow = false
        node.position = SCNVector3(0, Float(RoomUnits.floorY - panelCentreY) + Float(thickness), 0.04)
        RoomScene.markAsLight(node)
        return node
    }
}
