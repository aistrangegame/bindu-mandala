// Measuring apparatus, not part of the app. The whole Spike folder is compiled
// out of Release, so nothing here — including SpikeBench's hiding and restoring of
// the practitioner's own window — can exist in a build that reaches Neev. The test
// action builds Debug, so every spike test still sees it.
#if DEBUG
import Foundation
import SwiftUI

/// A deterministic 102-seat field for the spike bench.
///
/// The bench cannot read the practitioner's real store — a measurement must be
/// reproducible across two simulators and two variants — so it builds the field
/// itself, honouring the shapes the real data has (`the 86 data shape`): every seat
/// carries a ring, a quality and a tattva; most of the 86 carry **no** bīja; every
/// seat outside Ring 2 keeps the `.inner` cluster default that `Atmosphere.derive`
/// is careful never to let leak.
///
/// The two synthetic choices that move the numbers are stated here so no one has to
/// infer them from the code:
///
/// * **Names** are generated from a fixed syllable table to the same 10–16 character
///   length the real Khaḍgamālā names have. Text draws dominate the tier-1/2 frames,
///   so length matters and identity does not.
/// * **Felt counts** — one seat in four (kp % 4 == 1, so 26 of 102) has been felt,
///   with counts cycling 1…6. `felt` decides whether a seat draws its soft glow, so
///   this is the single biggest synthetic lever on the seat-layer primitive count. A
///   field where nobody has been felt draws 26 fewer gradient fills per frame.
struct SpikeField {
    let shaktis: [Shakti]
    let seats: [MandalaWorld.Seat]
    /// The same seats reduced to plain values for the census — built once, because
    /// re-reading 102 SwiftData models per sampled frame is what killed the first
    /// bench run. See `MandalaDrawCensus.SeatSnapshot`.
    let censusSeats: [MandalaDrawCensus.SeatSnapshot]
    let atmos: [Int: Atmosphere]
    /// Who has been felt. A set, not a tally: nothing in the Mandala's render
    /// path is allowed to know how *often*, and the census models that path.
    let felt: Set<Int>
    let todayKp: Int

    /// kp 29 — the first Ring-2 Karṣiṇī, the position the repo's UI tests already
    /// pin with `ENERGY_POS=29`.
    static let defaultTodayKp = 29
    /// kp 53 — the first of the fourteen. Ring 4 gives the bloom a real
    /// constellation (13 threads) and sits near enough the centre that the rest of
    /// the field stays on screen at the fly-to scale.
    static let bloomFocusKp = 53

    init(todayKp: Int = SpikeField.defaultTodayKp, variant: TimeVariant = .night) {
        var built: [Shakti] = []
        built.reserveCapacity(KhadgamalaMap.total)
        for kp in 1...KhadgamalaMap.total {
            built.append(Self.makeShakti(kp: kp))
        }
        self.shaktis = built
        let placed = MandalaWorld.seats(from: built)
        self.seats = placed
        self.censusSeats = MandalaDrawCensus.snapshot(placed)
        var a: [Int: Atmosphere] = [:]
        var f: Set<Int> = []
        for s in built {
            let k = s.khadgamalaPosition ?? s.position
            a[k] = Atmosphere.derive(from: s, at: variant)
            if k % 4 == 1 { f.insert(k) }
        }
        self.atmos = a
        self.felt = f
        self.todayKp = todayKp
    }

    var dayAtmosphere: Atmosphere {
        atmos[todayKp] ?? Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: todayKp, element: .ether)
    }

    /// The family threads that bloom around a focused seat.
    func family(ofKp kp: Int) -> Set<Int> {
        guard let s = shaktis.first(where: { ($0.khadgamalaPosition ?? $0.position) == kp }) else { return [] }
        return Set(MandalaWorld.family(of: s, in: shaktis).map { $0.khadgamalaPosition ?? $0.position })
    }

    func seat(kp: Int) -> MandalaWorld.Seat? {
        seats.first { ($0.shakti.khadgamalaPosition ?? $0.shakti.position) == kp }
    }

    // MARK: - Construction

    private static func makeShakti(kp: Int) -> Shakti {
        let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
        let idx = KhadgamalaMap.perRingIndex(forKhadgamala: kp)
        let name = generatedName(kp: kp)
        // Ring 2 is the only ring whose cluster is real; everyone else keeps the
        // `.inner` default the shipped derive is careful to ignore.
        let cluster: Cluster = ring == 2 ? ringTwoCluster(index: idx) : .inner
        // Most of the 86 carry no bīja: only Ring 2 and the Bindu get one here.
        let bija = (ring == 2 || ring == 9) ? Self.bijas[kp % Self.bijas.count] : ""
        return Shakti(
            position: idx,
            name: name,
            shortName: String(name.prefix(6)),
            phonetic: "",
            quality: "She who draws the \(Self.qualities[kp % Self.qualities.count])",
            qualityDescription: "",
            somatic: "",
            somaticPoetry: "",
            bija: bija,
            bodilyLocation: "",
            tattva: ring == 2 ? Self.tattvas[kp % Self.tattvas.count] : "",
            recognitionPhrase: "",
            cluster: cluster,
            status: .mapped,
            khadgamalaPosition: kp,
            ringNumber: ring)
    }

    private static func ringTwoCluster(index i: Int) -> Cluster {
        switch i {
        case 1...3:   return .inner
        case 4...8:   return .tanmatra
        case 9:       return .citta
        case 10...13: return .stability
        default:      return .selfBody
        }
    }

    /// A deterministic name of the length the real ones have (10–16 characters).
    private static func generatedName(kp: Int) -> String {
        let head = heads[kp % heads.count]
        let mid = mids[(kp / 3) % mids.count]
        let tail = tails[(kp / 5) % tails.count]
        return head + mid + tail
    }

    private static let heads = ["Kā", "Bud", "Ahaṁ", "Śab", "Spar", "Rū", "Ra", "Gan", "Cit", "Dhai", "Smṛ", "Nā", "Bī", "Ātma", "Amṛ", "Śarī"]
    private static let mids = ["mā", "dhya", "kā", "da", "śa", "pa", "sā", "ta", "ma", "rya", "ti"]
    private static let tails = ["karṣiṇī", "kṣobhiṇī", "vaśaṅkarī", "ākarṣiṇī", "mādinī"]
    private static let bijas = ["aṁ", "āṁ", "iṁ", "īṁ", "uṁ", "ūṁ", "eṁ", "aiṁ", "oṁ", "auṁ"]
    private static let qualities = ["mind", "ego", "sound", "touch", "form", "taste", "smell", "will", "memory", "name"]
    private static let tattvas = ["Air (Vāyu)", "Fire (Agni)", "Water (Jala)", "Earth (Pṛthvī)", "Ether (Ākāśa)"]
}
#endif
