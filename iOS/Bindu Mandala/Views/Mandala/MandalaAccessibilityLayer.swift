import SwiftUI

// MARK: - The Mandala, reachable
//
// Brief v2 §4.4. `MandalaCanvasLayer` draws the whole field — 102 seats, nine
// enclosures, the triangles, the Bindu — in a single `Canvas`. A `Canvas` is one
// view, and its strokes are not views, so to VoiceOver the entire instrument is
// a blank rectangle. Audit §H5 found it: *"the 102 seats are invisible to
// VoiceOver."*
//
// This layer is the tree the drawing does not have. One accessibility element
// per seat that is actually on the screen, one per enclosure whose ring is, each
// sitting exactly where the canvas drew the thing it speaks for, each carrying
// the label `MandalaVoice` composes and an action that does what a tap on that
// spot does.
//
// **It draws nothing and catches nothing.** Every element is a `Color.clear`,
// and the whole layer is `allowsHitTesting(false)` — the field's pan, pinch and
// tap all still belong to the one gesture catcher underneath, which is what
// keeps `nearestSeat(to:)` the single answer to "which seat is this". VoiceOver
// does not hit-test: it activates the element's own action, which is why the
// action is passed in rather than synthesised from a tap.
//
// **Why the elements carry no `.isButton` trait.** Adding it would make each of
// the 111 report as a `button` to XCUITest, and three suites read buttons off
// these screens for other reasons — `HitAreaTests` measures every button's touch
// area, and `SnapshotScreen.tapHamburger` finds the menu by *being* the button
// in the top-trailing corner. A hundred invisible buttons scattered over the
// field would be found instead. Without the trait they are plain accessibility
// elements: VoiceOver reads them, focuses them and activates them exactly the
// same, and the hint says out loud what activating does.
//
// **The order is the garland.** Enclosure, then the seats that sit in it, ring 1
// outward-in through ring 9 — which is khaḍgamālā order, because that is how the
// garland is strung. Priorities are negative so the header and the zoom column,
// which sit at the default 0, are still spoken first: the screen says what it is
// before it says who is on it.

struct MandalaAccessibilityLayer: View {
    let camera: MandalaCamera
    let size: CGSize
    let seats: [MandalaWorld.Seat]
    /// Her label and her hint, composed by the host when the field changed —
    /// never here, where the camera rebuilds this view on every frame of a drag.
    let voices: [Int: MandalaVoice.Spoken]
    /// The seats that answer right now, by khaḍgamālā position. When a seat is
    /// focused the field dims and only she and her family answer a tap; the
    /// spoken tree says the same thing rather than offering a hundred seats that
    /// no longer respond.
    let reachable: Set<Int>
    let onActivate: (MandalaWorld.Seat) -> Void

    /// The target a seat's element offers. FIDELITY's touch floor, and the same
    /// 44 pt `HitAreaIdiomTests` holds every other control to.
    static let target: CGFloat = 44

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                element(entry, priority: Double(-index - 1))
            }
        }
        .frame(width: size.width, height: size.height, alignment: .topLeading)
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private func element(_ entry: Entry, priority: Double) -> some View {
        Color.clear
            .frame(width: Self.target, height: Self.target)
            .accessibilityElement()
            .accessibilityLabel(entry.label)
            .accessibilityHint(entry.hint)
            .accessibilitySortPriority(priority)
            .accessibilityAction { entry.activate?() }
            .position(entry.point)
    }

    // MARK: What is on the screen, in the order the garland is strung

    struct Entry {
        let id: String
        let label: String
        let hint: String
        let point: CGPoint
        let activate: (() -> Void)?
    }

    /// The enclosure of each ring, then its seats, ring by ring. Built once per
    /// camera change rather than per element, so the whole ordering is one list
    /// somebody can read — and so a test can assert the order without
    /// reconstructing it.
    var entries: [Entry] {
        let byRing = Dictionary(grouping: seats.filter { reachable.contains($0.id) }) {
            MandalaVoice.ring(of: $0.shakti)
        }
        var out: [Entry] = []
        for ring in 1...9 {
            if let point = enclosurePoint(ring: ring), !(byRing[ring] ?? []).isEmpty {
                out.append(Entry(id: "enclosure-\(ring)",
                                 label: MandalaVoice.enclosureLabel(ring: ring),
                                 hint: "",
                                 point: point,
                                 activate: nil))
            }
            for seat in (byRing[ring] ?? []).sorted(by: { $0.id < $1.id }) {
                let point = camera.screen(for: seat.point)
                guard onScreen(point) else { continue }
                guard let voice = voices[seat.id] else { continue }
                out.append(Entry(id: "seat-\(seat.id)",
                                 label: voice.label,
                                 hint: voice.hint,
                                 point: point,
                                 activate: { onActivate(seat) }))
            }
        }
        return out
    }

    /// Where the canvas writes an enclosure's name: centred above its ring, and
    /// just below the centre for the Bindu, which has no radius to sit above.
    /// The spoken element stands where the drawn name does, so a walker who can
    /// see a little and hear the rest finds them in the same place.
    private func enclosurePoint(ring: Int) -> CGPoint? {
        let centre = camera.screen(for: .zero)
        let radius = MandalaWorld.ringRadius(ring) * camera.scale
        let point = ring == 9
            ? CGPoint(x: centre.x, y: centre.y + 18)
            : CGPoint(x: centre.x, y: centre.y - radius - 9)
        return onScreen(point) ? point : nil
    }

    /// The same margin the canvas culls at, so the tree holds what the drawing
    /// holds: an element for a seat that is off the edge of the glass would send
    /// VoiceOver focus somewhere the walker cannot see.
    private func onScreen(_ p: CGPoint) -> Bool {
        p.x > -20 && p.x < size.width + 20 && p.y > -20 && p.y < size.height + 20
    }
}
