import Foundation
import QuartzCore

// MARK: - Upgrade U0 · the walk's event trace (DEBUG only)
//
// `verification.md` V07: with `WALK_TRACE=1` the app writes one JSON line per
// beat — `{"beat": "<name>", "t": <CACurrentMediaTime>}` — to
// `<WALK_OUT>/trace.jsonl`, so the walk can time arrivals against Design's
// keyframes. `WALK_OUT` is an absolute host path (the simulator reads and
// writes the host's file system); without it the trace stays in memory.
// A Release build never traces.
//
// U0 wires the root's world changes; U1+ add each world's own beats by calling
// `WalkTrace.mark(_:)`.

enum WalkTrace {

    static let isOn: Bool = {
        #if DEBUG
        let p = ProcessInfo.processInfo
        return p.arguments.contains("WALK_TRACE=1") || p.environment["WALK_TRACE"] == "1"
        #else
        return false
        #endif
    }()

    /// `WALK_OUT=<absolute host path>`, as a launch argument or in the environment.
    static let outDirectory: URL? = {
        #if DEBUG
        let p = ProcessInfo.processInfo
        let raw = p.arguments.last(where: { $0.hasPrefix("WALK_OUT=") }).map { String($0.dropFirst("WALK_OUT=".count)) }
            ?? p.environment["WALK_OUT"]
        guard let raw, raw.hasPrefix("/") else { return nil }
        return URL(fileURLWithPath: raw, isDirectory: true)
        #else
        return nil
        #endif
    }()

    private final class Store: @unchecked Sendable {
        let lock = NSLock()
        var held: [String] = []
    }
    private static let store = Store()

    /// The lines written so far in this process (for a unit test or a bench).
    static var lines: [String] {
        store.lock.lock(); defer { store.lock.unlock() }
        return store.held
    }

    /// The JSON line for one beat — pure, so a test can hold its shape.
    static func line(beat: String, t: CFTimeInterval) -> String {
        let escaped = beat.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        return "{\"beat\": \"\(escaped)\", \"t\": \(String(format: "%.4f", t))}"
    }

    /// One beat. Cheap and silent when tracing is off.
    static func mark(_ beat: String, at t: CFTimeInterval = CACurrentMediaTime()) {
        guard isOn else { return }
        let entry = Self.line(beat: beat, t: t)
        store.lock.lock()
        store.held.append(entry)
        store.lock.unlock()
        guard let dir = outDirectory else { return }
        let url = dir.appendingPathComponent("trace.jsonl")
        let data = Data((entry + "\n").utf8)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        if let handle = try? FileHandle(forWritingTo: url) {
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        } else {
            try? data.write(to: url)
        }
    }
}
