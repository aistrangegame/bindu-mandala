import Foundation

/// Where the repository is, for every test that reads the app's own source.
///
/// On a Mac with the checkout, `#filePath` points into it and that tree is
/// read directly. On Xcode Cloud the tests run on a machine that holds only the
/// built products, so the "Bundle the source tree" build phase copies the tree
/// into this test bundle (secrets excluded) and it is read from there. Same
/// relative layout either way: `iOS/Bindu Mandala`, `iOS/Bindu MandalaTests`,
/// `DECISIONS.md`, `Claude Design Round 2/homes`.
enum SourceTree {
    private final class Marker {}

    static let repoRoot: URL = {
        let checkout = URL(fileURLWithPath: #filePath)
            .resolvingSymlinksInPath()
            .deletingLastPathComponent()   // Bindu MandalaTests
            .deletingLastPathComponent()   // iOS
            .deletingLastPathComponent()   // repo root
        let fm = FileManager.default
        if fm.fileExists(atPath: checkout.appendingPathComponent("iOS/Bindu Mandala").path) {
            return checkout
        }
        if let bundled = Bundle(for: Marker.self).resourceURL?
            .appendingPathComponent("SourceTree", isDirectory: true)
            .resolvingSymlinksInPath(),
           fm.fileExists(atPath: bundled.appendingPathComponent("iOS/Bindu Mandala").path) {
            return bundled
        }
        return checkout
    }()

    /// `iOS/` inside whichever tree was found.
    static var iOSRoot: URL { repoRoot.appendingPathComponent("iOS", isDirectory: true) }
}
