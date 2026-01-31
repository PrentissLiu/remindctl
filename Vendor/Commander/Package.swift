// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "Commander",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "Commander", targets: ["Commander"]),
    ],
    targets: [
        .target(
            name: "Commander",
            path: "Sources/Commander"),
        .testTarget(
            name: "CommanderTests",
            dependencies: ["Commander"],
            path: "Tests/CommanderTests"),
    ])
