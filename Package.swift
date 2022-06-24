// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
