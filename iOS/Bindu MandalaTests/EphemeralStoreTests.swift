import XCTest
@testable import Bindu_Mandala

// MARK: - EphemeralStoreTests — the harness's own store, and the law it may not touch
//
// `FeltRegisterSnapshots` reads ten screens against a committed geometry. Every
// one of those baselines was recorded on a store with nothing in it, and two of
// the screens *write*: the shipped `BinduMandalaUITests` records a recognition,
// and so does the ceremony screen at the end of the snapshot roster. Read off
// the practitioner's own on-disk store, the Field then says "felt here" beside a
// Śakti who has one, and the suite reports a composition change that is really
// just the container remembering the last run.
//
// The answer is `EPHEMERAL_STORE`: a UI-test launch gets a fresh in-memory store
// and leaves the disk alone. The suite becomes order-independent and re-runnable
// without erasing a simulator between passes.
//
// Charter §2 law 8 is why this file exists. A launch argument that could reach a
// practitioner's store would be a way to lose his practice, so two things have to
// be true at once and both are asserted here:
//
//  1. It is **DEBUG-only**. The argument does not exist in a shipped build.
//  2. It is **non-destructive**. The ephemeral path returns before anything on
//     disk is opened, preserved or removed — it does not delete, and it does not
//     call `preserveExistingStore`.

final class EphemeralStoreTests: XCTestCase {

    private func source(_ name: String) -> SourceFile? { LawSource.production(name) }

    func testTheEphemeralStoreExistsOnlyInADebugBuild() {
        guard let f = source("BinduMandalaApp.swift") else {
            return XCTFail("BinduMandalaApp is gone")
        }
        guard let decl = Rx.first(#"usesEphemeralStore: Bool = \{[\s\S]*?\n    \}\(\)"#, f.text) else {
            return XCTFail("`AppRuntime.usesEphemeralStore` is gone — the UI suite's store flag")
        }
        XCTAssertTrue(decl.contains("#if DEBUG"),
                      "EPHEMERAL_STORE is no longer behind #if DEBUG: a shipped build could be "
                      + "launched onto an empty store (charter §2, law 8)")
        XCTAssertTrue(decl.contains("#else\n        return false"),
                      "the release branch of EPHEMERAL_STORE must be an unconditional false")
        // The string itself appears exactly once, inside that declaration, so no
        // second reader can grow a different meaning for the same argument.
        XCTAssertEqual(Rx.all(#"EPHEMERAL_STORE"#, String(f.lexed.masked)).count, 0,
                       "EPHEMERAL_STORE appears in code outside its own string literal")
        XCTAssertEqual(Rx.all(#""EPHEMERAL_STORE""#, f.text).count, 1,
                       "EPHEMERAL_STORE is read in more than one place")
    }

    func testTheEphemeralPathNeverTouchesTheStoreOnDisk() {
        guard let f = source("PersistenceRecovery.swift") else {
            return XCTFail("PersistenceRecovery is gone")
        }
        guard let body = Rx.first(#"static func makeContainer\([\s\S]*?\n    \}"#, f.text) else {
            return XCTFail("`makeContainer` is gone")
        }
        guard let branch = Rx.first(#"if AppRuntime\.usesEphemeralStore \{[\s\S]*?\n        \}"#, body) else {
            return XCTFail("`makeContainer` no longer honours the ephemeral store")
        }
        XCTAssertTrue(branch.contains("isStoredInMemoryOnly: true"),
                      "the ephemeral branch opens something other than an in-memory store")
        for forbidden in ["preserveExistingStore", "removeItem", "moveItem", "trashItem"] {
            XCTAssertFalse(branch.contains(forbidden),
                           "the ephemeral branch reaches the disk via \(forbidden) — law 8 says a "
                           + "debug argument may never stand between him and his practice")
        }
        // It has to come *first*: after the on-disk open, a corrupt store would
        // already have been preserved aside before the flag was ever read.
        let ephemeralAt = body.range(of: "AppRuntime.usesEphemeralStore")?.lowerBound
        let diskAt = body.range(of: "migrationPlan: BinduMigrationPlan.self")?.lowerBound
        guard let ephemeralAt, let diskAt else { return XCTFail("makeContainer changed shape") }
        XCTAssertLessThan(ephemeralAt, diskAt,
                          "the ephemeral branch is read after the on-disk store is opened")
    }

    /// And it is off unless somebody asks for it. The unit host passes no such
    /// argument, so this is the real runtime value, not a re-reading of source.
    func testItIsOffByDefault() {
        XCTAssertFalse(AppRuntime.usesEphemeralStore,
                       "the ephemeral store is on in a process that never asked for it")
    }
}
