import Foundation

// MARK: - U1 · D · the Score validator (V42)
//
// `score-format-v2.md` §5 and Appendix A; the Bindu Field's
// `scripts/batch/validate.py` ("the 21 rules … Zero FAILs required; WARNs
// expected on batch drafts"); `verification.md` V42: "validate.py ported as a
// Swift test over every MandalaScore: required blocks; id ^[a-z][a-z0-9_]*$;
// times in [0,dur]; phases ordered, no overlap; silences no overlap; peak
// inside a phase; return < dur; beat_schedule last until null; generation_order
// the seven; derivation in {absent_fifth, absent_root, present_root,
// imposed+reason}; R16 HARD no Hz in resonance_link; footprint with silences;
// warnings R19/R20. Peaks marked needs_listening stay flagged until he listens."
//
// The player refuses a Score with any failure (`ScoreLoader.load`). Warnings
// never refuse.
//
// The twenty-one:
//   Structural  R1 schema · R2 the nine required · R3 id pattern
//   Temporal    R4 every time inside [0, duration] · R5 phases ordered, no
//               overlap · R6 silences ordered, no overlap · R7 peak inside a
//               phase · R8 return before the end · R9 beats ordered, last
//               `until` null
//   Semantic    R10 max_blend in [0,1], 1.0 only for the Return's spiral ·
//               R11 the seven dancers · R12 two-letter families with words ·
//               R13 derivation one of four · R14 imposed needs a reason ·
//               R15 an unknown vocabulary module falls back to Layer 1 (warn) ·
//               R16 no Hz in resonance_link (HARD) · R17 footprint with silences
//   Advisory    R18 global boost < 0.7 · R19 no haptic at peak_t · R20 peak not
//               authored and no reason (Appendix A) · R21 a peak that still
//               needs listening (V42)

/// One finding of the validator (score-format-v2 §5; verification.md V42).
struct ScoreFinding: Equatable, CustomStringConvertible {
    enum Rule: Int, CaseIterable, Comparable {
        case r1 = 1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21

        static func < (a: Rule, b: Rule) -> Bool { a.rawValue < b.rawValue }

        var tag: String { "R\(rawValue)" }

        /// Whether the rule only warns.
        var isAdvisory: Bool { [.r15, .r18, .r19, .r20, .r21].contains(self) }
    }

    let rule: Rule
    let detail: String

    var description: String { "\(rule.tag) \(detail)" }
}

/// What the validator found: failures refuse the Score; warnings do not
/// (score-format-v2 §5; V42).
struct ScoreValidation: Equatable {
    let failures: [ScoreFinding]
    let warnings: [ScoreFinding]

    var passes: Bool { failures.isEmpty }
    var failedRules: Set<ScoreFinding.Rule> { Set(failures.map(\.rule)) }
    var warnedRules: Set<ScoreFinding.Rule> { Set(warnings.map(\.rule)) }
}

/// The validator — score-format-v2.md §5 over the plain JSON tree.
enum ScoreValidator {

    /// The nine required sections (§2).
    static let required = ["identity", "config", "anchors", "phases", "silence_windows",
                           "binaural", "consciousness_loop", "return", "field_connection"]

    /// The four permitted carrier derivations (§3.15).
    static let derivations: Set<String> = ["absent_fifth", "absent_root", "present_root", "imposed"]

    /// The seven dancers (§3.9).
    static let seven: Set<String> = ["bindu", "gaia", "sid", "arch", "karishma", "sakshi", "ashrey"]

    /// Vocabulary modules the app can draw. None yet (U7 builds them); every
    /// Score that names one runs Layer 1 and is warned (R15).
    static let knownVocabularyModules: Set<String> = []

    /// validate.py's tolerance at the song's end (`dur + 0.05`).
    static let endTolerance = 0.05

    static func validate(_ doc: ScoreJSON, knownModules: Set<String> = knownVocabularyModules) -> ScoreValidation {
        var fails: [ScoreFinding] = []
        var warns: [ScoreFinding] = []
        func fail(_ r: ScoreFinding.Rule, _ d: String) { fails.append(ScoreFinding(rule: r, detail: d)) }
        func warn(_ r: ScoreFinding.Rule, _ d: String) { warns.append(ScoreFinding(rule: r, detail: d)) }

        let s = doc["score"] ?? .null

        // R1
        if doc["schema"]?.string != ScoreV2.schemaV2 { fail(.r1, "schema is not \(ScoreV2.schemaV2)") }

        // R2
        for r in required where s[r] == nil || s[r]?.isNull == true { fail(.r2, "missing required: \(r)") }

        // R3
        let id = s.at("identity", "id")?.string ?? ""
        if !isScoreId(id) { fail(.r3, "id \"\(id)\" is not ^[a-z][a-z0-9_]*$") }

        // R4
        let dur = s.at("identity", "song", "duration_seconds")?.double
        if dur == nil { fail(.r4, "no identity.song.duration_seconds to measure times against") }
        func check(_ t: ScoreJSON?, _ where_: String) {
            guard let t = t?.double, let dur else { return }
            if !(0 <= t && t <= dur + endTolerance) { fail(.r4, "\(where_)=\(t) outside [0,\(dur)]") }
        }
        let phases = s["phases"]?.array ?? []
        let silences = s["silence_windows"]?.array ?? []
        for (i, p) in phases.enumerated() {
            check(p["start"], "phase[\(i)].start"); check(p["end"], "phase[\(i)].end")
        }
        for (i, w) in silences.enumerated() {
            check(w["start"], "silence[\(i)].start"); check(w["end"], "silence[\(i)].end")
        }
        check(s.at("config", "peak_t"), "config.peak_t")
        check(s.at("anchors", "peak_t", "value"), "anchors.peak_t.value")
        check(s.at("anchors", "peak_t", "extracted"), "anchors.peak_t.extracted")
        for (i, t) in (s.at("mirror_system", "times")?.array ?? []).enumerated() { check(t, "mirror.times[\(i)]") }
        let beats = s.at("binaural", "beat_schedule")?.array ?? []
        for (i, b) in beats.enumerated() { check(b["until"], "beat_schedule[\(i)].until") }

        // R5
        for i in phases.indices {
            guard let st = phases[i]["start"]?.double, let en = phases[i]["end"]?.double else {
                fail(.r5, "phase[\(i)] has no start/end"); continue
            }
            if en < st { fail(.r5, "phase[\(i)] ends before it starts") }
            if i > 0, let ps = phases[i - 1]["start"]?.double, let pe = phases[i - 1]["end"]?.double {
                if st < pe - 1e-6 { fail(.r5, "phase overlap at \(i)") }
                if st < ps { fail(.r5, "phase unordered at \(i)") }
            }
        }

        // R6
        for i in silences.indices {
            guard let st = silences[i]["start"]?.double, let en = silences[i]["end"]?.double else {
                fail(.r6, "silence[\(i)] has no start/end"); continue
            }
            if en < st { fail(.r6, "silence[\(i)] ends before it starts") }
            if i > 0, let pe = silences[i - 1]["end"]?.double, st < pe - 1e-6 {
                fail(.r6, "silence overlap at \(i)")
            }
        }

        // R7
        if let pt = s.at("config", "peak_t")?.double, !phases.isEmpty {
            let inside = phases.contains { p in
                guard let st = p["start"]?.double, let en = p["end"]?.double else { return false }
                return st <= pt && pt <= en
            }
            if !inside { fail(.r7, "peak_t \(pt) is in no phase") }
        }

        // R8
        if let rs = s.at("return", "starts_seconds_before_end")?.double, let dur, !(rs < dur) {
            fail(.r8, "return starts \(rs) s before an end of \(dur) s")
        }

        // R9
        if let last = beats.last {
            if last["until"]?.isNull == false { fail(.r9, "the final beat's until is not null") }
            let middle = beats.dropLast().map { $0["until"]?.double }
            if middle.contains(where: { $0 == nil }) { fail(.r9, "a beat before the last has no until") }
            let nums = middle.compactMap { $0 }
            if nums != nums.sorted() { fail(.r9, "beat_schedule is not ordered by until") }
        }

        // R10
        for (i, p) in (s["path"]?.array ?? []).enumerated() {
            guard let mb = p["max_blend"]?.double else { continue }
            if mb < 0 || mb > 1 { fail(.r10, "path[\(i)].max_blend \(mb) outside [0,1]") }
            let returnSpiral = p["mode"]?.string == "spiral"
                && (p["phase"]?.string == "Return" || p["trigger_at"]?.string == "return")
            if mb >= 1, !returnSpiral { fail(.r10, "path[\(i)] reaches 1.0 outside the Return's spiral") }
        }
        for (i, p) in (s["shape_choreography"]?.array ?? []).enumerated() {
            guard let mb = p["max_blend"]?.double else { continue }
            if mb < 0 || mb > 1 { fail(.r10, "shape[\(i)].max_blend \(mb) outside [0,1]") }
            let returnSpiral = p["type"]?.string == "spiral" && p["trigger_at"]?.string == "return"
            if mb >= 1, !returnSpiral { fail(.r10, "shape[\(i)] reaches 1.0 outside the Return's spiral") }
        }

        // R11
        if let go = s.at("ensemble", "generation_order")?.array {
            let names = go.compactMap(\.string)
            if names.count != 7 || Set(names) != seven { fail(.r11, "generation_order is not the seven") }
        }

        // R12
        if let fam = s.at("mirror_system", "families")?.object {
            for (k, v) in fam where k.count != 2 || (v.array ?? []).isEmpty {
                fail(.r12, "family \"\(k)\"")
            }
        }

        // R13 · R14
        let carrier = s.at("binaural", "carrier")
        let d = carrier?["derivation"]?.string
        if d == nil || !derivations.contains(d ?? "") { fail(.r13, "derivation \(d ?? "missing")") }
        if d == "imposed", carrier?["reason"]?.string?.isEmpty ?? true { fail(.r14, "imposed carrier with no reason") }

        // R15
        if let vm = s.at("metaphor", "vocabulary_module")?.string, !vm.isEmpty, !knownModules.contains(vm) {
            warn(.r15, "vocabulary module \"\(vm)\" is not built; Layer 1 only")
        }

        // R16 (HARD)
        if let rl = s["resonance_link"], rl.isFilled {
            let hz = hzValues(in: rl, path: "resonance_link")
            if !hz.isEmpty { fail(.r16, "resonance_link carries Hz: \(hz.joined(separator: ", "))") }
        }

        // R17
        if !silences.isEmpty, s["silence_footprint_pct"]?.double == nil { fail(.r17, "silence_footprint_pct missing") }

        // R18
        let t4 = s.at("tiers", "t4_climax")
        if let f = (t4?.at("roles", "global_boost", "factor") ?? t4?.at("global_boost", "factor"))?.double, f < 0.7 {
            warn(.r18, "global boost \(f) — likely conservative")
        }

        // R19
        let patterns = s.at("haptics", "patterns")?.object ?? [:]
        let atPeak = patterns.values.contains { p in
            if p["fires_at"]?.string == "peak_t" { return true }
            if let t = p["fires_at"]?.double, let pt = s.at("config", "peak_t")?.double { return abs(t - pt) < 0.05 }
            return false
        }
        if !atPeak { warn(.r19, "no haptic at peak_t — the body should feel the apex") }

        // R20 (Appendix A: only when there is no reason either)
        let anchor = s.at("anchors", "peak_t")
        if anchor?["authored"]?.bool == false, anchor?["reason"]?.string?.isEmpty ?? true {
            warn(.r20, "peak not authored and no reason — did the listening happen?")
        }

        // R21
        if anchor?["needs_listening"]?.bool == true {
            warn(.r21, "peak needs listening — flagged until he listens")
        }

        return ScoreValidation(failures: fails, warnings: warns)
    }

    /// `^[a-z][a-z0-9_]*$`.
    static func isScoreId(_ s: String) -> Bool {
        let letters: ClosedRange<Unicode.Scalar> = "a"..."z"
        let digits: ClosedRange<Unicode.Scalar> = "0"..."9"
        let underscore: Unicode.Scalar = "_"
        guard let first = s.unicodeScalars.first, letters.contains(first) else { return false }
        return s.unicodeScalars.allSatisfy { letters.contains($0) || digits.contains($0) || $0 == underscore }
    }

    /// Every Hz inside `v`: a key naming hz / hertz / freq(uency) that holds
    /// something (validate.py's `find_hz`), or a string that writes a number
    /// in Hz ("136.1 Hz"). §3.24: "No Score may assign a Hz to a Shakti."
    static func hzValues(in v: ScoreJSON, path: String) -> [String] {
        var out: [String] = []
        switch v {
        case .object(let o):
            for (k, child) in o.sorted(by: { $0.key < $1.key }) {
                let lower = k.lowercased()
                if (lower.contains("hz") || lower.contains("hertz") || lower.contains("freq")), child.isFilled {
                    out.append("\(path).\(k)")
                }
                out.append(contentsOf: hzValues(in: child, path: "\(path).\(k)"))
            }
        case .array(let a):
            for (i, child) in a.enumerated() { out.append(contentsOf: hzValues(in: child, path: "\(path)[\(i)]")) }
        case .string(let s):
            if s.range(of: #"\d\s*(hz|hertz)\b"#, options: [.regularExpression, .caseInsensitive]) != nil {
                out.append("\(path)=\"\(s)\"")
            }
        default:
            break
        }
        return out
    }
}

/// A Score the player would not play, and why.
struct ScoreRefusal: Error, CustomStringConvertible, Equatable {
    let id: String?
    let findings: [ScoreFinding]

    var description: String {
        "Score \(id ?? "?") refused: " + findings.map(\.description).joined(separator: "; ")
    }
}

/// A Score that passed, with what it was warned about.
struct LoadedScore: Equatable {
    let score: ScoreV2
    let warnings: [ScoreFinding]
}

/// Reads a Score JSON document, validates it, and refuses it if any rule
/// fails (U1 brief Part D item 3: "validate with the 21 Score rules (V42) and
/// refuse an invalid score").
enum ScoreLoader {

    static func load(_ data: Data, knownModules: Set<String> = ScoreValidator.knownVocabularyModules) throws -> LoadedScore {
        let tree: ScoreJSON
        do {
            tree = try ScoreJSON.parse(data)
        } catch {
            throw ScoreRefusal(id: nil, findings: [ScoreFinding(rule: .r1, detail: "not JSON: \(error)")])
        }
        let v = ScoreValidator.validate(tree, knownModules: knownModules)
        let id = tree.at("score", "identity", "id")?.string
        guard v.passes else { throw ScoreRefusal(id: id, findings: v.failures) }
        do {
            let score = try JSONDecoder().decode(ScoreV2.self, from: data)
            return LoadedScore(score: score, warnings: v.warnings)
        } catch {
            // The rules passed but a field the player runs has a shape the
            // format does not allow — refused under the structural rule.
            throw ScoreRefusal(id: id, findings: [ScoreFinding(rule: .r2, detail: "a section has the wrong shape: \(error)")])
        }
    }

    static func load(_ text: String, knownModules: Set<String> = ScoreValidator.knownVocabularyModules) throws -> LoadedScore {
        try load(Data(text.utf8), knownModules: knownModules)
    }
}
