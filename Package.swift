// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ClaudeSpotlight",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/jamesrochabrun/SwiftAnthropic.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "ClaudeSpotlight",
            dependencies: ["SwiftAnthropic"],
            path: "Sources",
            exclude: ["Info.plist", "ClaudeSpotlight.entitlements"]
        )
    ]
)
