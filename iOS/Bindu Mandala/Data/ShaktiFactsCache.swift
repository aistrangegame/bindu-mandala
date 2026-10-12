import Foundation

// MARK: - Wave 6 · her extras, read live and held beside the store

/// What the base now says about one Śakti beyond the model's own columns:
/// her live **Score** (`fldz1vCCMpXiw8s1n`), her **Phonetic**
/// (`fldadDCi4OJYEaAFX`), her **Seed Verb** (`fldVgkRZmbc7STB7S`), and her
/// **Related Shaktis** (`fldQNnFoom72Nr6vh` + its reverse `fldtAau1NIP4QDZrk`)
/// resolved to positions at sync time.
///
/// **Why beside the store.** Exactly `RingFactsCache`'s reason: read-only
/// catalog values re-fetched on every sync and never written by him. New
/// stored properties on `Shakti` would change a shipped schema; a small JSON
/// in UserDefaults carries them with no migration. When it is empty (first
/// launch), every reader falls back to what it did before — the bundled
/// phonetic, the grammar's own light, the two garland doors.
enum ShaktiFactsCache {

    struct Facts: Codable, Equatable {
        /// The raw Score JSON as the base holds it (decoded on read, so a fix
        /// in the base needs no rebuild).
        var scoreJSON: String? = nil
        var phonetic: String? = nil
        var seedVerb: String? = nil
        /// Related Śaktis, by position (record links resolved at sync).
        var related: [Int]? = nil
    }

    static let defaultsKey = "shaktiFacts.v1"

    private static var defaults: UserDefaults { .standard }

    static func storeAll(_ all: [Int: Facts]) {
        var out: [String: Facts] = [:]
        for (kp, f) in all where (1...KhadgamalaMap.total).contains(kp) { out[String(kp)] = f }
        if let data = try? JSONEncoder().encode(out) {
            defaults.set(data, forKey: defaultsKey)
        }
    }

    static func facts(_ kp: Int) -> Facts? {
        loadAll()[String(kp)]
    }

    static func score(_ kp: Int) -> ShaktiScore? {
        guard let raw = facts(kp)?.scoreJSON else { return nil }
        return ShaktiScore.decode(raw)
    }

    static func seedVerb(_ kp: Int) -> String? {
        let t = facts(kp)?.seedVerb?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return t.isEmpty ? nil : t
    }

    /// Her sister across the rings — the third neighbour door — found by
    /// position alone, never by name: her first related seat, her row's own
    /// links (`Related Shaktis`, in the base's order) before the links other
    /// rows make to her. The base lists the namesake first — Sarva-Ākarṣiṇī
    /// the Devī (55) links her Mudrā (21) before the sixteen Karṣiṇīs — so
    /// every namesake pair (19↔53 … 23↔62) meets, and a Karṣiṇī's door opens
    /// to the Devī who draws all sixteen.
    static func sister(of kp: Int) -> Int? {
        sister(of: kp, related: { facts($0)?.related ?? [] })
    }

    /// The same rule over any related-map — pure, for the suite.
    static func sister(of kp: Int, related: (Int) -> [Int]) -> Int? {
        related(kp).first { $0 != kp }
    }

    private static func loadAll() -> [String: Facts] {
        guard let data = defaults.data(forKey: defaultsKey),
              let all = try? JSONDecoder().decode([String: Facts].self, from: data) else { return [:] }
        return all
    }
}

// MARK: - Her Score

/// A live, tunable Score for one Śakti's room — the Mandala's own form of
/// Bindu Field's Score layer (Universal Substrate · **Score** · Vocabulary).
/// The parameters describe *her room*, never him. Decoded tolerantly: a key in
/// snake or camel case, a number written as a string, a hue as degrees or a
/// hex colour. Anything it cannot read is simply absent, and the grammar
/// stands where the Score says nothing. A Score that is not JSON at all is no
/// Score (`decode` returns nil) — the room is the grammar's, whole.
///
///     {
///       "light": { "hue": 28, "glow": 0.8, "color": "#E8A040" },
///       "tempo": { "breath": 9, "rate": 0.8 },
///       "sound": { "carrier_hz": 136.1, "fifth": "ground", "ground": 0.6 }
///     }
struct ShaktiScore: Equatable {

    struct Light: Equatable {
        /// Hue in degrees, 0–360.
        var hue: Double? = nil
        /// How much light stands in her air, 0–1.
        var glow: Double? = nil
    }

    struct Tempo: Equatable {
        /// Her breath, in seconds — read through the one breath clock.
        var breath: Double? = nil
        /// A multiple of the grammar's own pace (0.25–4).
        var rate: Double? = nil
    }

    struct Sound: Equatable {
        enum Fifth: String, Equatable {
            /// The grammar's own: withheld, granted after dwelling.
            case withheld
            /// Granted from the first beat.
            case granted
            /// Offered only as ground (Field's absent-fifth law), never above.
            case ground
        }
        /// Her carrier, Hz — overrides the bīja-derived carrier.
        var carrierHz: Double? = nil
        var fifth: Fifth? = nil
        /// The ground fifth's level, 0–1 of its own ceiling.
        var ground: Double? = nil
    }

    var light = Light()
    var breathing = Tempo()
    var sound = Sound()

    var isEmpty: Bool { self == ShaktiScore() }

    static func decode(_ raw: String) -> ShaktiScore? {
        guard let data = raw.trimmingCharacters(in: .whitespacesAndNewlines).data(using: .utf8),
              let any = try? JSONSerialization.jsonObject(with: data),
              let root = any as? [String: Any] else { return nil }
        var s = ShaktiScore()

        if let l = section(root, "light") {
            if let h = number(l, ["hue", "hue_deg", "hueDeg"]) {
                let r = h.truncatingRemainder(dividingBy: 360)
                s.light.hue = r < 0 ? r + 360 : r
            } else if let hex = string(l, ["color", "colour", "hex"]), let h = hue(ofHex: hex) {
                s.light.hue = h
            }
            if let g = number(l, ["glow", "intensity", "brightness"]) { s.light.glow = clamp(g, 0, 1) }
        }
        if let t = section(root, "tempo") {
            if let b = number(t, ["breath", "breath_s", "breathSeconds", "period"]), b > 0 {
                s.breathing.breath = clamp(b, 2, 60)
            }
            if let r = number(t, ["rate", "multiplier", "pace"]), r > 0 { s.breathing.rate = clamp(r, 0.25, 4) }
        }
        if let so = section(root, "sound") {
            if let hz = number(so, ["carrier_hz", "carrierHz", "carrier", "hz"]), hz > 20, hz < 2000 {
                s.sound.carrierHz = hz
            }
            if let f = string(so, ["fifth", "fifth_mode", "fifthMode"])?.lowercased() {
                switch f {
                case "granted", "present", "given": s.sound.fifth = .granted
                case "ground", "absent", "absent_fifth", "inverse": s.sound.fifth = .ground
                case "withheld", "earned": s.sound.fifth = .withheld
                default: break
                }
            }
            if let g = number(so, ["ground", "ground_level", "groundLevel"]) { s.sound.ground = clamp(g, 0, 1) }
        }
        return s
    }

    // MARK: Tolerant readers

    private static func section(_ root: [String: Any], _ key: String) -> [String: Any]? {
        if let d = root[key] as? [String: Any] { return d }
        if let d = root[key.capitalized] as? [String: Any] { return d }
        return nil
    }

    private static func number(_ d: [String: Any], _ keys: [String]) -> Double? {
        for k in keys {
            if let n = d[k] as? NSNumber { return n.doubleValue }
            if let str = d[k] as? String, let n = Double(str.trimmingCharacters(in: .whitespaces)) { return n }
        }
        return nil
    }

    private static func string(_ d: [String: Any], _ keys: [String]) -> String? {
        for k in keys {
            if let s = d[k] as? String, !s.isEmpty { return s }
        }
        return nil
    }

    static func clamp(_ x: Double, _ lo: Double, _ hi: Double) -> Double { min(hi, max(lo, x)) }

    /// The hue (degrees) of a `#RRGGBB` colour.
    static func hue(ofHex hex: String) -> Double? {
        var h = hex.trimmingCharacters(in: .whitespaces)
        if h.hasPrefix("#") { h.removeFirst() }
        guard h.count == 6, let v = UInt32(h, radix: 16) else { return nil }
        let r = Double((v >> 16) & 0xFF) / 255
        let g = Double((v >> 8) & 0xFF) / 255
        let b = Double(v & 0xFF) / 255
        let mx = max(r, g, b), mn = min(r, g, b), d = mx - mn
        guard d > 0 else { return 0 }
        var deg: Double
        if mx == r { deg = 60 * (((g - b) / d).truncatingRemainder(dividingBy: 6)) }
        else if mx == g { deg = 60 * ((b - r) / d + 2) }
        else { deg = 60 * ((r - g) / d + 4) }
        if deg < 0 { deg += 360 }
        return deg
    }
}
