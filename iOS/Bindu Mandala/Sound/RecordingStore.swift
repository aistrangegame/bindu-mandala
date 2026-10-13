import Foundation
import CryptoKit

// MARK: - Upgrade U1 · B · bundled, cached, verified
//
// `waves/upgrade/worlds/sound.md` §1.9 and S64: a recording plays from the app
// bundle (`Audio/Songs/<path>`) when it is there; otherwise it streams from
// aistrangegame.com/<path> into `Application Support/AudioCache/<path>`, its
// sha256 checked against the catalogue on that first download, and plays from
// the cache every time after. A file whose bytes do not match is never kept.

/// Where a recording is played from — `sound.md` S64. One download per path at
/// a time; the cache is trusted once a download has been verified into it.
actor RecordingStore {

    static let shared = RecordingStore()

    enum Failure: Error, Equatable {
        /// The path is not in `Recordings.all`.
        case unknown(String)
        /// The server did not answer 200.
        case status(Int)
        /// The bytes are not his recording.
        case shaMismatch(expected: String, got: String)
    }

    private let cacheRoot: URL
    private let session: URLSession
    private let bundle: Bundle
    private var inFlight: [String: Task<URL, Error>] = [:]

    /// `cacheRoot` defaults to `Application Support/AudioCache`.
    init(cacheRoot: URL? = nil, session: URLSession = .shared, bundle: Bundle = .main) {
        if let cacheRoot {
            self.cacheRoot = cacheRoot
        } else {
            let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
                ?? FileManager.default.temporaryDirectory
            self.cacheRoot = support.appendingPathComponent("AudioCache", isDirectory: true)
        }
        self.session = session
        self.bundle = bundle
    }

    // MARK: Pure

    /// Lower-case hex SHA-256.
    nonisolated static func sha256Hex(_ data: Data) -> String {
        SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }

    /// Throws `.shaMismatch` unless `data` is exactly `recording`.
    nonisolated static func verify(_ data: Data, against recording: Recording) throws {
        let got = sha256Hex(data)
        guard got == recording.sha256 else {
            throw Failure.shaMismatch(expected: recording.sha256, got: got)
        }
    }

    // MARK: Where it lives

    /// The cache file for a path.
    nonisolated func cacheURL(for path: String) -> URL {
        cacheRoot.appendingPathComponent(path, isDirectory: false)
    }

    /// The bundled copy, if a later wave bundled it.
    nonisolated func bundledURL(for path: String) -> URL? {
        let file = (path as NSString).lastPathComponent
        let dir = (path as NSString).deletingLastPathComponent
        let name = (file as NSString).deletingPathExtension
        let ext = (file as NSString).pathExtension
        let sub = dir.isEmpty ? Recordings.bundleSubdirectory : Recordings.bundleSubdirectory + "/" + dir
        return bundle.url(forResource: name, withExtension: ext, subdirectory: sub)
    }

    nonisolated func isCached(_ path: String) -> Bool {
        FileManager.default.fileExists(atPath: cacheURL(for: path).path)
    }

    // MARK: Resolve

    /// A local file URL for the recording at `path`: the bundle, else the
    /// cache, else a verified download into the cache.
    func localURL(for path: String) async throws -> URL {
        guard let recording = Recordings.recording(path) else { throw Failure.unknown(path) }
        if let bundled = bundledURL(for: path) { return bundled }
        if isCached(path) { return cacheURL(for: path) }
        if let running = inFlight[path] { return try await running.value }
        let target = cacheURL(for: path)
        let session = self.session
        let task = Task<URL, Error> {
            let (data, response) = try await session.data(from: Recordings.remoteURL(path))
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                throw Failure.status(http.statusCode)
            }
            try RecordingStore.verify(data, against: recording)
            try FileManager.default.createDirectory(at: target.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try data.write(to: target, options: .atomic)
            return target
        }
        inFlight[path] = task
        defer { inFlight[path] = nil }
        return try await task.value
    }
}
