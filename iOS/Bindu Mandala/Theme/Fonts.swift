import SwiftUI
import UIKit
import os

private let fontLog = Logger(subsystem: "com.ashrey.bindu-mandala", category: "fonts")

// MARK: - The type of the instrument, and how it grows
//
// Brief v2 §4.3. Audit §H5: *"Dynamic Type: none at all — 152 fixed-size font
// sites in Views, zero text styles, zero `relativeTo:`."* Every string in the
// app was nailed to the point size it was drawn at, so a walker who has turned
// the system's type up reads Bindu Mandala at exactly the size somebody else
// chose for him.
//
// The three tokens below are the whole mechanism. `sanskrit` and `voice` are
// `Font.custom(_:size:relativeTo:)`, which is Dynamic Type for a bundled face:
// the size stays exactly what it says at the default content size, and grows
// from there in the proportion the named text style grows. `label` is the same
// idea for the system sans the small-caps strips are set in, done through
// `UIFontMetrics` because `Font.system(size:)` has no `relativeTo:` of its own.
//
// **The designed size is still the designed size.** Nothing here rounds, clamps
// or re-picks a number: at the default category every one of these returns the
// point size written at the call site, which is why the composition snapshots
// recorded before this phase still pass. What changes is that the number is now
// a floor that moves with the walker rather than a ceiling nailed to the glass.
//
// **Which style a size is measured against.** A size is mapped to the system
// text style nearest it, because that is what decides *how fast* it grows: at
// the largest accessibility setting `caption2` roughly triples while `largeTitle`
// grows by about half. A 60 pt name that tripled would be four words on nine
// lines; an 11 pt strip that grew by half would still be unreadable. The mapping
// is one table, in one place, so no call site has to make the judgement — and
// any site that wants a different answer passes the style itself.
//
// **What is deliberately not scaled**, each for a reason that is about the thing
// and not about the work:
//
//  · **Canvas-drawn strings.** `MandalaCanvasLayer` resolves its seat names,
//    bīja and enclosure titles inside a `Canvas`, in world coordinates that the
//    camera scales. The brief excepts them in as many words, and they are
//    excepted here: a canvas label has no line box to wrap into and no stack to
//    push, so growing the glyphs would overlap the seats they name rather than
//    make them legible. Zooming is what makes them bigger, and that is a gesture
//    the walker already has. `LalitaSourceView`'s returning field draws no text
//    at all.
//
//  · **Glyph controls in a fixed circular target.** The zoom column's `+`, `−`,
//    `⤢` and `♪`, the card's `×`. These are not words: each is one mark centred
//    in a 44–47 pt disc that `HitAreaIdiomTests` holds to its size, and a mark
//    grown past its own disc is clipped, not read. They carry accessibility
//    labels; that is the channel that scales for them.

enum AppFont {
    static let cormorant = "CormorantGaramond-Light"
    static let cormorantItalic = "CormorantGaramond-LightItalic"

    /// The system text style a size grows in proportion to. The boundaries sit
    /// between the styles' own default sizes (11 · 12 · 13 · 15 · 16 · 17 · 20 ·
    /// 22 · 28 · 34), so a size is measured against the style it is already
    /// nearest — and a size chosen *between* two styles takes the smaller of
    /// them, which grows slightly faster. That is the right way to be wrong: the
    /// failure this phase exists to prevent is text too small, never text too
    /// eager.
    static func style(forSize size: CGFloat) -> Font.TextStyle {
        switch size {
        case ..<11.75:  return .caption2
        case ..<12.75:  return .caption
        case ..<14.25:  return .footnote
        case ..<15.75:  return .subheadline
        case ..<16.75:  return .callout
        case ..<18.75:  return .body
        case ..<21.25:  return .title3
        case ..<25.25:  return .title2
        case ..<31.25:  return .title
        default:        return .largeTitle
        }
    }

    /// Her names, her qualities, the instrument's own voice — Cormorant Light.
    static func sanskrit(_ size: CGFloat, _ style: Font.TextStyle? = nil) -> Font {
        .custom(cormorant, size: size, relativeTo: style ?? self.style(forSize: size))
    }

    /// The italic register: the lines the instrument says *to* the walker.
    static func voice(_ size: CGFloat, _ style: Font.TextStyle? = nil) -> Font {
        .custom(cormorantItalic, size: size, relativeTo: style ?? self.style(forSize: size))
    }

    /// The point size the small-caps strips are actually drawn at, in a given
    /// content size category — the live one when `traits` is nil.
    ///
    /// **Why this is not just `scaledValue(for:)`.** `UIFontMetrics` quantises
    /// its answer to a third of a point, so a half-point size does not survive
    /// the round trip: asked for 11.5 at the *default* category it returns
    /// 11.666…, and a strip written at 11.5 would ship 1.45% larger than it was
    /// drawn. On the Rite that was enough to push a one-line kicker with a
    /// quarter-point of slack onto two lines and move the whole centre column
    /// seven points down the glass.
    ///
    /// So the metric is normalised against its own answer at `.large`: the
    /// ratio is what carries the growth, and the designed size is what it grows
    /// from. At the default category this is exactly the number written at the
    /// call site — which is the premise every composition baseline in
    /// `iOS/SnapshotBaselines/` rests on — and above it the strip grows in the
    /// same proportion the system's own text style grows.
    static func labelPointSize(_ size: CGFloat,
                               _ style: Font.TextStyle? = nil,
                               compatibleWith traits: UITraitCollection? = nil) -> CGFloat {
        let metrics = UIFontMetrics(forTextStyle: uiTextStyle(style ?? self.style(forSize: size)))
        let atDefault = metrics.scaledValue(
            for: size, compatibleWith: UITraitCollection(preferredContentSizeCategory: .large))
        guard atDefault > 0 else { return size }
        let live = traits.map { metrics.scaledValue(for: size, compatibleWith: $0) }
            ?? metrics.scaledValue(for: size)
        return live * size / atDefault
    }

    /// The small-caps system strips — section titles, ghost hints, the tracked
    /// labels above a block.
    ///
    /// `Font.system(size:)` has no `relativeTo:`, so this is built through
    /// `UIFontMetrics`, which scales a point size against a text style using the
    /// app's own preferred content size category. That is the same category
    /// SwiftUI's environment reads, and it is what an XCUITest launched with
    /// `-UIPreferredContentSizeCategoryName` overrides — so the tests that prove
    /// this at the largest accessibility size are measuring the thing that ships.
    static func label(_ size: CGFloat = 12, _ style: Font.TextStyle? = nil) -> Font {
        Font(UIFont.systemFont(ofSize: labelPointSize(size, style), weight: .regular))
    }


    static func uiTextStyle(_ style: Font.TextStyle) -> UIFont.TextStyle {
        switch style {
        case .largeTitle:  return .largeTitle
        case .title:       return .title1
        case .title2:      return .title2
        case .title3:      return .title3
        case .headline:    return .headline
        case .subheadline: return .subheadline
        case .body:        return .body
        case .callout:     return .callout
        case .footnote:    return .footnote
        case .caption:     return .caption1
        case .caption2:    return .caption2
        @unknown default:  return .body
        }
    }

    /// One-shot audit at launch — logs whether our custom fonts are actually
    /// registered with UIKit. If you see "MISSING", the .ttf didn't make it
    /// into the bundle or its PostScript name doesn't match what we ask for.
    static func audit() {
        let want = [cormorant, cormorantItalic]
        for name in want {
            if let _ = UIFont(name: name, size: 12) {
                fontLog.notice("✓ \(name, privacy: .public) registered.")
            } else {
                fontLog.error("✗ \(name, privacy: .public) MISSING — falling back to system serif.")
            }
        }
    }
}

extension View {
    func tracked(_ tracking: CGFloat) -> some View {
        self.tracking(tracking)
    }
}
