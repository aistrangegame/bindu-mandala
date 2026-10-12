import SwiftUI
import SwiftData

// MARK: - Wave 6 · her screen deepens with each return (Codex C-1354)
//
// "Progressive disclosure: each return reveals a deeper layer… The system
// holds the door open and never the watch." Each time he comes back to her,
// one more layer of her own row is set out below her doorways — her function,
// the state her ring sets down, what her ring gives, the root of her name, the
// way she is known, the paragraph of her enclosure. (Her iconographic
// prose stays out — Law 4 refuses the form even as sentences.) It is **place, not
// progress**: no count is shown, nothing says "new", nothing is locked, and a
// layer once open stays open. The newest one simply arrives, slowly, in light.
//
// The return is remembered on the phone only (`HerDeepening`), keyed by her
// position — a fact about how deep her screen has opened, never shown as a
// number and never sent anywhere.

enum HerDeepening {

    /// A return counts once in this long — coming back from a sheet over her
    /// screen is not a return.
    static let returnGap: TimeInterval = 20 * 60

    static let visitsKey = "herDeepening.visits.v1"
    static let lastKey = "herDeepening.last.v1"

    struct Layer: Equatable, Identifiable {
        let title: String
        let words: String
        var id: String { title }
    }

    /// Her layers, in the order they open, from her row and her ring's — only
    /// those the base actually holds words for.
    static func layers(function: String?, mentalState: String?, siddhi: String?,
                       etymology: String?, qualities: String?, ringNotes: String?) -> [Layer] {
        let candidates: [(String, String?)] = [
            ("what she does", function),
            ("what her ring sets down", mentalState),
            ("what her ring gives", siddhi),
            ("the root of her name", etymology),
            ("how she is known", qualities),
            ("her enclosure", ringNotes),
        ]
        return candidates.compactMap { title, raw in
            let t = (raw ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            return t.isEmpty ? nil : Layer(title: title, words: t)
        }
    }

    /// How many layers stand open after `visits` visits: the first visit opens
    /// one, each return one more, never more than there are.
    static func open(visits: Int, available: Int) -> Int {
        max(0, min(available, visits))
    }

    /// Does arriving at `now` count as a return, given the last counted one?
    static func isReturn(last: Date?, now: Date) -> Bool {
        guard let last else { return true }
        return now.timeIntervalSince(last) >= returnGap
    }

    // MARK: The phone's memory of it

    static func visits(_ kp: Int, _ defaults: UserDefaults = .standard) -> Int {
        (defaults.dictionary(forKey: visitsKey) as? [String: Int])?[String(kp)] ?? 0
    }

    /// Count this arrival if it is a return; give back the visits now held.
    @discardableResult
    static func arrive(_ kp: Int, now: Date = .now, _ defaults: UserDefaults = .standard) -> Int {
        var visits = (defaults.dictionary(forKey: visitsKey) as? [String: Int]) ?? [:]
        var lasts = (defaults.dictionary(forKey: lastKey) as? [String: Double]) ?? [:]
        let key = String(kp)
        let last = lasts[key].map { Date(timeIntervalSinceReferenceDate: $0) }
        if isReturn(last: last, now: now) {
            visits[key] = (visits[key] ?? 0) + 1
            lasts[key] = now.timeIntervalSinceReferenceDate
            defaults.set(visits, forKey: visitsKey)
            defaults.set(lasts, forKey: lastKey)
        }
        return visits[key] ?? 0
    }
}

/// The layers, set out below her doorways — and, at their head when her row
/// holds one, her seed verb (always shown, never gated), and the heart register
/// for the sixteen of the heart ring.
struct HerDeepeningSection: View {
    let shakti: Shakti

    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var visits = 0
    @State private var arrived = false
    @State private var heartOpen = false

    private var kp: Int? { shakti.khadgamalaPosition }
    private var ring: Int { shakti.ringNumber ?? kp.map { KhadgamalaMap.ringNumber(forKhadgamala: $0) } ?? 0 }
    private var atmo: Atmosphere { Atmosphere.derive(from: shakti) }

    private var layers: [HerDeepening.Layer] {
        let facts = RingFactsCache.facts(ring: ring)
        return HerDeepening.layers(function: shakti.shaktiFunction,
                                   mentalState: avaranas.first { $0.ringNumber == ring }?.mentalState,
                                   siddhi: facts?.siddhi,
                                   etymology: shakti.etymology,
                                   qualities: shakti.qualityDescription,
                                   ringNotes: facts?.notes)
    }

    var body: some View {
        let all = layers
        let open = HerDeepening.open(visits: visits, available: all.count)
        VStack(alignment: .leading, spacing: 22) {
            if let kp, let verb = ShaktiFactsCache.seedVerb(kp) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("HER SEED")
                        .font(AppFont.label(11))
                        .tracking(2.6)
                        .foregroundStyle(atmo.accentBright)
                    Text(verb)
                        .font(AppFont.sanskrit(26))
                        .foregroundStyle(Color.cream)
                }
                .accessibilityElement(children: .combine)
            }
            ForEach(Array(all.prefix(open).enumerated()), id: \.element.id) { i, layer in
                let newest = arrived && i == open - 1 && visits > 1
                VStack(alignment: .leading, spacing: 8) {
                    Text(layer.title.uppercased())
                        .font(AppFont.label(11))
                        .tracking(2.4)
                        .foregroundStyle(Color.cream.opacity(0.55))
                    Text(layer.words)
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.84))
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.leading, 12)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(LinearGradient(colors: [atmo.accentBright.opacity(newest ? 0.9 : 0.4), .clear],
                                             startPoint: .top, endPoint: .bottom))
                        .frame(width: 1)
                }
                .transition(.opacity)
                .accessibilityElement(children: .combine)
            }
            if ring == 2 {
                Button {
                    Haptics.light()
                    heartOpen = true
                } label: {
                    Text("the heart register ›")
                        .font(AppFont.voice(16))
                        .tracking(1.0)
                        .foregroundStyle(Color.gold.opacity(0.82))
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 30)
        .animation(reduceMotion ? nil : .easeInOut(duration: 2.4), value: open)
        .onAppear {
            guard let kp else { return }
            visits = HerDeepening.visits(kp)
            let now = HerDeepening.arrive(kp)
            if reduceMotion {
                visits = now
            } else {
                // The newest layer arrives a breath after she does.
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(BreathClock.breath / 4))
                    visits = now
                }
            }
            arrived = true
        }
        .fullScreenCover(isPresented: $heartOpen) {
            HeartRegisterView(shakti: shakti)
        }
    }
}
