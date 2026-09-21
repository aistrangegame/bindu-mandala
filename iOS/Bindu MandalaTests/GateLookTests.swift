import XCTest
import UIKit
@testable import Bindu_Mandala

// MARK: - THE GATE, LOOKED AT
//
// `iOS/FIDELITY.md` §7 asks for a picture of any new screen, driving the actual
// flow, and it keeps earning its place. Phase 3.1 was 438 tests green when the
// first frame of the rite showed the āvaraṇa's dust standing perfectly still;
// no assertion about a room could have found it. Phase 3.3 cost three more, and
// every one of them passed every check in the suite first:
//
//   * **the floor rose to the walker's chest.** The generic reversal let the
//     ground take the work over by standing somewhere else, and Garimā's floor
//     came up three units — a pale wall filling four fifths of the frame with
//     every bed she had made lost behind it. A floor cannot come toward a walker
//     standing on it. It answers in material now (``RoomReversal/stations(_:deep:bodyAltitude:)``).
//   * **the ember was inside the hill.** Her mark's light stands off the material
//     it is in, and the material had risen two units; the light ended up under
//     the top of the plinth, and an omni light inside a mound lights the whole
//     mound (``RoomScene/markRelief``).
//   * **the riser stood in front of her face.** A box a third of the face's span
//     deep, centred on the face's own plane, put half of itself between the
//     walker and her mark — in every room a Śakti is felt between the soles and
//     the crown, which is most of the hundred and two. The spine had never had a
//     face room captured: the rite and the legibility spread both look at rooms
//     whose mark is in the floor.
//
// So this is the harness that takes the pictures, kept rather than thrown away —
// the rings still to come will need it, and a capture nobody can re-take is a
// capture that stops being true. It asserts the one thing a still *can* assert
// on its own and Design's legibility register asks for: **the room visibly
// changed.** Two rooms that render identically at the two adaptations are one
// room shown twice, whatever the luminance says.
@MainActor
final class GateLookTests: XCTestCase {

    /// Where the frames land, so a human can open them. Printed rather than
    /// asserted about: a path is not a check.
    private static let folder = "gate-look"

    private static let frameSize = CGSize(width: 360, height: 720)

    /// The four moments worth looking at: the room as it opens, the first
    /// adaptation, the hold, and past the second.
    private static var moments: [(String, TimeInterval)] {
        [("0-open", 0),
         ("1-first", HomeMemory.firstAdaptation),
         ("2-hold", HomeMemory.holdEnd),
         ("3-deep", HomeMemory.secondAdaptationEnd)]
    }

    func testTheGateIsVisiblyADifferentRoomAtEachAdaptation() throws {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(Self.folder)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        // Her row as the base carries it. Nothing is looked up by name.
        let gate: [(String, Int, String, String, String)] = [
            ("laghima", 3, "Lightness", "Vāyu — air, movement", "Solar plexus rising upward"),
            ("garima", 4, "Weightedness", "Pṛthvī — earth", "Mūlādhāra / sit-bones / soles"),
        ]

        for (name, position, quality, tattva, location) in gate {
            let row = Shakti(position: position, name: name, shortName: "", phonetic: "",
                             quality: quality, qualityDescription: "", somatic: "",
                             somaticPoetry: "", bija: "", bodilyLocation: location,
                             tattva: tattva, recognitionPhrase: "", cluster: .inner,
                             status: .mapped)
            row.ringNumber = 1
            row.khadgamalaPosition = position
            let room = try XCTUnwrap(HomeRooms.resolve(row))
            let scene = RoomScene(room: room)

            var frames: [(String, [UInt8])] = []
            var nearHalf: [String: Double] = [:]
            for (when, t) in Self.moments {
                let image = try XCTUnwrap(scene.capture(size: Self.frameSize, atSceneTime: t),
                                          "\(name) could not be rendered offscreen at \(when)")
                let data = try XCTUnwrap(UIImage(cgImage: image).pngData())
                try data.write(to: directory.appendingPathComponent("\(name)-\(when).png"))
                frames.append((when, Self.grid(of: image)))
                nearHalf[when] = Self.nearMean(of: image)
            }

            // **And the near half of the frame does not run away with the light.**
            //
            // A global mean cannot tell a lit room from a washed one — the frame
            // that failed this was 0.2064 overall, comfortably inside every
            // luminance bound in the suite — because the mark that washes it is
            // one thing in one place, and the place is always the same: her mark
            // comes toward the walker through the second adaptation, so whatever
            // it lights it lights *near*, filling the bottom of the picture.
            // Garimā's near half went 0.081 → 0.343 with the structure in it
            // unchanged, which is a wash by definition: more light, no more room.
            let first = nearHalf["1-first"] ?? 0
            let deep = nearHalf["3-deep"] ?? 0
            let ran = first > 0 ? deep / first : 0
            print(String(format: "GATE_NEAR {\"room\":\"%@\",\"atFirst\":%.4f,\"pastSecond\":%.4f,"
                         + "\"ratio\":%.2f}", name, first, deep, ran))
            XCTAssertLessThan(ran, 3.5,
                              """
                              \(name)'s near half is \(ran) times as bright past the second adaptation \
                              as at the first (\(first) → \(deep)). Something in front of the walker is \
                              lighting the floor rather than showing it, and a whole-frame mean will \
                              not see it.
                              """)

            // Design's legibility register asks for *"always visibly changed"*.
            // Read as the fraction of a coarse grid that moved by more than a
            // rounding: a room that holds still through a whole stay is a loop.
            for pair in [(0, 1), (1, 3)] {
                let (fromWhen, from) = frames[pair.0]
                let (toWhen, to) = frames[pair.1]
                let moved = Self.changed(from, to)
                print("GATE_CHANGE {\"room\":\"\(name)\",\"from\":\"\(fromWhen)\","
                      + "\"to\":\"\(toWhen)\"," + String(format: "\"changed\":%.3f}", moved))
                XCTAssertGreaterThan(moved, 0.2,
                                     """
                                     \(name) looks the same at \(fromWhen) and \(toWhen): only \
                                     \(Int(moved * 100))% of the frame moved at all. Design's own \
                                     register is that a room is always visibly changed between \
                                     adaptations, and the second one reverses the premise rather than \
                                     continuing it.
                                     """)
            }
        }
        print("GATE_LOOK_DIR \(directory.path)")
    }

    /// A render as a coarse grid of luminance, which is what "looks different"
    /// can honestly be read as without a human in the room.
    private static func grid(of image: CGImage, side: Int = 48) -> [UInt8] {
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        guard let context = CGContext(data: &pixels, width: side, height: side,
                                      bitsPerComponent: 8, bytesPerRow: side * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return [] }
        context.draw(image, in: CGRect(x: 0, y: 0, width: side, height: side))
        var out = [UInt8]()
        out.reserveCapacity(side * side)
        for index in stride(from: 0, to: pixels.count, by: 4) {
            let red = 0.2126 * Double(pixels[index])
            let green = 0.7152 * Double(pixels[index + 1])
            let blue = 0.0722 * Double(pixels[index + 2])
            out.append(UInt8(min(255.0, red + green + blue)))
        }
        return out
    }

    /// The mean luminance of the **near half** of the frame: the floor the walker
    /// is standing on, which is where a mark that has come toward him lands.
    ///
    /// Read off the drawn image rather than the coarse grid, because the question
    /// is how much light is in one part of the picture rather than how much of it
    /// moved. A bitmap context's first row is the top of the image, so the near
    /// half is the second half of the buffer.
    private static func nearMean(of image: CGImage) -> Double {
        let width = 120, height = 240
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        guard let context = CGContext(data: &pixels, width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: width * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return 0 }
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        var sum = 0.0, count = 0.0
        for row in (height / 2)..<height {
            for column in 0..<width {
                let index = (row * width + column) * 4
                sum += (0.2126 * Double(pixels[index]) + 0.7152 * Double(pixels[index + 1])
                        + 0.0722 * Double(pixels[index + 2])) / 255
                count += 1
            }
        }
        return count > 0 ? sum / count : 0
    }

    /// What fraction of the grid moved, read **relative to how bright it was**.
    ///
    /// An absolute threshold is the wrong instrument here and it said so on its
    /// first run: Garimā's whole frame lives between 3% and 36% of the scale — her
    /// rooms are dark by design, and Design's own reading of this one is
    /// *"13→204"* against a ring that starts near black — so a mass descending the
    /// height of the room moved a twentieth of full range and read as nothing at
    /// all. An eighth of what was there, plus a floor for the parts that were
    /// almost nothing to begin with.
    private static func changed(_ a: [UInt8], _ b: [UInt8]) -> Double {
        let n = min(a.count, b.count)
        guard n > 0 else { return 0 }
        var moved = 0
        for i in 0..<n {
            let before = Double(a[i]), after = Double(b[i])
            if abs(before - after) > 3 + 0.125 * max(before, after) { moved += 1 }
        }
        return Double(moved) / Double(n)
    }
}
