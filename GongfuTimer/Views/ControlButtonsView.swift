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
            HStack(spacing: 8) {
                Button(action: isPaused ? onResume : onPause) {
                    Label(isPaused ? "Resume" : "Pause",
                          systemImage: isPaused ? "play.fill" : "pause.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(isPaused ? .green : Color(nsColor: .systemOrange).opacity(0.85))

                Button(action: onStop) {
                    Image(systemName: "stop.fill")
                        .frame(maxHeight: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .controlSize(.large)
        }
    }
}
