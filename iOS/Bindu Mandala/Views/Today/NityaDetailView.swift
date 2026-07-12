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

                    // The framing line — generated from the tithi, always present.
                    // (The design shows this italic line unconditionally; it never
                    //  depended on the null-in-seed `quality` field.)
                    if !display.framing.isEmpty {
                        Text(display.framing)
                            .font(.custom(AppFont.cormorantItalic, size: 21))
                            .tracking(0.3)
                            .lineSpacing(4)
                            .foregroundStyle(Color.gold)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // The fixed devotional prose — what a Nityā *is*. Always shown,
                    // per the prototype (rendered outside its full-moon branch).
                    Text(display.body)
                        .font(.custom(AppFont.cormorant, size: 16.5))
                        .tracking(0.2)
                        .lineSpacing(6)
                        .foregroundStyle(Color.cream.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
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
        let framing: String   // the italic line beneath the hairline
        let body: String      // the fixed devotional prose
    }

    /// The fixed prose that names what a Nityā *is* — shown for every day,
    /// full moon included (ported verbatim from the prototype's NityaSheet).
    private static let bodyProse =
        "The Nityā is the mood of the day itself — the goddess of this moon-phase, "
        + "presiding above whichever of the 102 arrives to be felt. She frames the "
        + "encounter without competing with it."

    private var display: Display {
        switch slot {
        case .nitya(let n):
            let tithi = n.tithiDisplayName
            // Śukla (waxing) vs Kṛṣṇa (waning) — the paksha the day sits in.
            let paksha = LunarPhaseService.currentDay() <= 15 ? "ŚUKLA" : "KṚṢṆA"
            return Display(
                name: n.sanskritName,
                tithiLabel: "\(paksha) · \(tithi.uppercased())",
                framing: "She presides over \(tithi) — one of the fifteen Nityā Devīs "
                    + "who turn the lunar fortnight.",
                body: Self.bodyProse
            )
        case .lalita:
            // Pūrṇimā belongs to Lalitā Mahātripurasundarī, who resides in the
            // Bindu. Ring 9's sanskritName ("Sarvānandamaya Chakra") is the
            // chakra name, not the presiding goddess — so we name her directly.
            return Display(
                name: "Lalitā Mahātripurasundarī",
                tithiLabel: "PŪRṆIMĀ",
                framing: "Pūrṇimā — the full moon belongs to Lalitā, seated in the "
                    + "Bindu, from whom the whole yantra breathes.",
                body: Self.bodyProse
            )
        case .unknown:
            return Display(name: "", tithiLabel: "", framing: "", body: "")
        }
    }
}
