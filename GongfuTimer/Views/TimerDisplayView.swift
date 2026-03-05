import SwiftUI

struct TimerDisplayView: View {
    let progress: Double
    let displayTime: String
    let isActive: Bool
    @Binding var currentDuration: Int
    @Binding var isEditing: Bool
    @Binding var editText: String
    var onStop: () -> Void = {}

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: 8)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.green,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            if isActive {
                Text(displayTime)
                    .font(.system(size: 40, weight: .medium, design: .monospaced))
                    .contentTransition(.numericText())
                    .onTapGesture {
                        onStop()
                        beginEditing()
                    }
            } else if isEditing {
                TextField("", text: $editText)
                    .font(.system(size: 40, weight: .medium, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .frame(width: 80)
                    .focused($isFocused)
                    .onSubmit { commitEdit() }
                    .onAppear { isFocused = true }
            } else {
                Text(displayTime)
                    .font(.system(size: 40, weight: .medium, design: .monospaced))
                    .onTapGesture { beginEditing() }
            }
        }
        .frame(width: 140, height: 140)
    }

    private func beginEditing() {
        editText = "\(currentDuration)"
        isEditing = true
        isFocused = true
    }

    private func commitEdit() {
        if let value = Int(editText), value > 0 {
            currentDuration = value
        }
        isEditing = false
    }
}
