import Foundation
import UserNotifications

/// The random gift (Wave 5 · Codex C-1353): one Śakti's own words — her
/// Appreciation Phrase, or her Function — arriving at an hour he will not
/// expect, at most once a day, inside a window he sets. Opening it lands on
/// her screen.
///
/// Built on `DailySummons`' ground and held to its manners: no sound, no badge,
/// no count; nothing if he has turned her arrivals off; nothing without the
/// system's permission. The words are hers, from her row — never composed here.
///
/// **Unscheduled, but never twice.** Each day's hour and each day's Śakti come
/// from a seeded draw on (the day, a per-install salt), so rescheduling — which
/// happens every time the app comes to the front — redraws the *same* gift for
/// the same day. A gift already delivered is in the past and is not drawn again;
/// one a reschedule would have moved cannot arrive a second time.
@MainActor
enum EnergyGift {

    static let idPrefix = "gift."
    static let positionKey = "kp"

    static let enabledKey = "energy_gift_enabled"
    static let windowStartKey = "energy_gift_window_start"
    static let windowEndKey = "energy_gift_window_end"
    private static let saltKey = "energy_gift_salt"

    static let defaultWindowStart = 10
    static let defaultWindowEnd = 20
    static let daysAhead = 14

    /// Khaḍgamālā position → (her name, her authored line). Set by the app layer
    /// from SwiftData (`RootView.primeSummons`), as `DailySummons.greetingProvider` is.
    static var giftProvider: ((Int) -> (title: String, body: String)?)?

    struct Planned: Equatable {
        let fireAt: Date
        let khadgamalaPosition: Int
    }

    /// The window as given, made sane: start 0…23, end after start, at most 24.
    nonisolated static func window(start: Int, end: Int) -> (start: Int, end: Int) {
        let s = max(0, min(23, start))
        var e = max(1, min(24, end))
        if e <= s { e = min(24, s + 1) }
        return (s, e)
    }

    /// The gifts for the next `days` days from `now`: at most one per local day,
    /// inside the window, never in the past. Pure — the same inputs give the
    /// same plan, on the device and in tests.
    nonisolated static func plan(from now: Date,
                                 days: Int,
                                 windowStart: Int,
                                 windowEnd: Int,
                                 salt: UInt64,
                                 count: Int = KhadgamalaMap.total,
                                 calendar: Calendar = .current) -> [Planned] {
        let w = window(start: windowStart, end: windowEnd)
        let span = (w.end - w.start) * 60
        let today = calendar.startOfDay(for: now)
        var out: [Planned] = []
        for offset in 0..<max(0, days) {
            guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
            let c = calendar.dateComponents([.year, .month, .day], from: day)
            let dayKey = UInt64((c.year ?? 0) * 10_000 + (c.month ?? 0) * 100 + (c.day ?? 0))
            var state = salt ^ (dayKey &* 0x9E37_79B9_7F4A_7C15)
            let minute = Int(mix(&state) % UInt64(max(1, span)))
            let kp = Int(mix(&state) % UInt64(max(1, count))) + 1
            guard let fire = calendar.date(bySettingHour: w.start, minute: 0, second: 0, of: day)?
                    .addingTimeInterval(TimeInterval(minute * 60)),
                  fire > now else { continue }
            out.append(Planned(fireAt: fire, khadgamalaPosition: kp))
        }
        return out
    }

    /// SplitMix64.
    nonisolated private static func mix(_ state: inout UInt64) -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }

    private static var salt: UInt64 {
        let defaults = UserDefaults.standard
        if let stored = defaults.string(forKey: saltKey), let v = UInt64(stored) { return v }
        let fresh = UInt64.random(in: 1...UInt64.max)
        defaults.set(String(fresh), forKey: saltKey)
        return fresh
    }

    /// Clear and redraw the coming fortnight's gifts.
    static func reschedule() async {
        let center = UNUserNotificationCenter.current()
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter { $0.hasPrefix(idPrefix) }
        center.removePendingNotificationRequests(withIdentifiers: ids)

        let defaults = UserDefaults.standard
        let arrivalsOn = (defaults.object(forKey: "daily_summons_enabled") as? Bool) ?? true
        let giftsOn = (defaults.object(forKey: enabledKey) as? Bool) ?? true
        guard arrivalsOn, giftsOn, let provider = giftProvider else { return }

        let status = await DailySummons.authorizationStatus()
        guard status == .authorized || status == .provisional else { return }

        let start = (defaults.object(forKey: windowStartKey) as? Int) ?? defaultWindowStart
        let end = (defaults.object(forKey: windowEndKey) as? Int) ?? defaultWindowEnd
        let cal = Calendar.current

        for gift in plan(from: .now, days: daysAhead, windowStart: start, windowEnd: end,
                         salt: salt, calendar: cal) {
            // Her row may hold neither line; the gift then passes to the next
            // seat that holds one, so the day keeps its gift.
            var chosen: (kp: Int, words: (title: String, body: String))?
            for step in 0..<KhadgamalaMap.total {
                let kp = (gift.khadgamalaPosition - 1 + step) % KhadgamalaMap.total + 1
                if let words = provider(kp),
                   !words.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    chosen = (kp, words)
                    break
                }
            }
            guard let chosen else { continue }

            let content = UNMutableNotificationContent()
            content.title = chosen.words.title
            content.body = chosen.words.body
            content.userInfo = [positionKey: chosen.kp]

            let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: gift.fireAt)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let id = "\(idPrefix)\(comps.year ?? 0)-\(comps.month ?? 0)-\(comps.day ?? 0)"
            try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }
    }
}

/// Lands a tapped gift on her screen. The system hands the response to this
/// delegate (installed at launch, before the app finishes launching, so a gift
/// that *opens* the app is not missed); the Khaḍgamālā position is held until
/// the shell is ready to present her, then taken exactly once.
final class GiftRouter: NSObject, UNUserNotificationCenterDelegate {

    static let shared = GiftRouter()

    private let lock = NSLock()
    private var held: Int?

    func install() {
        UNUserNotificationCenter.current().delegate = self
    }

    func hold(_ kp: Int) {
        lock.lock(); held = kp; lock.unlock()
    }

    /// The position waiting to be landed on, without taking it.
    func peek() -> Int? {
        lock.lock(); defer { lock.unlock() }
        return held
    }

    /// The position waiting to be landed on, once.
    func take() -> Int? {
        lock.lock(); defer { lock.unlock() }
        let kp = held
        held = nil
        return kp
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        if response.notification.request.identifier.hasPrefix("gift."),
           let kp = (info["kp"] as? Int) ?? (info["kp"] as? NSNumber)?.intValue {
            hold(kp)
            // U2 · the gift lands through the Router: Home, her card already
            // open (spine-and-home §2 J #72). Taken exactly once, here or by
            // the shell's launch (`SpineServices.landAnyGift`).
            Task { @MainActor in
                if let kp = GiftRouter.shared.take() { Router.shared.giftOpened(kp: kp) }
            }
        }
        completionHandler()
    }

    /// While the app is open: a gift shows as a quiet banner; the morning
    /// summons keeps its old manners and stays silent in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier.hasPrefix("gift.") {
            completionHandler([.banner, .list])
        } else {
            completionHandler([])
        }
    }
}
