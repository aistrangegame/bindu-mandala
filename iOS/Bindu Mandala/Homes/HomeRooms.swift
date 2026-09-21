import Foundation

// MARK: - Which room a Śakti gets
//
// The resolution order, from `Claude Code Handoff - The Homes.md` §4.3 and
// `homes-chambers.js`'s `buildChamber`:
//
//   1. her **authored** mechanism, if she has one
//   2. else her ring's **archetype**, tuned by her own row through the grammar
//   3. else her **seat** interior, gem-lit
//
// Then her **attribute** is added to whatever room resulted. Design says it in
// one line: *"Her attribute joins whatever room she has — hand-authored or
// grammar-built. The room is the mechanism; the attribute is the one thing
// acting inside it."*
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THIS FILE IS, AND IS NOT
// ─────────────────────────────────────────────────────────────────────────────
//
// **Pure logic only.** No SceneKit, no SwiftUI, no geometry, no shaders, no
// view. The renderer ruling (charter §2.4) decides how a room is *drawn*; it
// does not touch what a room *is*, and this is the half that ports one-to-one
// either way.
//
// **The dispatch, not the mechanisms.** The eight authored rooms are geometry —
// a ceiling that descends, a floor that lets go — and they belong to Phase 3.3
// under the ruled renderer. What is built here is the *rule that picks them*,
// with each of the eight standing as a named placeholder the renderer phase
// fills in. ``HomeMechanism`` is the door they will walk through.
//
// **No bundled roster.** Every input is read off ``Shakti`` — the row the sync
// fills from the base. Nothing here holds a name, a quality, a tattva or a
// phrase, and nothing here consults one.

// MARK: - The eight authored mechanisms

/// One of Design's eight hand-authored rooms, named by what the room **does**.
///
/// Design's `homes-chambers.js` keys these by Śakti *name*, and four of its
/// eight keys are ghost spellings that match no card: `Animā` (the card is
/// `Aṇimā`), `Vaśitā` (`Vaśitva`), `Sarvayoni` (`Sarva-Yoni`) and
/// `Sarvatrikhaṇḍā` (`Sarva-Trikhaṇḍā`). In Design's own shipped Axis those
/// four rooms silently fall through to the grammar, and its harness cannot see
/// it happen — there is no test that an authored room is actually reached.
///
/// So the map here is keyed by ``Shakti/khadgamalaPosition``, which is the only
/// key the laws allow and the only one that cannot be misspelled
/// (`Claude Chat/BUILD-BRIEF-V2-ERRATA.md` §3.x), and
/// `HomesHarnessTests.testEveryAuthoredPositionReachesItsAuthoredMechanism`
/// asserts all eight arrive — the test Design lacked.
enum HomeAuthoredMechanism: String, CaseIterable, Equatable {
    /// kp 1 · the room closes in until smallness is the only place left.
    case contract
    /// kp 3 · the floor lets go.
    case release
    /// kp 4 · the ceiling comes down the whole visit.
    case press
    /// kp 2 · the room has no far wall.
    case endless
    /// kp 6 · it has turned, and it rests on you.
    case known
    /// kp 27 · the wall is a membrane, and it is passing through you.
    case membrane
    /// kp 28 · three rooms standing in one another.
    case triple
    /// kp 102 · the room stops being a room.
    case dissolve

    /// The function in `homes-chambers.js` this stands for. Traceability only —
    /// Phase 3.3 ports the body; nothing reads this at runtime.
    var designFunction: String {
        switch self {
        case .contract: return "chamberContract"
        case .release:  return "chamberRelease"
        case .press:    return "chamberPress"
        case .endless:  return "chamberEndless"
        case .known:    return "chamberKnown"
        case .membrane: return "chamberMembrane"
        case .triple:   return "chamberTriple"
        case .dissolve: return "chamberDissolve"
        }
    }
}

/// The door an authored room walks through.
///
/// **Phase 3.3 fills these in.** Every conforming type below is a placeholder
/// that knows which of the eight it is and nothing else: the geometry — the
/// descending ceiling, the released floor, the membrane wall — is renderer work
/// and waits on the ruling. What is provable today is that the dispatch hands
/// each authored position *its own* mechanism and no other's.
protocol HomeMechanism {
    /// Which of the eight this type is. The dispatch's whole contract.
    static var kind: HomeAuthoredMechanism { get }
    init()
}

/// kp 1 · PHASE 3.3.
struct ContractMechanism: HomeMechanism { static let kind = HomeAuthoredMechanism.contract; init() {} }
/// kp 3 · PHASE 3.3. One half of the Gate (ruling R10).
struct ReleaseMechanism: HomeMechanism { static let kind = HomeAuthoredMechanism.release; init() {} }
/// kp 4 · PHASE 3.3. The other half of the Gate (ruling R10).
struct PressMechanism: HomeMechanism { static let kind = HomeAuthoredMechanism.press; init() {} }
/// kp 2 · PHASE 3.3.
struct EndlessMechanism: HomeMechanism { static let kind = HomeAuthoredMechanism.endless; init() {} }
/// kp 6 · PHASE 3.3.
struct KnownMechanism: HomeMechanism { static let kind = HomeAuthoredMechanism.known; init() {} }
/// kp 27 · PHASE 3.3.
struct MembraneMechanism: HomeMechanism { static let kind = HomeAuthoredMechanism.membrane; init() {} }
/// kp 28 · PHASE 3.3.
struct TripleMechanism: HomeMechanism { static let kind = HomeAuthoredMechanism.triple; init() {} }
/// kp 102 · PHASE 3.3.
struct DissolveMechanism: HomeMechanism { static let kind = HomeAuthoredMechanism.dissolve; init() {} }

extension HomeAuthoredMechanism {

    /// The placeholder type Phase 3.3 will fill. The dispatch returns the type,
    /// not an instance, so the renderer phase can hand it whatever a built room
    /// needs without changing this file.
    var placeholder: any HomeMechanism.Type {
        switch self {
        case .contract: return ContractMechanism.self
        case .release:  return ReleaseMechanism.self
        case .press:    return PressMechanism.self
        case .endless:  return EndlessMechanism.self
        case .known:    return KnownMechanism.self
        case .membrane: return MembraneMechanism.self
        case .triple:   return TripleMechanism.self
        case .dissolve: return DissolveMechanism.self
        }
    }
}

// MARK: - What a room turned out to be

/// Which of the three the resolution order landed on.
enum HomeRoomKind: Equatable {
    /// She has a hand-authored mechanism. Phase 3.3 builds its geometry.
    case authored(HomeAuthoredMechanism)
    /// Her ring's archetype, tuned by her own row.
    case grammar(HomeGrammar.Reading)
    /// Her seat interior, gem-lit — the floor every un-resolved Śakti inherits.
    case seat
}

/// One Śakti's room, resolved: the world it stands in, its light, what kind of
/// room it turned out to be, and the one thing acting inside it.
///
/// Equatable and pure. It holds no geometry, so the ruled renderer can draw it
/// either way, and it holds no name, so it cannot become a roster.
struct HomeRoom: Equatable {
    /// `khadgamalaPosition` 1–102. The only key.
    let position: Int
    /// Her āvaraṇa, 1–9.
    let ring: Int
    /// The weather she stands in, with the live base laid over Design's table.
    let world: HomeWorld
    /// Her light, jittered off her position.
    let gem: HomeGem
    /// What the resolution order landed on.
    let kind: HomeRoomKind
    /// The one thing that acts inside the room, whichever room it is.
    /// `nil` only for a position outside 1–102.
    let attribute: HomeAttributeActor?
    /// Where on the body she lives, `0` crown … `1` soles. Unified: read from
    /// ``HomeGrammar/bodyAltitude(bodilyLocation:)``, the single zone table.
    let bodyAltitude: Double

    /// Her words, where the grammar speaks for her. An authored room writes its
    /// own (Phase 3.3), and a seat has none.
    var label: HomeLabel? {
        if case .grammar(let reading) = kind { return reading.label }
        return nil
    }

    /// True when the room is a room of her own rather than the shared seat.
    /// Design's `isBuilt`, decided by position rather than by name.
    var isBuilt: Bool {
        if case .seat = kind { return false }
        return true
    }
}

// MARK: - The resolution order

enum HomeRooms {

    /// Design's `BY_NAME`, **re-keyed to `khadgamalaPosition`**.
    ///
    /// The positions come from the errata (§3.x): `{1, 2, 3, 4, 6, 27, 28,
    /// 102}`. The pairing is Design's own, read off the cards at those
    /// positions — kp 1 `Aṇimā` contracts, kp 2 `Mahimā` is endless, kp 3
    /// `Laghimā` releases, kp 4 `Garimā` presses, kp 6 `Vaśitva` is known,
    /// kp 27 `Sarva-Yoni` is the membrane, kp 28 `Sarva-Trikhaṇḍā` is triple,
    /// kp 102 `Mahātripurasundarī` dissolves.
    ///
    /// Note that kp 2 is Vastness and kp 3 is Lightness, not the other way
    /// round: a map keyed by name cannot tell you that, and a map keyed by
    /// position cannot get it wrong.
    static let authored: [Int: HomeAuthoredMechanism] = [
        1: .contract,
        2: .endless,
        3: .release,
        4: .press,
        6: .known,
        27: .membrane,
        28: .triple,
        102: .dissolve,
    ]

    /// Her authored mechanism, if she has one. Position is the only key.
    static func authoredMechanism(atPosition position: Int) -> HomeAuthoredMechanism? {
        authored[position]
    }

    /// The rings the grammar speaks for. Ring 9 is absent: the Bindu's room is
    /// authored, and the grammar declines rather than inventing one.
    static let grammarRings: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8]

    // MARK: · The rule itself

    /// Which room this Śakti gets, from plain values.
    ///
    /// **The order is the whole point, and it is Design's:** her authored
    /// mechanism first; else her ring archetype tuned by her own data through
    /// the grammar; else her seat, gem-lit. Her attribute is then added to
    /// whatever room resulted — it is never a fourth branch.
    ///
    /// `live` is the āvaraṇa row where the base has been reached, so its name,
    /// presiding Form, Yoginī class and mental state win over Design's table
    /// (law 1). `nil` outside rings 1–9, which is the absence of a world rather
    /// than a room to guess at.
    static func resolve(position: Int,
                        ring: Int,
                        tattva: String,
                        quality: String,
                        bodilyLocation: String,
                        bija: String? = nil,
                        live: HomeWorlds.LiveFacts? = nil) -> HomeRoom? {
        guard let world = HomeWorlds.world(ring: ring, live: live) else { return nil }
        let gem = HomeGem.gemFor(ring: ring, khadgamalaPosition: position)
        let altitude = HomeGrammar.bodyAltitude(bodilyLocation: bodilyLocation)

        let kind: HomeRoomKind
        if let mechanism = authoredMechanism(atPosition: position) {
            // 1 · hers, by hand.
            kind = .authored(mechanism)
        } else if grammarRings.contains(ring),
                  let reading = HomeGrammar.read(position: position, ring: ring,
                                                 tattva: tattva, quality: quality,
                                                 bodilyLocation: bodilyLocation, bija: bija) {
            // 2 · her ring's archetype, tuned by her own row.
            kind = .grammar(reading)
        } else {
            // 3 · her seat, gem-lit.
            kind = .seat
        }

        // …and her attribute joins whichever room that was.
        return HomeRoom(position: position,
                        ring: ring,
                        world: world,
                        gem: gem,
                        kind: kind,
                        attribute: HomeAttribute.actor(atPosition: position,
                                                       bodilyLocation: bodilyLocation),
                        bodyAltitude: altitude)
    }

    /// Which room this Śakti gets, read straight off her synced row.
    ///
    /// A row without a khaḍgamālā position or a ring has no identity the laws
    /// recognise, and so no room — `nil` rather than a guess at one.
    static func resolve(_ shakti: Shakti, live: HomeWorlds.LiveFacts? = nil) -> HomeRoom? {
        guard let position = shakti.khadgamalaPosition,
              let ring = shakti.ringNumber else { return nil }
        return resolve(position: position,
                       ring: ring,
                       tattva: shakti.tattva,
                       quality: shakti.quality,
                       bodilyLocation: shakti.bodilyLocation,
                       bija: shakti.bijaSyllable,
                       live: live)
    }
}
