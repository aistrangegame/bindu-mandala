import SwiftUI
import SwiftData

/// The descent, remembered.
///
/// A wordless retrospective — the rings opening one by one in the order they
/// were crossed, each glyph dissolving into the next. Not a stats screen. A
/// private memory. Stretch from §9.
struct DescentFilmView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var states: [DescentState]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]

    @State private var frameIndex: Int = 0
    @State private var advancer: Task<Void, Never>? = nil

    /// One frame per remembered moment of the descent.
    fileprivate struct FilmMoment: Identifiable {
        let id: Int      // ring number
        let ring: Int
        let avarana: Avarana?
        let crossedAt: Date?
    }

    private var moments: [FilmMoment] {
        guard let descent = states.first else { return [] }
        var out: [FilmMoment] = []
        // Ring 1 — Bhūpura, the ground. The descent starts here without
        // a recorded date; she was simply already present.
        out.append(FilmMoment(id: 1, ring: 1, avarana: avarana(1), crossedAt: nil))
        // Ring 2 — home. Where every install begins; no recorded crossing.
        out.append(FilmMoment(id: 2, ring: 2, avarana: avarana(2), crossedAt: nil))
        // Rings 3..deepestReached — each recorded.
        for (i, date) in descent.crossings.enumerated() {
            let ring = 3 + i
            guard ring <= 9, ring <= descent.deepestReached else { break }
            out.append(FilmMoment(id: ring, ring: ring, avarana: avarana(ring), crossedAt: date))
        }
        return out
    }

    var body: some View {
        ZStack {
            Color.ground.ignoresSafeArea()
            DustMotesView(count: 6)
                .allowsHitTesting(false)

            if moments.isEmpty {
                emptyState
            } else if let m = moments[safe: frameIndex] {
                FilmMomentView(moment: m, reduceMotion: reduceMotion)
                    .id(m.id)
                    .transition(AnyTransition.opacity)
            }

            VStack {
                Spacer()
                progressDots
                    .padding(.bottom, 14)
                Button { dismiss() } label: {
                    Text("close".uppercased())
                        .font(.system(size: 11))
                        .tracking(2.4)
                        .foregroundStyle(Color.cream.opacity(0.55))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 22)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 24)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { advanceManually() }
        .onAppear(perform: startFilm)
        .onDisappear { advancer?.cancel() }
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("the descent has not yet begun")
                .font(.custom(AppFont.cormorantItalic, size: 18))
                .foregroundStyle(Color.cream.opacity(0.55))
                .multilineTextAlignment(.center)
            Text("you are at home")
                .font(.system(size: 11))
                .tracking(2.4)
                .foregroundStyle(Color.gold.opacity(0.50))
        }
        .padding(.horizontal, 40)
    }

    @ViewBuilder
    private var progressDots: some View {
        if moments.count > 1 {
            HStack(spacing: 6) {
                ForEach(0..<moments.count, id: \.self) { i in
                    Circle()
                        .fill(Color.gold.opacity(i == frameIndex ? 0.85 : 0.22))
                        .frame(width: 4, height: 4)
                }
            }
        }
    }

    // MARK: - Sequencing

    private func startFilm() {
        guard moments.count > 1 else { return }
        advancer?.cancel()
        advancer = Task { @MainActor in
            for _ in 0..<(moments.count - 1) {
                try? await Task.sleep(for: .seconds(4.5))
                if Task.isCancelled { return }
                withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 1.2)) {
                    frameIndex = min(frameIndex + 1, moments.count - 1)
                }
            }
        }
    }

    private func advanceManually() {
        guard moments.count > 1 else { return }
        advancer?.cancel()
        withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 0.6)) {
            frameIndex = (frameIndex + 1) % moments.count
        }
        startFilm()
    }

    private func avarana(_ ring: Int) -> Avarana? {
        avaranas.first(where: { $0.ringNumber == ring })
    }
}

// MARK: - One frame

private struct FilmMomentView: View {
    let moment: DescentFilmView.FilmMoment
    let reduceMotion: Bool

    @State private var breath: CGFloat = 0

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 60)

            RingGlyph(ring: moment.ring, color: Color.gold, size: 96)
                .opacity(0.85 + 0.15 * Double(breath))
                .shadow(color: Color.gold.opacity(0.35 * Double(breath)), radius: 14)

            VStack(spacing: 10) {
                if let av = moment.avarana, !av.sanskritName.isEmpty {
                    Text(av.sanskritName)
                        .font(.custom(AppFont.cormorant, size: 30))
                        .tracking(1.4)
                        .foregroundStyle(Color.cream)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Avaraṇa \(moment.ring)")
                        .font(.custom(AppFont.cormorant, size: 28))
                        .tracking(1.2)
                        .foregroundStyle(Color.cream.opacity(0.85))
                }

                if let sub = moment.avarana?.subtitle, !sub.isEmpty {
                    Text(sub)
                        .font(.custom(AppFont.cormorantItalic, size: 15))
                        .tracking(0.4)
                        .foregroundStyle(Color.cream.opacity(0.60))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 36)

            if let date = moment.crossedAt {
                Text("the way opened · \(formatDate(date))")
                    .font(.system(size: 11))
                    .tracking(2.4)
                    .foregroundStyle(Color.gold.opacity(0.75))
            } else if moment.ring == 2 {
                Text("home")
                    .font(.system(size: 11))
                    .tracking(2.4)
                    .foregroundStyle(Color.gold.opacity(0.65))
            } else if moment.ring == 1 {
                Text("the ground")
                    .font(.system(size: 11))
                    .tracking(2.4)
                    .foregroundStyle(Color.gold.opacity(0.65))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            guard !reduceMotion else { breath = 0.5; return }
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                breath = 1
            }
        }
    }

    private func formatDate(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f.string(from: d).lowercased()
    }
}

// MARK: - Safe subscript

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
