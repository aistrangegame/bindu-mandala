// Measuring apparatus, not part of the app. The whole Spike folder is compiled
// out of Release, so nothing here — including SpikeBench's hiding and restoring of
// the practitioner's own window — can exist in a build that reaches Neev. The test
// action builds Debug, so every spike test still sees it.
#if DEBUG
import CoreGraphics
import Foundation

/// A per-frame census of the draw primitives the shipped `MandalaCanvasLayer`
/// issues into its `GraphicsContext`.
///
/// **This is a model, not an interception.** `GraphicsContext` is a struct with no
/// seam to wrap, and the spike is forbidden to touch the shipped canvas, so the
/// only honest way to count its primitives is to re-walk the same branch and
/// culling conditions the shipped `draw*` methods walk, from the same inputs, and
/// say plainly that that is what this is. The count is therefore exact for the
/// *structure* of the shipped draw — every `ctx.fill`, `ctx.stroke` and `ctx.draw`
/// it would issue for a given camera, field and clock — and carries no claim about
/// what the GPU then does with them (a radial-gradient fill and a 1 px line are one
/// primitive each here and nothing like each other downstream).
///
/// `MandalaDrawCensusTests` pins it against the shipped source's invariants, so a
/// future edit to the canvas that drifts from this model fails a test rather than
/// quietly poisoning a comparison.
enum MandalaDrawCensus {

    struct Tally {
        var stars = 0
        var enclosures = 0
        var todayRing = 0
        var flash = 0
        var yantra = 0
        var constellation = 0
        var seatFlares = 0
        var seatGlows = 0
        var seatDots = 0
        var seatHalos = 0
        var seatNames = 0
        var seatBijas = 0
        var enclosureNames = 0
        var binduGlow = 0

        var total: Int {
            stars + enclosures + todayRing + flash + yantra + constellation
                + seatFlares + seatGlows + seatDots + seatHalos + seatNames + seatBijas
                + enclosureNames + binduGlow
        }

        /// Fills, strokes and text draws split out — the three cost families differ.
        var fills: Int { stars + seatFlares + seatGlows + seatDots + binduGlow }
        var strokes: Int { enclosures + todayRing + flash + yantra + constellation + seatHalos }
        var texts: Int { seatNames + seatBijas + enclosureNames }

        var breakdown: String {
            "total \(total) = fills \(fills) · strokes \(strokes) · text \(texts)"
                + " [stars \(stars), enclosures \(enclosures), todayRing \(todayRing), flash \(flash),"
                + " yantra \(yantra), threads \(constellation), flares \(seatFlares), glows \(seatGlows),"
                + " dots \(seatDots), halos \(seatHalos), names \(seatNames), bījas \(seatBijas),"
                + " enclosureNames \(enclosureNames), bindu \(binduGlow)]"
        }
    }

    /// One seat reduced to the four facts the census actually branches on.
    ///
    /// `Shakti` is a SwiftData `@Model`, and every property read on one goes through
    /// the persistence accessors. A 20-second window samples about 1,200 frames, and
    /// re-reading 102 models per frame put ~10 seconds of accessor traffic on the
    /// main actor — long enough that `testmanagerd` judged the host unresponsive and
    /// killed it mid-bench with `signal kill`. Snapshotting once costs nothing and
    /// is also more honest: the census is a model of the draw structure and has no
    /// business measuring the store.
    struct SeatSnapshot {
        let kp: Int
        let point: CGPoint
        let ring: Int
        let hasBija: Bool
    }

    static func snapshot(_ seats: [MandalaWorld.Seat]) -> [SeatSnapshot] {
        seats.map {
            SeatSnapshot(kp: $0.shakti.khadgamalaPosition ?? $0.shakti.position,
                         point: $0.point,
                         ring: $0.shakti.ringNumber ?? 2,
                         hasBija: $0.shakti.bijaSyllable != nil)
        }
    }

    /// Everything the shipped canvas is handed for a frame.
    struct Input {
        var camera: MandalaCamera
        var size: CGSize
        var seats: [SeatSnapshot]
        var todayKp: Int
        var focusKp: Int?
        var familyKp: Set<Int>
        var felt: Set<Int>
        /// Phase 5's switch. The lit path draws each enclosure as a band of three
        /// strokes rather than one hairline, and the Bindu gains the gaze's two
        /// marks; every seat branch is unchanged.
        var lightOn: Bool = false
        /// 0…1 of the gaze (idea 38). At a full gaze the field holds still, so
        /// the per-seat flare and the expanding halo stop being issued.
        var tratak: Double = 0
        var flashRing: Int?
        var flashBornAt: TimeInterval?
        var constellation: Double
        var constellationStart: TimeInterval?
        var reduceMotion: Bool
        /// The absolute time the canvas would read from its own TimelineView.
        var t: TimeInterval
    }

    static func tally(_ i: Input) -> Tally {
        var c = Tally()
        let cam = i.camera
        let scale = cam.scale
        let tier = cam.tier
        let center = cam.screen(for: .zero)

        // drawStarfield — 120 deterministic stars, culled to the viewport + 20pt.
        for star in MandalaStars.all {
            let s = cam.screen(for: star.p)
            guard s.x > -20, s.x < i.size.width + 20, s.y > -20, s.y < i.size.height + 20 else { continue }
            c.stars += 1
        }

        // drawEnclosures — rings 2…8, dropped once the circle shrinks under 4pt.
        // With the light on each enclosure is a band — a core and two flanks.
        let perEnclosure = i.lightOn ? 3 : 1
        for ring in 2...8 where MandalaWorld.ringRadius(ring) * scale > 4 { c.enclosures += perEnclosure }

        // drawTodayRing — one dashed circle, only if today's seat is on a ring with radius.
        if let seat = i.seats.first(where: { $0.kp == i.todayKp }),
           MandalaWorld.ringRadius(seat.ring) > 0 {
            c.todayRing = 1
        }

        // drawFlash — one ring, alive for 1.5s after a crossing.
        if let ring = i.flashRing, let born = i.flashBornAt,
           MandalaWorld.ringRadius(ring) > 0 {
            let age = i.t - born
            if age >= 0, age < 1.5 { c.flash = 1 }
        }

        // drawYantra — three nested squares plus the nine interlocking triangles.
        // Never culled: the shipped code strokes all twelve at every zoom.
        c.yantra = 3 + MandalaYantra.triangles.count

        // drawConstellation — one thread per family seat once a seat is focused.
        if let focusKp = i.focusKp,
           i.seats.contains(where: { $0.kp == focusKp }),
           i.constellation > 0 {
            let family = i.seats.filter { i.familyKp.contains($0.kp) }
                .sorted { $0.kp < $1.kp }
            for (idx, _) in family.enumerated() {
                let prog: Double
                if i.reduceMotion || i.constellationStart == nil {
                    prog = i.constellation
                } else {
                    let raw = (i.t - i.constellationStart! - 0.05 - Double(idx) * 0.035) / 0.7
                    let p01 = min(max(raw, 0), 1)
                    prog = 1 - pow(1 - p01, 3)
                }
                if prog > 0 { c.constellation += 1 }
            }
        }

        // drawSeats — the expensive layer. Culled generously, then up to six
        // primitives per surviving seat.
        for seat in i.seats {
            let kp = seat.kp
            let s = cam.screen(for: seat.point)
            guard s.x > -40, s.x < i.size.width + 40,
                  s.y > -60, s.y < i.size.height + 80 else { continue }

            let isFocus = kp == i.focusKp
            let isToday = kp == i.todayKp
            let inFamily = i.familyKp.contains(kp)
            let felt = i.felt.contains(kp)
            let dimmed = i.focusKp != nil && !isFocus && !inFamily
            let lit = felt || isToday || isFocus || inFamily

            // The shipped canvas sizes each dot from `baseR`, the camera scale and a
            // per-seat breath. None of that changes how many primitives it issues,
            // so the census does not recompute it — only the branches are mirrored.

            let quiet = 1 - (i.lightOn ? min(max(i.tratak, 0), 1) : 0)
            if !i.reduceMotion, quiet > 0.001 {
                let fDur = 8.0 + Double(kp % 13)
                let ph = (i.t + Double(kp) * 0.37).truncatingRemainder(dividingBy: fDur) / fDur
                let flareO: Double = (ph < 0.06 ? (ph / 0.06) * 0.55
                    : ph < 0.22 ? (1 - (ph - 0.06) / 0.16) * 0.55 : 0) * quiet
                if flareO > 0.001 { c.seatFlares += 1 }
            }
            if lit { c.seatGlows += 1 }
            c.seatDots += 1
            if isToday || isFocus { c.seatHalos += 1 }

            let showName = tier >= 1 || inFamily || isFocus
            if showName && !dimmed {
                c.seatNames += 1
                if tier >= 2, !isFocus, seat.hasBija { c.seatBijas += 1 }
            }
        }

        // drawEnclosureNames — nine āvaraṇa titles once the mid zoom resolves.
        if tier >= 1 {
            for ring in 1...9 {
                let rr = MandalaWorld.ringRadius(ring) * scale
                let y = ring == 9 ? center.y + 18 : center.y - rr - 9
                if y > -20, y < i.size.height + 20 { c.enclosureNames += 1 }
            }
        }

        // drawBinduGlow — the haze always, plus the gaze's white light behind
        // the point and the point itself once Tratak has begun.
        c.binduGlow = 1
        if i.lightOn, i.tratak > 0.001 { c.binduGlow += 2 }
        return c
    }
}
#endif
