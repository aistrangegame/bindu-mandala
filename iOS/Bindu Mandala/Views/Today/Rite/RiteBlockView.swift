import SwiftUI

/// Everything the Rite's blocks need to render, gathered once per day.
struct RiteRenderContext {
    let content: RiteContent
    let atmosphere: Atmosphere
    let plan: RitePlan
    let nameSize: Double
    let align: HorizontalAlignment
    let textAlign: TextAlignment
    let leadingEdge: Bool          // for lean: name/hairline hug this edge
    let onOpenDetail: () -> Void
}

/// One block of the Daily Rite. The *set* of blocks is constant; the plan decides
/// their order, alignment, and weight — so a fire Śakti and a water Śakti are
/// structurally different, not the same layout re-skinned.
struct RiteBlockView: View {
    let kind: RiteBlock
    let ctx: RiteRenderContext

    private var atmo: Atmosphere { ctx.atmosphere }
    private var c: RiteContent { ctx.content }

    var body: some View {
        switch kind {
        case .kicker:      kicker
        case .name:        name(size: ctx.nameSize)
        case .nameSmall:   name(size: 27)
        case .phon:        phon
        case .know:        know
        case .rule:        rule
        case .quality:     quality
        case .prompt:      prompt
        }
    }

    // MARK: - Blocks

    private var kicker: some View {
        HStack(spacing: 10) {
            if c.hasCluster {
                Circle().fill(atmo.accent).frame(width: 8, height: 8)
            }
            Text(kickerLabel.uppercased())
                .font(AppFont.label(11.5))
                .tracking(3.0)
                .foregroundStyle(atmo.accentBright)
        }
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity, alignment: alignment)
    }

    private var kickerLabel: String {
        let base = "\(RiteContent.ordinal(c.ring).capitalized) Āvaraṇa"
        if c.hasCluster, let cl = c.cluster { return "\(base) · \(cl.label)" }
        return base
    }

    private func name(size: Double) -> some View {
        Button(action: ctx.onOpenDetail) {
            Text(c.name)
                .font(AppFont.sanskrit(size))
                .fontWeight(.light)
                .tracking(size * 0.05)
                .lineSpacing(2)
                .foregroundStyle(Color.cream)
                .shadow(color: atmo.glow, radius: 26)
                .multilineTextAlignment(ctx.textAlign)
                .lineLimit(3)
                .minimumScaleFactor(0.55)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: alignment)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(c.spokenName) — open her presence")
    }

    @ViewBuilder private var phon: some View {
        if let p = c.phonetic {
            Text(p.uppercased())
                .font(AppFont.label(12.5))
                .tracking(3.0)
                .foregroundStyle(Color.cream.opacity(0.5))
                .padding(.top, 12)
                .frame(maxWidth: .infinity, alignment: alignment)
        }
    }

    private var know: some View {
        Button(action: ctx.onOpenDetail) {
            Text("know her ›")
                .font(AppFont.voice(15))
                .tracking(0.9)
                .foregroundStyle(atmo.accentBright.opacity(0.92))
                // **It is read against her own ghost.** This line is centred
                // over the huge translucent name behind it, so its contrast is
                // not its alpha against the ground but its alpha against
                // whatever stroke of her name happens to run under it — and it
                // is now the first rung of the only ladder into the rooms
                // layer. The name itself is carried on a shadow for exactly
                // this reason; so is this. No size, padding or alpha changes,
                // so nothing on the screen moves.
                .shadow(color: .black.opacity(0.85), radius: 10)
                .padding(.vertical, 12)
                .padding(.top, 2)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: alignment)
    }

    private var rule: some View {
        Rectangle()
            .fill(atmo.accentSoft)
            .frame(width: 54, height: 0.6)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    @ViewBuilder private var quality: some View {
        if !c.quality.isEmpty {
            Text(c.quality)
                .font(AppFont.sanskrit(25))
                .lineSpacing(4)
                .foregroundStyle(atmo.accentBright)
                .multilineTextAlignment(ctx.textAlign)
                .frame(maxWidth: 330, alignment: alignment)
                .frame(maxWidth: .infinity, alignment: alignment)
        }
    }

    private var prompt: some View {
        Text("\u{201C}\(c.prompt)\u{201D}")
            .font(AppFont.voice(20))
            .lineSpacing(6)
            .foregroundStyle(Color.cream.opacity(0.82))
            .multilineTextAlignment(ctx.textAlign)
            .frame(maxWidth: 310, alignment: alignment)
            .padding(.top, 20)
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    private var alignment: Alignment {
        switch ctx.align {
        case .leading:  return .leading
        case .trailing: return .trailing
        default:        return .center
        }
    }
}
