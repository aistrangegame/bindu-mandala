import XCTest
import UIKit

// MARK: - U0 · V02 / V03 / V05 / V30 — the frames, the manifest, the light engine
//
// `Design/frames.json` holds the forty parity frames F01–F40 (verification.md
// §1.4). These checks prove the manifest is whole, every frame it names is on
// disk byte for byte, and the light engine that every later wave measures the
// app with reproduces Design's own measured bands — and that each check can
// fail (V30, "every check born red").

final class FramesManifestTests: XCTestCase {

    // MARK: The manifest is whole

    func testTheManifestHoldsFortyFramesF01ToF40() throws {
        let m = try FramesManifest.load()
        let ids = m.frames.map(\.id)
        XCTAssertEqual(ids, (1...40).map { String(format: "F%02d", $0) }, "the manifest is not F01–F40 in order")
        XCTAssertEqual(Set(ids).count, 40, "a frame id repeats")
        let worlds: Set<String> = ["home", "today-rite", "mandala", "rings", "her-home", "her-presence",
                                   "climb", "the-33", "game", "modes", "time", "memory", "well",
                                   "beneath", "relationship"]
        for f in m.frames {
            XCTAssertTrue(worlds.contains(f.world), "\(f.id) belongs to no world: \(f.world)")
            XCTAssertFalse(f.what.isEmpty, "\(f.id) does not say what it is")
            XCTAssertFalse(f.notes.isEmpty, "\(f.id) does not say how it is compared")
            if let dup = f.duplicateOf {
                XCTAssertNotNil(m.frame(dup), "\(f.id) is a duplicate of \(dup), which is not in the manifest")
            }
            let band = try XCTUnwrap(f.band, "\(f.id) carries no luminance band")
            XCTAssertTrue(band.min <= band.p5 && band.p5 <= band.mean && band.mean <= band.p95
                          && band.p95 <= band.max,
                          "\(f.id)'s band is not ordered: \(band)")
            XCTAssertTrue((0...255).contains(band.min) && (0...255).contains(band.max), "\(f.id)'s band is off 0–255")
            if let hue = f.hue { XCTAssertTrue((0...360).contains(hue), "\(f.id)'s hue \(hue)") }
        }
    }

    /// Every frame's source is on disk — a missing one is a FAIL, never a skip —
    /// and is the very file that was measured (md5).
    func testEveryFrameSourceExistsAndIsTheFileThatWasMeasured() throws {
        let m = try FramesManifest.load()
        XCTAssertEqual(m.frames.count, 40)
        for f in m.frames {
            XCTAssertFalse(f.source.isEmpty, "\(f.id) names no source")
            let data = try DesignCorpus.data(f.source)
            if let md5 = f.md5 {
                XCTAssertEqual(DesignCorpus.md5(data), md5, "\(f.id)'s source is not the file that was measured")
            }
            XCTAssertNotNil(UIImage(data: data), "\(f.id)'s source is not an image this platform can read")
        }
    }

    /// The light engine reproduces Design's own measured mean for every frame
    /// (inside the crop, on the 64 × 64 grid) — so a later verdict that the app
    /// is "dimmer than Design" is a fact about the app, not about the ruler.
    /// Tolerance: ± 3 on 0–255 (the resampling filters differ by ≤ 0.6 on these
    /// frames; JPEG decoders by a little more).
    func testTheLightEngineReproducesDesignsMeasuredBands() throws {
        let m = try FramesManifest.load()
        var off: [String] = []
        for f in m.frames {
            guard let band = f.band else { continue }
            let image = try DesignCorpus.image(f.source)
            let measured = try XCTUnwrap(Luminance.measure(image, crop: f.crop), "\(f.id) could not be measured")
            if abs(measured.mean - band.mean) > 3 {
                off.append(String(format: "%@ mean %.1f, Design measured %.1f", f.id, measured.mean, band.mean))
            }
            if let hue = f.hue, let mh = measured.hue, f.chroma ?? 0 >= 5,
               Luminance.hueDistance(hue, mh) > 15 {
                off.append(String(format: "%@ hue %.0f, Design measured %.0f", f.id, mh, hue))
            }
        }
        XCTAssertTrue(off.isEmpty, "the light engine disagrees with Design's measurement:\n" + off.joined(separator: "\n"))
    }

    // MARK: Born red (V30)

    /// A manifest missing a frame, naming a file that is not there, or out of
    /// order must fail — shown on planted manifests, kept in the suite.
    func testTheManifestChecksCatchPlantedDefects() throws {
        let short = """
        {"frames": [{"id": "F01", "world": "rings", "what": "x", "source": "Design/Corpus/nope.png",
          "crop": null, "luminance": {"min": 1, "p5": 2, "mean": 30, "p95": 3, "max": 4}, "hue": 27,
          "chromaPercent": 3, "comparison": "x", "duplicateOf": "F99", "md5": null}]}
        """
        let m = try FramesManifest.decode(Data(short.utf8))
        XCTAssertNotEqual(m.frames.map(\.id), (1...40).map { String(format: "F%02d", $0) },
                          "a one-frame manifest passed as forty")
        XCTAssertFalse(DesignCorpus.exists(m.frames[0].source), "a missing source was found")
        XCTAssertThrowsError(try DesignCorpus.data(m.frames[0].source), "a missing Design file did not fail")
        let band = try XCTUnwrap(m.frames[0].band)
        XCTAssertFalse(band.p5 <= band.mean && band.mean <= band.p95, "an unordered band passed")
        XCTAssertNil(m.frame("F99"), "a dangling duplicateOf was resolved")
        // The array form and the `L` key decode as well (the brief's schema).
        let alt = #"[{"id": "F02", "world": "rings", "what": "y", "source": "s.png", "crop": [1, 2, 11, 22], "L": {"min": 0, "p5": 1, "mean": 2, "p95": 3, "max": 4}, "hue": null, "chroma": 1, "notes": "n", "duplicateOf": null}]"#
        let a = try FramesManifest.decode(Data(alt.utf8))
        XCTAssertEqual(a.frames.first?.crop, CGRect(x: 1, y: 2, width: 10, height: 20))
        XCTAssertEqual(a.frames.first?.band?.mean, 2)
    }

    /// The light engine on known pixels: a flat grey, a planted darkening that
    /// the light verdict refuses, a blow-out, and a pure hue.
    func testTheLightEngineIsRightOnKnownPixelsAndCanFail() throws {
        func flat(_ r: UInt8, _ g: UInt8, _ b: UInt8) -> [UInt8] {
            Array(repeating: [r, g, b, 255], count: 64 * 64).flatMap { $0 }
        }
        let grey = try XCTUnwrap(Luminance.measure(rgba: flat(100, 100, 100), count: 64 * 64))
        XCTAssertEqual(grey.mean, 100, accuracy: 1e-9)
        XCTAssertEqual(grey.p5, 100, accuracy: 1e-9)
        XCTAssertNil(grey.hue, "grey has no hue")
        XCTAssertEqual(grey.chromaPercent, 0)

        let red = try XCTUnwrap(Luminance.measure(rgba: flat(200, 0, 0), count: 64 * 64))
        XCTAssertEqual(red.mean, 0.2126 * 200, accuracy: 1e-9, "Rec.709 weights")
        XCTAssertEqual(red.hue ?? -1, 0, accuracy: 1e-6)
        XCTAssertEqual(red.chromaPercent, 100, accuracy: 1e-9)

        // Planted defect: a room darkened by half fails the light verdict
        // against the frame it was matched to (Design is the floor).
        let design = FramesManifest.Band(min: 0, p5: 10, mean: 100, p95: 180, max: 240)
        let matched = Luminance(min: 0, p5: 10, mean: 110, p95: 185, max: 245,
                                blownShare: 0, hue: nil, chromaPercent: 0)
        XCTAssertTrue(Luminance.lightVerdict(app: matched, frame: design).isEmpty, "a matched room failed")
        let darkened = Luminance(min: 0, p5: 5, mean: 55, p95: 92, max: 122,
                                 blownShare: 0, hue: nil, chromaPercent: 0)
        XCTAssertGreaterThanOrEqual(Luminance.lightVerdict(app: darkened, frame: design).count, 3,
                                    "a room darkened by half passed the light verdict")
        let blown = try XCTUnwrap(Luminance.measure(rgba: flat(255, 255, 255), count: 64 * 64))
        XCTAssertEqual(blown.blownShare, 1)
        XCTAssertFalse(Luminance.lightVerdict(app: blown, frame: design).isEmpty, "a blown-out room passed")

        XCTAssertEqual(Luminance.hueDistance(350, 10), 20, accuracy: 1e-9)
        XCTAssertEqual(Luminance.hueDistance(10, 350), 20, accuracy: 1e-9)
    }

    /// The corpus itself: the Design files every later wave reads are present.
    func testTheDesignCorpusIsInTheRepo() throws {
        for path in ["homes-worlds.js", "homes-sound.js", "homes-attribute.js",
                     "homes-descent.js", "homes-grammar.js", "homes-memory.js"] {
            _ = try DesignCorpus.text(path)   // throws (a failure) when missing
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: DesignCorpus.chakra.path), "Design/Chakra is missing")
        XCTAssertTrue(FileManager.default.fileExists(atPath: DesignCorpus.root.appendingPathComponent("README.md").path))
    }
}
