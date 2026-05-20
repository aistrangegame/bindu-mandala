import Foundation
import UserNotifications

/// Schedules her quiet notifications — never to pull the user toward the app,
/// only to arrive with her rhythm.
@MainActor
enum NotificationsService {

    static func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            return false
        }
    }

    /// Reschedule all notifications based on current settings.
    /// Clears any previously scheduled "her" notifications first.
    static func reschedule(startHour: Int, intervalHours: Int) async {
        let center = UNUserNotificationCenter.current()
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter { $0.hasPrefix("her.") }
        center.removePendingNotificationRequests(withIdentifiers: ids)

        guard intervalHours > 0 else { return }

        // Schedule one notification per slot per day, for the next 7 days.
        var date = Date()
        let cal = Calendar.current
        for dayOffset in 0..<7 {
            guard let day = cal.date(byAdding: .day, value: dayOffset, to: date) else { continue }
            var hour = startHour
            while hour < 22 {
                var components = cal.dateComponents([.year, .month, .day], from: day)
                components.hour = hour
                components.minute = 0
                if let when = cal.date(from: components), when > Date() {
                    let content = UNMutableNotificationContent()
                    content.title = "she is here"
                    content.body = "where do you feel her right now"
                    content.sound = nil  // arrive without sound, unless silent ring requires it
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    let req = UNNotificationRequest(
                        identifier: "her.\(dayOffset).\(hour)",
                        content: content,
                        trigger: trigger
                    )
                    try? await center.add(req)
                }
                hour += intervalHours
            }
            date = day
        }
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
