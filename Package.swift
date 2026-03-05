// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "GongfuTimer",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "GongfuTimer",
            path: "GongfuTimer",
            exclude: ["Info.plist"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)
