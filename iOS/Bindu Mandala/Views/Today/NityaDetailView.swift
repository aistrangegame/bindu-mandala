import SwiftUI

/// What presides over today — a Nityā Devī (most days), or Lalitā via the
/// Ring 9 Avaraṇa (full moon), or nothing (pre-sync / no data → card hidden).
enum NityaSlot: Identifiable, Equatable {
    case nitya(NityaDevi)
    case lalita(Avarana)
    case unknown

    var id: String {
        switch self {
        case .nitya(let n):  return "n-\(n.tithiPosition)"
        case .lalita(let a): return "l-\(a.ringNumber)"
        case .unknown:       return "unknown"
        }
    }
}

/// Compact detail sheet for whoever presides today. Half-height by default;
/// drag to large. Swipe down to dismiss. Shown when the practitioner taps
/// the Nityā card on the Today screen.
struct NityaDetailView: View {
    let slot: NityaSlot

    var body: some View {
        ZStack {
            Color.ground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text(display.name)
                        .font(.custom(AppFont.cormorant, size: 42))
                        .tracking(2.5)
                        .foregroundStyle(Color.cream)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(display.tithiLabel)
                        .font(.system(size: 10))
                        .tracking(2.4)
                        .foregroundStyle(Color.gold.opacity(0.7))

                    Rectangle()
                        .fill(Color.gold.opacity(0.4))
                        .frame(width: 32, height: 0.5)

                    if !display.quality.isEmpty {
                        Text(display.quality)
                            .font(.custom(AppFont.cormorantItalic, size: 22))
                            .tracking(0.5)
                            .foregroundStyle(Color.gold)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if !display.description.isEmpty {
                        Text(display.description)
                            .font(.custom(AppFont.cormorant, size: 16))
                            .tracking(0.2)
                            .lineSpacing(6)
                            .foregroundStyle(Color.cream.opacity(0.75))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .preferredColorScheme(.dark)
    }

    private struct Display {
        let name: String
        let tithiLabel: String
        let quality: String
        let description: String
    }

    private var display: Display {
        switch slot {
        case .nitya(let n):
            return Display(
                name: n.sanskritName,
                tithiLabel: "TITHI \(n.tithiPosition)",
                quality: n.quality ?? "",
                description: n.qualityDescription ?? ""
            )
        case .lalita(let a):
            // Pūrṇimā belongs to Lalitā Mahātripurasundarī, who resides in the
            // Bindu. Ring 9's sanskritName ("Sarvānandamaya Chakra") is the
            // chakra name, not the presiding goddess — so we name her directly.
            let quality = (a.subtitle?.trimmingCharacters(in: .whitespaces))
                .flatMap { $0.isEmpty ? nil : $0 } ?? "Sarvānanda · All-Bliss"
            return Display(
                name: "Lalitā Mahātripurasundarī",
                tithiLabel: "PŪRṆIMĀ",
                quality: quality,
                description: a.personalConnection ?? ""
            )
        case .unknown:
            return Display(name: "", tithiLabel: "", quality: "", description: "")
        }
    }
}
