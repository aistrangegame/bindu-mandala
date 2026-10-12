import SwiftUI

// MARK: - Wave 2 · the equal way out, from the edge
//
// The Reading's §3 row on the 2.2 s held way out: *"Keep, extend. It is Design's
// number. Add Escape / left-edge as an equal way out per padakarshini law 14
// ('leaving is one gesture everywhere, never punished')."*
//
// The hold stays exactly as it is (``TheWayOut``). Beside it, a swipe in from
// the leading edge — the gesture every iOS screen already means *back* by — is
// the same leaving, through the same door: the surface's own `onOut`, so the
// stay is filed, the after-effect lingers and the voice closes exactly as they
// do after the hold. Nothing is lost by leaving this way, and nothing is said.
//
// It is offered wherever the hold is offered and nowhere else: a threshold is
// not a dialog, so there is no edge out of the rite's three beats either.

/// A swipe in from the leading edge, as an equal way out.
struct TheEdgeWayOut: ViewModifier {

    /// Whether there is a way out from where he is standing.
    let shown: Bool
    /// He is outside.
    let onOut: () -> Void

    /// How wide the edge is that a swipe must begin in.
    static let edgeWidth: CGFloat = 22
    /// How far in the swipe must carry before it is a leaving.
    static let travel: CGFloat = 72

    @State private var gone: Bool = false

    func body(content: Content) -> some View {
        content.overlay(alignment: .leading) {
            if shown {
                Color.clear
                    .frame(width: Self.edgeWidth)
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 12)
                            .onEnded { value in
                                guard value.translation.width > Self.travel,
                                      abs(value.translation.height) < value.translation.width
                                else { return }
                                leave()
                            })
                    .accessibilityHidden(true)
            }
        }
    }

    private func leave() {
        guard !gone else { return }
        gone = true
        Haptics.light()
        onOut()
    }
}

extension View {
    /// The equal way out of a Home surface, from the leading edge.
    func theEdgeWayOut(shown: Bool = true, onOut: @escaping () -> Void) -> some View {
        modifier(TheEdgeWayOut(shown: shown, onOut: onOut))
    }
}
