// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "TransitionButton",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "TransitionButton",
            targets: ["TransitionButton"]),
    ],
    targets: [
        .target(
            name: "TransitionButton",
            dependencies: []),
    ]
)
