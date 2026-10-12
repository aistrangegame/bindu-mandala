import SwiftUI
import SwiftData

/// Wave 6 · his record, gathered once for the month and the book: every act
/// the phone holds, with his own words where the act carried any.
@MainActor
enum MemoryRecord {
    static func acts(entries: [RecognitionEntry], notes: [MarginNote], now: Date = .now) -> [MonthReading.Act] {
        var out: [MonthReading.Act] = []
        for e in entries {
            let kp = e.khadgamalaPosition > 0 ? e.khadgamalaPosition : nil
            out.append(.init(kind: e.gesture == .felt ? .felt : .silence, at: e.timestamp, kp: kp, words: e.note))
        }
        for l in CorrespondenceStore.shared.letters {
            // A sealed letter's words are never read before its day.
            out.append(.init(kind: .letter, at: l.writtenAt, kp: l.khadgamalaPosition,
                             words: l.isReadable(at: now) ? l.body : nil))
        }
        for l in CorrespondenceStore.shared.lights {
            out.append(.init(kind: .light, at: l.sentAt, kp: l.khadgamalaPosition, words: l.words))
        }
        for n in notes where !n.isBlank {
            out.append(.init(kind: .note, at: n.createdAt, kp: nil, words: n.trimmedBody))
        }
        for c in CodexNoteStore.shared.notes {
            out.append(.init(kind: .codex, at: c.at, kp: nil, words: c.body))
        }
        for t in PortraitStrokeStore.shared.drawingInstants {
            out.append(.init(kind: .drawing, at: t, kp: nil, words: nil))
        }
        for p in PlayTraceStore.shared.traces {
            out.append(.init(kind: .played, at: p.at, kp: p.position, words: nil))
        }
        return out
    }
}

/// Wave 6 · the Month Mirror (Bindu Being) with the Portrait's day glyphs and
/// month letter (Bindu Feed). The field gathered → what moved through it →
/// the turning → the month witnessed → a place to answer. Words only from his
/// own record. "This is a mirror. It holds the season up to the light, and
/// asks nothing of you."
struct MonthMirrorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var entries: [RecognitionEntry]
    @Query private var notes: [MarginNote]
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    @State private var month: Date = Date()
    @State private var reading: MonthReading?
    @State private var chosenDay: MonthReading.DayGlyph?

    private func name(_ kp: Int) -> String {
        shaktis.first { $0.khadgamalaPosition == kp }?.name ?? ""
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.06, green: 0.05, blue: 0.09), Color.ground],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    header
                    if let r = reading {
                        MonthFieldGlyphs(reading: r, chosen: $chosenDay)
                            .frame(width: 300, height: 300)
                            .padding(.top, 10)
                        chosenWords(r)
                        horizon
                        if !r.arc.isEmpty {
                            head("What moved through the month")
                            VStack(alignment: .leading, spacing: 18) {
                                ForEach(r.arc, id: \.ring) { a in arcRow(a) }
                            }
                            .padding(.horizontal, 30)
                            horizon
                        }
                        if let day = r.turningDay {
                            head("The turning")
                            VStack(spacing: 12) {
                                if let line = r.turningLine {
                                    Text(line)
                                        .font(AppFont.sanskrit(22))
                                        .foregroundStyle(Color.cream)
                                        .multilineTextAlignment(.center)
                                }
                                Text(RiverWords.day(day).uppercased())
                                    .font(AppFont.label(11))
                                    .tracking(2.0)
                                    .foregroundStyle(Color.cream.opacity(0.5))
                            }
                            .padding(.horizontal, 30)
                            horizon
                        }
                        head("The month, witnessed")
                        Text(r.letter)
                            .font(AppFont.sanskrit(22))
                            .foregroundStyle(Color.cream.opacity(0.92))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 30)
                        Text(r.witness)
                            .font(AppFont.voice(14))
                            .italic()
                            .foregroundStyle(Color.cream.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .padding(.top, 14)
                            .padding(.horizontal, 30)
                        BinduPoint(size: 6)
                            .padding(.top, 16)
                        horizon
                        MonthSittingView(reading: r)
                            .padding(.horizontal, 24)
                        Text("This is a mirror.\nIt holds the season up to the light, and asks nothing of you.")
                            .font(AppFont.voice(15))
                            .italic()
                            .foregroundStyle(Color.cream.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                            .padding(.vertical, 50)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: read)
        .onChange(of: month) { _, _ in read() }
    }

    private func read() {
        let acts = MemoryRecord.acts(entries: entries, notes: notes)
        reading = MonthReading.read(month: month, acts: acts, name: { kp in name(kp) })
        chosenDay = nil
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Button { dismiss() } label: {
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
            HStack(spacing: 22) {
                Button {
                    Haptics.light()
                    month = Calendar.current.date(byAdding: .month, value: -1, to: month) ?? month
                } label: {
                    Text("‹").font(AppFont.sanskrit(26)).foregroundStyle(Color.gold.opacity(0.8))
                        .frame(minWidth: 44, minHeight: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("The month before")
                Text(monthTitle)
                    .font(AppFont.sanskrit(28))
                    .foregroundStyle(Color.gold)
                Button {
                    Haptics.light()
                    let next = Calendar.current.date(byAdding: .month, value: 1, to: month) ?? month
                    if next <= Date() { month = next }
                } label: {
                    Text("›").font(AppFont.sanskrit(26)).foregroundStyle(Color.gold.opacity(0.8))
                        .frame(minWidth: 44, minHeight: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("The month after")
            }
        }
    }

    private var monthTitle: String {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return f.string(from: month)
    }

    @ViewBuilder
    private func chosenWords(_ r: MonthReading) -> some View {
        VStack(spacing: 6) {
            if let d = chosenDay {
                Text(RiverWords.day(d.day))
                    .font(AppFont.label(11))
                    .tracking(1.8)
                    .foregroundStyle(Color.cream.opacity(0.5))
                Text(d.met.isEmpty ? "A day walked." : "You stopped for \(SakshiClose.list(d.met.map { name($0) }))")
                    .font(AppFont.voice(17))
                    .foregroundStyle(Color.cream.opacity(0.82))
                    .multilineTextAlignment(.center)
            } else {
                Text(r.isQuiet ? "A quiet month." : "touch a day to hear what it carried")
                    .font(AppFont.voice(14))
                    .italic()
                    .foregroundStyle(Color.cream.opacity(0.5))
            }
        }
        .frame(minHeight: 70)
        .padding(.horizontal, 30)
    }

    private func arcRow(_ a: MonthReading.Arc) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(LivingStrokesLayer.color(forRing: a.ring))
                .frame(width: 8, height: 8)
                .shadow(color: LivingStrokesLayer.color(forRing: a.ring), radius: 5)
                .padding(.top, 7)
            VStack(alignment: .leading, spacing: 4) {
                Text("The \(ChakraConstellation.ordinal(a.ring)) enclosure")
                    .font(AppFont.sanskrit(18))
                    .foregroundStyle(Color.cream)
                if !a.names.isEmpty {
                    Text(SakshiClose.list(a.names))
                        .font(AppFont.voice(15))
                        .foregroundStyle(LivingStrokesLayer.color(forRing: a.ring))
                }
                if let his = a.his {
                    Text("“\(his)”")
                        .font(AppFont.voice(15))
                        .foregroundStyle(Color.cream.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 0)
        }
    }

    private var horizon: some View {
        Rectangle()
            .fill(LinearGradient(colors: [.clear, Color.gold.opacity(0.25), .clear],
                                 startPoint: .leading, endPoint: .trailing))
            .frame(height: 1)
            .padding(.vertical, 34)
            .padding(.horizontal, 30)
    }

    private func head(_ s: String) -> some View {
        Text(s.uppercased())
            .font(AppFont.label(11))
            .tracking(2.6)
            .foregroundStyle(Color.gold.opacity(0.75))
            .padding(.bottom, 16)
    }
}

/// The month's field: each day walked as a glyph round the circle, in its
/// dominant ring's light, a dot for each Śakti met, an ember for each thing
/// sealed. Days not walked have no place — the circle is whole.
struct MonthFieldGlyphs: View {
    let reading: MonthReading
    @Binding var chosen: MonthReading.DayGlyph?

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let c = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            ZStack {
                Canvas { ctx, size in
                    ctx.blendMode = .plusLighter
                    let cc = CGPoint(x: size.width / 2, y: size.height / 2)
                    // Every ring the month touched, lit — a state, never weighed.
                    for ring in reading.touched {
                        let r = side / 2 * CGFloat(LivingMandala.ringRadiiBase[max(0, min(8, ring - 1))] / LivingMandala.halfBase) * 0.7
                        let hue = LivingStrokesLayer.color(forRing: ring)
                        let rr = max(6, r)
                        ctx.stroke(Path(ellipseIn: CGRect(x: cc.x - rr, y: cc.y - rr, width: 2 * rr, height: 2 * rr)),
                                   with: .color(hue.opacity(0.5)), lineWidth: 1.6)
                    }
                }
                ForEach(Array(reading.glyphs.enumerated()), id: \.element.id) { i, g in
                    let a = LivingMandala.beadAngle(index: i, total: reading.glyphs.count)
                    let r = side * 0.43
                    DayGlyphView(glyph: g, chosen: chosen == g)
                        .position(x: c.x + r * CGFloat(cos(a)), y: c.y + r * CGFloat(sin(a)))
                        .onTapGesture {
                            Haptics.light()
                            chosen = (chosen == g) ? nil : g
                        }
                        .accessibilityLabel(RiverWords.day(g.day))
                        .accessibilityAddTraits(.isButton)
                }
                BinduPoint(size: 7)
                    .position(c)
            }
        }
    }
}

/// One day walked: its ring's light, a dot for each Śakti met (each dot is
/// her), an ember when something was sealed — states, never a tally.
struct DayGlyphView: View {
    let glyph: MonthReading.DayGlyph
    var chosen = false

    var body: some View {
        let hue = LivingStrokesLayer.color(forRing: glyph.ring)
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [hue.opacity(chosen ? 0.75 : 0.5), .clear],
                                     center: .center, startRadius: 0, endRadius: 16))
                .frame(width: 32, height: 32)
            ForEach(Array(glyph.met.prefix(12).enumerated()), id: \.offset) { i, kp in
                let a = 2 * Double.pi * Double(i) / Double(max(1, min(12, glyph.met.count))) - Double.pi / 2
                Circle()
                    .fill(LivingStrokesLayer.color(forRing: KhadgamalaMap.ringNumber(forKhadgamala: kp)))
                    .frame(width: 3, height: 3)
                    .offset(x: 8 * CGFloat(cos(a)), y: 8 * CGFloat(sin(a)))
            }
            if glyph.sealed {
                Circle()
                    .fill(Color.goldWarm)
                    .frame(width: 3, height: 3)
                    .shadow(color: Color.goldWarm, radius: 3)
                    .offset(y: 13)
            }
            Circle().fill(Color.cream.opacity(0.9)).frame(width: 2.5, height: 2.5)
        }
        .frame(width: 44, height: 44)
        .contentShape(Circle())
    }
}

/// Being's MonthSitting: does this land? — *it lands · say more · leave my own
/// word*. The last writes his word to the Codex (Source App "Bindu Mandala"),
/// spoken or typed.
struct MonthSittingView: View {
    let reading: MonthReading

    enum Phase { case ask, more, mine, held }
    @State private var phase: Phase = .ask
    @State private var mine = ""
    @State private var kept = ""
    @State private var spoken = false
    @State private var voiceFile: String?
    @StateObject private var capture = SpeechCapture()

    var body: some View {
        VStack(spacing: 16) {
            switch phase {
            case .held:
                BinduPoint(size: 7)
                Text("Held.")
                    .font(AppFont.sanskrit(22))
                    .foregroundStyle(Color.cream)
                if !kept.isEmpty {
                    Text("you said back: “\(kept)”")
                        .font(AppFont.voice(15))
                        .italic()
                        .foregroundStyle(Color.cream.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            case .mine:
                Text("then say it back, in your own words")
                    .font(AppFont.voice(14))
                    .italic()
                    .foregroundStyle(Color.cream.opacity(0.55))
                TextEditor(text: $mine)
                    .font(AppFont.voice(17))
                    .foregroundStyle(Color.cream)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))
                VoiceWordButton(capture: capture) { file, heard in
                    voiceFile = file
                    spoken = true
                    let h = heard.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !h.isEmpty { mine = mine.isEmpty ? h : mine + "\n" + h }
                }
                Button {
                    keep()
                } label: {
                    Text("keep it")
                        .font(AppFont.voice(16))
                        .foregroundStyle(Color.cream)
                        .padding(.horizontal, 26)
                        .frame(minHeight: 44)
                        .background(Capsule().fill(Color.accentRed.opacity(0.8)))
                }
                .buttonStyle(.plain)
                .disabled(mine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            case .ask, .more:
                if phase == .more, let deeper = reading.deeper {
                    Text(deeper)
                        .font(AppFont.sanskrit(19))
                        .foregroundStyle(Color.cream)
                        .multilineTextAlignment(.center)
                }
                Text("does this land?")
                    .font(AppFont.voice(15))
                    .italic()
                    .foregroundStyle(Color.cream.opacity(0.55))
                HStack(spacing: 10) {
                    choice("it lands") { phase = .held }
                    if phase == .ask, reading.deeper != nil { choice("say more") { phase = .more } }
                    choice("leave my own word") { phase = .mine }
                }
            }
        }
        .animation(.easeInOut(duration: 0.6), value: phase)
        .onDisappear { capture.abandon() }
    }

    private func choice(_ label: String, action: @escaping () -> Void) -> some View {
        Button {
            Haptics.light()
            action()
        } label: {
            Text(label)
                .font(AppFont.voice(14))
                .foregroundStyle(Color.cream.opacity(0.8))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                .background(Capsule().stroke(Color.gold.opacity(0.35), lineWidth: 0.6))
        }
        .buttonStyle(.plain)
    }

    private func keep() {
        let words = mine.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !words.isEmpty else { return }
        Haptics.medium()
        CodexNoteStore.shared.leave(body: words, spoken: spoken ? .spoken : .typed,
                                    origin: "the month", voiceFile: voiceFile)
        kept = words
        phase = .held
    }
}
