import SwiftUI
import SwiftData

/// A directory of the field — all 102 Śaktis organized by Avaraṇa.
/// Reached via the hamburger menu. Tapping a Śakti pushes ShaktiDetailView.
struct TheHundredTwoView: View {
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]

    @State private var detailFor: Shakti?
    @State private var thresholdFor: Avarana?

    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $detailFor) { shakti in
                    ShaktiDetailView(shakti: shakti)
                }
                .navigationDestination(item: $thresholdFor) { avarana in
                    AvaranaThresholdView(avarana: avarana)
                }
        }
    }

    private var content: some View {
        ZStack {
            Color.ground.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("The Field")
                    .font(.custom(AppFont.cormorantItalic, size: 18))
                    .tracking(0.6)
                    .foregroundStyle(Color.gold)
                    .padding(.top, 16)
                    .padding(.bottom, 14)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Rectangle().fill(Color.gold.opacity(0.10)).frame(height: 0.5),
                        alignment: .bottom
                    )

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(1...9, id: \.self) { ring in
                            let inRing = (shaktisByRing[ring] ?? [])
                                .sorted { $0.position < $1.position }
                            if !inRing.isEmpty {
                                avaranaSection(ring: ring, shaktis: inRing)
                            }
                        }
                        Color.clear.frame(height: 32)
                    }
                }
            }
        }
    }

    /// Pre-sync legacy rows have nil ringNumber but are always Karṣiṇīs (Ring 2).
    private var shaktisByRing: [Int: [Shakti]] {
        Dictionary(grouping: shaktis) { $0.ringNumber ?? 2 }
    }

    @ViewBuilder
    private func avaranaSection(ring: Int, shaktis inRing: [Shakti]) -> some View {
        let avarana = avaranas.first(where: { $0.ringNumber == ring })
        let header = avaranaHeader(ring: ring, name: avarana?.sanskritName)

        VStack(alignment: .leading, spacing: 0) {
            if let avarana {
                Button {
                    Haptics.light()
                    thresholdFor = avarana
                } label: {
                    Text(header)
                        .font(.custom(AppFont.cormorantItalic, size: 13.5))
                        .tracking(0.4)
                        .foregroundStyle(Color.gold.opacity(0.85))
                        .padding(.top, 22)
                        .padding(.bottom, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                Text(header)
                    .font(.custom(AppFont.cormorantItalic, size: 13.5))
                    .tracking(0.4)
                    .foregroundStyle(Color.gold.opacity(0.85))
                    .padding(.top, 22)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 24)
            }

            ForEach(inRing) { s in
                shaktiRow(s)
            }
        }
    }

    private func shaktiRow(_ s: Shakti) -> some View {
        Button {
            Haptics.light()
            detailFor = s
        } label: {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                // Each seat lit by her own Atmosphere accent — never the false
                // `.inner` default the 86 carry. Today's seat glows.
                Circle()
                    .fill(SeatLighting.accent(for: s))
                    .frame(width: isToday(s) ? 7 : 5, height: isToday(s) ? 7 : 5)
                    .shadow(color: isToday(s) ? SeatLighting.glow(for: s) : .clear,
                            radius: isToday(s) ? 5 : 0)
                    .alignmentGuide(.firstTextBaseline) { $0[VerticalAlignment.center] }
                Text(s.name)
                    .font(.custom(AppFont.cormorant, size: 16))
                    .foregroundStyle(Color.cream.opacity(isToday(s) ? 1 : 0.92))
                    .accessibilityLabel("\(spokenName(s)), \(s.quality)")
                Spacer(minLength: 12)
                if let dev = s.devanagari, !dev.isEmpty {
                    Text(dev)
                        .font(.system(size: 17))
                        .foregroundStyle(Color.cream.opacity(0.65))
                        .accessibilityLabel("Devanagari: \(spokenName(s))")
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay(
                Rectangle().fill(Color.gold.opacity(0.06)).frame(height: 0.5),
                alignment: .bottom
            )
        }
        .buttonStyle(.plain)
    }

    /// Today's energy — the same all-102 selection the Rite shows (Ruling 3).
    private var todayPos: Int { DailyEnergyService.todaysPosition() }
    private func isToday(_ s: Shakti) -> Bool {
        guard let kp = s.khadgamalaPosition else { return false }
        return kp == todayPos
    }

    /// VoiceOver name — her phonetic when present, else her Sanskrit name (the 86
    /// have no phonetic).
    private func spokenName(_ s: Shakti) -> String {
        let p = s.phonetic.trimmingCharacters(in: .whitespacesAndNewlines)
        return p.isEmpty ? s.name : p
    }

    private func avaranaHeader(ring: Int, name: String?) -> String {
        let ord = ordinal(ring)
        guard let raw = name?.trimmingCharacters(in: .whitespaces), !raw.isEmpty else {
            return "\(ord) Avaraṇa"
        }
        // Airtable names may end in "Chakra" (Anglicized) or "Cakra" (IAST);
        // either way we never want to suffix a duplicate.
        let lowered = raw.lowercased()
        let hasCakra = lowered.contains("cakra") || lowered.contains("chakra")
        let suffix = hasCakra ? "" : " Cakra"
        return "\(ord) Avaraṇa — \(raw)\(suffix)"
    }

    private func ordinal(_ n: Int) -> String {
        switch n {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        default: return "\(n)th"
        }
    }
}
