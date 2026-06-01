import Foundation
import UserNotifications

/// One tender summons per day, ever. She arrives at a practitioner-chosen
/// hour (default 6 PM). If the rite was already done today, today's summons
/// is dropped — never a second nudge. No sound, no badge, no count.
///
/// Persistence:
///   • `daily_summons_enabled` (AppStorage) — toggle, default true.
///   • `daily_summons_hour`    (AppStorage) — 0–23, default 18.
///   • `daily_summons_last_rite_completed` (UserDefaults, TimeInterval) —
///     read here to skip today's summons when the rite is already done.
@MainActor
enum DailySummons {

    static let defaultHour = 18
    static let idPrefix = "summons."

    private static let lastRiteKey = "daily_summons_last_rite_completed"

    // MARK: - Authorization

    /// Returns true if the system would currently deliver our notifications.
    /// Honored even when the practitioner has flipped the in-app toggle off.
    static func authorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    /// Ask once. Quiet — alert only, no sound, no badge.
    static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert])
        } catch {
            return false
        }
    }

    // MARK: - Rite completion (the "skip today" signal)

    static func markRiteCompleted(at date: Date = .now) {
        UserDefaults.standard.set(date.timeIntervalSinceReferenceDate, forKey: lastRiteKey)
        // After a rite, today's pending summons should disappear in stillness.
        Task { await reschedule() }
    }

    static func lastRiteCompleted() -> Date? {
        let ts = UserDefaults.standard.double(forKey: lastRiteKey)
        return ts > 0 ? Date(timeIntervalSinceReferenceDate: ts) : nil
    }

    static func riteCompletedToday(calendar: Calendar = .current) -> Bool {
        guard let last = lastRiteCompleted() else { return false }
        return calendar.isDateInToday(last)
    }

    // MARK: - Scheduling

    /// Tear down all pending summons.
    static func cancelAll() async {
        let center = UNUserNotificationCenter.current()
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter { $0.hasPrefix(idPrefix) }
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    /// Reschedule the rolling 14-day window from current AppStorage state.
    /// Safe to call any time — clears prior summons first.
    /// If the toggle is off or authorization isn't granted, leaves the
    /// schedule empty.
    static func reschedule() async {
        let defaults = UserDefaults.standard
        let enabled = (defaults.object(forKey: "daily_summons_enabled") as? Bool) ?? true
        let hour = defaults.object(forKey: "daily_summons_hour") as? Int ?? defaultHour
        await reschedule(enabled: enabled, hour: hour)
    }

    /// Explicit form used by Settings when the toggle or hour just changed —
    /// the AppStorage write may not have flushed by the time we re-read it.
    static func reschedule(enabled: Bool, hour: Int) async {
        let center = UNUserNotificationCenter.current()

        // Always start clean.
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter { $0.hasPrefix(idPrefix) }
        center.removePendingNotificationRequests(withIdentifiers: ids)

        guard enabled else { return }

        let status = await authorizationStatus()
        guard status == .authorized || status == .provisional else { return }

        let cal = Calendar.current
        let now = Date()
        let safeHour = max(0, min(23, hour))

        for dayOffset in 0..<14 {
            guard let day = cal.date(byAdding: .day, value: dayOffset, to: now) else { continue }
            var comps = cal.dateComponents([.year, .month, .day], from: day)
            comps.hour = safeHour
            comps.minute = 0

            guard let when = cal.date(from: comps) else { continue }
            // Don't schedule a moment that has already passed.
            if when <= now { continue }
            // If the rite was already done today, drop today's summons.
            if cal.isDateInToday(when) && riteCompletedToday(calendar: cal) { continue }

            let content = UNMutableNotificationContent()
            content.title = "She is waiting."
            // No body, no sound, no badge — the title is the whole gesture.

            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let id = "\(idPrefix)\(comps.year ?? 0)-\(comps.month ?? 0)-\(comps.day ?? 0)"
            let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            try? await center.add(req)
        }
    }
}
