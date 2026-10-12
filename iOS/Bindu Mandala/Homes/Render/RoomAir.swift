import Foundation
import SceneKit
import UIKit
import simd

// MARK: - The light standing in the air
//
// Wave 1 · Slice D, under Build Charter II §3 law 3: *"Light stands in the air.
// Glows, cores, additive lines, membranes, transmission, caustics, gems, bloom,
// HDR. Each world keeps its own light."*
//
// Until this wave every room's air held one thing — four hundred and twenty
// motes — because the binding condition (a rule Code invented on 09-21 for one
// test room and then extended to all light) let nothing stand in the air that
// was not a mark in stone. The Reading of 12 October traced the gap between
// Design and the built app to that rule more than to any other, and the charter
// reshaped it to its first principle: **no figural depiction of a Śakti.** A
// caustic is not a figure. Neither is a lamp, a shaft of light, a colonnade or
// a band of chatoyance.
//
// So this file is `homes-worlds.js`'s nine bands, brought into the room each
// Śakti stands in — Design's own counts, colours and clocks, scaled from its
// thirty-unit bands into a room one body tall:
//
//   1 · Feet      a low sun swinging horizon to horizon across the far wall
//   2 · Pelvis    seven red rings expanding through cold blue, on the pulse
//   3 · Navel     a 2,600-point curl flow that will not settle
//   4 · Heart     RGB caustics crawling over glossy ground, and a diamond prism
//   5 · Throat    a 72-rib colonnade, light arriving in shafts between the ribs
//   6 · Forehead  nine translucent ruby lanterns, each lit from within
//   7 · Crown     luminous pearl fog — veils of light, sourceless
//   8 · Above     one chatoyant band travelling round the room, and the dark
//   9 · Totality  nine gem lamps orbiting, the yantra's lines turning
//
// **Every clock is the band's own** (``WorldBands``): the room hands this file
// the world time, already tempo-scaled by ``HomeWorlds/worldClock(_:ring:)``,
// and never her chamber clock. A slow world never buys a cheaper adaptation.
//
// **Every part of it is a pure function of that time**, so a reduce-motion
// walker is posed once and drawn once, and a test can capture any instant.
//
// HOW IT IS DRAWN
//
// Each light body owns its colour outright — a fragment modifier writes the
// whole pixel, premultiplied, onto an additive blend — so none of it depends on
// how SceneKit's lighting models fold ambient into diffuse, and the HDR buffer
// the camera now renders into (``RoomExposure``) carries values past one, which
// is what the bloom picks up as hot centres. The solid things — the ribs, the
// ruby lanterns, the prism — are lit like the rest of the room.
//
// Every node here is marked as light (``RoomScene/markAsLight(_:)``) except the
// three kinds of lit geometry, and none of it is, or could be read as, a figure.

// MARK: - The camera's light, per world

/// How one world is exposed: HDR on, and a bloom tuned to the world's own light.
///
/// The Crown is the conservative one — its fog is pearl and already bright —
/// and the dark worlds are lifted, because Design's measured room brightness
/// runs ≈ 80–255 where the restrained build ran ≈ 11–65. A wash-out is answered
/// by better light, not less: the bloom threshold sits high enough that only
/// what is genuinely hot — a core, a band, a lamp — spreads.
struct RoomExposure: Equatable {
    /// Exposure bias in stops.
    let exposureOffset: Double
    let bloomIntensity: Double
    let bloomThreshold: Double
    /// In points of the render.
    let bloomBlurRadius: Double

    static let table: [Int: RoomExposure] = [
        1: RoomExposure(exposureOffset: 0.30, bloomIntensity: 0.9, bloomThreshold: 0.78, bloomBlurRadius: 10),
        2: RoomExposure(exposureOffset: 0.40, bloomIntensity: 1.1, bloomThreshold: 0.72, bloomBlurRadius: 12),
        3: RoomExposure(exposureOffset: 0.35, bloomIntensity: 1.0, bloomThreshold: 0.75, bloomBlurRadius: 10),
        4: RoomExposure(exposureOffset: 0.30, bloomIntensity: 1.2, bloomThreshold: 0.80, bloomBlurRadius: 8),
        5: RoomExposure(exposureOffset: 0.35, bloomIntensity: 1.0, bloomThreshold: 0.78, bloomBlurRadius: 12),
        6: RoomExposure(exposureOffset: 0.40, bloomIntensity: 1.4, bloomThreshold: 0.70, bloomBlurRadius: 14),
        7: RoomExposure(exposureOffset: -0.10, bloomIntensity: 0.6, bloomThreshold: 0.92, bloomBlurRadius: 16),
        8: RoomExposure(exposureOffset: 0.35, bloomIntensity: 1.3, bloomThreshold: 0.75, bloomBlurRadius: 10),
        9: RoomExposure(exposureOffset: 0.20, bloomIntensity: 1.2, bloomThreshold: 0.80, bloomBlurRadius: 14),
    ]

    /// The world's exposure; a world outside 1…9 takes the Bhūpura's.
    static func forRing(_ ring: Int) -> RoomExposure {
        table[ring] ?? table[1]!
    }

    /// Put it on a camera. Adaptation is off, so a room is the same picture on
    /// every run and a capture can be judged.
    func apply(to camera: SCNCamera) {
        camera.wantsHDR = true
        camera.wantsExposureAdaptation = false
        camera.exposureOffset = CGFloat(exposureOffset)
        camera.bloomIntensity = CGFloat(bloomIntensity)
        camera.bloomThreshold = CGFloat(bloomThreshold)
        camera.bloomBlurRadius = CGFloat(bloomBlurRadius)
    }
}

// MARK: - What each band holds, as numbers

/// Design's counts for one band. Pure, so the nine can be asserted against
/// `homes-worlds.js` without a renderer.
struct BandAir: Equatable {
    let ring: Int
    /// Pelvis — `for (let i = 0; i < 7; i++)` expanding rings.
    let expandingRings: Int
    /// Navel — `const N = 2600`.
    let churnPoints: Int
    /// Heart — three spectra crawling.
    let causticSpectra: Int
    /// Heart — the diamond.
    let hasPrism: Bool
    /// Throat — `const COUNT = 72`.
    let ribs: Int
    /// Throat — `for (let i = 0; i < 24; i++)` shafts.
    let shafts: Int
    /// Forehead — nine ruby lanterns, each with its own light inside.
    let lanterns: Int
    /// Crown — five veils of pearl.
    let veils: Int
    /// Above the crown — the one band of chatoyance.
    let hasTravellingBand: Bool
    /// Totality — nine gem lamps.
    let gemLamps: Int
    /// Feet — the low sun on the far wall.
    let hasSun: Bool
    /// Design's `motes(count, …)` in the band, where it has one.
    let motes: Int

    static func forRing(_ ring: Int) -> BandAir {
        switch ring {
        case 1: return BandAir(ring: 1, expandingRings: 0, churnPoints: 0, causticSpectra: 0, hasPrism: false,
                               ribs: 0, shafts: 0, lanterns: 0, veils: 0, hasTravellingBand: false,
                               gemLamps: 0, hasSun: true, motes: 90)
        case 2: return BandAir(ring: 2, expandingRings: 7, churnPoints: 0, causticSpectra: 0, hasPrism: false,
                               ribs: 0, shafts: 0, lanterns: 0, veils: 0, hasTravellingBand: false,
                               gemLamps: 0, hasSun: false, motes: 120)
        case 3: return BandAir(ring: 3, expandingRings: 0, churnPoints: 2_600, causticSpectra: 0, hasPrism: false,
                               ribs: 0, shafts: 0, lanterns: 0, veils: 0, hasTravellingBand: false,
                               gemLamps: 0, hasSun: false, motes: 0)
        case 4: return BandAir(ring: 4, expandingRings: 0, churnPoints: 0, causticSpectra: 3, hasPrism: true,
                               ribs: 0, shafts: 0, lanterns: 0, veils: 0, hasTravellingBand: false,
                               gemLamps: 0, hasSun: false, motes: 0)
        case 5: return BandAir(ring: 5, expandingRings: 0, churnPoints: 0, causticSpectra: 0, hasPrism: false,
                               ribs: 72, shafts: 24, lanterns: 0, veils: 0, hasTravellingBand: false,
                               gemLamps: 0, hasSun: false, motes: 0)
        case 6: return BandAir(ring: 6, expandingRings: 0, churnPoints: 0, causticSpectra: 0, hasPrism: false,
                               ribs: 0, shafts: 0, lanterns: 9, veils: 0, hasTravellingBand: false,
                               gemLamps: 0, hasSun: false, motes: 90)
        case 7: return BandAir(ring: 7, expandingRings: 0, churnPoints: 0, causticSpectra: 0, hasPrism: false,
                               ribs: 0, shafts: 0, lanterns: 0, veils: 5, hasTravellingBand: false,
                               gemLamps: 0, hasSun: false, motes: 150)
        case 8: return BandAir(ring: 8, expandingRings: 0, churnPoints: 0, causticSpectra: 0, hasPrism: false,
                               ribs: 0, shafts: 0, lanterns: 0, veils: 0, hasTravellingBand: true,
                               gemLamps: 0, hasSun: false, motes: 0)
        case 9: return BandAir(ring: 9, expandingRings: 0, churnPoints: 0, causticSpectra: 0, hasPrism: false,
                               ribs: 0, shafts: 0, lanterns: 0, veils: 0, hasTravellingBand: false,
                               gemLamps: 9, hasSun: false, motes: 220)
        default: return forRing(1)
        }
    }

    /// Design's nine gem colours for Totality's lamps, in its own order.
    static let gemLampColours: [SIMD3<Double>] = [
        rgb(0xffc367), rgb(0x6f9dff), rgb(0xff6a44), rgb(0xdff0ff), rgb(0x2fe08a),
        rgb(0xff3a52), rgb(0xfbf6ec), rgb(0xffe9a8), rgb(0xffffff),
    ]

    /// A packed hex colour as three components, the way Design writes them.
    static func rgb(_ hex: Int) -> SIMD3<Double> {
        SIMD3(Double((hex >> 16) & 0xFF) / 255, Double((hex >> 8) & 0xFF) / 255, Double(hex & 0xFF) / 255)
    }

    /// How Design's thirty-unit bands are brought into a room one body tall.
    static var scale: Double { RoomUnits.roomHeight / 18 }

    /// Where the air is centred: a little beyond her resting mark, at the
    /// room's own middle height.
    static var centre: SIMD3<Double> {
        SIMD3(0, RoomUnits.mountOffset, -RoomUnits.roomHeight * 0.7)
    }

    /// Where Throat's ribs stand, in plan: three concentric arcs of 24, open in
    /// a wedge toward the walker so no rib stands between him and her mark.
    static func ribPlan() -> [(x: Double, z: Double, row: Int)] {
        let s = scale
        let c = centre
        let gap = Double.pi / 3
        var out: [(x: Double, z: Double, row: Int)] = []
        for i in 0..<72 {
            let row = i / 24, k = i % 24
            let r = (10 + Double(row) * 4) * s
            // 24 ribs across the 300° that face away from him; θ = 0 is far.
            let span: Double = 2 * Double.pi - gap
            let along: Double = (Double(k) + 0.5) / 24
            let theta: Double = -Double.pi + gap / 2 + along * span + Double(row) * 0.04
            out.append((x: c.x + r * sin(theta), z: c.z - r * cos(theta), row: row))
        }
        return out
    }

    /// Where the Forehead's nine lanterns stand, at a moment of the season: on
    /// a ring round the air's centre, open toward the walker.
    static func lanternPlace(_ i: Int, at t: Double) -> SIMD3<Double> {
        let s = scale
        let c = centre
        let gap: Double = 0.84
        let along: Double = Double(i) / 9
        let a: Double = Double.pi / 2 + gap / 2 + along * (2 * Double.pi - gap)
        let r: Double = (9 + Double(i % 3) * 4.6) * s
        let rise: Double = sin(Double(i) * 1.7 + t * 0.07) * 5.4 * s * 0.8
        return SIMD3(c.x + cos(a) * r, c.y + rise, c.z + sin(a) * r)
    }
}

// MARK: - The air, built

/// One room's air: the band's light, standing in it, on the band's own clock.
final class RoomAir {

    let ring: Int
    let plan: BandAir
    /// Everything this file builds hangs from here, and the room hangs it in
    /// its world layer.
    let root = SCNNode()

    /// What changes with the band's clock.
    private var clockwork: [(TimeInterval) -> Void] = []

    init(room: HomeRoom) {
        ring = room.ring
        plan = BandAir.forRing(room.ring)
        root.name = "air"
        switch room.ring {
        case 1: buildFeet()
        case 2: buildPelvis()
        case 3: buildNavel()
        case 4: buildHeart()
        case 5: buildThroat()
        case 6: buildForehead()
        case 7: buildCrown()
        case 8: buildAboveCrown()
        case 9: buildTotality()
        default: break
        }
        if plan.motes > 0 { buildMotes(colour: RoomAir.moteColour[room.ring] ?? SIMD3(1, 1, 1)) }
        update(worldTime: 0)
    }

    /// The band at one instant of its own clock. Pure in its effects: the same
    /// time always poses the same air.
    func update(worldTime t: TimeInterval) {
        for step in clockwork { step(t) }
    }

    /// How many light bodies stand in the air — a fact for a check.
    var lightBodies: Int {
        var count = 0
        func walk(_ node: SCNNode) {
            if node.geometry != nil, RoomScene.isLight(node) { count += 1 }
            node.childNodes.forEach(walk)
        }
        walk(root)
        return count
    }

    // MARK: - 1 · Feet · topaz · rasa · day–night

    private func buildFeet() {
        let s = BandAir.scale
        let half = RoomUnits.halfExtent
        // `sprite(glow('w1', …), 0xffc367, 22, 0.6)` — the sun's disc, on the
        // far wall, swinging from horizon to horizon.
        let disc = RoomAir.glow("sun", colour: BandAir.rgb(0xffc367), size: 22 * s * 1.5, alpha: 0.6, hot: 1.4)
        root.addChildNode(disc)
        let warm = RoomAir.omni("sun light", colour: BandAir.rgb(0xffc367), reach: RoomUnits.extent)
        root.addChildNode(warm)
        clockwork.append { t in
            // `const day = (t * 0.05) % 1`
            let day = WorldBands.fract(t * 0.05)
            let ang = day * 2 * .pi
            let alt = sin(ang)
            let p = SCNVector3(Float(cos(ang) * half * 0.55),
                               Float(RoomUnits.floorY + 0.6 + max(-0.4, alt * 3.2)),
                               Float(-half * 0.9))
            disc.position = p
            RoomAir.set(disc, "uAlpha", 0.95 * WorldBands.clamp01(alt + 0.4))
            warm.position = SCNVector3(p.x, p.y + 0.4, p.z + 1.5)
            // `sun.intensity = 6.4 * clamp01(alt * 1.6 + 0.2)`
            warm.light?.intensity = CGFloat(2_200 * WorldBands.clamp01(alt * 1.6 + 0.2))
        }
    }

    // MARK: - 2 · Pelvis · sapphire · rakta · the hour

    private func buildPelvis() {
        let s = BandAir.scale
        let c = BandAir.centre
        let width = RoomUnits.extent * 0.9
        let plane = SCNPlane(width: CGFloat(width), height: CGFloat(width))
        let rings = RoomAir.lightMaterial("pulse rings", fragment: RoomAir.pulseRingsFragment)
        RoomAir.set(rings, "uW", width)
        RoomAir.set(rings, "uS", s)
        RoomAir.set(rings, "uBeat", 0)
        RoomAir.set(rings, "uSys", 0)
        plane.materials = [rings]
        let floor = SCNNode(geometry: plane)
        floor.name = "pulse rings"
        floor.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        floor.position = SCNVector3(Float(c.x), Float(RoomUnits.floorY + 0.03), Float(c.z))
        RoomAir.light(floor)
        root.addChildNode(floor)

        // `heart = sprite(…, 0xff5c6e, 12, 0.4)` and `beat = new PointLight(0xff4d5e, …)`
        let heart = RoomAir.glow("pulse", colour: BandAir.rgb(0xff5c6e), size: 12 * s, alpha: 0.4, hot: 1.2)
        heart.position = SCNVector3(Float(c.x), Float(RoomUnits.floorY + 1.2 * s * 3), Float(c.z))
        root.addChildNode(heart)
        let beat = RoomAir.omni("pulse light", colour: BandAir.rgb(0xff4d5e), reach: RoomUnits.roomHeight * 2.6)
        beat.position = heart.position
        root.addChildNode(beat)

        clockwork.append { t in
            // `const bpm = t * 1.05` · `const sys = pow(max(0, sin(bpm·π)), 6)`
            let bpm = t * 1.05
            let sys = pow(max(0, sin(bpm * .pi)), 6)
            RoomAir.set(rings, "uBeat", bpm)
            RoomAir.set(rings, "uSys", sys)
            heart.scale = RoomAir.uniform((10 + sys * 9) * s)
            RoomAir.set(heart, "uAlpha", 0.24 + sys * 0.5)
            beat.light?.intensity = CGFloat(400 + sys * 2_600)
        }
    }

    // MARK: - 3 · Navel · coral · māṃsa · the day

    private func buildNavel() {
        let s = BandAir.scale
        let c = BandAir.centre
        var rng = SeededAir(seed: 3)
        var dim: [SCNVector3] = [], hot: [SCNVector3] = []
        let total = plan.churnPoints
        for i in 0..<total {
            // `r = pow(random, 0.6) * 20` · `y = (random − 0.5) * 22`
            let r = pow(rng.next(), 0.6) * 20 * s
            let a = rng.next() * 2 * .pi
            let y = (rng.next() - 0.5) * 17 * s
            let p = SCNVector3(Float(cos(a) * r), Float(y), Float(sin(a) * r))
            if i % 7 == 0 { hot.append(p) } else { dim.append(p) }
        }
        let colour = SIMD3<Double>(1.0, 0.46, 0.32)
        var churns: [SCNMaterial] = []
        for (name, points, gain) in [("churn", dim, 0.34), ("churn · hot", hot, 1.9)] {
            let (node, material) = RoomAir.points(name, points, size: 0.07, maxPixels: 3.5,
                                               colour: colour, gain: gain,
                                               geometry: RoomAir.churnGeometry)
            RoomAir.set(material, "uScale", s)
            RoomAir.set(material, "uTime", 0)
            node.position = SCNVector3(Float(c.x), Float(c.y), Float(c.z))
            root.addChildNode(node)
            churns.append(material)
        }
        // `core = new PointLight(0xff6a44, 320, 40, 2)`
        let core = RoomAir.omni("churn light", colour: BandAir.rgb(0xff6a44), reach: RoomUnits.roomHeight * 2.4)
        core.position = SCNVector3(Float(c.x), Float(c.y), Float(c.z))
        root.addChildNode(core)
        clockwork.append { t in
            for m in churns { RoomAir.set(m, "uTime", t) }
            // `core.intensity = 280 + Math.sin(t * 0.4) * 90`
            core.light?.intensity = CGFloat((280 + sin(t * 0.4) * 90) * 6)
        }
    }

    // MARK: - 4 · Heart · diamond · medas · lunar fortnight

    private func buildHeart() {
        let s = BandAir.scale
        let c = BandAir.centre
        let width = RoomUnits.extent * 0.85
        let plane = SCNPlane(width: CGFloat(width), height: CGFloat(width))
        let caustic = RoomAir.lightMaterial("caustics", fragment: RoomAir.causticFragment)
        RoomAir.set(caustic, "uTime", 0)
        RoomAir.set(caustic, "uGain", 0.8)
        plane.materials = [caustic]
        let floor = SCNNode(geometry: plane)
        floor.name = "caustics"
        floor.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        floor.position = SCNVector3(Float(c.x), Float(RoomUnits.floorY + 0.03), Float(c.z))
        RoomAir.light(floor)
        root.addChildNode(floor)

        // The diamond: a clear octahedron, and its edges split three ways —
        // dispersion as the world's own condition.
        let prism = SCNNode()
        prism.name = "diamond"
        let radius = 2.4 * s * 1.3
        let body = RoomAir.octahedron(radius: radius)
        let glass = SCNMaterial()
        glass.name = "diamond"
        glass.lightingModel = .blinn
        glass.diffuse.contents = UIColor(white: 0.9, alpha: 1)
        glass.specular.contents = UIColor.white
        glass.shininess = 0.9
        glass.transparency = 0.22
        glass.transparencyMode = .dualLayer
        glass.fresnelExponent = 2.4
        glass.emission.contents = UIColor(white: 0.25, alpha: 1)
        glass.isDoubleSided = true
        glass.writesToDepthBuffer = false
        body.materials = [glass]
        let solid = SCNNode(geometry: body)
        solid.name = "diamond body"
        solid.castsShadow = false
        prism.addChildNode(solid)
        for (k, tint) in [SIMD3<Double>(1.0, 0.30, 0.30), SIMD3(0.30, 1.0, 0.54), SIMD3(0.42, 0.55, 1.0)].enumerated() {
            let edges = RoomAir.octahedron(radius: radius * (1.0 + 0.045 * Double(k + 1)))
            let m = RoomAir.lightMaterial("diamond edge", fragment: RoomAir.flatFragment)
            m.fillMode = .lines
            RoomAir.tint(m, tint, gain: 1.6)
            edges.materials = [m]
            let node = SCNNode(geometry: edges)
            node.name = "diamond edge"
            RoomAir.light(node)
            prism.addChildNode(node)
        }
        let spark = RoomAir.glow("diamond light", colour: SIMD3(1, 1, 1), size: radius * 3.2, alpha: 0.5, hot: 1.6)
        prism.addChildNode(spark)
        prism.position = SCNVector3(Float(-RoomUnits.roomHeight * 0.34),
                                    Float(RoomUnits.canopyY - RoomUnits.roomHeight * 0.24),
                                    Float(c.z - RoomUnits.roomHeight * 0.45))
        root.addChildNode(prism)

        clockwork.append { t in
            // `const fort = 0.5 + 0.5 * Math.sin(t * 0.0398)`
            let fort = 0.5 + 0.5 * sin(t * 0.0398)
            RoomAir.set(caustic, "uTime", t)
            // `m.material.opacity = 0.42 + 0.4 * fort`
            RoomAir.set(caustic, "uGain", (0.42 + 0.4 * fort) * 1.5)
            // `prism.rotation.set(t * 0.07, t * 0.11, 0)`
            prism.eulerAngles = SCNVector3(Float(t * 0.07), Float(t * 0.11), 0)
        }
    }

    // MARK: - 5 · Throat · emerald · asthi · lunar month

    private func buildThroat() {
        let s = BandAir.scale
        let c = BandAir.centre
        // The colonnade: seventy-two ribs, built as one and flattened into one
        // draw. `CylinderGeometry(0.34, 0.5, 20, 12)` at Design's scale.
        let bone = SCNMaterial()
        bone.name = "asthi"
        bone.lightingModel = .blinn
        bone.diffuse.contents = UIColor(red: 0.85, green: 0.91, blue: 0.82, alpha: 1)
        bone.specular.contents = UIColor(white: 0.18, alpha: 1)
        bone.shininess = 0.2
        let colonnade = SCNNode()
        for rib in BandAir.ribPlan() {
            // `s.set(1, 1 − ringIx * 0.1, 1)` — the outer rows shorten.
            let tall = RoomUnits.roomHeight * 1.04 * (1 - 0.1 * Double(rib.row))
            let cylinder = SCNCylinder(radius: CGFloat(0.42 * s), height: CGFloat(tall))
            cylinder.radialSegmentCount = 12
            cylinder.materials = [bone]
            let node = SCNNode(geometry: cylinder)
            node.position = SCNVector3(Float(rib.x), Float(RoomUnits.floorY + tall / 2), Float(rib.z))
            colonnade.addChildNode(node)
        }
        let ribs = colonnade.flattenedClone()
        ribs.name = "colonnade"
        ribs.castsShadow = true
        root.addChildNode(ribs)

        // The shafts between them — standing light, turned always to him.
        var shafts: [SCNNode] = []
        for i in 0..<plan.shafts {
            let gap: Double = Double.pi / 3.0
            let along: Double = (Double(i) + 1) / 24
            let theta: Double = -Double.pi + gap / 2 + along * (2 * Double.pi - gap)
            let r: Double = 10.6 * s
            let plane = SCNPlane(width: CGFloat(2.6 * s), height: CGFloat(RoomUnits.roomHeight))
            let m = RoomAir.lightMaterial("shaft", fragment: RoomAir.shaftFragment)
            RoomAir.set(m, "uAlpha", 0.1)
            plane.materials = [m]
            let node = SCNNode(geometry: plane)
            node.name = "shaft"
            node.position = SCNVector3(Float(c.x + r * sin(theta)),
                                       Float(RoomUnits.floorY + RoomUnits.roomHeight / 2),
                                       Float(c.z - r * cos(theta)))
            let turn = SCNBillboardConstraint()
            turn.freeAxes = .Y
            node.constraints = [turn]
            RoomAir.light(node)
            root.addChildNode(node)
            shafts.append(node)
        }

        // `above = DirectionalLight(0xd6ffe4)` is the room's key; the core is hers.
        let core = RoomAir.omni("colonnade light", colour: BandAir.rgb(0x2fe08a), reach: RoomUnits.roomHeight * 2.8)
        core.position = SCNVector3(Float(c.x), Float(c.y), Float(c.z))
        root.addChildNode(core)

        clockwork.append { t in
            // `const moon = 0.5 + 0.5 * Math.sin(t * 0.0199)`
            let moon = 0.5 + 0.5 * sin(t * 0.0199)
            for (i, shaft) in shafts.enumerated() {
                let flicker = 0.4 + 0.6 * abs(sin(t * 0.13 + Double(i) * 0.6))
                RoomAir.set(shaft, "uAlpha", (0.06 + 0.16 * moon * flicker) * 2.6)
            }
            // `core.intensity = 380 + moon * 620`
            core.light?.intensity = CGFloat((380 + moon * 620) * 2.4)
        }
    }

    // MARK: - 6 · Forehead · ruby · majjā · season

    private func buildForehead() {
        let s = BandAir.scale
        let shell = SCNMaterial()
        shell.name = "majja-shell"
        shell.lightingModel = .blinn
        shell.diffuse.contents = UIColor(red: 0.35, green: 0.04, blue: 0.09, alpha: 1)
        shell.specular.contents = UIColor(white: 0.5, alpha: 1)
        shell.shininess = 0.5
        shell.emission.contents = UIColor(red: 0.54, green: 0.05, blue: 0.11, alpha: 1)
        shell.emission.intensity = 2.2
        shell.transparency = 0.8
        shell.transparencyMode = .dualLayer
        shell.fresnelExponent = 1.6
        // Seen through, so the light inside it is not hidden by its own skin.
        shell.writesToDepthBuffer = false

        var lanterns: [SCNNode] = []
        var marrow: [SCNNode] = []
        for i in 0..<plan.lanterns {
            let sphere = SCNSphere(radius: CGFloat([2.6, 2.2, 2.8][i % 3] * s))
            sphere.isGeodesic = true
            sphere.segmentCount = [3, 2, 4][i % 3]
            sphere.materials = [shell]
            let node = SCNNode(geometry: sphere)
            node.name = "ruby lantern"
            node.castsShadow = false
            root.addChildNode(node)
            lanterns.append(node)
            let inner = RoomAir.glow("marrow", colour: BandAir.rgb(0xff3a52), size: 4.2 * s, alpha: 0.7, hot: 1.8)
            root.addChildNode(inner)
            marrow.append(inner)
        }
        // Design puts a light in every one; three carry the room's share of it.
        let lights = (0..<3).map { _ in
            RoomAir.omni("marrow light", colour: BandAir.rgb(0xff3a52), reach: RoomUnits.roomHeight * 1.6)
        }
        lights.forEach(root.addChildNode)

        clockwork.append { t in
            // `const season = 0.5 + 0.5 * Math.sin(t * 0.0066)`
            let season = 0.5 + 0.5 * sin(t * 0.0066)
            shell.emission.intensity = CGFloat(1.5 + season * 1.6)
            for (i, node) in lanterns.enumerated() {
                let p = BandAir.lanternPlace(i, at: t)
                let v = SCNVector3(Float(p.x), Float(p.y), Float(p.z))
                node.position = v
                node.eulerAngles = SCNVector3(Float(t * 0.04 + Double(i)), Float(t * 0.03 - Double(i)), 0)
                marrow[i].position = v
                RoomAir.set(marrow[i], "uAlpha", 0.45 + 0.4 * season * (0.6 + 0.4 * sin(t * 0.21 + Double(i))))
            }
            for (k, light) in lights.enumerated() {
                let i = k * 3 + 1
                light.position = lanterns[min(i, lanterns.count - 1)].position
                light.light?.intensity = CGFloat((240 + season * 420 * (0.6 + 0.4 * sin(t * 0.21 + Double(i)))) * 3)
            }
        }
    }

    // MARK: - 7 · Crown · pearl · śukra · solar half-year

    private func buildCrown() {
        let s = BandAir.scale
        let c = BandAir.centre
        var veils: [SCNNode] = []
        for i in 0..<plan.veils {
            let size = (40 + Double(i) * 12) * s * 0.55
            let veil = RoomAir.glow("pearl veil", colour: BandAir.rgb(0xfbf6ec), size: size, alpha: 0.07, hot: 0)
            let d = Double(i) - 2
            veil.position = SCNVector3(Float(c.x + d * 5 * s * 0.6),
                                       Float(c.y + d * 3.4 * s * 0.6),
                                       Float(c.z - (1 + Double(i) * 1.6) * s * 3))
            root.addChildNode(veil)
            veils.append(veil)
        }
        clockwork.append { t in
            // `const half = 0.5 + 0.5 * Math.sin(t * 0.0033)`
            let half = 0.5 + 0.5 * sin(t * 0.0033)
            for (i, veil) in veils.enumerated() {
                let di = Double(i)
                // Design's `0.08 + 0.1 · half · …`, at a little over half: the
                // fog this stands in is already pearl, and an additive veil
                // over it is the one light in the instrument that could carry
                // the room to white.
                RoomAir.set(veil, "uAlpha", (0.08 + 0.1 * half * (0.5 + 0.5 * sin(t * 0.05 + di))) * 0.55)
                veil.scale = RoomAir.uniform((40 + di * 12) * s * 0.55 * (1 + 0.05 * sin(t * 0.04 + di)))
            }
        }
    }

    // MARK: - 8 · Above crown · cat's eye · ojas · year

    private func buildAboveCrown() {
        let s = BandAir.scale
        let c = BandAir.centre
        // The shell of chatoyance, seen from outside its far half: Design's own
        // meridian shader, on a sphere standing in the room behind her.
        let sphere = SCNSphere(radius: CGFloat(RoomUnits.roomHeight))
        sphere.segmentCount = 48
        let band = RoomAir.lightMaterial("chatoyance", fragment: RoomAir.chatoyanceFragment)
        band.cullMode = .front
        band.isDoubleSided = false
        RoomAir.set(band, "uAngle", 0)
        RoomAir.set(band, "uGain", 1.4)
        sphere.materials = [band]
        let shell = SCNNode(geometry: sphere)
        shell.name = "chatoyance"
        shell.position = SCNVector3(Float(c.x), Float(c.y), Float(c.z))
        RoomAir.light(shell)
        root.addChildNode(shell)

        // `ridge` — the band itself, a bar of light across the room.
        let bar = SCNCylinder(radius: CGFloat(0.035), height: CGFloat(RoomUnits.roomHeight * 2.2))
        let barLight = RoomAir.lightMaterial("the band", fragment: RoomAir.flatFragment)
        RoomAir.tint(barLight, SIMD3(1.0, 0.94, 0.75), gain: 2.4)
        bar.materials = [barLight]
        let ridge = SCNNode(geometry: bar)
        ridge.name = "the band"
        RoomAir.light(ridge)
        let pivot = SCNNode()
        pivot.position = SCNVector3(Float(c.x), Float(c.y), Float(c.z))
        ridge.eulerAngles = SCNVector3(0, 0, Float.pi / 2)
        pivot.addChildNode(ridge)
        root.addChildNode(pivot)

        let sweep = RoomAir.omni("sweep", colour: BandAir.rgb(0xffe9a8), reach: RoomUnits.roomHeight * 3)
        root.addChildNode(sweep)
        let halo = RoomAir.glow("sweep halo", colour: BandAir.rgb(0xffe9a8), size: 24 * s, alpha: 0.28, hot: 0.8)
        root.addChildNode(halo)

        clockwork.append { t in
            // `const yr = t * 0.062`
            let yr = t * 0.062
            RoomAir.set(band, "uAngle", yr)
            pivot.eulerAngles = SCNVector3(0, Float(-yr), 0)
            let swell = abs(sin(yr * 2.0))
            let p = SCNVector3(Float(c.x + cos(yr) * 16 * s), Float(c.y), Float(c.z + sin(yr) * 16 * s))
            sweep.position = p
            sweep.light?.intensity = CGFloat((500 + swell * 900) * 2.2)
            halo.position = p
            halo.scale = RoomAir.uniform((24 + swell * 14) * s)
        }
    }

    // MARK: - 9 · Totality · all gems · tejas · kāla–akāla

    private func buildTotality() {
        let s = BandAir.scale
        let c = BandAir.centre
        var lamps: [SCNNode] = []
        for i in 0..<plan.gemLamps {
            let colour = BandAir.gemLampColours[i % BandAir.gemLampColours.count]
            let lamp = RoomAir.glow("gem lamp", colour: colour, size: 9 * s * 1.2, alpha: 0.55, hot: 1.6)
            root.addChildNode(lamp)
            lamps.append(lamp)
        }
        let lights = [0, 3, 6].map { i -> SCNNode in
            let colour = BandAir.gemLampColours[i]
            return RoomAir.omni("gem light", colour: colour, reach: RoomUnits.roomHeight * 2.2)
        }
        lights.forEach(root.addChildNode)

        // The yantra's own lines: three circles lying flat, three pairs of
        // triangles standing, turning together — `yantra.rotation.y = t * 0.008`.
        let yantra = SCNNode()
        yantra.name = "yantra"
        let lines = RoomAir.yantraLines(scale: s)
        let ink = RoomAir.lightMaterial("yantra", fragment: RoomAir.flatFragment)
        RoomAir.tint(ink, BandAir.rgb(0xfff6de), gain: 0.42)
        lines.materials = [ink]
        let drawn = SCNNode(geometry: lines)
        drawn.name = "yantra"
        RoomAir.light(drawn)
        yantra.addChildNode(drawn)
        yantra.position = SCNVector3(Float(c.x), Float(c.y), Float(c.z))
        root.addChildNode(yantra)

        clockwork.append { t in
            for (i, lamp) in lamps.enumerated() {
                let di = Double(i)
                // `const a = L.a + t * 0.014` · `r = 15 + sin(t * 0.05 + i) * 3.4`
                let a = di / 9 * 2 * .pi + t * 0.014
                let r = (15 + sin(t * 0.05 + di) * 3.4) * s
                lamp.position = SCNVector3(Float(c.x + cos(a) * r),
                                           Float(c.y + sin(di * 2.3 + t * 0.03) * 8 * s),
                                           Float(c.z + sin(a) * r))
                RoomAir.set(lamp, "uAlpha", 0.35 + 0.35 * (0.5 + 0.5 * sin(t * 0.19 + di * 0.7)))
            }
            for (k, light) in lights.enumerated() {
                let i = k * 3
                light.position = lamps[i].position
                light.light?.intensity = CGFloat((240 + 180 * (0.5 + 0.5 * sin(t * 0.19 + Double(i) * 0.7))) * 2.6)
            }
            yantra.eulerAngles = SCNVector3(0, Float(t * 0.008), 0)
        }
    }

    // MARK: - Motes, with hot centres

    static let moteColour: [Int: SIMD3<Double>] = [
        1: BandAir.rgb(0xffe0b0), 2: BandAir.rgb(0xbfd8ff), 6: BandAir.rgb(0xff8a9a),
        7: BandAir.rgb(0xfffaf0), 9: BandAir.rgb(0xfff6de),
    ]

    /// Design's `motes(count, spread, colour)` and `driftMotes(dust, t, amp)`:
    /// most of them faint, about one in seven hot enough to bloom.
    private func buildMotes(colour: SIMD3<Double>) {
        let c = BandAir.centre
        var rng = SeededAir(seed: UInt64(ring) &* 97 &+ 11)
        var dim: [SCNVector3] = [], hot: [SCNVector3] = []
        for i in 0..<plan.motes {
            let p = SCNVector3(Float((rng.next() - 0.5) * RoomUnits.extent * 0.55),
                               Float((rng.next() - 0.5) * RoomUnits.roomHeight * 0.95),
                               Float((rng.next() - 0.5) * RoomUnits.extent * 0.55))
            if i % 7 == 0 { hot.append(p) } else { dim.append(p) }
        }
        let amp = RoomAir.moteDrift[ring] ?? 0.4
        var drifting: [SCNMaterial] = []
        for (name, points, gain, size) in [("motes · air", dim, 0.55, 0.05), ("motes · hot", hot, 2.6, 0.09)] {
            let (node, material) = RoomAir.points(name, points, size: size, maxPixels: 4,
                                               colour: colour, gain: gain, geometry: RoomAir.driftGeometry)
            RoomAir.set(material, "uAmp", amp * BandAir.scale * 1.4)
            RoomAir.set(material, "uTime", 0)
            node.position = SCNVector3(Float(c.x), Float(c.y), Float(c.z))
            root.addChildNode(node)
            drifting.append(material)
        }
        clockwork.append { t in for m in drifting { RoomAir.set(m, "uTime", t) } }
    }

    /// `driftMotes(dust, t, amp)` — Design's own amplitude per band.
    static let moteDrift: [Int: Double] = [1: 0.5, 2: 0.4, 6: 0.34, 7: 0.3, 9: 0.5]
}

// MARK: - Making light bodies

extension RoomAir {

    /// A tiny white image, so every light body carries texture coordinates for
    /// its fragment modifier to read. Drawn, not loaded.
    static let texel: CGImage? = {
        let side = 4
        let pixels = [UInt8](repeating: 255, count: side * side * 4)
        guard let provider = CGDataProvider(data: Data(pixels) as CFData) else { return nil }
        return CGImage(width: side, height: side, bitsPerComponent: 8, bitsPerPixel: 32,
                       bytesPerRow: side * 4, space: CGColorSpaceCreateDeviceRGB(),
                       bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                       provider: provider, decode: nil, shouldInterpolate: false,
                       intent: .defaultIntent)
    }()

    /// A material whose fragment modifier writes the whole pixel, premultiplied,
    /// onto an additive blend.
    static func lightMaterial(_ name: String, fragment: String) -> SCNMaterial {
        let m = SCNMaterial()
        m.name = name
        m.lightingModel = .constant
        m.diffuse.contents = texel
        m.blendMode = .add
        m.writesToDepthBuffer = false
        m.isDoubleSided = true
        m.shaderModifiers = [.fragment: fragment]
        return m
    }

    /// A shader argument, seeded and written as `Float` — SceneKit keys an
    /// argument by the type it first sees.
    static func set(_ material: SCNMaterial, _ key: String, _ value: Double) {
        material.setValue(NSNumber(value: Float(value)), forKey: key)
    }

    /// The same, on a node's only material.
    static func set(_ node: SCNNode, _ key: String, _ value: Double) {
        guard let material = node.geometry?.firstMaterial else { return }
        set(material, key, value)
    }

    static func tint(_ material: SCNMaterial, _ colour: SIMD3<Double>, gain: Double) {
        set(material, "uR", colour.x)
        set(material, "uG", colour.y)
        set(material, "uB", colour.z)
        set(material, "uGain", gain)
    }

    static func uniform(_ size: Double) -> SCNVector3 {
        SCNVector3(Float(size), Float(size), Float(size))
    }

    /// Mark a node as light.
    static func light(_ node: SCNNode) {
        node.castsShadow = false
        RoomScene.markAsLight(node)
    }

    /// A glow: a soft halo with a hot centre, always turned to the eye.
    static func glow(_ name: String, colour: SIMD3<Double>, size: Double,
                     alpha: Double, hot: Double) -> SCNNode {
        let plane = SCNPlane(width: 1, height: 1)
        let m = lightMaterial(name, fragment: glowFragment)
        set(m, "uR", colour.x)
        set(m, "uG", colour.y)
        set(m, "uB", colour.z)
        set(m, "uAlpha", alpha)
        set(m, "uHot", hot)
        plane.materials = [m]
        let node = SCNNode(geometry: plane)
        node.name = name
        node.scale = uniform(size)
        node.constraints = [SCNBillboardConstraint()]
        light(node)
        return node
    }

    /// A point light in the air.
    static func omni(_ name: String, colour: SIMD3<Double>, reach: Double) -> SCNNode {
        let l = SCNLight()
        l.type = .omni
        l.color = UIColor(red: CGFloat(colour.x), green: CGFloat(colour.y), blue: CGFloat(colour.z), alpha: 1)
        l.intensity = 0
        l.attenuationStartDistance = 0
        l.attenuationEndDistance = CGFloat(reach)
        l.attenuationFalloffExponent = 2
        let node = SCNNode()
        node.name = name
        node.light = l
        return node
    }

    /// A cloud of points with a geometry modifier and one flat colour.
    static func points(_ name: String, _ positions: [SCNVector3], size: Double, maxPixels: Double,
                       colour: SIMD3<Double>, gain: Double,
                       geometry modifier: String) -> (SCNNode, SCNMaterial) {
        let source = SCNGeometrySource(vertices: positions)
        let element = SCNGeometryElement(indices: (0..<Int32(positions.count)).map { $0 },
                                         primitiveType: .point)
        element.pointSize = CGFloat(size)
        element.minimumPointScreenSpaceRadius = 0.7
        element.maximumPointScreenSpaceRadius = CGFloat(maxPixels)
        let material = SCNMaterial()
        material.name = name
        material.lightingModel = .constant
        material.blendMode = .add
        material.writesToDepthBuffer = false
        material.shaderModifiers = [.geometry: modifier, .fragment: flatFragment]
        tint(material, colour, gain: gain)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.materials = [material]
        let node = SCNNode(geometry: geometry)
        node.name = name
        light(node)
        return (node, material)
    }

    /// An octahedron with a flat face per side, outward-wound.
    static func octahedron(radius r: Double) -> SCNGeometry {
        let top = SIMD3<Double>(0, r, 0), bottom = SIMD3<Double>(0, -r, 0)
        let ring: [SIMD3<Double>] = [SIMD3(r, 0, 0), SIMD3(0, 0, r), SIMD3(-r, 0, 0), SIMD3(0, 0, -r)]
        var vertices: [SCNVector3] = []
        var normals: [SCNVector3] = []
        var indices: [Int32] = []
        for k in 0..<4 {
            let a = ring[k], b = ring[(k + 1) % 4]
            for apex in [top, bottom] {
                var triangle = [apex, a, b]
                var n = simd_normalize(simd_cross(triangle[1] - triangle[0], triangle[2] - triangle[0]))
                let centroid = (triangle[0] + triangle[1] + triangle[2]) / 3
                if simd_dot(n, centroid) < 0 {
                    triangle.swapAt(1, 2)
                    n = -n
                }
                for p in triangle {
                    indices.append(Int32(vertices.count))
                    vertices.append(SCNVector3(Float(p.x), Float(p.y), Float(p.z)))
                    normals.append(SCNVector3(Float(n.x), Float(n.y), Float(n.z)))
                }
            }
        }
        return SCNGeometry(sources: [SCNGeometrySource(vertices: vertices),
                                     SCNGeometrySource(normals: normals)],
                           elements: [SCNGeometryElement(indices: indices, primitiveType: .triangles)])
    }

    /// Design's Totality yantra as line segments: three circles lying flat,
    /// three pairs of triangles standing.
    static func yantraLines(scale s: Double) -> SCNGeometry {
        var vertices: [SCNVector3] = []
        var indices: [Int32] = []
        func loop(_ points: [SIMD3<Double>]) {
            let start = Int32(vertices.count)
            for p in points { vertices.append(SCNVector3(Float(p.x), Float(p.y), Float(p.z))) }
            let n = Int32(points.count)
            for i in 0..<n { indices.append(start + i); indices.append(start + (i + 1) % n) }
        }
        // `[7, 9.4, 12].forEach((r, i) => … l.position.y = y − 1 + i * 0.5)`
        for (i, r) in [7.0, 9.4, 12.0].enumerated() {
            let y = (-1 + Double(i) * 0.5) * s
            loop((0..<84).map { k -> SIMD3<Double> in
                let a = Double(k) / 84 * 2 * .pi
                return SIMD3(cos(a) * r * s, y, sin(a) * r * s)
            })
        }
        // `[[6.4, −2.6], [5.1, −2.1], [3.8, −1.5]]` — up and down, standing.
        for (i, pair) in [(6.4, -2.6), (5.1, -2.1), (3.8, -1.5)].enumerated() {
            let (ay, base) = pair
            let upY = (1 + Double(i) * 0.6) * s
            let downY = (1.3 + Double(i) * 0.6) * s
            loop([SIMD3(0, ay * s + upY, 0), SIMD3(ay * 0.92 * s, base * s + upY, 0),
                  SIMD3(-ay * 0.92 * s, base * s + upY, 0)])
            loop([SIMD3(0, -ay * s + downY, 0), SIMD3(ay * 0.92 * s, -base * s + downY, 0),
                  SIMD3(-ay * 0.92 * s, -base * s + downY, 0)])
        }
        return SCNGeometry(sources: [SCNGeometrySource(vertices: vertices)],
                           elements: [SCNGeometryElement(indices: indices, primitiveType: .line)])
    }
}

// MARK: - The shader modifiers
//
// Swift strings SceneKit compiles at run time, as the motes always have been.
// Each writes the whole pixel, premultiplied — `rgb · a, a` — so an additive
// blend adds exactly the light it means, and nothing here depends on how a
// lighting model folds ambient into diffuse.

extension RoomAir {

    /// One flat colour, at a gain that may run past one into the HDR buffer.
    static let flatFragment = """
    #pragma arguments
    float uR;
    float uG;
    float uB;
    float uGain;
    #pragma body
    float3 lit = float3(uR, uG, uB) * uGain;
    _output.color = float4(lit, saturate(max(lit.r, max(lit.g, lit.b))));
    """

    /// A glow: a soft halo, and a hot centre for the bloom to catch.
    static let glowFragment = """
    #pragma arguments
    float uR;
    float uG;
    float uB;
    float uAlpha;
    float uHot;
    #pragma body
    float2 d = _surface.diffuseTexcoord - float2(0.5, 0.5);
    float r = length(d) * 2.0;
    float halo = pow(saturate(1.0 - r), 2.4);
    float core = exp(-r * r * 22.0) * uHot;
    float a = (halo * 0.6 + core) * uAlpha;
    _output.color = float4(float3(uR, uG, uB) * a, saturate(a));
    """

    /// Pelvis: seven rings travelling out on the pulse, through cold blue.
    static let pulseRingsFragment = """
    #pragma arguments
    float uW;
    float uS;
    float uBeat;
    float uSys;
    #pragma body
    float2 d = (_surface.diffuseTexcoord - float2(0.5, 0.5)) * uW;
    float r = length(d);
    float lit = 0.0;
    for (int i = 0; i < 7; i++) {
        float p = fract(uBeat * 0.5 + float(i) / 7.0);
        float rr = (1.4 + p * 27.0) * uS;
        float w = 0.05 + 0.08 * p;
        float x = (r - rr) / w;
        lit += exp(-x * x) * (1.0 - p) * 0.62 * (0.4 + 0.6 * uSys);
    }
    float edge = saturate(1.0 - r / (uW * 0.5));
    float3 col = (float3(1.0, 0.36, 0.43) * lit * 1.8 + float3(0.10, 0.18, 0.42) * 0.10) * edge;
    _output.color = float4(col, saturate(max(col.r, max(col.g, col.b))));
    """

    /// Heart: caustics in three separated spectra, each on its own drift.
    static let causticFragment = """
    #pragma arguments
    float uTime;
    float uGain;
    #pragma body
    float2 uv = _surface.diffuseTexcoord;
    float2 p = uv * 7.0;
    float t = uTime;
    float2 q0 = p * 1.00 + float2(sin(t * 0.037), cos(t * 0.029)) * 2.4;
    float a0 = sin(q0.x + sin(q0.y * 1.7 + t * 0.21));
    float b0 = sin(q0.y + sin(q0.x * 1.3 - t * 0.17));
    float c0 = pow(saturate(1.0 - abs(a0 + b0) * 0.9), 7.0);
    float2 q1 = p * 1.11 + float2(sin(t * 0.041 + 1.0), cos(t * 0.032 + 2.0)) * 2.4 + float2(2.1, 0.7);
    float a1 = sin(q1.x + sin(q1.y * 1.7 + t * 0.21 + 2.1));
    float b1 = sin(q1.y + sin(q1.x * 1.3 - t * 0.17 + 2.1));
    float c1 = pow(saturate(1.0 - abs(a1 + b1) * 0.9), 7.0);
    float2 q2 = p * 1.22 + float2(sin(t * 0.045 + 2.0), cos(t * 0.035 + 4.0)) * 2.4 + float2(4.2, 1.3);
    float a2 = sin(q2.x + sin(q2.y * 1.7 + t * 0.21 + 4.2));
    float b2 = sin(q2.y + sin(q2.x * 1.3 - t * 0.17 + 4.2));
    float c2 = pow(saturate(1.0 - abs(a2 + b2) * 0.9), 7.0);
    float3 col = float3(1.0, 0.30, 0.30) * c0 + float3(0.30, 1.0, 0.54) * c1 + float3(0.42, 0.55, 1.0) * c2;
    float e = length(uv - float2(0.5, 0.5)) * 2.0;
    col *= saturate(1.0 - e * e) * uGain;
    _output.color = float4(col, saturate(max(col.r, max(col.g, col.b))));
    """

    /// Throat: a shaft of light, soft across and fading at both ends.
    static let shaftFragment = """
    #pragma arguments
    float uAlpha;
    #pragma body
    float2 uv = _surface.diffuseTexcoord;
    float x = (uv.x - 0.5) * 3.6;
    float across = exp(-x * x);
    float along = pow(saturate(sin(uv.y * 3.14159265)), 0.6);
    float a = across * along * uAlpha;
    _output.color = float4(float3(0.56, 0.95, 0.72) * a, saturate(a));
    """

    /// Above the crown: Design's meridian, verbatim but for its coordinates —
    /// one band of light on a shell, and a faint haze at its equator.
    static let chatoyanceFragment = """
    #pragma arguments
    float uAngle;
    float uGain;
    #pragma body
    float2 uv = _surface.diffuseTexcoord;
    float phi = uv.x * 6.2831853;
    float lat = (0.5 - uv.y) * 3.14159265;
    float3 n = float3(cos(phi) * cos(lat), sin(lat), sin(phi) * cos(lat));
    float2 axis = float2(cos(uAngle), sin(uAngle));
    float d = abs(dot(n.xz, axis));
    float band = pow(saturate(1.0 - d), 22.0);
    float haze = pow(max(0.0, 1.0 - abs(n.y)), 2.0) * 0.16;
    float3 col = mix(float3(0.20, 0.15, 0.06), float3(1.0, 0.90, 0.58), band);
    float a = (band * 0.95 + haze) * uGain;
    _output.color = float4(col * a, saturate(a));
    """

    /// Navel: Design's cheap curl — three offset sines that never repeat cleanly
    /// — on the band's own clock, in Design's units.
    static let churnGeometry = """
    #pragma arguments
    float uTime;
    float uScale;
    #pragma body
    float3 p = _geometry.position.xyz / uScale;
    float sd = fract(sin(dot(_geometry.position.xyz, float3(12.9898, 78.233, 37.719))) * 43758.5453) * 6.2831853;
    float t = uTime + sd;
    float3 v = float3(sin(p.y * 0.19 + t * 0.5) + cos(p.z * 0.14 - t * 0.31),
                      sin(p.z * 0.16 + t * 0.42) + cos(p.x * 0.12 - t * 0.27),
                      sin(p.x * 0.17 - t * 0.36) + cos(p.y * 0.13 + t * 0.29));
    float3 q = p * 2.1;
    float t2 = uTime * 0.7;
    float3 w = float3(sin(q.y * 0.19 + t2 * 0.5) + cos(q.z * 0.14 - t2 * 0.31),
                      sin(q.z * 0.16 + t2 * 0.42) + cos(q.x * 0.12 - t2 * 0.27),
                      sin(q.x * 0.17 - t2 * 0.36) + cos(q.y * 0.13 + t2 * 0.29));
    p += v * 2.6 + w * 0.9;
    _geometry.position.xyz = p * uScale;
    """

    /// `driftMotes(dust, t, amp)`.
    static let driftGeometry = """
    #pragma arguments
    float uTime;
    float uAmp;
    #pragma body
    float s = _geometry.position.x * 12.9898 + _geometry.position.z * 78.233;
    float ph = fract(sin(s) * 43758.5453) * 6.2831853;
    _geometry.position.y += sin(uTime * 0.14 + ph) * uAmp;
    _geometry.position.x += cos(uTime * 0.09 + ph) * uAmp * 0.5;
    """
}

// MARK: - Her light at her mark

/// The core and halo of light that stand at her mark, at one moment of the
/// stay. Pure, so the stay's arc can be asserted: the core is hottest once the
/// eye has settled and softens past the second adaptation, while the halo
/// widens — the mark becoming the room rather than hardening into a lamp.
struct HerLight: Equatable {
    let coreSize: Double
    let coreAlpha: Double
    let haloSize: Double
    let haloAlpha: Double

    static func at(settling k: Double, deep b: Double) -> HerLight {
        let k = min(1, max(0, k)), b = min(1, max(0, b))
        let h = RoomUnits.roomHeight
        return HerLight(coreSize: h * 0.11 * (1 + 0.4 * k),
                        coreAlpha: (0.35 + 0.5 * k) * (1 - 0.45 * b),
                        haloSize: h * 0.30 * (1 + 0.35 * b),
                        haloAlpha: (0.16 + 0.20 * k) * (1 - 0.40 * b))
    }
}

/// A small deterministic generator, so the same world is the same air on every
/// launch — the principle ``Atmosphere`` jitters a hue by.
struct SeededAir {
    private var state: UInt64
    init(seed: UInt64) { state = seed &* 2_654_435_761 | 1 }
    mutating func next() -> Double {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return Double((state >> 33) % 100_000) / 100_000
    }
}
