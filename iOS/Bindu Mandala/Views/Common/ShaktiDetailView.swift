import SwiftUI
import SwiftData

/// The Śakti Detail screen — reached by tapping a petal in the Mandala.
struct ShaktiDetailView: View {
    @Bindable var shakti: Shakti
    /// Where she was opened from — names the back button ("today", "the field",
    /// "mandala"), matching the prototype's `backLabel`.
    var backLabel: String = "mandala"
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var bijaPulse: CGFloat = 0        // 0…1 pulse for tap-to-hear
    @State private var bijaSounding = false          // resonance rings while she sounds
    @State private var bijaGen = 0                    // so a rapid re-tap's timer can't clear a later sounding
    @State private var advanceProgress: CGFloat = 0  // 0…1 during the held beat
    @State private var breathPhase: CGFloat = 0      // soft breath when ready
    @State private var goDeeperExpanded: Bool = false
    @State private var showRecognition = false
    /// Phase 3.7 — the way in. See ``herDoor``.
    @State private var showHerRoom = false

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

    /// Her atmosphere — the same day-lit palette every other screen reads, so the
    /// Detail inherits the day's light rather than sitting on flat ground.
    private var atmo: Atmosphere {
        Atmosphere.derive(from: shakti, at: LunarPhaseService.currentTimeVariant())
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                atmosphereLayer(side: min(geo.size.width, geo.size.height))

                VStack(spacing: 0) {
                    navBar
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // The hero leads, then the soul.
                            heroSection
                            codexPortraitSection
                            somaticSection
                            bijaSection
                            appreciationPhraseSection
                            embodimentSection
                            if shakti.hasFieldConnection { fieldConnectionSection }
                            herMomentsSection
                            // Reference matter, folded.
                            goDeeperSection
                            Color.clear.frame(height: 32)
                        }
                        .padding(.horizontal, 26)
                    }
                    .overlay(alignment: .bottom) { BottomScrollFade() }
                    herDoor
                    recognitionFooter
                }
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
        .fullScreenCover(isPresented: $showHerRoom) {
            // `entering(_:remembering:)` builds the whole threshold from her own
            // row and what her room remembers, and it is the **only** way a room
            // is ever constructed in the shell. There is no call anywhere that
            // reaches a `RoomView` without the rite in front of it, which is what
            // makes "no room without the rite" a fact about the tree rather than
            // a rule somebody has to keep.
            //
            // `nil` is impossible for a row the walker is looking at — she is on
            // this screen, so she has a position and a ring — and the door below
            // asks the same question before it draws, so this branch is the
            // compiler's rather than the walker's.
            if let rite = RiteOfEnteringView.entering(shakti,
                                                      remembering: HomeMemoryStore(context: context),
                                                      onLeft: { showHerRoom = false }) {
                rite
            } else {
                Color.ground.ignoresSafeArea()
                    .onAppear { showHerRoom = false }
            }
        }
    }

    /// **The way into her room, and the one place in the shell it is opened.**
    ///
    /// *Where it stands, and why it is here rather than anywhere else.* Three
    /// screens find a Śakti — her seat in the Mandala, her row in the Field,
    /// today's Rite — and all three arrive at this one. So this is the single
    /// place a door can stand and be the *same* door for every one of the
    /// hundred and two, reached however he came to her, without the instrument
    /// growing a list of rooms. A room reached from a list is a room reached
    /// like a file.
    ///
    /// *Why the foot of the screen rather than a place in the scroll.* The
    /// footer is the only part of the Detail that does not scroll, and it is
    /// where this screen's **acts** already stand. Everything above it is what
    /// is known about her — her portrait, her somatic line, her bīja, the
    /// moments she has been felt — and a walker who opens her and wants only her
    /// should not have to read the archive to reach her. It also costs the
    /// screen nothing: the footer grows downward from the scroll's own edge, so
    /// not one element of the Detail moves to make room for it.
    ///
    /// *And it completes a ladder the app was already climbing.* The Mandala's
    /// card offers **know her ›** and lands here. Here she may be dwelt with —
    /// **be with her ›** — and then felt: **I feel her**. Reading, staying,
    /// recognising; each a deeper act than the one above it, in the order the
    /// screen puts them in. The room is not a sibling of the recognition. It is
    /// the ground the recognition is made on, so it stands above it.
    ///
    /// It is unconditional, and it has to be: every seat with a position and a
    /// ring has a room (``HomeRooms/resolve(_:live:)``), so if one Śakti can be
    /// entered, all of them can.
    @ViewBuilder
    private var herDoor: some View {
        if HomeRooms.resolve(shakti) != nil {
            Button {
                Haptics.medium()
                showHerRoom = true
            } label: {
                Text("be with her ›")
                    .font(AppFont.voice(16))
                    .tracking(1.4)
                    .foregroundStyle(Color.gold.opacity(0.82))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 26)
            .padding(.top, 10)
            .accessibilityLabel("Be with her — enter the room of \(shakti.phonetic.isEmpty ? shakti.name : shakti.phonetic)")
        }
    }

    /// Background + a crowning counter-rotating sigil + element motes + depth —
    /// the same four-layer atmosphere the Rite and Field wear. The sigil is
    /// clamped onto a flexible `Color.clear` so its overdraw never inflates layout.
    private func atmosphereLayer(side: CGFloat) -> some View {
        ZStack {
            AtmosphereBackground(atmosphere: atmo)
            Color.clear.overlay(alignment: .top) {
                RiteSigil(atmosphere: atmo, ring: shakti.ringNumber ?? 2,
                          size: side * 1.5, spin: -1)
                    .opacity(0.55)
                    .offset(y: -side * 0.62)   // crowns above the fold, mostly off-screen
            }
            DustMotesView(count: 10, element: atmo.element, accent: atmo.accentBright)
            DepthOverlay()
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
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
                .font(AppFont.sanskrit(20))
                .tracking(2.4)
                .foregroundStyle(Color.cream)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 56)
                .background(
                    Capsule()
                        .fill(LinearGradient(
                            colors: [Color.accentRed, atmo.accent.opacity(0.55)],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: atmo.glow, radius: 34, y: 3)
                        .shadow(color: Color.accentRed.opacity(0.35), radius: 20, y: 3)
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
                HStack(spacing: 6) {
                    Text("‹").font(.system(size: 22, weight: .light))
                    Text(backLabel)
                        .font(AppFont.voice(16))
                        .tracking(0.4)
                }
                .foregroundStyle(Color.gold)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Spacer()
            if let kp = shakti.khadgamalaPosition {
                Text("\(kp) · 102")
                    .font(AppFont.label(11))
                    .tracking(1.6)
                    .foregroundStyle(Color.cream.opacity(0.55))
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 6)
        .padding(.bottom, 10)
    }

    /// The hero — centred and glowing, the way one meets a presence. Kicker →
    /// name (with her glow) → script → phonetic → hairline → quality → cluster.
    private var heroSection: some View {
        VStack(spacing: 0) {
            Text(heroKicker)
                .font(AppFont.label(11))
                .tracking(3.0)
                .foregroundStyle(atmo.accentBright)
                .multilineTextAlignment(.center)
                .padding(.bottom, 18)

            Text(shakti.name)
                .font(AppFont.sanskrit(44))
                .fontWeight(.light)
                .tracking(1.5)
                .foregroundStyle(Color.cream)
                .shadow(color: atmo.glow, radius: 44)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.55)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel(headerSpokenLabel)

            if let dev = shakti.devanagari, !dev.isEmpty {
                Text(dev)
                    .font(AppFont.label(22))
                    .foregroundStyle(Color.cream.opacity(0.7))
                    .padding(.top, 12)
                    // §4.4. Handed to a voice as text, this line is read out
                    // character by character — `\u{0938}`, `\u{094D}`, `\u{092A}` — which tells
                    // a walker nothing and takes a long time doing it. The line
                    // is labelled as *what it is*; her name itself has already
                    // been spoken above, transliterated.
                    .accessibilityLabel(MandalaVoice.devanagariLabel)
            }

            if !shakti.phonetic.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(shakti.phonetic.uppercased())
                    .font(AppFont.label(12))
                    .tracking(2.6)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .padding(.top, 12)
            }

            Rectangle()
                .fill(atmo.accentSoft)
                .frame(width: 54, height: 0.6)
                .padding(.top, 22)

            let quality = shakti.quality.trimmingCharacters(in: .whitespaces)
            if !quality.isEmpty {
                Text(shakti.quality)
                    .font(AppFont.sanskrit(23))
                    .tracking(0.4)
                    .foregroundStyle(atmo.accentBright)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 22)
            }

            let qDesc = shakti.qualityDescription.trimmingCharacters(in: .whitespaces)
            if !qDesc.isEmpty {
                Text(shakti.qualityDescription)
                    .font(AppFont.sanskrit(15))
                    .lineSpacing(6)
                    .foregroundStyle(Color.cream.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 12)
                    .padding(.horizontal, 6)
            }

            // The 16 wear their family; the 86 wear only their own light — never
            // the false "INNER INSTRUMENT" the .inner default would print.
            if hasCluster {
                HStack(spacing: 8) {
                    Circle()
                        .fill(seatColor)
                        .frame(width: 7, height: 7)
                        .shadow(color: seatColor.opacity(0.7), radius: 4)
                    Text(shakti.cluster.label.uppercased())
                        .font(AppFont.label(11))
                        .tracking(1.8)
                        .foregroundStyle(Color.cream.opacity(0.5))
                }
                .padding(.top, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 22)
        .padding(.bottom, 8)
    }

    /// "First Āvaraṇa" … "Ninth Āvaraṇa" from her ring, mirroring the prototype
    /// hero kicker. (Her ring's *form* is added by T2.4 once the Avaraṇa model
    /// carries it.)
    private var heroKicker: String {
        let ordinals = ["First", "Second", "Third", "Fourth", "Fifth",
                        "Sixth", "Seventh", "Eighth", "Ninth"]
        let ring = shakti.ringNumber ?? 0
        guard ring >= 1, ring <= ordinals.count else { return "The Śrī Yantra" }
        return "\(ordinals[ring - 1]) Āvaraṇa"
    }

    /// She deepens as she is felt. A four-node track shows how far she has been
    /// embodied; the pill beneath it is a chosen crossing (press-and-hold), lit
    /// only when enough recognitions have made her ready. Ported from the
    /// prototype's `EmbodimentPill`, keeping our server-backed advance.
    private var embodimentSection: some View {
        section("Embodiment", alignment: .center, divider: true) {
            VStack(spacing: 14) {
                embodimentTrack
                embodimentPill
            }
            .frame(maxWidth: .infinity)
        }
    }

    /// Palette per level, mirroring the prototype: cream → soft → accent → bright.
    private func nodeColor(_ index: Int) -> Color {
        switch index {
        case 0:  return Color.cream.opacity(0.55)
        case 1:  return atmo.accentSoft
        case 2:  return atmo.accent
        default: return atmo.accentBright
        }
    }

    private var currentLevel: Int {
        ShaktiStatus.allCases.firstIndex(of: shakti.status) ?? 0
    }

    private var embodimentTrack: some View {
        let level = currentLevel
        return HStack(spacing: 7) {
            ForEach(Array(ShaktiStatus.allCases.enumerated()), id: \.element) { i, _ in
                if i > 0 {
                    Rectangle()
                        .fill(i <= level ? atmo.accent : Color.cream.opacity(0.14))
                        .frame(width: 18, height: 1)
                }
                Circle()
                    .fill(i <= level ? nodeColor(i) : .clear)
                    .overlay(Circle().stroke(i > level ? Color.cream.opacity(0.22) : .clear, lineWidth: 1))
                    .frame(width: i == level ? 9 : 6, height: i == level ? 9 : 6)
                    .shadow(color: i == level ? atmo.accentBright.opacity(0.8) : .clear, radius: 5)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Embodiment: \(shakti.status.label), level \(level + 1) of \(ShaktiStatus.allCases.count)")
    }

    @ViewBuilder
    private var embodimentPill: some View {
        if let target = nextStatusIfReady {
            crossingPill(target: target)
        } else {
            let color = pillColor(for: shakti.status)
            VStack(spacing: 8) {
                Text(shakti.status.label.uppercased())
                    .font(AppFont.label(11.5))
                    .tracking(2.0)
                    .foregroundStyle(color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Capsule().stroke(color, lineWidth: 1))
                Text(shakti.status == .embodied ? "she lives in you" : "felt into being")
                    .font(AppFont.voice(13))
                    .foregroundStyle(Color.cream.opacity(0.55))
            }
        }
    }

    private func crossingPill(target: ShaktiStatus) -> some View {
        let color = nodeColor(currentLevel)
        let breath = 0.55 + 0.45 * Double(breathPhase)
        return VStack(spacing: -12) {
            Text(shakti.status.label.uppercased())
                .font(AppFont.label(11.5))
                .tracking(2.0)
                .foregroundStyle(color)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    ZStack {
                        Capsule().stroke(color, lineWidth: 1).blur(radius: 4).opacity(breath * 0.5)
                        Capsule().stroke(color, lineWidth: 1)
                        GeometryReader { g in
                            Capsule().fill(atmo.accent.opacity(0.22))
                                .frame(width: g.size.width * Double(advanceProgress))
                        }
                    }
                )
                .scaleEffect(1 + Double(advanceProgress) * 0.03)
                .padding(.bottom, 20)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
                .onLongPressGesture(
                    minimumDuration: 0.75,
                    maximumDistance: 40,
                    perform: { performAdvance(to: target) },
                    onPressingChanged: { pressing in
                        if pressing {
                            Haptics.soft()
                            withAnimation(.linear(duration: 0.75)) { advanceProgress = 1 }
                        } else {
                            withAnimation(.easeOut(duration: 0.25)) { advanceProgress = 0 }
                        }
                    }
                )
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel("\(shakti.status.label). Hold to cross into \(target.label).")
                .onAppear {
                    guard !reduceMotion else { breathPhase = 0.5; return }
                    withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                        breathPhase = 1
                    }
                }
            // A caption, never a control — and it has to say so. The pill buys
            // its whole 44 pt target with `.padding(.bottom, 20)`, and the
            // `spacing: -12` above pulls this line back up over the lower twelve
            // points of it. A plain `Text` is hit-testable and is drawn after
            // the pill, so without this a thumb landing in that band lands on a
            // caption that carries no gesture and the long press never begins —
            // on the one control in the eight that no live measurement reaches,
            // because it appears only when a Śakti is ready to cross.
            Text("hold to cross into \(target.label.lowercased())")
                .font(AppFont.voice(13))
                .foregroundStyle(Color.cream.opacity(0.5))
                .allowsHitTesting(false)
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
        case .mapped:    return Color.cream.opacity(0.55)
        case .exploring: return Color.gold.opacity(0.55)
        case .active:    return Color.gold
        case .embodied:  return Color.clusterInner
        }
    }

    /// The 86 carry no somatic poetry — hide rather than print an empty header.
    @ViewBuilder
    private var somaticSection: some View {
        if !shakti.somaticPoetry.trimmingCharacters(in: .whitespaces).isEmpty {
            section("Somatic Signature", divider: true) {
                Text(shakti.somaticPoetry)
                    .font(AppFont.voice(17))
                    .lineSpacing(8)
                    .foregroundStyle(Color.cream.opacity(0.75))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    /// Bīja field structure across the 102:
    /// - Type 1 — pure syllable ("aṁ", "Hrīm")
    /// - Type 2 — syllable + " — " + description ("Kaṃ — governs K-row …")
    /// The syllable is `Shakti.bijaSyllable` — the one parse, shared by every
    /// surface. Only this screen shows the description, so only here is the
    /// remainder after the first " — " (space + em dash + space) rejoined.
    private var parsedBija: (syllable: String, description: String?) {
        let syllable = shakti.bijaSyllable ?? ""
        let parts = shakti.bija.components(separatedBy: " — ")
        guard parts.count > 1 else { return (syllable, nil) }
        let description = parts[1...].joined(separator: " — ")
        return (syllable, description.isEmpty ? nil : description)
    }

    /// The 86 carry no bīja — hide rather than render an empty syllable + a
    /// play button that would sound nothing.
    @ViewBuilder
    private var bijaSection: some View {
        if shakti.bijaSyllable != nil {
            bijaSectionBody
        }
    }

    private var bijaSectionBody: some View {
        let parsed = parsedBija
        return section("Bīja · Tap to Hear", alignment: .center, divider: true) {
            VStack(spacing: 14) {
                ZStack {
                    // Resonance rings expanding while she sounds (prototype's lrBijaRing).
                    if bijaSounding && !reduceMotion {
                        ForEach(0..<3, id: \.self) { i in
                            BijaResonanceRing(delay: Double(i) * 0.5, color: atmo.accentSoft)
                        }
                    }
                    Text(parsed.syllable)
                        .font(AppFont.sanskrit(84))
                        .fontWeight(.light)
                        .foregroundStyle(Color.gold)
                        .shadow(color: bijaSounding ? atmo.accent : atmo.glow,
                                radius: bijaSounding ? 70 : 40)
                        .scaleEffect(1 + bijaPulse * 0.05)
                }
                .frame(minHeight: 118)
                .contentShape(Rectangle())
                .onTapGesture { soundBija() }
                .accessibilityLabel("Bija syllable: \(parsed.syllable). Tap to hear.")
                .accessibilityAddTraits(.isButton)

                Text(bijaSounding ? "SOUNDING" : "TAP TO SOUND HER")
                    .font(AppFont.label(11.5))
                    .tracking(2.2)
                    .foregroundStyle(bijaSounding ? atmo.accentBright : Color.cream.opacity(0.55))

                if let description = parsed.description {
                    Text(description)
                        .font(AppFont.voice(14))
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
        let dur: TimeInterval = 3.2   // matches BijaSoundService.playBija's drone duration
        BijaSoundService.shared.playBija(shakti.bija, seed: shakti.khadgamalaPosition ?? shakti.position)
        // The "SOUNDING" caption tracks the drone regardless of motion settings; the
        // resonance rings + pulse below are motion. The generation token ensures a
        // rapid re-tap's earlier timer can't cut the later sounding short.
        bijaGen += 1
        let gen = bijaGen
        bijaSounding = true
        DispatchQueue.main.asyncAfter(deadline: .now() + dur) {
            if gen == bijaGen { bijaSounding = false }
        }
        guard !reduceMotion else { return }
        // A transient pulse that settles back to 1.0× (lrBijaPulse), not a permanent grow.
        bijaPulse = 1
        withAnimation(.easeOut(duration: 1.3)) { bijaPulse = 0 }
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
                        .font(AppFont.label(15))
                        .foregroundStyle(Color.cream.opacity(0.7))
                }
            }
        }
    }

    private var fieldConnectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Field Connection — \(shakti.fieldName ?? "")".uppercased())
                .font(AppFont.label(11))
                .tracking(2.0)
                .foregroundStyle(Color.cream.opacity(0.5))
            Text(shakti.fieldNote ?? "")
                .font(AppFont.voice(15))
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
        section("Her Moments", divider: true) {
            HerMomentsList(
                khadgamalaPosition: shakti.khadgamalaPosition ?? (shakti.position + 28),
                clusterColor: seatColor,
                airtableRecordId: shakti.airtableRecordId,
                shaktiName: shakti.name
            )
        }
    }

    // MARK: - Phase 2 sections

    @ViewBuilder
    private var appreciationPhraseSection: some View {
        if let v = shakti.appreciationPhrase, !v.isEmpty {
            VStack(spacing: 14) {
                Rectangle()
                    .fill(Color.gold.opacity(0.14))
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .padding(.bottom, 8)
                Rectangle()
                    .fill(Color.gold.opacity(0.3))
                    .frame(width: 32, height: 0.5)
                Text(v)
                    .font(AppFont.voice(16))
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
                    .font(AppFont.voice(14.5))
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
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(Color.gold.opacity(0.14))
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .padding(.bottom, 22)
                Text(v)
                    .font(AppFont.voice(16))
                    .tracking(0.2)
                    .lineSpacing(9)
                    .foregroundStyle(Color.gold)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 26)
        }
    }

    @ViewBuilder
    private var lineageSection: some View {
        if let v = shakti.shaktiFamilyRaw, !v.isEmpty {
            section("Lineage") {
                Text(v)
                    .font(AppFont.voice(13.5))
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
                    .font(AppFont.label(13.5))
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
                    .font(AppFont.voice(14))
                    .lineSpacing(7)
                    .foregroundStyle(Color.cream.opacity(0.58))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    /// A single fold for the reference matter — iconography, lineage, cosmic
    /// function, tattva, bodily seat, etymology. Closed by default; the soul leads.
    @ViewBuilder
    private var goDeeperSection: some View {
        let hasContent = (shakti.iconography?.isEmpty == false)
            || (shakti.shaktiFamilyRaw?.isEmpty == false)
            || (shakti.shaktiFunction?.isEmpty == false)
            || !shakti.tattva.isEmpty
            || !shakti.bodilyLocation.trimmingCharacters(in: .whitespaces).isEmpty
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
                            .font(AppFont.voice(14))
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
                        bodilySeatSection
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
                                        divider: Bool = false,
                                        @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: alignment, spacing: 10) {
            // A gold thread separating the mid-body sections (prototype's per-section
            // 1px rgba(201,150,63,0.14) top border).
            if divider {
                Rectangle()
                    .fill(Color.gold.opacity(0.14))
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .padding(.bottom, 12)
            }
            Text(title.uppercased())
                .font(AppFont.label(11.5))
                .tracking(2.0)
                .foregroundStyle(Color.cream.opacity(0.55))
                .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
            content()
                .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
        }
        .padding(.top, 22)
    }

    /// "Bodily seat" — where she is felt in the body (prototype's DeepRow). Hidden
    /// when absent.
    @ViewBuilder
    private var bodilySeatSection: some View {
        let loc = shakti.bodilyLocation.trimmingCharacters(in: .whitespaces)
        if !loc.isEmpty {
            section("Bodily Seat") {
                Text(loc)
                    .font(AppFont.label(15))
                    .foregroundStyle(Color.cream.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

/// One expanding, fading ring of resonance around the bīja while she sounds
/// (prototype's lrBijaRing: scale 0.7→3.4, opacity 0.55→0 over 3.6s).
private struct BijaResonanceRing: View {
    let delay: Double
    let color: Color
    @State private var animating = false

    var body: some View {
        Circle()
            .stroke(color, lineWidth: 1)
            .frame(width: 90, height: 90)
            .scaleEffect(animating ? 3.4 : 0.7)
            .opacity(animating ? 0 : 0.55)
            .onAppear {
                withAnimation(.easeOut(duration: 3.6).repeatForever(autoreverses: false).delay(delay)) {
                    animating = true
                }
            }
            .allowsHitTesting(false)
    }
}

private struct HerMomentsList: View {
    let khadgamalaPosition: Int
    let clusterColor: Color
    let airtableRecordId: String?
    /// Narrows the ledger read to rows whose link carries her name; the
    /// record id above keeps the match exact (names repeat across rings).
    let shaktiName: String
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
                    .font(AppFont.voice(14))
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
                        .font(AppFont.label(12))
                        .tracking(0.7)
                        .foregroundStyle(Color.cream.opacity(0.55))
                    if let moonPhase, !moonPhase.isEmpty {
                        Text("· \(moonPhase.lowercased())")
                            .font(AppFont.voice(12))
                            .foregroundStyle(Color.cream.opacity(0.50))
                    }
                }
                if let note, !note.isEmpty {
                    Text(note)
                        .font(AppFont.voice(13))
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
            let rows = try await AirtableService.shared.fetchRecognitions(forShaktiRecordId: recordId,
                                                                          name: shaktiName)
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
