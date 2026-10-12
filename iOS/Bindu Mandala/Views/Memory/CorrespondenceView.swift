import SwiftUI
import SwiftData

/// The Well as a river (Wave 5 · The Correspondence, Codex C-1346).
///
/// Upstream, letters sent **back** to moments that have already come. Downstream,
/// letters sealed **forward** to her day in the lunar cycle — sealed with no
/// peek: her name, the day it opens, and nothing of what it says. When the day
/// comes the letter glows; opened, it is revealed word by word. Every page
/// yellows by real time.
///
/// Nothing here writes a word for him, and nothing answers. There is no reply.
/// The Well's own letters — one per Śakti, edited in place — are untouched and
/// live where they always have; the river runs beside them.
struct CorrespondenceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    @State private var composing = false
    @State private var reading: RiverLetter?
    @State private var revealAnimated = false
    // Wave 6 · light sent back, and the name kept in Bindu memory.
    @State private var sendingLight = false
    @State private var keepingName = false

    private var store: CorrespondenceStore { CorrespondenceStore.shared }

    private var byPosition: [Int: Shakti] {
        var m: [Int: Shakti] = [:]
        for s in shaktis { if let kp = s.khadgamalaPosition { m[kp] = s } }
        return m
    }

    var body: some View {
        let now = Date()
        let letters = store.letters
        let sealed = letters.filter { $0.isSealed(at: now) }.sorted { $0.addressedTo < $1.addressedTo }
        let due = letters.filter { $0.isDue(at: now) }.sorted { $0.addressedTo < $1.addressedTo }
        let flowing = letters.filter { $0.isReadable(at: now) }.sorted { $0.addressedTo > $1.addressedTo }
        let people = byPosition

        ZStack {
            LinearGradient(colors: [Color(red: 0.05, green: 0.04, blue: 0.09), Color.ground],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            RiverCurrent()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        if !due.isEmpty {
                            section("her day has come")
                            ForEach(due) { letter in
                                Button {
                                    Haptics.medium()
                                    if store.open(letter.id) {
                                        revealAnimated = true
                                        reading = letter
                                        let ctx = context
                                        Task { await PracticeLedger.flush(context: ctx) }
                                    }
                                } label: {
                                    sealedCard(letter, shakti: people[letter.khadgamalaPosition], due: true)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        if !sealed.isEmpty {
                            section("sealed, downstream")
                            ForEach(sealed) { letter in
                                sealedCard(letter, shakti: people[letter.khadgamalaPosition], due: false)
                            }
                        }
                        if !flowing.isEmpty {
                            section("the river")
                            ForEach(flowing) { letter in
                                Button {
                                    Haptics.light()
                                    revealAnimated = false
                                    reading = letter
                                } label: {
                                    pageCard(letter, shakti: people[letter.khadgamalaPosition], now: now)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        if !store.lights.isEmpty {
                            section("light sent back")
                            ForEach(store.lights.sorted { $0.moment > $1.moment }) { light in
                                LightSentBackCard(light: light, shakti: people[light.khadgamalaPosition])
                            }
                        }
                        if letters.isEmpty {
                            Text("Write to her at a moment that has passed, or seal a letter forward to her day. It waits, unopened, until the moon brings it round.")
                                .font(AppFont.voice(17))
                                .foregroundStyle(Color.cream.opacity(0.65))
                                .lineSpacing(5)
                                .padding(.top, 30)
                        }
                        Color.clear.frame(height: 24)
                    }
                    .padding(.horizontal, 22)
                }
                writeButton
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $composing) {
            RiverComposer(shaktis: shaktis)
        }
        .sheet(isPresented: $sendingLight) {
            SendLightBackView(shaktis: shaktis)
        }
        .sheet(isPresented: $keepingName) {
            HigherSelfNameView()
        }
        .fullScreenCover(item: $reading) { letter in
            let s = people[letter.khadgamalaPosition]
            LetterRevealView(letter: letter,
                             name: (letter.recipient == nil || letter.recipient?.kind == .her)
                                ? (s?.name ?? "her")
                                : String(RiverWords.heading(letter, herName: s?.name).dropFirst(3)),
                             accent: s.map { SeatLighting.accentBright(for: $0) } ?? Color.gold,
                             animated: revealAnimated)
        }
        .onAppear {
            let ctx = context
            Task { await PracticeLedger.flush(context: ctx) }
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            HStack {
                Button(action: { dismiss() }) {
                    Text("‹ back")
                        .font(AppFont.voice(16))
                        .foregroundStyle(Color.gold)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, 20)
            Text("The River")
                .font(AppFont.sanskrit(30))
                .tracking(1.4)
                .foregroundStyle(Color.gold)
            Text("letters back to a moment, and forward to her day".uppercased())
                .font(AppFont.label(11))
                .tracking(2.0)
                .foregroundStyle(Color.cream.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            // Wave 6 · light, not words, sent back; and the name he keeps.
            HStack(spacing: 18) {
                Button {
                    Haptics.light()
                    sendingLight = true
                } label: {
                    Text("send light back ›")
                        .font(AppFont.voice(15))
                        .foregroundStyle(Color.gold.opacity(0.85))
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Button {
                    Haptics.light()
                    keepingName = true
                } label: {
                    Text(BinduMemory.shared.higherSelfName == nil ? "a name, kept ›" : "the name you keep ›")
                        .font(AppFont.voice(15))
                        .foregroundStyle(Color.gold.opacity(0.85))
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.bottom, 14)
    }

    private func section(_ words: String) -> some View {
        Text(words.uppercased())
            .font(AppFont.label(11))
            .tracking(2.4)
            .foregroundStyle(Color.gold.opacity(0.8))
            .padding(.top, 12)
    }

    /// A sealed letter: her light, her name, the day it opens — and nothing of
    /// what it says.
    private func sealedCard(_ letter: RiverLetter, shakti: Shakti?, due: Bool) -> some View {
        let accent = shakti.map { SeatLighting.accentBright(for: $0) } ?? Color.gold
        return HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [accent.opacity(due ? 0.9 : 0.45), .clear],
                                         center: .center, startRadius: 0, endRadius: 24))
                    .frame(width: 48, height: 48)
                Circle()
                    .fill(accent.opacity(due ? 1 : 0.7))
                    .frame(width: 18, height: 18)
                Circle()
                    .stroke(Color.cream.opacity(0.6), lineWidth: 0.6)
                    .frame(width: 24, height: 24)
            }
            .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(shakti?.name ?? "A Śakti")
                    .font(AppFont.sanskrit(19))
                    .foregroundStyle(Color.cream)
                Text(due ? "Her day has come. Open it." : RiverWords.opens(letter))
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.cream.opacity(due ? 0.85 : 0.6))
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(due ? 0.07 : 0.035))
        )
        .shadow(color: due ? accent.opacity(0.5) : .clear, radius: due ? 18 : 0)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }

    /// A page in the river, yellowing by real time.
    private func pageCard(_ letter: RiverLetter, shakti: Shakti?, now: Date) -> some View {
        let patina = letter.patina(at: now)
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(RiverWords.heading(letter, herName: shakti?.name))
                    .font(AppFont.sanskrit(18))
                    .foregroundStyle(Color.cream)
                Spacer()
                Text(RiverWords.whereItWent(letter))
                    .font(AppFont.label(11))
                    .tracking(1.2)
                    .foregroundStyle(Color.cream.opacity(0.55))
            }
            Text(letter.body)
                .font(AppFont.voice(16))
                .foregroundStyle(Color.cream.opacity(0.8))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(red: 0.12, green: 0.08, blue: 0.07))
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(RiverWords.patinaTint.opacity(0.32 * patina))
            }
        )
        .contentShape(Rectangle())
    }

    private var writeButton: some View {
        Button {
            Haptics.medium()
            composing = true
        } label: {
            Text("write a letter")
                .font(AppFont.sanskrit(20))
                .tracking(1.6)
                .foregroundStyle(Color.cream)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 54)
                .background(Capsule().fill(Color.accentRed))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 26)
        .padding(.vertical, 12)
    }
}

/// The river's few composed phrases, kept in one place.
enum RiverWords {
    /// The colour old paper turns.
    static let patinaTint = Color(red: 0.62, green: 0.46, blue: 0.2)

    static func day(_ date: Date) -> String {
        DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
    }

    static func opens(_ letter: RiverLetter) -> String {
        let when = letter.opening?.words ?? "her day"
        return "Sealed · opens on \(when), \(day(letter.addressedTo))"
    }

    /// Wave 6 · whom a page is to: her name, or "to myself at nine", "to a
    /// memory", "to my later self".
    static func heading(_ letter: RiverLetter, herName: String?) -> String {
        guard let r = letter.recipient, r.kind != .her else { return herName ?? "A Śakti" }
        return r.heading(herName: herName ?? "her")
    }

    static func whereItWent(_ letter: RiverLetter) -> String {
        switch letter.direction {
        case .back:    return "sent back to " + day(letter.addressedTo)
        case .forward: return "opened " + day(letter.openedAt ?? letter.addressedTo)
        }
    }
}

/// Slow light moving downstream behind the letters.
private struct RiverCurrent: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(minimumInterval: nil, paused: reduceMotion)) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                ctx.blendMode = .plusLighter
                for i in 0..<7 {
                    let phase = Double(i) * 0.9
                    var path = Path()
                    let baseX = size.width * (0.1 + 0.13 * CGFloat(i))
                    path.move(to: CGPoint(x: baseX, y: -20))
                    var y: CGFloat = -20
                    while y < size.height + 20 {
                        y += 18
                        let x = baseX + 22 * CGFloat(sin(Double(y) / 90 + t * 0.25 + phase))
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    ctx.stroke(path, with: .color(Color(red: 0.45, green: 0.55, blue: 0.85).opacity(0.05)),
                               lineWidth: 10)
                }
            }
        }
    }
}

/// Writing to her. Forward letters are sealed to her day; back letters go to a
/// moment already passed. What he types is kept as a draft until it is set
/// down, so a dismissed sheet or a killed app loses nothing.
struct RiverComposer: View {
    let shaktis: [Shakti]

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    @State private var kp: Int = DailyEnergyService.todaysPosition()
    @State private var direction: RiverLetter.Direction = .forward
    @State private var opening: RiverLetter.Opening = .purnima
    @State private var moment: Date = Date().addingTimeInterval(-86_400)
    @State private var words: String = ""
    @State private var loaded = false
    @State private var saveTask: Task<Void, Never>?
    @FocusState private var focused: Bool
    // Wave 6 · who it is to, and his voice.
    @State private var recipientKind: RiverRecipient.Kind = .her
    @State private var age: Int = 9
    @State private var voiceFile: String?
    @StateObject private var capture = SpeechCapture()

    private var recipient: RiverRecipient {
        recipientKind == .age ? RiverRecipient(kind: .age, age: age) : RiverRecipient(kind: recipientKind)
    }

    private var placeholder: String {
        switch recipientKind {
        case .her:       return "Speak to her directly. She is listening."
        case .age:       return "Speak to yourself at that age."
        case .memory:    return "Name the memory in your first line, then speak to it."
        case .pastSelf:  return "Speak to the one you were."
        case .laterSelf: return "Speak to the one you are becoming."
        }
    }

    private var store: CorrespondenceStore { CorrespondenceStore.shared }

    private var opensOn: String {
        RiverWords.day(RiverLetter.openingInstant(opening, khadgamalaPosition: kp, after: .now))
    }

    private var canSet: Bool { CorrespondenceStore.hasSomething(body: words, voiceFile: voiceFile) }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.05, blue: 0.07).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Picker("Which way", selection: $direction) {
                            Text("forward to her day").tag(RiverLetter.Direction.forward)
                            Text("back to a moment").tag(RiverLetter.Direction.back)
                        }
                        .pickerStyle(.segmented)

                        // Wave 6 · her, or himself at an age, a memory, a self.
                        HStack {
                            Text("to")
                                .font(AppFont.voice(16))
                                .foregroundStyle(Color.cream.opacity(0.7))
                            Picker("To whom", selection: $recipientKind) {
                                ForEach(RiverRecipient.Kind.allCases.filter { $0.allows(direction) }) { k in
                                    Text(k.words).tag(k)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color.gold)
                            Spacer(minLength: 0)
                        }
                        if recipientKind == .age {
                            Stepper(value: $age, in: 0...120) {
                                Text("myself at \(ActivityLedger.spelled(age))")
                                    .font(AppFont.voice(16))
                                    .foregroundStyle(Color.cream.opacity(0.8))
                            }
                            .tint(Color.gold)
                        }

                        HStack {
                            Text(recipientKind == .her ? "her" : "in the river of")
                                .font(AppFont.voice(16))
                                .foregroundStyle(Color.cream.opacity(0.7))
                            Picker("To her", selection: $kp) {
                                ForEach(shaktis) { s in
                                    if let p = s.khadgamalaPosition {
                                        Text(s.name).tag(p)
                                    }
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color.gold)
                            Spacer(minLength: 0)
                        }

                        if direction == .forward {
                            VStack(alignment: .leading, spacing: 8) {
                                Picker("When it opens", selection: $opening) {
                                    ForEach(RiverLetter.Opening.allCases) { o in
                                        Text(o.words).tag(o)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color.gold)
                                Text("It will open on \(opensOn), and not before.")
                                    .font(AppFont.voice(14))
                                    .foregroundStyle(Color.cream.opacity(0.6))
                            }
                        } else {
                            DatePicker("The moment", selection: $moment, in: ...Date(),
                                       displayedComponents: [.date, .hourAndMinute])
                                .tint(Color.gold)
                                .font(AppFont.voice(16))
                                .foregroundStyle(Color.cream.opacity(0.8))
                        }

                        ZStack(alignment: .topLeading) {
                            if words.isEmpty {
                                Text(placeholder)
                                    .font(AppFont.voice(19))
                                    .foregroundStyle(Color.cream.opacity(0.5))
                                    .padding(.horizontal, 6)
                                    .padding(.top, 9)
                                    .allowsHitTesting(false)
                            }
                            TextEditor(text: $words)
                                .focused($focused)
                                .font(AppFont.sanskrit(19))
                                .foregroundStyle(Color.cream.opacity(0.92))
                                .tint(Color.gold)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 260)
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.04)))

                        // Wave 6 · a voice letter: his voice kept, his words
                        // laid on the page to read and correct.
                        HStack {
                            VoiceWordButton(capture: capture) { file, heard in
                                voiceFile = file
                                let h = heard.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !h.isEmpty {
                                    words = words.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                        ? h : words + "\n" + h
                                }
                                scheduleDraftSave()
                            }
                            Spacer(minLength: 0)
                            if let f = voiceFile { VoicePlayButton(file: f) }
                        }

                        Button(action: setDown) {
                            Text(direction == .forward ? "seal it forward" : "send it back")
                                .font(AppFont.sanskrit(20))
                                .tracking(1.4)
                                .foregroundStyle(Color.cream.opacity(canSet ? 1 : 0.5))
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 54)
                                .background(Capsule().fill(Color.accentRed.opacity(canSet ? 1 : 0.4)))
                        }
                        .buttonStyle(.plain)
                        .disabled(!canSet)

                        if direction == .forward {
                            Text("Once sealed, it cannot be read or changed until its day. There is no peek.")
                                .font(AppFont.voice(13))
                                .foregroundStyle(Color.cream.opacity(0.55))
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("A letter in the river")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Keep for later") {
                        saveDraftNow()
                        dismiss()
                    }
                    .tint(Color.gold)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: load)
        .onChange(of: words) { _, _ in scheduleDraftSave() }
        .onChange(of: kp) { _, _ in scheduleDraftSave() }
        .onChange(of: direction) { _, d in
            if !recipientKind.allows(d) { recipientKind = .her }
            scheduleDraftSave()
        }
        .onChange(of: recipientKind) { _, _ in scheduleDraftSave() }
        .onChange(of: age) { _, _ in scheduleDraftSave() }
        .onChange(of: opening) { _, _ in scheduleDraftSave() }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { saveDraftNow() }
        }
        .onDisappear {
            capture.abandon()
            saveDraftNow()
        }
    }

    private func load() {
        guard !loaded else { return }
        loaded = true
        if let d = store.draft {
            kp = d.khadgamalaPosition
            direction = d.direction
            opening = d.opening
            moment = min(d.addressedTo, Date())
            words = d.body
            if let r = d.recipient {
                recipientKind = r.kind
                if let a = r.age { age = a }
            }
            voiceFile = d.voiceFile
        }
    }

    private func scheduleDraftSave() {
        guard loaded else { return }
        saveTask?.cancel()
        saveTask = Task {
            try? await Task.sleep(for: .seconds(2))
            if !Task.isCancelled { await MainActor.run { saveDraftNow() } }
        }
    }

    /// Keep what he has typed. An empty page is no draft.
    private func saveDraftNow() {
        saveTask?.cancel()
        guard loaded else { return }
        if !CorrespondenceStore.hasSomething(body: words, voiceFile: voiceFile) {
            store.saveDraft(nil)
        } else {
            store.saveDraft(RiverDraft(khadgamalaPosition: kp, direction: direction,
                                       body: words, opening: opening, addressedTo: moment,
                                       recipient: recipient, voiceFile: voiceFile))
        }
    }

    private func setDown() {
        guard canSet else { return }
        saveTask?.cancel()
        Haptics.medium()
        let set: RiverLetter?
        switch direction {
        case .forward: set = store.seal(body: words, to: kp, opening: opening,
                                        recipient: recipient, voiceFile: voiceFile)
        case .back:    set = store.sendBack(body: words, to: kp, moment: moment,
                                            recipient: recipient, voiceFile: voiceFile)
        }
        guard set != nil else { return }
        words = ""
        voiceFile = nil
        let ctx = context
        Task { await PracticeLedger.flush(context: ctx) }
        dismiss()
    }
}

/// A letter read. Opened on its day, it arrives word by word; a page already
/// in the river is simply there. A touch shows the rest at once.
struct LetterRevealView: View {
    let letter: RiverLetter
    let name: String
    let accent: Color
    let animated: Bool

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shown = 0

    private var tokens: [String] {
        letter.body.split(separator: " ", omittingEmptySubsequences: false).map(String.init)
    }

    private var revealed: String { tokens.prefix(shown).joined(separator: " ") }

    var body: some View {
        let patina = letter.patina(at: Date())
        ZStack {
            Color(red: 0.1, green: 0.07, blue: 0.06).ignoresSafeArea()
            RiverWords.patinaTint.opacity(0.3 * patina).ignoresSafeArea()
            RadialGradient(colors: [accent.opacity(0.25), .clear], center: .top,
                           startRadius: 0, endRadius: 420)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Text("‹ the river")
                            .font(AppFont.voice(16))
                            .foregroundStyle(Color.gold)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("to \(name)")
                            .font(AppFont.sanskrit(24))
                            .foregroundStyle(accent)
                        // Wave 6 · a voice letter: his own voice, heard again.
                        if let f = letter.voiceFile, SpeechCapture.exists(f) {
                            VoicePlayButton(file: f)
                        }
                        Text(revealed)
                            .font(AppFont.sanskrit(20))
                            .foregroundStyle(Color.cream.opacity(0.92))
                            .lineSpacing(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .animation(.easeOut(duration: 0.3), value: shown)
                    }
                    .padding(.top, 12)
                }
            }
            .padding(.horizontal, 24)
        }
        .preferredColorScheme(.dark)
        .contentShape(Rectangle())
        .onTapGesture { shown = tokens.count }
        .task {
            let all = tokens.count
            guard animated, !reduceMotion else {
                shown = all
                return
            }
            try? await Task.sleep(for: .seconds(0.8))
            while shown < all {
                if Task.isCancelled { return }
                shown += 1
                try? await Task.sleep(for: .seconds(0.24))
            }
        }
    }
}
