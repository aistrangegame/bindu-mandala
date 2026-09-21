import Foundation

// MARK: - The rite of entering — the ceremony, with nothing drawn
//
// Build Brief v2 §3.1, handoff §4.5, and the thread: *"The rite IS the distance.
// Entering her is not a screen — the three beats happen while you cross toward
// her, in three self-paced surges of travel."* This file is the ceremony as
// arithmetic; `RiteOfEnteringView` is the only thing that draws it, and
// ``RoomApproach`` is the crossing it is folded into.
//
// It is the first thing the walker feels every time he enters, a hundred and
// two rooms deep, so every number in it is Design's — read out of the working
// instrument (`The Homes - The Axis.html`: `STATION`, `beginEnter`,
// `advanceRite`, and the `mode === 'rite'` branch of its frame loop) rather
// than chosen here. There are exactly three departures, each named where it
// happens: ``promptAlpha`` and the prompt's type size, both of which sit at
// `iOS/FIDELITY.md`'s legibility floor rather than below it, and the absence of
// Design's beat indicator, which is a progress readout.
//
// ─────────────────────────────────────────────────────────────────────────────
// TWO LAWS MEET HERE, AND THEY PULL IN OPPOSITE DIRECTIONS
// ─────────────────────────────────────────────────────────────────────────────
//
// **The ceremony compresses on a return, and never skips.** Charter §2.2, and
// the brief says it twice. ``HomeMemory/compression(visits:)`` gives `1` on a
// first meeting, then `0.68`, `0.46`, and a floor of `0.36` — and that number
// scales *how long each beat takes to write*, never how many beats there are.
// Three beats happen on the first visit and three happen on the four-hundredth.
// `RiteOfEnteringTests` asserts it at every compression down to the floor.
//
// **And nothing about the compression may be said out loud.** The same law's
// other half: no count, no visit number, no progress, no beat indicator, and no
// "welcome back". The compression is *felt* — the ceremony is simply quicker —
// and the walker is never told why. So this file composes no sentence of its
// own about him: the only words it can put on a screen are hers, off her row,
// plus the two prompts below.
//
// The one line Design offers in the other direction — *the Axis's status-bar
// note on arriving somewhere already known* — is deliberately **not built**.
// It is one bit of the practice record, read aloud; the charter's restraint
// clause settles it, and `DECISIONS.md` carries the reasoning. What replaces it
// is the thing it was describing: a quicker ceremony and a room that opens
// where his dwell has earned (``HomeMemory/headStart(dwell:)``). The felt fact,
// not the announcement of it.

// MARK: - The three beats

/// What is written at one beat of the rite. Design's own order, and it is an
/// order of increasing intimacy: her gratitude, her name, and then her name
/// taken apart into what it is made of.
enum RiteBeat: Int, CaseIterable, Equatable {
    /// Her āvaraṇa's appreciation phrase, arriving out of nothing.
    case phrase = 1
    /// Her Devanāgarī, written stroke by stroke by an unseen hand.
    case written = 2
    /// Her name opened into its true compound parts, splitting and rejoining,
    /// with her quality beneath.
    case roots = 3
}

/// The words at the threshold: the prompt, and nothing else this file authors.
///
/// Verbatim from Design. Note what they do **not** say: not "continue", which
/// would be a step in a sequence, and not "begin", which would be a start he
/// has already made. Touch, and go on.
enum RitePrompt: Equatable {
    case goOn
    case enter

    var words: String {
        switch self {
        case .goOn:  return "touch to go on"
        case .enter: return "touch to enter"
        }
    }
}

// MARK: - The ceremony

/// One crossing to one room: three beats, touch-paced, compressed on a return,
/// and folded into the travel toward her.
struct RiteOfEntering: Equatable {

    // MARK: · Design's stations and durations

    /// Where each beat leaves the walker on his crossing. `STATION` in the Axis.
    /// The rite's whole shape is here: the first touch has carried him a third
    /// of the way, the last stretch is short, and the beats are not evenly
    /// spaced because an approach does not feel evenly spaced.
    static let stations: [Double] = [0, 0.3, 0.62, 0.88, 1]

    /// How long one beat takes to write itself, before her memory compresses it.
    /// Design's `(reduced ? 3.4 : 2.4)`.
    static let writingSeconds: TimeInterval = 2.4
    static let reducedWritingSeconds: TimeInterval = 3.4

    /// Her phrase is fully present a third of the way through its beat.
    static let phraseArrivesOver: Double = 0.34
    /// …and stands just short of full white. Design's `0.94`.
    static let phraseAlpha: Double = 0.94

    /// Her name is written in **three** masked segments, each of which eases
    /// across and then holds — an unseen hand lifting between strokes. Design's
    /// `seg = bp * 3` with `eased = w < 0.72 ? w / 0.72 : 1`.
    static let strokes = 3
    static let strokeHold: Double = 0.72

    /// Her roots are apart by the time the beat is three-fifths through, and
    /// back together by its end. Design's `split` and `join`.
    static let rootsPartOver: Double = 0.58
    static let rootsRejoinFrom: Double = 0.52
    static let rootsRejoinOver: Double = 0.48

    /// Her quality arrives under the roots in the beat's last two-fifths.
    static let glossArrivesFrom: Double = 0.6
    static let glossArrivesOver: Double = 0.4
    static let glossAlpha: Double = 0.6

    /// The prompt waits until the beat has finished writing. Design's `0.99`,
    /// which is the exponential's way of saying *when it is done*.
    static let promptWaitsUntil: Double = 0.99

    /// **The one number here that is not Design's.** The Axis shows its prompt
    /// at `0.44` alpha; `iOS/FIDELITY.md` §4 sets the legibility floor for
    /// meaningful text at ~0.5, and the charter names FIDELITY as standing law.
    /// The prompt is the only instruction in the ceremony, so it is meaningful
    /// text by any reading, and it sits at the floor rather than below it.
    static let promptAlpha: Double = 0.55

    // MARK: · Where the ceremony stands

    enum Stage: Equatable {
        /// Writing one of the three. `1`, `2`, `3` — never shown, only lived.
        case beat(RiteBeat)
        /// The third touch has been given: the last stretch of the crossing.
        case crossing
        /// He is in the room.
        case inside
    }

    /// Her ceremony's compression, **read** from ``HomeMemoryStore`` and never
    /// recomputed here. Clamped into Design's own range, so a caller that hands
    /// this a nonsense number gets the floor rather than a ceremony that
    /// vanishes.
    let compression: Double

    /// Where her room opens on the chamber clock when the crossing ends —
    /// ``HomeMemory/headStart(dwell:)``, read from the store like the
    /// compression. `0` for a room never stood in.
    let headStart: TimeInterval

    /// Whether this walker's device is carrying motion at all.
    ///
    /// **Not `let`, and that is the whole of a real defect.** A ceremony is made
    /// before its view is in the environment, so the flag it is constructed with
    /// is not necessarily the one the view branches on — see ``adopt(reduceMotion:at:)``.
    private(set) var reduceMotion: Bool

    private(set) var stage: Stage
    /// When the current stage opened, on the reference-date clock.
    private(set) var stageOpenedAt: TimeInterval
    /// The walker's distance, as a closed form.
    private(set) var approach: RoomApproach
    /// Every beat that has landed, in order — what the ceremony has asked the
    /// instrument to strike. It is the ceremony's record, never the walker's,
    /// and it reaches no screen.
    private(set) var struck: [RiteBeat]

    // MARK: · Opening

    /// The crossing begins. Design's `beginEnter`: the walker is set at the far
    /// end, the first beat opens, and its tone lands at once.
    init(compression: Double,
         headStart: TimeInterval = 0,
         reduceMotion: Bool = false,
         now: TimeInterval = Date().timeIntervalSinceReferenceDate) {
        self.compression = Self.clampedCompression(compression)
        self.headStart = max(0, headStart)
        self.reduceMotion = reduceMotion
        self.stage = .beat(.phrase)
        self.stageOpenedAt = now
        self.approach = RoomApproach.crossing(from: Self.stations[0],
                                              to: Self.stations[1],
                                              at: now,
                                              reduceMotion: reduceMotion)
        self.struck = [.phrase]
    }

    /// The crossing to one room, with her memory read rather than recomputed.
    ///
    /// This is the only door a screen should use: the compression and the head
    /// start are the store's to give, and a view that worked either of them out
    /// for itself would be a second copy of Design's numbers waiting to drift.
    @MainActor
    static func toRoom(at khadgamalaPosition: Int,
                       remembering store: HomeMemoryStore,
                       reduceMotion: Bool = false,
                       now: TimeInterval = Date().timeIntervalSinceReferenceDate) -> RiteOfEntering {
        RiteOfEntering(compression: store.compression(for: khadgamalaPosition),
                       headStart: store.headStart(for: khadgamalaPosition),
                       reduceMotion: reduceMotion,
                       now: now)
    }

    /// Design's floor, applied to whatever a caller hands over. The ceremony
    /// never becomes shorter than ``HomeMemory/compressionFloor`` and never
    /// longer than the whole of it.
    static func clampedCompression(_ raw: Double) -> Double {
        guard raw.isFinite else { return 1 }
        return min(1, max(HomeMemory.compressionFloor, raw))
    }

    /// Adopt the motion setting the walker's device is actually carrying.
    ///
    /// **The two flags have to be one flag, and this is where they are made
    /// one.** ``RiteOfEnteringView`` branches its rendering on
    /// `forceReduceMotion || the environment`, while the ceremony can only be
    /// constructed with the first of those — a `View`'s `init` is not in the
    /// environment yet. So a walker with the system's own Reduce Motion switched
    /// on used to get the **still** rendering path — one evaluation, no timeline
    /// — driving an **animated** ceremony. That single evaluation lands at the
    /// instant the beat opened: her phrase at nothing, her Devanāgarī wholly
    /// masked, her roots at nothing, and `frame.prompt` still `nil` because the
    /// beat has not finished writing. Nothing re-renders, so it stays that way,
    /// and a touch only reproduces it for the next beat. A wordless, promptless
    /// threshold, at every one of the 102 doors.
    ///
    /// Turning it on settles the ceremony where the still path expects to find
    /// it: the beat is written (``writing(at:)``), and the walker **steps** to
    /// his station rather than easing toward it on a loop that is not running.
    /// Those are the same two facts `crossing` and `releasing` already carry;
    /// this applies them to a ceremony that has already begun.
    mutating func adopt(reduceMotion on: Bool,
                        at now: TimeInterval = Date().timeIntervalSinceReferenceDate) {
        guard on != reduceMotion else { return }
        reduceMotion = on
        switch stage {
        case .beat:
            approach = on
                ? .standing(at: approach.to)
                : RoomApproach.crossing(from: approach.value(at: now), to: approach.to,
                                        at: now, reduceMotion: false)
            // Turning it back on mid-beat needs no clock at all — a beat under
            // reduced motion is written the moment it opens. Turning it off
            // does: the beat writes itself from here rather than from an
            // instant that has already passed.
            if !on { stageOpenedAt = now }
        case .crossing:
            approach = on
                ? .arrived
                : RoomApproach.releasing(from: approach.value(at: now), at: now, reduceMotion: false)
        case .inside:
            break
        }
    }

    // MARK: · The beat's own clock

    /// How long one beat takes to write, with her memory's compression applied.
    ///
    /// **This is the whole of what a return changes.** It is a duration, never a
    /// count: the floor of `0.36` makes the ceremony a little over a third as
    /// long to write and exactly as long in beats.
    var writingDuration: TimeInterval {
        (reduceMotion ? Self.reducedWritingSeconds : Self.writingSeconds) * compression
    }

    /// How far the current beat has written itself, `0…1`. Design's `bp`.
    ///
    /// Under reduced motion a beat is **already written** the moment it opens.
    /// FIDELITY forbids the loop the writing would need, and the render spine
    /// took the same reading for the room itself: the walker is handed the
    /// outcome — her phrase present, her name whole, her roots rejoined — rather
    /// than nothing. All three beats still happen, and each still waits for his
    /// touch.
    func writing(at now: TimeInterval) -> Double {
        guard !reduceMotion else { return 1 }
        guard writingDuration > 0 else { return 1 }
        return Self.clamp01((now - stageOpenedAt) / writingDuration)
    }

    // MARK: · The touch

    /// He touches. The beat that lands is returned, so its tone can be struck;
    /// `nil` when the touch was the third one and what it began was the last
    /// stretch of the crossing.
    ///
    /// **Touch-paced, never timed.** Nothing here consults the clock to decide
    /// whether he may go on: a beat that has not finished writing advances on a
    /// touch, and a beat that finished an hour ago waits for one. Design says it
    /// plainly — *"Nothing advances on a timer, and nothing is ever skipped."*
    @discardableResult
    mutating func touch(at now: TimeInterval = Date().timeIntervalSinceReferenceDate) -> RiteBeat? {
        guard case .beat(let beat) = stage else { return nil }

        guard let next = RiteBeat(rawValue: beat.rawValue + 1) else {
            // The third touch: what is left of the distance, and no more words.
            stage = .crossing
            stageOpenedAt = now
            approach = RoomApproach.releasing(from: approach.value(at: now),
                                              at: now,
                                              reduceMotion: reduceMotion)
            return nil
        }

        stage = .beat(next)
        stageOpenedAt = now
        approach = RoomApproach.crossing(from: approach.value(at: now),
                                         to: Self.stations[next.rawValue],
                                         at: now,
                                         reduceMotion: reduceMotion)
        struck.append(next)
        return next
    }

    /// How long the last stretch takes, once he has given the third touch.
    /// `nil` before then, and `0` under reduced motion, where he is simply in.
    func crossingDuration(at now: TimeInterval = Date().timeIntervalSinceReferenceDate)
        -> TimeInterval? {
        guard case .crossing = stage else { return nil }
        return approach.duration ?? 0
    }

    /// The crossing is over and he is in the room.
    mutating func arrive(at now: TimeInterval = Date().timeIntervalSinceReferenceDate) {
        guard case .crossing = stage else { return }
        stage = .inside
        stageOpenedAt = now
        approach = .arrived
    }

    /// Whether the rite is still between him and the room.
    var isCeremonial: Bool {
        if case .inside = stage { return false }
        return true
    }

    // MARK: · What the walker is given, at one instant

    /// Everything the view draws, as numbers.
    ///
    /// The view is a renderer of this and holds no timing of its own, which is
    /// what lets the tests judge what the walker actually sees rather than what
    /// the ceremony intended.
    func frame(at now: TimeInterval = Date().timeIntervalSinceReferenceDate) -> RiteFrame {
        let travelled = approach.value(at: now)
        guard case .beat(let beat) = stage else {
            return RiteFrame(beat: nil, writing: 1, phrase: 0, revealed: 0,
                             rootGap: 0, gloss: 0, prompt: nil, travelled: travelled)
        }
        let bp = writing(at: now)
        let prompt: RitePrompt? = bp >= Self.promptWaitsUntil
            ? (beat == .roots ? .enter : .goOn)
            : nil

        switch beat {
        case .phrase:
            return RiteFrame(beat: beat,
                             writing: bp,
                             phrase: Self.clamp01(bp / Self.phraseArrivesOver) * Self.phraseAlpha,
                             revealed: 0, rootGap: 0, gloss: 0,
                             prompt: prompt, travelled: travelled)
        case .written:
            return RiteFrame(beat: beat,
                             writing: bp,
                             phrase: 0,
                             revealed: Self.revealed(writing: bp),
                             rootGap: 0, gloss: 0,
                             prompt: prompt, travelled: travelled)
        case .roots:
            return RiteFrame(beat: beat,
                             writing: bp,
                             phrase: 0, revealed: 0,
                             rootGap: Self.rootGap(writing: bp),
                             gloss: Self.gloss(writing: bp),
                             prompt: prompt, travelled: travelled)
        }
    }

    // MARK: · Design's three curves

    /// How much of her name the unseen hand has written, `0…1`.
    ///
    /// Three strokes, each easing across the first ``strokeHold`` of its own
    /// share and then holding — which is why the curve has two plateaus in it,
    /// at a third and at two thirds. They are the pauses between strokes, and
    /// they are the reason the writing reads as a hand rather than as a wipe.
    static func revealed(writing bp: Double) -> Double {
        let span = Double(strokes)
        let segment = min(span - 0.001, clamp01(bp) * span)
        let index = segment.rounded(.down)
        let within = segment - index
        let eased = within < strokeHold ? within / strokeHold : 1
        return (index + eased) / span
    }

    /// How far apart her roots stand, `0…1` of the full gap. They part, and
    /// then they come back together: at the end of the beat the name is whole
    /// again, having been shown to be made of pieces.
    static func rootGap(writing bp: Double) -> Double {
        let part = clamp01(bp / rootsPartOver)
        let rejoin = clamp01((bp - rootsRejoinFrom) / rootsRejoinOver)
        return (1 - rejoin) * part
    }

    /// Her quality, arriving beneath the roots. `0…1` of ``glossAlpha``.
    static func gloss(writing bp: Double) -> Double {
        clamp01((bp - glossArrivesFrom) / glossArrivesOver)
    }

    static func clamp01(_ x: Double) -> Double { min(1, max(0, x)) }
}

// MARK: - One instant of the ceremony

/// What the walker is given at one moment of the rite.
///
/// Every field is a quantity of *her* — how present her phrase is, how much of
/// her name is written, how far her roots stand apart. There is no field for
/// how many times he has been here, how far through he is, or which beat this
/// is of how many, and there is nowhere to put one: ``RiteOfEnteringView``
/// draws this struct and nothing else.
struct RiteFrame: Equatable {
    /// Which beat is being written, or `nil` once the words are done.
    let beat: RiteBeat?
    /// How far the beat has written itself, `0…1`.
    let writing: Double
    /// Her phrase's alpha.
    let phrase: Double
    /// How much of her name has been written, `0…1`.
    let revealed: Double
    /// How far her roots stand apart, `0…1` of the full gap.
    let rootGap: Double
    /// How present her quality is beneath them, `0…1`.
    let gloss: Double
    /// The words at the threshold, once the beat has finished writing.
    let prompt: RitePrompt?
    /// How far he has come, `0` at the far end and `1` in the room.
    let travelled: Double

    /// The settled state of a beat: everything written, everything arrived.
    /// What reduced motion is given, and what every beat ends at.
    var isSettled: Bool {
        guard let beat else { return true }
        switch beat {
        case .phrase:  return phrase >= RiteOfEntering.phraseAlpha - 1e-9
        case .written: return revealed >= 1 - 1e-9
        case .roots:   return rootGap <= 1e-9 && gloss >= 1 - 1e-9
        }
    }
}

// MARK: - Her words, off her own row

/// What the rite says, composed from the base and from nowhere else.
///
/// Design's Axis reads these off its bundled cards. The app reads them off
/// ``Shakti`` — `appreciationPhrase`, `devanagari`, `etymology`, `quality`, all
/// four real Airtable fields the sync already fills — because a bundled card
/// table is the ghost roster the laws exist to prevent.
///
/// **Every fall-back degrades to something true rather than to something
/// invented** (invariant 5, and `FIDELITY.md` §6): her Devanāgarī falls back to
/// her name, which is the same name in another script; her roots fall back to
/// her name's own compound parts, which are in the name already; her gratitude
/// falls back to her āvaraṇa's, which is the gratitude of the enclosure she is
/// seated in. Nothing here composes a sentence that is not somebody's.
struct RiteWords: Equatable {
    /// Beat one. Her appreciation phrase, or her āvaraṇa's.
    let appreciation: String
    /// Beat two. Her Devanāgarī, or her name.
    let written: String
    /// Beat three. The parts her name is made of.
    let roots: [String]
    /// …and her quality beneath them. May be empty; the beat is then the roots
    /// alone, which is still the beat.
    let gloss: String

    /// Everything this can put in front of the walker, for the checks that read
    /// the whole corpus at once.
    var all: [String] { [appreciation, written, gloss] + roots }

    /// Composed from plain values, so the whole corpus can be driven without a
    /// row, a context or a store.
    static func compose(appreciationPhrase: String?,
                        ringAppreciation: String,
                        devanagari: String?,
                        name: String,
                        etymology: String?,
                        quality: String) -> RiteWords {
        RiteWords(
            appreciation: firstSpoken([appreciationPhrase, ringAppreciation, name]),
            written: firstSpoken([devanagari, name]),
            roots: roots(inEtymology: etymology) ?? compoundParts(of: name),
            gloss: trimmed(quality) ?? "")
    }

    /// Composed from her synced row, with her āvaraṇa's gratitude standing
    /// behind hers.
    static func compose(shakti: Shakti, ring: Int) -> RiteWords {
        compose(appreciationPhrase: shakti.appreciationPhrase,
                ringAppreciation: Avarana.appreciationPhrase(forRing: ring),
                devanagari: shakti.devanagari,
                name: shakti.name,
                etymology: shakti.etymology,
                quality: shakti.quality)
    }

    // MARK: · The etymology, read rather than assumed

    /// The separators an etymological root list is written with — Design joins
    /// its own `roots` array with `' + '`, and the base's field is written the
    /// same way.
    static let rootSeparators: CharacterSet = CharacterSet(charactersIn: "+·—–")

    /// The longest a root may be before what is being read is prose rather than
    /// a root list.
    static let longestRoot = 24

    /// Her etymology as roots, or `nil` when the field is not a root list.
    ///
    /// **It guards rather than assumes.** The field is free text in the base,
    /// and a line of prose split on its dashes would put half-sentences on the
    /// threshold; a root that is too long, or that carries a full stop, means
    /// this is a sentence about her etymology rather than the etymology, and the
    /// beat falls back to her name's own parts.
    static func roots(inEtymology etymology: String?) -> [String]? {
        guard let etymology, let whole = trimmed(etymology) else { return nil }
        let parts = whole.components(separatedBy: rootSeparators).compactMap(trimmed)
        guard parts.count > 1 else { return nil }
        for part in parts {
            guard part.count <= longestRoot, !part.contains(".") else { return nil }
        }
        return parts
    }

    // MARK: · Her name, opened

    /// The prefixes and suffixes that actually occur in the khaḍgamālā, ported
    /// from Design's `riteRoots`.
    ///
    /// They **split a string**; nothing is looked up, selected or keyed by them
    /// (law 1), and a name that matches none of them is simply left whole —
    /// which is Design's own behaviour and the honest one: a name whose parts
    /// are unknown is shown as itself rather than as a guess.
    static let namePrefixes = ["Sarva", "Anaṅga", "Mahā", "Tripura", "Kāmeśvarī", "Vajreśvarī", "Bhaga"]
    static let nameSuffixes = ["ākarṣiṇī", "karṣiṇī", "mayī", "pradā", "kāriṇī",
                               "sundarī", "mālinī", "eśvarī", "iṇī", "inī"]

    /// The marks the app's own names already carry their compounds on:
    /// `Sarva-Yoni`, `Anaṅga-Kusumā`. Where one is present it is the base's own
    /// answer, and no morpheme table is needed at all.
    static let compoundMarks = CharacterSet(charactersIn: "-·")

    /// Her name opened into its parts.
    static func compoundParts(of name: String) -> [String] {
        guard let whole = trimmed(name) else { return [] }

        let marked = whole.components(separatedBy: compoundMarks).compactMap(trimmed)
        if marked.count > 1 { return marked }

        var middle = whole
        var head: String?
        var tail: String?
        for prefix in namePrefixes where middle.hasPrefix(prefix) && middle.count > prefix.count + 1 {
            head = prefix
            middle = String(middle.dropFirst(prefix.count))
            break
        }
        for suffix in nameSuffixes where middle.hasSuffix(suffix) && middle.count > suffix.count + 1 {
            tail = suffix
            middle = String(middle.dropLast(suffix.count))
            break
        }
        let parts = [head, trimmed(middle), tail].compactMap { $0 }
        return parts.count > 1 ? parts : [whole]
    }

    // MARK: · Small helpers

    static func trimmed(_ s: String?) -> String? {
        guard let s else { return nil }
        let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }

    static func firstSpoken(_ candidates: [String?]) -> String {
        for candidate in candidates {
            if let spoken = trimmed(candidate) { return spoken }
        }
        return ""
    }
}

// MARK: - The tone each beat lands on

extension RiteOfEntering {

    /// One struck tone as a beat lands: her carrier at the unison, the fifth,
    /// the octave. `HomeCarrier` owns the arithmetic and this owns nothing —
    /// it exists so the ceremony's own record of what it struck can be read as
    /// pitches rather than as beat numbers.
    static func strikePitch(beat: RiteBeat, ring: Int, syllable: String?) -> Double {
        HomeCarrier.strikeFrequency(ring: ring, beat: beat.rawValue, syllable: syllable)
    }

    /// The pitches this ceremony has asked for, in order.
    func strikePitches(ring: Int, syllable: String?) -> [Double] {
        struck.map { Self.strikePitch(beat: $0, ring: ring, syllable: syllable) }
    }
}
