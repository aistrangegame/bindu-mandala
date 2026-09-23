import SwiftUI

// MARK: - The way out of the Homes layer, written down once
//
// Phase 3.7 opens two doors into the building — her room, from her own screen,
// and the nine āvaraṇas, from the Field. This is the other half, and the phase
// is not done without it: *the way out matters as much as the way in.*
//
// ─────────────────────────────────────────────────────────────────────────────
// LEAVING IS A CROSSING, SO IT IS HELD RATHER THAN TAPPED
// ─────────────────────────────────────────────────────────────────────────────
//
// The rite of entering is paced by single touches, and it can be, because a
// touch there costs nothing: the ceremony has nothing to lose and the next beat
// is the only thing on the other side of it. A stay does have something to lose.
// A stray finger that ended a stay would take with it the adaptation the whole
// instrument is made of — so the way out asks for the one gesture this app
// already uses for a crossing that cannot be taken back: a hold.
//
// The Detail's own pill says *"hold to cross into …"*. This is the same idiom,
// pointed the other way, and the hold lasts exactly as long as the crossing it
// is: ``RoomApproach/releaseSeconds``, Design's own `2.2`, read here rather
// than typed again. In her room the hold **is** the walk — the eye stands away
// from her through the āvaraṇa's own air for the whole of it, and letting go
// before it is over carries him back in.
//
// ─────────────────────────────────────────────────────────────────────────────
// REDUCED MOTION: A TOUCH, BECAUSE A HOLD WITH NOTHING MOVING IS ONLY WAITING
// ─────────────────────────────────────────────────────────────────────────────
//
// `iOS/FIDELITY.md` asks for a **real** still path, and Design's invariant 4 for
// motion that is *quantized, never disabled*. A hold is only legible while
// something is travelling through it: with the render loop stopped there is
// nothing to watch, and two and a fifth seconds of a blank press is not restraint
// but a stopped clock. So on the still path the crossing is a **step** — one
// touch, and he is outside — which is the same reading the rite took for its own
// stations and the climb took for its bands. The whole distance is crossed in
// both; one is walked and one is stepped, and neither is skipped.
//
// The words follow the path, which is why they are two strings and not one:
// *hold* where there is a walk to hold through, *touch* where there is a step,
// and "touch to …" is the rite's own ``RitePrompt`` wording so the instruction
// out of a room is in the same voice as the instruction into it.
//
// ─────────────────────────────────────────────────────────────────────────────
// IT SAYS NOTHING, AND THERE IS NOWHERE IN IT TO SAY ANYTHING
// ─────────────────────────────────────────────────────────────────────────────
//
// This is the only thing the walker is shown inside a room besides the room, so
// it is also the most obvious place in the instrument for a count to appear. It
// carries no value at all: every stored property of `TheWayOut` is a `Bool` or a
// closure returning `Void`, and its whole vocabulary is the two strings below.
// There is no field here that could hold a number, which is law 2 held by the
// shape of the type rather than by care — the same discipline ``HomeDwelling``
// is built with, and a test reads the property types off disk and refuses
// anything else: a value it holds is a value it can be made to show.
//
// It is set in the rite's own type, at the rite's own size and alpha and in the
// rite's own place at the foot of the frame, so the last thing a walker reads on
// the way in and the first thing he reads on the way out stand in one voice and
// one position. `iOS/FIDELITY.md` rule 4's floor is cleared rather than sat on:
// this is an instruction, not a ghost.

/// The one way out of anywhere in the Homes layer.
///
/// Draws the instruction, owns the gesture, and hands back three facts and no
/// values: the crossing began, the crossing was let go of, the walker is out.
struct TheWayOut: ViewModifier {

    /// The walker's motion setting, already resolved by the surface applying
    /// this — a `ViewModifier` sees the environment, but the surfaces here
    /// already fold `forceReduceMotion` into one answer and two readings of one
    /// setting is exactly the defect the Phase 3.1 review found in the rite.
    let reduceMotion: Bool

    /// The crossing has begun, and how long it has to run. A surface with an
    /// approach to unwind uses the seconds; one without may ignore them.
    var onBegan: (TimeInterval) -> Void = { _ in }

    /// He let go before he was out. Whatever began, unbegins.
    var onLetGo: () -> Void = { }

    /// He is outside.
    let onOut: () -> Void

    /// Whether there is a way out from where he is standing.
    ///
    /// `false` for the whole of the rite of entering, and that is a decision
    /// rather than an oversight: **a threshold is not a dialog and has no
    /// cancel on it.** The ceremony is three touches long; offering a second
    /// instruction beside *"touch to go on"* would make the crossing a thing
    /// one could be talked out of, and the rite's own prompt is the only
    /// instruction Design puts at a threshold.
    var shown: Bool = true

    /// How long the crossing out takes — Design's own release, read from the
    /// crossing in rather than chosen, so the way out is the way in at the same
    /// pace.
    static var seconds: TimeInterval { RoomApproach.releaseSeconds }

    /// The rite's own prompt, in the rite's own words for a step.
    static let stepped = "touch to withdraw"
    /// …and for a walk that is held through.
    static let held = "hold to withdraw"

    static func words(reduceMotion: Bool) -> String { reduceMotion ? stepped : held }

    /// Set in the rite's own prompt type and alpha (``RiteOfEntering``), which
    /// clears FIDELITY rule 4's floor rather than sitting on it.
    static let size: CGFloat = 11
    static var alpha: Double { RiteOfEntering.promptAlpha }

    /// Nothing is out yet; and once it is, a finger lifting cannot take it back.
    ///
    /// Written with its type rather than inferring it, because the check that
    /// reads this file off disk judges every stored property by the type it can
    /// see, and an un-annotated one is judged by its initialiser instead.
    @State private var gone: Bool = false

    func body(content: Content) -> some View {
        ZStack {
            content
            if shown {
                VStack {
                    Spacer()
                    prompt
                        .padding(.bottom, 64)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private var prompt: some View {
        Text(Self.words(reduceMotion: reduceMotion))
            .font(AppFont.label(Self.size))
            .textCase(.uppercase)
            .tracking(Self.size * 0.3)
            .foregroundStyle(Color.cream)
            .opacity(Self.alpha)
            .padding(.horizontal, 24)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
            .modifier(WayOutGesture(reduceMotion: reduceMotion,
                                    gone: $gone,
                                    onBegan: onBegan,
                                    onLetGo: onLetGo,
                                    onOut: onOut))
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(Text(Self.words(reduceMotion: reduceMotion)))
            // A voice performs an action; it never holds one. The crossing is
            // not a test of patience, so a walker arriving here by VoiceOver is
            // simply outside.
            .accessibilityAction { leave() }
    }

    private func leave() {
        guard !gone else { return }
        gone = true
        Haptics.light()
        onOut()
    }
}

/// The gesture, split out because the two paths are two gestures and a
/// `ViewBuilder` branch inside one modifier would rebuild the prompt whenever
/// the walker changed the setting mid-stay.
private struct WayOutGesture: ViewModifier {
    let reduceMotion: Bool
    @Binding var gone: Bool
    let onBegan: (TimeInterval) -> Void
    let onLetGo: () -> Void
    let onOut: () -> Void

    func body(content: Content) -> some View {
        if reduceMotion {
            content.onTapGesture { out() }
        } else {
            content.onLongPressGesture(
                minimumDuration: TheWayOut.seconds,
                maximumDistance: 44,
                perform: { out() },
                onPressingChanged: { pressing in
                    guard !gone else { return }
                    if pressing {
                        Haptics.soft()
                        onBegan(TheWayOut.seconds)
                    } else {
                        onLetGo()
                    }
                })
        }
    }

    private func out() {
        guard !gone else { return }
        gone = true
        Haptics.light()
        onOut()
    }
}

extension View {
    /// The way out of a Home surface. See ``TheWayOut``.
    func theWayOut(reduceMotion: Bool,
                   shown: Bool = true,
                   onBegan: @escaping (TimeInterval) -> Void = { _ in },
                   onLetGo: @escaping () -> Void = { },
                   onOut: @escaping () -> Void) -> some View {
        modifier(TheWayOut(reduceMotion: reduceMotion,
                           onBegan: onBegan,
                           onLetGo: onLetGo,
                           onOut: onOut,
                           shown: shown))
    }
}
