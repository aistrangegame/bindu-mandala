import SwiftUI

/// Layout-level constants the practice holds itself to.
///
/// `Hit.min` is the minimum touch-target dimension. Per Apple HIG and the
/// brief's bar, every tappable energy uses `.frame(width: Hit.min, height:
/// Hit.min)` + `.contentShape(...)`. The *visible* glyph stays small — only
/// the invisible hit area grows. Visual scale and discoverability are
/// orthogonal to thumb-reachability.
enum Hit {
    static let min: CGFloat = 44
}
