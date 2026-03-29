// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "GongfuTimer",
    platforms: [.macOS(.v26)],
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
