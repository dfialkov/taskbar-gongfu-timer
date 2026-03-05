import SwiftUI

struct TimerPopoverView: View {
    @Bindable var model: TimerModel
    @State private var isEditingDuration = false
    @State private var editText = ""

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                if model.steepCount > 0 {
                    Text("Steep #\(model.steepCount)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }

            // Timer display with nudge buttons
            HStack(spacing: 12) {
                nudgeButton(seconds: -5)

                TimerDisplayView(
                    progress: model.progress,
                    displayTime: model.isRunning || model.isPaused
                        ? model.displayTime
                        : "\(model.currentDuration)s",
                    isActive: model.isRunning || model.isPaused,
                    currentDuration: $model.currentDuration,
                    isEditing: $isEditingDuration,
                    editText: $editText,
                    onStop: model.stop
                )

                nudgeButton(seconds: 5)
            }

            // Controls
            ControlButtonsView(
                isRunning: model.isRunning,
                isPaused: model.isPaused,
                onStart: { commitEdit(); model.start() },
                onPause: { commitEdit(); model.pause() },
                onResume: { commitEdit(); model.resume() },
                onStop: { commitEdit(); model.stop() }
            )

            Divider()

            // Auto-increment picker
            InfusionInfoView(incrementPerSteep: $model.incrementPerSteep)
                .onChange(of: model.incrementPerSteep) { _, _ in
                    commitEdit()
                }
        }
        .contentShape(Rectangle())
        .onTapGesture { commitEdit() }
        .padding()
        .frame(width: 280)
        .onDisappear { isEditingDuration = false }
    }

    private func commitEdit() {
        guard isEditingDuration else { return }
        if let value = Int(editText), value > 0 {
            model.currentDuration = value
        }
        isEditingDuration = false
    }

    private func nudgeButton(seconds: Int) -> some View {
        Button {
            commitEdit()
            model.currentDuration = max(1, model.currentDuration + seconds)
            model.progress = 0
        } label: {
            Text(seconds > 0 ? "+\(seconds)" : "\(seconds)")
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.medium)
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
        .disabled(model.isRunning || model.isPaused)
    }
}
