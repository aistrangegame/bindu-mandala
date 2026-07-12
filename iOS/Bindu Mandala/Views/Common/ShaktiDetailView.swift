import SwiftUI
import SwiftData

/// The Śakti Detail screen — reached by tapping a petal in the Mandala.
struct ShaktiDetailView: View {
    @Bindable var shakti: Shakti
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var bijaPulse: CGFloat = 0        // 0…1 pulse for tap-to-hear
    @State private var advanceProgress: CGFloat = 0  // 0…1 during the held beat
    @State private var breathPhase: CGFloat = 0      // soft breath when ready
    @State private var goDeeperExpanded: Bool = false
    @State private var showRecognition = false

    /// Ruling 7 / R3: cluster is a Ring-2-only taxonomy. The 86 carry `.inner`
    /// as `clusterRaw`'s default — never surface it as a color or a family label.
    /// Every seat-color here routes through the Atmosphere for the 86.
    private var hasCluster: Bool { (shakti.ringNumber ?? 2) == 2 }

    /// Her seat color — the cluster family for the 16, her own Atmosphere for the 86.
    private var seatColor: Color {
        hasCluster ? shakti.cluster.color : SeatLighting.accent(for: shakti)
    }

    /// VoiceOver header — her phonetic + quality when present, else just her name
    /// (the 86 carry neither), never a bare ", ".
    private var headerSpokenLabel: String {
        let p = shakti.phonetic.trimmingCharacters(in: .whitespaces)
        let q = shakti.quality.trimmingCharacters(in: .whitespaces)
        switch (p.isEmpty, q.isEmpty) {
        case (false, false): return "\(p), \(q)"
        case (false, true):  return p
        case (true, false):  return "\(shakti.name), \(q)"
        case (true, true):   return shakti.name
        }
    }

    var body: some View {
        ZStack {
            Color.ground.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // The soul, leading.
                        devanagariSection
                        codexPortraitSection
                        somaticSection
                        appreciationPhraseSection
                        qualitySection
                        bijaSection
                        if shakti.hasFieldConnection { fieldConnectionSection }
                        herMomentsSection
                        // Reference matter, folded.
                        goDeeperSection
                        Color.clear.frame(height: 32)
                    }
                    .padding(.horizontal, 26)
                }
                .overlay(alignment: .bottom) { BottomScrollFade() }
                recognitionFooter
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableSwipeBack()
        .fullScreenCover(isPresented: $showRecognition) {
            RecognitionMomentView(shakti: shakti,
                                  isPresented: $showRecognition,
                                  source: .mandala)
        }
    }

    /// She can be recognized from anywhere she is met — not only on the day she
    /// happens to preside. The same red gesture as the Daily Rite; `source`
    /// distinguishes where the recognition arose.
    private var recognitionFooter: some View {
        Button {
            Haptics.medium()
            showRecognition = true
        } label: {
            Text("I feel her")
                .font(.custom(AppFont.cormorant, size: 20))
                .tracking(2.4)
                .foregroundStyle(Color.cream)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    Capsule().fill(Color.accentRed)
                        .shadow(color: Color.accentRed.opacity(0.40), radius: 24, y: 3)
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 26)
        .padding(.top, 8)
        .padding(.bottom, 14)
        .accessibilityLabel("I feel her — record recognition of \(shakti.phonetic.isEmpty ? shakti.name : shakti.phonetic)")
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
            // Isolated mini-petal — lit by her seat color (never the .inner default).
            PetalShape(outerRatio: 0.42, innerRatio: 0.08, halfWidthRatio: 0.13)
                .fill(seatColor.opacity(0.85))
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
                .padding(.bottom, 10)
                .accessibilityLabel(headerSpokenLabel)

            if !shakti.phonetic.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(shakti.phonetic.uppercased())
                    .font(.system(size: 11))
                    .tracking(2.0)
                    .foregroundStyle(Color.cream.opacity(0.4))
                    .padding(.bottom, 12)
            }

            HStack(alignment: .center, spacing: 10) {
                // The 16 wear their family; the 86 wear only their own light — never
                // the false "INNER INSTRUMENT" the .inner default would print.
                if hasCluster {
                    ClusterDotView(cluster: shakti.cluster)
                } else {
                    Circle()
                        .fill(seatColor)
                        .frame(width: 7, height: 7)
                        .shadow(color: SeatLighting.glow(for: shakti), radius: 4)
                }
                statusPill
                Spacer()
                if let kp = shakti.khadgamalaPosition {
                    Text("\(kp) · 102")
                        .font(.system(size: 10))
                        .tracking(0.8)
                        .foregroundStyle(Color.cream.opacity(0.50))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 26)
        .padding(.top, 18)
        .padding(.bottom, 16)
        .overlay(Rectangle().fill(Color.gold.opacity(0.10)).frame(height: 0.5), alignment: .bottom)
    }

    /// Phase 3.5: readiness is sensed (recognition count grows); crossing is
    /// always chosen (press-and-hold the pill). If the practitioner hasn't
    /// felt her often enough yet, the pill is plain — it reads as state, not
    /// as something to push.
    private var statusPill: some View {
        let cur = shakti.status
        let color = pillColor(for: cur)
        let label = cur.label.uppercased()
        return Group {
            if let target = nextStatusIfReady {
                advancePillBody(label: label, color: color, target: target)
            } else {
                plainPillBody(label: label, color: color)
            }
        }
    }

    private func plainPillBody(label: String, color: Color) -> some View {
        Text(label)
            .font(.system(size: 10))
            .tracking(1.6)
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Capsule().stroke(color, lineWidth: 1))
    }

    private func advancePillBody(label: String, color: Color, target: ShaktiStatus) -> some View {
        let breath = 0.55 + 0.45 * Double(breathPhase)
        return Text(label)
            .font(.system(size: 10))
            .tracking(1.6)
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                ZStack {
                    Capsule()
                        .stroke(color, lineWidth: 1)
                        .blur(radius: 4)
                        .opacity(breath * 0.45)
                    Capsule().stroke(color, lineWidth: 1)
                    Capsule().fill(color.opacity(0.22 * Double(advanceProgress)))
                }
            )
            .scaleEffect(1 + Double(advanceProgress) * 0.03)
            .contentShape(Capsule())
            .onLongPressGesture(
                minimumDuration: 0.7,
                maximumDistance: 40,
                perform: { performAdvance(to: target) },
                onPressingChanged: { pressing in
                    if pressing {
                        Haptics.soft()
                        withAnimation(.linear(duration: 0.7)) { advanceProgress = 1 }
                    } else {
                        withAnimation(.easeOut(duration: 0.25)) { advanceProgress = 0 }
                    }
                }
            )
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("\(shakti.status.label). Hold to cross into \(target.label).")
            .onAppear {
                guard !reduceMotion else { breathPhase = 0.5; return }
                withAnimation(.easeInOut(duration: 1.9).repeatForever(autoreverses: true)) {
                    breathPhase = 1
                }
            }
    }

    /// Readiness thresholds — sensed from recognition count.
    /// Mapped → Exploring at 1, → Active at 3, → Embodied at 7.
    private var nextStatusIfReady: ShaktiStatus? {
        let count = shakti.serverRecognitionCount ?? 0
        let cur = shakti.status
        let threshold: Int
        switch cur {
        case .mapped:    threshold = 1
        case .exploring: threshold = 3
        case .active:    threshold = 7
        case .embodied:  return nil
        }
        return count >= threshold ? cur.advanced() : nil
    }

    private func performAdvance(to target: ShaktiStatus) {
        Haptics.medium()
        advanceProgress = 0
        let s = shakti
        let ctx = context
        Task {
            await AirtableService.shared.advanceStatus(shakti: s, to: target, context: ctx)
        }
    }

    private func pillColor(for status: ShaktiStatus) -> Color {
        switch status {
        case .mapped:    return Color.cream.opacity(0.35)
        case .exploring: return Color.gold.opacity(0.55)
        case .active:    return Color.gold
        case .embodied:  return Color.clusterInner
        }
    }

    /// The 86 carry no quality — hide the section rather than print an empty header.
    @ViewBuilder
    private var qualitySection: some View {
        let quality = shakti.quality.trimmingCharacters(in: .whitespaces)
        let desc = shakti.qualityDescription.trimmingCharacters(in: .whitespaces)
        if !quality.isEmpty || !desc.isEmpty {
            section("Quality") {
                VStack(alignment: .leading, spacing: 10) {
                    if !quality.isEmpty {
                        Text(shakti.quality)
                            .font(.custom(AppFont.cormorant, size: 19))
                            .tracking(0.4)
                            .foregroundStyle(Color.gold)
                    }
                    if !desc.isEmpty {
                        Text(shakti.qualityDescription)
                            .font(.system(size: 14))
                            .lineSpacing(6)
                            .foregroundStyle(Color.cream.opacity(0.65))
                    }
                }
            }
        }
    }

    /// The 86 carry no somatic poetry — hide rather than print an empty header.
    @ViewBuilder
    private var somaticSection: some View {
        if !shakti.somaticPoetry.trimmingCharacters(in: .whitespaces).isEmpty {
            section("Somatic Signature") {
                Text(shakti.somaticPoetry)
                    .font(.custom(AppFont.cormorantItalic, size: 17))
                    .lineSpacing(8)
                    .foregroundStyle(Color.cream.opacity(0.75))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    /// Bīja field structure across the 102:
    /// - Type 1 — pure syllable ("aṁ", "Hrīm")
    /// - Type 2 — syllable + " — " + description ("Kaṃ — governs K-row …")
    /// Parsed on the literal " — " (space + em dash + space). The description
    /// rejoins any further " — " occurrences inside the body.
    private var parsedBija: (syllable: String, description: String?) {
        let raw = shakti.bija
        let parts = raw.components(separatedBy: " — ")
        guard parts.count > 1 else { return (raw, nil) }
        let syllable = parts[0]
        let description = parts[1...].joined(separator: " — ")
        return (syllable, description.isEmpty ? nil : description)
    }

    /// The 86 carry no bīja — hide rather than render an empty syllable + a
    /// play button that would sound nothing.
    @ViewBuilder
    private var bijaSection: some View {
        if !shakti.bija.trimmingCharacters(in: .whitespaces).isEmpty {
            bijaSectionBody
        }
    }

    private var bijaSectionBody: some View {
        let parsed = parsedBija
        return section("Bīja Syllable · Tap to Hear", alignment: .center) {
            VStack(spacing: 12) {
                HStack(spacing: 24) {
                    Spacer(minLength: 0)
                    Text(parsed.syllable)
                        .font(.custom(AppFont.cormorant, size: 64))
                        .foregroundStyle(Color.gold)
                        .shadow(color: Color.gold.opacity(0.4), radius: 20)
                        .onTapGesture { soundBija() }
                        .accessibilityLabel("Bija syllable: \(parsed.syllable). Tap to hear.")
                        .accessibilityAddTraits(.isButton)
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

                if let description = parsed.description {
                    Text(description)
                        .font(.custom(AppFont.cormorantItalic, size: 14))
                        .lineSpacing(8)
                        .foregroundStyle(Color.cream.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 12)
                }
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

    @ViewBuilder
    private var tattvaSection: some View {
        if !shakti.tattva.trimmingCharacters(in: .whitespaces).isEmpty {
            section("Esoteric Tattva") {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(seatColor.opacity(0.15))
                        Circle()
                            .stroke(seatColor.opacity(0.3), lineWidth: 1)
                        Circle()
                            .fill(seatColor.opacity(0.8))
                            .frame(width: 10, height: 10)
                    }
                    .frame(width: 28, height: 28)
                    Text(shakti.tattva)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.cream.opacity(0.7))
                }
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
                .fill(seatColor.opacity(0.07))
        )
        .overlay(
            Rectangle()
                .fill(seatColor.opacity(0.35))
                .frame(width: 2),
            alignment: .leading
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.top, 22)
    }

    private var herMomentsSection: some View {
        section("Her Moments") {
            HerMomentsList(
                khadgamalaPosition: shakti.khadgamalaPosition ?? (shakti.position + 28),
                clusterColor: seatColor,
                airtableRecordId: shakti.airtableRecordId
            )
        }
    }

    // MARK: - Phase 2 sections

    @ViewBuilder
    private var devanagariSection: some View {
        if let v = shakti.devanagari, !v.isEmpty {
            Text(v)
                .font(.system(size: 44))
                .foregroundStyle(Color.cream)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 22)
                .accessibilityLabel("Devanagari script: \(shakti.phonetic)")
        }
    }

    @ViewBuilder
    private var appreciationPhraseSection: some View {
        if let v = shakti.appreciationPhrase, !v.isEmpty {
            VStack(spacing: 14) {
                Rectangle()
                    .fill(Color.gold.opacity(0.3))
                    .frame(width: 32, height: 0.5)
                Text(v)
                    .font(.custom(AppFont.cormorantItalic, size: 16))
                    .tracking(0.6)
                    .lineSpacing(7)
                    .foregroundStyle(Color.gold)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 24)
        }
    }

    @ViewBuilder
    private var iconographySection: some View {
        if let v = shakti.iconography, !v.isEmpty {
            section("Iconography") {
                Text(v)
                    .font(.custom(AppFont.cormorantItalic, size: 14.5))
                    .lineSpacing(8)
                    .foregroundStyle(Color.cream.opacity(0.58))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    /// The soul of the screen — rendered bare, no section label.
    /// Italic Cormorant gold, generous line height. Never truncated.
    @ViewBuilder
    private var codexPortraitSection: some View {
        if let v = shakti.codexPortrait, !v.isEmpty {
            Text(v)
                .font(.custom(AppFont.cormorantItalic, size: 16))
                .tracking(0.2)
                .lineSpacing(9)
                .foregroundStyle(Color.gold)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 26)
        }
    }

    @ViewBuilder
    private var lineageSection: some View {
        if let v = shakti.shaktiFamilyRaw, !v.isEmpty {
            section("Lineage") {
                Text(v)
                    .font(.custom(AppFont.cormorantItalic, size: 13.5))
                    .lineSpacing(6)
                    .foregroundStyle(Color.cream.opacity(0.58))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    @ViewBuilder
    private var cosmicFunctionSection: some View {
        if let v = shakti.shaktiFunction, !v.isEmpty {
            section("Cosmic Function") {
                Text(v)
                    .font(.system(size: 13.5))
                    .lineSpacing(6)
                    .foregroundStyle(Color.cream.opacity(0.58))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    @ViewBuilder
    private var etymologySection: some View {
        if let v = shakti.etymology, !v.isEmpty {
            section("Etymology") {
                Text(v)
                    .font(.custom(AppFont.cormorantItalic, size: 14))
                    .lineSpacing(7)
                    .foregroundStyle(Color.cream.opacity(0.58))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    /// A single fold for the reference matter — iconography, lineage, cosmic
    /// function, tattva, etymology. Closed by default; the soul leads.
    @ViewBuilder
    private var goDeeperSection: some View {
        let hasContent = (shakti.iconography?.isEmpty == false)
            || (shakti.shaktiFamilyRaw?.isEmpty == false)
            || (shakti.shaktiFunction?.isEmpty == false)
            || !shakti.tattva.isEmpty
            || (shakti.etymology?.isEmpty == false)
        if hasContent {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    Haptics.light()
                    withAnimation(.easeInOut(duration: 0.35)) {
                        goDeeperExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 12) {
                        Text(goDeeperExpanded ? "less" : "go deeper")
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(1.4)
                            .foregroundStyle(Color.gold.opacity(0.78))
                        Rectangle()
                            .fill(Color.gold.opacity(0.22))
                            .frame(height: 0.5)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.top, 28)

                if goDeeperExpanded {
                    VStack(alignment: .leading, spacing: 0) {
                        iconographySection
                        lineageSection
                        cosmicFunctionSection
                        tattvaSection
                        etymologySection
                    }
                    .transition(.opacity)
                }
            }
        }
    }

    // MARK: - Section helper

    private func section<Content: View>(_ title: String,
                                        alignment: HorizontalAlignment = .leading,
                                        @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: alignment, spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 10.5))
                .tracking(2.0)
                .foregroundStyle(Color.cream.opacity(0.55))
                .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
            content()
                .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
        }
        .padding(.top, 22)
    }
}

private struct HerMomentsList: View {
    let khadgamalaPosition: Int
    let clusterColor: Color
    let airtableRecordId: String?
    @Environment(\.modelContext) private var context

    @State private var airtableMoments: [RecognitionAirtableRow] = []
    @State private var airtableLoaded = false

    var body: some View {
        let localEntries = RecognitionLogStore(context: context)
            .entries(forKhadgamala: khadgamalaPosition, limit: 200)

        VStack(alignment: .leading, spacing: 0) {
            // Once Airtable has answered with anything, it becomes the authoritative
            // record. Local entries are shown immediately so the section is never
            // empty during the fetch. Offline / pre-sync / fetch-failure: keep local.
            if airtableLoaded && !airtableMoments.isEmpty {
                ForEach(airtableMoments) { moment in
                    momentRow(
                        timestamp: moment.feltAt.map(formatTimestamp) ?? "she was felt here",
                        note: moment.notes,
                        moonPhase: moment.moonPhase
                    )
                }
            } else if !localEntries.isEmpty {
                ForEach(localEntries) { entry in
                    momentRow(
                        timestamp: formatTimestamp(entry.timestamp),
                        note: entry.note,
                        moonPhase: nil
                    )
                }
            } else {
                Text("She has not been felt here yet.")
                    .font(.custom(AppFont.cormorantItalic, size: 14))
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .padding(.vertical, 6)
            }
        }
        .task(id: airtableRecordId ?? "") {
            await loadAirtableMoments()
        }
    }

    private func momentRow(timestamp: String, note: String?, moonPhase: String?) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Circle()
                .fill(clusterColor.opacity(0.7))
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(timestamp)
                        .font(.system(size: 12))
                        .tracking(0.7)
                        .foregroundStyle(Color.cream.opacity(0.55))
                    if let moonPhase, !moonPhase.isEmpty {
                        Text("· \(moonPhase.lowercased())")
                            .font(.custom(AppFont.cormorantItalic, size: 12))
                            .foregroundStyle(Color.cream.opacity(0.50))
                    }
                }
                if let note, !note.isEmpty {
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

    private func loadAirtableMoments() async {
        guard let recordId = airtableRecordId, !recordId.isEmpty else {
            airtableLoaded = false
            return
        }
        do {
            let rows = try await AirtableService.shared.fetchRecognitions(forShaktiRecordId: recordId)
            airtableMoments = rows
            airtableLoaded = true
        } catch {
            // Silent — local entries stay visible.
            airtableLoaded = false
        }
    }

    private func formatTimestamp(_ d: Date) -> String {
        let cal = Calendar.current
        let df = DateFormatter()
        if cal.isDateInToday(d)         { df.dateFormat = "'she was felt here · today,' h:mm a" }
        else if cal.isDateInYesterday(d){ df.dateFormat = "'she was felt here · yesterday,' h:mm a" }
        else                            { df.dateFormat = "'she was felt here ·' MMM d, h:mm a" }
        return df.string(from: d)
    }
}
