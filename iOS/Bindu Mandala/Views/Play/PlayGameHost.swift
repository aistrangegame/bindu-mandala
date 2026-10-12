import SwiftUI
import SwiftData

// MARK: - Wave 4 · the host every game is played inside
//
// One shell for all sixteen: the game's own ground and light, one way out, the
// hand-off, and the one ledger row. The shape of every visit:
//
//   playing → gathering (the light draws in to one point) → her Recognition,
//   or stillness → he leaves with one gesture.
//
// There is no end screen. Nothing on this glass says how long he played, how
// well, or how often — storage may count; the screen may not.

/// What one game is doing right now. Not isolated to an actor on purpose:
/// every caller is already on the main thread (touches, timelines, buttons),
/// and the game models must be able to reach it from inside a `Canvas`.
final class PlaySession: ObservableObject {
    enum Phase: Equatable { case playing, gathering, still }

    let game: PlayGame
    @Published private(set) var phase: Phase = .playing
    /// The seat the game hands to — its own address, or (the garland, the
    /// bead tones) the one he came to rest on.
    @Published private(set) var handTo: Int? = nil
    @Published private(set) var handoff: PlayHandoff = .stillness

    let startedAt: Double = PlayClock.now
    /// How many times he acted. Storage only — it decides whether leaving
    /// early is still a game played; it is never drawn.
    private(set) var acts = 0
    /// The ring the bīja tones were played in.
    private(set) var ringInPlay: Int?
    private var completing = false

    init(game: PlayGame, startPosition: Int? = nil) {
        self.game = game
        self.handTo = game.address.position ?? startPosition
    }

    func acted() { acts += 1 }

    /// He has really played: three acts and a few breaths of time.
    var engaged: Bool { acts >= 3 && PlayClock.now - startedAt >= 6 }

    /// The bead or seat he is resting on now (the garland).
    func rest(on kp: Int) {
        guard phase == .playing, (1...KhadgamalaMap.total).contains(kp) else { return }
        if handTo != kp { handTo = kp }
    }

    func playing(ring: Int) { ringInPlay = ring }

    /// End the game. Safe to call from inside a frame: the change is
    /// published on the next turn of the run loop, once.
    func complete(_ handoff: PlayHandoff, at kp: Int? = nil) {
        guard !completing, phase == .playing else { return }
        completing = true
        acts += 1
        DispatchQueue.main.async {
            if let kp = kp { self.handTo = kp }
            self.handoff = handoff
            self.phase = .gathering
        }
    }

    func settle() {
        if phase != .still { phase = .still }
    }

    /// Wave 6 · the game asks him for a word (Mirror Maze, the Letter, Flash).
    /// Published on the next turn of the run loop, so a frame may ask.
    @Published private(set) var asking = false
    /// The line the empty field shows while it waits.
    @Published private(set) var askingFor = "one word"

    func ask(_ on: Bool, prompt: String = "one word") {
        DispatchQueue.main.async {
            if self.askingFor != prompt { self.askingFor = prompt }
            if self.asking != on { self.asking = on }
        }
    }
}

// MARK: - The ledger, for play

enum PlayLedger {

    /// What the game was played at, in the ledger's own words.
    static func place(for game: PlayGame, ring: Int, shaktiName: String?) -> String {
        if let n = shaktiName?.trimmingCharacters(in: .whitespacesAndNewlines), !n.isEmpty {
            return n
        }
        switch game.address {
        case .threshold(let from, _):
            return from == 3 ? "The Shadow crossing" : "The Armin crossing"
        case .garland:
            return "The garland"
        default:
            return "\(ActivityLedger.ordinal(ring)) Āvaraṇa"
        }
    }

    /// The one row a played game writes. Linked to her Shakti row when the
    /// game was hers and her row is known; otherwise to the Avaraṇa row of the
    /// ring it was played in — so the act is always filed somewhere in the
    /// yantra, and never dropped for want of a link.
    static func row(game: PlayGame,
                    ring: Int,
                    shaktiName: String?,
                    shaktiRecordId: String?,
                    seconds: Double,
                    at: Date) -> PendingActivity {
        let link: String
        if let r = shaktiRecordId, !r.isEmpty {
            link = r
        } else {
            link = AirtableService.avaranaRecordId(forRing: ring) ?? ""
        }
        return ActivityLedger.played(game: game.title,
                                     place: place(for: game, ring: ring, shaktiName: shaktiName),
                                     linkRecordId: link,
                                     seconds: seconds,
                                     at: at)
    }

    /// Through the existing path: one POST to App Activity, queued offline and
    /// drained with every other event, never dropped.
    static func write(_ row: PendingActivity) {
        Task { @MainActor in
            await AirtableService.shared.logActivity(row)
        }
    }
}

// MARK: - The host

struct PlayGameHost: View {
    let game: PlayGame
    var startPosition: Int? = nil
    var onClose: () -> Void

    @Query private var shaktis: [Shakti]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @StateObject private var session: PlaySession
    @State private var model: any PlayModel
    @State private var motion = PlayMotion()
    @State private var feeling: Shakti? = nil
    @State private var felt = false
    @State private var ledgered = false
    @State private var hintVisible = true
    @State private var word = ""
    @FocusState private var wordFocused: Bool

    init(game: PlayGame, startPosition: Int? = nil, onClose: @escaping () -> Void) {
        self.game = game
        self.startPosition = startPosition
        self.onClose = onClose
        _session = StateObject(wrappedValue: PlaySession(game: game, startPosition: startPosition))
        _model = State(initialValue: PlayModels.make(game, startPosition: startPosition))
    }

    var body: some View {
        ZStack {
            PlayGround(game: game)

            PlayStage(game: game, model: model, session: session, motion: motion,
                      names: names, reduceMotion: reduceMotion)
                .opacity(session.phase == .playing ? 1 : 0)
                .scaleEffect(session.phase == .playing || reduceMotion ? 1 : 0.6)
                .animation(.easeIn(duration: reduceMotion ? 0.3 : 1.4), value: session.phase)
                .allowsHitTesting(session.phase == .playing)

            if session.phase != .playing {
                PlayStillness(game: game,
                              shakti: handToShakti,
                              canFeel: !felt && handToShakti != nil,
                              reduceMotion: reduceMotion,
                              onFeel: { feelHer() })
                    .transition(.opacity)
            }

            VStack {
                HStack {
                    leaveButton
                    Spacer()
                }
                Spacer()
                if session.phase == .playing && hintVisible {
                    Text(game.hint)
                        .font(AppFont.voice(15))
                        .foregroundStyle(Color.cream.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 34)
                        .padding(.bottom, 26)
                        .allowsHitTesting(false)
                        .transition(.opacity)
                }
            }

            if session.asking && session.phase == .playing {
                wordField
                    .transition(.opacity)
            }
        }
        .onAppear {
            model.meet(herWords)
            PlaySound.shared.begin()
            if game.usesMotion { motion.start() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                withAnimation(.easeOut(duration: 1.6)) { hintVisible = false }
            }
        }
        .onDisappear {
            if session.engaged { writeOnce() }
            motion.stop()
            PlaySound.shared.end()
        }
        .onChange(of: session.phase) { _, phase in
            guard phase == .gathering else { return }
            handOff()
        }
        .fullScreenCover(item: $feeling) { s in
            RecognitionMomentView(shakti: s, isPresented: feelingShown, source: .play)
        }
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    // MARK: Leaving — one gesture, never punished

    private var leaveButton: some View {
        Button {
            PlayHaptics.tap(0.3)
            if session.engaged { writeOnce() }
            onClose()
        } label: {
            Text("‹ leave")
                .font(AppFont.voice(16))
                .foregroundStyle(Color.cream.opacity(0.6))
                .frame(minWidth: 64, minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.leading, 14)
        .padding(.top, 8)
        .accessibilityLabel("Leave \(game.title)")
    }

    // MARK: His word (Wave 6)

    /// One line for his own word, standing over the game's light. What he
    /// writes is handed to the game and the line goes; nothing here keeps it.
    private var wordField: some View {
        VStack(spacing: 14) {
            Spacer()
            TextField("", text: $word, prompt: Text(session.askingFor).foregroundColor(Color.cream.opacity(0.3)))
                .font(AppFont.sanskrit(30))
                .foregroundStyle(Color.cream.opacity(0.9))
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .submitLabel(.done)
                .focused($wordFocused)
                .onSubmit { giveWord() }
                .padding(.horizontal, 40)
                .accessibilityLabel("Your word")
            Rectangle()
                .fill(game.hue.opacity(0.4))
                .frame(height: 1)
                .padding(.horizontal, 60)
            Spacer()
            Spacer()
        }
        .onAppear { wordFocused = true }
    }

    private func giveWord() {
        let w = word.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !w.isEmpty else { return }
        PlayHaptics.tap(0.4)
        wordFocused = false
        model.give(word: w, session: session)
        session.ask(false)
        session.acted()
        word = ""
    }

    // MARK: The hand-off

    private var names: [Int: String] {
        var out: [Int: String] = [:]
        for s in shaktis { out[s.playPosition] = s.name }
        return out
    }

    /// Her own words by position, for the games that answer from her rows.
    private var herWords: [Int: PlayWords] {
        var out: [Int: PlayWords] = [:]
        for s in shaktis {
            out[s.playPosition] = PlayWords(name: s.name,
                                            appreciation: s.appreciationPhrase ?? "",
                                            function: s.shaktiFunction ?? "",
                                            quality: s.quality)
        }
        return out
    }

    private var handToShakti: Shakti? {
        guard let kp = session.handTo else { return nil }
        return shaktis.first { $0.playPosition == kp }
    }

    private var feelingShown: Binding<Bool> {
        Binding(get: { feeling != nil },
                set: { shown in
                    if !shown {
                        feeling = nil
                        session.settle()
                    }
                })
    }

    /// Practice first: the row is written before any light moves.
    private func handOff() {
        writeOnce()
        PlaySound.shared.droneGain(0)
        PlayHaptics.bloom()
        let wait = reduceMotion ? 0.4 : 1.6
        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
            if session.handoff == .recognition, handToShakti != nil {
                feelHer()
            } else {
                session.settle()
            }
        }
    }

    private func feelHer() {
        guard !felt, let s = handToShakti else {
            session.settle()
            return
        }
        felt = true
        feeling = s
    }

    private func writeOnce() {
        guard !ledgered else { return }
        ledgered = true
        let s = handToShakti
        let ring = session.ringInPlay ?? s?.ringNumber ?? game.address.ring
        let row = PlayLedger.row(game: game,
                                 ring: ring,
                                 shaktiName: s?.name,
                                 shaktiRecordId: s?.airtableRecordId,
                                 seconds: PlayClock.now - session.startedAt,
                                 at: .now)
        PlayLedger.write(row)
        // Wave 6 · the same act, kept on the phone for the Portrait's layers.
        PlayTraceStore.shared.note(game: game.rawValue, position: s?.khadgamalaPosition ?? session.handTo,
                                   ring: ring, at: row.at)
        // Wave 6: the same act, remembered on the phone so the World in a Box
        // can stand an object for it (an object, never a total).
        PlayGardenStore.shared.record(game: game.rawValue)
    }
}

// MARK: - The ground

struct PlayGround: View {
    let game: PlayGame

    var body: some View {
        ZStack {
            game.ground
            RadialGradient(colors: [game.hue.opacity(0.10), game.ground.opacity(0)],
                           center: .center, startRadius: 0, endRadius: 520)
                .blendMode(.plusLighter)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

// MARK: - The stage: one model, one clock, one surface

struct PlayStage: View {
    let game: PlayGame
    let model: any PlayModel
    @ObservedObject var session: PlaySession
    let motion: PlayMotion
    let names: [Int: String]
    let reduceMotion: Bool

    var body: some View {
        ZStack {
            TimelineView(.animation) { timeline in
                let breath = timeline.date.timeIntervalSinceReferenceDate
                Canvas { ctx, size in
                    let now = PlayClock.now
                    model.advance(now: now, size: size, session: session, motion: motion)
                    model.draw(in: ctx, size: size, now: now, breath: breath, hue: game.hue,
                               still: reduceMotion)
                }
            }
            .ignoresSafeArea()

            TouchSenseSurface(onBegan: { s in model.began(s, session: session) },
                              onMoved: { s in model.moved(s, session: session) },
                              onEnded: { s in model.ended(s, session: session) })
                .ignoresSafeArea()
                .accessibilityElement()
                .accessibilityLabel("\(game.title) — \(game.verb)")
                .accessibilityHint(game.hint)
                .accessibilityAddTraits(.allowsDirectInteraction)

            if model.hasCaption {
                TimelineView(.periodic(from: .now, by: 0.2)) { _ in
                    VStack {
                        Spacer()
                        Text(model.caption(names: names))
                            .font(AppFont.sanskrit(24))
                            .foregroundStyle(Color.cream.opacity(0.82))
                            .multilineTextAlignment(.center)
                            .shadow(color: game.hue.opacity(0.7), radius: 14)
                            .padding(.horizontal, 28)
                            .padding(.bottom, 96)
                    }
                    .allowsHitTesting(false)
                }
                .accessibilityHidden(true)
            }
        }
    }
}

// MARK: - Stillness: the light gathered to one point

struct PlayStillness: View {
    let game: PlayGame
    let shakti: Shakti?
    let canFeel: Bool
    let reduceMotion: Bool
    var onFeel: () -> Void

    var body: some View {
        GeometryReader { geo in
            let c = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.45)
            ZStack {
                TimelineView(.animation(paused: reduceMotion)) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    // The Bindu's own breath, slow — the game has gone quiet.
                    let b = reduceMotion ? 0.5 : 0.5 - 0.5 * cos(2 * .pi * t / 9)
                    Canvas { ctx, _ in
                        var add = ctx
                        add.blendMode = .plusLighter
                        add.glow(at: c, radius: 150 + 30 * b, color: game.hue, alpha: 0.16 + 0.08 * b)
                        add.glow(at: c, radius: 48 + 8 * b, color: Color.cream, alpha: 0.30 + 0.15 * b)
                        add.core(at: c, radius: 3.5, color: Color.cream, alpha: 0.95)
                    }
                }
                .allowsHitTesting(false)
                .accessibilityHidden(true)

                if canFeel, let s = shakti {
                    Button {
                        PlayHaptics.tap(0.6)
                        onFeel()
                    } label: {
                        VStack(spacing: 14) {
                            Color.clear.frame(width: 120, height: 120)
                            Text(s.name)
                                .font(AppFont.sanskrit(22))
                                .foregroundStyle(Color.cream.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .position(x: c.x, y: c.y + 30)
                    .accessibilityLabel("Feel her — \(s.phonetic.isEmpty ? s.name : s.phonetic)")
                }
            }
        }
        .ignoresSafeArea()
    }
}
