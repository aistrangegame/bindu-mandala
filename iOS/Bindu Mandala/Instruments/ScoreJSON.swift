import Foundation

// MARK: - U1 · D · a Score as plain JSON
//
// `score-format-v2.md` §5: the validator reads the document the way the
// Bindu Field's `scripts/batch/validate.py` reads it — as a tree of plain
// values — so a malformed Score is *refused with a reason* rather than failing
// somewhere inside a typed decode. `ScoreV2` (the typed mirror the player
// runs) is decoded only after the tree has passed.
//
// The Scores are live-tunable in Airtable (§7: "edit the JSON in Airtable, and
// the next fetch performs differently. No rebuild"), so nothing here assumes
// a field's type beyond what the format states.

/// Any JSON value (the-33-architecture.md §2 row 61, Layer 2: "the Score in
/// Airtable"). Also the type of the Score sections that are names pointing
/// into a vocabulary module rather than values the player runs (`tiers`,
/// `geometry`, `spatial_memory`, …).
enum ScoreJSON: Codable, Equatable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([ScoreJSON])
    case object([String: ScoreJSON])

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() {
            self = .null
        } else if let b = try? c.decode(Bool.self) {
            self = .bool(b)
        } else if let n = try? c.decode(Double.self) {
            self = .number(n)
        } else if let s = try? c.decode(String.self) {
            self = .string(s)
        } else if let a = try? c.decode([ScoreJSON].self) {
            self = .array(a)
        } else if let o = try? c.decode([String: ScoreJSON].self) {
            self = .object(o)
        } else {
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "not a JSON value")
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .null: try c.encodeNil()
        case .bool(let b): try c.encode(b)
        case .number(let n): try c.encode(n)
        case .string(let s): try c.encode(s)
        case .array(let a): try c.encode(a)
        case .object(let o): try c.encode(o)
        }
    }

    /// Parse a document.
    static func parse(_ data: Data) throws -> ScoreJSON {
        try JSONDecoder().decode(ScoreJSON.self, from: data)
    }

    static func parse(_ text: String) throws -> ScoreJSON {
        try parse(Data(text.utf8))
    }

    // MARK: Reading

    subscript(key: String) -> ScoreJSON? {
        if case .object(let o) = self { return o[key] }
        return nil
    }

    subscript(index: Int) -> ScoreJSON? {
        if case .array(let a) = self, a.indices.contains(index) { return a[index] }
        return nil
    }

    /// A path of keys, nil as soon as one is missing.
    func at(_ keys: String...) -> ScoreJSON? {
        var v: ScoreJSON? = self
        for k in keys { v = v?[k] }
        return v
    }

    var isNull: Bool {
        if case .null = self { return true }
        return false
    }

    var double: Double? {
        if case .number(let n) = self { return n }
        return nil
    }

    var string: String? {
        if case .string(let s) = self { return s }
        return nil
    }

    var bool: Bool? {
        if case .bool(let b) = self { return b }
        return nil
    }

    var array: [ScoreJSON]? {
        if case .array(let a) = self { return a }
        return nil
    }

    var object: [String: ScoreJSON]? {
        if case .object(let o) = self { return o }
        return nil
    }

    /// Present and holding something: not null, not "", not [] and not {}
    /// (validate.py's `v not in (None, [], {})`, with the empty string too).
    var isFilled: Bool {
        switch self {
        case .null: return false
        case .string(let s): return !s.isEmpty
        case .array(let a): return !a.isEmpty
        case .object(let o): return !o.isEmpty
        case .bool, .number: return true
        }
    }
}
