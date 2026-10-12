import Foundation
import CoreGraphics

// MARK: - The 33, at their addresses in the yantra
//
// Wave 3 · The Origin and the 33. The Map (`tblwpmyKOeMxEEHd7`) was realigned
// to the Śrī Yantra on 17 May 2026 (Codex C-1343, C-1344, C-1345): every one of
// the 33 chakras already has an address among the 102. This is that address,
// baked once from the live Map joined to the Mandala table's khaḍgamālā
// positions, and shipped in the bundle as `Data/ChakraConstellation.json`.
//
// **The truth floor.** Every field is the Map's own value, or `null` where the
// Map's cell is empty — nothing is filled in here. The one thing the Map does
// not carry is a khaḍgamālā position, so the bake joins its Shakti Name to the
// Mandala table's seats (or, for a family, to the Mandala's own Shakti Family)
// and writes the reason for every join beside it (`joinedBy`). A presiding
// form that is not one of the 102 (Tripureśī at the crown, Tripura Siddhāmbā
// at Integration) keeps an empty `kp` and lives at the level of its whole ring.
//
// **Places, not a ladder.** The Road order is the order of the walk — centre,
// out to the perimeter, spiralling home — and it is used to move a camera, not
// to number anything on the glass. Nothing here knows what he has done.

/// One of the 33, as the Map holds it.
struct Chakra33: Codable, Identifiable, Equatable {
    /// Book Position on the Map — its place on the Road, 1…33.
    let road: Int
    let recordId: String
    let name: String
    let subtitle: String?
    let sanskrit: String?
    let kind: Kind
    /// The Map's System select (Energy · Body · Mind · Tree of Life).
    let system: String?
    /// The Map's Walker Journey Stage.
    let stage: String?
    /// The Map's Number — its place inside its own section.
    let sectionNumber: Int?
    /// The Map's Avarana select, verbatim (`"n/a"` where the Map says so).
    let avaranaField: String?
    /// Its āvaraṇa, 1…9 — nil for the two thresholds, which live *between* rings.
    let avarana: Int?
    /// The khaḍgamālā positions it is seated at (empty for a whole ring or a threshold).
    let kp: [Int]
    let address: Address
    /// For a threshold, the two rings it stands between, outer first.
    let crossing: [Int]?
    let shaktiName: String?
    let mudra: String?
    let colorHex: String?
    let primaryColor: String?
    let verb: String?
    let activation: String?
    let bija: String?
    let essence: String?
    let bodyLocation: String?
    /// Why this chakra sits at these seats — the bake's join, in words.
    let joinedBy: String?

    // MARK: Wave 6 · the teaching its room carries
    //
    // Re-baked from every field of The Map on 12 Oct 2026. Each is the Map's
    // own cell, verbatim, or absent where the Map's cell is empty — nothing is
    // composed here. All optional (and `var` with a default, so the synthesized
    // decoder reads them with `decodeIfPresent`): a bake from before Wave 6, or
    // one that loses a column, still decodes and the room simply says less.

    /// Core Question — the one line at each place ("Am I safe here?").
    var coreQuestion: String? = nil
    /// Signature Phrase — the seed line ("please come back home.").
    var signaturePhrase: String? = nil
    /// Hero Threshold — the sub-line under the verb.
    var heroThreshold: String? = nil
    /// Practice Prompt — the room's practice.
    var practicePrompt: String? = nil
    /// Three Ways In — three doors into the practice, as the Map writes them.
    var threeWaysIn: String? = nil
    /// Practice Gate Type — Textarea · Sound Response · Device Tilt · Canvas · Tap Rhythm.
    var gateType: String? = nil
    /// Gate Text — the physical instruction before the gate opens (its last
    /// line names the gate's button: "Button: I feel the ground").
    var gateText: String? = nil
    /// Story Thread — the Bindu → Lalitā story at this place.
    var storyThread: String? = nil
    /// Leela Story — what the room says once the gate has been walked.
    var leelaStory: String? = nil
    /// Act 1 Voice / Act 2 Voice — the two-act telling (Act 2 is 10 of 33).
    var act1Voice: String? = nil
    var act2Voice: String? = nil
    /// Bindu Reflection and Witness Perspective — the two further voices.
    var binduReflection: String? = nil
    var witnessPerspective: String? = nil
    /// Writing Prompt / Writing Reflection — the offering, and the line after it.
    var writingPrompt: String? = nil
    var writingReflection: String? = nil
    /// Mirror Frequency Instruction (33) and Mirror Frequency (10) — the wake-up.
    var mirrorFrequencyInstruction: String? = nil
    var mirrorFrequency: String? = nil
    /// Subtle Mirror — its twin at the other density (Soles ↔ Mūlādhāra …).
    var subtleMirror: String? = nil
    /// Voice — whose light speaks here (Gaia · Bindu · Sakshi · Higher Self · Lalita).
    var voice: String? = nil
    /// Codex References — provenance only (4 of 33).
    var codexReferences: String? = nil

    var id: Int { road }

    enum Kind: String, Codable, CaseIterable {
        case bindu, energy, shadow, body, armin, mind, summit
    }

    /// How it is seated: the point, a whole ring, one seat, or between two rings.
    enum Address: String, Codable, CaseIterable {
        case centre, ring, seat, threshold
    }

    var isThreshold: Bool { kind == .shadow || kind == .armin }

    /// Wave 6 · the room's address in the ledger: its own Map record. The
    /// ledger's `Link to The Map` is filled with exactly this.
    var mapRecordId: String { recordId }
}

/// The bake, loaded once, plus the pure geometry of where each chakra stands.
enum ChakraConstellation {

    /// The file the bake writes, bundled with the app (synchronized group).
    static let resourceName = "ChakraConstellation"

    private struct File: Decodable {
        let chakras: [Chakra33]
    }

    /// All 33, in Road order. Empty — never a crash — if the bundle has lost
    /// the file or the file cannot be read.
    static let all: [Chakra33] = load(bundle: .main)

    static func load(bundle: Bundle) -> [Chakra33] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return [] }
        return decode(data)
    }

    /// Defensive decode: a malformed file yields nothing rather than a half-sky.
    static func decode(_ data: Data) -> [Chakra33] {
        guard let file = try? JSONDecoder().decode(File.self, from: data) else { return [] }
        return file.chakras.sorted { $0.road < $1.road }
    }

    // MARK: - The two thresholds

    /// The thresholds a fall from ring `old` to ring `new` passes through,
    /// inward only, outermost first. Falling from 2 to 8 passes both.
    static func thresholdsCrossed(from old: Int, to new: Int,
                                  in chakras: [Chakra33] = all) -> [Chakra33] {
        guard new > old else { return [] }
        return chakras
            .filter { c in
                guard c.isThreshold, let pair = c.crossing, pair.count == 2 else { return false }
                return old <= pair[0] && new >= pair[1]
            }
            .sorted { ($0.crossing?.first ?? 0) < ($1.crossing?.first ?? 0) }
    }

    /// The world radius a threshold is drawn at: halfway between its two rings.
    static func thresholdRadius(_ c: Chakra33) -> CGFloat? {
        guard let pair = c.crossing, pair.count == 2 else { return nil }
        return (MandalaWorld.ringRadius(pair[0]) + MandalaWorld.ringRadius(pair[1])) / 2
    }

    // MARK: - Where a seat stands

    /// How many seats each āvaraṇa holds — the garland's own shape.
    static let ringCounts = [28, 16, 8, 14, 10, 10, 12, 3, 1]

    /// Where `MandalaWorld.seats` puts the seat at `kp` when the whole garland is
    /// present — the same formula, from her position alone. Used when the
    /// roster on the phone is still the sixteen of the first launch, so a
    /// chakra still has somewhere to stand before the sync.
    static func canonicalPoint(kp: Int) -> CGPoint? {
        let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
        guard ring >= 1 else { return nil }
        if ring == 9 { return .zero }
        let n = ringCounts[ring - 1]
        let idx = KhadgamalaMap.perRingIndex(forKhadgamala: kp) - 1
        if ring == 1 {
            return MandalaWorld.squarePerimeter(t: (CGFloat(idx) + 0.5) / CGFloat(n),
                                                half: MandalaWorld.ringRadius(1))
        }
        let a = (CGFloat(idx) / CGFloat(n)) * 2 * .pi - .pi / 2
        let r = MandalaWorld.ringRadius(ring)
        return CGPoint(x: r * cos(a), y: r * sin(a))
    }

    /// The seat's point from the live field when it is there, else the canonical one.
    static func point(kp: Int, seats: [Int: CGPoint]) -> CGPoint? {
        seats[kp] ?? canonicalPoint(kp: kp)
    }

    /// The points a chakra is drawn through, in garland order.
    static func points(of c: Chakra33, seats: [Int: CGPoint]) -> [CGPoint] {
        c.kp.sorted().compactMap { point(kp: $0, seats: seats) }
    }

    // MARK: - Spoken

    private static let ordinals = ["", "first", "second", "third", "fourth", "fifth",
                                   "sixth", "seventh", "eighth", "ninth"]

    static func ordinal(_ ring: Int) -> String {
        (1...9).contains(ring) ? ordinals[ring] : ""
    }

    /// What a voice says of a chakra: its name and subtitle, then where it lives
    /// in the yantra, in words — never a number of his. `seatName` is the Śakti
    /// at its one seat, looked up by position by the caller.
    static func spokenLabel(_ c: Chakra33, seatName: String?) -> String {
        var parts: [String] = [c.name]
        if let s = c.subtitle { parts.append(s) }
        parts.append(spokenPlace(c, seatName: seatName))
        return parts.joined(separator: ". ")
    }

    static func spokenPlace(_ c: Chakra33, seatName: String?) -> String {
        switch c.address {
        case .centre:
            return "at the Bindu, the point at the centre"
        case .threshold:
            guard let pair = c.crossing, pair.count == 2 else { return "a threshold" }
            return "the threshold between the \(ordinal(pair[0])) and \(ordinal(pair[1])) āvaraṇas"
        case .ring:
            let ring = c.avarana.map { ordinal($0) } ?? ""
            return c.kp.isEmpty
                ? "the whole of the \(ring) āvaraṇa"
                : "across the \(ring) āvaraṇa"
        case .seat:
            let ring = c.avarana.map { ordinal($0) } ?? ""
            if let seatName, !seatName.isEmpty {
                return "at \(seatName)'s seat, in the \(ring) āvaraṇa"
            }
            return "at one seat in the \(ring) āvaraṇa"
        }
    }
}
