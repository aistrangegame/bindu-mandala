import SwiftUI
import SwiftData
import UIKit

// MARK: - Wave 6 · the 33 alive — a chakra's room
//
// Touch one of the 33 — a light in the Mandala's constellation, or one of the
// ten body chakras on the Climb — and its room opens. The room is the Map's own
// row, in the order the Chakras brief walks a room (arrival → story → practice
// → wake-up → gate), and every word in it is a cell of that row:
//
//   · **arrival** — whose voice speaks here, the name, the subtitle, the verb,
//     the Core Question, the Hero Threshold; the Signature Phrase as the seed;
//   · **story** — the Story Thread, and behind it the voice layers (Act 1 and
//     Act 2, the Bindu's reflection, the witness), one at a time;
//   · **practice** — the Practice Prompt and the Three Ways In, three doors;
//     and in the body's rooms, the held movements and breaths from his Codex
//     (`ChakraMovement`);
//   · **wake-up** — the bīja (sounded only where it is a syllable) and the
//     Mirror Frequency Instruction;
//   · **the gate** — the Gate Text, held through with the Map's own button
//     words; a Textarea or Canvas gate takes his words first (the Writing
//     Prompt). Walked, the offering *leaves*: held one breath, it lifts to an
//     ember and is gone from the glass — "The room keeps what you gave it. You
//     walk lighter." — and the Leela Story arrives, never foreshadowed;
//   · **doors** — into the Home whose practice this is (her seat's room, or
//     the ring itself on the Climb), and its game if Wave 4 placed one here.
//
// Every practice walked here is one `Chakra Practiced` row in App Activity,
// filling `Link to The Map` with this chakra's record. Practice first: the row
// is written before the light moves. Nothing here counts him.

/// Where a door in the room leads.
enum ChakraRoomExit: Identifiable, Equatable {
    case her(Int)
    case ring(Int)
    case game(PlayGame, Int?)

    var id: String {
        switch self {
        case .her(let kp):      return "her-\(kp)"
        case .ring(let r):      return "ring-\(r)"
        case .game(let g, _):   return "game-\(g.rawValue)"
        }
    }
}

struct ChakraRoomView: View {
    let chakra: Chakra33
    let onLeave: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var shaktis: [Shakti]

    @State private var arrived = false
    @State private var openWay: Int?
    @State private var layer: VoiceLayer?
    @State private var practice: ChakraMovement?
    @State private var gateFill: CGFloat = 0
    @State private var gateWalked = false
    @State private var offering = ""
    @State private var given: String?
    @State private var exit: ChakraRoomExit?
    /// The practices already written this visit — one row each.
    @State private var practiced: Set<String> = []

    /// The Mandala's own sound switch (`lr_sound`).
    private let soundOn: Bool

    init(chakra: Chakra33, onLeave: @escaping () -> Void) {
        self.chakra = chakra
        self.onLeave = onLeave
        self.soundOn = (UserDefaults.standard.object(forKey: "lr_sound") as? Bool) ?? true
    }

    /// How long the gate is held before it opens.
    static let gateHold: Double = 1.4
    /// The offering's own line, from the Chakras brief (§9) and its Design
    /// (`bindu-moments.jsx`): what the room says as the words leave.
    static let offeringLine = "The room keeps what you gave it. You walk lighter."

    private var tone: Color { ChakraConstellationDrawing.tone(chakra) }

    var body: some View {
        ZStack {
            ChakraRoomField(chakra: chakra, reduceMotion: reduceMotion)

            ScrollView(.vertical, showsIndicators: false) {
                Group {
                    if chakra.isSealed {
                        // Ruling 2 · the Ego Reveal: its identity, and a held,
                        // quiet threshold. No story, practice, wake-up, gate or
                        // door — its words wait for its own walk.
                        sealedThreshold
                    } else {
                        VStack(spacing: 0) {
                            arrival
                            story
                            practiceSection
                            wakeUp
                            gateSection
                            doors
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 84)
                .padding(.bottom, 140)
                .opacity(arrived ? 1 : 0)
                .offset(y: arrived || reduceMotion ? 0 : 24)
            }

            topBar

            if let given {
                OfferingLeaving(words: given, tone: tone, reduceMotion: reduceMotion) {
                    self.given = nil
                }
                .transition(.opacity)
            }

            if let p = practice {
                ChakraMovementPractice(movement: p, chakra: chakra, soundOn: soundOn,
                                       onComplete: { words, seconds in
                                           write(p.title, words: words, seconds: seconds)
                                       },
                                       onClose: {
                                           withAnimation(.easeInOut(duration: 0.5)) { practice = nil }
                                       })
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
        .theEdgeWayOut(shown: practice == nil, onOut: { leave() })
        .fullScreenCover(item: $exit) { e in
            ChakraRoomExitView(exit: e, onDone: { exit = nil })
        }
        .onAppear(perform: arrive)
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    // MARK: Arrival

    private var arrival: some View {
        VStack(spacing: 12) {
            if let v = chakra.voice {
                Text(v)
                    .font(AppFont.label(11.5))
                    .tracking(3)
                    .textCase(.uppercase)
                    .foregroundStyle(tone.opacity(0.95))
            }
            Text(chakra.name)
                .font(AppFont.sanskrit(44))
                .tracking(1.2)
                .foregroundStyle(Color.cream)
                .multilineTextAlignment(.center)
                .shadow(color: tone.opacity(0.8), radius: 24)
            if let s = chakra.sanskrit {
                Text(s)
                    .font(AppFont.voice(16))
                    .foregroundStyle(Color.cream.opacity(0.62))
            }
            if let s = chakra.subtitle {
                Text(s)
                    .font(AppFont.voice(19))
                    .foregroundStyle(Color.cream.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            if let v = chakra.verb {
                Text(v)
                    .font(AppFont.label(12))
                    .tracking(4)
                    .foregroundStyle(tone.opacity(0.95))
                    .padding(.top, 4)
            }
            if let q = chakra.coreQuestion {
                Text(q)
                    .font(AppFont.voice(24))
                    .foregroundStyle(Color.cream.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 26)
            }
            if let h = chakra.heroThreshold {
                Text(h)
                    .font(AppFont.voice(16))
                    .foregroundStyle(Color.cream.opacity(0.66))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let seed = chakra.signaturePhrase {
                Text(seed)
                    .font(AppFont.sanskrit(22))
                    .foregroundStyle(Color.cream.opacity(0.88))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 30)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: The sealed room (ruling 2)

    /// Only what the room is called — its name, subtitle and verb — and a
    /// point of light that breathes behind a closed ring, with one line.
    private var sealedThreshold: some View {
        VStack(spacing: 12) {
            Text(chakra.name)
                .font(AppFont.sanskrit(44))
                .tracking(1.2)
                .foregroundStyle(Color.cream)
                .multilineTextAlignment(.center)
                .shadow(color: tone.opacity(0.8), radius: 24)
            if let s = chakra.subtitle {
                Text(s)
                    .font(AppFont.voice(19))
                    .foregroundStyle(Color.cream.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            if let v = chakra.verb {
                Text(v)
                    .font(AppFont.label(12))
                    .tracking(4)
                    .foregroundStyle(tone.opacity(0.95))
                    .padding(.top, 4)
            }
            SealedThresholdMark(tone: tone, reduceMotion: reduceMotion)
                .frame(width: 120, height: 120)
                .padding(.top, 56)
                .accessibilityHidden(true)
            Text(ChakraConstellation.sealedLine)
                .font(AppFont.voice(18))
                .italic()
                .foregroundStyle(Color.cream.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.top, 18)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: Story, and the voices behind it

    enum VoiceLayer: String, CaseIterable, Identifiable {
        case act1, act2, bindu, witness
        var id: String { rawValue }

        var label: String {
            switch self {
            case .act1:    return "act one"
            case .act2:    return "act two"
            case .bindu:   return "the Bindu, after"
            case .witness: return "the witness"
            }
        }
    }

    private func text(of layer: VoiceLayer) -> String? {
        switch layer {
        case .act1:    return chakra.act1Voice
        case .act2:    return chakra.act2Voice
        case .bindu:   return chakra.binduReflection
        case .witness: return chakra.witnessPerspective
        }
    }

    private var layers: [VoiceLayer] { VoiceLayer.allCases.filter { text(of: $0) != nil } }

    @ViewBuilder
    private var story: some View {
        let thread = ChakraTeaching.paragraphs(chakra.storyThread)
        if !thread.isEmpty || !layers.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                heading("the story")
                ForEach(Array(thread.enumerated()), id: \.offset) { pair in
                    prose(pair.element)
                }
                if !layers.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(layers) { l in
                            Button {
                                Haptics.light()
                                withAnimation(.easeInOut(duration: 0.4)) { layer = layer == l ? nil : l }
                            } label: {
                                Text(l.label)
                                    .font(AppFont.label(11.5))
                                    .tracking(1.2)
                                    .foregroundStyle(Color.cream.opacity(layer == l ? 0.95 : 0.6))
                                    .padding(.horizontal, 8)
                                    .frame(minHeight: 44)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityAddTraits(layer == l ? .isSelected : [])
                        }
                    }
                    .padding(.top, 8)
                    if let l = layer {
                        ForEach(Array(ChakraTeaching.paragraphs(text(of: l)).enumerated()), id: \.offset) { pair in
                            prose(pair.element, alpha: 0.78)
                        }
                        .transition(.opacity)
                    }
                }
            }
            .padding(.top, 64)
        }
    }

    // MARK: The practice, and its three doors

    @ViewBuilder
    private var practiceSection: some View {
        let prompt = ChakraTeaching.paragraphs(chakra.practicePrompt)
        let ways = ChakraTeaching.threeWays(chakra.threeWaysIn)
        let moves = ChakraMovement.practices(for: chakra)
        if !prompt.isEmpty || ways != nil || !moves.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                heading("the practice")
                ForEach(Array(prompt.enumerated()), id: \.offset) { pair in
                    prose(pair.element)
                }
                if let ways {
                    if let intro = ways.intro { prose(intro, alpha: 0.7) }
                    ForEach(Array(ways.ways.enumerated()), id: \.offset) { pair in
                        wayDoor(pair.element, index: pair.offset)
                    }
                }
                ForEach(moves) { m in
                    movementDoor(m)
                }
            }
            .padding(.top, 64)
        }
    }

    private func wayDoor(_ way: String, index: Int) -> some View {
        let d = ChakraTeaching.door(of: way)
        let open = openWay == index
        return VStack(alignment: .leading, spacing: 10) {
            Button {
                Haptics.light()
                withAnimation(.easeInOut(duration: 0.45)) { openWay = open ? nil : index }
            } label: {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Circle()
                        .fill(tone.opacity(open ? 0.95 : 0.5))
                        .frame(width: 7, height: 7)
                        .shadow(color: tone, radius: open ? 8 : 3)
                    Text(d.head)
                        .font(AppFont.voice(18))
                        .foregroundStyle(Color.cream.opacity(open ? 0.95 : 0.78))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(open ? "Closes this way in." : "Opens this way in.")
            if open, let rest = d.rest {
                prose(rest, alpha: 0.8)
                    .padding(.leading, 19)
                    .transition(.opacity)
            }
        }
    }

    private func movementDoor(_ m: ChakraMovement) -> some View {
        Button {
            Haptics.medium()
            withAnimation(.easeInOut(duration: reduceMotion ? 0.2 : 0.6)) { practice = m }
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Text(m.title)
                    .font(AppFont.label(12))
                    .tracking(2.4)
                    .textCase(.uppercase)
                    .foregroundStyle(tone.opacity(0.95))
                if let first = m.lines.first {
                    Text(first)
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(tone.opacity(0.45), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 18).fill(tone.opacity(0.06)))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.top, 6)
        .accessibilityLabel(m.title)
        .accessibilityHint("A held practice. The light answers your hand; nothing is counted.")
    }

    // MARK: The wake-up

    @ViewBuilder
    private var wakeUp: some View {
        let instruction = ChakraTeaching.paragraphs(chakra.mirrorFrequencyInstruction)
        let mirror = ChakraTeaching.paragraphs(chakra.mirrorFrequency)
        if chakra.bija != nil || !instruction.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                heading("the wake-up")
                if let b = chakra.bija {
                    Text(b)
                        .font(AppFont.sanskrit(22))
                        .foregroundStyle(Color.cream.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }
                ForEach(Array(instruction.enumerated()), id: \.offset) { pair in
                    prose(pair.element)
                }
                if mirror != instruction {
                    ForEach(Array(mirror.enumerated()), id: \.offset) { pair in
                        prose(pair.element, alpha: 0.72)
                    }
                }
                if let syllable = ChakraTeaching.soundedSyllable(chakra.bija), soundOn {
                    Button {
                        Haptics.soft()
                        // Seeded off no seat at all, so it is the syllable's own
                        // tone and never a Śakti's recorded voice.
                        BijaSoundService.shared.playBija(syllable, seed: 0, duration: 4.2)
                    } label: {
                        Text("sound \(syllable)")
                            .font(AppFont.label(12))
                            .tracking(2)
                            .foregroundStyle(Color.gold)
                            .padding(.horizontal, 18)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 64)
        }
    }

    // MARK: The gate

    @ViewBuilder
    private var gateSection: some View {
        if let gate = ChakraTeaching.gate(chakra.gateText) {
            VStack(alignment: .leading, spacing: 16) {
                heading(chakra.gateType.map { "the gate · \($0.lowercased())" } ?? "the gate")
                if !gate.instruction.isEmpty {
                    ForEach(Array(ChakraTeaching.paragraphs(gate.instruction).enumerated()), id: \.offset) { pair in
                        prose(pair.element)
                    }
                }
                if !gateWalked {
                    if ChakraTeaching.gateTakesWords(chakra) {
                        if let w = chakra.writingPrompt {
                            prose(w, alpha: 0.8)
                        }
                        TextField("", text: $offering, axis: .vertical)
                            .font(AppFont.voice(18))
                            .foregroundStyle(Color.cream)
                            .lineLimit(2...8)
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 14).stroke(tone.opacity(0.45), lineWidth: 1))
                            .accessibilityLabel(chakra.writingPrompt ?? "Your words")
                    }
                    gateHoldButton(gate.button ?? chakra.verb ?? "")
                } else {
                    walkedWords
                }
            }
            .padding(.top, 64)
        }
    }

    private func gateHoldButton(_ words: String) -> some View {
        Text(words)
            .font(AppFont.voice(19))
            .foregroundStyle(Color.cream.opacity(0.95))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 26)
            .frame(maxWidth: .infinity, minHeight: 58)
            .background(
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(tone.opacity(0.10))
                        Capsule().fill(tone.opacity(0.42))
                            .frame(width: max(0, geo.size.width * gateFill))
                        Capsule().stroke(tone.opacity(0.7), lineWidth: 1)
                    }
                }
            )
            .contentShape(Capsule())
            .padding(.top, 10)
            .onLongPressGesture(minimumDuration: Self.gateHold, maximumDistance: 40, perform: {
                walkGate()
            }, onPressingChanged: { pressing in
                guard !gateWalked else { return }
                if pressing {
                    Haptics.soft()
                    withAnimation(.linear(duration: Self.gateHold)) { gateFill = 1 }
                } else {
                    withAnimation(.easeOut(duration: 0.35)) { gateFill = 0 }
                }
            })
            .accessibilityElement()
            .accessibilityLabel(words)
            .accessibilityHint("Hold to walk through the gate.")
            .accessibilityAddTraits(.isButton)
            .accessibilityAction { walkGate() }
    }

    /// After the gate: the offering's line (when words were given), the
    /// Writing Reflection, and then the Leela Story — never foreshadowed.
    @ViewBuilder
    private var walkedWords: some View {
        if givenSomething {
            Text(Self.offeringLine)
                .font(AppFont.voice(18))
                .italic()
                .foregroundStyle(Color.cream.opacity(0.75))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
        if givenSomething, let r = chakra.writingReflection {
            prose(r, alpha: 0.82)
        }
        ForEach(Array(ChakraTeaching.paragraphs(chakra.leelaStory).enumerated()), id: \.offset) { pair in
            prose(pair.element, alpha: 0.9)
        }
    }

    @State private var givenSomething = false

    static let gatePractice = "the gate"

    private func walkGate() {
        guard !gateWalked else { return }
        let words = offering.trimmingCharacters(in: .whitespacesAndNewlines)
        // Practice first: the row is written before any light moves.
        write(Self.gatePractice, words: words.isEmpty ? nil : words, seconds: nil)
        PlayHaptics.bloom()
        if soundOn {
            BijaSoundService.shared.playVakChord(frequencies: [110, 165, 220],
                                                 duration: 3.4, volume: 0.04, stagger: 0.12)
        }
        givenSomething = !words.isEmpty
        withAnimation(.easeInOut(duration: reduceMotion ? 0.2 : 0.9)) {
            gateWalked = true
            gateFill = 1
            if !words.isEmpty {
                given = words
                offering = ""
            }
        }
    }

    // MARK: Doors — into the Home, and its game

    @ViewBuilder
    private var doors: some View {
        let home = ChakraTeaching.homeDoor(chakra)
        let games = ChakraTeaching.games(chakra)
        if home != nil || !games.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                heading("the doors")
                if let home {
                    doorButton(homeWords(home), hint: "Opens the Home whose practice this is.") {
                        switch home {
                        case .seat(let kp): exit = .her(kp)
                        case .ring(let r):  exit = .ring(r)
                        }
                    }
                }
                ForEach(games) { g in
                    doorButton("\(g.title) · \(g.verb)", hint: g.hint) {
                        exit = .game(g, chakra.kp.first)
                    }
                }
            }
            .padding(.top, 64)
        }
    }

    private func homeWords(_ door: ChakraTeaching.HomeDoor) -> String {
        switch door {
        case .seat(let kp):
            let name = shaktis.first(where: { $0.khadgamalaPosition == kp })?.name ?? ""
            return name.isEmpty ? "into her room" : "into \(name)'s room"
        case .ring(let r):
            return "into the \(ChakraConstellation.ordinal(r)) āvaraṇa, on the climb"
        }
    }

    private func doorButton(_ words: String, hint: String, _ action: @escaping () -> Void) -> some View {
        Button {
            Haptics.medium()
            action()
        } label: {
            HStack {
                Text(words)
                    .font(AppFont.voice(18))
                    .foregroundStyle(Color.gold)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                Text("›")
                    .font(AppFont.voice(20))
                    .foregroundStyle(Color.gold)
            }
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(hint)
    }

    // MARK: The way out

    private var topBar: some View {
        VStack {
            HStack {
                Button(action: leave) {
                    Text("‹ leave the room")
                        .font(AppFont.voice(16))
                        .foregroundStyle(Color.cream.opacity(0.62))
                        .padding(.horizontal, 6)
                        .frame(minWidth: 64, minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.leading, 14)
                .padding(.top, 8)
                Spacer()
            }
            Spacer()
        }
    }

    private func leave() {
        Haptics.light()
        onLeave()
    }

    private func arrive() {
        withAnimation(.easeOut(duration: reduceMotion ? 0.3 : 1.6)) { arrived = true }
        if soundOn {
            // Rooms about him take 110 Hz (charter §3.5).
            BijaSoundService.shared.playVakBija(frequency: 110, duration: 3.0, volume: 0.05)
        }
        UIAccessibility.post(notification: .screenChanged,
                             argument: ChakraConstellation.spokenLabel(chakra, seatName: seatName))
    }

    private var seatName: String? {
        guard chakra.address == .seat, let kp = chakra.kp.first else { return nil }
        return shaktis.first(where: { $0.khadgamalaPosition == kp })?.name
    }

    // MARK: The ledger

    /// Her Shakti row for a seated chakra (or the point), the Avaraṇa row for a
    /// ring-level one, nothing for a threshold — whose Map link carries it.
    private var mandalaLink: String {
        switch chakra.address {
        case .seat, .centre:
            guard let kp = chakra.kp.first else { return "" }
            return shaktis.first(where: { $0.khadgamalaPosition == kp })?.airtableRecordId ?? ""
        case .ring:
            return chakra.avarana.flatMap { AirtableService.avaranaRecordId(forRing: $0) } ?? ""
        case .threshold:
            return ""
        }
    }

    /// One row per practice walked this visit, through the existing path: one
    /// POST to App Activity, queued offline and drained with every other event,
    /// never dropped.
    private func write(_ practice: String, words: String?, seconds: Double?) {
        guard !practiced.contains(practice) else { return }
        practiced.insert(practice)
        let row = ActivityLedger.chakraPracticed(mapRecordId: chakra.recordId,
                                                 chakraName: chakra.name,
                                                 practice: practice,
                                                 mandalaLink: mandalaLink,
                                                 words: words,
                                                 seconds: seconds,
                                                 at: .now)
        Task { @MainActor in
            await AirtableService.shared.logActivity(row)
        }
    }

    // MARK: Type

    private func heading(_ words: String) -> some View {
        Text(words)
            .font(AppFont.label(11.5))
            .tracking(2.8)
            .textCase(.uppercase)
            .foregroundStyle(tone.opacity(0.95))
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func prose(_ words: String, alpha: Double = 0.86) -> some View {
        Text(words)
            .font(AppFont.voice(18))
            .lineSpacing(5)
            .foregroundStyle(Color.cream.opacity(max(0.6, alpha)))
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Where a door leads

struct ChakraRoomExitView: View {
    let exit: ChakraRoomExit
    let onDone: () -> Void

    @Environment(\.modelContext) private var context

    var body: some View {
        switch exit {
        case .her(let kp):
            HerRoomPassage(startingAt: kp, context: context, onLeft: onDone)
        case .ring(let r):
            ChakraRingClimb(ring: r, onLeft: onDone)
        case .game(let g, let kp):
            PlayField.host(g, atPosition: kp, onClose: onDone)
        }
    }
}

/// An energy chakra's door: the Climb, standing in its ring.
struct ChakraRingClimb: View {
    let ring: Int
    let onLeft: () -> Void

    @Query private var shaktis: [Shakti]

    init(ring: Int, onLeft: @escaping () -> Void) {
        self.ring = ring
        self.onLeft = onLeft
    }

    var body: some View {
        WorldClimbView(live: [:],
                       seats: seats,
                       met: met,
                       todayKp: nil,
                       startingAtRing: ring,
                       forceReduceMotion: AppRuntime.forcesReduceMotion,
                       onLeft: onLeft)
    }

    private var seats: [ClimbLights.Seat] {
        var byKp: [Int: Shakti] = [:]
        for s in shaktis { if let kp = s.khadgamalaPosition { byKp[kp] = s } }
        return (1...KhadgamalaMap.total).map { kp in
            ClimbLights.Seat(kp: kp, name: byKp[kp]?.name ?? "", quality: byKp[kp]?.quality ?? "")
        }
    }

    /// A state, never a count: the Śaktis he has felt carry their core light.
    private var met: Set<Int> {
        Set(shaktis.filter { $0.hasBeenFelt }.compactMap { $0.khadgamalaPosition })
    }
}

// MARK: - The offering that leaves

/// His words held one breath, then lifting — condensing to an ember that
/// drifts off the top of the glass. Given, not saved-and-displayed: the record
/// keeps them (the row's Notes); the view lets them go.
struct OfferingLeaving: View {
    let words: String
    let tone: Color
    let reduceMotion: Bool
    let onGone: () -> Void

    @State private var lifting = false
    @State private var line = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55).ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()
                ZStack {
                    Text(words)
                        .font(AppFont.voice(20))
                        .foregroundStyle(Color.cream.opacity(0.92))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                        .scaleEffect(lifting ? 0.2 : 1)
                        .blur(radius: lifting ? 6 : 0)
                        .opacity(lifting ? 0 : 1)
                        .offset(y: lifting ? -320 : 0)
                    Circle()
                        .fill(RadialGradient(colors: [Color.cream, tone, tone.opacity(0)],
                                             center: .center, startRadius: 0, endRadius: 14))
                        .frame(width: 28, height: 28)
                        .opacity(lifting ? 0.9 : 0)
                        .offset(y: lifting ? -460 : 0)
                }
                Text(ChakraRoomView.offeringLine)
                    .font(AppFont.voice(19))
                    .italic()
                    .foregroundStyle(Color.cream.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                    .opacity(line ? 1 : 0)
                Spacer()
            }
        }
        .allowsHitTesting(false)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ChakraRoomView.offeringLine)
        .onAppear {
            let breath = reduceMotion ? 0.6 : 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + breath) {
                withAnimation(.easeIn(duration: reduceMotion ? 0.4 : 2.6)) { lifting = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + breath + 1.2) {
                withAnimation(.easeOut(duration: 1.6)) { line = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + breath + 6.5) {
                withAnimation(.easeIn(duration: 0.8)) { onGone() }
            }
        }
    }
}
