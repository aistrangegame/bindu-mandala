import SwiftUI
import SwiftData

/// The Well — a love-letter space, one private letter per Karṣiṇī.
/// Local SwiftData is the source of truth; Airtable receives what it can when it can.
struct WellView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Shakti.position) private var allShaktis: [Shakti]
    @Query private var allLetters: [ShaktiLetter]
    @State private var openingFor: Shakti?

    /// Only Ring 2 Karṣiṇīs receive letters. `ShaktiLetter.shaktiPosition` is
    /// `@Attribute(.unique)` over 1–16; including other rings would collide.
    private var ring2Shaktis: [Shakti] {
        allShaktis.filter { ($0.ringNumber ?? 2) == 2 }
            .sorted { $0.position < $1.position }
    }

    /// One look-up across the whole list, vs. the old code which inserted a
    /// fresh `ShaktiLetter` per rendered row just to read the preview.
    private var lettersByPosition: [Int: String] {
        Dictionary(allLetters.map { ($0.shaktiPosition, $0.body) },
                   uniquingKeysWith: { first, _ in first })
    }

    /// The Well wears today's light, like every other room.
    private var dayAtmo: Atmosphere {
        let pos = DailyEnergyService.todaysPosition()
        if let t = allShaktis.first(where: { $0.khadgamalaPosition == pos }) {
            return Atmosphere.derive(from: t, at: LunarPhaseService.currentTimeVariant())
        }
        return Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: pos,
                                 element: .ether, at: LunarPhaseService.currentTimeVariant())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [dayAtmo.ground, dayAtmo.groundDeep],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                RadialGradient(gradient: Gradient(colors: [dayAtmo.glow, .clear]),
                               center: UnitPoint(x: 0.5, y: -0.05), startRadius: 0, endRadius: 440)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    header
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(ring2Shaktis) { s in
                                Button {
                                    openingFor = s
                                } label: {
                                    row(for: s)
                                }
                                .buttonStyle(.plain)
                                Rectangle()
                                    .fill(Color.gold.opacity(0.06))
                                    .frame(height: 0.5)
                                    .padding(.leading, 32)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationDestination(item: $openingFor) { shakti in
                LetterEditorView(shakti: shakti)
            }
            .onAppear {
                // Debug: `OPEN_LETTER=<pos>` opens that Karṣiṇī's letter editor directly.
                if let arg = ProcessInfo.processInfo.arguments.first(where: { $0.hasPrefix("OPEN_LETTER=") }),
                   let pos = Int(arg.dropFirst("OPEN_LETTER=".count)),
                   let s = ring2Shaktis.first(where: { $0.position == pos }) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { openingFor = s }
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Text("Your Letters to Them")
                .font(.custom(AppFont.cormorant, size: 30))
                .tracking(1.6)
                .foregroundStyle(Color.gold)
            Text("Speak to her directly. She is listening.".uppercased())
                .font(.system(size: 10))
                .tracking(2.4)
                .foregroundStyle(Color.cream.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
        .padding(.bottom, 16)
        .overlay(Rectangle().fill(Color.gold.opacity(0.10)).frame(height: 0.5), alignment: .bottom)
    }

    private func row(for shakti: Shakti) -> some View {
        let preview = lettersByPosition[shakti.position] ?? ""
        let firstLine = preview.split(whereSeparator: \.isNewline).first.map(String.init) ?? ""
        let hasLetter = !firstLine.trimmingCharacters(in: .whitespaces).isEmpty
        return HStack(alignment: .top, spacing: 14) {
            Circle()
                .fill(shakti.cluster.color)
                .frame(width: 7, height: 7)
                .shadow(color: shakti.cluster.color, radius: 4)
                .padding(.top, 8)
            VStack(alignment: .leading, spacing: 4) {
                Text(shakti.name)
                    .font(.custom(AppFont.cormorant, size: 22))
                    .tracking(1.2)
                    .foregroundStyle(Color.cream)
                if hasLetter {
                    Text(firstLine)
                        .font(.custom(AppFont.cormorantItalic, size: 14))
                        .foregroundStyle(Color.cream.opacity(0.55))
                        .lineLimit(2)
                } else {
                    Text("You can speak to her here")
                        .font(.custom(AppFont.cormorantItalic, size: 14))
                        .foregroundStyle(Color.cream.opacity(0.32))
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.system(size: 11))
                .foregroundStyle(Color.cream.opacity(0.25))
                .padding(.top, 12)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}

/// Full-screen editor for one letter. Surface background, cream Cormorant.
/// Auto-saves 5s after the last keystroke; always saves on dismiss.
struct LetterEditorView: View {
    @Bindable var shakti: Shakti
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var draft: String = ""
    @State private var loaded = false
    @State private var dirty = false
    @State private var saveTask: Task<Void, Never>?
    @FocusState private var focused: Bool

    /// Her own atmosphere — writing to her is lit by her light, kept calm (her
    /// deep ground with only a whisper of glow, so the page stays legible).
    private var atmo: Atmosphere { Atmosphere.derive(from: shakti) }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [atmo.ground, atmo.groundDeep],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            RadialGradient(gradient: Gradient(colors: [atmo.glow.opacity(0.5), .clear]),
                           center: UnitPoint(x: 0.5, y: -0.02), startRadius: 0, endRadius: 360)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                header
                ZStack(alignment: .topLeading) {
                    if draft.isEmpty {
                        Text("Speak to her directly. She is listening.")
                            .font(.custom(AppFont.cormorantItalic, size: 19))
                            .foregroundStyle(Color.cream.opacity(0.28))
                            .padding(.horizontal, 26)
                            .padding(.top, 18)
                            .allowsHitTesting(false)
                    }
                    TextEditor(text: $draft)
                        .focused($focused)
                        .font(.custom(AppFont.cormorant, size: 19))
                        .foregroundStyle(Color.cream.opacity(0.92))
                        .tint(Color.gold)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .onChange(of: draft) { _, _ in
                            // Initial load assigns draft without going through user
                            // input — `loaded` gates the dirty flag so first-render
                            // doesn't trigger a save (and doesn't seed Airtable).
                            guard loaded else { return }
                            dirty = true
                            scheduleAutoSave()
                        }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableSwipeBack()
        .onAppear(perform: load)
        .onDisappear {
            saveTask?.cancel()
            saveIfNeeded()
        }
    }

    private var header: some View {
        HStack {
            Button(action: dismissAndSave) {
                HStack(spacing: 4) {
                    Text("‹").font(.system(size: 22, weight: .light))
                    Text("The Well").tracking(0.8)
                }
                .foregroundStyle(Color.gold)
                .font(.system(size: 14))
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Spacer()
            Text(shakti.name)
                .font(.custom(AppFont.cormorant, size: 16))
                .tracking(1.2)
                .foregroundStyle(Color.cream.opacity(0.8))
            Spacer()
            // Soft cluster dot mirror of the back button width
            Circle()
                .fill(shakti.cluster.color)
                .frame(width: 7, height: 7)
                .shadow(color: shakti.cluster.color, radius: 4)
                .frame(width: 64, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 12)
        .overlay(Rectangle().fill(Color.gold.opacity(0.12)).frame(height: 0.5), alignment: .bottom)
    }

    private func load() {
        guard !loaded else { return }
        // Read existing local body without going through the .onChange dirty path.
        draft = LetterStore(context: context).letter(for: shakti.position).body
        // Only flip `loaded` after the assignment so the .onChange this triggers
        // is ignored — initial load is not an edit.
        loaded = true
    }

    private func scheduleAutoSave() {
        saveTask?.cancel()
        saveTask = Task {
            try? await Task.sleep(for: .seconds(5))
            if !Task.isCancelled {
                await MainActor.run { saveIfNeeded() }
            }
        }
    }

    private func saveIfNeeded() {
        guard dirty else { return }
        saveTask?.cancel()

        let store = LetterStore(context: context)
        let letter = store.letter(for: shakti.position)
        store.save(letter, body: draft)
        dirty = false

        // Fire-and-forget Airtable PATCH. Failure is silent; queued for retry.
        let s = shakti
        let body = draft
        Task {
            await AirtableService.shared.saveLetter(shakti: s, body: body)
        }
    }

    private func dismissAndSave() {
        saveTask?.cancel()
        saveIfNeeded()
        dismiss()
    }
}
