// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "P42WatchosWidgets",
    platforms: [
        .watchOS(.v11),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "P42WatchosWidgets",
            targets: ["P42WatchosWidgets"]
        ),
    ],
    dependencies: [
        .package(url: "git@github.com:platform-42/P42Extensions.git", from: "6.0.0"),
        .package(url: "git@github.com:platform-42/P42utils.git", from: "9.0.0")
   ],
    targets: [
        .target(
            name: "P42WatchosWidgets",
            dependencies: [
                "P42Extensions",
                "P42utils"
            ]
        )
    ]
)
