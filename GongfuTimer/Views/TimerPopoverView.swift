import SwiftUI

struct TimerPopoverView: View {
    @Bindable var model: TimerModel
    @State private var isEditingDuration = false
    @State private var editText = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                if model.steepCount > 0 {
                    Text("Steep #\(model.steepCount)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Button {
                        model.resetSteepCount()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
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
            HStack(spacing: 20) {
                nudgeButton(seconds: -TimerModel.nudgeStep)

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

                nudgeButton(seconds: TimerModel.nudgeStep)
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
        .focusable()
        .focusEffectDisabled()
        .focused($isFocused)
        .onAppear { isFocused = true }
        .onDisappear { isEditingDuration = false }
        .onKeyPress(keys: [.return]) { press in
            guard !isEditingDuration else { return .ignored }
            if press.modifiers.contains(.shift) {
                if model.isRunning || model.isPaused {
                    model.stop()
                }
            } else if model.isRunning && !model.isPaused {
                model.pause()
            } else if model.isPaused {
                model.resume()
            } else {
                model.start()
            }
            return .handled
        }
        .onKeyPress(keys: [.leftArrow, .rightArrow]) { press in
            let forward = press.key == .rightArrow
            if press.modifiers.contains(.shift) {
                model.cycleIncrement(forward: forward)
                return .handled
            }
            guard !isEditingDuration else { return .ignored }
            model.nudge(seconds: forward ? TimerModel.nudgeStep : -TimerModel.nudgeStep)
            return .handled
        }
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
            model.nudge(seconds: seconds)
        } label: {
            Text(seconds > 0 ? "+\(seconds)" : "\(seconds)")
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
    }
}
