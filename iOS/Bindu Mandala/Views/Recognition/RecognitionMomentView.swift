import SwiftUI
import SwiftData

/// The Recognition Moment — full-screen takeover after "I feel her".
/// Two acts, separated by a thin gold hairline:
///   Act 1: "she was felt here · [time]"      (muted, sans, uppercase)
///   Act 2: "and she felt you back · [time+3s]" (italic Cormorant, gold)
///
/// On dismiss, posts `didSettleNotification` — RootView listens and
/// navigates to the Portrait, where the newly-lit point glows briefly.
struct RecognitionMomentView: View {
    static let didSettleNotification = Notification.Name("RecognitionMomentDidSettle")

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
    @State private var respPhase: CGFloat = 0   // her element's slow response pulse
    @State private var closing = false          // collapse-into-the-point on exit

    /// Her atmosphere — the ceremony is lit by the same day-palette as everywhere else.
    private var atmo: Atmosphere {
        Atmosphere.derive(from: shakti, at: LunarPhaseService.currentTimeVariant())
    }
    private var recog: RecogElement { RecogElement.forElement(atmo.element) }

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
            let focal = CGPoint(x: geo.size.width * 0.5, y: geo.size.height * recog.focalY)
            let scale = min(geo.size.width, geo.size.height) / 390
            ZStack {
                // Her light pools where her element lives, over a deepening ground.
                atmosphereBackground(focalUnit: UnitPoint(x: 0.5, y: recog.focalY))

                // Her ring's geometry + ghost bīja + ripples, all at the focal,
                // responding in the manner of her element.
                focalLayer(focal: focal, scale: scale)

                DustMotesView(count: recog.motes, element: atmo.element, accent: atmo.accentBright)
                    .allowsHitTesting(false)

                ceremonyText
                    .opacity(closing ? 0 : 1)
                    .scaleEffect(closing ? 0.84 : 1)
                    .animation(.easeIn(duration: 0.6), value: closing)

                if closing { collapseCircle(at: focal) }
            }
            .ignoresSafeArea()
        }
        .background(Color(red: 5/255, green: 2/255, blue: 3/255).ignoresSafeArea())
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

    // MARK: - Atmosphere layers

    private func atmosphereBackground(focalUnit: UnitPoint) -> some View {
        ZStack {
            LinearGradient(colors: [atmo.groundDeep, Color(red: 5/255, green: 2/255, blue: 3/255)],
                           startPoint: .top, endPoint: .bottom)
            RadialGradient(gradient: Gradient(colors: [atmo.glow, .clear]),
                           center: focalUnit, startRadius: 0, endRadius: 520)
        }
        .allowsHitTesting(false)
    }

    /// Sigil + ghost bīja + element ripples, gathered at the focal. All breathe
    /// with `respPhase` in the amplitude/tempo of her element.
    private func focalLayer(focal: CGPoint, scale: CGFloat) -> some View {
        let respScale = 1 + (recog.respScale - 1) * Double(respPhase)
        return ZStack {
            // Element ripples of recognition, emanating from the focal.
            ForEach(0..<recog.rippleN, id: \.self) { i in
                FocalRipple(color: atmo.accentSoft,
                            duration: recog.rippleDur,
                            delay: Double(i) * recog.rippleDur / Double(recog.rippleN),
                            wide: atmo.element == .air,
                            reduceMotion: reduceMotion)
                    .position(focal)
            }

            // Her ring's geometry, spinning, at the focal.
            RiteSigil(atmosphere: atmo, ring: shakti.ringNumber ?? 2,
                      size: 480 * scale, spin: sigilSpin)
                .opacity(0.55 * (nameVisible ? 1 : 0))
                .scaleEffect(respScale)
                .position(focal)

            // Ghost bīja — enormous, faint, staged in with the phrase.
            if !bijaSyllable.isEmpty {
                Text(bijaSyllable)
                    .font(.custom(AppFont.cormorant, size: 300 * scale))
                    .foregroundStyle(atmo.accentFaint)
                    .opacity(0.5 * (phraseVisible ? 1 : 0))
                    .scaleEffect(respScale)
                    .position(focal)
            }
        }
        .allowsHitTesting(false)
    }

    private var sigilSpin: Double {
        (shakti.khadgamalaPosition ?? shakti.position) % 2 == 0 ? 1 : -1
    }

    /// The collapse — the ceremony gathers into the point, handing to the Portrait.
    private func collapseCircle(at focal: CGPoint) -> some View {
        Circle()
            .fill(RadialGradient(
                gradient: Gradient(colors: [atmo.accentBright, atmo.glow, .clear]),
                center: .center, startRadius: 0, endRadius: 150))
            .frame(width: 300, height: 300)
            .scaleEffect(closing ? 0.14 : 1.5)
            .opacity(closing ? 0 : 0.6)
            .position(focal)
            .allowsHitTesting(false)
    }

    // MARK: - Text (name + phrase + two acts)

    private var ceremonyText: some View {
        ZStack {
            // Center: name + divider + appreciation phrase
            VStack(spacing: 0) {
                Spacer()

                Text(shakti.name)
                    .font(.custom(AppFont.cormorant, size: 40))
                    .foregroundStyle(Color.cream)
                    .tracking(3.2)
                    .multilineTextAlignment(.center)
                    .shadow(color: atmo.glow, radius: 50)
                    .minimumScaleFactor(0.6)
                    .opacity(nameVisible ? 1 : 0)
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
                        .font(.custom(AppFont.cormorantItalic, size: 24))
                        .foregroundStyle(Color.cream)
                        .tracking(0.5)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 44)
                        .opacity(phraseVisible ? 1 : 0)
                }

                Spacer()
            }

            // Bottom block: two acts of recognition + optional note card
            VStack(spacing: 0) {
                Spacer()

                // Act 1
                Text("she was felt here · \(timeString(act1Time))".uppercased())
                    .font(.system(size: 11))
                    .tracking(1.8)
                    .foregroundStyle(Color.cream.opacity(0.6))
                    .padding(.bottom, 10)
                    .opacity(act1Visible ? 1 : 0)

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
                    .font(.custom(AppFont.cormorantItalic, size: 15))
                    .foregroundStyle(atmo.accentBright)
                    .tracking(0.7)
                    .padding(.bottom, 22)
                    .opacity(act2Visible ? 1 : 0)

                // Optional note card
                if noteCardVisible {
                    NoteCard(text: $note)
                        .frame(maxWidth: 280)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .padding(.bottom, 30)
                }

                Text("Tap anywhere to close".uppercased())
                    .font(.system(size: 10))
                    .tracking(2)
                    .foregroundStyle(Color.cream.opacity(0.40))
                    .padding(.bottom, 36)
            }
        }
    }

    private func stage() {
        guard !hasLogged else { return }
        hasLogged = true
        act1Time = .now

        // Debug: `RECOGNIZE_AUTOCLOSE` closes the ceremony on its own after it lands,
        // so the live close → didSettle → Portrait handoff can be exercised headlessly.
        if ProcessInfo.processInfo.arguments.contains("RECOGNIZE_AUTOCLOSE") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) { beginClose() }
        }

        let store = RecognitionLogStore(context: context)
        store.record(
            khadgamalaPosition: shakti.khadgamalaPositionOrFallback,
            ringNumber: shakti.ringNumber ?? 2,
            gesture: .felt
        )
        // The rite is complete — silence the evening summons. Never twice.
        DailySummons.markRiteCompleted(at: act1Time)

        if reduceMotion {
            nameVisible = true; phraseVisible = true
            act1Visible = true; act2Visible = true; act2Time = .now
            noteCardVisible = true
            respPhase = 0.5
            return
        }

        // Her element's response — a slow breath at her element's tempo/amplitude.
        withAnimation(.easeInOut(duration: recog.respDur).repeatForever(autoreverses: true)) {
            respPhase = 1
        }

        withAnimation(.easeInOut(duration: 1.8).delay(0.3)) { nameVisible = true }
        withAnimation(.easeInOut(duration: 1.8).delay(0.9)) { phraseVisible = true }
        withAnimation(.easeOut(duration: 1.0).delay(2.6))  { act1Visible = true }

        // Act 2 — capture timestamp at the moment it actually appears so the
        // "she felt you back · h:mm:ss" reflects the practitioner's real time,
        // not a pre-computed Act1 + 3s offset.
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.1) {
            act2Time = .now
            withAnimation(.easeInOut(duration: 1.4)) { act2Visible = true }
        }

        // Note card lands one second after reciprocity, alone — never
        // simultaneously, so "and she felt you back" gets to land in stillness.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
            withAnimation(.easeInOut(duration: 1.4)) { noteCardVisible = true }
        }
    }

    /// The ceremony gathers into the point, then hands off to the Portrait. The
    /// record was already written in `stage()`; this is purely the closing rite.
    private func beginClose() {
        guard !closing else { return }
        if reduceMotion { finishClose(); return }
        withAnimation(.easeIn(duration: 0.62)) { closing = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.62) { finishClose() }
    }

    private func finishClose() {
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
        isPresented = false
        // She settles into the Portrait — the practitioner sees the newly-lit
        // point in the field of their attention. RootView listens for this.
        NotificationCenter.default.post(name: Self.didSettleNotification, object: nil)
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
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .foregroundStyle(Color.cream.opacity(0.50))
                    .tracking(0.5)
            }
            TextField("", text: $text, axis: .vertical)
                .font(.custom(AppFont.cormorantItalic, size: 14))
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

/// Per-element recognition physics — where her light pools, how many motes and
/// ripples move, and the amplitude/tempo of her response when she is felt back.
/// Ported from the prototype's `LR_RECOG` + its response keyframes.
private struct RecogElement {
    let focalY: Double     // vertical focal (x is always centred)
    let motes: Int
    let rippleN: Int
    let rippleDur: Double
    let respScale: Double  // peak of the response breath
    let respDur: Double    // one breath's period

    static func forElement(_ e: Element) -> RecogElement {
        switch e {
        case .fire:  return .init(focalY: 0.60, motes: 12, rippleN: 4, rippleDur: 4.6, respScale: 1.06,  respDur: 5.5)
        case .water: return .init(focalY: 0.50, motes: 10, rippleN: 4, rippleDur: 6.4, respScale: 1.07,  respDur: 6.5)
        case .air:   return .init(focalY: 0.44, motes: 14, rippleN: 5, rippleDur: 4.0, respScale: 1.04,  respDur: 6.0)
        case .ether: return .init(focalY: 0.45, motes: 10, rippleN: 3, rippleDur: 5.6, respScale: 1.16,  respDur: 4.8)
        case .earth: return .init(focalY: 0.54, motes: 6,  rippleN: 2, rippleDur: 7.6, respScale: 1.015, respDur: 7.5)
        case .light: return .init(focalY: 0.44, motes: 12, rippleN: 5, rippleDur: 3.6, respScale: 1.05,  respDur: 3.8)
        }
    }
}

/// A single ripple of recognition, expanding forever from a point at her
/// element's tempo. `wide` disperses horizontally more than vertically — air's way.
private struct FocalRipple: View {
    let color: Color
    let duration: Double
    let delay: Double
    var wide: Bool = false
    let reduceMotion: Bool
    @State private var animating = false

    var body: some View {
        Circle()
            .stroke(color, lineWidth: 0.8)
            .frame(width: 12, height: 12)
            .scaleEffect(x: animating ? (wide ? 52 : 30) : 0.6,
                         y: animating ? (wide ? 20 : 30) : 0.6)
            .opacity(animating ? 0 : 0.5)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: false).delay(delay)) {
                    animating = true
                }
            }
            .allowsHitTesting(false)
    }
}
