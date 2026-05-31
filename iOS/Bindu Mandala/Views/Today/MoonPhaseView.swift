import SwiftUI

struct MoonPhaseView: View {
    var date: Date = .now
    var size: CGFloat = 22

    var body: some View {
        HStack(spacing: 9) {
            moonGlyph
                .accessibilityHidden(true)   // label is on the parent
            Text(LunarPhaseService.headerLabel(at: date).uppercased())
                .font(.system(size: 11, weight: .regular))
                .tracking(1.4)
                .foregroundStyle(Color.cream.opacity(0.55))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Moon phase: \(LunarPhaseService.headerLabel(at: date))")
    }

    /// Crescent rendered with a mask offset to match the illuminated fraction.
    private var moonGlyph: some View {
        let illum = LunarPhaseService.illumination(at: date)         // 0…1
        let waxing = LunarPhaseService.phaseFraction(at: date) < 0.5
        let offset = (waxing ? 1 : -1) * (1 - illum) * size * 0.85
        return ZStack {
            Circle()
                .stroke(Color.gold.opacity(0.4), lineWidth: 0.5)
                .frame(width: size, height: size)
            Circle()
                .fill(Color.gold.opacity(0.85))
                .frame(width: size, height: size)
                .mask(
                    ZStack {
                        Circle().frame(width: size, height: size)
                        Circle()
                            .frame(width: size, height: size)
                            .offset(x: offset)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                )
        }
        .frame(width: size, height: size)
    }
}
