import SwiftUI
import SwiftData

/// The Śakti Detail screen — reached by tapping a petal in the Mandala.
struct ShaktiDetailView: View {
    @Bindable var shakti: Shakti
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var statusCeremony: CGFloat = 0   // 0…1 pulse for the pill
    @State private var bijaPulse: CGFloat = 0        // 0…1 pulse for tap-to-hear

    var body: some View {
        ZStack {
            Color.ground.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        qualitySection
                        somaticSection
                        bijaSection
                        tattvaSection
                        if shakti.hasFieldConnection { fieldConnectionSection }
                        herMomentsSection
                        Color.clear.frame(height: 32)
                    }
                    .padding(.horizontal, 26)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Sections

    private var navBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Text("‹").font(.system(size: 22, weight: .light))
                    Text("Mandala").tracking(0.8)
                }
                .foregroundStyle(Color.gold)
                .font(.system(size: 14))
            }
            .buttonStyle(.plain)
            Spacer()
            // Isolated mini-petal
            PetalShape(outerRatio: 0.42, innerRatio: 0.08, halfWidthRatio: 0.13)
                .fill(shakti.cluster.color.opacity(0.85))
                .frame(width: 28, height: 36)
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 12)
        .overlay(Rectangle().fill(Color.gold.opacity(0.12)).frame(height: 0.5), alignment: .bottom)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(shakti.name)
                .font(.custom(AppFont.cormorant, size: 34))
                .tracking(2.0)
                .foregroundStyle(Color.cream)
                .padding(.bottom, 6)
            Text(shakti.phonetic.uppercased())
                .font(.system(size: 11))
                .tracking(2.0)
                .foregroundStyle(Color.cream.opacity(0.4))
                .padding(.bottom, 12)
            HStack(spacing: 12) {
                ClusterDotView(cluster: shakti.cluster)
                statusPill
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 26)
        .padding(.top, 18)
        .padding(.bottom, 16)
        .overlay(Rectangle().fill(Color.gold.opacity(0.10)).frame(height: 0.5), alignment: .bottom)
    }

    private var statusPill: some View {
        let color = pillColor(for: shakti.status)
        return Button(action: advanceStatus) {
            Text(shakti.status.label.uppercased())
                .font(.system(size: 10))
                .tracking(1.6)
                .foregroundStyle(color)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    Capsule().stroke(color, lineWidth: 1)
                )
                .background(
                    Capsule().fill(color.opacity(0.18 * Double(statusCeremony)))
                )
                .scaleEffect(1 + statusCeremony * 0.08)
                .shadow(color: color.opacity(0.45 * Double(statusCeremony)), radius: 12 * statusCeremony)
        }
        .buttonStyle(.plain)
    }

    private func pillColor(for status: ShaktiStatus) -> Color {
        switch status {
        case .mapped:    return Color.cream.opacity(0.35)
        case .exploring: return Color.gold.opacity(0.55)
        case .active:    return Color.gold
        case .embodied:  return Color.clusterInner
        }
    }

    private func advanceStatus() {
        guard shakti.status != .embodied else {
            // Soft tap acknowledging she is already there.
            Haptics.soft()
            return
        }
        Haptics.soft()
        let next = shakti.status.advanced()
        if reduceMotion {
            shakti.status = next
            try? context.save()
            return
        }
        // Ceremony — gentle expand & glow, settle, then commit the new status.
        withAnimation(.easeOut(duration: 0.55)) {
            statusCeremony = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            withAnimation(.easeInOut(duration: 0.35)) {
                shakti.status = next
            }
            try? context.save()
            withAnimation(.easeIn(duration: 0.6).delay(0.05)) {
                statusCeremony = 0
            }
        }
    }

    private var qualitySection: some View {
        section("Quality") {
            VStack(alignment: .leading, spacing: 10) {
                Text(shakti.quality)
                    .font(.custom(AppFont.cormorant, size: 19))
                    .tracking(0.4)
                    .foregroundStyle(Color.gold)
                Text(shakti.qualityDescription)
                    .font(.system(size: 14))
                    .lineSpacing(6)
                    .foregroundStyle(Color.cream.opacity(0.65))
            }
        }
    }

    private var somaticSection: some View {
        section("Somatic Signature") {
            Text(shakti.somaticPoetry)
                .font(.custom(AppFont.cormorantItalic, size: 17))
                .lineSpacing(8)
                .foregroundStyle(Color.cream.opacity(0.75))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var bijaSection: some View {
        section("Bīja Syllable · Tap to Hear", alignment: .center) {
            HStack(spacing: 24) {
                Spacer(minLength: 0)
                Text(shakti.bija)
                    .font(.custom(AppFont.cormorant, size: 108))
                    .foregroundStyle(Color.gold)
                    .shadow(color: Color.gold.opacity(0.4), radius: 28)
                    .onTapGesture { soundBija() }
                ZStack {
                    Circle()
                        .stroke(Color.gold.opacity(0.55), lineWidth: 1)
                        .background(Circle().fill(Color.gold.opacity(0.05)))
                        .frame(width: 44, height: 44)
                    Circle()
                        .stroke(Color.gold.opacity(0.25), lineWidth: 0.5)
                        .frame(width: 56, height: 56)
                    Image(systemName: "play.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.gold.opacity(0.85))
                    // Pulse rings on tap
                    Circle()
                        .stroke(Color.gold.opacity(0.5), lineWidth: 1)
                        .scaleEffect(1 + bijaPulse * 1.4)
                        .opacity(Double(1 - bijaPulse))
                        .frame(width: 44, height: 44)
                }
                .frame(width: 56, height: 56)
                .contentShape(Circle())
                .onTapGesture { soundBija() }
                Spacer(minLength: 0)
            }
        }
    }

    private func soundBija() {
        Haptics.soft()
        BijaSoundService.shared.play(forPosition: shakti.position)
        guard !reduceMotion else { return }
        bijaPulse = 0
        withAnimation(.easeOut(duration: 1.4)) { bijaPulse = 1 }
    }

    private var tattvaSection: some View {
        section("Esoteric Tattva") {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(shakti.cluster.color.opacity(0.15))
                    Circle()
                        .stroke(shakti.cluster.color.opacity(0.3), lineWidth: 1)
                    Circle()
                        .fill(shakti.cluster.color.opacity(0.8))
                        .frame(width: 10, height: 10)
                }
                .frame(width: 28, height: 28)
                Text(shakti.tattva)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.cream.opacity(0.7))
            }
        }
    }

    private var fieldConnectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Field Connection — \(shakti.fieldName ?? "")".uppercased())
                .font(.system(size: 9.5))
                .tracking(2.0)
                .foregroundStyle(Color.cream.opacity(0.3))
            Text(shakti.fieldNote ?? "")
                .font(.custom(AppFont.cormorantItalic, size: 15))
                .lineSpacing(7)
                .foregroundStyle(Color.cream.opacity(0.65))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(shakti.cluster.color.opacity(0.07))
        )
        .overlay(
            Rectangle()
                .fill(shakti.cluster.color.opacity(0.35))
                .frame(width: 2),
            alignment: .leading
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.top, 22)
    }

    private var herMomentsSection: some View {
        section("Her Moments") {
            HerMomentsList(position: shakti.position, clusterColor: shakti.cluster.color)
        }
    }

    // MARK: - Section helper

    private func section<Content: View>(_ title: String,
                                        alignment: HorizontalAlignment = .leading,
                                        @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: alignment, spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 9.5))
                .tracking(2.0)
                .foregroundStyle(Color.cream.opacity(0.3))
                .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
            content()
                .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
        }
        .padding(.top, 22)
    }
}

private struct HerMomentsList: View {
    let position: Int
    let clusterColor: Color
    @Environment(\.modelContext) private var context

    var body: some View {
        let entries = RecognitionLogStore(context: context).entries(for: position)
        VStack(alignment: .leading, spacing: 0) {
            if entries.isEmpty {
                Text("She has not been felt here yet.")
                    .font(.custom(AppFont.cormorantItalic, size: 14))
                    .foregroundStyle(Color.cream.opacity(0.35))
                    .padding(.vertical, 6)
            } else {
                ForEach(entries) { entry in
                    HStack(alignment: .top, spacing: 14) {
                        Circle()
                            .fill(clusterColor.opacity(0.7))
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(timestamp(entry.timestamp))
                                .font(.system(size: 12))
                                .tracking(0.7)
                                .foregroundStyle(Color.cream.opacity(0.4))
                            if let note = entry.note, !note.isEmpty {
                                Text(note)
                                    .font(.custom(AppFont.cormorantItalic, size: 13))
                                    .foregroundStyle(Color.cream.opacity(0.6))
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .overlay(
                        Rectangle().fill(Color.gold.opacity(0.08)).frame(height: 0.5),
                        alignment: .bottom
                    )
                }
            }
        }
    }

    private func timestamp(_ d: Date) -> String {
        // "she was felt here · today, 9:14 AM" style.
        let cal = Calendar.current
        let df = DateFormatter()
        if cal.isDateInToday(d)        { df.dateFormat = "'she was felt here · today,' h:mm a" }
        else if cal.isDateInYesterday(d){ df.dateFormat = "'she was felt here · yesterday,' h:mm a" }
        else                            { df.dateFormat = "'she was felt here ·' MMM d, h:mm a" }
        return df.string(from: d)
    }
}
