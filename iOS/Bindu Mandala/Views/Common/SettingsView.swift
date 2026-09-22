import SwiftUI
import SwiftData

/// Settings — daily rhythm + field connections + bīja note.
/// Entered via the hamburger menu.
struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]

    @AppStorage("daily_summons_enabled") private var summonsEnabled = true
    @AppStorage("daily_summons_hour")    private var summonsHour: Int = DailySummons.defaultHour
    /// Debug: `OPEN_FILM` opens The Way Behind directly. The card that opens it
    /// is the fourth down a sheet that is off-screen on every width, so reaching
    /// it by touch means scrolling to a place that depends on where a flick
    /// landed — which is not a screen a test can measure twice. Same idiom as
    /// `OPEN_LETTER` / `OPEN_DETAIL` / `OPEN_SILENCE`.
    @State private var filmPresented = ProcessInfo.processInfo.arguments.contains("OPEN_FILM")

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        rhythmSection
                        fieldConnectionsSection
                        bijaSection
                        wayBehindSection
                        homecomingSection
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
                .fullScreenCover(isPresented: $filmPresented) {
                    DescentFilmView()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.custom(AppFont.cormorant, size: 19))
                        .tracking(0.6)
                        .foregroundStyle(Color.cream)
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
                Toggle(isOn: $summonsEnabled) {
                    Text("Let her arrive")
                        .font(.custom(AppFont.cormorant, size: 18))
                        .foregroundStyle(Color.cream)
                }
                .tint(Color.gold)
                .onChange(of: summonsEnabled) { _, newValue in
                    Task { await applySummonsChange(enabled: newValue) }
                }

                if summonsEnabled {
                    HStack {
                        Text("She arrives")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.cream.opacity(0.7))
                        Spacer()
                        Picker("", selection: $summonsHour) {
                            ForEach(5..<23) { hour in
                                Text(formatHour(hour)).tag(hour)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(Color.gold)
                    }
                    .onChange(of: summonsHour) { _, newHour in
                        Task { await DailySummons.reschedule(enabled: true, hour: newHour) }
                    }
                }

                Text("Once a day, never twice. If the rite is already done, she lets the evening pass in stillness.")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .foregroundStyle(Color.cream.opacity(0.55))
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
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .lineSpacing(4)
            }
        }
    }

    private var bijaSection: some View {
        sectionShell("Bīja") {
            Text("Bīja values follow Airtable when connected. When offline, the cached syllables are used. Tap any bīja in a Śakti's Detail screen to hear her tone.")
                .font(.custom(AppFont.cormorantItalic, size: 14))
                .foregroundStyle(Color.cream.opacity(0.65))
                .lineSpacing(5)
        }
    }

    private var wayBehindSection: some View {
        sectionShell("The Way Behind") {
            VStack(alignment: .leading, spacing: 14) {
                Button {
                    Haptics.soft()
                    filmPresented = true
                } label: {
                    Text("Remember the descent")
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
                Text("Each ring you have crossed, opening one by one.")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .lineSpacing(4)
            }
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
                    .foregroundStyle(Color.cream.opacity(0.55))
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
                .font(.system(size: 11.5))
                .tracking(2.2)
                .foregroundStyle(Color.gold.opacity(0.85))
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
        if let shakti = shaktis.first(where: { $0.position == position && ($0.ringNumber ?? 2) == 2 }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(shakti.cluster.color)
                        .frame(width: 6, height: 6)
                    Text(shakti.name)
                        .font(.custom(AppFont.cormorant, size: 16))
                        .foregroundStyle(Color.cream)
                    Spacer()
                }
                .padding(.bottom, 6)
                FieldNameField(
                    shakti: shakti,
                    placeholder: defaultName
                )
                Text(hint)
                    .font(.custom(AppFont.cormorantItalic, size: 12))
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .padding(.top, 4)
            }
        }
    }

    private func formatHour(_ hour: Int) -> String {
        var c = DateComponents(); c.hour = hour; c.minute = 0
        guard let d = Calendar.current.date(from: c) else { return "\(hour):00" }
        let f = DateFormatter(); f.dateFormat = "h a"
        return f.string(from: d)
    }

    private func applySummonsChange(enabled: Bool) async {
        guard enabled else {
            await DailySummons.cancelAll()
            return
        }
        switch await DailySummons.authorizationStatus() {
        case .authorized, .provisional:
            await DailySummons.reschedule(enabled: true, hour: summonsHour)
        case .notDetermined:
            if await DailySummons.requestAuthorization() {
                await DailySummons.reschedule(enabled: true, hour: summonsHour)
            } else {
                summonsEnabled = false
            }
        default:
            // Denied at system level — reflect that in the toggle.
            summonsEnabled = false
        }
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
            prompt: Text(placeholder).foregroundStyle(Color.cream.opacity(0.55))
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
        .padding(.bottom, 2)
        .frame(minHeight: 44)
        .contentShape(Rectangle())
    }
}
