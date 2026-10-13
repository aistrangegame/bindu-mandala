import SwiftUI
import SwiftData

/// The Recognition Moment — full-screen takeover after "I feel her".
/// Two acts, separated by a thin gold hairline:
///   Act 1: "she was felt here · [time]"      (muted, sans, uppercase)
///   Act 2: "and she felt you back · [time]"  (italic Cormorant, her bright accent)
///
/// The ceremony answers in **her nature** (`RecognitionNature`, from her
/// element): fire flares, water pools, air disperses, ether blooms once and
/// holds, earth settles, light radiates. Her ring's geometry and her bīja move
/// in that manner, her nature's own light stands in the air around them
/// (`RecognitionLight`), and at Act 2 the light answers once — in the hand as a
/// haptic and in the ear as her bīja.
///
/// On close the practice data is committed first (the note, the ledger write),
/// then the ceremony gathers into her point, a brief after-glow of her light
/// stays there and falls away, and the Router settles him into Memory (U2:
/// `Router.recognitionSettled`, from every source), where the newly-lit point glows.
struct RecognitionMomentView: View {
    let shakti: Shakti
    @Binding var isPresented: Bool
    var source: AirtableService.RecognitionSource = .today

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var nameVisible = false
    @State private var phraseVisible = false
    @State private var act1Visible = false
    @State private var act2Visible = false
    @State private var noteCardVisible = false
    @State private var act1Time: Date = .now
    @State private var act2Time: Date? = nil   // captured when Act 2 actually appears
    @State private var note: String = ""
    @State private var hasLogged = false
    @State private var respPhase: CGFloat = 0   // her geometry's response, rest → peak
    @State private var bijaPhase: CGFloat = 0   // her bīja's response, 1.3× slower
    @State private var answered = false         // Act 2 has landed — her light stands full
    @State private var closing = false          // gathering into the point
    @State private var afterGlowing = false     // what stays of her light
    @State private var noteCommitted = false

    /// Her atmosphere — the ceremony is lit by the same day-palette as everywhere else.
    private var atmo: Atmosphere {
        Atmosphere.derive(from: shakti, at: LunarPhaseService.currentTimeVariant())
    }
    /// Her nature — how the ceremony moves when she is felt back.
    private var nature: RecognitionNature { RecognitionNature.of(atmo.element) }

    /// The bare bīja syllable (before any " — description") — `Shakti.bijaSyllable`.
    private var bijaSyllable: String { shakti.bijaSyllable ?? "" }

    /// Her appreciation line: the bootstrap `recognitionPhrase` when present,
    /// else the Airtable `appreciationPhrase`, else empty (phrase is hidden).
    private var phraseText: String {
        let r = shakti.recognitionPhrase.trimmingCharacters(in: .whitespacesAndNewlines)
        if !r.isEmpty { return r }
        return (shakti.appreciationPhrase ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let focal = CGPoint(x: size.width * 0.5, y: size.height * CGFloat(nature.focalY))
            let scale = min(size.width, size.height) / 390
            ZStack {
                // Her light pools where her nature lives, over a deepening ground.
                RecognitionBackdrop(atmosphere: atmo, nature: nature)

                // Everything that is her light in the air — gathered into the
                // point on close.
                ceremonyLight(focal: focal, scale: scale, size: size)
                    .scaleEffect(closing && !reduceMotion ? 0.86 : 1,
                                 anchor: UnitPoint(x: 0.5, y: CGFloat(nature.focalY)))
                    .opacity(closing ? 0 : 1)

                ceremonyText
                    .opacity(closing ? 0 : 1)
                    .scaleEffect(closing && !reduceMotion ? 0.84 : 1)
                    .allowsHitTesting(!closing)

                if closing && !reduceMotion && !afterGlowing {
                    collapseCircle(at: focal)
                }

                if afterGlowing {
                    RecognitionAfterGlow(atmosphere: atmo, focal: focal, scale: scale,
                                         reduceMotion: reduceMotion)
                        .transition(.identity)
                }

                // §4.4. The whole screen is the way out, which gives a sighted
                // walker a target the size of the glass and a VoiceOver walker
                // nothing at all — there is no element under the finger to find.
                // This is that element: it draws nothing, hit-tests nothing (the
                // gesture below is still the only touch path), and carries the
                // action so a voice can perform it. It is last in the spoken
                // order, because the two Recognition lines are what this screen
                // is for and the way out is not.
                Color.clear
                    .accessibilityElement()
                    .accessibilityLabel(MandalaVoice.closeCeremony)
                    .accessibilitySortPriority(-1)
                    .accessibilityAction { if nameVisible { beginClose() } }
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()
        }
        .background(RecognitionBackdrop.night.ignoresSafeArea())
        // The idiomatic dismissal as well as the named one: a two-finger scrub
        // leaves the moment, the way it leaves any other screen in iOS.
        .accessibilityAction(.escape) { if nameVisible { beginClose() } }
        .contentShape(Rectangle())
        .onTapGesture {
            // Don't allow dismissing the ceremony before her name has arrived —
            // the recognition has already been logged in stage(), so an early
            // tap would cost the user the visual without changing the record.
            guard nameVisible else { return }
            beginClose()
        }
        .onAppear(perform: stage)
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    // MARK: - Her light in the air

    /// Her nature's standing light, the ripples of recognition, her ring's
    /// geometry and the ghost of her bīja — all at the focal, all moving in
    /// her manner — and the motes of the temple air.
    private func ceremonyLight(focal: CGPoint, scale: CGFloat, size: CGSize) -> some View {
        let pose = reduceMotion ? stillPose : nature.pose(at: Double(respPhase))
        let bijaPose = reduceMotion ? stillPose : nature.pose(at: Double(bijaPhase))
        return ZStack {
            RecognitionNatureLight(atmosphere: atmo, nature: nature, pose: pose,
                                   focal: focal, scale: scale, size: size,
                                   answered: answered)
                .opacity(nameVisible ? 1 : 0)

            // Ripples of recognition, travelling as her element travels.
            if !reduceMotion {
                ForEach(0..<nature.rippleCount, id: \.self) { i in
                    RecognitionRipple(color: atmo.accentSoft, nature: nature, index: i,
                                      scale: scale, reduceMotion: reduceMotion)
                        .position(focal)
                }
            }

            // Her ring's geometry, turning, answering in her manner. Its
            // strokes give off light rather than only sitting on the ground.
            RiteSigil(atmosphere: atmo, ring: shakti.ringNumber ?? 2,
                      size: 480 * scale, spin: sigilSpin)
                .shadow(color: atmo.accentSoft, radius: 9 * scale)
                .scaleEffect(CGFloat(pose.scale))
                .offset(x: CGFloat(pose.dx) * scale, y: CGFloat(pose.dy) * scale)
                .opacity(0.55 * pose.opacity)
                .opacity(nameVisible ? 1 : 0)
                .position(focal)
                .accessibilityHidden(true)

            // Ghost bīja — enormous, faint, staged in with the phrase.
            if !bijaSyllable.isEmpty {
                Text(bijaSyllable)
                    .font(.custom(AppFont.cormorant, size: 300 * scale))
                    .foregroundStyle(atmo.accentFaint)
                    .opacity(bijaPose.opacity)
                    .opacity(phraseVisible ? 1 : 0)
                    .scaleEffect(CGFloat(bijaPose.scale))
                    .offset(x: CGFloat(bijaPose.dx) * scale, y: CGFloat(bijaPose.dy) * scale)
                    .position(focal)
                    .accessibilityHidden(true)
            }

            // The answer at Act 2 — once, in her nature.
            if answered && !reduceMotion {
                RecognitionAnswer(atmosphere: atmo, nature: nature, focal: focal,
                                  scale: scale, size: size)
                    .transition(.identity)
            }

            DustMotesView(count: nature.motes, element: atmo.element, accent: atmo.accentBright)
        }
        .allowsHitTesting(false)
    }

    /// Under reduce motion each nature is its still light: the bloom already
    /// open, every other nature held halfway to its height.
    private var stillPose: RecognitionNature.Pose {
        nature.pose(at: nature.repeats ? 0.5 : 1)
    }

    private var sigilSpin: Double {
        (shakti.khadgamalaPosition ?? shakti.position) % 2 == 0 ? 1 : -1
    }

    /// The collapse — the ceremony gathers into the point (`lrCollapse`).
    private func collapseCircle(at focal: CGPoint) -> some View {
        Circle()
            .fill(RadialGradient(
                gradient: Gradient(colors: [atmo.accentBright, atmo.glow, .clear]),
                center: .center, startRadius: 0, endRadius: 150))
            .frame(width: 300, height: 300)
            .scaleEffect(closing ? 0.14 : 1.5)
            .opacity(closing ? 0 : 0.6)
            .blendMode(.plusLighter)
            .position(focal)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    /// How far a line still has to rise before it has arrived (Design's `vis(n, dy)`).
    /// Under reduce motion the words arrive by fading alone.
    private func rise(_ arrived: Bool, _ dy: Double) -> CGFloat {
        arrived || reduceMotion ? 0 : CGFloat(dy)
    }

    // MARK: - Text (name + phrase + two acts)

    private var ceremonyText: some View {
        ZStack {
            // Center: name + divider + appreciation phrase
            VStack(spacing: 0) {
                Spacer()

                Text(shakti.name)
                    .font(AppFont.sanskrit(40))
                    .foregroundStyle(Color.cream)
                    .tracking(3.2)
                    .multilineTextAlignment(.center)
                    .shadow(color: atmo.glow, radius: 50)
                    .minimumScaleFactor(0.6)
                    .opacity(nameVisible ? 1 : 0)
                    .offset(y: rise(nameVisible, RecognitionTimeline.nameRise))
                    .padding(.horizontal, 44)
                    .padding(.bottom, 28)

                // The 16 Karṣiṇīs carry a bootstrap recognition phrase; the other
                // 86 offer their Airtable appreciation phrase. When neither
                // exists, the divider + phrase simply don't appear.
                if !phraseText.isEmpty {
                    Rectangle()
                        .fill(atmo.accentSoft)
                        .frame(width: 32, height: 0.5)
                        .opacity(phraseVisible ? 1 : 0)
                        .padding(.bottom, 28)

                    Text(phraseText)
                        .font(AppFont.voice(24))
                        .foregroundStyle(Color.cream)
                        .tracking(0.5)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 44)
                        .opacity(phraseVisible ? 1 : 0)
                        .offset(y: rise(phraseVisible, RecognitionTimeline.nameRise))
                }

                Spacer()
            }

            // Bottom block: two acts of recognition + optional note card
            VStack(spacing: 0) {
                Spacer()

                // Act 1
                Text("she was felt here · \(timeString(act1Time))".uppercased())
                    .font(AppFont.label(11))
                    .tracking(1.8)
                    .foregroundStyle(Color.cream.opacity(0.6))
                    .padding(.bottom, 10)
                    .opacity(act1Visible ? 1 : 0)
                    .offset(y: rise(act1Visible, RecognitionTimeline.lineRise))

                // Hairline divider between acts
                Rectangle()
                    .fill(atmo.accentSoft)
                    .frame(width: 22, height: 0.5)
                    .padding(.bottom, 10)
                    .opacity(act2Visible ? 1 : 0)

                // Act 2 — and she felt you back. Timestamp is captured at the
                // moment Act 2 becomes visible, not pre-computed — so it reads
                // the real time the practitioner received the reciprocity.
                Text("and she felt you back · \(timeStringWithSeconds(act2Time ?? act1Time.addingTimeInterval(3)))")
                    .font(AppFont.voice(15))
                    .foregroundStyle(atmo.accentBright)
                    .tracking(0.7)
                    .shadow(color: atmo.glow, radius: 14)
                    .padding(.bottom, 22)
                    .opacity(act2Visible ? 1 : 0)
                    .offset(y: rise(act2Visible, RecognitionTimeline.lineRise))

                // Optional note card
                if noteCardVisible {
                    NoteCard(text: $note)
                        .frame(maxWidth: 280)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .padding(.bottom, 30)
                }

                Text("Tap anywhere to close".uppercased())
                    .font(AppFont.label(11))
                    .tracking(2)
                    .foregroundStyle(Color.cream.opacity(0.50))
                    .opacity(noteCardVisible ? 1 : 0)
                    .padding(.bottom, 36)
            }
        }
    }

    // MARK: - The ceremony's timeline

    private func stage() {
        guard !hasLogged else { return }
        hasLogged = true
        act1Time = .now

        // Practice data first: the recognition is written before a single
        // light moves, so nothing the ceremony does can cost the record.
        let store = RecognitionLogStore(context: context)
        store.record(
            khadgamalaPosition: shakti.khadgamalaPositionOrFallback,
            ringNumber: shakti.ringNumber ?? 2,
            gesture: .felt
        )
        // The rite is complete — silence the evening summons. Never twice.
        DailySummons.markRiteCompleted(at: act1Time)

        // Debug: `RECOGNIZE_AUTOCLOSE` closes the ceremony on its own after it lands,
        // so the live close → didSettle → Portrait handoff can be exercised headlessly.
        if ProcessInfo.processInfo.arguments.contains("RECOGNIZE_AUTOCLOSE") {
            DispatchQueue.main.asyncAfter(deadline: .now() + RecognitionTimeline.autoClose) { beginClose() }
        }

        // Her nature's response begins with her name: her geometry first,
        // her bīja with her phrase. Under reduce motion each nature is its
        // still light, and only the words' arrival moves (by fading).
        if !reduceMotion {
            let swing = nature.swing
            let bijaSwing = nature.bijaSwing
            let repeats = nature.repeats
            DispatchQueue.main.asyncAfter(deadline: .now() + RecognitionTimeline.name) {
                let curve = Animation.easeInOut(duration: swing)
                withAnimation(repeats ? curve.repeatForever(autoreverses: true) : curve) { respPhase = 1 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + RecognitionTimeline.phrase) {
                let curve = Animation.easeInOut(duration: bijaSwing)
                withAnimation(repeats ? curve.repeatForever(autoreverses: true) : curve) { bijaPhase = 1 }
            }
        }

        let arrive = Animation.easeInOut(duration: RecognitionTimeline.arrive)
        withAnimation(arrive.delay(RecognitionTimeline.name))   { nameVisible = true }
        withAnimation(arrive.delay(RecognitionTimeline.phrase)) { phraseVisible = true }
        withAnimation(arrive.delay(RecognitionTimeline.act1))   { act1Visible = true }

        // Act 2 — capture timestamp at the moment it actually appears so the
        // "she felt you back · h:mm:ss" reflects the practitioner's real time,
        // not a pre-computed Act1 + 3s offset.
        DispatchQueue.main.asyncAfter(deadline: .now() + RecognitionTimeline.act2) { feltBack() }

        // Note card lands after reciprocity, alone — never simultaneously, so
        // "and she felt you back" gets to land in stillness.
        DispatchQueue.main.asyncAfter(deadline: .now() + RecognitionTimeline.note) {
            withAnimation(arrive) { noteCardVisible = true }
        }
    }

    /// "and she felt you back" — the words, her light answering once, her
    /// pulse in the hand and her bīja in the ear. Her tone keeps its own
    /// pitch, sounded the way every bīja in the instrument is sounded.
    private func feltBack() {
        guard !closing else { return }
        act2Time = .now
        withAnimation(.easeInOut(duration: RecognitionTimeline.arrive)) { act2Visible = true }
        withAnimation(.easeInOut(duration: RecognitionTimeline.answerLift)) { answered = true }
        RecognitionHaptic.play(nature.pulse)
        BijaSoundService.shared.playBija(shakti.bija, seed: shakti.khadgamalaPosition ?? shakti.position)
    }

    /// The close: his words and the ledger write are committed first, then the
    /// ceremony gathers into the point, her after-glow stays a moment and
    /// falls away, and only then does she settle into the Portrait.
    private func beginClose() {
        guard !closing else { return }
        commitClose()
        let whole = RecognitionTimeline.closeDuration(reduceMotion: reduceMotion)
        if reduceMotion {
            withAnimation(.easeOut(duration: 0.4)) { closing = true }
            afterGlowing = true
        } else {
            withAnimation(.easeIn(duration: RecognitionTimeline.collapse)) { closing = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + RecognitionTimeline.collapse) {
                afterGlowing = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + whole) { settle() }
    }

    /// Practice data, before any light moves: the note onto his local moment,
    /// then the ledger write with where she was felt from. Once only.
    private func commitClose() {
        guard !noteCommitted else { return }
        noteCommitted = true
        // Persist note locally if user wrote anything.
        let trimmed = note.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            let store = RecognitionLogStore(context: context)
            if let latest = store.latest(),
               latest.khadgamalaPosition == shakti.khadgamalaPositionOrFallback {
                latest.note = note
                try? context.save()
            }
        }
        // Fire-and-forget Airtable write with the full note. Failure is silent —
        // AirtableService queues for retry. Ceremony has already completed; the
        // visual "and she felt you back" was driven by local write success.
        let noteToSend: String? = trimmed.isEmpty ? nil : trimmed
        let s = shakti
        let ctx = context
        let src = source
        Task {
            await AirtableService.shared.recordRecognition(
                shakti: s, note: noteToSend, source: src, context: ctx
            )
        }
    }

    /// The after-glow has fallen away: hand off.
    private func settle() {
        isPresented = false
        // She settles into Memory — the practitioner sees the newly-lit point
        // in the field of his attention. U2 · the Router carries him there from
        // every source, as Design does (spine-and-home §2 J #73), and back()
        // returns him to where he felt her.
        let src = source
        Task { @MainActor in Router.shared.recognitionSettled(source: src.rawValue) }
    }

    private func timeString(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: d)
    }

    private func timeStringWithSeconds(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "h:mm:ss"
        return f.string(from: d)
    }
}

private struct NoteCard: View {
    @Binding var text: String
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if text.isEmpty && !focused {
                Text("What did you notice?")
                    .font(AppFont.voice(13))
                    .foregroundStyle(Color.cream.opacity(0.50))
                    .tracking(0.5)
            }
            TextField("", text: $text, axis: .vertical)
                .font(AppFont.voice(14))
                .foregroundStyle(Color.cream.opacity(0.85))
                .focused($focused)
                .lineLimit(1...4)
                .tint(Color.gold)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.cream.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.cream.opacity(0.12), lineWidth: 0.5)
                )
        )
        // Don't dismiss the screen when tapping inside the note card.
        .contentShape(Rectangle())
        .onTapGesture { focused = true }
    }
}

private extension Shakti {
    /// Phase-2 convenience: prefer the synced Khaḍgamālā position, fall back
    /// to deriving from the legacy `position` field for Ring 2 entries that
    /// haven't been seeded by Airtable yet (Bootstrap sets both; this guard
    /// covers any edge case where a Shakti exists pre-sync).
    var khadgamalaPositionOrFallback: Int {
        khadgamalaPosition ?? (position + 28)
    }
}
