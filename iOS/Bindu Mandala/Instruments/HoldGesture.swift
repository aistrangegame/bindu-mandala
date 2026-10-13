import SwiftUI

// MARK: - U1 · D · the hold, in the hand
//
// `the-33-architecture.md` §2 row 31 and `verification.md` V25: every hold in
// the app completes only by a real hold of its designed duration, by touch or
// by a held key (Enter / Space; key repeat ignored); an early release drains,
// never fails; the act waits for the release; reduce motion keeps the
// duration.
//
// `HoldDriver` gives the pure `HoldEngine` its frames (a main-actor loop that
// runs only while something is held or draining — no render loop at rest) and
// its feel (`HapticLibrary`: a tick at press, the ramp .15 → .6, one latch at
// the commit, nothing on an early release).
//
// `.hold(for:named:onCommit:onComplete:)` is the modifier every world uses.
// Its accessibility action performs the act at once: *"A voice performs an
// action; it never holds one"* (`Views/Rooms/TheWayOut.swift`).
//
// U1 builds it; U2 onward put it on the screens (the existing
// `onLongPressGesture` fires — 1.4 s chakra, 2.2 s way out, 2.8 s Door — are
// left as they are until then).

/// Drives one `HoldEngine` in real time (the-33 §2 row 31).
@MainActor
final class HoldDriver: ObservableObject {

    @Published private(set) var progress: Double = 0
    @Published private(set) var isHeld: Bool = false
    @Published private(set) var isCommitted: Bool = false
    @Published private(set) var isCompleted: Bool = false

    private(set) var engine: HoldEngine
    private var onCommit: () -> Void = {}
    private var onComplete: () -> Void = {}
    /// Whether the hold is felt (the Sound sheet's switch is honoured inside
    /// `HapticLibrary` too).
    var feelsHaptics: Bool = true

    private let clock: () -> TimeInterval
    private var loop: Task<Void, Never>?

    /// The frame the loop asks for (≈ 60 Hz).
    static let frame: Duration = .milliseconds(16)

    init(rise: TimeInterval, drain: TimeInterval = HoldLadder.drain,
         clock: @escaping () -> TimeInterval = { ProcessInfo.processInfo.systemUptime }) {
        self.engine = HoldEngine(rise: rise, drain: drain)
        self.clock = clock
    }

    /// The acts, refreshed each time the view is drawn (never published).
    func bind(onCommit: @escaping () -> Void, onComplete: @escaping () -> Void) {
        self.onCommit = onCommit
        self.onComplete = onComplete
    }

    /// A new duration takes effect between holds, never during one.
    func configure(rise: TimeInterval, drain: TimeInterval) {
        guard !engine.needsFrames, engine.rise != rise || engine.drain != drain else { return }
        let wasCompleted = engine.completed
        engine = HoldEngine(rise: rise, drain: drain)
        if wasCompleted { _ = engine.performByVoice() }
    }

    func press(_ source: HoldSource, isRepeat: Bool = false) {
        handle(engine.press(at: clock(), by: source, isRepeat: isRepeat))
        run()
    }

    func release(_ source: HoldSource) {
        handle(engine.release(at: clock(), by: source))
        run()
    }

    func cancel() {
        handle(engine.cancel(at: clock()))
        run()
    }

    /// VoiceOver's action: the act, at once.
    func performByVoice() {
        handle(engine.performByVoice())
    }

    /// Ready for another hold (a surface that stays after its act).
    func reset() {
        loop?.cancel()
        loop = nil
        engine.reset()
        publish()
    }

    // MARK: Frames

    private func run() {
        guard loop == nil, engine.needsFrames else { return }
        loop = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: HoldDriver.frame)
                guard let self else { return }
                if !self.step() { break }
            }
            self?.loop = nil
        }
    }

    /// One frame; false when the engine is at rest.
    private func step() -> Bool {
        handle(engine.tick(at: clock()))
        if engine.isHeld, !engine.committed, feelsHaptics {
            HapticLibrary.shared.holdProgress(engine.progress)
        }
        return engine.needsFrames
    }

    private func handle(_ events: [HoldEvent]) {
        for e in events {
            switch e {
            case .pressed:
                if feelsHaptics { HapticLibrary.shared.holdPressed() }
            case .committed:
                if feelsHaptics { HapticLibrary.shared.holdLatched() }
                onCommit()
            case .completed:
                onComplete()
            case .letGo:
                // Nothing on an early release: no buzz, no sound, no word.
                if feelsHaptics { HapticLibrary.shared.holdEnded() }
            case .drained:
                break
            }
        }
        publish()
    }

    private func publish() {
        if progress != engine.progress { progress = engine.progress }
        if isHeld != engine.isHeld { isHeld = engine.isHeld }
        if isCommitted != engine.committed { isCommitted = engine.committed }
        if isCompleted != engine.completed { isCompleted = engine.completed }
    }
}

/// The one hold, as a modifier (the-33 §2 row 31; V25). The view it wraps is
/// what is held. A view that draws the hold's light passes a `HoldDriver` of
/// its own (`.hold(for:named:driver:…)`) and reads `driver.progress`.
@MainActor
struct HoldModifier: ViewModifier {

    let duration: TimeInterval
    let drain: TimeInterval
    /// The act's name — the button is named for the act ("hold to release into
    /// the field"), not for the gesture.
    let label: String
    let onCommit: () -> Void
    let onComplete: () -> Void

    @ObservedObject var driver: HoldDriver
    @State private var touching: Bool = false

    func body(content: Content) -> some View {
        let _ = driver.bind(onCommit: onCommit, onComplete: onComplete)
        let _ = driver.configure(rise: duration, drain: drain)
        content
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !touching {
                            touching = true
                            driver.press(.touch)
                        }
                        let moved = hypot(Double(value.translation.width), Double(value.translation.height))
                        if moved > HoldLadder.cancelDistance, driver.isHeld {
                            driver.cancel()
                        }
                    }
                    .onEnded { _ in
                        touching = false
                        driver.release(.touch)
                    }
            )
            .focusable()
            .onKeyPress(keys: [.return, .space], phases: [.down, .repeat, .up]) { press in
                if press.phase == .down {
                    driver.press(.key)
                } else if press.phase == .repeat {
                    driver.press(.key, isRepeat: true)
                } else if press.phase == .up {
                    driver.release(.key)
                } else {
                    return .ignored
                }
                return .handled
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text(label))
            .accessibilityAddTraits(.isButton)
            .accessibilityValue(Text(driver.isHeld ? HoldEngine.spokenProgress(driver.progress) : ""))
            .accessibilityAction { driver.performByVoice() }
    }
}

/// A hold whose driver lives in the modifier, for a view that does not draw
/// the light itself (the-33 §2 row 31; V25).
@MainActor
struct OwnedHold: ViewModifier {
    let duration: TimeInterval
    let drain: TimeInterval
    let label: String
    let onCommit: () -> Void
    let onComplete: () -> Void
    @StateObject private var driver: HoldDriver

    init(duration: TimeInterval, drain: TimeInterval, label: String,
         onCommit: @escaping () -> Void, onComplete: @escaping () -> Void) {
        self.duration = duration
        self.drain = drain
        self.label = label
        self.onCommit = onCommit
        self.onComplete = onComplete
        _driver = StateObject(wrappedValue: HoldDriver(rise: duration, drain: drain))
    }

    func body(content: Content) -> some View {
        content.modifier(HoldModifier(duration: duration, drain: drain, label: label,
                                      onCommit: onCommit, onComplete: onComplete, driver: driver))
    }
}

extension View {

    /// The one hold (G0): fills over `duration`, commits at full, acts on
    /// release; an early release drains over `drain`; a tap does nothing; a
    /// held Enter / Space counts and its repeats are ignored. See
    /// ``HoldEngine`` and ``HoldLadder`` for the durations.
    @MainActor
    func hold(for duration: TimeInterval,
              drain: TimeInterval = HoldLadder.drain,
              named label: String,
              onCommit: @escaping () -> Void = {},
              onComplete: @escaping () -> Void) -> some View {
        modifier(OwnedHold(duration: duration, drain: drain, label: label,
                           onCommit: onCommit, onComplete: onComplete))
    }

    /// The same hold with a driver the view owns, so it can draw the light
    /// (`driver.progress`).
    @MainActor
    func hold(for duration: TimeInterval,
              drain: TimeInterval = HoldLadder.drain,
              named label: String,
              driver: HoldDriver,
              onCommit: @escaping () -> Void = {},
              onComplete: @escaping () -> Void) -> some View {
        modifier(HoldModifier(duration: duration, drain: drain, label: label,
                              onCommit: onCommit, onComplete: onComplete, driver: driver))
    }
}
