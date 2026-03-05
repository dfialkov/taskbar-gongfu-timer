import SwiftUI

struct ControlButtonsView: View {
    let isRunning: Bool
    let isPaused: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void
    let onStop: () -> Void

    var body: some View {
        if !isRunning && !isPaused {
            Button(action: onStart) {
                Label("Start", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .controlSize(.large)
        } else {
            HStack(spacing: 0) {
                Button(action: isPaused ? onResume : onPause) {
                    Label(isPaused ? "Resume" : "Pause",
                          systemImage: isPaused ? "play.fill" : "pause.fill")
                        .frame(maxWidth: .infinity)
                }
                .tint(isPaused ? .green : .orange)

                Divider()
                    .frame(height: 16)

                Button(action: onStop) {
                    Image(systemName: "stop.fill")
                }
                .tint(.red)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
}
