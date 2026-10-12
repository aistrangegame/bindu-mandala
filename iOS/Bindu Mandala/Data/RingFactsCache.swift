import Foundation

/// The nine āvaraṇa rows' own material — gem, dhātu, time cycle, bīja and
/// body region — as the base last said them (Wave 0 · D).
///
/// Law: Airtable is the source of truth for names and content. Design's
/// `HomeWorlds` table typed these five into Swift; they now arrive with every
/// sync and the typed values stand only as the offline fallback.
///
/// **Why beside the store and not in it.** These are read-only catalog
/// strings, re-fetched on every sync and never written by him. Putting them on
/// the `Avarana` model would change a shipped schema version, and BinduSchema's
/// first law is that a shipped version's models never drift. A small JSON in
/// UserDefaults carries them with no migration and no risk to his practice
/// data. If it is ever empty (first launch, cleared defaults), the authored
/// values show — degrade by falling back, never by blanking.
enum RingFactsCache {

    struct Facts: Codable, Equatable {
        var gem: String?
        var dhatu: String?
        var timeCycle: String?
        var beeja: String?
        var bodyRegion: String?
        /// Wave 2 · the ring's Siddhi (`fldx9jXyTVWxp19o1`), received on the
        /// way out of the Gates of Release. Optional, so a cache written
        /// before Wave 2 still decodes.
        var siddhi: String? = nil
    }

    static let defaultsKey = "ringFacts.v1"

    private static var defaults: UserDefaults { .standard }

    static func store(ring: Int, facts: Facts) {
        guard (1...9).contains(ring) else { return }
        var all = loadAll()
        all[String(ring)] = facts
        if let data = try? JSONEncoder().encode(all) {
            defaults.set(data, forKey: defaultsKey)
        }
    }

    static func facts(ring: Int) -> Facts? {
        loadAll()[String(ring)]
    }

    private static func loadAll() -> [String: Facts] {
        guard let data = defaults.data(forKey: defaultsKey),
              let all = try? JSONDecoder().decode([String: Facts].self, from: data) else { return [:] }
        return all
    }
}
