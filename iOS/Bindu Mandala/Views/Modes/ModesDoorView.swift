import SwiftUI

/// **The mode door** — Wave 6. One door on the Mandala opens the modes not yet
/// built until now: Darśana, Sādhana, Smṛti, Svapna, Pūjā. Each mode opens in
/// the same cover and returns here when it ends; leaving here returns to the
/// field. Mauna is named but not opened: it arrives, when he is still at the
/// centre (C-1307).
///
/// The door offers all five at every hour — nothing is locked. Only the order
/// leans with the day: at first light the dream comes first, after sunset the
/// offering.
struct ModesDoorView: View {
    let onClose: () -> Void

    @State private var mode: TheModes.Mode?

    var body: some View {
        ZStack {
            Color(red: 4 / 255, green: 1 / 255, blue: 4 / 255).ignoresSafeArea()
            if let mode {
                modeView(mode)
                    .transition(.opacity)
            } else {
                list
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: mode)
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private func modeView(_ m: TheModes.Mode) -> some View {
        let back = { self.mode = nil }
        switch m {
        case .darshana: DarshanaView(onEnd: back)
        case .sadhana:  SadhanaView(onEnd: back)
        case .smriti:   SmritiView(onEnd: back)
        case .svapna:   SvapnaView(onEnd: back)
        case .puja:     PujaView(onEnd: back)
        }
    }

    private var list: some View {
        VStack(spacing: 0) {
            Text("THE MODES")
                .font(AppFont.label(11))
                .tracking(3.2)
                .foregroundStyle(Color.gold.opacity(0.75))
                .padding(.top, 64)
            Text("ways of being with the yantra")
                .font(AppFont.voice(16))
                .foregroundStyle(Color.cream.opacity(0.6))
                .padding(.top, 6)
            Spacer()
            VStack(spacing: 6) {
                ForEach(ModesDoor.order(hour: Calendar.current.component(.hour, from: Date()))) { m in
                    Button {
                        Haptics.light()
                        mode = m
                    } label: {
                        VStack(spacing: 4) {
                            Text(m.title)
                                .font(AppFont.sanskrit(26))
                                .foregroundStyle(Color.cream)
                            Text(m.gloss)
                                .font(AppFont.voice(14))
                                .foregroundStyle(Color.cream.opacity(0.6))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            Text(TheModes.maunaGloss)
                .font(AppFont.voice(14))
                .foregroundStyle(Color.gold.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 22)
            Spacer()
            ModeRestButton(words: "return to the field", action: onClose)
                .padding(.bottom, 30)
        }
        .theEdgeWayOut(onOut: onClose)
    }
}

/// The door's order by the hour — a lean, never a lock.
enum ModesDoor {
    static func order(hour: Int) -> [TheModes.Mode] {
        switch hour {
        case 4..<10:  return [.svapna, .darshana, .sadhana, .smriti, .puja]
        case 17..<24: return [.puja, .darshana, .sadhana, .smriti, .svapna]
        default:      return [.darshana, .sadhana, .smriti, .svapna, .puja]
        }
    }
}
