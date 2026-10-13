import XCTest
@testable import Bindu_Mandala

// MARK: - U0 · the World Registry's seed, the snapshot source and the walk trace
//
// verification.md V11 (the fifteen worlds, each addressable), V18 (the walk
// state: OPEN_WORLD, SNAPSHOT, WALK_OUT, WALK_TRACE) and the data floor that a
// snapshot launch never writes live (V35). Each check is shown able to fail on
// a planted defect beside it (V30).

final class WorldRegistryTests: XCTestCase {

    // MARK: V11 · the fifteen

    func testTheRegistryHoldsExactlyTheFifteenWorlds() {
        XCTAssertEqual(WorldID.allCases.map(\.rawValue),
                       ["home", "today", "mandala", "rings", "herHome", "herPresence", "climb",
                        "the33", "game", "modes", "time", "memory", "well", "beneath", "relationship"])
        XCTAssertEqual(WorldID.allCases.count, 15)
        XCTAssertEqual(Set(WorldID.allCases.map(\.sentinel)).count, 15, "two worlds share a sentinel")
        for w in WorldID.allCases {
            XCTAssertEqual(w.sentinel, "world.\(w.rawValue)")
            XCTAssertFalse(w.title.isEmpty)
            XCTAssertTrue(NeverMeasure.measuresOutLoud(w.title).isEmpty)
        }
    }

    /// Every world is routable in U0: its closest screen is one RootView has.
    func testEveryWorldOpensAnExistingScreen() {
        let screens: Set<String> = ["mandala", "rite", "well", "the102", "memory"]
        for w in WorldID.allCases {
            XCTAssertTrue(screens.contains(w.u0Destination), "\(w) opens \(w.u0Destination), which is no screen")
        }
        XCTAssertEqual(WorldID.home.u0Destination, "mandala", "the Bindu is the Mandala's centre in U0")
        XCTAssertEqual(WorldID.today.u0Destination, "rite")
        XCTAssertTrue(WorldID.climb.opensClimb)
        XCTAssertTrue(WorldID.game.opensPlayField)
        XCTAssertTrue(WorldID.beneath.opensDescent)
        XCTAssertEqual(WorldID.allCases.filter(\.opensClimb), [.climb])
    }

    func testOpenWorldIsReadFromTheLaunchArguments() {
        XCTAssertEqual(WorldID.fromLaunchArguments(["OPEN_WORLD=well"]), .well)
        XCTAssertEqual(WorldID.fromLaunchArguments(["OPEN_WORLD=well", "OPEN_WORLD=the33"]), .the33, "the last wins")
        XCTAssertNil(WorldID.fromLaunchArguments(["OPEN_WORLD=nowhere"]), "an unknown world opened something")
        XCTAssertNil(WorldID.fromLaunchArguments(["START_TAB=well"]))
        XCTAssertNil(WorldID.fromLaunchArguments([]))
    }

    /// The six-way ring seeds the registry: every way in reaches a world.
    func testEveryWayInReachesAWorld() {
        for way in WayIn.allCases {
            XCTAssertTrue(WorldID.allCases.contains(WorldID.reached(by: way)))
        }
    }

    // MARK: V18 · the snapshot source

    private var snapshot: URL {
        SourceTree.iOSRoot.appendingPathComponent("Bindu MandalaTests/Snapshot/2026-10-13", isDirectory: true)
    }

    /// The dated export re-shaped to the API's page: all 102 Śaktis, the nine
    /// āvaraṇas and fifteen Nityās, by field id, selects as names, links as ids.
    func testTheSnapshotReadsAsTheAPIWouldServeIt() throws {
        for (type, count) in [("Shakti", 102), ("Avarana", 9), ("Nitya", 15)] {
            let data = try SnapshotSource.mandalaPage(rowType: type, in: snapshot)
            let page = try XCTUnwrap(try JSONSerialization.jsonObject(with: data) as? [String: Any])
            let records = try XCTUnwrap(page["records"] as? [[String: Any]])
            XCTAssertEqual(records.count, count, "\(type) rows")
            for r in records {
                XCTAssertTrue((r["id"] as? String)?.hasPrefix("rec") ?? false)
                let fields = try XCTUnwrap(r["fields"] as? [String: Any])
                XCTAssertEqual(fields[SnapshotSource.rowTypeFieldId] as? String, type, "a select stayed an object")
                for (_, v) in fields {
                    if let d = v as? [String: Any] {
                        XCTAssertNil(d["color"], "a select was not reduced to its name")
                    }
                }
            }
        }
        // The 102 are the garland, each once (position is identity).
        let shaktis = try JSONSerialization.jsonObject(
            with: SnapshotSource.mandalaPage(rowType: "Shakti", in: snapshot)) as? [String: Any]
        let kps = (shaktis?["records"] as? [[String: Any]] ?? [])
            .compactMap { ($0["fields"] as? [String: Any])?["fldI0aV1sfOeNybHI"] as? Int }
        XCTAssertEqual(kps.sorted(), Array(1...102))
    }

    func testTheExportCellBecomesTheAPICell() {
        XCTAssertEqual(SnapshotSource.normalised(["id": "selLVz", "name": "Mapped", "color": "gray"]) as? String, "Mapped")
        XCTAssertEqual(SnapshotSource.normalised([["id": "recA", "name": "Garimā"]]) as? [String], ["recA"])
        XCTAssertEqual(SnapshotSource.normalised("Garimā") as? String, "Garimā", "a string changed")
        let other = SnapshotSource.normalised(["url": "https://x"]) as? [String: String]
        XCTAssertEqual(other, ["url": "https://x"], "an unknown object was rewritten")
    }

    /// A unit-test host is not a snapshot launch, and the mock refuses a write
    /// it was not asked to hold — so it can never swallow a real one.
    @MainActor
    func testTheMockOnlyTakesWritesInASnapshotLaunch() {
        XCTAssertNil(SnapshotSource.date)
        XCTAssertFalse(SnapshotSource.isActive)
        XCTAssertFalse(SnapshotLedger.shared.divert(entry: "x", table: "t", summary: "s"),
                       "the mock took a write outside a snapshot launch")
        XCTAssertTrue(SnapshotLedger.shared.writes.isEmpty)
    }

    // MARK: V35 · a snapshot launch never writes live

    /// Every write entry point in `AirtableService` hands its row to the mock
    /// (or the snapshot read) **before** it can reach a request — read from the
    /// source, so a new write that forgets fails here.
    static let writeEntryPoints = [
        "func recordRecognition(", "func advanceStatus(", "func recordCrossing(", "func saveLetter(",
        "func logActivity(_ item: PendingActivity)", "func recordSilence(", "func recordMilestone(",
        "func recordNote(", "func writeCodexNote(", "func sync(context: ModelContext)",
    ]

    static func divertsFirst(_ body: String) -> Bool {
        guard let divert = [body.range(of: "SnapshotLedger.shared.divert"),
                            body.range(of: "SnapshotSource.isActive")].compactMap({ $0 }).min(by: { $0.lowerBound < $1.lowerBound })
        else { return false }
        for network in ["URLRequest(", "session.data(", "syncIsDisabled()", "processActivity(", "enqueue"] {
            if let n = body.range(of: network), n.lowerBound < divert.lowerBound { return false }
        }
        return true
    }

    func testEveryWriteDivertsToTheMockBeforeTheNetwork() throws {
        let service = try XCTUnwrap(LawSource.production("AirtableService.swift"))
        let code = String(service.lexed.masked)
        for entry in Self.writeEntryPoints {
            let start = try XCTUnwrap(code.range(of: entry), "\(entry) is gone from AirtableService")
            let rest = code[start.upperBound...]
            let end = rest.range(of: "\n    }\n")?.lowerBound ?? rest.endIndex
            XCTAssertTrue(Self.divertsFirst(String(rest[..<end])),
                          "\(entry) can reach the network before a snapshot launch diverts it")
        }
        // Born red: a write with no diversion fails.
        XCTAssertFalse(Self.divertsFirst("""
            if syncIsDisabled() { return }
            let req = URLRequest(url: u)
            """))
        XCTAssertTrue(Self.divertsFirst("""
            if SnapshotLedger.shared.divert(entry: "x", table: "t", summary: "s") { return }
            if syncIsDisabled() { return }
            """))
    }

    /// A snapshot launch counts as sync-disabled everywhere else too.
    func testTheSnapshotTurnsSyncOff() throws {
        let app = try XCTUnwrap(LawSource.production("BinduMandalaApp.swift"))
        let decl = try XCTUnwrap(Rx.first(#"static var syncDisabled: Bool = [\s\S]*?\n\n"#, String(app.lexed.masked)))
        XCTAssertTrue(decl.contains("SnapshotSource.isActive"), "a snapshot launch could sync live")
        let src = try XCTUnwrap(LawSource.production("SnapshotSource.swift"))
        XCTAssertTrue(src.text.contains("#if DEBUG"), "SNAPSHOT is honoured outside DEBUG")
        let world = try XCTUnwrap(LawSource.production("WorldID.swift"))
        XCTAssertTrue(world.text.contains("#if DEBUG"), "OPEN_WORLD is honoured outside DEBUG")
    }

    // MARK: V07 · the walk trace

    func testTheTraceLineIsOneJSONObject() throws {
        let line = WalkTrace.line(beat: "destination.\"mandala\"", t: 12.5)
        let obj = try XCTUnwrap(try JSONSerialization.jsonObject(with: Data(line.utf8)) as? [String: Any])
        XCTAssertEqual(obj["beat"] as? String, "destination.\"mandala\"")
        XCTAssertEqual(obj["t"] as? Double ?? -1, 12.5, accuracy: 1e-9)
        XCTAssertFalse(WalkTrace.isOn, "the unit-test host traces")
    }
}
