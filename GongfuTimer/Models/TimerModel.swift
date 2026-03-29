import Foundation
import SwiftUI

@MainActor
@Observable
final class TimerModel {
    var isRunning = false
    var isPaused = false
    var progress: Double = 0
    var secondsRemaining = 0
    var steepCount = 0
    var timerFinished = false
    var currentDuration: Int {
        didSet { UserDefaults.standard.set(currentDuration, forKey: "baseDuration") }
    }
    var incrementPerSteep: Int {
        didSet { UserDefaults.standard.set(incrementPerSteep, forKey: "incrementPerSteep") }
    }

    private var displayLink: DispatchSourceTimer?
    private var totalSeconds = 0
    private var startDate: Date?
    private var elapsedBeforePause: TimeInterval = 0

    init() {
        let saved = UserDefaults.standard.integer(forKey: "baseDuration")
        self.currentDuration = saved > 0 ? saved : 15
        self.incrementPerSteep = UserDefaults.standard.integer(forKey: "incrementPerSteep")
    }

    var displayTime: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        }
        return "\(seconds)s"
    }

    var menuBarLabel: String {
        if isRunning && !isPaused {
            return displayTime
        }
        if isPaused {
            return "⏸ \(displayTime)"
        }
        return ""
    }

    func start() {
        let d = max(currentDuration, 1)
        totalSeconds = d
        secondsRemaining = d
        elapsedBeforePause = 0
        startDate = Date()
        isRunning = true
        isPaused = false
        timerFinished = false
        startDisplayLink()
    }

    func pause() {
        if let start = startDate {
            elapsedBeforePause += Date().timeIntervalSince(start)
        }
        startDate = nil
        isPaused = true
        cancelDisplayLink()
    }

    func resume() {
        startDate = Date()
        isPaused = false
        startDisplayLink()
    }

    func nudge(seconds: Int) {
        if isRunning || isPaused {
            totalSeconds = max(1, totalSeconds + seconds)
            // Recompute elapsed so secondsRemaining adjusts on next tick
            if isPaused {
                secondsRemaining = max(0, secondsRemaining + seconds)
            }
        }
        currentDuration = max(1, currentDuration + seconds)
    }

    static let nudgeStep = 5
    static let incrementOptions = [0, 5, 15, 30]

    func cycleIncrement(forward: Bool) {
        guard let idx = Self.incrementOptions.firstIndex(of: incrementPerSteep) else { return }
        let next = forward ? idx + 1 : idx - 1
        guard Self.incrementOptions.indices.contains(next) else { return }
        incrementPerSteep = Self.incrementOptions[next]
    }

    func resetSteepCount() {
        steepCount = 0
    }

    func stop() {
        cancelDisplayLink()
        isRunning = false
        isPaused = false
        timerFinished = false
        progress = 0
        secondsRemaining = 0
        totalSeconds = 0
        startDate = nil
        elapsedBeforePause = 0
    }

    private func startDisplayLink() {
        let source = DispatchSource.makeTimerSource(queue: .main)
        source.schedule(deadline: .now(), repeating: .milliseconds(16))
        source.setEventHandler { [weak self] in
            self?.tick()
        }
        displayLink = source
        source.resume()
    }

    private func cancelDisplayLink() {
        displayLink?.cancel()
        displayLink = nil
    }

    private func tick() {
        guard let start = startDate else { return }
        let elapsed = elapsedBeforePause + Date().timeIntervalSince(start)
        let total = TimeInterval(totalSeconds)

        progress = min(elapsed / total, 1.0)
        let newRemaining = max(totalSeconds - Int(elapsed), 0)
        if newRemaining != secondsRemaining { secondsRemaining = newRemaining }

        if elapsed >= total {
            timerCompleted()
        }
    }

    private func timerCompleted() {
        cancelDisplayLink()
        isRunning = false
        isPaused = false
        timerFinished = true
        progress = 1
        secondsRemaining = 0
        startDate = nil
        elapsedBeforePause = 0
        steepCount += 1
        currentDuration += incrementPerSteep
        SoundPlayer.playCompletionSound()
    }
}
