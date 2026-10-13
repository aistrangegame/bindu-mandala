import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · A · the higher-self name, kept (Bindu memory, C-1325)
//
// `waves/upgrade/worlds/spine-and-home.md` §2 B #16 and #7 (The One's stage 4
// and 5, verbatim): asked once, from Home ("What name surfaced?"); changeable
// at any time by holding the name or the Road's line 1.8 s; every earlier name
// kept (`BinduMemory`'s history is never overwritten). A change commits by a
// hold (C-1359). "let it sit at the point" puts it beneath the point at Home.
// The ledger's `Name Kept` row goes out through `PracticeLedger`, as the
// Memory world's own naming does.

/// Home › the name — `spine-and-home.md` #16.
@MainActor
struct HomeEssence: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var context
    @AppStorage(HomeCentre.nameAtPointKey) private var nameAtPoint = false

    @State private var name = ""
    @State private var kept: (previous: String?, now: String)?
    @State private var left = false
    @FocusState private var focused: Bool

    private var memory: BinduMemory { BinduMemory.shared }

    var body: some View {
        ZStack {
            Color.silenceGround.ignoresSafeArea()
            VStack(spacing: 26) {
                Spacer(minLength: 60)
                ThePoint(look: .forWorld(.home), light: .always)
                if let kept {
                    VStack(spacing: 14) {
                        Text("Your higher self is called \(kept.now).")
                            .font(AppFont.voice(22))
                            .foregroundStyle(Color.cream)
                        if let previous = kept.previous {
                            Text("You named it \(previous) before. You named it \(kept.now) now. Both are honored.")
                                .font(AppFont.voice(16))
                                .foregroundStyle(Color.cream.opacity(0.7))
                        }
                        Text("The road has been waiting.")
                            .font(AppFont.voice(16))
                            .foregroundStyle(Color.gold.opacity(0.8))
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .transition(.opacity)
                } else {
                    Text("What name surfaced?")
                        .font(AppFont.voice(26))
                        .foregroundStyle(Color.cream)
                    if let current = memory.higherSelfName {
                        Text(current)
                            .font(AppFont.sanskrit(22))
                            .foregroundStyle(Color.gold.opacity(0.8))
                    }
                    VStack(spacing: 6) {
                        TextField("", text: $name,
                                  prompt: Text("whatever arrived").foregroundStyle(Color.cream.opacity(0.5)))
                            .focused($focused)
                            .font(AppFont.sanskrit(24))
                            .foregroundStyle(Color.gold)
                            .multilineTextAlignment(.center)
                            .tint(Color.gold)
                            .submitLabel(.done)
                            .accessibilityIdentifier("home.essence.name")
                        Rectangle().fill(Color.gold.opacity(0.4)).frame(height: 0.5)
                    }
                    .padding(.horizontal, 48)
                    receive
                }
                Toggle(isOn: $nameAtPoint) {
                    Text("let it sit at the point")
                        .font(AppFont.voice(16))
                        .foregroundStyle(Color.cream.opacity(0.75))
                }
                .tint(Color.gold)
                .padding(.horizontal, 48)
                .frame(minHeight: Hit.min)
                Button { leave() } label: {
                    Text("return to the point")
                        .font(AppFont.voice(15))
                        .foregroundStyle(Color.cream.opacity(0.55))
                        .frame(minWidth: Hit.min, minHeight: Hit.min)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("home.essence.leave")
                Spacer()
            }
        }
        .theEdgeWayOut(onOut: { leave() })
        .accessibilityAction(.escape) { leave() }
    }

    /// "Receive" — a hold of 1.8 s commits the name (C-1359).
    private var receive: some View {
        let ready = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return Text("Receive")
            .font(AppFont.sanskrit(20))
            .foregroundStyle(Color.cream.opacity(ready ? 1 : 0.4))
            .frame(minWidth: 160, minHeight: 50)
            .background(Capsule().stroke(Color.gold.opacity(ready ? 0.6 : 0.2), lineWidth: 0.8))
            .hold(for: HoldLadder.story, named: "Receive the name", onComplete: { keep() })
            .accessibilityIdentifier("home.essence.receive")
    }

    private func keep() {
        let previous = memory.higherSelfName
        guard let k = memory.keep(name: name) else { return }
        focused = false
        name = ""
        withAnimation(.easeOut(duration: 1.2)) { kept = (previous, k.name) }
        let ctx = context
        Task { await PracticeLedger.flush(context: ctx) }
    }

    private func leave() {
        guard !left else { return }
        focused = false
        left = router.back(via: .dissolve)
    }
}
