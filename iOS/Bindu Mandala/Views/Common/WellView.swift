import SwiftUI
import SwiftData

/// The Well — a love-letter space, one private letter per Śakti.
///
/// Brief 2.1 opened it to all nine rings: every one of the 102 can be written
/// to, grouped by ring, **Ring 2 first** (the Karṣiṇīs — Ashrey's home ring),
/// then the Bhūpura and inward to the Bindu. The ring sections follow the
/// Field's grammar (`TheHundredTwoView` / `FieldRing`): a sigil chip, the
/// Avaraṇa's name and subtitle, one ring open at a time.
///
/// Local SwiftData is the source of truth; Airtable receives what it can when
/// it can. Nothing here counts: a Śakti who has been written to glows in her
/// own light, and so does the ring that holds her — never a tally, never a total.
struct WellView: View {
    @Query(sort: \Shakti.khadgamalaPosition) private var allShaktis: [Shakti]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    @Query private var allLetters: [ShaktiLetter]

    @State private var openingFor: Shakti?
    @State private var openRing: Int? = WellView.homeRing
    @State private var didHandleLaunchArgument = false

    /// Ring 2 is the home ring and is where the Well opens; the other eight
    /// follow from the outer square inward to the point.
    private static let homeRing = 2
    private static let ringOrder = [2, 1, 3, 4, 5, 6, 7, 8, 9]

    /// Pre-sync legacy rows carry no ring but are always Karṣiṇīs (Ring 2) —
    /// the same assumption the Field makes.
    private var shaktisByRing: [Int: [Shakti]] {
        Dictionary(grouping: allShaktis) { $0.ringNumber ?? 2 }
    }

    /// Khaḍgamālā position → the letter's first line that actually has words in
    /// it. Absent means never written: the presence of a key *is* the "she has
    /// been spoken to" signal, so no caller ever needs a count. One look-up
    /// across the whole list, and reading it inserts nothing.
    private var writtenLines: [Int: String] {
        var m: [Int: String] = [:]
        for letter in allLetters {
            guard let line = letter.body
                .split(whereSeparator: \.isNewline)
                .first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty })
                .map(String.init) else { continue }
            if m[letter.khadgamalaPosition] == nil { m[letter.khadgamalaPosition] = line }
        }
        return m
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
                        // Eager, not lazy: only the open ring materialises rows
                        // (nine headers + at most twenty-eight seats), and a
                        // `LazyVStack` guessing at the unbuilt sections' heights
                        // overshoots on a fling and parks the Well on a blank
                        // screen. Cheap here, and the scroll is then exact.
                        VStack(spacing: 0) {
                            let lines = writtenLines
                            ForEach(Self.ringOrder, id: \.self) { ring in
                                let seats = (shaktisByRing[ring] ?? [])
                                    .sorted { $0.position < $1.position }
                                if !seats.isEmpty {
                                    WellRing(
                                        ring: ring,
                                        avarana: avaranas.first(where: { $0.ringNumber == ring }),
                                        seats: seats,
                                        ringAtmo: Atmosphere.derive(from: seats[0]),
                                        writtenLines: lines,
                                        open: openRing == ring,
                                        onToggle: {
                                            Haptics.light()
                                            withAnimation(.easeInOut(duration: 0.34)) {
                                                openRing = (openRing == ring) ? nil : ring
                                            }
                                        },
                                        onOpenLetter: { Haptics.light(); openingFor = $0 }
                                    )
                                }
                            }
                            Color.clear.frame(height: 32)
                        }
                    }
                }
            }
            .navigationDestination(item: $openingFor) { shakti in
                LetterEditorView(shakti: shakti)
            }
            .onAppear(perform: openLetterFromLaunchArgument)
        }
    }

    /// Debug: `OPEN_LETTER=<kp>` opens that Śakti's letter editor directly.
    /// Since Brief 2.1 the value is a **Khaḍgamālā position (1–102)** — the same
    /// global identity the letter itself is keyed by — not the old Ring-2
    /// per-ring index. Her ring is opened behind the editor, so dismissing it
    /// lands in the section she came from. It fires **once** per launch: the
    /// Well's `onAppear` runs again every time the editor is dismissed, and
    /// without the guard the argument would push her letter straight back and
    /// the practitioner could never leave.
    private func openLetterFromLaunchArgument() {
        guard !didHandleLaunchArgument else { return }
        didHandleLaunchArgument = true
        guard let arg = ProcessInfo.processInfo.arguments
                .first(where: { $0.hasPrefix("OPEN_LETTER=") }),
              let kp = Int(arg.dropFirst("OPEN_LETTER=".count)),
              (1...KhadgamalaMap.total).contains(kp),
              let s = allShaktis.first(where: { $0.letterKey == kp }) else { return }
        openRing = s.ringNumber ?? 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { openingFor = s }
    }

    private var header: some View {
        VStack(spacing: 6) {
            // The title keeps clear of the hamburger's lane on both sides (it
            // ran into it on the SE), shrinking rather than colliding.
            Text("Your Letters to Them")
                .font(.custom(AppFont.cormorant, size: 30))
                .tracking(1.6)
                .foregroundStyle(Color.gold)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .padding(.horizontal, 52)
            Text("Speak to her directly. She is listening.".uppercased())
                .font(.system(size: 11))
                .tracking(2.4)
                .foregroundStyle(Color.cream.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
        .padding(.bottom, 16)
        .overlay(Rectangle().fill(Color.gold.opacity(0.10)).frame(height: 0.5), alignment: .bottom)
    }
}

// MARK: - One ring of the Well (accordion section)

/// A ring of the Well. The header is the Avaraṇa in the app's existing idiom —
/// her sigil, her Sanskrit name, her subtitle — and carries a single dot when
/// the ring holds writing. That dot is a presence, not a quantity: it says only
/// "your words live in here", never how many.
private struct WellRing: View {
    let ring: Int
    let avarana: Avarana?
    let seats: [Shakti]
    let ringAtmo: Atmosphere
    let writtenLines: [Int: String]
    let open: Bool
    let onToggle: () -> Void
    let onOpenLetter: (Shakti) -> Void

    private var holdsWriting: Bool {
        seats.contains { writtenLines[$0.letterKey] != nil }
    }

    var body: some View {
        VStack(spacing: 0) {
            ringHeader
            if open { seatList }
        }
        .overlay(Rectangle().fill(Color.gold.opacity(0.10)).frame(height: 0.5), alignment: .bottom)
    }

    private var ringHeader: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(RadialGradient(gradient: Gradient(colors: [ringAtmo.accentFaint, .clear]),
                                             center: .center, startRadius: 0, endRadius: 24))
                    RiteSigil(atmosphere: ringAtmo, ring: ring, size: 44,
                              spin: ring % 2 == 1 ? 1 : -1)
                        .opacity(open ? 0.9 : 0.5)
                }
                .frame(width: 48, height: 48)
                .shadow(color: open ? ringAtmo.glow : .clear, radius: open ? 16 : 0)
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 10) {
                        Text(ringName)
                            .font(.custom(AppFont.cormorant, size: 21))
                            .tracking(0.6)
                            .foregroundStyle(open ? ringAtmo.accentBright : Color.cream)
                        if holdsWriting {
                            Circle()
                                .fill(ringAtmo.accentBright)
                                .frame(width: 7, height: 7)
                                .shadow(color: ringAtmo.accentBright, radius: 5)
                        }
                    }
                    if let sub = avarana?.subtitle, !sub.isEmpty {
                        Text(sub)
                            .font(.custom(AppFont.cormorantItalic, size: 14.5))
                            .foregroundStyle(Color.cream.opacity(0.55))
                    }
                }
                Spacer(minLength: 8)

                Text("›")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.cream.opacity(0.5))
                    .rotationEffect(.degrees(open ? 90 : 0))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(
                open
                ? LinearGradient(colors: [ringAtmo.accentFaint, .clear],
                                 startPoint: .leading, endPoint: .trailing)
                : LinearGradient(colors: [.clear, .clear], startPoint: .leading, endPoint: .trailing)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(ringName + (holdsWriting ? ", holds your letters" : ""))
        .accessibilityHint(open ? "Collapse this ring" : "Open this ring")
    }

    private var seatList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(seats) { seat in
                Button {
                    onOpenLetter(seat)
                } label: {
                    row(for: seat)
                }
                .buttonStyle(.plain)
                if seat.id != seats.last?.id {
                    Rectangle()
                        .fill(Color.gold.opacity(0.06))
                        .frame(height: 0.5)
                        .padding(.leading, 43)
                }
            }
        }
        .padding(.bottom, 10)
        .background(LinearGradient(colors: [ringAtmo.groundDeep.opacity(0.9), .clear],
                                   startPoint: .top, endPoint: .bottom))
    }

    /// One Śakti's row. Her dot carries her own light — the cluster hue for the
    /// sixteen, her ring's hue for the other eighty-six (`Atmosphere.derive`
    /// already refuses to leak the 86's default cluster) — and brightens when
    /// she has been written to. The line beneath is the practitioner's own first
    /// line, never generated, never seeded.
    private func row(for shakti: Shakti) -> some View {
        let sAtmo = Atmosphere.derive(from: shakti)
        let firstLine = writtenLines[shakti.letterKey]
        let written = firstLine != nil
        return HStack(alignment: .top, spacing: 14) {
            Circle()
                .fill(sAtmo.accent)
                .frame(width: 7, height: 7)
                .opacity(written ? 1 : 0.4)
                .shadow(color: written ? sAtmo.accentBright : .clear, radius: written ? 6 : 0)
                .padding(.top, 8)
            VStack(alignment: .leading, spacing: 4) {
                Text(shakti.name)
                    .font(.custom(AppFont.cormorant, size: 20))
                    .tracking(1.0)
                    .foregroundStyle(Color.cream)
                if let firstLine {
                    Text(firstLine)
                        .font(.custom(AppFont.cormorantItalic, size: 14))
                        .foregroundStyle(Color.cream.opacity(0.6))
                        .lineLimit(2)
                } else {
                    Text("You can speak to her here")
                        .font(.custom(AppFont.cormorantItalic, size: 14))
                        .foregroundStyle(Color.cream.opacity(0.5))
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.system(size: 11))
                .foregroundStyle(Color.cream.opacity(0.3))
                .padding(.top, 12)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .contentShape(Rectangle())
        // Law 2: written is a warmth, never a number.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(spokenName(shakti) + (written ? ", written to" : ", not yet written to"))
    }

    /// The 86 carry no phonetic (FIDELITY rule 6) — fall back to her name
    /// rather than announcing an empty string.
    private func spokenName(_ s: Shakti) -> String {
        let p = s.phonetic.trimmingCharacters(in: .whitespacesAndNewlines)
        return p.isEmpty ? s.name : p
    }

    private var ringName: String {
        if let raw = avarana?.sanskritName.trimmingCharacters(in: .whitespaces), !raw.isEmpty {
            return raw
        }
        return "\(ordinal(ring)) Avaraṇa"
    }

    private func ordinal(_ n: Int) -> String {
        switch n {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        default: return "\(n)th"
        }
    }
}

/// Full-screen editor for one letter. Surface background, cream Cormorant.
/// Auto-saves 5s after the last keystroke and on dismiss — but only when the
/// text differs from what was last saved (`LetterDraft.isDirty`). Merely
/// opening a letter is not an edit and writes nothing, locally or to Airtable.
struct LetterEditorView: View {
    @Bindable var shakti: Shakti
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    /// Saved baseline + live text; dirty iff they differ — see `LetterDraft`.
    @State private var draft = LetterDraft()
    @State private var loaded = false
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
                    if draft.text.isEmpty {
                        Text("Speak to her directly. She is listening.")
                            .font(.custom(AppFont.cormorantItalic, size: 19))
                            .foregroundStyle(Color.cream.opacity(0.28))
                            .padding(.horizontal, 26)
                            .padding(.top, 18)
                            .allowsHitTesting(false)
                    }
                    TextEditor(text: $draft.text)
                        .focused($focused)
                        .font(.custom(AppFont.cormorant, size: 19))
                        .foregroundStyle(Color.cream.opacity(0.92))
                        .tint(Color.gold)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .onChange(of: draft.text) { _, _ in
                            // Dirty means the practitioner typed: the text differs
                            // from the saved baseline. `load()` sets both sides at
                            // once, so opening a letter never schedules a save.
                            guard draft.isDirty else { return }
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
            // Her own light, mirroring the back button's width. Her atmosphere,
            // not her cluster — the 86 have no real cluster (FIDELITY rule 6),
            // and `Atmosphere.derive` already falls to the ring hue for them.
            Circle()
                .fill(atmo.accent)
                .frame(width: 7, height: 7)
                .shadow(color: atmo.accentBright, radius: 4)
                .frame(width: 64, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 12)
        .overlay(Rectangle().fill(Color.gold.opacity(0.12)).frame(height: 0.5), alignment: .bottom)
    }

    private func load() {
        guard !loaded else { return }   // onAppear can fire again; never clobber the draft
        // Read-only: no row is inserted for a letter never written. The insert
        // belongs to `saveIfNeeded`, so opening leaves the store untouched and
        // a blank row can never block her server letter from seeding.
        let body = LetterStore(context: context).existingLetter(for: shakti.letterKey)?.body ?? ""
        draft = LetterDraft(saved: body)   // text == saved, so this is not an edit
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
        guard draft.isDirty else { return }
        saveTask?.cancel()

        let store = LetterStore(context: context)
        let letter = store.letter(for: shakti.letterKey)
        store.save(letter, body: draft.text)
        draft.markSaved()

        // Fire-and-forget Airtable PATCH. Failure is silent; queued for retry.
        let s = shakti
        let body = draft.text
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
