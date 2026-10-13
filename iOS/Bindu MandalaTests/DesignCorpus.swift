import XCTest
import UIKit
import CryptoKit

// MARK: - U0 · the parity helpers (V02, V03, V05)
//
// `waves/upgrade/worlds/verification.md`: every later wave proves its worlds
// against Design's own files — numbers read off disk (V06), frames measured
// (V05), the forty frames as references (V03). These are the helpers those
// checks stand on.
//
// **A missing Design file is a FAIL, never an `XCTSkip`.** A skip reads as
// green in a test report, and a parity check that cannot find its reference
// has proven nothing — so `DesignCorpus.data(_:)` throws a plain error, which
// XCTest records as a failure.
//
// Where the files are: `Design/` at the repository root (Part B copied the
// upload there byte for byte — `Design/README.md`). Found the way every
// source-reading suite finds the repo: `SourceTree.repoRoot`, the checkout via
// `#filePath` on the Mac, or the copy the "Bundle the source tree" build phase
// puts inside this test bundle on Xcode Cloud (that phase now rsyncs `Design/`
// too).

enum DesignCorpus {

    struct Missing: Error, CustomStringConvertible {
        let path: String
        var description: String {
            "Design file missing: \(path) — a missing Design file is a failure, never a skip"
        }
    }

    /// `Design/` inside whichever tree `SourceTree` found.
    static var root: URL { SourceTree.repoRoot.appendingPathComponent("Design", isDirectory: true) }

    /// `Design/Corpus/` — the Design upload.
    static var corpus: URL { root.appendingPathComponent("Corpus", isDirectory: true) }

    /// `Design/Chakra/` — the chakra upload.
    static var chakra: URL { root.appendingPathComponent("Chakra", isDirectory: true) }

    /// A Design path, resolved: repo-relative (`Design/Corpus/…`, as the frames
    /// manifest writes `source`), or relative to `Design/Corpus/` (as
    /// verification.md and `corpusPath` write it).
    static func url(_ path: String) -> URL {
        if path.hasPrefix("Design/") { return SourceTree.repoRoot.appendingPathComponent(path) }
        return corpus.appendingPathComponent(path)
    }

    static func exists(_ path: String) -> Bool {
        FileManager.default.fileExists(atPath: url(path).path)
    }

    /// The file's bytes, or a thrown `Missing` (a failure).
    static func data(_ path: String) throws -> Data {
        let u = url(path)
        guard let d = FileManager.default.contents(atPath: u.path) else { throw Missing(path: u.path) }
        return d
    }

    /// A Design source file as text (`.js`, `.jsx`, `.html`, `.md`), or a failure.
    static func text(_ path: String) throws -> String {
        let d = try data(path)
        guard let s = String(data: d, encoding: .utf8) else { throw Missing(path: url(path).path + " (not UTF-8)") }
        return s
    }

    /// A Design image, or a failure.
    static func image(_ path: String) throws -> UIImage {
        let d = try data(path)
        guard let img = UIImage(data: d) else { throw Missing(path: url(path).path + " (not an image)") }
        return img
    }

    static func md5(_ data: Data) -> String {
        Insecure.MD5.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - The frames manifest (V03)

/// `Design/frames.json`, read leniently: the top level may be the array itself
/// or an object holding `frames`; the luminance band may be `luminance` or `L`;
/// chroma `chromaPercent` or `chroma`; the note `comparison` or `notes`.
struct FramesManifest {

    struct Band: Equatable {
        let min, p5, mean, p95, max: Double
    }

    struct Frame {
        let id: String
        let world: String
        let what: String
        /// Repo-relative (`Design/Corpus/…`) or corpus-relative.
        let source: String
        /// x0, y0, x1, y1 in source pixels; nil = the whole image.
        let crop: CGRect?
        let band: Band?
        let hue: Double?
        let chroma: Double?
        let notes: String
        let duplicateOf: String?
        let md5: String?
    }

    let frames: [Frame]

    static var url: URL { DesignCorpus.root.appendingPathComponent("frames.json") }

    static func load() throws -> FramesManifest {
        let data = try DesignCorpus.data("Design/frames.json")
        return try decode(data)
    }

    static func decode(_ data: Data) throws -> FramesManifest {
        let any = try JSONSerialization.jsonObject(with: data)
        let rows: [[String: Any]]
        if let a = any as? [[String: Any]] {
            rows = a
        } else if let o = any as? [String: Any], let a = o["frames"] as? [[String: Any]] {
            rows = a
        } else {
            throw DesignCorpus.Missing(path: "frames.json (neither an array nor {frames: […]})")
        }
        return FramesManifest(frames: rows.map(frame))
    }

    private static func number(_ v: Any?) -> Double? { (v as? NSNumber)?.doubleValue }

    private static func frame(_ r: [String: Any]) -> Frame {
        var crop: CGRect? = nil
        if let c = r["crop"] as? [Any], c.count == 4,
           let x0 = number(c[0]), let y0 = number(c[1]), let x1 = number(c[2]), let y1 = number(c[3]) {
            crop = CGRect(x: x0, y: y0, width: x1 - x0, height: y1 - y0)
        }
        var band: Band? = nil
        if let l = (r["luminance"] ?? r["L"]) as? [String: Any],
           let mn = number(l["min"]), let p5 = number(l["p5"]), let mean = number(l["mean"]),
           let p95 = number(l["p95"]), let mx = number(l["max"]) {
            band = Band(min: mn, p5: p5, mean: mean, p95: p95, max: mx)
        }
        return Frame(id: r["id"] as? String ?? "",
                     world: r["world"] as? String ?? "",
                     what: r["what"] as? String ?? "",
                     source: r["source"] as? String ?? "",
                     crop: crop,
                     band: band,
                     hue: number(r["hue"]),
                     chroma: number(r["chromaPercent"] ?? r["chroma"]),
                     notes: (r["comparison"] ?? r["notes"]) as? String ?? "",
                     duplicateOf: r["duplicateOf"] as? String,
                     md5: r["md5"] as? String)
    }

    func frame(_ id: String) -> Frame? { frames.first { $0.id == id } }
}

// MARK: - Luminance on the 64 × 64 grid (V05)

/// The light of a picture as verification.md §1.4 measures it: resampled to a
/// 64 × 64 grid, Rec.709 luminance `.2126 R + .7152 G + .0722 B` on 0–255;
/// min / p5 / mean / p95 / max; the blown share (L ≥ 250); and the dominant hue
/// — the chroma-weighted circular mean over pixels with V > .12 and S > .25 —
/// with the share of such pixels.
struct Luminance: Equatable {
    let min, p5, mean, p95, max: Double
    /// Share of the grid at L ≥ 250, 0…1.
    let blownShare: Double
    /// Degrees 0…360, nil when no pixel is chromatic.
    let hue: Double?
    /// Share of chromatic pixels, in percent (as the manifest writes it).
    let chromaPercent: Double

    static let grid = 64

    /// Measure `image`, cropped first to `crop` (in the image's pixels) when given.
    static func measure(_ image: UIImage, crop: CGRect? = nil) -> Luminance? {
        guard var cg = image.cgImage else { return nil }
        if let crop, let cropped = cg.cropping(to: crop.integral) { cg = cropped }
        let n = grid
        var buffer = [UInt8](repeating: 0, count: n * n * 4)
        guard let ctx = CGContext(data: &buffer, width: n, height: n, bitsPerComponent: 8,
                                  bytesPerRow: n * 4, space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { return nil }
        ctx.interpolationQuality = .high
        ctx.draw(cg, in: CGRect(x: 0, y: 0, width: n, height: n))
        return measure(rgba: buffer, count: n * n)
    }

    /// The same measure over raw RGBA bytes — `count` pixels, 4 bytes each.
    static func measure(rgba: [UInt8], count: Int) -> Luminance? {
        guard count > 0, rgba.count >= count * 4 else { return nil }
        var ls: [Double] = []
        ls.reserveCapacity(count)
        var sx = 0.0, sy = 0.0, chromatic = 0
        var blown = 0
        for i in 0..<count {
            let r = Double(rgba[i * 4]), g = Double(rgba[i * 4 + 1]), b = Double(rgba[i * 4 + 2])
            let l = 0.2126 * r + 0.7152 * g + 0.0722 * b
            ls.append(l)
            if l >= 250 { blown += 1 }
            let mx = Swift.max(r, g, b) / 255, mn = Swift.min(r, g, b) / 255
            let c = mx - mn
            let s = mx > 0 ? c / mx : 0
            if mx > 0.12, s > 0.25, c > 0 {
                let rr = r / 255, gg = g / 255, bb = b / 255
                var h: Double
                if mx == rr { h = (gg - bb) / c } else if mx == gg { h = 2 + (bb - rr) / c } else { h = 4 + (rr - gg) / c }
                h *= 60
                if h < 0 { h += 360 }
                let rad = h * .pi / 180
                sx += c * cos(rad); sy += c * sin(rad)
                chromatic += 1
            }
        }
        let sorted = ls.sorted()
        func percentile(_ p: Double) -> Double {
            let idx = Swift.min(sorted.count - 1, Swift.max(0, Int((p * Double(sorted.count - 1)).rounded())))
            return sorted[idx]
        }
        var hue: Double? = nil
        if chromatic > 0, sx != 0 || sy != 0 {
            var h = atan2(sy, sx) * 180 / .pi
            if h < 0 { h += 360 }
            hue = h
        }
        return Luminance(min: sorted.first ?? 0, p5: percentile(0.05),
                         mean: ls.reduce(0, +) / Double(ls.count),
                         p95: percentile(0.95), max: sorted.last ?? 0,
                         blownShare: Double(blown) / Double(count),
                         hue: hue, chromaPercent: 100 * Double(chromatic) / Double(count))
    }

    /// The circular distance between two hues, in degrees (0…180).
    static func hueDistance(_ a: Double, _ b: Double) -> Double {
        let d = abs((a - b).truncatingRemainder(dividingBy: 360))
        return d > 180 ? 360 - d : d
    }

    /// verification.md §1.4's light rule, Design as the floor: the app's mean
    /// in [0.8, 1.6] × the frame's; p95 ≥ frame p95 − 10 %; max ≥ frame max − 15;
    /// blown share ≤ the frame's + 1 %. Returns the clauses that failed (empty = PASS).
    static func lightVerdict(app: Luminance, frame: FramesManifest.Band, frameBlownShare: Double = 0) -> [String] {
        var out: [String] = []
        if frame.mean > 0 {
            let ratio = app.mean / frame.mean
            if ratio < 0.8 { out.append(String(format: "mean %.1f is dimmer than Design's %.1f × 0.8", app.mean, frame.mean)) }
            if ratio > 1.6 { out.append(String(format: "mean %.1f is past Design's %.1f × 1.6", app.mean, frame.mean)) }
        }
        if app.p95 < frame.p95 * 0.9 { out.append(String(format: "p95 %.1f < Design's %.1f − 10%%", app.p95, frame.p95)) }
        if app.max < frame.max - 15 { out.append(String(format: "max %.1f < Design's %.1f − 15", app.max, frame.max)) }
        if app.blownShare > frameBlownShare + 0.01 {
            out.append(String(format: "blown share %.3f > Design's + 1%%", app.blownShare))
        }
        return out
    }
}
