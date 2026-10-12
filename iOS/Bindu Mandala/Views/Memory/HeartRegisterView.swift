import SwiftUI

/// Wave 6 · the heart register's room. His Sa chosen once and remembered; the
/// drone breathing on the one clock; the call, and the silence for his answer.
/// Sound begins on his first touch, never on arrival.
struct HeartRegisterView: View {
    let shakti: Shakti?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var sa = HeartRegister.chosenSa()
    @State private var calling = true
    @State private var sounding = false
    @State private var engine = HeartRegisterEngine()

    private var accent: Color { shakti.map { SeatLighting.accentBright(for: $0) } ?? Color(red: 0.86, green: 0.42, blue: 0.5) }

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.03, blue: 0.05).ignoresSafeArea()
            TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: reduceMotion || !sounding)) { tl in
                let b = sounding && !reduceMotion ? BreathClock.breathPhase(at: tl.date) : 0.4
                RadialGradient(colors: [accent.opacity(0.18 + 0.3 * b), .clear],
                               center: .center, startRadius: 0, endRadius: 260 + 60 * b)
                    .ignoresSafeArea()
                    .blendMode(.plusLighter)
            }
            .allowsHitTesting(false)

            VStack(spacing: 26) {
                HStack {
                    Button {
                        engine.stop()
                        dismiss()
                    } label: {
                        Text("‹ back")
                            .font(AppFont.voice(16))
                            .foregroundStyle(Color.gold)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                .padding(.horizontal, 20)

                Text("The Heart Register")
                    .font(AppFont.sanskrit(30))
                    .foregroundStyle(Color.gold)
                Text(shakti.map { "at the heart, with \($0.name)" } ?? "at the heart")
                    .font(AppFont.voice(16))
                    .foregroundStyle(Color.cream.opacity(0.6))

                Spacer()

                Button {
                    Haptics.medium()
                    if sounding {
                        engine.stop()
                        sounding = false
                    } else {
                        engine.start(saHz: HeartRegister.saChoices[sa].hz, calling: calling)
                        sounding = true
                    }
                } label: {
                    ZStack {
                        Circle()
                            .stroke(accent.opacity(0.5), lineWidth: 1)
                            .frame(width: 150, height: 150)
                        BinduPoint(size: 14, color: accent, breathes: sounding)
                    }
                    .frame(width: 170, height: 170)
                    .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(sounding ? "Let the drone rest" : "Begin the drone")

                Text(sounding
                     ? (calling ? "It calls. In the silence, sing it back." : "The drone holds. Sing into it.")
                     : "Touch the point to begin.")
                    .font(AppFont.voice(17))
                    .foregroundStyle(Color.cream.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                VStack(spacing: 14) {
                    HStack(spacing: 10) {
                        Text("your Sa")
                            .font(AppFont.voice(15))
                            .foregroundStyle(Color.cream.opacity(0.6))
                        ForEach(HeartRegister.saChoices.indices, id: \.self) { i in
                            Button {
                                Haptics.light()
                                sa = i
                                HeartRegister.choose(sa: i)
                                engine.setSa(HeartRegister.saChoices[i].hz)
                            } label: {
                                Text(HeartRegister.saChoices[i].name)
                                    .font(AppFont.sanskrit(18))
                                    .foregroundStyle(i == sa ? Color.cream : Color.cream.opacity(0.55))
                                    .frame(minWidth: 36, minHeight: 44)
                                    .background(Circle().fill(i == sa ? accent.opacity(0.25) : .clear))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Toggle(isOn: $calling) {
                        Text("call and answer")
                            .font(AppFont.voice(16))
                            .foregroundStyle(Color.cream.opacity(0.75))
                    }
                    .tint(accent)
                    .padding(.horizontal, 40)
                    .onChange(of: calling) { _, on in
                        if sounding { engine.setCalling(on) }
                    }
                }
                .padding(.bottom, 34)
            }
        }
        .preferredColorScheme(.dark)
        .onDisappear { engine.stop() }
    }
}
