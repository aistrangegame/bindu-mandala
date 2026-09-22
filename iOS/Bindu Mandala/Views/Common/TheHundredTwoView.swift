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

    @State private var detailFor: Shakti?
    @State private var thresholdFor: Avarana?
    @State private var openRing: Int?
    @State private var userToggled = false
    /// Phase 3.7 — the way onto the axis. See ``theClimbDoor``.
    @State private var showClimb = false

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
                .onAppear {
                    // Debug: `OPEN_THRESHOLD=<ring>` opens that ring's threshold directly.
                    if let arg = ProcessInfo.processInfo.arguments.first(where: { $0.hasPrefix("OPEN_THRESHOLD=") }),
                       let ring = Int(arg.dropFirst("OPEN_THRESHOLD=".count)),
                       let av = avaranas.first(where: { $0.ringNumber == ring }) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { thresholdFor = av }
                    }
                    // Debug: `OPEN_CLIMB` rises onto the axis directly.
                    if ProcessInfo.processInfo.arguments.contains("OPEN_CLIMB") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showClimb = true }
                    }
                }
        }
        .fullScreenCover(isPresented: $showClimb) {
            WorldClimbView(live: liveWorlds,
                           startingAtRing: effectiveOpen ?? todayRing,
                           onLeft: { showClimb = false })
        }
    }

    /// **The way onto the axis, and the argument for it standing here.**
    ///
    /// The climb is the nine āvaraṇas as one continuous space — an enclosure is
    /// a *weather* and a *clock* rather than a place with a door — and the
    /// question Phase 3.7 had to answer is where a walker meets it.
    ///
    /// Not the hamburger. The menu holds five ways of being in the instrument;
    /// the climb is not a sixth, it is what four of them are lists and pictures
    /// **of**, and a menu row would make it their sibling.
    ///
    /// Not the Āvaraṇa threshold, which was the closer call and is the more
    /// beautiful reading — the threshold is the doorway of one enclosure and the
    /// climb is what lies on the other side of it. It is refused on one fact:
    /// `AvaranaThresholdView` needs an `Avarana` row, and those rows live only
    /// in Airtable. On a fresh install, offline, or before the first sync has
    /// answered, the whole climb would be unreachable — and the surface that is
    /// the bulk of Phase 3.2's work may not be gated on the network.
    ///
    /// So it stands here, on the one screen in the app whose subject **is** the
    /// nine. The Mandala's subject is the yantra as a figure, the Rite's is
    /// today, the Well's is what he has written, the Memory's is his own field.
    /// The Field's own second line says *nine rings · one hundred and two* — and
    /// the line beneath it is those nine, walked instead of listed. It opens at
    /// the ring he has open here, so he rises from where he was already standing
    /// rather than from the first āvaraṇa every time.
    private var theClimbDoor: some View {
        Button {
            Haptics.medium()
            showClimb = true
        } label: {
            Text("rise through them ›")
                .font(AppFont.voice(15))
                .tracking(1.2)
                .foregroundStyle(Color.gold.opacity(0.8))
                // As wide as its own words and no wider. A full-width target
                // under a short centred line is a vague one, and it would also
                // reach into the top-trailing corner that `SnapshotScreen`'s
                // `tapHamburger` searches by geometry — the hazard that file
                // already names. Clearing that corner costs nothing here.
                .padding(.horizontal, 28)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Rise through the nine enclosures")
    }

    /// The live āvaraṇa rows the climb reads its names from, keyed by ring.
    /// Empty before the base has been reached, which is exactly what
    /// ``HomeWorlds/world(ring:live:)`` is built to degrade through.
    private var liveWorlds: [Int: HomeWorlds.LiveFacts] {
        var out: [Int: HomeWorlds.LiveFacts] = [:]
        for a in avaranas { out[a.ringNumber] = HomeWorlds.liveFacts(from: a) }
        return out
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
                .font(AppFont.sanskrit(30))
                .fontWeight(.light)
                .tracking(1.6)
                .foregroundStyle(Color.cream)
            Text("NINE RINGS · ONE HUNDRED AND TWO")
                .font(AppFont.label(11.5))
                .tracking(2.4)
                .foregroundStyle(Color.cream.opacity(0.55))
            theClimbDoor
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 14)
        // The door brings its own air: a 15 pt line centred in a 44 pt target
        // stands about fourteen points clear of its own box on each side, so the
        // header's own bottom padding gives eight of them up and the gap under
        // the words is what it was. Eight of the fifty-two points the door costs
        // are paid for here; the other forty-four are classified.
        .padding(.bottom, 6)
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
                              spin: ring % 2 == 1 ? 1 : -1)
                        .opacity(open ? 0.9 : 0.5)
                }
                .frame(width: 48, height: 48)
                .shadow(color: open ? ringAtmo.glow : .clear, radius: open ? 16 : 0)

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 10) {
                        Text(ringName)
                            .font(AppFont.sanskrit(21))
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
                            .font(AppFont.voice(14.5))
                            .foregroundStyle(Color.cream.opacity(0.55))
                    }
                }
                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(seats.count)")
                        .font(AppFont.label(11.5))
                        .tracking(1.0)
                        .foregroundStyle(ringAtmo.accentBright)
                    Text("›")
                        .font(AppFont.label(15))
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
                if let form = avarana?.enclosureForm, !form.isEmpty {
                    Text(form.uppercased())
                        .font(AppFont.label(11.5))
                        .tracking(2.4)
                        .foregroundStyle(ringAtmo.accentBright)
                }
                if let mental = avarana?.mentalState, !mental.isEmpty {
                    Text(mental)
                        .font(AppFont.voice(14))
                        .foregroundStyle(Color.cream.opacity(0.6))
                }
                Spacer(minLength: 8)
                if avarana != nil {
                    Button(action: onOpenThreshold) {
                        Text("the threshold ›")
                            .font(AppFont.voice(14))
                            .tracking(0.4)
                            .foregroundStyle(ringAtmo.accentBright)
                            .padding(.vertical, 14)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 26)
            .padding(.top, avarana == nil ? 8 : 4)
            .padding(.bottom, avarana == nil ? 12 : 8)

            ForEach(seats) { seat in
                seatRow(seat)
            }
        }
        .padding(.bottom, 14)
        .background(
            // The ring's geometry, faint, filling the room you've entered.
            Color.clear.overlay(
                RiteSigil(atmosphere: ringAtmo, ring: ring, size: 340,
                          spin: ring % 2 == 1 ? 1 : -1)
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
                    .font(AppFont.sanskrit(19))
                    .tracking(0.3)
                    .foregroundStyle(Color.cream.opacity(felt ? 1 : 0.82))
                    // Law 2: a felt seat is warmer (dot, glow, full cream), never counted.
                    .accessibilityLabel("\(spokenName(seat)), \(seat.quality)"
                                        + (felt ? ", felt here" : ""))
                Spacer(minLength: 10)
                if isToday {
                    Text("today")
                        .font(AppFont.voice(13.5))
                        .foregroundStyle(sAtmo.accentBright)
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
