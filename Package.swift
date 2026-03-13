// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "P42WatchosWidgets",
    platforms: [
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "P42WatchosWidgets",
            targets: ["P42WatchosWidgets"]),
    ],
    dependencies: [
        .package(url: "git@github.com:platform-42/P42Extensions.git", branch: "main")
    ],
    targets: [
        .target(
            name: "P42WatchosWidgets",
            dependencies: [
                "P42Extensions"
            ]
        )
    ]
)
