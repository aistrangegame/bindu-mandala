import SwiftUI
import SwiftData

/// Settings — daily rhythm + field connections + bīja note.
/// Entered via a small gear icon in the Today header.
struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]

    @AppStorage("notifications_enabled") private var notificationsEnabled = false
    @AppStorage("notifications_start_hour") private var startHour: Int = 7
    @AppStorage("notifications_interval_hours") private var intervalHours: Int = 3

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        rhythmSection
                        fieldConnectionsSection
                        bijaSection
                        homecomingSection
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.gold)
                }
            }
            .toolbarBackground(Color.ground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Sections

    private var rhythmSection: some View {
        sectionShell("Daily Rhythm") {
            VStack(alignment: .leading, spacing: 18) {
                Toggle(isOn: $notificationsEnabled) {
                    Text("Let her arrive")
                        .font(.custom(AppFont.cormorant, size: 18))
                        .foregroundStyle(Color.cream)
                }
                .tint(Color.gold)
                .onChange(of: notificationsEnabled) { _, newValue in
                    Task { await applyNotificationChange(enabled: newValue) }
                }

                if notificationsEnabled {
                    HStack {
                        Text("First arrival")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.cream.opacity(0.7))
                        Spacer()
                        Picker("", selection: $startHour) {
                            ForEach(5..<12) { hour in
                                Text(formatHour(hour)).tag(hour)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(Color.gold)
                    }
                    .onChange(of: startHour) { _, _ in
                        Task { await rescheduleIfEnabled() }
                    }

                    HStack {
                        Text("Cadence")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.cream.opacity(0.7))
                        Spacer()
                        Picker("", selection: $intervalHours) {
                            Text("Every 3 hours").tag(3)
                            Text("Every 4 hours").tag(4)
                            Text("Every 6 hours").tag(6)
                        }
                        .pickerStyle(.menu)
                        .tint(Color.gold)
                    }
                    .onChange(of: intervalHours) { _, _ in
                        Task { await rescheduleIfEnabled() }
                    }
                }

                Text("She does not pull you toward the app. She only arrives with her rhythm.")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .foregroundStyle(Color.cream.opacity(0.4))
                    .lineSpacing(4)
            }
        }
    }

    private var fieldConnectionsSection: some View {
        sectionShell("Field Connections") {
            VStack(alignment: .leading, spacing: 18) {
                fieldRow(position: 3, defaultName: "Gaia",
                         hint: "She anchors here.")
                fieldRow(position: 12, defaultName: "Ashrey",
                         hint: "She weaves through here.")
                fieldRow(position: 14, defaultName: "Ram",
                         hint: "Holds her frequency.")
                Text("These names appear on each Śakti's Detail screen and may be edited freely. They are personal to this practitioner.")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .foregroundStyle(Color.cream.opacity(0.4))
                    .lineSpacing(4)
            }
        }
    }

    private var bijaSection: some View {
        sectionShell("Bīja") {
            Text("Bīja values follow Airtable when connected. When offline, the cached syllables are used. Tap any bīja in a Śakti's Detail screen to hear her tone.")
                .font(.custom(AppFont.cormorantItalic, size: 14))
                .foregroundStyle(Color.cream.opacity(0.55))
                .lineSpacing(5)
        }
    }

    private var homecomingSection: some View {
        sectionShell("Homecoming") {
            VStack(alignment: .leading, spacing: 14) {
                Button(action: reEnterHomecoming) {
                    Text("Re-enter the Homecoming")
                        .font(.custom(AppFont.cormorant, size: 18))
                        .tracking(0.6)
                        .foregroundStyle(Color.gold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.gold.opacity(0.5), lineWidth: 0.6)
                        )
                }
                .buttonStyle(.plain)
                Text("She will greet you again, as on the first day.")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .foregroundStyle(Color.cream.opacity(0.4))
                    .lineSpacing(4)
            }
        }
    }

    private func reEnterHomecoming() {
        Haptics.soft()
        HomecomingView.reset()
        dismiss()
    }

    // MARK: - Helpers

    private func sectionShell<Content: View>(_ title: String,
                                             @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title.uppercased())
                .font(.system(size: 10))
                .tracking(2.2)
                .foregroundStyle(Color.gold.opacity(0.7))
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.surface)
        )
    }

    @ViewBuilder
    private func fieldRow(position: Int, defaultName: String, hint: String) -> some View {
        if let shakti = shaktis.first(where: { $0.position == position }) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(shakti.cluster.color)
                        .frame(width: 6, height: 6)
                    Text(shakti.name)
                        .font(.custom(AppFont.cormorant, size: 16))
                        .foregroundStyle(Color.cream)
                    Spacer()
                }
                FieldNameField(
                    shakti: shakti,
                    placeholder: defaultName
                )
                Text(hint)
                    .font(.custom(AppFont.cormorantItalic, size: 12))
                    .foregroundStyle(Color.cream.opacity(0.35))
            }
        }
    }

    private func formatHour(_ hour: Int) -> String {
        var c = DateComponents(); c.hour = hour; c.minute = 0
        guard let d = Calendar.current.date(from: c) else { return "\(hour):00" }
        let f = DateFormatter(); f.dateFormat = "h a"
        return f.string(from: d)
    }

    private func applyNotificationChange(enabled: Bool) async {
        if enabled {
            let granted = await NotificationsService.requestAuthorization()
            if !granted {
                notificationsEnabled = false
                return
            }
            await NotificationsService.reschedule(startHour: startHour, intervalHours: intervalHours)
        } else {
            NotificationsService.cancelAll()
        }
    }

    private func rescheduleIfEnabled() async {
        guard notificationsEnabled else { return }
        await NotificationsService.reschedule(startHour: startHour, intervalHours: intervalHours)
    }
}

private struct FieldNameField: View {
    @Bindable var shakti: Shakti
    let placeholder: String
    @Environment(\.modelContext) private var context

    var body: some View {
        TextField(
            "",
            text: Binding(
                get: { shakti.fieldName ?? "" },
                set: { newValue in
                    shakti.fieldName = newValue.isEmpty ? nil : newValue
                    try? context.save()
                }
            ),
            prompt: Text(placeholder).foregroundStyle(Color.cream.opacity(0.3))
        )
        .font(.custom(AppFont.cormorant, size: 18))
        .foregroundStyle(Color.cream)
        .tint(Color.gold)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.ground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.gold.opacity(0.18), lineWidth: 0.5)
                )
        )
    }
}
