import SwiftUI

// MARK: - Wave 2 · the corridor's two doors
//
// Design's Axis, `.door.l` / `.door.r`: a thin vertical seam of light at each
// edge of her room, a third of the way down, with her neighbour's name written
// up it. *"Walking the corridor. Not a return to the axis and not a cut: her
// room is released, and the crossing to her neighbour begins from exactly where
// you stand — so the rite runs again, and the travel is continuous."*
//
// The neighbours are the garland's (``Garland``) — the seat before her and the
// seat after her, by position, wrapping round the circle — and each door opens
// onto that Śakti's own rite of entering. No room is ever reached without it.

/// The corridor's two neighbours, by position, with the names the base gives
/// them. A name may be empty (the base not yet reached): the door still opens.
struct NeighbourDoors: Equatable {
    struct Door: Equatable {
        let kp: Int
        let name: String
    }
    let before: Door
    let after: Door
    /// Wave 6 · a third door: her namesake sister in another ring (Related
    /// Shaktis, read live). `nil` for the many who have none.
    var sister: Door? = nil
}

/// The two doors, drawn at the room's edges.
struct NeighbourDoorsView: View {
    let doors: NeighbourDoors
    let reduceMotion: Bool
    let onWalk: (Int) -> Void

    @State private var shown = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                door(doors.before, leading: true)
                    .position(x: 26, y: geo.size.height * 0.34 + 75)
                door(doors.after, leading: false)
                    .position(x: geo.size.width - 26, y: geo.size.height * 0.34 + 75)
                if let sister = doors.sister {
                    sisterDoor(sister)
                        .position(x: geo.size.width / 2, y: geo.size.height - 150)
                }
            }
        }
        .opacity(shown ? 1 : 0)
        .onAppear {
            if reduceMotion { shown = true } else {
                // Design's `.door` arrives over 800 ms once he is in her room.
                withAnimation(.linear(duration: 0.8)) { shown = true }
            }
        }
    }

    /// Wave 6 · the sister's door: a level seam of light at the foot of the
    /// room, her name along it — the way across the rings to her namesake.
    private func sisterDoor(_ d: NeighbourDoors.Door) -> some View {
        Button {
            onWalk(d.kp)
        } label: {
            VStack(spacing: 6) {
                Rectangle()
                    .fill(LinearGradient(colors: [Color.cream.opacity(0),
                                                  Color.cream.opacity(0.5),
                                                  Color.cream.opacity(0)],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(width: 120, height: 1)
                    .blendMode(.plusLighter)
                if !d.name.isEmpty {
                    Text(d.name)
                        .font(AppFont.label(11))
                        .tracking(1.8)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.cream)
                        .opacity(0.6)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .frame(width: 200, height: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(d.name.isEmpty ? "her sister" : "her sister, \(d.name)"))
        .accessibilityHint(Text("crosses the rings to her sister's room"))
    }

    private func door(_ d: NeighbourDoors.Door, leading: Bool) -> some View {
        Button {
            onWalk(d.kp)
        } label: {
            ZStack {
                // The seam: 1 pt of light, fading at both ends.
                Rectangle()
                    .fill(LinearGradient(colors: [Color.cream.opacity(0),
                                                  Color.cream.opacity(0.5),
                                                  Color.cream.opacity(0)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 1)
                    .blendMode(.plusLighter)
                    .offset(x: leading ? -21 : 21)
                if !d.name.isEmpty {
                    Text(d.name)
                        .font(AppFont.label(11))
                        .tracking(1.8)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.cream)
                        .opacity(0.6)
                        .fixedSize()
                        .rotationEffect(.degrees(leading ? -90 : 90))
                        .offset(x: leading ? -8 : 8)
                }
            }
            .frame(width: 52, height: 150)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(d.name.isEmpty ? "her neighbour" : "her neighbour, \(d.name)"))
        .accessibilityHint(Text("walks the corridor to her room"))
    }
}
