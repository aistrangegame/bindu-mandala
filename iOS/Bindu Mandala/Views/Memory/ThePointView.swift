import SwiftUI
import CoreMotion

/// The point (Wave 5): the Bindu gaze and the Temporal Layer's five clocks.
///
/// **The gaze** (The Mirror): a still gaze into the point. Hold the phone still
/// and the field steadies — the five wheels stop trembling, the light gathers
/// in, and the point brightens. Move, and the field loosens again; nothing is
/// lost, nothing is scored.
///
/// **The five clocks** turn round the point at their own rates — the hour, the
/// tithi, the nakṣatra, the season and the sun — each read off the real sky
/// (`Ephemeris`, `Panchanga`). A wrong tithi would be a false statement, so
/// none of them is a guess.
struct ThePointView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var stillness = StillnessSensor()
    /// U2 · C · in Time (its own world) "‹ back" is `router.back()`; `nil`:
    /// dismiss, as when it was presented from the Portrait.
    var onBack: (() -> Void)? = nil

    var body: some View {
        TimelineView(.animation(minimumInterval: reduceMotion ? 1 : nil, paused: false)) { timeline in
            let now = timeline.date
            let reading = TemporalReading(at: now)
            let steady = stillness.steadiness
            ZStack {
                RadialGradient(colors: [Color(red: 0.04, green: 0.02, blue: 0.03), Color(red: 0.008, green: 0, blue: 0.004)],
                               center: .center, startRadius: 0, endRadius: 520)
                    .ignoresSafeArea()

                FiveClocks(reading: reading,
                           steadiness: steady,
                           time: now.timeIntervalSinceReferenceDate,
                           still: reduceMotion)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Button(action: { if let onBack { onBack() } else { dismiss() } }) {
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
                    Text("THE POINT")
                        .font(AppFont.label(11))
                        .tracking(3.2)
                        .foregroundStyle(Color.gold.opacity(0.75))
                    Text(steady > 0.92 ? "the field is still" : "hold still, and gaze into the point")
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.65))
                        .padding(.top, 6)
                    Spacer()
                    legend(reading)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                }
            }
        }
        .preferredColorScheme(.dark)
        .contentShape(Rectangle())
        .onTapGesture { stillness.disturb() }
        .onAppear { stillness.start() }
        .onDisappear { stillness.stop() }
        .accessibilityElement(children: .contain)
    }

    private func legend(_ r: TemporalReading) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            row(FiveClocks.hourColor, "hour", r.hourWords)
            row(FiveClocks.tithiColor, "tithi", r.tithiWords)
            row(FiveClocks.nakshatraColor, "nakṣatra", r.nakshatraWords)
            row(FiveClocks.seasonColor, "season", r.seasonWords)
            row(FiveClocks.sunColor, "sun", r.sunWords)
        }
    }

    private func row(_ color: Color, _ label: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
                .shadow(color: color, radius: 4)
            Text(label.uppercased())
                .font(AppFont.label(11))
                .tracking(2.0)
                .foregroundStyle(Color.cream.opacity(0.55))
                .frame(minWidth: 84, alignment: .leading)
            Text(value)
                .font(AppFont.voice(16))
                .foregroundStyle(Color.cream.opacity(0.88))
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

/// Everything the five clocks say about one instant.
struct TemporalReading {
    let date: Date
    let hourFraction: Double      // 0…1 round the local day, midnight at the top
    let sandhya: Panchanga.Sandhya
    let elongation: Double        // 0…360
    let tithi: Int
    let siderealMoon: Double
    let nakshatra: Int
    let tropicalSun: Double
    let rtu: Panchanga.Rtu
    let siderealSun: Double
    let rashi: Int
    let uttarayana: Bool

    init(at date: Date, calendar: Calendar = .current, place: TemporalPlace? = nil) {
        self.date = date
        let c = calendar.dateComponents([.hour, .minute, .second], from: date)
        let seconds = Double((c.hour ?? 0) * 3_600 + (c.minute ?? 0) * 60 + (c.second ?? 0))
        hourFraction = seconds / 86_400
        sandhya = Panchanga.sandhya(at: date, place: place ?? TemporalPlace.current(timeZone: calendar.timeZone, at: date),
                                    calendar: calendar)
        elongation = Ephemeris.elongation(date)
        tithi = Panchanga.tithi(at: date)
        siderealMoon = Ephemeris.siderealMoonLongitude(date)
        nakshatra = Panchanga.nakshatra(at: date)
        tropicalSun = Ephemeris.sunLongitude(date)
        rtu = Panchanga.rtu(at: date)
        siderealSun = Ephemeris.siderealSunLongitude(date)
        rashi = Panchanga.sunRashi(at: date)
        uttarayana = Panchanga.isUttarayana(at: date)
    }

    var hourWords: String {
        let time = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        return "\(time) · \(sandhya.name)"
    }
    var tithiWords: String { "\(Panchanga.pakshaName(tithi)) \(Panchanga.tithiName(tithi))" }
    var nakshatraWords: String { Panchanga.nakshatraName(nakshatra) }
    var seasonWords: String { "\(rtu.name) · \(rtu.english)" }
    var sunWords: String {
        "\(Panchanga.rashiNames[rashi]) · \(uttarayana ? "Uttarāyaṇa" : "Dakṣiṇāyana")"
    }
}

/// Five concentric wheels round the point, each turning at its own rate, each
/// with its marks and its one bright position. They tremble while he moves and
/// settle as he stills.
struct FiveClocks: View {
    let reading: TemporalReading
    let steadiness: Double
    let time: TimeInterval
    let still: Bool

    static let hourColor = Color(red: 0.79, green: 0.59, blue: 0.25)
    static let tithiColor = Color(red: 0.91, green: 0.79, blue: 0.48)
    static let nakshatraColor = Color(red: 0.83, green: 0.63, blue: 0.40)
    static let seasonColor = Color(red: 0.83, green: 0.63, blue: 0.09)
    static let sunColor = Color(red: 0.77, green: 0.31, blue: 0.31)

    var body: some View {
        Canvas { ctx, size in
            let c = CGPoint(x: size.width / 2, y: size.height * 0.42)
            let unit = min(size.width, size.height) / 390
            let unsteady = 1 - max(0, min(1, steadiness))
            let wheels: [(r: CGFloat, angle: Double, ticks: Int, color: Color)] = [
                (158, reading.hourFraction * 360, 24, Self.hourColor),
                (130, reading.elongation, 30, Self.tithiColor),
                (102, reading.siderealMoon, 27, Self.nakshatraColor),
                (74, Ephemeris.normalized(reading.tropicalSun - 270), 6, Self.seasonColor),
                (48, reading.siderealSun, 12, Self.sunColor),
            ]
            ctx.blendMode = .plusLighter

            for (i, w) in wheels.enumerated() {
                let tremble = still ? 0 : unsteady * 2.4 * sin(time * (1.3 + Double(i) * 0.37) + Double(i))
                let r = w.r * unit + CGFloat(tremble)
                ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                           with: .color(Color.gold.opacity(0.18 + 0.2 * steadiness)), lineWidth: 0.6)
                for k in 0..<w.ticks {
                    let a = Double(k) / Double(w.ticks) * 2 * .pi - .pi / 2
                    var tick = Path()
                    tick.move(to: CGPoint(x: c.x + (r - 2.5) * CGFloat(cos(a)), y: c.y + (r - 2.5) * CGFloat(sin(a))))
                    tick.addLine(to: CGPoint(x: c.x + (r + 2.5) * CGFloat(cos(a)), y: c.y + (r + 2.5) * CGFloat(sin(a))))
                    ctx.stroke(tick, with: .color(Color.gold.opacity(0.22)), lineWidth: 0.5)
                }
                let a = (w.angle - 90) * .pi / 180
                let p = CGPoint(x: c.x + r * CGFloat(cos(a)), y: c.y + r * CGFloat(sin(a)))
                var spoke = Path()
                spoke.move(to: c)
                spoke.addLine(to: p)
                ctx.stroke(spoke, with: .color(w.color.opacity(0.10 + 0.14 * steadiness)), lineWidth: 0.5)
                let glow: CGFloat = 9 + 5 * CGFloat(steadiness)
                ctx.fill(Path(ellipseIn: CGRect(x: p.x - glow, y: p.y - glow, width: glow * 2, height: glow * 2)),
                         with: .radialGradient(Gradient(colors: [w.color.opacity(0.75), .clear]),
                                               center: p, startRadius: 0, endRadius: glow))
                ctx.fill(Path(ellipseIn: CGRect(x: p.x - 2, y: p.y - 2, width: 4, height: 4)),
                         with: .color(Color.cream))
            }

            // The sandhyā: at a junction the whole field takes a little of the
            // hour's gold.
            if reading.sandhya.isJunction {
                let rr = 170 * unit
                ctx.fill(Path(ellipseIn: CGRect(x: c.x - rr, y: c.y - rr, width: rr * 2, height: rr * 2)),
                         with: .radialGradient(Gradient(colors: [Self.hourColor.opacity(0.10), .clear]),
                                               center: c, startRadius: 0, endRadius: rr))
            }

            // The point. It gathers as he stills.
            let breathe = still ? 0 : 0.06 * sin(time * 2 * .pi / 5)
            let halo = (26 + 34 * CGFloat(steadiness)) * unit * CGFloat(1 + breathe)
            ctx.fill(Path(ellipseIn: CGRect(x: c.x - halo, y: c.y - halo, width: halo * 2, height: halo * 2)),
                     with: .radialGradient(Gradient(colors: [Color.accentRed.opacity(0.85), Color.accentRed.opacity(0.0)]),
                                           center: c, startRadius: 0, endRadius: halo))
            let core = (4 + 3 * CGFloat(steadiness)) * unit
            ctx.fill(Path(ellipseIn: CGRect(x: c.x - core, y: c.y - core, width: core * 2, height: core * 2)),
                     with: .color(Color.cream))
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// How still the phone is held, 0 (moving) … 1 (still). Device motion needs no
/// permission. Where there is no motion hardware (the simulator) stillness simply
/// gathers with time, and a touch loosens it.
final class StillnessSensor: ObservableObject {
    @Published private(set) var steadiness: Double = 0

    private let manager = CMMotionManager()
    private var last = Date()
    private var fallback: Timer?
    private var reachedStill = false

    /// Seconds of stillness to steady fully.
    static let gatherSeconds = 6.0

    /// The next steadiness after `dt` seconds at this much motion.
    static func next(_ current: Double, motion: Double, dt: Double) -> Double {
        let still = motion < 0.035
        let v = still ? current + dt / gatherSeconds : current - dt * 1.2
        return max(0, min(1, v))
    }

    func start() {
        last = Date()
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 1.0 / 30
            manager.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
                guard let self, let data else { return }
                let a = data.userAcceleration
                let g = data.rotationRate
                let motion = sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
                    + 0.12 * sqrt(g.x * g.x + g.y * g.y + g.z * g.z)
                self.ingest(motion: motion)
            }
        } else {
            fallback = Timer.scheduledTimer(withTimeInterval: 1.0 / 20, repeats: true) { [weak self] _ in
                self?.ingest(motion: 0)
            }
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
        fallback?.invalidate()
        fallback = nil
    }

    func disturb() {
        steadiness = max(0, steadiness - 0.5)
        reachedStill = false
    }

    private func ingest(motion: Double) {
        let now = Date()
        let dt = min(0.2, now.timeIntervalSince(last))
        last = now
        let v = Self.next(steadiness, motion: motion, dt: dt)
        if abs(v - steadiness) > 0.0005 { steadiness = v }
        if v >= 1, !reachedStill {
            reachedStill = true
            Haptics.soft()
        } else if v < 0.8 {
            reachedStill = false
        }
    }
}
