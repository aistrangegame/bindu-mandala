import SwiftUI
import SwiftData

// MARK: - Wave 2 · One building — the door every way in passes through
//
// Phase 3.7 cut one door into the rooms, on her Detail, and a law that said
// there would only ever be one: *"a second door is a second set of conditions
// to drift."* Charter II lifted that rule (the Reading's §3 row, *"One door
// into a room"* → **Lift**): the room is reachable from everywhere it makes
// sense — her seat in the Mandala, the Rite, the Field, the climb, her Detail,
// and the corridor from inside a neighbour's room.
//
// What the one-door rule actually protected survives, and is held here by the
// shape of the tree rather than by a count of doors:
//
//   1. **Every way in passes the rite of entering.** This modifier is the only
//      place in the shell that calls ``RiteOfEnteringView/entering(_:remembering:)``,
//      and that call is still the only way a `RoomView` is ever built. Many
//      doors, one threshold.
//   2. **Every door asks the same question.** A door is a position; the room
//      it opens is resolved by ``HomeRooms`` from her own row, so no surface
//      can make some of the hundred and two reachable and others not.
//   3. **Leaving is one gesture, never punished** — the held way out, its
//      equal edge-swipe, and the corridor's two doors all hand the stay over
//      through the same `out()`.

/// A seat in the garland, as something that can be presented.
struct HerSeat: Identifiable, Hashable {
    let id: Int
}

/// Presents her room — through the rite of entering — for whatever position
/// the binding is set to. Setting it to `nil` closes the room.
@MainActor
struct HerRoomDoor: ViewModifier {
    @Binding var kp: Int?
    /// Called after he has left the building altogether (not when he walks the
    /// corridor — the passage stays up for that).
    var onLeft: (() -> Void)?

    @Environment(\.modelContext) private var context

    func body(content: Content) -> some View {
        content.fullScreenCover(item: seat) { seat in
            HerRoomPassage(startingAt: seat.id, context: context, onLeft: {
                kp = nil
                onLeft?()
            })
        }
    }

    private var seat: Binding<HerSeat?> {
        Binding(get: { kp.map { HerSeat(id: $0) } },
                set: { kp = $0?.id })
    }
}

extension View {
    /// Her room, through the rite of entering, whenever `kp` holds a position.
    @MainActor
    func herRoom(_ kp: Binding<Int?>, onLeft: (() -> Void)? = nil) -> some View {
        modifier(HerRoomDoor(kp: kp, onLeft: onLeft))
    }
}

/// The corridor: one room at a time, and the neighbour doors that walk from
/// one to the next. Each room is a fresh rite of entering — the passage only
/// changes which position it is standing at.
@MainActor
struct HerRoomPassage: View {
    let context: ModelContext
    let onLeft: () -> Void

    @State private var kp: Int
    /// Wave 6 · B · the position whose rite has ended — he is inside.
    @State private var enteredKp: Int?

    init(startingAt kp: Int, context: ModelContext, onLeft: @escaping () -> Void) {
        self.context = context
        self.onLeft = onLeft
        _kp = State(initialValue: kp)
    }

    var body: some View {
        ZStack {
            Color.ground.ignoresSafeArea()
            room
                .id(kp)
                .transition(.opacity)
            // Wave 6 · B · the game's own structure inside her room: the
            // Trinity's face at its seat, and Knowledge — Will — Action.
            if let shakti = Self.seat(kp, in: context) {
                RoomGameLayer(shakti: shakti, entered: enteredKp == kp)
                    .id(kp)
            }
        }
        .animation(.easeInOut(duration: 0.7), value: kp)
    }

    @ViewBuilder
    private var room: some View {
        if let shakti = Self.seat(kp, in: context),
           let rite = RiteOfEnteringView.entering(shakti,
                                                  remembering: HomeMemoryStore(context: context),
                                                  forceReduceMotion: AppRuntime.forcesReduceMotion,
                                                  neighbours: Self.corridor(of: kp, in: context),
                                                  onEntered: { enteredKp = kp },
                                                  onLeft: onLeft,
                                                  onNeighbour: { next in kp = next }) {
            rite
        } else {
            // A position with no row behind it yet (the base not reached for
            // that seat): nothing to stand in, so the surface simply closes.
            Color.ground.ignoresSafeArea()
                .onAppear { onLeft() }
        }
    }

    /// Her row, by position — the only key (§4.2).
    static func seat(_ kp: Int, in context: ModelContext) -> Shakti? {
        let rows = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        return rows.first { $0.khadgamalaPosition == kp }
    }

    /// The seat before her and the seat after her in the garland.
    static func corridor(of kp: Int, in context: ModelContext) -> NeighbourDoors? {
        guard let pair = Garland.neighbours(of: kp) else { return nil }
        let rows = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        func name(_ p: Int) -> String {
            rows.first { $0.khadgamalaPosition == p }?.name ?? ""
        }
        return NeighbourDoors(before: .init(kp: pair.before, name: name(pair.before)),
                              after: .init(kp: pair.after, name: name(pair.after)))
    }
}
