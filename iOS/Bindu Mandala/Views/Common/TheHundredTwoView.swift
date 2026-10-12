import SwiftUI
import SwiftData

/// The Field — the 102 as a descent through nine rings, lit by the day's
/// atmosphere. Reached via the hamburger menu. One ring opens at a time (an
/// accordion, defaulting to today's ring); each seat's dot brightens with how
/// often she has been felt. Tapping a Śakti pushes ShaktiDetailView; tapping a
/// ring header's "the threshold" opens the Avaraṇa threshold.
/// Ported from the prototype's `FieldScreen` / `FieldRing`.
///
/// Wave 1 · lit as Design's Field: the day's ground with its crown of glow
/// (`Backdrop.crown`, an ellipse 130% × 40% — the port drew a circle), every
/// ring's chip at the brightness Design drew it (it was 2–4× fainter), the open
/// ring's geometry filling its room at 0.5, and each ring breathing at its own
/// rate (`FieldBreath`). "Enter her ring" on the threshold comes back here and
/// opens that ring.
struct TheHundredTwoView: View {
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    @Query private var recognitions: [RecognitionEntry]
    /// What each room remembers — read only as a state (has he stood here),
    /// for the climb's core lights.
    @Query private var rooms: [HomeMemory]
    /// Wave 2 · the room a seat's doorway opened. See ``HerRoomDoor``.
    @State private var roomKp: Int?

    @State private var detailFor: Shakti?
    @State private var thresholdFor: Avarana?
    @State private var openRing: Int?
    @State private var userToggled = false
    /// Phase 3.7 — the way onto the axis. See ``theClimbDoor``.
    @State private var showClimb = false
    /// The ring "enter her ring" asked to be brought into view.
    @State private var scrollTarget: Int?

    /// The open ring. Until the practitioner touches the accordion it follows
    /// today's ring — computed at render, so it's correct even if the store
    /// resolves after first appearance (which an `onAppear` seed would miss).
    private var effectiveOpen: Int? { userToggled ? openRing : todayRing }

    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $detailFor) { shakti in
                    ShaktiDetailView(shakti: shakti, backLabel: "the field", source: .field)
                }
                .navigationDestination(item: $thresholdFor) { avarana in
                    AvaranaThresholdView(avarana: avarana,
                                         ringAtmosphere: ringAtmosphere(avarana.ringNumber),
                                         onEnter: { enterRing(avarana.ringNumber) })
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
                           seats: climbSeats,
                           met: metKp,
                           todayKp: todayPos,
                           startingAtRing: effectiveOpen ?? todayRing,
                           forceReduceMotion: AppRuntime.forcesReduceMotion,
                           onLeft: { showClimb = false })
        }
        // Wave 2 · one building: a seat's doorway opens her room, through
        // her rite, from the Field.
        .herRoom($roomKp)
    }

    /// The 102 for the climb, with the names and qualities the base gives them.
    private var climbSeats: [ClimbLights.Seat] {
        var byKp: [Int: Shakti] = [:]
        for s in shaktis { if let kp = s.khadgamalaPosition { byKp[kp] = s } }
        return (1...KhadgamalaMap.total).map { kp in
            ClimbLights.Seat(kp: kp, name: byKp[kp]?.name ?? "", quality: byKp[kp]?.quality ?? "")
        }
    }

    /// The Śaktis he has stood with or felt — a state, never a count: they
    /// carry Design's core light on the climb (*she was expecting you*).
    private var metKp: Set<Int> {
        let felt = Set(countByKp.filter { $0.value > 0 }.map { $0.key })
        let stood = Set(rooms.filter { $0.known }.map { $0.khadgamalaPosition })
        return felt.union(stood)
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
            LightField(layers: Backdrop.crown(dayAtmo))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                ScrollViewReader { proxy in
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
                                        onEnterRoom: { kp in Haptics.medium(); roomKp = kp },
                                        onOpenThreshold: {
                                            if let av = avaranas.first(where: { $0.ringNumber == ring }) {
                                                Haptics.light(); thresholdFor = av
                                            }
                                        }
                                    )
                                    .id(ring)
                                }
                            }
                            Color.clear.frame(height: 32)
                        }
                    }
                    .onChange(of: scrollTarget) { _, target in
                        guard let target else { return }
                        withAnimation(.easeInOut(duration: 0.6)) { proxy.scrollTo(target, anchor: .top) }
                        scrollTarget = nil
                    }
                }
            }
        }
    }

    /// A ring's own light — the atmosphere of its first seat, as its row wears
    /// it — or, before the store holds that ring, the light of its first
    /// Khaḍgamālā position.
    private func ringAtmosphere(_ ring: Int) -> Atmosphere {
        if let first = (shaktisByRing[ring] ?? []).min(by: { $0.position < $1.position }) {
            return Atmosphere.derive(from: first)
        }
        let firstKp = [1: 1, 2: 29, 3: 45, 4: 53, 5: 67, 6: 77, 7: 87, 8: 99, 9: 102][ring] ?? 1
        return Atmosphere.derive(ring: ring, cluster: ring == 2 ? .inner : nil,
                                 khadgamala: firstKp, element: Element.forRing(ring))
    }

    /// "Enter her ring": the threshold steps back, and the ring it stood at
    /// opens and comes into view — the threshold was the way into this room.
    private func enterRing(_ ring: Int) {
        Haptics.medium()
        thresholdFor = nil
        withAnimation(.easeInOut(duration: 0.34)) {
            userToggled = true
            openRing = ring
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { scrollTarget = ring }
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
    ///
    /// This was the ONE screen in the app that reached past
    /// ``AppRuntime/pinnedEnergyPosition`` to the calendar directly, and it cost
    /// the composition lock a red on the ~16 days in 102 when today's Śakti falls
    /// in Ring 2 — the only ring a `SYNC_OFF` launch seeds. On the other 86 days
    /// she is absent from the roster, `todayShakti` is nil, and no seat is marked;
    /// on those sixteen she is found and marked, and the baseline (recorded on one
    /// of the 86) reported a composition that had moved. The app was right both
    /// times. Honouring the override makes the Field answer to the same pin every
    /// other screen already obeys, so the suite no longer depends on the date.
    private var todayPos: Int { AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition() }
    private var todayShakti: Shakti? { shaktis.first { $0.khadgamalaPosition == todayPos } }
    private var todayRing: Int { todayShakti?.ringNumber ?? 2 }

    /// The whole Field wears today's light.
    private var dayAtmo: Atmosphere { DayLight.atmosphere(shaktis, position: todayPos) }

    /// How often each seat has been felt — local recognitions merged with the
    /// server count, so a just-felt Śakti lights immediately and history persists.
    private var countByKp: [Int: Int] {
        var m: [Int: Int] = [:]
        // A silence is its own gesture: it never lights a seat as felt (Wave 0 · B3).
        for r in recognitions where r.gesture == .felt {
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
    /// Wave 2 · her doorway: her room, through her rite.
    let onEnterRoom: (Int) -> Void
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
                // Ring sigil chip — her geometry at full light, breathing at
                // the ring's own rate, turning and glowing when the room is open.
                RingChip(ring: ring, atmo: ringAtmo, open: open)

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
            // The ring's geometry filling the room you've entered — at the 0.5
            // Design gave it, breathing at the ring's rate.
            RingRoomGeometry(ring: ring, atmo: ringAtmo)
        )
        .background(LinearGradient(colors: [ringAtmo.groundDeep, ringAtmo.groundDeep.opacity(0)],
                                   startPoint: .top, endPoint: .bottom))
    }

    private func seatRow(_ seat: Shakti) -> some View {
        let kp = seat.khadgamalaPosition ?? (seat.position + 28)
        let isToday = kp == todayKp
        let count = countByKp[kp] ?? 0
        let felt = count > 0
        let sAtmo = Atmosphere.derive(from: seat)
        return HStack(spacing: 0) {
            seatButton(seat, isToday: isToday, felt: felt, sAtmo: sAtmo)
            // Wave 2 · her doorway — a small arch of her light. The row opens
            // what is known of her; the arch opens her room, through her rite.
            Button {
                onEnterRoom(kp)
            } label: {
                DoorwayArch(colour: sAtmo.accentBright)
                    .frame(width: 14, height: 18)
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.trailing, 10)
            .accessibilityLabel(Text("Be with her — enter the room of \(spokenName(seat))"))
        }
        .background(
            isToday
            ? LinearGradient(colors: [sAtmo.accentFaint, .clear], startPoint: .leading, endPoint: .trailing)
            : LinearGradient(colors: [.clear, .clear], startPoint: .leading, endPoint: .trailing)
        )
    }

    private func seatButton(_ seat: Shakti, isToday: Bool, felt: Bool, sAtmo: Atmosphere) -> some View {
        Button {
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

// MARK: - The ring's chip, and the ring's room

/// A ring's chip in the Field's list: her ring's geometry at the light Design
/// drew it (`LrSigil … opacity={2.4}` — clamped, it is full), over a pool of
/// her faint accent. The pool breathes at the ring's own period; the Bhūpura's
/// holds. Open, the geometry turns and her glow stands around it.
private struct RingChip: View {
    let ring: Int
    let atmo: Atmosphere
    let open: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let period = FieldBreath.period(ring: ring)
        let still = reduceMotion || AppRuntime.forcesReduceMotion || period == nil
        ZStack {
            TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: still)) { context in
                let b = still ? 0.5 : FieldBreath.phase(at: context.date.timeIntervalSinceReferenceDate,
                                                        period: period ?? 1)
                Circle()
                    .fill(RadialGradient(gradient: Gradient(colors: [atmo.accentFaint,
                                                                     atmo.accentFaint.opacity(0)]),
                                         center: .center, startRadius: 0, endRadius: 24.4))
                    .scaleEffect(0.92 + 0.16 * b)
                    .shadow(color: open ? atmo.glow : atmo.glow.opacity(0),
                            radius: open ? 8 + 6 * b : 0)
            }
            RiteSigil(atmosphere: atmo, ring: ring, size: 48,
                      spin: ring % 2 == 1 ? 1 : -1, spinning: open)
                .opacity(DayLight.fieldChipOpacity)
        }
        .frame(width: 48, height: 48)
        .accessibilityHidden(true)
    }
}

/// The open ring's geometry, 360 pt, standing at 46% of the room — the light
/// of the enclosure you have walked into. It turns, and it breathes at the
/// ring's rate around the 0.5 Design gave it.
private struct RingRoomGeometry: View {
    let ring: Int
    let atmo: Atmosphere
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let period = FieldBreath.period(ring: ring)
        let still = reduceMotion || AppRuntime.forcesReduceMotion || period == nil
        GeometryReader { geo in
            TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: still)) { context in
                let b = still ? 0.5 : FieldBreath.phase(at: context.date.timeIntervalSinceReferenceDate,
                                                        period: period ?? 1)
                RiteSigil(atmosphere: atmo, ring: ring, size: 360,
                          spin: ring % 2 == 1 ? 1 : -1)
                    .opacity(DayLight.fieldRoomOpacity * (0.88 + 0.24 * b))
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.46)
            }
        }
        .clipped()
        .allowsHitTesting(false)
    }
}

/// Wave 2 · a seat's doorway: the Seven Gates' arch, drawn in her light — a
/// threshold, not a figure.
private struct DoorwayArch: View {
    let colour: Color

    var body: some View {
        ArchShape()
            .stroke(colour, lineWidth: 1.1)
            .shadow(color: colour, radius: 4)
            .accessibilityHidden(true)
    }
}

private struct ArchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = rect.width / 2
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        p.addArc(center: CGPoint(x: rect.midX, y: rect.minY + r), radius: r,
                 startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return p
    }
}
