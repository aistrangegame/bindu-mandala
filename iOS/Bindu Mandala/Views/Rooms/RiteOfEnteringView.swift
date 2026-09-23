import SwiftUI

// MARK: - The rite of entering, on screen
//
// The ceremony is ``RiteOfEntering`` and the crossing is ``RoomApproach``; this
// file draws them over the real room, and holds no timing, no wording and no
// numbers of its own beyond type.
//
// ─────────────────────────────────────────────────────────────────────────────
// IT IS NOT A SCREEN BEFORE THE ROOM. IT IS THE ROOM, APPROACHED
// ─────────────────────────────────────────────────────────────────────────────
//
// The `RoomView` beneath the words is the room he is entering — her floor, her
// world's weather, her light, her attribute acting on the material — from the
// first frame of the rite to the last. Nothing fades to black and nothing cuts
// (invariant 3); the only thing that changes when the ceremony ends is that the
// words stop and the walker is standing in it.
//
// The crossing is carried by the eye alone (``RoomScene/stand(atApproach:)``),
// which means the air does the rest for free: SceneKit's fog is a distance
// band, so standing a body-height further out is genuinely looking through more
// of the world's own veil — thin in the first āvaraṇa, nearly opaque in the
// ninth — and her room resolves as he comes.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND IT IS ALSO THE ROOM, LEFT
// ─────────────────────────────────────────────────────────────────────────────
//
// Phase 3.7. Because this file is the room rather than a screen in front of it,
// the way out belongs here too: there is nowhere else that holds her clock, her
// approach and her dwelling, and a second view that did would be a second room.
//
// ``TheWayOut`` draws the instruction and owns the gesture; what this file adds
// is the three things only a room can say. The crossing out is the release run
// the other way, at the same rate, through the same air. The stay is measured to
// the instant he began to cross rather than to the instant the surface went
// away, because the walk out is no more time in her room than the walk in was.
// And what the stay was worth is handed to ``HomeMemoryStore`` exactly once — the
// write that makes the *next* ceremony shorter, and the reason a compression
// that has existed since Phase 3.1 has never yet had anything to compress.
//
// The way out is not offered during the ceremony, and ``TheWayOut/shown`` says
// why: a threshold is not a dialog and has no cancel on it.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE CHAMBER CLOCK DOES NOT RUN DURING THE RITE
// ─────────────────────────────────────────────────────────────────────────────
//
// The clock is held at the threshold and begun, once, on arrival, at the head
// start her accumulated dwell has earned. Two reasons, and the second is the
// one that matters: a ceremony that advanced the room's own clock would hand a
// walker who lingered over her name an adaptation he had not stayed for, and
// the adaptation is the whole instrument. The first is simply that the rite is
// not time spent in her room.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT IS NOT DRAWN HERE, AND WILL NOT BE
// ─────────────────────────────────────────────────────────────────────────────
//
// **No beat indicator.** Design's Axis puts three pips at the bottom of the
// frame — one lit, the passed ones dimmed. That is a progress readout, and the
// brief names it in the same breath as a visit number. The walker knows where
// he is in the ceremony the way he knows where he is in a sentence.
//
// **No returning line.** See ``RiteOfEntering``'s header and `DECISIONS.md`.
//
// **No number, of anything.** There is nowhere in this file to put one:
// everything drawn comes out of ``RiteFrame``, which has no field that counts.

/// The threshold of one room: three beats, touch-paced, folded into the walk in.
struct RiteOfEnteringView: View {

    /// The room he is entering, resolved by ``HomeRooms``. Position is the key.
    let room: HomeRoom
    /// Her words, off her own row.
    let words: RiteWords
    /// Her seed syllable, for the tone each beat lands on. `nil` is the bare
    /// root — silence about what is unknown, never a plausible pitch.
    let syllable: String?
    /// Her five fields, for the five stations of the descent. Composed off her
    /// own row exactly as ``words`` is.
    let descentWords: DescentWords
    /// Her ground, her carrier, her air and her withheld fifth — `nil` for a
    /// preview or a capture. It **draws nothing and is asked nothing**: like
    /// ``dwelling`` it has no property a view could read, which is how a room
    /// stays whole with the sound off by construction rather than by care.
    let voice: HomeVoice?
    /// The mechanism acting on her room, where Phase 3.3 has built one.
    let mechanism: RoomSurfaceMechanism?
    /// Called once, when he is inside.
    let onEntered: (() -> Void)?
    /// Called once, when he has crossed out — the surface that presented this
    /// room is what takes him off it. See ``TheWayOut``.
    let onLeft: (() -> Void)?
    /// What the stay was worth, in real seconds, handed over exactly once.
    ///
    /// It is a closure rather than a store for the same reason ``dwelling`` is:
    /// this file draws a room and knows nothing about SwiftData. The real door,
    /// ``entering(_:remembering:)``, hands it ``HomeMemoryStore/record(khadgamalaPosition:dwell:)``
    /// — which is what makes the *next* ceremony shorter, and is the first time
    /// in the instrument that a compression has had anything to compress.
    let recording: ((TimeInterval) -> Void)?
    /// What this stay records once he is in — the R11 silence and the once-ever
    /// first dwelling. `nil` for a preview, a capture, or a room stood in with no
    /// Śakti row behind it.
    ///
    /// **It draws nothing and it is asked nothing.** ``HomeDwelling`` has no
    /// property a view could read, so the ceremony can carry it without the
    /// silence ever becoming something on screen — which is Ruling 11's *never
    /// displayed* and law 2's *no count* held by the shape of the type rather
    /// than by care.
    let dwelling: HomeDwelling?
    /// Forced on for tests and captures; otherwise the environment decides.
    let forceReduceMotion: Bool

    @Environment(\.accessibilityReduceMotion) private var environmentReduceMotion

    @State private var rite: RiteOfEntering
    @State private var clock: RoomClock
    @State private var approach: RoomApproachSource
    @State private var crossing: Task<Void, Never>?
    /// **The watch kept over a withdrawal that was begun and never finished.**
    ///
    /// The way out is a press, and a press reports two things: it began, and it
    /// ended. `holdOn()` — which puts the stay back, re-lights the two marks and
    /// closes the room on him again — runs only on the *ended*. A press can be
    /// taken away without one: the system lifts the touch out from under the
    /// view (a call banner, the app going to the background, and the digitizer
    /// teardown `DECISIONS.md` records for the harness), SwiftUI discards the
    /// cancelled press, and no callback arrives at all. The walker was then left
    /// standing inside her room with the eye withdrawn to nothing, both marks
    /// cancelled and never rescheduled, and the stay frozen where his finger
    /// landed — with no gesture that could undo any of it.
    ///
    /// So the withdrawal watches itself. It is armed when the crossing begins
    /// and cancelled by either honest end — he is out, or he let go — and if
    /// neither has arrived a little after the crossing's own length, the only
    /// thing that can have happened is that the press was taken away. He did not
    /// leave, so he is put back exactly as a let-go would have put him back.
    @State private var withdrawal: Task<Void, Never>?
    /// The stay's own bookkeeping — when it ended and whether it has been filed.
    ///
    /// Its four rules are ``TheStay``'s, so they can be driven rather than read:
    /// the stay ends where he decided it ended, a let-go undoes that, the filing
    /// happens once by whichever door closes first, and a ceremony he abandoned
    /// files nothing.
    @State private var stay = TheStay()
    /// How many times the walker has been moved on his crossing.
    ///
    /// The still path's redraw token (``RoomView/moves``). ``RoomApproachSource``
    /// is a reference so the driver can read the walker's distance on SceneKit's
    /// own thread without re-rendering the tree — which means moving him changes
    /// nothing SwiftUI can see, and with the render loop stopped the room is
    /// never asked for another frame. Every place this file moves him bumps
    /// this, so the ask is declared rather than incidental.
    @State private var moves = 0
    /// Where he is in the descent, and what a touch does next — ``TheDescent``'s
    /// four rules, drivable rather than spelled into this file.
    @State private var descent = TheDescent()
    /// How far he has gone into her mark, held where the room's driver can read
    /// it on SceneKit's own thread. The same device the crossing uses, because
    /// ``RoomApproach``'s own header says the descent *is* the same motion with
    /// a different reason.
    @State private var descending = RoomApproachSource(.standing(at: 0))
    /// Whether her room has adapted far enough to be gone into. It is a wake
    /// rather than a poll (``HomeDwelling``'s reason: the still path has no
    /// render loop to hang one on), and on a return it is already true when he
    /// arrives, because his own dwell opened the room past the adaptation.
    @State private var wayDownIsOpen = false
    @State private var adapting: Task<Void, Never>?

    // MARK: · Type, which is the only thing this file chooses
    //
    // Design's CSS, in points: her phrase 23, her Devanāgarī 38, her roots 25,
    // her quality 16.5 italic, the prompt 9 with `.3em` of tracking.
    //
    // **The prompt is the one size that is not Design's.** Nine points is below
    // `iOS/FIDELITY.md` §4's ~11pt floor for meaningful text, and the prompt is
    // the only instruction in the ceremony. It is set at the floor, with its
    // tracking scaled by the same proportion so it keeps its proportion.

    private static let phraseSize: CGFloat = 23
    private static let writtenSize: CGFloat = 38
    private static let rootSize: CGFloat = 25
    private static let glossSize: CGFloat = 16.5
    private static let promptSize: CGFloat = 11
    /// The descent's one line. Between beat one's 23 and her quality's 16.5 —
    /// her field is a fact about her rather than her gratitude, and it is read
    /// standing in a shaft rather than at a threshold.
    private static let descentSize: CGFloat = 19
    private static let promptTracking: CGFloat = promptSize * 0.3

    /// How far her roots stand apart at their widest. Design's `30px`.
    private static let rootSpread: CGFloat = 30

    /// The soft edge of the hand's stroke — Design's `pct + 7%`.
    private static let strokeEdge: Double = 0.07

    init(room: HomeRoom,
         words: RiteWords,
         syllable: String? = nil,
         descentWords: DescentWords = DescentWords(lines: [], roots: []),
         voice: HomeVoice? = nil,
         mechanism: RoomSurfaceMechanism? = nil,
         compression: Double,
         headStart: TimeInterval = 0,
         dwelling: HomeDwelling? = nil,
         forceReduceMotion: Bool = false,
         onEntered: (() -> Void)? = nil,
         onLeft: (() -> Void)? = nil,
         recording: ((TimeInterval) -> Void)? = nil) {
        self.room = room
        self.words = words
        self.syllable = syllable
        self.descentWords = descentWords
        self.voice = voice
        self.mechanism = mechanism
        self.dwelling = dwelling
        self.onEntered = onEntered
        self.onLeft = onLeft
        self.recording = recording
        self.forceReduceMotion = forceReduceMotion
        // **Built without a motion setting, on purpose.** A `View`'s `init` is
        // not in the environment, so `forceReduceMotion` is only half the answer
        // here and the half it is missing is the one a real walker uses. The
        // ceremony takes the whole answer in `adoptMotion()`, on appearance and
        // on every change, and there is exactly one place it can come from.
        _rite = State(initialValue: RiteOfEntering(compression: compression,
                                                   headStart: headStart))
        _clock = State(initialValue: RoomClock.held())
        _approach = State(initialValue: RoomApproachSource.atTheDoor())
    }

    private var reduceMotion: Bool { forceReduceMotion || environmentReduceMotion }

    var body: some View {
        ZStack {
            RoomView(room: room,
                     clock: clock,
                     mechanism: mechanism,
                     approach: approach,
                     descent: descending,
                     descentRoots: descentWords.roots.count,
                     forceReduceMotion: reduceMotion,
                     moves: moves)
                .allowsHitTesting(false)

            if rite.isCeremonial {
                ceremony
            } else if wayDownIsOpen {
                goingDeeper
            }
        }
        .background(Color.ground)
        .contentShape(Rectangle())
        .onTapGesture { touch() }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { touch() }
        .theWayOut(reduceMotion: reduceMotion,
                   shown: !rite.isCeremonial,
                   onBegan: { seconds in unwind(over: seconds) },
                   onLetGo: { holdOn() },
                   onOut: { out() })
        .onAppear { open() }
        .onChange(of: environmentReduceMotion) { _, _ in adoptMotion() }
        .onDisappear {
            crossing?.cancel()
            withdrawal?.cancel()
            adapting?.cancel()
            // The voice stops where it started. Nothing in the rooms layer can
            // outlive the room that opened it.
            voice?.closes()
            // He has left. A mark that had not arrived does not arrive.
            dwelling?.end()
            handOverTheStay()
        }
        .ignoresSafeArea()
    }

    // MARK: - The ceremony

    @ViewBuilder
    private var ceremony: some View {
        if reduceMotion {
            // No timeline and no animation: each beat arrives already written,
            // and the only thing that moves him is his own touch.
            beats(rite.frame(at: Date().timeIntervalSinceReferenceDate))
        } else {
            TimelineView(.animation) { timeline in
                beats(rite.frame(at: timeline.date.timeIntervalSinceReferenceDate))
            }
        }
    }

    @ViewBuilder
    private func beats(_ frame: RiteFrame) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            Group {
                switch frame.beat {
                case .phrase:  phrase(frame)
                case .written: written(frame)
                case .roots:   roots(frame)
                case nil:      Color.clear.frame(height: 0)
                }
            }
            .padding(.horizontal, 34)
            Spacer(minLength: 0)
            prompt(frame)
                .padding(.bottom, 64)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Beat one — her gratitude, arriving out of nothing.
    private func phrase(_ frame: RiteFrame) -> some View {
        Text(words.appreciation)
            .font(AppFont.sanskrit(Self.phraseSize))
            .tracking(Self.phraseSize * 0.04)
            .lineSpacing(Self.phraseSize * 0.5)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.cream)
            .opacity(frame.phrase)
            .shadow(color: .black.opacity(0.95), radius: 15, y: 2)
            .fixedSize(horizontal: false, vertical: true)
    }

    /// Beat two — her name, written stroke by stroke by an unseen hand.
    ///
    /// The mask is the hand: the text is whole from the first frame and only as
    /// much of it as has been written is uncovered, with a soft leading edge
    /// where the stroke is being made.
    ///
    /// **The face follows the string, not the field.** Devanāgarī is set in the
    /// system face — Cormorant carries no Devanāgarī, and a substituted glyph is
    /// still her name while a missing one is not. But `words.written` is her
    /// Devanāgarī *or her roman name*, and this beat used to set the system face
    /// for both: a row whose `devanagari` is empty had the centre of her own
    /// threshold written in the OS's sans, between a Cormorant beat one and a
    /// Cormorant beat three, while the Detail rendered the identical string in
    /// Cormorant a tap away. ``RiteWords/writtenIsDevanagari`` asks which string
    /// was actually chosen, so the answer cannot drift from the choice again.
    private func written(_ frame: RiteFrame) -> some View {
        Text(words.written)
            .font(words.writtenIsDevanagari
                  ? .system(size: Self.writtenSize)
                  : AppFont.sanskrit(Self.writtenSize))
            .tracking(Self.writtenSize * 0.02)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.cream)
            .shadow(color: .black.opacity(0.9), radius: 22)
            .mask(alignment: .leading) {
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black, location: max(0.0001, frame.revealed)),
                        .init(color: .clear, location: min(1, frame.revealed + Self.strokeEdge)),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing)
            }
    }

    /// Beat three — her name opened into what it is made of, and her quality
    /// arriving beneath it.
    private func roots(_ frame: RiteFrame) -> some View {
        VStack(spacing: Self.glossSize) {
            HStack(alignment: .firstTextBaseline, spacing: frame.rootGap * Self.rootSpread) {
                ForEach(Array(words.roots.enumerated()), id: \.offset) { _, part in
                    Text(part)
                        .font(AppFont.sanskrit(Self.rootSize))
                        .foregroundStyle(Color.cream)
                        .shadow(color: .black.opacity(0.9), radius: 12, y: 2)
                }
            }
            if !words.gloss.isEmpty {
                Text(words.gloss)
                    .font(AppFont.voice(Self.glossSize))
                    .tracking(Self.glossSize * 0.03)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.cream)
                    .opacity(frame.gloss * RiteOfEntering.glossAlpha)
                    .shadow(color: .black.opacity(0.9), radius: 10, y: 2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    /// The threshold's one instruction, once the beat has finished writing.
    @ViewBuilder
    private func prompt(_ frame: RiteFrame) -> some View {
        if let prompt = frame.prompt {
            Text(prompt.words)
                .font(AppFont.label(Self.promptSize))
                .textCase(.uppercase)
                .tracking(Self.promptTracking)
                .foregroundStyle(Color.cream)
                .opacity(RiteOfEntering.promptAlpha)
                .frame(minHeight: 44)
        } else {
            Color.clear.frame(height: 44)
        }
    }

    // MARK: - Going deeper, on screen

    /// The descent's whole surface: one line of hers, and one instruction.
    ///
    /// **No motion and no fade.** The field is rendered as motion by the shaft
    /// (``DescentShaft``) — that is Design's own division of labour — and what
    /// is written here is the inscription beside it, which arrives at the
    /// station because he has arrived at the station. A word that faded in would
    /// need a loop the reduce-motion path deliberately does not have, and would
    /// buy nothing: he is already reading it.
    ///
    /// **Nothing here says how deep he is.** There is no station number, no
    /// rail, no pip, and no place to put one: a line of hers and a prompt of two
    /// words are the whole of it, at every one of the five.
    @ViewBuilder
    private var goingDeeper: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            if let station = descent.station, !descentWords[station].isEmpty {
                Text(descentWords[station])
                    .font(AppFont.sanskrit(Self.descentSize))
                    .tracking(Self.descentSize * 0.04)
                    .lineSpacing(Self.descentSize * 0.5)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.cream)
                    .opacity(RiteOfEntering.phraseAlpha)
                    .shadow(color: .black.opacity(0.95), radius: 15, y: 2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 34)
            }
            Spacer(minLength: 0)
            descentPrompt
                // **Above the way out, never on top of it.** ``TheWayOut``
                // draws its own instruction at the same 64 points off the
                // floor that the rite's prompt uses, and the rite could put
                // one there safely only because the way out is not offered
                // during the ceremony. This one *is* offered at the same time
                // as the way out, so it stands a prompt's height and a gap
                // above it — and the two read as the ladder they are: go
                // deeper, or hold and withdraw.
                .padding(.bottom, 64 + 44 + 14)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private var descentPrompt: some View {
        Text((descent.prompt ?? TheDescent.mouthPrompt).words)
            .font(AppFont.label(Self.promptSize))
            .textCase(.uppercase)
            .tracking(Self.promptTracking)
            .foregroundStyle(Color.cream)
            .opacity(RiteOfEntering.promptAlpha)
            .frame(minHeight: 44)
    }

    // MARK: - What a touch does

    /// The first beat's tone lands as the crossing opens — Design's
    /// `beginEnter`, which strikes before the walker has done anything.
    private func open() {
        adoptMotion()
        // Her ground comes up under the crossing, and her carrier with the
        // distance — Design's *"entering her: the carrier comes up"*. It is the
        // first thing that happens, before the first tone is struck, so the
        // strike lands on a room that is already sounding.
        voice?.opens()
        voice?.crossing(approach.value())
        strike(.phrase)
    }

    /// The ceremony takes the motion setting the walker's device is carrying.
    ///
    /// The rite is built in `init`, which is not in the environment, so this is
    /// the first moment the real answer is known — and
    /// ``RiteOfEntering/adopt(reduceMotion:at:)`` is where the ceremony's flag
    /// and the one this view renders by are made the same flag. Without it a
    /// walker with the system's own Reduce Motion on is drawn once, at the
    /// instant each beat opened, and stays blank.
    private func adoptMotion() {
        rite.adopt(reduceMotion: reduceMotion)
        stand(at: rite.approach)
    }

    /// Where he stands now, and the room asked for a frame that says so.
    private func stand(at approach: RoomApproach) {
        self.approach.set(approach)
        voice?.crossing(approach.to)
        moves &+= 1
    }

    /// Where he is going in the shaft, and the room asked for a frame that says
    /// so. The descent's own half of ``stand(at:)``, and it bumps the same
    /// token, because a still room is posed once per move he makes.
    private func descend(to travel: Double, over motion: RoomApproach.Motion) {
        let now = Date().timeIntervalSinceReferenceDate
        descending.set(RoomApproach(from: descending.value(at: now), to: travel,
                                    since: now, motion: motion))
        moves &+= 1
    }

    /// The motion of one stretch of the descent.
    ///
    /// Design's own station rate, and under reduced motion the walker **steps**
    /// between stations exactly as he steps between the rite's — quantized,
    /// never disabled, and the same reading ``RoomApproach/crossing(from:to:at:reduceMotion:)``
    /// already took for the way in.
    private var descentMotion: RoomApproach.Motion {
        reduceMotion
            ? .still
            : .easing(tau: RoomApproach.tau(ratePerFrame: RoomApproach.ratePerFrame))
    }

    private func touch() {
        // He is inside, and her room has opened far enough to be gone into:
        // the same touch that carried him in carries him deeper.
        if case .inside = rite.stage {
            // **A man on his way out is not going deeper.** The way out's own
            // gesture lives on its prompt and the room's touch lives on the
            // whole surface, so a press that begins on the prompt and is let go
            // can reach both; before this phase a touch inside a room did
            // nothing at all and the overlap could not be felt. The stay knows
            // when he has begun to cross out, and that is the fact to ask.
            guard wayDownIsOpen, stay.endedAt == nil else { return }
            descend(to: descent.onward(), over: descentMotion)
            return
        }
        guard case .beat = rite.stage else { return }
        let now = Date().timeIntervalSinceReferenceDate
        let landed = rite.touch(at: now)
        stand(at: rite.approach)

        if let landed {
            strike(landed)
            return
        }

        // The third touch: the last stretch, and then he is in.
        let seconds = rite.crossingDuration(at: now) ?? 0
        crossing?.cancel()
        guard seconds > 0 else { return arrive() }
        crossing = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            guard !Task.isCancelled else { return }
            arrive()
        }
    }

    private func arrive() {
        let now = Date().timeIntervalSinceReferenceDate
        rite.arrive(at: now)
        stand(at: rite.approach)
        // The room opens where her accumulated dwell has earned, and he is
        // never told that it did.
        clock.begin(opening: rite.headStart, at: now)
        // Her clock is running, so the voice follows it from here.
        voice?.inside(clock: clock)
        // …and so does the way down, which opens when her room has adapted —
        // at once in a room his own dwell has already opened that far.
        watchForTheWayDown()
        // …and the stay begins, which is the only thing in the instrument that
        // records a silence. It is begun on **her own clock**, the one the room
        // beneath these words is being drawn by, so the dwelling and the room
        // cannot stand at two different instants (``HomeDwelling``'s header).
        dwelling?.begin(clock: clock)
        onEntered?()
    }

    /// Sleep until her room has adapted, and open the way down there.
    ///
    /// A wake rather than a poll, for ``HomeDwelling``'s reason: the mark is
    /// known the instant the clock begins, and the reduce-motion path has no
    /// render loop to notice it on. A room that opened past the adaptation on
    /// arrival — which is what a head start earned by accumulated dwell *is* —
    /// answers immediately and sleeps not at all.
    private func watchForTheWayDown() {
        adapting?.cancel()
        if TheDescent.isOffered(atChamberTime: clock.chamberTime()) {
            wayDownIsOpen = true
            return
        }
        let wait = HomeMemory.firstAdaptation - clock.chamberTime()
        adapting = Task { @MainActor in
            if wait > 0 {
                try? await Task.sleep(nanoseconds: UInt64(min(wait, 86_400) * 1_000_000_000))
            }
            guard !Task.isCancelled else { return }
            wayDownIsOpen = true
        }
    }

    // MARK: - What the way out does

    /// The crossing out: the release, run the other way.
    ///
    /// ``RoomApproach/releasing(from:at:reduceMotion:)`` carries him the last of
    /// the distance to her at a steady rate; this is the same stretch with its
    /// ends exchanged, so the eye stands away from her through the āvaraṇa's own
    /// air over exactly as long as the hold lasts. Nothing else in the room
    /// moves: the fog is a distance band and the world's veil does the rest, the
    /// way it did on the way in.
    ///
    /// Under reduced motion there is no unwinding at all — the hold is a touch,
    /// this is never called, and he steps out. Quantized, never disabled.
    private func unwind(over seconds: TimeInterval) {
        guard !rite.isCeremonial else { return }
        let now = Date().timeIntervalSinceReferenceDate
        // The stay ends where he decides it ends, not where the surface goes.
        stay.ends(at: clock.elapsed(now: now))
        // A mark that has not arrived does not arrive while he is on his way out.
        dwelling?.end()
        // **From inside her mark, the way out is the way down, run backwards.**
        // He rises out of the shaft over exactly the length of the hold and is
        // standing in her room as the surface goes — which is the same sentence
        // the crossing out already speaks one layer up, and it means a walker
        // five stations deep is never taken off a screen he never stood on.
        if descent.withdraws() {
            descend(to: 0, over: .steady(seconds: max(0, seconds)))
        } else {
            stand(at: RoomApproach(from: approach.value(at: now), to: 0,
                                   since: now, motion: .steady(seconds: max(0, seconds))))
        }
        watchTheWithdrawal(over: seconds)
    }

    /// Arms the watch described on ``withdrawal``: the crossing's own length,
    /// which is when a finished press is due, plus ``withdrawalSlack`` for one
    /// that is merely late.
    private func watchTheWithdrawal(over seconds: TimeInterval) {
        withdrawal?.cancel()
        let slack = max(0, seconds) + Self.withdrawalSlack
        withdrawal = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(slack * 1_000_000_000))
            guard !Task.isCancelled else { return }
            // He is neither out nor back: the press was taken away. Put him back.
            holdOn()
        }
    }

    /// How long after a crossing's own length a finished press may still arrive
    /// before the withdrawal is judged to have been taken away.
    ///
    /// Generous rather than tight, and deliberately so: the cost of waiting too
    /// long is that a walker whose crossing was taken from him looks at a
    /// withdrawn world for another half second, and the cost of waiting too
    /// little is that a press which really did complete under a loaded device
    /// gets undone underneath him. The second is the worse failure, so the
    /// slack is sized for it.
    static let withdrawalSlack: TimeInterval = 0.6

    /// He let go of the crossing. The room closes on him at Design's own
    /// station rate, the stay is no longer over, and the two marks are live
    /// again — a walker who thought about leaving and did not has not left.
    private func holdOn() {
        withdrawal?.cancel()
        withdrawal = nil
        guard !rite.isCeremonial, stay.goesOn() else { return }
        let now = Date().timeIntervalSinceReferenceDate
        if descent.goesOn() {
            // He is put back at the station he was standing at, not at the
            // mouth: a man who thought about leaving and did not has not lost
            // the descent he had made.
            descend(to: descent.travel, over: descentMotion)
        } else {
            stand(at: RoomApproach.crossing(from: approach.value(at: now), to: 1,
                                            at: now, reduceMotion: reduceMotion))
        }
        dwelling?.begin(clock: clock)
    }

    /// He is outside. The stay is handed over, then the surface takes him off.
    private func out() {
        crossing?.cancel()
        withdrawal?.cancel()
        withdrawal = nil
        adapting?.cancel()
        dwelling?.end()
        voice?.closes()
        handOverTheStay()
        onLeft?()
    }

    /// What the stay was worth, handed over exactly once.
    ///
    /// A room he never entered has nothing to hand over — the clock is still
    /// held at her threshold — and a stay that has already been handed over is
    /// not handed over twice, whichever of the two doors closes first.
    private func handOverTheStay() {
        guard let dwell = stay.handOver(elapsedNow: clock.elapsed(), entered: !clock.isHeld)
        else { return }
        recording?(dwell)
    }

    private func strike(_ beat: RiteBeat) {
        HomeSoundService.shared.strike(ring: room.ring,
                                       beat: beat.rawValue,
                                       syllable: syllable)
    }
}

// MARK: - Entering her, from her own row

extension RiteOfEnteringView {

    /// The whole threshold from a synced row and what her room remembers.
    ///
    /// `nil` where she has no khaḍgamālā position or no ring — a row without
    /// the one key the laws recognise has no room, and therefore no threshold.
    @MainActor
    static func entering(_ shakti: Shakti,
                         remembering store: HomeMemoryStore,
                         mechanism: RoomSurfaceMechanism? = nil,
                         sounding: Bool = true,
                         forceReduceMotion: Bool = false,
                         onEntered: (() -> Void)? = nil,
                         onLeft: (() -> Void)? = nil) -> RiteOfEnteringView? {
        guard let room = HomeRooms.resolve(shakti), let position = shakti.khadgamalaPosition else {
            return nil
        }
        return RiteOfEnteringView(room: room,
                                  words: RiteWords.compose(shakti: shakti, ring: room.ring),
                                  syllable: shakti.bijaSyllable,
                                  // Her five fields, for the five stations.
                                  descentWords: DescentWords.compose(shakti: shakti),
                                  // Her voice, and the one thing it needs from
                                  // what her room remembers: accumulated dwell,
                                  // which is what the withheld fifth is withheld
                                  // against. Read once, as the compression and
                                  // the head start are, and never subscribed to.
                                  voice: HomeVoice.forRoom(
                                    ring: room.ring,
                                    syllable: shakti.bijaSyllable,
                                    accumulatedDwell: store.accumulatedDwell(for: position),
                                    sounding: sounding),
                                  mechanism: mechanism,
                                  compression: store.compression(for: position),
                                  headStart: store.headStart(for: position),
                                  // What this stay records, and never shows.
                                  // `memory(for:)` is a pure read — a room never
                                  // stood in answers with a transient row and
                                  // nothing enters the store.
                                  dwelling: HomeDwelling(
                                    memory: store.memory(for: position),
                                    marks: HomeDwelling.forRoom(shakti, context: store.context)),
                                  forceReduceMotion: forceReduceMotion,
                                  onEntered: onEntered,
                                  onLeft: onLeft,
                                  // The only write a stay makes to what her room
                                  // remembers, and the one that was missing: the
                                  // ceremony has been able to compress since
                                  // Phase 3.1 and nothing had ever recorded a
                                  // stay for it to compress against. It is
                                  // phone-only by construction — `HomeMemoryStore`
                                  // touches neither `AirtableService` nor the
                                  // ledger, which is R17 at the data layer.
                                  recording: { dwell in
                                      store.record(khadgamalaPosition: position, dwell: dwell)
                                  })
    }
}

#if DEBUG
#Preview("the rite · Garimā") {
    let position = 4
    let ring = KhadgamalaMap.ringNumber(forKhadgamala: position)
    let room = HomeRooms.resolve(position: position,
                                 ring: ring,
                                 tattva: "Pṛthvī — earth",
                                 quality: "Weightedness",
                                 bodilyLocation: "Mūlādhāra / sit-bones / soles")!
    return RiteOfEnteringView(
        room: room,
        words: RiteWords.compose(appreciationPhrase: "Thank you for the weight that holds me here.",
                                 ringAppreciation: Avarana.appreciationPhrase(forRing: ring),
                                 devanagari: "गरिमा",
                                 name: "Garimā",
                                 etymology: "Guru + imā",
                                 quality: "Weightedness"),
        compression: 1)
}
#endif
