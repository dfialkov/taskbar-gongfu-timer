import SwiftUI

struct InfusionInfoView: View {
    @Binding var incrementPerSteep: Int

    private let options = [0, 5, 15, 30]

    var body: some View {
        VStack(spacing: 6) {
            Text("Per steep")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Picker("", selection: $incrementPerSteep) {
                ForEach(options, id: \.self) { value in
                    Text(value == 0 ? "Off" : "+\(value)s")
                        .tag(value)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
