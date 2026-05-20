import SwiftUI
import UIKit

/// Restores the iOS edge-swipe-back gesture on NavigationStack-pushed views
/// that hide the system back button in favor of a custom in-view back affordance.
///
/// Hiding the back button (`.navigationBarBackButtonHidden(true)`) also suppresses
/// the interactive pop gesture, because UIKit ties the gesture's `shouldBegin`
/// to back-button presence. This shim installs a delegate that allows the
/// gesture whenever the nav stack has something to pop.
struct SwipeBackEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Controller { Controller() }
    func updateUIViewController(_ uiViewController: Controller, context: Context) {}

    final class Controller: UIViewController, UIGestureRecognizerDelegate {
        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            guard let nav = parent?.navigationController else { return }
            nav.interactivePopGestureRecognizer?.delegate = self
            nav.interactivePopGestureRecognizer?.isEnabled = true
        }

        func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool {
            (parent?.navigationController?.viewControllers.count ?? 0) > 1
        }
    }
}

extension View {
    /// Use on a pushed view whose back button is hidden but which still
    /// wants iOS edge-swipe-to-pop to work.
    func enableSwipeBack() -> some View {
        background(
            SwipeBackEnabler()
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
    }
}
