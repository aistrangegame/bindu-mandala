import SwiftUI
import SwiftData

/// Top-level container with the three-tab custom bar (Today · Mandala · The Well).
/// Mandala and The Well are placeholder shells until Phases 4 / 7.
struct RootView: View {
    @Environment(\.modelContext) private var context
    @State private var selected: Tab = Self.initialTab()

    enum Tab { case today, mandala, well }

    private static func initialTab() -> Tab {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("START_TAB=mandala") { return .mandala }
        if args.contains("START_TAB=well")    { return .well }
        return .today
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.ground.ignoresSafeArea()
                switch selected {
                case .today:
                    TodayView()
                case .mandala:
                    MandalaScreenView(
                        onPetalTap: { _ in
                            // Phase 5: present Shakti Detail.
                        },
                        onBinduTap: {
                            // Phase 6: present Silence screen.
                        }
                    )
                case .well:
                    WellView()
                }
            }

            CustomTabBar(selected: $selected)
        }
        .background(Color.ground.ignoresSafeArea())
        .task {
            ShaktiBootstrap.seedIfNeeded(context: context)
            await AirtableService.shared.sync(context: context)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selected: RootView.Tab

    var body: some View {
        HStack {
            tabButton(.today, label: "Today",   icon: AnyView(TodayIcon()))
            tabButton(.mandala, label: "Mandala", icon: AnyView(MandalaIcon()))
            tabButton(.well, label: "The Well", icon: AnyView(WellIcon()))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background(
            LinearGradient(
                colors: [Color.ground.opacity(0.85), Color.ground.opacity(0.98)],
                startPoint: .top, endPoint: .bottom
            )
            .overlay(Rectangle().fill(Color.gold.opacity(0.15)).frame(height: 0.5), alignment: .top)
        )
    }

    @ViewBuilder
    private func tabButton(_ tab: RootView.Tab, label: String, icon: AnyView) -> some View {
        let active = selected == tab
        Button {
            Haptics.light()
            selected = tab
        } label: {
            VStack(spacing: 3) {
                icon
                    .frame(width: 24, height: 24)
                    .foregroundStyle(active ? Color.gold : Color.cream.opacity(0.32))
                Text(label.uppercased())
                    .font(.system(size: 10, weight: .regular))
                    .tracking(0.8)
                    .foregroundStyle(active ? Color.gold : Color.cream.opacity(0.32))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

private struct TodayIcon: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            var p = Path()
            p.move(to: CGPoint(x: w * 0.5, y: h * 0.125))
            p.addQuadCurve(to: CGPoint(x: w * 0.75, y: h * 0.54),
                           control: CGPoint(x: w * 0.75, y: h * 0.29))
            p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.875),
                           control: CGPoint(x: w * 0.75, y: h * 0.75))
            p.addQuadCurve(to: CGPoint(x: w * 0.25, y: h * 0.54),
                           control: CGPoint(x: w * 0.25, y: h * 0.75))
            p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.125),
                           control: CGPoint(x: w * 0.25, y: h * 0.29))
            ctx.stroke(p, with: .color(.primary), lineWidth: 1.3)
            let dot = Path(ellipseIn: CGRect(x: w * 0.5 - 2.5, y: h * 0.54 - 2.5, width: 5, height: 5))
            ctx.fill(dot, with: .color(.primary.opacity(0.7)))
        }
    }
}

private struct MandalaIcon: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2, cy = size.height / 2
            for a in stride(from: 0.0, to: 360.0, by: 45.0) {
                ctx.translateBy(x: cx, y: cy)
                ctx.rotate(by: .degrees(a))
                var petal = Path()
                petal.move(to: CGPoint(x: 0, y: -2.5))
                petal.addCurve(to: CGPoint(x: 0, y: -11),
                               control1: CGPoint(x: 2, y: -5),
                               control2: CGPoint(x: 2, y: -9.5))
                petal.addCurve(to: CGPoint(x: 0, y: -2.5),
                               control1: CGPoint(x: -2, y: -9.5),
                               control2: CGPoint(x: -2, y: -5))
                ctx.fill(petal, with: .color(.primary.opacity(0.7)))
                ctx.rotate(by: .degrees(-a))
                ctx.translateBy(x: -cx, y: -cy)
            }
            let bindu = Path(ellipseIn: CGRect(x: cx - 2, y: cy - 2, width: 4, height: 4))
            ctx.fill(bindu, with: .color(.primary))
        }
    }
}

private struct WellIcon: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2, cy = size.height / 2
            ctx.stroke(Path(ellipseIn: CGRect(x: cx - 9, y: cy - 9, width: 18, height: 18)),
                       with: .color(.primary), lineWidth: 1.3)
            ctx.stroke(Path(ellipseIn: CGRect(x: cx - 5.5, y: cy - 5.5, width: 11, height: 11)),
                       with: .color(.primary.opacity(0.6)), lineWidth: 1)
            ctx.fill(Path(ellipseIn: CGRect(x: cx - 2, y: cy - 2, width: 4, height: 4)),
                     with: .color(.primary.opacity(0.5)))
        }
    }
}

