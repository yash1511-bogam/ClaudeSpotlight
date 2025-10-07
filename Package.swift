// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClaudeSpotlight",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/jamesrochabrun/SwiftAnthropic.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "ClaudeSpotlight",
            dependencies: ["SwiftAnthropic"],
            path: "Sources",
            exclude: ["Info.plist"]
        )
    ]
)
