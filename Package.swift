// swift-tools-version: 5.8
import PackageDescription

let package = Package(
  name: "remindctl",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "RemindCore", targets: ["RemindCore"]),
    .executable(name: "remindctl", targets: ["remindctl"]),
  ],
  dependencies: [
    .package(path: "Vendor/Commander"),
  ],
  targets: [
    .target(
      name: "RemindCore",
      dependencies: [],
      linkerSettings: [
        .linkedFramework("EventKit"),
      ]
    ),
    .executableTarget(
      name: "remindctl",
      dependencies: [
        "RemindCore",
        .product(name: "Commander", package: "Commander"),
      ],
      exclude: [
        "Resources/Info.plist",
      ],
      linkerSettings: [
        .unsafeFlags([
          "-Xlinker", "-sectcreate",
          "-Xlinker", "__TEXT",
          "-Xlinker", "__info_plist",
          "-Xlinker", "Sources/remindctl/Resources/Info.plist",
        ]),
      ]
    ),
    .testTarget(
      name: "RemindCoreTests",
      dependencies: [
        "RemindCore",
      ]
    ),
    .testTarget(
      name: "remindctlTests",
      dependencies: [
        "remindctl",
        "RemindCore",
      ]
    ),
  ]
)
