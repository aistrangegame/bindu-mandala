import Foundation

// MARK: - MandalaVoice — the instrument said aloud
//
// Brief v2 §4.4. The living Mandala is one `Canvas`: the 102 seats and the nine
// enclosures are strokes in a drawing, and a drawing has no accessibility tree.
// Audit §H5 put it plainly — *"the entire canvas Mandala exposes no
// accessibility elements; the 102 seats are invisible to VoiceOver."*
//
// This file is the seam the screen speaks through, and it is deliberately a
// pure function of a `Śakti` and nothing else: no view, no environment, no
// clock. That is what makes it testable over all 102 rows at once, which is the
// only way anybody is ever going to check it — `MandalaVoiceTests` reads the
// shipped bootstrap and asks every row for her label.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT IS SPOKEN, AND WHAT IS NOT
// ─────────────────────────────────────────────────────────────────────────────
//
// **Her name, transliterated — never the diacritics, never the Devanāgarī.**
// `Sparśākarṣiṇī` handed to a speech synthesiser is not a name: `ś`, `ṣ` and `ṇ`
// are not letters an English voice has, so it spells the word out or drops the
// syllables on the floor. Sixteen of the 102 carry a `phonetic` field written
// for exactly this (`Spar · SHAH · kar · shi · nee`); the other 86 do not, and
// the brief says to speak the transliteration we have. So every name goes
// through `romanised(_:)`, which turns IAST into the plain letters that sound
// it: `ś`/`ṣ` → `sh`, `ṛ` → `ri`, `ñ` → `ny`, and the long vowels lose their
// macrons. The Devanāgarī string is never spoken as text at all — the line is
// labelled as *what it is* (`devanagariLabel`), because a voice reading
// `स्पर्शाकर्षिणी` character by character tells a walker nothing.
//
// **Her seat, as a word.** A khaḍgamālā position is identity — the charter's
// first law — and may be spoken. It is spelled out (`twenty-ninth`) rather than
// written as a numeral, because a numeral beside a total is the shape a score
// arrives in, and because "twenty-ninth of the one hundred and two" is what a
// person would actually say.
//
// **Nothing that was counted.** No label here may say how often she has been
// felt, how many times this screen has been opened, or how far along anything
// is. `LawsTests` judges the strings this file composes along with every other
// walker-facing string in the tree, and there is no exception mechanism for a
// practice measure. The one number these labels carry is her place in a garland
// that was fixed before the app existed.

enum MandalaVoice {

    // MARK: - Her name, said out loud

    /// IAST and the other diacritics the base writes, mapped to the plain
    /// letters that sound them.
    ///
    /// Pinned as an explicit table rather than a `stripDiacritics` transform,
    /// because stripping is wrong in the cases that matter most: it turns `ś`
    /// into `s` (*Sparsakarsini*), and the sibilants are half of what these
    /// names sound like. Anything left carrying a combining mark after this
    /// table has run is folded by `stripping(_:)` as a backstop, so a character
    /// nobody anticipated degrades to a plain letter instead of reaching a
    /// voice intact.
    static let romanisation: [Character: String] = [
        "ā": "a",  "Ā": "A",
        "ī": "i",  "Ī": "I",
        "ū": "u",  "Ū": "U",
        "ṛ": "ri", "Ṛ": "Ri",
        "ṝ": "ri", "Ṝ": "Ri",
        "ḷ": "li", "Ḷ": "Li",
        "ḹ": "li", "Ḹ": "Li",
        "ē": "e",  "Ē": "E",
        "ō": "o",  "Ō": "O",
        "ś": "sh", "Ś": "Sh",
        "ṣ": "sh", "Ṣ": "Sh",
        "ṭ": "t",  "Ṭ": "T",
        "ḍ": "d",  "Ḍ": "D",
        "ṇ": "n",  "Ṇ": "N",
        "ṅ": "n",  "Ṅ": "N",
        "ñ": "ny", "Ñ": "Ny",
        "ṃ": "m",  "Ṃ": "M",
        "ṁ": "m",  "Ṁ": "M",
        "ḥ": "h",  "Ḥ": "H",
        "ṉ": "n",  "Ṉ": "N",
        "ṟ": "r",  "Ṟ": "R",
        "ḻ": "l",  "Ḻ": "L",
    ]

    /// True for a character in the Devanāgarī block. The block, not a guess at a
    /// language: a string is either written in it or it is not.
    static func isDevanagari(_ c: Character) -> Bool {
        c.unicodeScalars.contains { $0.value >= 0x0900 && $0.value <= 0x097F }
    }

    /// Whether a string is written in Devanāgarī at all — one such character is
    /// enough, because a voice reading the rest of the line still stops dead at
    /// that one.
    static func containsDevanagari(_ s: String) -> Bool {
        s.contains(where: isDevanagari)
    }

    /// The plain letters that sound a diacritic name. Devanāgarī is dropped
    /// rather than transliterated — this function's job is to make a Latin
    /// string speakable, and a script it does not read is better absent than
    /// spelled.
    static func romanised(_ raw: String) -> String {
        var out = ""
        for ch in raw.precomposedStringWithCanonicalMapping {
            if let mapped = romanisation[ch] { out += mapped }
            else if isDevanagari(ch) { continue }
            else { out.append(ch) }
        }
        return stripping(collapsingSpaces(out))
    }

    /// Any combining mark this table did not name, removed. The backstop, never
    /// the mechanism.
    static func stripping(_ s: String) -> String {
        String(String.UnicodeScalarView(s.unicodeScalars.filter { scalar in
            !(scalar.value >= 0x0300 && scalar.value <= 0x036F)
        }))
    }

    static func collapsingSpaces(_ s: String) -> String {
        s.split(whereSeparator: { $0 == " " || $0 == "\t" || $0 == "\n" })
            .joined(separator: " ")
    }

    /// A `phonetic` field made speakable. The field is written for the eye —
    /// `Spar · SHAH · kar · shi · nee` — and two things in it are wrong for an
    /// ear. The middle dots are read out as punctuation by some voices and as
    /// nothing by others, so they become spaces. And a syllable in full capitals
    /// is a stress mark to a reader and an **acronym** to a synthesiser, which
    /// spells it: `KAH` comes out *K-A-H*. Each such syllable is set in title
    /// case, which keeps the word and loses the spelling.
    static func speakablePhonetic(_ raw: String) -> String {
        let pieces = raw
            .replacingOccurrences(of: "·", with: " ")
            .replacingOccurrences(of: "•", with: " ")
            .replacingOccurrences(of: "–", with: " ")
            .replacingOccurrences(of: "—", with: " ")
            .split(whereSeparator: { $0 == " " || $0 == "\t" || $0 == "\n" })
            .map(String.init)
        let said = pieces.map { piece -> String in
            let letters = piece.filter { $0.isLetter }
            guard letters.count > 1, letters.allSatisfy({ $0.isUppercase }) else { return piece }
            return piece.prefix(1) + piece.dropFirst().lowercased()
        }
        return romanised(said.joined(separator: " "))
    }

    /// Her name as a voice should say it: her phonetic when the base carries one,
    /// otherwise the transliteration of her name. Never empty for a row that has
    /// a name — and for a row that has neither, the caller gets her seat instead,
    /// because an unnamed element is an element a walker cannot find again.
    static func spokenName(for shakti: Shakti) -> String {
        let phonetic = shakti.phonetic.trimmingCharacters(in: .whitespacesAndNewlines)
        if !phonetic.isEmpty, !containsDevanagari(phonetic) {
            let said = speakablePhonetic(phonetic)
            if !said.isEmpty { return said }
        }
        let name = romanised(shakti.name.trimmingCharacters(in: .whitespacesAndNewlines))
        if !name.isEmpty { return name }
        let short = romanised(shakti.shortName.trimmingCharacters(in: .whitespacesAndNewlines))
        if !short.isEmpty { return short }
        return "\(ordinal(seat(of: shakti)).capitalizedFirst) seat"
    }

    // MARK: - Numbers as words

    private static let ones = ["", "one", "two", "three", "four", "five", "six", "seven",
                               "eight", "nine", "ten", "eleven", "twelve", "thirteen",
                               "fourteen", "fifteen", "sixteen", "seventeen", "eighteen",
                               "nineteen"]
    private static let tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty",
                               "seventy", "eighty", "ninety"]
    private static let onesOrdinal = ["", "first", "second", "third", "fourth", "fifth",
                                      "sixth", "seventh", "eighth", "ninth", "tenth",
                                      "eleventh", "twelfth", "thirteenth", "fourteenth",
                                      "fifteenth", "sixteenth", "seventeenth", "eighteenth",
                                      "nineteenth"]
    private static let tensOrdinal = ["", "", "twentieth", "thirtieth", "fortieth",
                                      "fiftieth", "sixtieth", "seventieth", "eightieth",
                                      "ninetieth"]

    /// `29` → `"twenty-nine"`. Enough of English for a garland of 102 and no
    /// more: the instrument has no larger number to say.
    static func cardinal(_ n: Int) -> String {
        guard n > 0, n < 1000 else { return String(n) }
        if n >= 100 {
            let rest = n % 100
            let head = "\(ones[n / 100]) hundred"
            return rest == 0 ? head : "\(head) and \(cardinal(rest))"
        }
        if n < 20 { return ones[n] }
        let unit = n % 10
        return unit == 0 ? tens[n / 10] : "\(tens[n / 10])-\(ones[unit])"
    }

    /// `29` → `"twenty-ninth"`. Spelled, never a numeral: a numeral sitting
    /// beside a total is the shape every score arrives in, and her seat is not
    /// one. `LawsTests` draws that line; this keeps the strings on the right
    /// side of it without needing the exception.
    static func ordinal(_ n: Int) -> String {
        guard n > 0, n < 1000 else { return String(n) }
        if n >= 100 {
            let rest = n % 100
            return rest == 0 ? "\(ones[n / 100]) hundredth"
                             : "\(ones[n / 100]) hundred and \(ordinal(rest))"
        }
        if n < 20 { return onesOrdinal[n] }
        let unit = n % 10
        return unit == 0 ? tensOrdinal[n / 10] : "\(tens[n / 10])-\(onesOrdinal[unit])"
    }

    // MARK: - The garland, and the nine enclosures

    /// Her khaḍgamālā position — identity, and the only key (charter §2.1).
    static func seat(of shakti: Shakti) -> Int {
        shakti.khadgamalaPosition ?? shakti.position
    }

    static func ring(of shakti: Shakti) -> Int {
        shakti.ringNumber ?? 2
    }

    /// The invariant Śrī-Yantra enclosure forms, said rather than drawn. The
    /// drawn strip in `MandalaCanvasLayer` writes `16-Petal Lotus`; a voice
    /// given that says "sixteen dash petal" or "sixteen hyphen petal", so the
    /// spoken forms are their own pinned table, with the diacritics romanised
    /// here for the same reason her name is.
    static let enclosureForms = [
        "", "the earth square", "sixteen-petal lotus", "eight-petal lotus",
        "fourteen triangles", "ten outer triangles", "ten inner triangles",
        "eight triangles", "the root triangle", "the bindu",
    ]

    /// What the ninth enclosure is, in the instrument's own words. Ring 9 holds
    /// one seat and the whole yantra breathes out of it, so it is named rather
    /// than counted.
    static func enclosureLabel(ring: Int) -> String {
        guard ring >= 1, ring < enclosureForms.count else { return "An enclosure" }
        return "\(ordinal(ring).capitalizedFirst) enclosure. \(enclosureForms[ring].capitalizedFirst)."
    }

    // MARK: - The labels the screen actually speaks

    /// One seat on the living Mandala: who she is, what she draws, and where in
    /// the garland she sits. Three sentences, in that order, because VoiceOver
    /// reads a label straight through and a walker swiping across a ring wants
    /// her name first and the furniture last.
    static func seatLabel(for shakti: Shakti) -> String {
        var parts = [spokenName(for: shakti)]
        let quality = romanised(shakti.quality.trimmingCharacters(in: .whitespacesAndNewlines))
        if !quality.isEmpty { parts.append(quality) }
        parts.append("\(ordinal(ring(of: shakti)).capitalizedFirst) enclosure, "
                     + "\(ordinal(seat(of: shakti))) of the one hundred and two")
        return parts.joined(separator: ". ") + "."
    }

    /// What happens when this seat is activated. The Mandala's own gesture:
    /// the first tap flies to her and opens her significance, the second opens
    /// her full presence — so the hint says both, since a VoiceOver walker
    /// cannot see the card arrive and infer the rest.
    static func seatHint(for shakti: Shakti) -> String {
        ring(of: shakti) == 9
            ? "Opens the source."
            : "Opens her significance. Activate again for her full presence."
    }

    /// What a seat says and what activating it does, composed once.
    ///
    /// The living Mandala rebuilds its whole layer on every camera change — a
    /// drag is sixty of them a second — and romanising a hundred and two names
    /// inside that is a hundred and two string walks per frame. The host builds
    /// these when the *field* changes, beside the atmospheres it already
    /// precomputes for the same reason, and the layer does geometry and nothing
    /// else.
    struct Spoken: Equatable {
        let label: String
        let hint: String
    }

    static func spoken(for shakti: Shakti) -> Spoken {
        Spoken(label: seatLabel(for: shakti), hint: seatHint(for: shakti))
    }

    /// The Devanāgarī line, labelled as what it is. The string itself is never
    /// handed to a voice — that is the whole point of the line having a label.
    static let devanagariLabel = "Her name written in Devanagari."

    /// The ceremony's tap-anywhere exit, and the Bindu's. A screen a walker
    /// leaves by touching any part of it gives a sighted walker a whole screen
    /// of target and a VoiceOver walker nothing at all.
    static let closeCeremony = "Close this moment and return."
    static let enterFromHomecoming = "Enter the instrument."
}

extension String {
    /// First letter up, the rest left exactly as written — `capitalized` would
    /// take `sixteen-petal lotus` to `Sixteen-Petal Lotus` and a name like
    /// `Sparshakarshini` is not ours to re-case either.
    var capitalizedFirst: String {
        guard let first else { return self }
        return String(first).uppercased() + dropFirst()
    }
}
