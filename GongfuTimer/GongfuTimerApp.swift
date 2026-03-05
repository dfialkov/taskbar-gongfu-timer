import AppKit
import SwiftUI

@MainActor private let greenLeafImage: NSImage = {
    let config = NSImage.SymbolConfiguration(paletteColors: [.systemGreen])
    let image = NSImage(systemSymbolName: "leaf.fill", accessibilityDescription: nil)!
        .withSymbolConfiguration(config)!
    image.isTemplate = false
    return image
}()

@main
struct GongfuTimerApp: App {
    @State private var model = TimerModel()

    var body: some Scene {
        MenuBarExtra {
            TimerPopoverView(model: model)
        } label: {
            if model.menuBarLabel.isEmpty {
                if model.timerFinished {
                    Image(nsImage: greenLeafImage)
                } else {
                    Image(systemName: "leaf.fill")
                }
            } else {
                Text(model.menuBarLabel)
            }
        }
        .menuBarExtraStyle(.window)
    }
}
