#!/usr/bin/env swift
import AppKit

let sizes: [(name: String, size: Int)] = [
    ("icon_16x16", 16),
    ("icon_16x16@2x", 32),
    ("icon_32x32", 32),
    ("icon_32x32@2x", 64),
    ("icon_128x128", 128),
    ("icon_128x128@2x", 256),
    ("icon_256x256", 256),
    ("icon_256x256@2x", 512),
    ("icon_512x512", 512),
    ("icon_512x512@2x", 1024),
]

let iconsetPath = "/tmp/GongfuTimer.iconset"
let fm = FileManager.default
try? fm.removeItem(atPath: iconsetPath)
try! fm.createDirectory(atPath: iconsetPath, withIntermediateDirectories: true)

for entry in sizes {
    let s = CGFloat(entry.size)

    let image = NSImage(size: NSSize(width: s, height: s), flipped: false) { rect in
        // Background: warm dark circle
        let bg = NSColor(red: 0.18, green: 0.15, blue: 0.12, alpha: 1.0)
        bg.setFill()
        NSBezierPath(ovalIn: rect.insetBy(dx: s * 0.02, dy: s * 0.02)).fill()

        // Subtle border ring
        let ring = NSColor(red: 0.35, green: 0.55, blue: 0.30, alpha: 0.4)
        ring.setStroke()
        let ringPath = NSBezierPath(ovalIn: rect.insetBy(dx: s * 0.06, dy: s * 0.06))
        ringPath.lineWidth = s * 0.02
        ringPath.stroke()

        // Draw SF Symbol leaf
        let config = NSImage.SymbolConfiguration(pointSize: s * 0.48, weight: .medium)
        if let symbol = NSImage(systemSymbolName: "leaf.fill", accessibilityDescription: nil)?
            .withSymbolConfiguration(config) {

            let symbolSize = symbol.size
            let x = (s - symbolSize.width) / 2
            let y = (s - symbolSize.height) / 2
            let drawRect = NSRect(x: x, y: y, width: symbolSize.width, height: symbolSize.height)

            // Green tint
            let tinted = NSImage(size: symbolSize, flipped: false) { tintRect in
                symbol.draw(in: tintRect)
                NSColor(red: 0.40, green: 0.72, blue: 0.35, alpha: 1.0).setFill()
                tintRect.fill(using: .sourceAtop)
                return true
            }
            tinted.draw(in: drawRect)
        }
        return true
    }

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: entry.size, pixelsHigh: entry.size,
        bitsPerSample: 8, samplesPerPixel: 4,
        hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0, bitsPerPixel: 0
    )!
    rep.size = NSSize(width: entry.size, height: entry.size)

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    image.draw(in: NSRect(x: 0, y: 0, width: entry.size, height: entry.size))
    NSGraphicsContext.restoreGraphicsState()

    let png = rep.representation(using: .png, properties: [:])!
    let path = "\(iconsetPath)/\(entry.name).png"
    try! png.write(to: URL(fileURLWithPath: path))
}

print("Iconset created at \(iconsetPath)")
