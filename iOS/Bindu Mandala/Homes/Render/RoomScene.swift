import Foundation
import SceneKit
import Metal
import UIKit

// MARK: - The spine: one room, assembled
//
// The renderer ruling's third file. `SCNScene` assembly with Design's three
// depth layers as named node roots, the surfaces, the camera, and the hook a
// mechanism uses to act on them.
//
// What is reused from `Views/Spike/GarimaSceneKitRoom.swift`, which is the
// proven pattern rather than a first draft:
//
//   * **Strata as real geometry, not a displacement texture.** SceneKit can
//     displace from a texture only through the tessellator, which the simulator
//     does not carry. The spike made the bedding real geometry and found that
//     this is not a workaround: it is what lets a mark be *in* the floor.
//   * **Base plus two morph targets.** Three meshes, generated once, and the
//     whole stay is two weights. The spike measured it cheaper past the second
//     adaptation than at the first, which is the state a practitioner reaches.
//   * **`pose(at:)` as a pure function of scene time.** The room is a function,
//     so it can be asserted without a renderer and drawn exactly once on the
//     reduce-motion path.
//   * **The camera discipline the spike caught inverted.** Its first draft put
//     a soles Śakti's eye 1.4 units above the floor, and her mark then climbed
//     into the *upper* half of the frame — the opposite of a Śakti felt at the
//     soles. Here the eye is not tuned at all: ``RoomUnits`` stands it where
//     the body's own eyes are, and `RoomSceneTests` asserts both ends of the
//     body against the frame.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE THIRD LAYER HAS NO GEOMETRY, AND THAT IS THE BINDING CONDITION
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's three layers are the building, the world, and her mechanism. Under
// the renderer ruling the third one owns **no mesh at all**: her mechanism is
// an action on the building's own material, so what it holds is the light in
// the mark it made and nothing else. `testHerLayerHoldsNoSolid` walks the
// graph and fails the build if a geometry ever appears under it.
//
// The `SCNScene` itself is deliberately not exposed. A room is installed into a
// view or captured; it never hands out a root node for something to be added
// to. That is the same rule as ``RoomMaterial``'s, one level up.

/// What a mechanism is handed, and the only thing it can do with it.
///
/// It carries where she is, how far the stay has come, and the materials of the
/// room's surfaces — read-only. There is no node, no scene and no root here, so
/// a mechanism has nowhere to put an object even if it had one.
struct RoomStage {
    /// Where her mark falls at this moment.
    let placement: RoomPlacement
    /// The first adaptation, `0…1`.
    let settling: Double
    /// The second adaptation, `0…1`.
    let deep: Double
    /// The room's surfaces as they stand, before this moment's actions.
    let materials: [RoomSurfaceKind: RoomMaterial]

    /// A reach in scene units, in one surface's own coordinates.
    func reach(_ worldUnits: Double, on surface: RoomSurfaceKind) -> Double {
        materials[surface]?.reach(worldUnits: worldUnits) ?? 0
    }
}

/// The hook one of Design's authored mechanisms uses to act on the room.
///
/// **Its return type is the binding condition for Phase 3.3.** A mechanism can
/// produce actions on surfaces and nothing else: there is no return path here
/// for a node, a mesh, a light or a shape. The eight authored rooms — the
/// ceiling that descends, the floor that lets go, the wall passing through you
/// — are all deformations of the room's own material, and this signature is
/// what keeps the ninetieth one honest.
protocol RoomSurfaceMechanism {
    /// Everything this mechanism does to the room at one moment of the stay.
    func actions(at chamberTime: TimeInterval, stage: RoomStage) -> [RoomSurfaceKind: [SurfaceAction]]
}

/// The whole room at one instant, as numbers. Pure, so the room's behaviour is
/// a property of this struct rather than of a screenshot.
struct RoomPose: Equatable {
    let sceneTime: TimeInterval
    /// The first adaptation, `0…1` over 62 s.
    let settling: Double
    /// The second, `0…1` over the 120 s after 227 s.
    let deep: Double
    /// The two morph weights, normalised so they never overshoot: the room
    /// passes through the first adaptation's shape and arrives at the second's.
    let firstWeight: Double
    let secondWeight: Double
    let placement: RoomPlacement
    let eye: SIMD3<Double>
    let eyePitch: Double
    let keyStrength: Double
    let keyPosition: SIMD3<Double>
    let emberStrength: Double
    /// Her physics, applied to the room itself — the building breathes the way
    /// she does. Zero where the grammar does not speak for her.
    let drift: HomeOffset
    /// The world's own clock, tempo-scaled. It drives the weather and nothing
    /// else; her adaptation clock is never scaled (``HomeWorlds/adaptationClock(_:ring:)``).
    let worldTime: TimeInterval

    init(sceneTime t: TimeInterval, room: HomeRoom) {
        let k = HomeGrammar.settling(chamberTime: t)
        let b = HomeGrammar.deepProgress(chamberTime: t)
        self.sceneTime = t
        self.settling = k
        self.deep = b
        self.firstWeight = k * (1 - b)
        self.secondWeight = b
        let placement = RoomUnits.placement(bodyAltitude: room.bodyAltitude, chamberTime: t)
        self.placement = placement
        self.eye = SIMD3(0, RoomUnits.eyeY, RoomUnits.eyeZ)
        self.eyePitch = RoomUnits.eyePitch(toward: placement)
        self.keyStrength = RoomLightRig.keyStrength(settling: k, deep: b)
        self.keyPosition = RoomLightRig.keyPosition(settling: k, deep: b)
        self.emberStrength = RoomLightRig.emberStrength(settling: k, deep: b)
        if case .grammar(let reading) = room.kind {
            self.drift = reading.displacement(time: t, amplitude: RoomScene.driftAmplitude)
        } else {
            self.drift = .zero
        }
        self.worldTime = HomeWorlds.worldClock(t, ring: room.ring)
    }
}

/// One Śakti's room, assembled.
final class RoomScene {

    /// The room this is, resolved by ``HomeRooms``. Position is the only key.
    let room: HomeRoom
    /// Her light.
    let rig: RoomLightRig
    /// The mechanism acting on the room, where one has been built. Phase 3.3
    /// fills these in for the authored eight; until then a room is its grammar,
    /// its world and her attribute, which is a whole room.
    let mechanism: RoomSurfaceMechanism?

    // MARK: - Design's three depth layers, as named node roots

    /// Layer 1 — the building: the floor, the canopy, the walls, her face.
    let building = SCNNode()
    /// Layer 2 — the world: the āvaraṇa's weather and the light it arrives by.
    let weather = SCNNode()
    /// Layer 3 — her mechanism. **No geometry, ever.** See the header.
    let herLayer = SCNNode()

    let cameraNode = SCNNode()

    // MARK: - The surfaces

    /// The scene time the room was last put at. The approach reads it so that
    /// standing further back cannot silently pose the room at a different
    /// instant from the one it was just posed at.
    private(set) var posedAt: TimeInterval = 0

    /// The world clock the air was last set to. Her own while she is stood in;
    /// the threshold's while the walker is still crossing toward her.
    private(set) var breathedAt: TimeInterval = 0

    /// The material of each surface, with everything that has been done to it.
    private(set) var materials: [RoomSurfaceKind: RoomMaterial] = [:]
    /// The surface her attribute acts on, decided by her body altitude.
    let receivingSurface: RoomSurfaceKind

    private let scene = SCNScene()
    private let groundNode = SCNNode()
    private let canopyNode = SCNNode()
    private let faceNode = SCNNode()
    private let riserNode = SCNNode()
    private var wallNodes: [SCNNode] = []
    private var emberNode: SCNNode?
    private var keyNode: SCNNode?
    private var motesMaterial: SCNMaterial?
    /// The material of the surface her attribute acts on. Its emission is the
    /// light in the marks she has made, and it rises as the stay deepens.
    private var markedMaterial: SCNMaterial?

    // MARK: - Constants

    /// Vertices per side of a surface mesh. 64 × 64 is 4,096 vertices and 7,938
    /// triangles: enough that a mark reads as a mark at the near edge of the
    /// floor, and small enough that base plus two morph targets is a few
    /// hundred kilobytes rather than a few megabytes — which matters at 102.
    static let resolution = 64

    /// How far the room itself moves with her physics. A twentieth of a
    /// body-height: the building breathes, it does not sway.
    static let driftAmplitude: Double = RoomUnits.roomHeight / 20

    /// How strongly a mark's own light shows when the stay has just begun, and
    /// when it has come the whole way. Design's §4.4: the attribute does not
    /// brighten into an object — it becomes the room, so the top of this range
    /// is a surface glowing, not a lamp.
    static let markEmissionFloor: Double = 0.06
    static let markEmissionCeiling: Double = 0.42

    /// How many motes stand in the air. Carried from the spike, where the
    /// screen-space radius clamp that keeps them from stacking to white was
    /// measured rather than guessed (Design's invariant 7).
    static let moteCount = 420

    // MARK: - Assembly

    init(room: HomeRoom, mechanism: RoomSurfaceMechanism? = nil) {
        self.room = room
        self.mechanism = mechanism
        self.rig = RoomLightRig(gem: room.gem, world: room.world)
        self.receivingSurface = RoomUnits.surface(forBodyAltitude: room.bodyAltitude)

        // ── the material of every surface, before anything happens to it ────
        for kind in RoomSurfaceKind.allCases {
            materials[kind] = RoomMaterial(surface: kind, seed: room.position)
        }

        // ── the three moments the room's shape is generated at ──────────────
        //
        // Her chamber clock's own marks, read from `HomeMemory` rather than
        // written again: the stay begins, the first adaptation completes, the
        // second completes. Everything between is two morph weights.
        let moments: [TimeInterval] = [0,
                                       HomeMemory.firstAdaptation,
                                       HomeMemory.secondAdaptationEnd]
        let shapes = moments.map { shaped(at: $0) }

        // ── layer 1 · the building ──────────────────────────────────────────
        building.name = "building"
        weather.name = "world"
        herLayer.name = "her mechanism"

        let ink = RoomLightRig.colour(room.gem.ink)

        buildGround(shapes: shapes.map { $0[.ground] ?? materials[.ground]! }, ink: ink)
        buildCanopy(shapes: shapes.map { $0[.canopy] ?? materials[.canopy]! }, ink: ink)
        buildFace(shapes: shapes.map { $0[.face] ?? materials[.face]! }, ink: ink)
        buildWalls(ink: ink)

        // ── layer 2 · the world ─────────────────────────────────────────────
        buildWeather()
        rig.applyFog(to: scene)
        scene.background.contents = RoomLightRig.colour(room.gem.ink)

        // ── the camera ──────────────────────────────────────────────────────
        let camera = SCNCamera()
        camera.fieldOfView = CGFloat(RoomUnits.fieldOfView)
        camera.zNear = RoomUnits.zNear
        camera.zFar = RoomUnits.zFar
        camera.wantsHDR = false
        cameraNode.camera = camera
        cameraNode.name = "eye"
        cameraNode.position = SCNVector3(0, Float(RoomUnits.eyeY), Float(RoomUnits.eyeZ))

        // ── layer 3 · her mechanism, and the light in what it made ──────────
        let opening = RoomUnits.placement(bodyAltitude: room.bodyAltitude, chamberTime: 0)
        let installed = rig.install(world: weather, mechanism: herLayer, at: opening)
        keyNode = installed.key
        emberNode = installed.ember

        scene.rootNode.addChildNode(building)
        scene.rootNode.addChildNode(weather)
        scene.rootNode.addChildNode(herLayer)
        scene.rootNode.addChildNode(cameraNode)

        pose(at: 0)
    }

    // MARK: - What the room's surfaces are, at one moment

    /// Every surface, with everything that has been done to it at this moment
    /// of the stay: the mechanism's actions first, then her attribute's.
    ///
    /// This is the only place an action is ever applied, and the only things it
    /// can apply are ``SurfaceAction``s.
    func shaped(at chamberTime: TimeInterval) -> [RoomSurfaceKind: RoomMaterial] {
        var out = materials
        let placement = RoomUnits.placement(bodyAltitude: room.bodyAltitude,
                                            chamberTime: chamberTime)
        let stage = RoomStage(placement: placement,
                              settling: HomeGrammar.settling(chamberTime: chamberTime),
                              deep: HomeGrammar.deepProgress(chamberTime: chamberTime),
                              materials: out)

        if let mechanism {
            for (kind, actions) in mechanism.actions(at: chamberTime, stage: stage) {
                out[kind]?.receive(actions)
            }
        }
        if let actor = room.attribute, var receiving = out[receivingSurface] {
            receiving.receive(RoomInscription.actions(for: actor,
                                                      at: chamberTime,
                                                      on: receiving,
                                                      placement: placement))
            out[receivingSurface] = receiving
        }
        return out
    }

    // MARK: - Posing

    /// Put the whole room at one instant.
    ///
    /// Pure in everything but its writes: the same scene time always produces
    /// the same room, which is what lets the reduce-motion path pose once and
    /// draw once, and what lets the tests assert a stay without a renderer.
    func pose(at sceneTime: TimeInterval) {
        let pose = RoomPose(sceneTime: sceneTime, room: room)
        posedAt = sceneTime

        for node in [groundNode, canopyNode, faceNode] {
            node.morpher?.setWeight(CGFloat(pose.firstWeight), forTargetAt: 0)
            node.morpher?.setWeight(CGFloat(pose.secondWeight), forTargetAt: 1)
        }

        // Her physics, on the room itself.
        building.position = SCNVector3(Float(pose.drift.x), Float(pose.drift.y), Float(pose.drift.z))

        // Her face comes toward the walker as the attribute grows into the room.
        if receivingSurface == .face {
            faceNode.position = SCNVector3(0, Float(pose.placement.height), Float(pose.placement.depth))
            riserNode.position = SCNVector3(0, Float(RoomUnits.floorY), Float(pose.placement.depth))
            riserNode.scale = SCNVector3(1, Float(max(0.001, pose.placement.height - RoomUnits.floorY)), 1)
        }

        emberNode?.position = SCNVector3(0,
                                         Float(pose.placement.height + RoomUnits.roomHeight * 0.12),
                                         Float(pose.placement.depth))
        emberNode?.light?.intensity = CGFloat(pose.emberStrength)

        if let keyNode {
            keyNode.light?.intensity = CGFloat(pose.keyStrength)
            keyNode.position = SCNVector3(Float(pose.keyPosition.x),
                                          Float(pose.keyPosition.y),
                                          Float(pose.keyPosition.z))
            keyNode.look(at: SCNVector3(0, Float(RoomUnits.floorY), Float(pose.placement.depth)))
        }

        cameraNode.position = SCNVector3(Float(pose.eye.x), Float(pose.eye.y), Float(pose.eye.z))
        cameraNode.eulerAngles = SCNVector3(Float(pose.eyePitch), 0, 0)

        // The marks are lit as they are made: the emission map is the whole
        // stay's marks, and how much of it is showing is the stay's own two
        // adaptations. A texture cannot morph; an intensity can.
        markedMaterial?.emission.intensity =
            CGFloat(Self.markEmissionFloor
                    + (Self.markEmissionCeiling - Self.markEmissionFloor)
                      * (0.45 * pose.settling + 0.55 * pose.deep))

        breathe(at: pose.worldTime)
        motesMaterial?.setValue(NSNumber(value: Float(pose.deep)), forKey: "uDeep")
    }

    /// The world's air, at one moment of the **āvaraṇa's** clock.
    ///
    /// Split out of ``pose(at:)`` for one case, and it is the case the rite
    /// creates: while the walker is still at her threshold her chamber clock is
    /// held, and posing the room at a held clock would hold the weather with it
    /// — the dust standing perfectly still for the whole ceremony. Design is
    /// explicit that it does not: *"the weather is continuous — and it follows
    /// you into her room."* The air is the enclosure's, not hers, and it does
    /// not wait for him.
    ///
    /// ``pose(at:)`` still calls this with her own world time, so an entered
    /// room is exactly what it was and stays a pure function of one clock.
    func breathe(at worldTime: TimeInterval) {
        breathedAt = worldTime
        motesMaterial?.setValue(NSNumber(value: Float(worldTime)), forKey: "uTime")
    }

    // MARK: - Standing short of the room

    /// Put the walker somewhere on his crossing toward the room — `0` at the far
    /// end of the approach, `1` standing in it.
    ///
    /// Called **after** ``pose(at:)``, which always stands the eye in the room:
    /// the pose is the room at an instant and this is where it is seen from, and
    /// keeping them apart is what lets every existing check about the room's own
    /// behaviour go on reading a room that is stood in.
    ///
    /// It moves the eye and nothing else. It adds no node, no light and no
    /// geometry, so the binding condition the spine carries — her layer holds no
    /// solid — cannot be reached from here even by accident. And it changes no
    /// fog: the world's veil already decides where the air closes, and standing
    /// further out simply puts more of that air between the walker and her room.
    func stand(atApproach approach: Double) {
        let depth = RoomUnits.eyeDepth(approach: approach)
        let placement = RoomUnits.placement(bodyAltitude: room.bodyAltitude,
                                            chamberTime: posedAt)
        cameraNode.position = SCNVector3(0, Float(RoomUnits.eyeY), Float(depth))
        cameraNode.eulerAngles =
            SCNVector3(Float(RoomUnits.eyePitch(toward: placement, fromDepth: depth)), 0, 0)
    }

    // MARK: - Where a room goes

    /// Put this room into a view. The scene is never handed out.
    func install(into view: SCNView) {
        view.scene = scene
        view.pointOfView = cameraNode
        view.backgroundColor = RoomLightRig.colour(room.gem.ink)
        view.isOpaque = true
        view.antialiasingMode = .multisampling2X
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = false
    }

    /// The room, rendered offscreen at one moment of the stay.
    ///
    /// The ruling recorded that SwiftUI cannot screenshot a `CAMetalLayer`, so
    /// the legibility register — Design's 204 real renders, the check that
    /// found five dark rooms and one white one — has to go around SwiftUI. This
    /// is that door, and it needs no window and no host application: it is the
    /// geometry half of the composite, which is the half a machine can judge.
    func capture(size: CGSize, atSceneTime sceneTime: TimeInterval) -> CGImage? {
        pose(at: sceneTime)
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        let renderer = SCNRenderer(device: device, options: nil)
        renderer.scene = scene
        renderer.pointOfView = cameraNode
        renderer.autoenablesDefaultLighting = false
        return renderer.snapshot(atTime: 0, with: size, antialiasingMode: .none).cgImage
    }

    /// How many meshes stand under her own layer. The binding condition, as a
    /// number the tests can read: it is zero, in every room, forever.
    var solidsInHerLayer: Int {
        var count = 0
        func walk(_ node: SCNNode) {
            if node.geometry != nil { count += 1 }
            node.childNodes.forEach(walk)
        }
        walk(herLayer)
        return count
    }

    // MARK: - The surfaces, built

    private func buildGround(shapes: [RoomMaterial], ink: UIColor) {
        let geometries = shapes.map {
            Self.mesh(of: $0, extent: RoomUnits.extent, orientation: .floor)
        }
        let material = Self.stone(ink, roughness: 0.95, emission: shapes.last)
        material.name = "ground"
        if receivingSurface == .ground { markedMaterial = material }
        geometries.forEach { $0.materials = [material] }
        groundNode.geometry = geometries[0]
        groundNode.name = "ground"
        groundNode.position = SCNVector3(0, Float(RoomUnits.floorY), 0)
        groundNode.castsShadow = false
        groundNode.morpher = Self.morpher(Array(geometries.dropFirst()))
        building.addChildNode(groundNode)
    }

    private func buildCanopy(shapes: [RoomMaterial], ink: UIColor) {
        let geometries = shapes.map {
            Self.mesh(of: $0, extent: RoomUnits.extent, orientation: .ceiling)
        }
        let material = Self.stone(ink, roughness: 0.98, emission: shapes.last)
        material.name = "canopy"
        if receivingSurface == .canopy { markedMaterial = material }
        geometries.forEach { $0.materials = [material] }
        canopyNode.geometry = geometries[0]
        canopyNode.name = "canopy"
        canopyNode.position = SCNVector3(0, Float(RoomUnits.canopyY), 0)
        canopyNode.castsShadow = true
        canopyNode.morpher = Self.morpher(Array(geometries.dropFirst()))
        building.addChildNode(canopyNode)
    }

    /// The working face, and the riser that joins it to the floor.
    ///
    /// The riser is why a face is not a panel hung in the air: it is a column of
    /// the same stone standing up out of the ground, and the face is its top.
    /// Where her altitude puts her at the floor or the canopy there is no face
    /// at all, and these two nodes are never added.
    private func buildFace(shapes: [RoomMaterial], ink: UIColor) {
        guard receivingSurface == .face else { return }
        let geometries = shapes.map {
            Self.mesh(of: $0, extent: RoomUnits.faceSpan, orientation: .face)
        }
        let material = Self.stone(ink, roughness: 0.92, emission: shapes.last)
        material.name = "face"
        markedMaterial = material
        material.isDoubleSided = true
        geometries.forEach { $0.materials = [material] }
        faceNode.geometry = geometries[0]
        faceNode.name = "face"
        faceNode.castsShadow = true
        faceNode.morpher = Self.morpher(Array(geometries.dropFirst()))
        building.addChildNode(faceNode)

        let riser = SCNBox(width: CGFloat(RoomUnits.faceSpan * 0.55), height: 1,
                           length: CGFloat(RoomUnits.faceSpan * 0.3), chamferRadius: 0)
        riser.materials = [Self.stone(ink, roughness: 0.95, emission: nil)]
        riserNode.geometry = riser
        riserNode.name = "riser"
        riserNode.pivot = SCNMatrix4MakeTranslation(0, -0.5, 0)
        riserNode.castsShadow = true
        building.addChildNode(riserNode)
    }

    private func buildWalls(ink: UIColor) {
        let material = Self.stone(ink, roughness: 0.94, emission: nil)
        material.name = "wall"
        material.isDoubleSided = true
        let height = RoomUnits.roomHeight * 1.6
        for (index, side) in [(x: -1.0, z: 0.0), (x: 1.0, z: 0.0), (x: 0.0, z: -1.0)].enumerated() {
            let plane = SCNPlane(width: CGFloat(RoomUnits.extent), height: CGFloat(height))
            plane.materials = [material]
            let node = SCNNode(geometry: plane)
            node.name = "wall-\(index)"
            node.castsShadow = false
            if side.x != 0 {
                node.position = SCNVector3(Float(side.x * RoomUnits.halfExtent * 0.65), 0, 0)
                node.eulerAngles = SCNVector3(0, Float(-side.x * .pi / 2), 0)
            } else {
                node.position = SCNVector3(0, 0, Float(-RoomUnits.halfExtent))
            }
            wallNodes.append(node)
            building.addChildNode(node)
        }
    }

    /// The āvaraṇa's weather: motes standing in the air, moving on the world's
    /// own clock. Design's worlds are weather, not palette, and the tempo scales
    /// this and only this.
    private func buildWeather() {
        var points = [SCNVector3]()
        points.reserveCapacity(Self.moteCount)
        var state = UInt64(bitPattern: Int64(room.position &* 2_654_435_761)) | 1
        func next() -> Double {
            state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            return Double((state >> 33) % 100_000) / 100_000
        }
        for _ in 0..<Self.moteCount {
            points.append(SCNVector3(Float((next() - 0.5) * RoomUnits.extent * 0.7),
                                     Float(RoomUnits.floorY + next() * RoomUnits.roomHeight),
                                     Float((next() - 0.5) * RoomUnits.extent * 0.7)))
        }
        let source = SCNGeometrySource(vertices: points)
        let element = SCNGeometryElement(indices: (0..<Int32(Self.moteCount)).map { $0 },
                                         primitiveType: .point)
        element.pointSize = 2.4
        element.minimumPointScreenSpaceRadius = 0.6
        element.maximumPointScreenSpaceRadius = 3.0

        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = RoomLightRig.colour(room.gem.bright)
        material.blendMode = .add
        material.writesToDepthBuffer = false
        // The more veiled the world, the more of it is in the air.
        material.transparency = CGFloat(0.20 + 0.34 * room.world.character.veil)
        material.name = "motes"
        // A Swift string SceneKit compiles at run time — no build-target file
        // and nothing in the shipping binary. The ruling names this as the
        // reason a permanent `.metal` file is optional for SceneKit and
        // unavoidable for a canvas.
        material.shaderModifiers = [
            .geometry: """
            #pragma arguments
            float uTime;
            float uDeep;
            #pragma body
            float s = _geometry.position.x * 12.9898 + _geometry.position.z * 78.233;
            float ph = fract(sin(s) * 43758.5453) * 6.2831853;
            _geometry.position.y += sin(uTime * 0.11 + ph) * 0.42 * (1.0 - uDeep * 0.6);
            _geometry.position.x += cos(uTime * 0.07 + ph) * 0.24;
            """
        ]
        // Seeded as `Float`, because SceneKit keys a shader argument by the
        // type it first sees: seed it as a `Double` and every later `Float`
        // write logs a type switch and animates wrong.
        material.setValue(NSNumber(value: Float(0)), forKey: "uTime")
        material.setValue(NSNumber(value: Float(0)), forKey: "uDeep")
        motesMaterial = material

        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.materials = [material]
        let node = SCNNode(geometry: geometry)
        node.name = "motes"
        node.castsShadow = false
        weather.addChildNode(node)
    }

    // MARK: - Meshing a material

    /// Which way a surface faces, and therefore which axis its relief runs on.
    enum Orientation {
        /// A floor: relief stands up out of it.
        case floor
        /// A ceiling seen from beneath: relief goes up into it.
        case ceiling
        /// A face standing in front of the walker: relief comes toward them.
        case face
    }

    /// A surface's material, as geometry.
    ///
    /// The relief comes from ``RoomMaterial/relief(at:)`` and nowhere else, so
    /// there is exactly one route from an action to a triangle, and it runs
    /// through the height field.
    static func mesh(of material: RoomMaterial,
                     extent: Double,
                     orientation: Orientation,
                     resolution n: Int = RoomScene.resolution) -> SCNGeometry {
        var vertices = [SCNVector3](); vertices.reserveCapacity(n * n)
        var normals = [SCNVector3](); normals.reserveCapacity(n * n)
        var texcoords = [CGPoint](); texcoords.reserveCapacity(n * n)

        let step = 1.0 / Double(n - 1)
        let worldStep = extent * step

        func place(_ u: Double, _ v: Double, _ y: Double) -> SCNVector3 {
            let a = Float((u - 0.5) * extent)
            let b = Float((v - 0.5) * extent)
            switch orientation {
            case .floor:   return SCNVector3(a, Float(y), b)
            case .ceiling: return SCNVector3(a, Float(-y), b)
            case .face:    return SCNVector3(a, b, Float(y))
            }
        }

        for j in 0..<n {
            for i in 0..<n {
                let u = Double(i) * step
                let v = Double(j) * step
                let here = SurfaceCoordinate(u: u, v: v)
                vertices.append(place(u, v, material.relief(at: here)))

                let du = material.relief(at: SurfaceCoordinate(u: min(1, u + step), v: v))
                    - material.relief(at: SurfaceCoordinate(u: max(0, u - step), v: v))
                let dv = material.relief(at: SurfaceCoordinate(u: u, v: min(1, v + step)))
                    - material.relief(at: SurfaceCoordinate(u: u, v: max(0, v - step)))
                var nx: Double, ny: Double, nz: Double
                switch orientation {
                case .floor:   (nx, ny, nz) = (-du, 2 * worldStep, -dv)
                case .ceiling: (nx, ny, nz) = (-du, -2 * worldStep, -dv)
                case .face:    (nx, ny, nz) = (-du, -dv, 2 * worldStep)
                }
                let length = (nx * nx + ny * ny + nz * nz).squareRoot()
                if length > 0 { nx /= length; ny /= length; nz /= length }
                normals.append(SCNVector3(Float(nx), Float(ny), Float(nz)))
                texcoords.append(CGPoint(x: u, y: v))
            }
        }

        var indices = [Int32]()
        indices.reserveCapacity((n - 1) * (n - 1) * 6)
        let reversed = orientation == .ceiling
        for j in 0..<(n - 1) {
            for i in 0..<(n - 1) {
                let a = Int32(j * n + i), b = a + 1
                let c = a + Int32(n), d = c + 1
                if reversed {
                    indices.append(contentsOf: [a, b, c, b, d, c])
                } else {
                    indices.append(contentsOf: [a, c, b, b, c, d])
                }
            }
        }

        return SCNGeometry(
            sources: [SCNGeometrySource(vertices: vertices),
                      SCNGeometrySource(normals: normals),
                      SCNGeometrySource(textureCoordinates: texcoords)],
            elements: [SCNGeometryElement(indices: indices, primitiveType: .triangles)])
    }

    /// The two morph targets, blended **normalised** rather than additively.
    ///
    /// Normalised is not a preference: with two additive targets both at full
    /// weight the room would arrive at `first + second - base`, overshooting
    /// every mark by the whole of the first adaptation. Normalised, the weights
    /// `k·(1-b)` and `b` take the room exactly through the first adaptation's
    /// shape and exactly to the second's.
    static func morpher(_ targets: [SCNGeometry]) -> SCNMorpher {
        let morpher = SCNMorpher()
        morpher.targets = targets
        morpher.calculationMode = .normalized
        return morpher
    }

    /// The dhātu: her hue, desaturated and taken nearly to black — the stone the
    /// room is cut from, which is ``HomeGem/ink``.
    ///
    /// Where a surface has been marked, the mark's own emission is written into
    /// the material's emission channel as a texture. **That is the only route to
    /// light in a room's material**, and it exists because
    /// ``RoomMaterial/emission(at:)`` cannot return anything where the material
    /// is undisturbed.
    static func stone(_ ink: UIColor, roughness: Double, emission: RoomMaterial?) -> SCNMaterial {
        let m = SCNMaterial()
        m.lightingModel = .blinn
        m.diffuse.contents = ink
        m.specular.contents = UIColor(white: CGFloat(max(0, 1 - roughness)) * 0.5, alpha: 1)
        m.shininess = 0.04
        m.isLitPerPixel = true
        if let emission, !emission.isUndisturbed {
            m.emission.contents = emissionMap(of: emission)
            m.emission.intensity = 0.34
        }
        return m
    }

    /// The surface's own emission, as a small map.
    ///
    /// 64 × 64, which is the mesh's own resolution: a mark cannot be lit more
    /// finely than the material it is in, and anything finer would be light
    /// floating over stone rather than light coming out of it.
    ///
    /// Written as four channels rather than one, and that is not a style
    /// choice: a single-channel 8-bit `CGImage` reaches Metal as
    /// `r8Unorm_sRGB`, which the simulator's device rejects with a hard
    /// assertion — `pixelFormat (11) is not a valid MTLPixelFormat` — and takes
    /// the whole test process down with it. Grey in RGB is the same light and
    /// a format every device carries.
    static func emissionMap(of material: RoomMaterial, side: Int = 64) -> CGImage? {
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        for j in 0..<side {
            for i in 0..<side {
                let lit = material.emission(at: SurfaceCoordinate(u: Double(i) / Double(side - 1),
                                                                  v: Double(j) / Double(side - 1)))
                let value = UInt8(min(255, max(0, lit * 255)))
                let offset = (j * side + i) * 4
                pixels[offset] = value
                pixels[offset + 1] = value
                pixels[offset + 2] = value
                pixels[offset + 3] = 255
            }
        }
        guard let provider = CGDataProvider(data: Data(pixels) as CFData) else { return nil }
        return CGImage(width: side, height: side, bitsPerComponent: 8, bitsPerPixel: 32,
                       bytesPerRow: side * 4,
                       space: CGColorSpaceCreateDeviceRGB(),
                       bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                       provider: provider, decode: nil, shouldInterpolate: true,
                       intent: .defaultIntent)
    }
}
