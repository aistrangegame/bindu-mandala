import Foundation

// MARK: - The carrier, live in one room
//
// Build Brief v2 §3.9's third thing. ``HomeSoundService`` was built whole in
// Phase 2.3 — nine grounds voiced by their own ring's technique, her bīja as a
// just interval above her āvaraṇa's root, the air layer, the withheld fifth —
// and then **nothing ever called it**. `setGround`, `setCarrier` and `setRoom`
// had no call site anywhere in the app, and the one gesture that did (`strike`,
// at each beat of the rite) was inert, because every gesture begins
// `guard isBuilt` and nothing had ever called `start()`. The instrument has been
// silent in all 102 rooms since it was written.
//
// This is the conductor: the small object that stands between one stay and that
// service, and it is deliberately the only thing in the rooms layer that knows
// the service exists.
//
// ─────────────────────────────────────────────────────────────────────────────
// A ROOM IS WHOLE WITH THE SOUND OFF
// ─────────────────────────────────────────────────────────────────────────────
//
// Nothing structural is carried by the voice, and this is a constraint on the
// design rather than a hope about it. Every station of the descent, every
// adaptation of the room, every word of the rite and every gesture that moves
// the walker is decided by geometry and the clock; the carrier is told what
// they decided and tells nothing back. There is no callback out of this file,
// no published property, and no return value anywhere that a view could branch
// on — so a walker who never turns the volume up loses exactly the sound, and
// `HomeVoiceTests` proves it by driving a whole stay with the service never
// started and asserting that the room, the descent and the stay are identical.
//
// ─────────────────────────────────────────────────────────────────────────────
// IT DOES NOT FIGHT THE WALKER'S OWN AUDIO
// ─────────────────────────────────────────────────────────────────────────────
//
// Three things, and the first two were already true of the service:
//
//   * `.mixWithOthers`, so his own music is never evicted;
//   * an interruption or a route change pauses cleanly rather than sounding
//     into a room that did not ask;
//   * and **the silent switch stops it**, which is this phase's ruling and is
//     why ``HomeSoundService/respectsSilentSwitch`` exists. A struck bīja is a
//     gesture the walker just made with his own finger and the switch cannot
//     have meant it; a carrier that runs for the whole of a stay is the
//     instrument choosing to sound, and a phone held on silent has already
//     answered that. The rest of the app keeps its own ruling: the service puts
//     the session back the way `RingAudioService` and `BijaSoundService` ask for
//     it when it lets go.
//
// There is no in-app volume, no sound toggle and no mute button in the rooms
// layer. The phone has two controls for this already and they are better than
// any control a room could grow.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY IT WAKES ON A CADENCE, WHEN THE DWELLING DOES NOT
// ─────────────────────────────────────────────────────────────────────────────
//
// ``HomeDwelling`` sleeps until each of the stay's two marks because a stay has
// exactly two marks on it. The carrier has no marks: the filter opens
// continuously with the first adaptation and the fifth arrives continuously with
// the second, so there is something to say at every moment of the stay.
//
// It is still not a render loop. The engine interpolates toward whatever target
// it was last handed, with time constants of six tenths of a second to two
// seconds (``HomeCarrier/Tau``), so a target set once a second is already
// finer-grained than anything the ear can hear arriving. One wake a second, for
// as long as he is inside, against sixty a second — and crucially it is the same
// one wake a second on the reduce-motion path, where there is deliberately no
// render loop to hang anything on. **The sound does not depend on the room
// moving**, which is what makes a still room a whole room.

/// One stay's voice: her ground, her carrier, her air and her withheld fifth.
@MainActor
final class HomeVoice {

    /// What the voice actually does. Injected for one reason: a suite has to be
    /// able to watch a whole stay conducted without an audio engine, a device or
    /// a session, and a conductor that reached for `HomeSoundService.shared`
    /// inside itself could only be tested by letting it sound.
    struct Instrument {
        var begin: @MainActor () -> Void
        var ground: @MainActor (_ ring: Int) -> Void
        var carrier: @MainActor (_ ring: Int, _ amount: Double, _ syllable: String?) -> Void
        var room: @MainActor (_ a: Double, _ b: Double, _ ring: Int, _ syllable: String?) -> Void
        var end: @MainActor () -> Void

        /// The real one.
        @MainActor static var real: Instrument {
            Instrument(
                begin: {
                    // The ruling above, asked for before the graph is ever built
                    // — the service reads it in `configureSession`.
                    HomeSoundService.shared.respectsSilentSwitch = true
                    HomeSoundService.shared.start()
                },
                ground: { ring in
                    // Standing still in one āvaraṇa: her own ground, and no
                    // blend toward a neighbour. The climb is what crossfades.
                    let i = max(0, min(HomeCarrier.roots.count - 1, ring - 1))
                    HomeSoundService.shared.setGround(index: i, next: i, blend: 0)
                },
                carrier: { ring, amount, syllable in
                    HomeSoundService.shared.setCarrier(ring: ring,
                                                       amount: amount,
                                                       syllable: syllable)
                },
                room: { a, b, ring, syllable in
                    HomeSoundService.shared.setRoom(a: a, b: b, ring: ring, syllable: syllable)
                },
                end: { HomeSoundService.shared.stopAll() })
        }

        /// The voice, doing nothing. For a preview, a capture, and for the
        /// suites that ask what a stay decided rather than what it sounded like.
        static let silent = Instrument(begin: {}, ground: { _ in },
                                       carrier: { _, _, _ in }, room: { _, _, _, _ in },
                                       end: {})
    }

    /// How often the voice is told where the stay now stands. See the header.
    static let cadence: TimeInterval = 1

    /// Her āvaraṇa, 1–9.
    let ring: Int
    /// Her seed syllable, or `nil` — the bare root, which is silence about what
    /// is not known rather than a plausible pitch.
    let syllable: String?
    /// Everything ever stood in her room, which is what the withheld fifth is
    /// withheld against. Read once, at the top of the stay, exactly as the head
    /// start and the compression are.
    let accumulatedDwell: TimeInterval

    private let instrument: Instrument
    private var cadenceTask: Task<Void, Never>?
    private var sounding = false

    /// How many times the voice has been told where the stay stands. Read by the
    /// suite; there is nothing in the app that reads it, and nothing it could
    /// mean to a walker.
    private(set) var tellings = 0

    init(ring: Int,
         syllable: String?,
         accumulatedDwell: TimeInterval = 0,
         instrument: Instrument = .silent) {
        self.ring = ring
        self.syllable = syllable
        self.accumulatedDwell = max(0, accumulatedDwell)
        self.instrument = instrument
    }

    deinit { cadenceTask?.cancel() }

    // MARK: - What the stay tells it

    /// The crossing has opened. Her ground comes up under him at her āvaraṇa's
    /// own root, and her carrier comes up with the distance.
    func opens() {
        guard !sounding else { return }
        sounding = true
        instrument.begin()
        instrument.ground(ring)
    }

    /// Where the walker stands on his crossing toward her, `0`–`1`. Design's
    /// *"entering her: the carrier comes up, the ground recedes"* — the amount
    /// **is** the approach, so the carrier arrives exactly as she does.
    func crossing(_ approach: Double) {
        guard sounding else { return }
        instrument.carrier(ring, HomeDescent.clamp01(approach), syllable)
    }

    /// Where the stay stands on her chamber clock.
    ///
    /// `a` is the first adaptation, which opens the filter — the room's own
    /// settling, read from ``HomeGrammar/settling(chamberTime:)`` so the voice
    /// and the geometry open together rather than on two curves.
    ///
    /// `b` is the withheld fifth, and it is the one place in the instrument
    /// where **what the room remembers of him is audible**:
    /// ``HomeMemory/grantsFifth(ring:elapsed:dwell:)`` grants it outright in the
    /// ninth āvaraṇa, and otherwise to whichever is further along — this stay
    /// past the hold's end, or three minutes of accumulated dwell in her room.
    /// So a Śakti he has truly stood with sounds her fifth the moment he
    /// arrives, and a stranger's room withholds it until he has earned it here.
    /// Nothing says so. It is simply a fuller sound in a room he knows.
    func standing(atChamberTime t: TimeInterval) {
        guard sounding else { return }
        tellings &+= 1
        instrument.room(HomeGrammar.settling(chamberTime: t),
                        HomeMemory.grantsFifth(ring: ring, elapsed: t, dwell: accumulatedDwell),
                        ring,
                        syllable)
    }

    /// The stay has begun: he is inside, and the voice follows her clock from
    /// here until he leaves.
    func inside(clock: RoomClock) {
        guard sounding else { return }
        instrument.carrier(ring, 1, syllable)
        standing(atChamberTime: clock.chamberTime())
        cadenceTask?.cancel()
        cadenceTask = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Self.cadence))
                guard !Task.isCancelled, let self else { return }
                self.standing(atChamberTime: clock.chamberTime())
            }
        }
    }

    /// He has left. Everything stops — and it stops **here**, in the one place
    /// that started it, so there is no path by which a room's voice outlives the
    /// room. The app's own background hook calls `stopAll` as well, and the
    /// service is idempotent, which is why both may.
    func closes() {
        cadenceTask?.cancel()
        cadenceTask = nil
        guard sounding else { return }
        sounding = false
        instrument.end()
    }
}

// MARK: - Her voice, from her own row

extension HomeVoice {

    /// The voice for one room and what it remembers of him.
    ///
    /// `dwell` is her accumulated dwell, read off ``HomeMemoryStore`` at the top
    /// of the stay the way the compression and the head start are — one read,
    /// never a subscription, and never anything that could reach a screen.
    static func forRoom(ring: Int,
                        syllable: String?,
                        accumulatedDwell: TimeInterval,
                        sounding: Bool = true) -> HomeVoice {
        HomeVoice(ring: ring,
                  syllable: syllable,
                  accumulatedDwell: accumulatedDwell,
                  instrument: sounding ? .real : .silent)
    }
}
