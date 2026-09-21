// Measuring apparatus, not part of the app. The whole Spike folder is compiled
// out of Release, so nothing here — including SpikeBench's hiding and restoring of
// the practitioner's own window — can exist in a build that reaches Neev. The test
// action builds Debug, so every spike test still sees it.
#if DEBUG
import Foundation
import QuartzCore

#if canImport(Darwin)
import Darwin
#endif

/// Test-only instrumentation for the G5 spike. Nothing here is reachable from any
/// shipped screen: no shipped view references it, it draws nothing, and it is only
/// ever entered from the test targets. It exists so every spike variant — and the
/// shipped Living Mandala it must be judged against — is measured by exactly the
/// same ruler.
///
/// **What it can and cannot tell you.** These are *simulator* numbers. A simulator
/// runs the render on the Mac's GPU through a translation layer and its CPU is not
/// the phone's; absolute milliseconds and absolute megabytes here do NOT predict
/// device behaviour. Only the *relative* comparison between two variants measured
/// on the same host, in the same session, at the same configuration is meaningful.
/// Every report this file emits carries that caveat in its own payload so it cannot
/// be quoted out of context.
enum SpikeMetrics {

    // MARK: - Memory

    /// Resident footprint in bytes — `phys_footprint`, the same figure Xcode's
    /// memory gauge and jetsam use. 0 if the kernel call fails.
    static func footprintBytes() -> UInt64 {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size)
        let kr: kern_return_t = withUnsafeMutablePointer(to: &info) { ptr in
            ptr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &count)
            }
        }
        guard kr == KERN_SUCCESS else { return 0 }
        return UInt64(info.phys_footprint)
    }

    static func footprintMB() -> Double { Double(footprintBytes()) / 1_048_576 }

    // MARK: - CPU

    /// Total CPU seconds this process has burned (user + system), across live and
    /// already-terminated threads. Sampled at the two ends of a window and divided
    /// by the frames in it, this gives CPU-per-frame — the number that actually
    /// separates a cheap scene from an expensive one, since presented frame
    /// *cadence* saturates at the display refresh long before the work does.
    static func taskCPUSeconds() -> Double {
        var live = task_thread_times_info_data_t()
        var liveCount = mach_msg_type_number_t(MemoryLayout<task_thread_times_info_data_t>.size / MemoryLayout<natural_t>.size)
        let liveKR: kern_return_t = withUnsafeMutablePointer(to: &live) { ptr in
            ptr.withMemoryRebound(to: integer_t.self, capacity: Int(liveCount)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(TASK_THREAD_TIMES_INFO), intPtr, &liveCount)
            }
        }

        var basic = mach_task_basic_info()
        var basicCount = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size / MemoryLayout<natural_t>.size)
        let basicKR: kern_return_t = withUnsafeMutablePointer(to: &basic) { ptr in
            ptr.withMemoryRebound(to: integer_t.self, capacity: Int(basicCount)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), intPtr, &basicCount)
            }
        }

        var total: Double = 0
        if liveKR == KERN_SUCCESS {
            total += seconds(live.user_time) + seconds(live.system_time)
        }
        if basicKR == KERN_SUCCESS {
            // mach_task_basic_info carries the time of threads that have already exited.
            total += seconds(basic.user_time) + seconds(basic.system_time)
        }
        return total
    }

    private static func seconds(_ t: time_value_t) -> Double {
        Double(t.seconds) + Double(t.microseconds) / 1_000_000
    }

    /// One-minute load average of the **host Mac** — a simulator process shares the
    /// Mac's scheduler, so a busy machine steals frames from the run and there is no
    /// way to tell that from a slow scene after the fact. Recorded at both ends of
    /// every window so a reader can throw out a contaminated one instead of
    /// believing it.
    static func hostLoadAverage() -> Double {
        var l = [Double](repeating: 0, count: 3)
        guard getloadavg(&l, 3) > 0 else { return -1 }
        return l[0]
    }

    // MARK: - Process age

    /// Seconds since this process was forked. Used for launch accounting; note it
    /// includes dyld and, under XCTest, the test-bundle injection, so it is an
    /// upper bound on the app's own cold start rather than a clean one.
    static func processAgeSeconds() -> Double {
        var info = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        let ok = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0) == 0
        guard ok else { return 0 }
        let start = info.kp_proc.p_starttime
        let started = Double(start.tv_sec) + Double(start.tv_usec) / 1_000_000
        return Date().timeIntervalSince1970 - started
    }

    // MARK: - The clock the spike drives directly

    /// The test-only time input. A spike view reads *this* rather than the wall
    /// clock, so a room whose adaptations land at 173 s and 347 s can be placed
    /// past its second adaptation in a single frame instead of after six minutes
    /// of waiting.
    ///
    /// The shipped `MandalaCanvasLayer` predates this and reads
    /// `TimelineView(.animation)`'s own date, which is always real. Fast-forwarding
    /// the shipped canvas would mean editing it, which this spike is forbidden to
    /// do — so for the *baseline* the offset moves only the harness's own scripted
    /// state (bloom cadence, descent cadence), and the shipped canvas's internal
    /// breath, twinkle and flare stay on the real clock. Every baseline report says
    /// so in its `clockNote`.
    /// Times are carried in `timeIntervalSinceReferenceDate`, the same basis the
    /// shipped canvas reads out of its `TimelineView`, so a scene time and a canvas
    /// time can be compared without conversion.
    final class Clock: @unchecked Sendable {
        /// Seconds added to real elapsed time. Set to 347+ to sit past a second adaptation.
        var offset: TimeInterval
        /// Real reference-date time at which this clock's scene began.
        private(set) var epoch: TimeInterval

        /// - Parameter epoch: pinned only by the deterministic census baseline, which
        ///   needs the *absolute* times it feeds the census to be the same on every
        ///   run — the shipped canvas's flare phase is a function of absolute time,
        ///   so a wall-clock epoch would make the seat-flare count drift run to run.
        ///   Every measured window leaves it nil and starts at now.
        init(offset: TimeInterval = 0, epoch: TimeInterval? = nil) {
            self.offset = offset
            self.epoch = epoch ?? Date().timeIntervalSinceReferenceDate
        }

        func restart(offset: TimeInterval) {
            self.offset = offset
            self.epoch = Date().timeIntervalSinceReferenceDate
        }

        /// Scene time: how far into the room we are pretending to be.
        func sceneTime(now: TimeInterval = Date().timeIntervalSinceReferenceDate) -> TimeInterval {
            (now - epoch) + offset
        }

        /// The real reference-date instant that corresponds to a given scene time.
        func referenceTime(forScene s: TimeInterval) -> TimeInterval { epoch + s - offset }
    }

    // MARK: - Frame sampling

    /// A CADisplayLink frame counter. Records the interval between presented
    /// frames and the reference-date instant of each one, so a census can be
    /// evaluated *after* the window on exactly the frames that were drawn —
    /// keeping the counting work out of the measurement it is counting.
    final class FrameSampler: NSObject {
        private var link: CADisplayLink?
        private var lastTimestamp: CFTimeInterval = 0
        private(set) var intervalsMs: [Double] = []
        /// One entry per presented frame, in `timeIntervalSinceReferenceDate` —
        /// the same basis the shipped canvas's TimelineView reads.
        private(set) var frameRefTimes: [TimeInterval] = []
        private var cpuAtStart: Double = 0
        private var cpuAtStop: Double = 0
        private var footprintStart: Double = 0
        private var footprintPeak: Double = 0
        private var loadAtStart: Double = 0
        private var loadAtStop: Double = 0

        @MainActor
        func start() {
            intervalsMs.removeAll(keepingCapacity: true)
            frameRefTimes.removeAll(keepingCapacity: true)
            lastTimestamp = 0
            footprintStart = SpikeMetrics.footprintMB()
            footprintPeak = footprintStart
            loadAtStart = SpikeMetrics.hostLoadAverage()
            cpuAtStart = SpikeMetrics.taskCPUSeconds()
            let l = CADisplayLink(target: self, selector: #selector(tick(_:)))
            l.add(to: .main, forMode: .common)
            link = l
        }

        @MainActor
        func stop() {
            cpuAtStop = SpikeMetrics.taskCPUSeconds()
            loadAtStop = SpikeMetrics.hostLoadAverage()
            link?.invalidate()
            link = nil
        }

        @objc private func tick(_ l: CADisplayLink) {
            if lastTimestamp > 0 {
                intervalsMs.append((l.timestamp - lastTimestamp) * 1000)
            }
            lastTimestamp = l.timestamp
            frameRefTimes.append(Date().timeIntervalSinceReferenceDate)
            let f = SpikeMetrics.footprintMB()
            if f > footprintPeak { footprintPeak = f }
        }

        /// Wrap up the window into a report. `census` is the per-frame draw-primitive
        /// tally the caller replayed from `frameRefTimes` after `stop()`.
        @MainActor
        func finish(label: String,
                    device: String,
                    window: String,
                    clockNote: String,
                    census: CensusAccumulator) -> Report {
            let cpu = cpuAtStop - cpuAtStart
            let sorted = intervalsMs.sorted()
            let frames = intervalsMs.count
            let mean = frames > 0 ? intervalsMs.reduce(0, +) / Double(frames) : 0
            let worst = sorted.last ?? 0
            let p95 = sorted.isEmpty ? 0 : sorted[min(sorted.count - 1, Int(Double(sorted.count) * 0.95))]
            return Report(
                label: label,
                device: device,
                window: window,
                frames: frames,
                seconds: intervalsMs.reduce(0, +) / 1000,
                meanFrameMs: mean,
                p95FrameMs: p95,
                worstFrameMs: worst,
                cpuMsPerFrame: frames > 0 ? (cpu * 1000) / Double(frames) : 0,
                cpuSecondsInWindow: cpu,
                footprintStartMB: footprintStart,
                footprintPeakMB: footprintPeak,
                primitivesMean: census.mean,
                primitivesWorst: census.worst,
                primitivesBreakdown: census.worstBreakdown,
                hostLoadAtStart: loadAtStart,
                hostLoadAtEnd: loadAtStop,
                clockNote: clockNote)
        }
    }

    // MARK: - Reports

    /// Accumulates the per-frame primitive census over a window.
    struct CensusAccumulator {
        private(set) var total: Int = 0
        private(set) var count: Int = 0
        private(set) var worst: Int = 0
        private(set) var worstBreakdown: String = ""

        mutating func add(_ c: MandalaDrawCensus.Tally) {
            total += c.total
            count += 1
            if c.total > worst {
                worst = c.total
                worstBreakdown = c.breakdown
            }
        }

        var mean: Double { count > 0 ? Double(total) / Double(count) : 0 }
    }

    /// Written, never read back — `emit` is the only consumer, so this is
    /// `Encodable` rather than `Codable`. A synthesized decoder could not honour
    /// `measuredOn`, which is deliberately a constant no payload may override.
    struct Report: Encodable {
        let label: String
        let device: String
        /// "A · first adaptation" / "B · past second adaptation" / "control".
        let window: String
        let frames: Int
        let seconds: Double
        let meanFrameMs: Double
        let p95FrameMs: Double
        let worstFrameMs: Double
        let cpuMsPerFrame: Double
        let cpuSecondsInWindow: Double
        let footprintStartMB: Double
        let footprintPeakMB: Double
        let primitivesMean: Double
        let primitivesWorst: Int
        let primitivesBreakdown: String
        /// Host-Mac one-minute load average at each end of the window.
        let hostLoadAtStart: Double
        let hostLoadAtEnd: Double
        let clockNote: String
        /// Stamped into every payload so no figure can be quoted as a device number.
        let measuredOn: String = "iOS Simulator — relative comparison only; not a device figure"
    }

    /// Emit a report as a single greppable line. `xcodebuild`'s stdout carries it,
    /// so the run needs no result-bundle parsing and no added dependency.
    static func emit(_ r: Report) {
        let enc = JSONEncoder()
        enc.outputFormatting = [.sortedKeys]
        guard let data = try? enc.encode(r), let json = String(data: data, encoding: .utf8) else { return }
        print("SPIKE_METRIC \(json)")
    }
}
#endif
