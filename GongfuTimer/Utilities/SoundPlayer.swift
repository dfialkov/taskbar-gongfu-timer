import AppKit

enum SoundPlayer {
    static func playCompletionSound() {
        NSSound(named: "Glass")?.play()
    }
}
