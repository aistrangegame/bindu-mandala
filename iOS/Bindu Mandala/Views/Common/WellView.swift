import SwiftUI
import SwiftData

/// The Well — third tab. A love-letter space, one private letter per Śakti.
/// Letters are local-only and never synced or read by anyone.
struct WellView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]
    @State private var openingFor: Shakti?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ground.ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(shaktis) { s in
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
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Text("Your Letters to Them")
                .font(.custom(AppFont.cormorant, size: 30))
                .tracking(1.6)
                .foregroundStyle(Color.gold)
            Text("Speak to her directly. She is listening.".uppercased())
                .font(.system(size: 9))
                .tracking(2.4)
                .foregroundStyle(Color.cream.opacity(0.32))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
        .padding(.bottom, 16)
        .overlay(Rectangle().fill(Color.gold.opacity(0.10)).frame(height: 0.5), alignment: .bottom)
    }

    private func row(for shakti: Shakti) -> some View {
        let preview = LetterStore(context: context).letter(for: shakti.position).body
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

/// Full-screen editor for one letter. surface background, cream Cormorant.
struct LetterEditorView: View {
    @Bindable var shakti: Shakti
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var draft: String = ""
    @State private var loaded = false
    @FocusState private var focused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            Color.surface.ignoresSafeArea()

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
                        .background(Color.surface)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: load)
        .onDisappear(perform: save)
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
        loaded = true
        draft = LetterStore(context: context).letter(for: shakti.position).body
    }

    private func dismissAndSave() {
        save()
        dismiss()
    }

    private func save() {
        let store = LetterStore(context: context)
        let letter = store.letter(for: shakti.position)
        store.save(letter, body: draft)
    }
}
