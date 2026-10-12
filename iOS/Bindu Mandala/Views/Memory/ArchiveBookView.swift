import SwiftUI
import SwiftData

// MARK: - Wave 6 · the Archive as a book (Bindu Feed's final Wave)
//
// Every page he has set down becomes a page in a book, oldest first: his
// letters (only those readable — a sealed letter is never a page before its
// day), the notes he left in the margin, the words he left with a recognition,
// the light he sent back with words beside it, and what he sent to the Codex.
// Each page yellows by how long ago it was written, not by where it sits in
// the pile. **The page at the exact middle of the book is not a page at all**:
// it is a door into the descent. The last page seals something forward.

enum ArchiveBook {

    struct Page: Equatable, Identifiable {
        enum Kind: Equatable { case letter, note, recognition, light, codex, door }
        var id: String
        var kind: Kind
        var at: Date
        var heading: String
        var words: String
        var voiceFile: String? = nil
    }

    /// The book: his pages oldest first, and the door at the exact middle.
    /// An empty record is a book with only its door.
    static func bind(_ pages: [Page]) -> [Page] {
        var sorted = pages.filter { $0.kind != .door }.sorted { $0.at < $1.at }
        let middle = sorted.count / 2
        let doorAt = sorted.isEmpty ? Date() : sorted[max(0, min(sorted.count - 1, middle))].at
        sorted.insert(Page(id: "door", kind: .door, at: doorAt, heading: "", words: ""), at: middle)
        return sorted
    }

    /// Where the door stands: always the middle index.
    static func doorIndex(in book: [Page]) -> Int? { book.firstIndex { $0.kind == .door } }

    /// Paper yellowing by real time, as the river's pages do.
    static func patina(_ at: Date, now: Date = .now) -> Double {
        let days = max(0, now.timeIntervalSince(at) / 86_400)
        return 1 - exp(-days / 240)
    }
}

struct ArchiveBookView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var entries: [RecognitionEntry]
    @Query private var notes: [MarginNote]
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    @State private var page = 0
    @State private var descentOpen = false
    @State private var sealingForward = false
    @State private var leavingWord = false

    private func name(_ kp: Int) -> String {
        shaktis.first { $0.khadgamalaPosition == kp }?.name ?? "her"
    }

    private var book: [ArchiveBook.Page] {
        let now = Date()
        var pages: [ArchiveBook.Page] = []
        for l in CorrespondenceStore.shared.letters where l.isReadable(at: now) {
            let body = l.body.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !body.isEmpty || l.voiceFile != nil else { continue }
            pages.append(.init(id: "letter-\(l.id)", kind: .letter, at: l.writtenAt,
                               heading: RiverWords.heading(l, herName: name(l.khadgamalaPosition)),
                               words: body, voiceFile: l.voiceFile))
        }
        for n in notes where !n.isBlank {
            pages.append(.init(id: "note-\(n.noteId)", kind: .note, at: n.createdAt,
                               heading: "in the margin", words: n.trimmedBody))
        }
        for e in entries {
            let t = (e.note ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !t.isEmpty else { continue }
            pages.append(.init(id: "felt-\(e.timestamp.timeIntervalSinceReferenceDate)-\(e.khadgamalaPosition)",
                               kind: .recognition, at: e.timestamp,
                               heading: "with \(name(e.khadgamalaPosition))", words: t))
        }
        for l in CorrespondenceStore.shared.lights {
            guard let w = l.words, !w.isEmpty else { continue }
            pages.append(.init(id: "light-\(l.id)", kind: .light, at: l.sentAt,
                               heading: "light sent back to \(RiverWords.day(l.moment))", words: w))
        }
        for c in CodexNoteStore.shared.notes {
            pages.append(.init(id: "codex-\(c.id)", kind: .codex, at: c.at,
                               heading: "left in the Codex", words: c.body, voiceFile: c.voiceFile))
        }
        return ArchiveBook.bind(pages)
    }

    var body: some View {
        let pages = book
        ZStack {
            Color(red: 0.06, green: 0.04, blue: 0.04).ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Button { dismiss() } label: {
                        Text("‹ close the book")
                            .font(AppFont.voice(16))
                            .foregroundStyle(Color.gold)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    BinduPoint(size: 5)
                }
                .padding(.horizontal, 20)

                TabView(selection: $page) {
                    if let name = BinduMemory.shared.higherSelfName {
                        frontispiece(name).tag(-1)
                    }
                    ForEach(Array(pages.enumerated()), id: \.element.id) { i, p in
                        Group {
                            if p.kind == .door { door } else { pageView(p) }
                        }
                        .tag(i)
                    }
                    lastPage.tag(pages.count)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $descentOpen) { DescentFilmView() }
        .sheet(isPresented: $sealingForward) { RiverComposer(shaktis: shaktis) }
        .sheet(isPresented: $leavingWord) { CodexNoteComposer(origin: "the book") }
    }

    private func frontispiece(_ name: String) -> some View {
        VStack(spacing: 18) {
            Spacer()
            Text("the book of")
                .font(AppFont.voice(16))
                .italic()
                .foregroundStyle(Color.cream.opacity(0.55))
            Text(name)
                .font(AppFont.sanskrit(34))
                .foregroundStyle(Color.gold)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(paper(0))
        .padding(18)
    }

    private func pageView(_ p: ArchiveBook.Page) -> some View {
        let patina = ArchiveBook.patina(p.at)
        return ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(RiverWords.day(p.at).uppercased())
                    .font(AppFont.label(11))
                    .tracking(2.0)
                    .foregroundStyle(Color(red: 0.35, green: 0.25, blue: 0.18).opacity(0.75))
                Text(p.heading)
                    .font(AppFont.sanskrit(22))
                    .foregroundStyle(Color(red: 0.22, green: 0.13, blue: 0.1))
                Text(p.words)
                    .font(AppFont.sanskrit(20))
                    .foregroundStyle(Color(red: 0.16, green: 0.1, blue: 0.08).opacity(0.92))
                    .lineSpacing(7)
                    .fixedSize(horizontal: false, vertical: true)
                if let f = p.voiceFile, SpeechCapture.exists(f) {
                    VoicePlayButton(file: f)
                }
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(paper(patina))
        .padding(18)
    }

    /// The middle of the book: a door into the descent, not a page.
    private var door: some View {
        Button {
            Haptics.medium()
            descentOpen = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.black)
                RadialGradient(colors: [Color.accentRed.opacity(0.35), .clear],
                               center: .center, startRadius: 0, endRadius: 220)
                VStack(spacing: 22) {
                    BinduPoint(size: 9)
                    Text("the middle of the book")
                        .font(AppFont.voice(15))
                        .italic()
                        .foregroundStyle(Color.cream.opacity(0.55))
                    Text("go down ›")
                        .font(AppFont.sanskrit(22))
                        .foregroundStyle(Color.gold)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(18)
        .accessibilityLabel("A door into the descent")
    }

    private var lastPage: some View {
        VStack(spacing: 22) {
            Spacer()
            Text("the next page is not written yet")
                .font(AppFont.voice(17))
                .italic()
                .foregroundStyle(Color(red: 0.3, green: 0.2, blue: 0.15))
            Button {
                Haptics.medium()
                sealingForward = true
            } label: {
                Text("seal it forward")
                    .font(AppFont.sanskrit(21))
                    .foregroundStyle(Color.cream)
                    .padding(.horizontal, 30)
                    .frame(minHeight: 50)
                    .background(Capsule().fill(Color.accentRed))
            }
            .buttonStyle(.plain)
            Button {
                Haptics.light()
                leavingWord = true
            } label: {
                Text("leave my own word in the Codex ›")
                    .font(AppFont.voice(16))
                    .foregroundStyle(Color(red: 0.42, green: 0.24, blue: 0.12))
                    .frame(minHeight: 44)
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(paper(0))
        .padding(18)
    }

    private func paper(_ patina: Double) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color(red: 0.93, green: 0.89, blue: 0.8))
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(RiverWords.patinaTint.opacity(0.45 * patina))
        }
        .shadow(color: .black.opacity(0.6), radius: 18, y: 6)
    }
}

/// Wave 6 · the raw Codex write, as a page: his word, spoken or typed, sent to
/// the Codex with Source App "Bindu Mandala" and Status left unset.
struct CodexNoteComposer: View {
    let origin: String

    @Environment(\.dismiss) private var dismiss
    @State private var words = ""
    @State private var spoken = false
    @State private var voiceFile: String?
    @State private var left = false
    @StateObject private var capture = SpeechCapture()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.05, blue: 0.07).ignoresSafeArea()
                VStack(alignment: .leading, spacing: 18) {
                    Text(left ? "It is in the Codex now, in your words." : "Your own word, for the Codex.")
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.75))
                    TextEditor(text: $words)
                        .font(AppFont.sanskrit(19))
                        .foregroundStyle(Color.cream)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 220)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))
                        .disabled(left)
                    HStack {
                        VoiceWordButton(capture: capture) { file, heard in
                            voiceFile = file
                            spoken = true
                            let h = heard.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !h.isEmpty { words = words.isEmpty ? h : words + "\n" + h }
                        }
                        Spacer()
                        if let f = voiceFile { VoicePlayButton(file: f) }
                    }
                    if !left {
                        Button {
                            guard CodexNoteStore.shared.leave(body: words, spoken: spoken ? .spoken : .typed,
                                                              origin: origin, voiceFile: voiceFile) != nil else { return }
                            Haptics.medium()
                            left = true
                        } label: {
                            Text("leave it in the Codex")
                                .font(AppFont.sanskrit(19))
                                .foregroundStyle(Color.cream)
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 50)
                                .background(Capsule().fill(Color.accentRed))
                        }
                        .buttonStyle(.plain)
                        .disabled(words.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("A word, for the Codex")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(left ? "done" : "not now") { dismiss() }.tint(Color.gold)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onDisappear { capture.abandon() }
    }
}
