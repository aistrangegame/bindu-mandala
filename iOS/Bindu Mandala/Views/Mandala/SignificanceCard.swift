import SwiftUI

/// The card that blooms up when a seat is focused — her name, quality, the family
/// she is threaded to, her bīja to sound, and the way into her full presence.
/// Reads every color from her Atmosphere, so the 86 are lit by their own light
/// and never the false `.inner` gold (Ruling 7 / R3).
struct SignificanceCard: View {
    let shakti: Shakti
    let atmo: Atmosphere
    let familyCount: Int
    let familyLabel: String
    var onSound: () -> Void
    var onOpenDetail: () -> Void
    var onClose: () -> Void

    private var phonetic: String? {
        let p = shakti.phonetic.trimmingCharacters(in: .whitespaces)
        return p.isEmpty ? nil : p
    }
    private var bijaSyllable: String? { shakti.bijaSyllable }
    private var significance: String? {
        let q = shakti.qualityDescription.trimmingCharacters(in: .whitespaces)
        if !q.isEmpty { return q }
        let poem = shakti.somaticPoetry.trimmingCharacters(in: .whitespaces)
        return poem.isEmpty ? nil : poem
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(familyLabel.uppercased())
                    .font(AppFont.label(11.5))
                    .tracking(2.4)
                    .foregroundStyle(atmo.accentBright)
                Spacer()
                Button(action: onClose) {
                    Text("×").font(.system(size: 22, weight: .light)).foregroundStyle(Color.cream.opacity(0.5))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 8)

            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(shakti.name)
                        .font(AppFont.sanskrit(30))
                        .foregroundStyle(Color.cream)
                    if let phonetic {
                        Text(phonetic.uppercased())
                            .font(AppFont.label(11.5)).tracking(2)
                            .foregroundStyle(Color.cream.opacity(0.55))
                            .padding(.top, 7)
                    }
                    if !shakti.quality.trimmingCharacters(in: .whitespaces).isEmpty {
                        Text(shakti.quality)
                            .font(AppFont.sanskrit(18))
                            .foregroundStyle(atmo.accentBright)
                            .padding(.top, 9)
                    }
                    if familyCount > 0 {
                        Text("threaded to \(familyCount) \(familyCount == 1 ? "sister" : "sisters")")
                            .font(AppFont.voice(13))
                            .foregroundStyle(Color.cream.opacity(0.5))
                            .padding(.top, 8)
                    }
                }
                Spacer(minLength: 0)
                if let bijaSyllable {
                    Button(action: onSound) {
                        VStack(spacing: 4) {
                            Text(bijaSyllable)
                                .font(AppFont.sanskrit(40))
                                .foregroundStyle(Color.gold)
                                .shadow(color: atmo.glow, radius: 18)
                            Text("SOUND HER")
                                .font(AppFont.label(11.5)).tracking(1.8)
                                .foregroundStyle(Color.cream.opacity(0.55))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            if let significance {
                Text(significance)
                    .font(AppFont.voice(14))
                    .lineSpacing(4)
                    .foregroundStyle(Color.cream.opacity(0.72))
                    .lineLimit(3)
                    .padding(.top, 12)
            }

            Button(action: onOpenDetail) {
                Text("enter her presence")
                    .font(AppFont.sanskrit(17))
                    .tracking(1.6)
                    .foregroundStyle(Color.cream)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 46)
                    .background(Capsule().fill(Color.accentRed))
            }
            .buttonStyle(.plain)
            .padding(.top, 14)
        }
        .padding(EdgeInsets(top: 18, leading: 20, bottom: 16, trailing: 20))
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.ground.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(atmo.accentSoft, lineWidth: 1))
                .shadow(color: atmo.glow, radius: 30, y: 8)
        )
    }
}
