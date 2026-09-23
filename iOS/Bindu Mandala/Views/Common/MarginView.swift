import SwiftUI
import SwiftData

// MARK: - The margin — where he says what he sees
//
// *"The ability to go into the settings and leave a note … a basic text entry …
// where I can describe ideas, thoughts, anything new that I want to add onto the
// app, anything that's broken. Instead of having to come back here session by
// session and describe everything one by one, I just go through the app, go to
// the settings, record it, share what I find … and then I can save it as a new
// entry, and I can also see all of the old entries that I've done."*
//
// Two screens, both behind their own door in Settings, and the door is the law
// fix as much as it is the design. **The notes never render inline.** If they
// did, this would be the Phase 3.8 breach in a new place: Settings would grow
// with his writing, "Re-enter the Homecoming" would sink a little further with
// every note, and a VoiceOver walker — who has no flick to the foot of a scroll
// — would pass his whole correspondence to reach the last control on the sheet.
// The Settings scroll is the same length on the first day and the thousandth.
//
// And nothing stands behind the list: it is a destination, not a corridor, so a
// long scroll there costs a walker nothing he did not come for. That asymmetry
// is the whole of what made Her Moments a parity failure, and it cannot arise
// here.
//
// **Once left, a note is left.** No editing after dismissal, no delete, this
// pass. The ledger has only a POST path in this house; an editable note would
// let the phone and the body's memory disagree with no way to reconcile, and a
// delete would leave an orphan row. Read-only is also what makes the list
// honestly *his own words handed back* rather than a workspace. Both are cheap
// to add the day he reaches for them — the same "wait until he has used it"
// logic as his own text-only ruling.

/// Which note the composer currently holds open, so the background sweep never
/// posts a sentence he is still in the middle of.
///
/// `AirtableService.flushUnledgeredNotes` runs on every scene-phase `.active`,
/// which is exactly the moment he comes *back* to a composer he left open.
/// Without this it would ledger the half of the note he had typed before he was
/// interrupted, and the finished note — already stamped — would never be sent.
/// The ledger row is the only copy of a note that ever leaves the phone, so a
/// truncated one is a real loss of his words.
///
/// A flag rather than a stored property: if the process dies with the composer
/// open, the composer is gone too, and the next launch's sweep is right to take
/// the note as it stands.
@MainActor
enum MarginComposition {
    /// The note being typed into right now, if any.
    static var openNoteId: UUID?
}

/// The day's own light, which the margin's two pages wear.
///
/// FIDELITY rule 1: a page is not flat `Color.ground`. It is the Well's exact
/// idiom — today's Śakti through `Atmosphere.derive`, with the same fallback for
/// a store that has not synced her yet — because a note belongs to the day he
/// wrote it on and to no Śakti at all. Nothing here moves: the atmosphere is
/// derived once from the hour, never from a clock the view keeps.
@MainActor
enum MarginAir {
    static func today(_ shaktis: [Shakti]) -> Atmosphere {
        let pos = DailyEnergyService.todaysPosition()
        if let t = shaktis.first(where: { $0.khadgamalaPosition == pos }) {
            return Atmosphere.derive(from: t, at: LunarPhaseService.currentTimeVariant())
        }
        return Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: pos,
                                 element: .ether, at: LunarPhaseService.currentTimeVariant())
    }

    /// The page's ground and its one crowning glow, drawn the way the letter
    /// editor draws them — the glow kept to half strength so the page a walker
    /// reads and types on stays legible under it.
    @ViewBuilder
    static func ground(_ atmo: Atmosphere) -> some View {
        LinearGradient(colors: [atmo.ground, atmo.groundDeep],
                       startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        RadialGradient(gradient: Gradient(colors: [atmo.glow.opacity(0.5), .clear]),
                       center: UnitPoint(x: 0.5, y: -0.02), startRadius: 0, endRadius: 360)
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

// MARK: - The date a note carries, in ink and in a voice

/// A note's `createdAt`, said two ways.
///
/// Pure and testable, and separate from both views, because the two answers must
/// not drift: what the row prints and what VoiceOver announces are the same
/// fact, and only one of them is allowed to contain a numeral.
enum MarginDate {

    /// The ink: today · yesterday · the weekday for the past week · "MMM d".
    /// The same idiom the Detail's own `formatTimestamp` already uses, and it
    /// carries no digit *literal* in this file — the format is `DateFormatter`
    /// letters, so the laws' digit-shape scanner finds nothing to judge.
    static func written(_ d: Date, now: Date = .now, calendar: Calendar = .current) -> String {
        let df = DateFormatter()
        if calendar.isDate(d, inSameDayAs: now) { return "today" }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(d, inSameDayAs: yesterday) { return "yesterday" }
        if let weekAgo = calendar.date(byAdding: .day, value: -6, to: now), d >= weekAgo {
            df.dateFormat = "EEEE"
            return df.string(from: d).lowercased()
        }
        df.dateFormat = "MMM d"
        return df.string(from: d)
    }

    /// The voice: the same day with **no numeral in it at all**.
    ///
    /// §4.4's finding, applied to a date. A VoiceOver walker hears the month and
    /// the day as words — "September the twenty-first" — through the very
    /// ordinal table the Mandala already speaks her seat with, so the whole
    /// spoken surface of the margin has no digit anywhere in it.
    static func spoken(_ d: Date, now: Date = .now, calendar: Calendar = .current) -> String {
        if calendar.isDate(d, inSameDayAs: now) { return "Today" }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(d, inSameDayAs: yesterday) { return "Yesterday" }
        let df = DateFormatter()
        if let weekAgo = calendar.date(byAdding: .day, value: -6, to: now), d >= weekAgo {
            df.dateFormat = "EEEE"
            return df.string(from: d)
        }
        df.dateFormat = "MMMM"
        let day = calendar.component(.day, from: d)
        return "\(df.string(from: d)) the \(MandalaVoice.ordinal(day))"
    }
}

// MARK: - Leaving one

/// The composer: the letter editor's idiom, almost verbatim, because that is
/// this house's answer to *"not a form"* and it is already proven.
///
/// A full-screen page, the ground gradient, one back control, no title, no
/// fields, no category, no priority, no tags, **no Save button** — leaving the
/// page is saving. `LetterDraft` is reused unchanged, which gives the note the
/// letter's hardest-won property for free: **opening writes nothing.** The row
/// is inserted on the first keystroke that changes the text and updated
/// thereafter, never a new row per autosave, so a composer he opens and abandons
/// leaves no trace.
///
/// **Two things the letter editor does not do, and both are about not losing his
/// words.** It observes `scenePhase` and saves on `.inactive` — which fires
/// before `.background` and before the snapshot — because swiping to the home
/// screen does *not* call `onDisappear`, and a pending debounce then sits in a
/// suspended app where a force-quit or a jetsam kill takes everything typed
/// since the last autosave. And the debounce is two seconds rather than five,
/// which is the whole remaining exposure to a hard crash mid-keystroke. A
/// per-keystroke write was considered and refused: it is the wrong trade against
/// store churn, and the letter's proven idiom is the right one.
struct MarginNoteComposerView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @State private var draft = LetterDraft()
    @State private var note: MarginNote?
    @State private var saveTask: Task<Void, Never>?
    @FocusState private var focused: Bool

    /// Seconds of quiet before an autosave. Two, not the letter's five — see the
    /// type's own note.
    static let autosaveSeconds: Double = 2

    var body: some View {
        ZStack(alignment: .top) {
            MarginAir.ground(MarginAir.today(shaktis))

            VStack(spacing: 0) {
                header
                ZStack(alignment: .topLeading) {
                    if draft.text.isEmpty {
                        Text("Say what you see. It will be read.")
                            .font(AppFont.voice(19))
                            .foregroundStyle(Color.cream.opacity(0.5))
                            .padding(.horizontal, 26)
                            .padding(.top, 18)
                            .allowsHitTesting(false)
                            // Read once, by the editor's own label.
                            .accessibilityHidden(true)
                    }
                    TextEditor(text: $draft.text)
                        .focused($focused)
                        .font(AppFont.sanskrit(19))
                        .foregroundStyle(Color.cream.opacity(0.92))
                        .tint(Color.gold)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .accessibilityLabel("Your note")
                        .accessibilityHint("Type what you want to say. Leaving this page saves it.")
                        .accessibilityIdentifier("marginComposer")
                        .onChange(of: draft.text) { _, _ in
                            guard draft.isDirty else { return }
                            scheduleAutoSave()
                        }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableSwipeBack()
        .onAppear { focused = true }
        .onChange(of: scenePhase) { _, phase in
            // `.inactive` arrives before `.background` and before the snapshot;
            // `onDisappear` never arrives at all for a swipe to the home screen.
            if phase != .active { saveIfNeeded() }
        }
        .onDisappear {
            saveTask?.cancel()
            saveIfNeeded()
            MarginComposition.openNoteId = nil
            ledgerIfNeeded()
        }
    }

    private var header: some View {
        HStack {
            Button(action: leave) {
                HStack(spacing: 4) {
                    Text("‹").font(.system(size: 22, weight: .light))
                    Text("Settings").tracking(0.8)
                }
                .foregroundStyle(Color.gold)
                .font(AppFont.label(14))
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back to settings")
            .accessibilityHint("Keeps what you have written")
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 12)
        .overlay(Rectangle().fill(Color.gold.opacity(0.12)).frame(height: 0.5), alignment: .bottom)
    }

    private func scheduleAutoSave() {
        saveTask?.cancel()
        saveTask = Task {
            try? await Task.sleep(for: .seconds(Self.autosaveSeconds))
            if !Task.isCancelled {
                await MainActor.run { saveIfNeeded() }
            }
        }
    }

    /// Persist, but only when something changed and there are words in it. The
    /// first call is what inserts the row — before that the store has never
    /// heard of this note.
    private func saveIfNeeded() {
        guard draft.isDirty else { return }
        saveTask?.cancel()
        let store = MarginNoteStore(context: context)
        let row = note ?? store.blank()
        guard store.save(row, body: draft.text) else { return }
        note = row
        MarginComposition.openNoteId = row.noteId
        draft.markSaved()
    }

    /// The ledger row, written once, when he has finished and gone. `createdAt`
    /// is the note's own instant, so a note that waits three days for a network
    /// still lands on the day he wrote it.
    private func ledgerIfNeeded() {
        guard let row = note, !row.isBlank, row.ledgeredAt == nil else { return }
        let ctx = context
        Task { await AirtableService.shared.recordNote(row, context: ctx) }
    }

    private func leave() {
        saveTask?.cancel()
        saveIfNeeded()
        dismiss()
    }
}

// MARK: - Reading them back

/// What he has left, newest first, and nothing else.
///
/// A plain scroll of rows: the day it was written over the words themselves.
/// No count, no badge, no ordinal, no "your first note", no total — the digits
/// permitted on this surface are dates, and the recent ones are words.
struct MarginNoteListView: View {
    @Query(sort: \MarginNote.createdAt, order: .reverse) private var notes: [MarginNote]
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Environment(\.dismiss) private var dismiss
    @State private var reading: MarginNote?

    var body: some View {
        ZStack {
            MarginAir.ground(MarginAir.today(shaktis))
            VStack(spacing: 0) {
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if notes.isEmpty {
                            Text("Nothing left here yet.")
                                .font(AppFont.voice(16))
                                .foregroundStyle(Color.cream.opacity(0.55))
                                .padding(.horizontal, 24)
                                .padding(.top, 28)
                        }
                        ForEach(notes) { note in
                            Button { reading = note } label: { row(note) }
                                .buttonStyle(.plain)
                            Rectangle()
                                .fill(Color.gold.opacity(0.08))
                                .frame(height: 0.5)
                                .padding(.horizontal, 22)
                        }
                        Color.clear.frame(height: 36)
                    }
                }
            }
        }
        // One named container around the list and nothing else. A sheet leaves
        // the screen beneath it in the accessibility tree — the Well is still
        // there, with its own "2nd Avaraṇa" in it — so a check that reads "every
        // label in the margin" has to have a margin to read. Without this the
        // no-numeral check was reading the whole app and failing on a screen it
        // does not own.
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("marginListRoot")
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableSwipeBack()
        .navigationDestination(item: $reading) { note in
            MarginNoteReaderView(note: note)
        }
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                HStack(spacing: 4) {
                    Text("‹").font(.system(size: 22, weight: .light))
                    Text("Settings").tracking(0.8)
                }
                .foregroundStyle(Color.gold)
                .font(AppFont.label(14))
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back to settings")
            Spacer()
            Text("What you have left")
                .font(AppFont.sanskrit(16))
                .tracking(1.2)
                .foregroundStyle(Color.cream.opacity(0.8))
                // Names the destination for a driven test: a sentinel has to be
                // true only *after* this screen has arrived, and the door that
                // opens it carries the same words.
                .accessibilityIdentifier("marginListTitle")
            Spacer()
            Color.clear.frame(width: 64, height: 1)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 12)
        .overlay(Rectangle().fill(Color.gold.opacity(0.12)).frame(height: 0.5), alignment: .bottom)
    }

    /// One note's row. Truncated here, never in the reader. **One** accessibility
    /// element, whose label is the day and then his own words — no position, no
    /// ordinal, no "row three of twelve", nothing counted.
    private func row(_ note: MarginNote) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(MarginDate.written(note.createdAt))
                .font(AppFont.label(12))
                .tracking(1.4)
                .foregroundStyle(Color.gold.opacity(0.7))
            Text(note.trimmedBody)
                .font(AppFont.voice(14))
                .foregroundStyle(Color.cream.opacity(0.75))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(MarginDate.spoken(note.createdAt)). \(note.trimmedBody)")
        .accessibilityHint("Opens the note")
    }
}

/// One note, whole. Nothing here but the day and what he said.
struct MarginNoteReaderView: View {
    let note: MarginNote
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            MarginAir.ground(MarginAir.today(shaktis))
            VStack(spacing: 0) {
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(MarginDate.written(note.createdAt))
                            .font(AppFont.label(12))
                            .tracking(1.4)
                            .foregroundStyle(Color.gold.opacity(0.7))
                            .accessibilityLabel(MarginDate.spoken(note.createdAt))
                        Text(note.trimmedBody)
                            .font(AppFont.sanskrit(19))
                            .foregroundStyle(Color.cream.opacity(0.9))
                            .lineSpacing(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 22)
                    Color.clear.frame(height: 36)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableSwipeBack()
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                HStack(spacing: 4) {
                    Text("‹").font(.system(size: 22, weight: .light))
                    Text("What you have left").tracking(0.8)
                }
                .foregroundStyle(Color.gold)
                .font(AppFont.label(14))
                .frame(minHeight: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back to your notes")
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 12)
        .overlay(Rectangle().fill(Color.gold.opacity(0.12)).frame(height: 0.5), alignment: .bottom)
    }
}
