import SwiftUI

// MARK: - The 33 on the Mandala: the layer's state and its overlay
//
// Everything Wave 3 adds to the living Mandala hangs off two small hooks in
// `LivingMandalaView` — one `@State` value and one overlay — plus one call in
// the canvas and one line in `updateEntered()`. The rest lives here:
//
//   · the **constellation** (✦) — the 33 drawn as light at their
//     addresses, and spoken where they stand;
//   · **walk the road** (☉) — the 33 in their order as one camera path over
//     the same yantra, centre → perimeter → spiralling home; a touch on the
//     glass moves on, and leaving is one touch;
//   · the **thresholds** — Shadow at the 3→4 crossing, Armin at the 6→7 —
//     which any fall through those crossings passes through.
//
// Wave 6.1 · the two switches no longer stand on the glass: they are two of
// the ways in the Mandala's one "ways in" mark (``WaysInRing``), which asks
// through `toggleConstellation()`, `roadAsked` and `leaveRoadAsked`.
//
// The constellation remembers itself on this phone only (a per-viewer
// convenience, never a record). Nothing here writes to the ledger: walking the Road moves a
// camera; it does not log a crossing.

/// The layer's state, held by the Mandala as one `@State` value.
struct ChakraLayerState: Equatable {
    static let constellationKey = "chakra_constellation"

    /// Whether the 33 are drawn. Starts as he left it.
    var constellationOn: Bool = UserDefaults.standard.bool(forKey: ChakraLayerState.constellationKey)
    /// Whether the Road is being walked.
    var walking = false
    /// Where on the Road the walk is standing (an index into the stops).
    var roadIndex = 0
    /// The threshold moments waiting to be passed through, outermost first.
    var thresholds: [Chakra33] = []
    /// The chakra the Road is standing at (its Road position), for the canvas.
    var focusRoad: Int?
    /// Wave 6.1 · the ways-in ring asked for the Road to begin, or to end. The
    /// overlay owns the walk and answers on its next change.
    var roadAsked = false
    var leaveRoadAsked = false

    /// The chakras the canvas draws right now: all 33 while the switch is on
    /// or the Road is being walked, none otherwise.
    var drawn: [Chakra33] {
        (constellationOn || walking) ? ChakraConstellation.all : []
    }

    /// The hook `updateEntered()` calls on an inward crossing: a fall from
    /// `old` to `new` that passes the corridor or the gate queues its moment.
    mutating func noteCrossing(from old: Int, to new: Int) {
        guard !walking else { return }          // the Road sounds its own
        let crossed = ChakraConstellation.thresholdsCrossed(from: old, to: new)
        for c in crossed where !thresholds.contains(where: { $0.road == c.road }) {
            thresholds.append(c)
        }
    }

    mutating func toggleConstellation() {
        constellationOn.toggle()
        UserDefaults.standard.set(constellationOn, forKey: Self.constellationKey)
    }
}

/// The overlay the Mandala lays over its canvas: the Road's words at the foot
/// while walking, the threshold moments, and the constellation's spoken layer
/// (its two switches are ways in the Mandala's one mark since Wave 6.1).
struct ChakraLayerOverlay: View {
    @Binding var state: ChakraLayerState
    @Binding var camera: MandalaCamera
    let size: CGSize
    let seats: [MandalaWorld.Seat]
    let reduceMotion: Bool
    let soundOn: Bool
    /// True while the Bindu is open or the Veil stands — the spoken layer steps
    /// out of the tree, as the garland does.
    let hidden: Bool
    /// Clears the host's own focus and veil before the Road begins.
    let onBeginRoad: () -> Void
    /// Hands the camera back to the host's resting view when the Road ends.
    let onEndRoad: () -> Void

    private var seatPoints: [Int: CGPoint] {
        var out: [Int: CGPoint] = [:]
        for s in seats { out[s.id] = s.point }
        return out
    }

    private var stops: [ChakraRoad.Stop] {
        ChakraRoad.stops(ChakraConstellation.all, seats: seatPoints, in: size)
    }

    /// Wave 6 · the room of the chakra whose light was touched (its Road position).
    @State private var openRoad: Int? = nil

    var body: some View {
        ZStack {
            if state.constellationOn && !state.walking && !hidden {
                // Wave 6 · every light is a door into its chakra's room.
                ChakraConstellationVoices(chakras: ChakraConstellation.all, seats: seats,
                                          camera: camera, size: size,
                                          onOpen: { openRoad = $0 })
            }
            if state.walking {
                roadCatcher
                roadWords
            }
            if let next = state.thresholds.first {
                MandalaThresholdMoment(chakra: next, reduceMotion: reduceMotion, soundOn: soundOn) {
                    if !state.thresholds.isEmpty { state.thresholds.removeFirst() }
                }
                .id(next.road)
                .transition(.opacity)
            }
        }
        .chakraRoom($openRoad)
        // Wave 6.1 · the ways-in ring asks; the walk stays the overlay's own.
        .onChange(of: state.roadAsked) { _, asked in
            guard asked else { return }
            state.roadAsked = false
            if !state.walking { beginRoad() }
        }
        .onChange(of: state.leaveRoadAsked) { _, asked in
            guard asked else { return }
            state.leaveRoadAsked = false
            if state.walking { endRoad() }
        }
    }

    // MARK: The Road

    /// While walking, a touch anywhere on the glass moves on to the next place.
    private var roadCatcher: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture { advance() }
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private var roadWords: some View {
        let all = stops
        if state.roadIndex < all.count {
            let c = all[state.roadIndex].chakra
            let station = ChakraTeaching.station(c)
            VStack(spacing: 6) {
                if let station {
                    Text(station.kicker)
                        .font(AppFont.label(11.5))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundStyle(ChakraConstellationDrawing.tone(c).opacity(0.95))
                }
                Text(c.name)
                    .font(AppFont.sanskrit(28))
                    .tracking(1.2)
                    .foregroundStyle(Color.cream.opacity(0.92))
                if let s = c.subtitle {
                    Text(s)
                        .font(AppFont.voice(16))
                        .foregroundStyle(Color.cream.opacity(0.72))
                        .multilineTextAlignment(.center)
                }
                if let v = c.verb {
                    Text(v)
                        .font(AppFont.label(11.5))
                        .tracking(3.2)
                        .foregroundStyle(ChakraConstellationDrawing.tone(c).opacity(0.9))
                }
                // Wave 6 · the one line at each place on the Road: its Core
                // Question; and at the two stations, the Map's story thread.
                // U0 · ruling 2: the sealed station shows only that it is held.
                if c.isSealed {
                    Text(ChakraConstellation.sealedLine)
                        .font(AppFont.voice(17))
                        .italic()
                        .foregroundStyle(Color.cream.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.top, 6)
                } else if let q = c.coreQuestion {
                    Text(q)
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.82))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 6)
                }
                if station != nil, !c.isSealed, let thread = c.storyThread {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(thread)
                            .font(AppFont.voice(15))
                            .lineSpacing(4)
                            .foregroundStyle(Color.cream.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxHeight: 190)
                    .padding(.top, 8)
                }
                Button {
                    Haptics.medium()
                    openRoad = c.road
                } label: {
                    Text("enter its room")
                        .font(AppFont.label(11.5))
                        .tracking(1.6)
                        .foregroundStyle(Color.gold)
                        .padding(.horizontal, 18)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityHint(c.isSealed ? "Opens its held threshold. The road waits."
                                                : "Opens this chakra's room. The road waits.")
                Button(action: endRoad) {
                    Text("leave the road")
                        .font(AppFont.label(11.5))
                        .tracking(1.6)
                        .foregroundStyle(Color.cream.opacity(0.6))
                        .padding(.horizontal, 18)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 92)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .id(c.road)
            .transition(.opacity)
            .task(id: state.roadIndex) { await walk() }
        }
    }

    private func beginRoad() {
        let all = stops
        guard !all.isEmpty else { return }
        Haptics.soft()
        onBeginRoad()
        state.thresholds = []
        state.roadIndex = 0
        state.walking = true
        fly(to: all[0], from: nil)
    }

    private func endRoad() {
        Haptics.light()
        withAnimation(.easeOut(duration: 0.4)) { state.walking = false }
        state.roadIndex = 0
        onEndRoad()
    }

    private func advance() {
        let all = stops
        let next = state.roadIndex + 1
        guard next < all.count else { endRoad(); return }
        Haptics.light()
        fly(to: all[next], from: all[state.roadIndex])
        withAnimation(.easeInOut(duration: reduceMotion ? 0.2 : 0.8)) { state.roadIndex = next }
    }

    /// The walk's own clock: rest at this place for its breath, then move on.
    /// Restarted whenever the index changes, so a touch that moves on early
    /// simply begins the next rest.
    private func walk() async {
        let all = stops
        guard state.roadIndex < all.count else { return }
        let here = all[state.roadIndex]
        let rest = ChakraRoad.dwell(at: here) + ChakraRoad.travel(
            from: state.roadIndex > 0 ? all[state.roadIndex - 1] : nil, to: here)
        try? await Task.sleep(for: .seconds(rest))
        // Wave 6 · while a room opened from the Road is open, the Road waits.
        while openRoad != nil && !Task.isCancelled {
            try? await Task.sleep(for: .seconds(0.5))
        }
        guard !Task.isCancelled, state.walking else { return }
        advance()
    }

    private func fly(to stop: ChakraRoad.Stop, from: ChakraRoad.Stop?) {
        let target = ChakraRoad.camera(for: stop, in: size)
        state.focusRoad = stop.chakra.road
        if reduceMotion {
            camera = target
        } else {
            withAnimation(.easeInOut(duration: ChakraRoad.travel(from: from, to: stop))) { camera = target }
        }
        // The two crossings are crossed on the Road too.
        if stop.chakra.isThreshold {
            state.thresholds = [stop.chakra]
        }
    }
}
