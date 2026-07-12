import SwiftUI
import SwiftData

/// The Field — the 102 as a descent through nine rings, lit by the day's
/// atmosphere. Reached via the hamburger menu. One ring opens at a time (an
/// accordion, defaulting to today's ring); each seat's dot brightens with how
/// often she has been felt. Tapping a Śakti pushes ShaktiDetailView; tapping a
/// ring header's "the threshold" opens the Avaraṇa threshold.
/// Ported from the prototype's `FieldScreen` / `FieldRing`.
struct TheHundredTwoView: View {
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    @Query private var recognitions: [RecognitionEntry]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var detailFor: Shakti?
    @State private var thresholdFor: Avarana?
    @State private var openRing: Int?
    @State private var userToggled = false

    /// The open ring. Until the practitioner touches the accordion it follows
    /// today's ring — computed at render, so it's correct even if the store
    /// resolves after first appearance (which an `onAppear` seed would miss).
    private var effectiveOpen: Int? { userToggled ? openRing : todayRing }

    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $detailFor) { shakti in
                    ShaktiDetailView(shakti: shakti, backLabel: "the field")
                }
                .navigationDestination(item: $thresholdFor) { avarana in
                    AvaranaThresholdView(avarana: avarana)
                }
        }
    }

    private var content: some View {
        ZStack {
            // The day's atmosphere as the ground, her glow pooling at the crown.
            LinearGradient(colors: [dayAtmo.ground, dayAtmo.groundDeep],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            RadialGradient(gradient: Gradient(colors: [dayAtmo.glow, .clear]),
                           center: UnitPoint(x: 0.5, y: -0.05), startRadius: 0, endRadius: 460)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                header
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(1...9, id: \.self) { ring in
                            let inRing = (shaktisByRing[ring] ?? []).sorted { $0.position < $1.position }
                            if !inRing.isEmpty {
                                FieldRing(
                                    ring: ring,
                                    avarana: avaranas.first(where: { $0.ringNumber == ring }),
                                    seats: inRing,
                                    ringAtmo: Atmosphere.derive(from: inRing[0]),
                                    todayKp: todayPos,
                                    todayRing: todayRing,
                                    countByKp: countByKp,
                                    open: effectiveOpen == ring,
                                    reduceMotion: reduceMotion,
                                    onToggle: {
                                        Haptics.light()
                                        withAnimation(.easeInOut(duration: 0.34)) {
                                            let cur = effectiveOpen
                                            userToggled = true
                                            openRing = (cur == ring) ? nil : ring
                                        }
                                    },
                                    onOpenShakti: { Haptics.light(); detailFor = $0 },
                                    onOpenThreshold: {
                                        if let av = avaranas.first(where: { $0.ringNumber == ring }) {
                                            Haptics.light(); thresholdFor = av
                                        }
                                    }
                                )
                            }
                        }
                        Color.clear.frame(height: 32)
                    }
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("The Field")
                .font(.custom(AppFont.cormorant, size: 30))
                .fontWeight(.light)
                .tracking(1.6)
                .foregroundStyle(Color.cream)
            Text("NINE RINGS · ONE HUNDRED AND TWO")
                .font(.system(size: 10.5))
                .tracking(2.4)
                .foregroundStyle(Color.cream.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 14)
        .padding(.bottom, 14)
        .overlay(Rectangle().fill(Color.gold.opacity(0.12)).frame(height: 0.5), alignment: .bottom)
    }

    // MARK: - Derived state

    /// Pre-sync legacy rows have nil ringNumber but are always Karṣiṇīs (Ring 2).
    private var shaktisByRing: [Int: [Shakti]] {
        Dictionary(grouping: shaktis) { $0.ringNumber ?? 2 }
    }

    /// Today's energy — the same all-102 selection the Rite shows (Ruling 3).
    private var todayPos: Int { DailyEnergyService.todaysPosition() }
    private var todayShakti: Shakti? { shaktis.first { $0.khadgamalaPosition == todayPos } }
    private var todayRing: Int { todayShakti?.ringNumber ?? 2 }

    /// The whole Field wears today's light.
    private var dayAtmo: Atmosphere {
        if let t = todayShakti {
            return Atmosphere.derive(from: t, at: LunarPhaseService.currentTimeVariant())
        }
        return Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: todayPos,
                                 element: .ether, at: LunarPhaseService.currentTimeVariant())
    }

    /// How often each seat has been felt — local recognitions merged with the
    /// server count, so a just-felt Śakti lights immediately and history persists.
    private var countByKp: [Int: Int] {
        var m: [Int: Int] = [:]
        for r in recognitions {
            m[r.khadgamalaPosition, default: 0] += 1
        }
        for s in shaktis {
            let kp = s.khadgamalaPosition ?? (s.position + 28)
            m[kp] = max(m[kp] ?? 0, s.serverRecognitionCount ?? 0)
        }
        return m
    }
}

// MARK: - One ring of the Field (accordion row)

private struct FieldRing: View {
    let ring: Int
    let avarana: Avarana?
    let seats: [Shakti]
    let ringAtmo: Atmosphere
    let todayKp: Int
    let todayRing: Int
    let countByKp: [Int: Int]
    let open: Bool
    let reduceMotion: Bool
    let onToggle: () -> Void
    let onOpenShakti: (Shakti) -> Void
    let onOpenThreshold: () -> Void

    private var holdsToday: Bool { todayRing == ring }

    var body: some View {
        VStack(spacing: 0) {
            ringHeader
            if open { expandedBody }
        }
        .overlay(Rectangle().fill(Color.gold.opacity(0.10)).frame(height: 0.5), alignment: .bottom)
    }

    private var ringHeader: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // Ring sigil chip — her geometry, glowing when the room is open.
                ZStack {
                    Circle()
                        .fill(RadialGradient(gradient: Gradient(colors: [ringAtmo.accentFaint, .clear]),
                                             center: .center, startRadius: 0, endRadius: 24))
                    RiteSigil(atmosphere: ringAtmo, ring: ring, size: 44,
                              spin: ring % 2 == 1 ? 1 : -1, reduceMotion: reduceMotion)
                        .opacity(open ? 0.9 : 0.5)
                }
                .frame(width: 48, height: 48)
                .shadow(color: open ? ringAtmo.glow : .clear, radius: open ? 16 : 0)

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 10) {
                        Text(ringName)
                            .font(.custom(AppFont.cormorant, size: 21))
                            .tracking(0.6)
                            .foregroundStyle(open ? ringAtmo.accentBright : Color.cream)
                        if holdsToday {
                            Circle()
                                .fill(ringAtmo.accentBright)
                                .frame(width: 7, height: 7)
                                .shadow(color: ringAtmo.accentBright, radius: 5)
                        }
                    }
                    if let sub = avarana?.subtitle, !sub.isEmpty {
                        Text(sub)
                            .font(.custom(AppFont.cormorantItalic, size: 14.5))
                            .foregroundStyle(Color.cream.opacity(0.55))
                    }
                }
                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(seats.count)")
                        .font(.system(size: 10.5))
                        .tracking(1.0)
                        .foregroundStyle(ringAtmo.accentBright)
                    Text("›")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.cream.opacity(0.4))
                        .rotationEffect(.degrees(open ? 90 : 0))
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(
                open
                ? LinearGradient(colors: [ringAtmo.accentFaint, .clear],
                                 startPoint: .leading, endPoint: .trailing)
                : LinearGradient(colors: [.clear, .clear], startPoint: .leading, endPoint: .trailing)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var expandedBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Atmosphere caption — her ring's form / mental state, and the threshold.
            HStack(alignment: .center, spacing: 10) {
                if let form = avarana?.form, !form.isEmpty {
                    Text(form.uppercased())
                        .font(.system(size: 10))
                        .tracking(2.4)
                        .foregroundStyle(ringAtmo.accentBright)
                }
                if let mental = avarana?.mentalState, !mental.isEmpty {
                    Text(mental)
                        .font(.custom(AppFont.cormorantItalic, size: 14))
                        .foregroundStyle(Color.cream.opacity(0.6))
                }
                Spacer(minLength: 8)
                if avarana != nil {
                    Button(action: onOpenThreshold) {
                        Text("the threshold ›")
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(0.4)
                            .foregroundStyle(ringAtmo.accentBright)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 26)
            .padding(.top, 8)
            .padding(.bottom, 12)

            ForEach(seats) { seat in
                seatRow(seat)
            }
        }
        .padding(.bottom, 14)
        .background(
            // The ring's geometry, faint, filling the room you've entered.
            Color.clear.overlay(
                RiteSigil(atmosphere: ringAtmo, ring: ring, size: 340,
                          spin: ring % 2 == 1 ? 1 : -1, reduceMotion: reduceMotion)
                    .opacity(0.4)
            )
            .clipped()
            .allowsHitTesting(false)
        )
        .background(LinearGradient(colors: [ringAtmo.groundDeep.opacity(0.9), .clear],
                                   startPoint: .top, endPoint: .bottom))
    }

    private func seatRow(_ seat: Shakti) -> some View {
        let kp = seat.khadgamalaPosition ?? (seat.position + 28)
        let isToday = kp == todayKp
        let count = countByKp[kp] ?? 0
        let felt = count > 0
        let sAtmo = Atmosphere.derive(from: seat)
        return Button {
            onOpenShakti(seat)
        } label: {
            HStack(spacing: 14) {
                Circle()
                    .fill(sAtmo.accent)
                    .frame(width: 7, height: 7)
                    .opacity(felt ? 1 : 0.4)
                    .shadow(color: felt ? sAtmo.accentBright : .clear, radius: felt ? 6 : 0)
                Text(seat.name)
                    .font(.custom(AppFont.cormorant, size: 19))
                    .tracking(0.3)
                    .foregroundStyle(Color.cream.opacity(felt ? 1 : 0.82))
                    .accessibilityLabel("\(spokenName(seat)), \(seat.quality)")
                Spacer(minLength: 10)
                if isToday {
                    Text("today")
                        .font(.custom(AppFont.cormorantItalic, size: 13.5))
                        .foregroundStyle(sAtmo.accentBright)
                } else if felt {
                    Text("\(count)")
                        .font(.system(size: 10.5))
                        .foregroundStyle(sAtmo.accentBright)
                        .accessibilityLabel("felt \(count) time\(count == 1 ? "" : "s")")
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isToday
                ? LinearGradient(colors: [sAtmo.accentFaint, .clear], startPoint: .leading, endPoint: .trailing)
                : LinearGradient(colors: [.clear, .clear], startPoint: .leading, endPoint: .trailing)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var ringName: String {
        if let raw = avarana?.sanskritName.trimmingCharacters(in: .whitespaces), !raw.isEmpty {
            return raw
        }
        return "\(ordinal(ring)) Avaraṇa"
    }

    private func spokenName(_ s: Shakti) -> String {
        let p = s.phonetic.trimmingCharacters(in: .whitespacesAndNewlines)
        return p.isEmpty ? s.name : p
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
