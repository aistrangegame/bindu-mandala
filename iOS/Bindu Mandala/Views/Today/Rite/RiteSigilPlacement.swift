import CoreGraphics

/// Where the Rite's sigil stands, and how large — `TdSigil`, measured.
///
/// Design positions the sigil's *unscaled* box against an edge (`bottom: -40`,
/// `right: -220`, `top: 46%`) and then scales it about its own centre with
/// `transform: scale(s)`. So the centre is fixed by the placement and the size
/// grows around it. The first port anchored the *scaled* box to the edge
/// instead, which moved every sigil whose scale was not 1 — that is, all of
/// them. This is the placement as Design computes it, in points, for any box.
///
/// Pure, so the placements are asserted in `DayLightTests`.
struct RiteSigilFrame: Equatable {
    /// The sigil's centre in the box.
    let center: CGPoint
    /// Its drawn side, after every scale.
    let size: CGFloat
    /// The factor its strokes thicken by (`transform: scale(…)` on the SVG).
    let lineScale: CGFloat
}

enum RiteSigilPlacement {
    /// The frame Design's numbers were authored in (a standard iPhone width).
    static let referenceWidth: CGFloat = 390

    /// `TdSigil`'s base sizes: 760 for the earth's wide base, 560 for the
    /// radiance's point, 620 otherwise.
    static func baseSize(_ p: SigilPlacement) -> CGFloat {
        switch p {
        case .bottomBig: return 760
        case .centerBig: return 560
        default:         return 620
        }
    }

    /// - Parameters:
    ///   - flip: the composition's `flip`. Design's `left = !flip`: when the
    ///     words lean left, the sigil stands off the right edge.
    static func frame(for p: SigilPlacement, planScale: Double, compScale: Double,
                      flip: Bool, in box: CGSize) -> RiteSigilFrame {
        let k = min(box.width, box.height) / referenceWidth
        let base = baseSize(p) * k
        let half = base / 2
        let w = box.width, h = box.height
        var s = CGFloat(planScale * compScale)

        let center: CGPoint
        switch p {
        case .bottom:     center = CGPoint(x: w / 2, y: h + 40 * k - half)
        case .bottomWide: center = CGPoint(x: w / 2, y: h + 140 * k - half)
        case .bottomBig:  center = CGPoint(x: w / 2, y: h + 220 * k - half)
        case .side:
            let x = flip ? (-220 * k + half) : (w + 220 * k - half)
            center = CGPoint(x: x, y: h * 0.40)
        case .centerBig:  center = CGPoint(x: w / 2, y: h * 0.46)
        case .center:
            center = CGPoint(x: w / 2, y: h * 0.46)
            s *= 0.95
        }
        return RiteSigilFrame(center: center, size: base * s, lineScale: k * s)
    }

    /// The air plan's horizon line sits at 43% of the height.
    static let horizonY: CGFloat = 0.43
}
