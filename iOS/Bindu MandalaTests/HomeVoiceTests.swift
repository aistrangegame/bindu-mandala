import XCTest
@testable import Bindu_Mandala

// MARK: - The carrier, live in a room — judged
//
// ``HomeSoundService`` was proved constant by constant in Phase 2.3 and then
// never called. What is judged here is the wiring: that a room gets its voice,
// that the voice stops when the walker leaves, that **what the room remembers of
// him is what decides the withheld fifth**, and — the one that matters most —
// that a room with the sound off loses nothing but the sound.
@MainActor
final class HomeVoiceTests: XCTestCase {

    /// A voice that writes down what it was told instead of sounding.
    private final class Ledger {
        var began = 0
        var ended = 0
        var grounds: [Int] = []
        var carriers: [Double] = []
        var rooms: [(a: Double, b: Double, ring: Int, syllable: String?)] = []

        var instrument: HomeVoice.Instrument {
            HomeVoice.Instrument(
                begin: { [self] in began += 1 },
                ground: { [self] ring in grounds.append(ring) },
                carrier: { [self] _, amount, _ in carriers.append(amount) },
                room: { [self] a, b, ring, syllable in
                    rooms.append((a: a, b: b, ring: ring, syllable: syllable))
                },
                end: { [self] in ended += 1 })
        }
    }

    private func voice(ring: Int = 2,
                       syllable: String? = "Hrīṃ",
                       dwell: TimeInterval = 0,
                       ledger: Ledger) -> HomeVoice {
        HomeVoice(ring: ring, syllable: syllable,
                  accumulatedDwell: dwell, instrument: ledger.instrument)
    }

    // MARK: - It plays for a room and stops when he leaves

    func testTheCarrierComesUpWithTheCrossingAndStopsAtTheDoor() {
        let ledger = Ledger()
        let voice = voice(ledger: ledger)

        voice.opens()
        XCTAssertEqual(ledger.began, 1)
        XCTAssertEqual(ledger.grounds, [2], "her own āvaraṇa's ground, and no other")

        // Design's *"entering her: the carrier comes up"* — the amount is the
        // crossing itself, so she arrives exactly as she arrives.
        for station in RiteOfEntering.stations { voice.crossing(station) }
        XCTAssertEqual(ledger.carriers, RiteOfEntering.stations)

        voice.closes()
        XCTAssertEqual(ledger.ended, 1)

        // …and nothing sounds after the door: a stray callback moves nothing.
        voice.crossing(1)
        voice.standing(atChamberTime: 300)
        XCTAssertEqual(ledger.carriers.count, RiteOfEntering.stations.count)
        XCTAssertTrue(ledger.rooms.isEmpty)
    }

    func testItOpensOnceAndClosesOnceHoweverOftenItIsAsked() {
        let ledger = Ledger()
        let voice = voice(ledger: ledger)
        voice.opens(); voice.opens(); voice.opens()
        XCTAssertEqual(ledger.began, 1)
        voice.closes(); voice.closes()
        XCTAssertEqual(ledger.ended, 1)
    }

    func testAVoiceThatNeverOpenedNeverSounds() {
        let ledger = Ledger()
        let voice = voice(ledger: ledger)
        voice.crossing(1)
        voice.standing(atChamberTime: 400)
        voice.closes()
        XCTAssertEqual(ledger.began, 0)
        XCTAssertEqual(ledger.ended, 0)
        XCTAssertTrue(ledger.carriers.isEmpty)
        XCTAssertTrue(ledger.rooms.isEmpty)
    }

    // MARK: - The filter opens with the room, not beside it

    func testTheFilterOpensOnTheRoomsOwnSettlingCurve() {
        let ledger = Ledger()
        let voice = voice(ledger: ledger)
        voice.opens()
        for t in [0.0, 30, HomeMemory.firstAdaptation, 200, HomeMemory.secondAdaptationEnd] {
            voice.standing(atChamberTime: t)
        }
        for (i, t) in [0.0, 30, HomeMemory.firstAdaptation, 200,
                       HomeMemory.secondAdaptationEnd].enumerated() {
            XCTAssertEqual(ledger.rooms[i].a, HomeGrammar.settling(chamberTime: t),
                           accuracy: 1e-12, "the voice and the geometry are on one curve")
        }
        // The carrier is derived from her syllable, never invented.
        XCTAssertEqual(ledger.rooms.last?.syllable, "Hrīṃ")
        XCTAssertEqual(ledger.rooms.last?.ring, 2)
    }

    // MARK: - The withheld fifth is the relationship

    /// The one place in the instrument where what a room remembers is
    /// **audible** — and it is still never said.
    func testTheFifthIsGrantedByTheRelationshipAndNeverByACount() {
        // A stranger's room, on arrival: nothing.
        let stranger = Ledger()
        let cold = voice(ring: 3, dwell: 0, ledger: stranger)
        cold.opens()
        cold.standing(atChamberTime: 0)
        XCTAssertEqual(stranger.rooms.last?.b ?? -1, 0, accuracy: 1e-12)

        // …and it is earned inside this stay, past the hold's end.
        cold.standing(atChamberTime: HomeMemory.secondAdaptationEnd)
        XCTAssertEqual(stranger.rooms.last?.b ?? -1, 1, accuracy: 1e-12)

        // A room he has truly stood in sounds it the moment he arrives.
        let known = Ledger()
        let warm = voice(ring: 3, dwell: 600, ledger: known)
        warm.opens()
        warm.standing(atChamberTime: 0)
        XCTAssertEqual(known.rooms.last?.b ?? -1, 1, accuracy: 1e-12)

        // The ninth āvaraṇa grants it outright, relationship or none.
        let bindu = Ledger()
        let ninth = voice(ring: 9, dwell: 0, ledger: bindu)
        ninth.opens()
        ninth.standing(atChamberTime: 0)
        XCTAssertEqual(bindu.rooms.last?.b ?? -1, 1, accuracy: 1e-12)
    }

    /// The dwell is read **once**, at the top of the stay, and never subscribed
    /// to — the same shape the compression and the head start have.
    func testTheDwellIsTakenOnceAndTheVoiceNeverReadsItAgain() {
        let ledger = Ledger()
        let voice = voice(dwell: 480, ledger: ledger)
        XCTAssertEqual(voice.accumulatedDwell, 480, accuracy: 1e-12)
        // A negative dwell is not a relationship.
        XCTAssertEqual(HomeVoice(ring: 1, syllable: nil, accumulatedDwell: -9).accumulatedDwell, 0)
    }

    // MARK: - Nothing it knows can reach a screen

    /// Law 2 held by the shape of the type rather than by care: there is nothing
    /// on ``HomeVoice`` a view could bind to or draw, exactly as there is nothing
    /// on ``HomeDwelling``. The only outward path is ``HomeVoice/Instrument``,
    /// whose every member returns `Void`.
    func testTheVoiceHasNothingAViewCouldDraw() throws {
        let source = try String(
            contentsOf: URL(fileURLWithPath: #filePath)
                .resolvingSymlinksInPath()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("Bindu Mandala/Services/HomeVoice.swift"),
            encoding: .utf8)
        for forbidden in ["@Published", "ObservableObject", "@Observable", "import SwiftUI"]
        where source.contains(forbidden) {
            XCTFail("the voice grew something a view can bind to: \(forbidden)")
        }
        // Every member of the instrument is a one-way door.
        XCTAssertFalse(source.contains("-> Bool"), "the voice answered a question")
        XCTAssertFalse(source.contains("-> String"))
    }

    // MARK: - A room is whole with the sound off

    /// **The structural claim of this phase's third item.** The same stay is
    /// driven twice — once with a voice and once with none — and every decision
    /// the room makes is identical. Nothing about the descent, the adaptation,
    /// the stay or the way out is carried by sound.
    func testASilentStayDecidesExactlyWhatASoundingOneDecides() {
        func walk(withVoice: Bool) -> [String] {
            let ledger = Ledger()
            let voice: HomeVoice? = withVoice ? self.voice(dwell: 300, ledger: ledger) : nil
            var descent = TheDescent()
            var stay = TheStay()
            var log: [String] = []

            voice?.opens()
            for station in RiteOfEntering.stations {
                voice?.crossing(station)
                log.append("cross \(station)")
            }
            let clock = RoomClock(opening: HomeMemory.headStart(dwell: 300))
            voice?.inside(clock: clock)
            log.append("offered \(TheDescent.isOffered(atChamberTime: clock.chamberTime()))")
            for _ in 0..<6 { log.append("travel \(descent.onward())") }
            log.append("withdraw \(descent.withdraws())")
            stay.ends(at: 42)
            log.append("stay \(stay.handOver(elapsedNow: 99, entered: true) ?? -1)")
            voice?.closes()
            return log
        }
        XCTAssertEqual(walk(withVoice: true), walk(withVoice: false),
                       "a room with the sound off lost something structural")
    }

    // MARK: - The session ruling

    /// The room asks for the silent switch to be honoured, and gives the session
    /// back at the door. The service's own default is unchanged, because the
    /// rest of the app ruled the other way for a struck bīja.
    func testTheRoomAsksForTheSilentSwitchAndTheServiceDefaultStandsUnchanged() throws {
        let source = try String(
            contentsOf: URL(fileURLWithPath: #filePath)
                .resolvingSymlinksInPath()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("Bindu Mandala/Services/HomeSoundService.swift"),
            encoding: .utf8)
        // `.mixWithOthers` is not valid with `.ambient`; passing it throws and
        // the carrier would never have built its graph at all.
        XCTAssertTrue(source.contains("try session.setCategory(.ambient, mode: .default)"),
                      "the ambient branch grew an option that throws")
        XCTAssertTrue(source.contains("private func restoreSession()"),
                      "the room stopped giving the session back")
        // The service's own default is untouched: a struck bīja still sounds
        // through the switch, which is the rest of the app's own ruling.
        XCTAssertTrue(source.contains("var respectsSilentSwitch = false"))
        // …and the room is the one that asks for the other reading.
        let voiceSource = try String(
            contentsOf: URL(fileURLWithPath: #filePath)
                .resolvingSymlinksInPath()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("Bindu Mandala/Services/HomeVoice.swift"),
            encoding: .utf8)
        XCTAssertTrue(voiceSource.contains("respectsSilentSwitch = true"))
    }
}
