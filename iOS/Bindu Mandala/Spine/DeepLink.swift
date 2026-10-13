import Foundation

// MARK: - Upgrade U1 · A · deep links and the walk's addresses
//
// `waves/upgrade/worlds/spine-and-home.md` §2 J #71 ("open(url) for
// bindu://place?world=&kp=&ch=&day=") and #75 ("OPEN_WORLD=<id> and
// OPEN_PLACE=world:kp:ch:day replace START_TAB"). Every address has a link,
// and every link names an address; the kp and road short forms open her Home
// and the chakra's room, the first doors on those threads (§2 E #47).
//
// The `bindu` URL scheme is not yet registered in Info.plist (U2 adds
// `CFBundleURLTypes`); `SpineRoot` already answers `onOpenURL`.

/// Links ⇄ addresses — `spine-and-home.md` §2 J #71, #75.
enum DeepLink {

    static let scheme = "bindu"

    /// `bindu://place?world=herHome&kp=29&ch=&day=2026-10-13&sub=`
    static let placeHost = "place"
    /// `bindu://kp/29` — her position: her Home.
    static let kpHost = "kp"
    /// `bindu://road/7` — the chakra: its room in the 33.
    static let roadHost = "road"
    /// `bindu://day/2026-10-13` — the day: Today.
    static let dayHost = "day"
    /// `bindu://world/well` — a world, plainly.
    static let worldHost = "world"

    // MARK: Address → link

    /// The link for an address (the camera stays on the phone).
    static func url(for address: Address) -> URL {
        var pairs: [(String, String)] = [("world", address.world.rawValue)]
        if let kp = address.kp { pairs.append(("kp", String(kp))) }
        if let ch = address.chakra { pairs.append(("ch", String(ch))) }
        if let day = address.day { pairs.append(("day", day.iso)) }
        if let sub = address.sub { pairs.append(("sub", sub)) }
        // Encoded by hand so `&`, `=`, `+` and `#` inside a value stay inside it.
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "&=+#")
        var c = URLComponents()
        c.scheme = scheme
        c.host = placeHost
        c.percentEncodedQuery = pairs
            .map { "\($0.0)=\($0.1.addingPercentEncoding(withAllowedCharacters: allowed) ?? $0.1)" }
            .joined(separator: "&")
        return c.url ?? URL(string: "\(scheme)://\(placeHost)?world=\(address.world.rawValue)")!
    }

    // MARK: Link → address

    /// The address a link names, or nil (an unknown world, a position outside
    /// the garland, a chakra off the Road, a day that does not exist).
    static func address(from url: URL) -> Address? {
        guard url.scheme?.lowercased() == scheme, let host = url.host?.lowercased() else { return nil }
        let path = url.pathComponents.filter { $0 != "/" }
        switch host {
        case placeHost:
            let query = queryValues(of: url)
            func value(_ key: String) -> String? {
                guard let v = query[key], !v.isEmpty else { return nil }
                return v
            }
            guard let raw = value("world"), let world = WorldID(rawValue: raw) else { return nil }
            var a = Address(world)
            if let v = value("kp") { guard let n = Int(v) else { return nil }; a.kp = n }
            if let v = value("ch") { guard let n = Int(v) else { return nil }; a.chakra = n }
            if let v = value("day") { guard let d = Address.Day(iso: v) else { return nil }; a.day = d }
            a.sub = value("sub")
            return a.isValid ? a : nil
        case kpHost:
            guard path.count == 1, let n = Int(path[0]) else { return nil }
            return address(forKP: n)
        case roadHost:
            guard path.count == 1, let n = Int(path[0]) else { return nil }
            return address(forRoad: n)
        case dayHost:
            guard path.count == 1, let d = Address.Day(iso: path[0]) else { return nil }
            return address(forDay: d)
        case worldHost:
            guard path.count == 1, let w = WorldID(rawValue: path[0]) else { return nil }
            return Address(w)
        default:
            return nil
        }
    }

    /// `key=value` pairs of a link's query, percent-decoded; the last of a key wins.
    static func queryValues(of url: URL) -> [String: String] {
        guard let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?.percentEncodedQuery else { return [:] }
        var out: [String: String] = [:]
        for pair in query.split(separator: "&") {
            let kv = pair.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            guard let k = kv.first.map(String.init)?.removingPercentEncoding else { continue }
            let v = kv.count > 1 ? (String(kv[1]).removingPercentEncoding ?? "") : ""
            out[k] = v
        }
        return out
    }

    /// Her position opens her Home (the first kp door, §2 E #47).
    static func address(forKP kp: Int) -> Address? {
        let a = Address(.herHome, kp: kp)
        return a.isValid ? a : nil
    }

    /// A chakra opens its room in the 33 (the first chakra door, §2 E #47).
    static func address(forRoad chakra: Int) -> Address? {
        let a = Address(.the33, chakra: chakra)
        return a.isValid ? a : nil
    }

    /// A day opens Today on it (the first day door, §2 E #47).
    static func address(forDay day: Address.Day) -> Address {
        Address(.today, day: day)
    }

    // MARK: The walk's launch arguments (DEBUG only, V50)

    /// `OPEN_PLACE=world:kp:ch:day` — empty segments are absent threads
    /// (`OPEN_PLACE=herHome:29::`, `OPEN_PLACE=the33::7:`, `OPEN_PLACE=time:::2026-10-13`).
    static let openPlacePrefix = "OPEN_PLACE="

    /// The value of an `OPEN_PLACE` argument as an address.
    static func place(fromLaunchValue value: String) -> Address? {
        let parts = value.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
        guard let first = parts.first, let world = WorldID(rawValue: first), parts.count <= 4 else { return nil }
        var a = Address(world)
        if parts.count > 1, !parts[1].isEmpty { guard let n = Int(parts[1]) else { return nil }; a.kp = n }
        if parts.count > 2, !parts[2].isEmpty { guard let n = Int(parts[2]) else { return nil }; a.chakra = n }
        if parts.count > 3, !parts[3].isEmpty { guard let d = Address.Day(iso: parts[3]) else { return nil }; a.day = d }
        return a.isValid ? a : nil
    }

    /// The address the walk launched on — `OPEN_PLACE` or `OPEN_WORLD`, the
    /// last of either winning (as `ENERGY_POS` does). DEBUG only: a Release
    /// build never honours either (V50: no forced state in a shipped build).
    /// `OPEN_WORLD` now routes through here (U1 brief, Part A 5).
    static func launchAddress(arguments: [String] = ProcessInfo.processInfo.arguments) -> Address? {
        #if DEBUG
        guard let arg = arguments.last(where: {
            $0.hasPrefix(openPlacePrefix) || $0.hasPrefix(WorldID.openWorldPrefix) || $0.hasPrefix(openPlayPrefix)
        }) else { return nil }
        if arg.hasPrefix(openPlacePrefix) {
            return place(fromLaunchValue: String(arg.dropFirst(openPlacePrefix.count)))
        }
        if arg.hasPrefix(openPlayPrefix) {
            return play(fromLaunchArgument: arg)
        }
        return WorldID.fromLaunchArguments([arg]).map { Address($0) }
        #else
        return nil
        #endif
    }

    /// U2 · `OPEN_PLAY` (Lalitā's whole field) or `OPEN_PLAY=<game>` (one game)
    /// — the retired play presenter's launch argument, now an address in A
    /// Strange Game. An unknown game opens nothing.
    static let openPlayPrefix = "OPEN_PLAY"

    static func play(fromLaunchArgument arg: String) -> Address? {
        guard arg.hasPrefix(openPlayPrefix) else { return nil }
        let rest = arg.dropFirst(openPlayPrefix.count)
        if rest.isEmpty { return Address(.game) }
        guard rest.hasPrefix("="), let game = PlayGame(rawValue: String(rest.dropFirst())) else { return nil }
        return Address(.game, sub: game.rawValue)
    }
}
