import Foundation
import AVFoundation
import Speech
import os

private let speechLog = Logger(subsystem: "com.ashrey.bindu-mandala", category: "speech")

/// Wave 6 · the shared capture for every spoken "own word" — a letter, a
/// Codex note, the month's answer (Bindu Feed's `SpeechCapture`, rebuilt here).
///
/// His voice is recorded with `AVAudioRecorder` to a file in
/// `Application Support/Practice/voice/` (practice data: backed up with the
/// phone, never deleted), and when he stops, the file is set down as words by
/// `SFSpeechRecognizer` — **on the device** wherever the device can, so his
/// voice never leaves the phone to become text. The words are his and may be
/// corrected before anything is set down; nothing here completes, rewrites or
/// answers them. The sound is his own voice and nothing is ever generated.
///
/// Permissions are asked the first time he touches the voice, never on load:
/// `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`.
// Not actor-isolated as a type (so a view can hold it as `@StateObject`); every
// method that touches state is `@MainActor`.
final class SpeechCapture: ObservableObject {

    enum State: Equatable {
        case idle
        case recording
        case settingDown
        /// The microphone was refused; the composer stays a page to type on.
        case refused
    }

    @Published private(set) var state: State = .idle

    private var recorder: AVAudioRecorder?
    private var fileName: String?

    // MARK: Where his voice lives

    static var voiceDirectory: URL {
        PracticeVault.defaultDirectory.appendingPathComponent("voice", isDirectory: true)
    }

    static func url(for file: String) -> URL {
        voiceDirectory.appendingPathComponent(file)
    }

    static func exists(_ file: String?) -> Bool {
        guard let file, !file.isEmpty else { return false }
        return FileManager.default.fileExists(atPath: url(for: file).path)
    }

    // MARK: Permission

    /// The microphone (required) and speech (wished for — without it the voice
    /// is still kept, and the words are his to type).
    @MainActor
    func askPermission() async -> Bool {
        let mic: Bool = await withCheckedContinuation { c in
            AVAudioApplication.requestRecordPermission { granted in
                c.resume(returning: granted)
            }
        }
        if SFSpeechRecognizer.authorizationStatus() == .notDetermined {
            let _: Bool = await withCheckedContinuation { c in
                SFSpeechRecognizer.requestAuthorization { status in
                    c.resume(returning: status == .authorized)
                }
            }
        }
        if !mic { state = .refused }
        return mic
    }

    // MARK: Recording

    /// Begin keeping his voice. Returns false if the microphone is refused or
    /// the recorder cannot start.
    @discardableResult
    @MainActor
    func begin() async -> Bool {
        guard state != .recording else { return true }
        guard await askPermission() else { return false }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default,
                                    options: [.defaultToSpeaker, .mixWithOthers])
            try session.setActive(true)
            try FileManager.default.createDirectory(at: Self.voiceDirectory,
                                                    withIntermediateDirectories: true)
            let name = "voice-\(UUID().uuidString).m4a"
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            ]
            let r = try AVAudioRecorder(url: Self.url(for: name), settings: settings)
            guard r.record() else { return false }
            recorder = r
            fileName = name
            state = .recording
            return true
        } catch {
            speechLog.error("Voice could not begin: \(error.localizedDescription, privacy: .public)")
            state = .idle
            return false
        }
    }

    /// Stop, and set his voice down as words. Returns the file his voice was
    /// kept in and the words (empty when the device could not hear them).
    @MainActor
    func end() async -> (file: String, words: String)? {
        guard let r = recorder, let name = fileName else { return nil }
        r.stop()
        recorder = nil
        fileName = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        state = .settingDown
        let words = await Self.words(in: Self.url(for: name))
        state = .idle
        return (name, words)
    }

    /// Let go without keeping anything new (the sheet closed mid-breath). The
    /// file stays on disk — his voice is never deleted — and simply is not used.
    @MainActor
    func abandon() {
        recorder?.stop()
        recorder = nil
        fileName = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        if state != .refused { state = .idle }
    }

    // MARK: Words

    /// A small box that keeps the recogniser and its task alive until the
    /// words have come back, and makes sure the answer is given exactly once.
    private final class Hearing {
        var recognizer: SFSpeechRecognizer?
        var task: SFSpeechRecognitionTask?
        var answered = false
        let lock = NSLock()

        func answer(_ words: String, _ c: CheckedContinuation<String, Never>) {
            lock.lock()
            let first = !answered
            answered = true
            lock.unlock()
            guard first else { return }
            c.resume(returning: words)
            task = nil
            recognizer = nil
        }
    }

    /// The words in a recording, heard on the device where it can.
    static func words(in url: URL) async -> String {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else { return "" }
        guard let recognizer = SFSpeechRecognizer(locale: Locale.current)
                ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US")),
              recognizer.isAvailable else { return "" }
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        if recognizer.supportsOnDeviceRecognition {
            request.requiresOnDeviceRecognition = true
        }
        let hearing = Hearing()
        hearing.recognizer = recognizer
        return await withCheckedContinuation { (c: CheckedContinuation<String, Never>) in
            hearing.task = recognizer.recognitionTask(with: request) { result, error in
                if let result, result.isFinal {
                    hearing.answer(result.bestTranscription.formattedString, c)
                } else if error != nil {
                    hearing.answer(result?.bestTranscription.formattedString ?? "", c)
                }
            }
        }
    }
}

/// Plays his own voice back — a kept letter, a kept note. Nothing else.
final class VoicePlayback: ObservableObject {
    @Published private(set) var playing = false
    private var player: AVAudioPlayer?
    private var watch: Task<Void, Never>?

    @MainActor
    func play(_ file: String) {
        stop()
        guard SpeechCapture.exists(file) else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers])
            try session.setActive(true)
            let p = try AVAudioPlayer(contentsOf: SpeechCapture.url(for: file))
            p.prepareToPlay()
            guard p.play() else { return }
            player = p
            playing = true
            // Wave 6.1 · one sound at a time: his voice is in front while it speaks.
            SoundConductor.shared.strike(.voice, seconds: p.duration)
            watch = Task { @MainActor [weak self] in
                while let strong = self, let p = strong.player, p.isPlaying, !Task.isCancelled {
                    try? await Task.sleep(for: .milliseconds(250))
                }
                self?.playing = false
            }
        } catch {
            speechLog.error("Voice could not play: \(error.localizedDescription, privacy: .public)")
        }
    }

    @MainActor
    func stop() {
        watch?.cancel()
        watch = nil
        player?.stop()
        player = nil
        playing = false
    }
}
