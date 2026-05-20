import SwiftUI
import SwiftData

/// The Mandala tab — the full 16-petal lotus as navigation + progress map.
struct MandalaScreenView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]

    /// Optional external taps (kept for RootView compatibility — local
    /// presentation is preferred so the Mandala owns its destinations).
    var onPetalTap: ((Int) -> Void)? = nil
    var onBinduTap: (() -> Void)? = nil

    @State private var detailFor: Shakti?
    @State private var showSilence = false
    @State private var hasAppliedLaunchArgs = false

    private var todayIndex: Int {
        LunarPhaseService.todayPetalIndex()
    }

    private var activeCount: Int {
        shaktis.filter { $0.status == .active }.count
    }
    private var embodiedCount: Int {
        shaktis.filter { $0.status == .embodied }.count
    }

    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $detailFor) { shakti in
                    ShaktiDetailView(shakti: shakti)
                }
        }
        .fullScreenCover(isPresented: $showSilence) {
            SilenceView(isPresented: $showSilence)
        }
        .onAppear(perform: applyLaunchArgsIfNeeded)
    }

    private func applyLaunchArgsIfNeeded() {
        guard !hasAppliedLaunchArgs else { return }
        hasAppliedLaunchArgs = true
        let args = ProcessInfo.processInfo.arguments
        if args.contains("OPEN_SILENCE") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showSilence = true }
            return
        }
        if let arg = args.first(where: { $0.hasPrefix("OPEN_DETAIL=") }),
           let pos = Int(arg.dropFirst("OPEN_DETAIL=".count)),
           let s = shaktis.first(where: { $0.position == pos }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { detailFor = s }
        }
    }

    private var content: some View {
        ZStack {
            Color.ground.ignoresSafeArea()
            // Faint warm center
            RadialGradient(
                gradient: Gradient(colors: [Color.gold.opacity(0.06), Color.clear]),
                center: UnitPoint(x: 0.5, y: 0.45),
                startRadius: 0, endRadius: 280
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Avarana heading
                Text("2nd Avaraṇa — Sarvāśā-Paripūraka Cakra".uppercased())
                    .font(.system(size: 11))
                    .tracking(2.0)
                    .foregroundStyle(Color.gold.opacity(0.85))
                    .padding(.top, 12)
                    .padding(.bottom, 6)

                Spacer(minLength: 0)

                // The lotus, centered, filling most of the screen
                LotusMandalaView(
                    shaktis: shaktis,
                    todayIndex: shaktis.isEmpty ? nil : todayIndex,
                    diameter: 344,
                    onPetalTap: { position in
                        if let s = shaktis.first(where: { $0.position == position }) {
                            detailFor = s
                        }
                        onPetalTap?(position)
                    },
                    onBinduTap: {
                        showSilence = true
                        onBinduTap?()
                    }
                )
                .padding(.bottom, 4)

                Spacer(minLength: 0)

                // Progress text
                HStack(spacing: 8) {
                    Text("\(activeCount)").foregroundStyle(Color.gold)
                    Text("of \(shaktis.count) Active").foregroundStyle(Color.cream.opacity(0.45))
                    Text("·").foregroundStyle(Color.cream.opacity(0.3))
                    Text("\(embodiedCount)").foregroundStyle(Color.cream.opacity(0.7))
                    Text("Embodied").foregroundStyle(Color.cream.opacity(0.45))
                }
                .font(.system(size: 12))
                .tracking(1.2)
                .padding(.bottom, 12)

                // Cluster legend
                let legend: [Cluster] = [.inner, .tanmatra, .citta, .stability, .selfBody]
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 18),
                    GridItem(.flexible(), spacing: 18),
                    GridItem(.flexible(), spacing: 18),
                ], spacing: 6) {
                    ForEach(legend, id: \.self) { c in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(c.color)
                                .frame(width: 5, height: 5)
                                .shadow(color: c.color, radius: 2)
                            Text(c.label)
                                .font(.system(size: 9.5))
                                .tracking(1.0)
                                .foregroundStyle(Color.cream.opacity(0.45))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 8)

                // Hint
                Text("Tap a petal to enter · Bindu for silence".uppercased())
                    .font(.system(size: 9))
                    .tracking(2.6)
                    .foregroundStyle(Color.cream.opacity(0.22))
                    .padding(.bottom, 14)
            }
        }
    }
}
