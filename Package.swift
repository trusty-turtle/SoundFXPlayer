// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SoundFXPlayer",
    // Has only been guaranteed/tested on iOS 17+
    // But should work on all these:
    platforms: [
            .iOS(.v12),     // Correct syntax for iOS
            .macOS(.v10_13), // Correct syntax for macOS
            .tvOS(.v12),    // Correct syntax for tvOS
            .watchOS(.v4)   // Correct syntax for watchOS
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SoundFXPlayer",
            targets: ["SoundFXPlayer"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SoundFXPlayer"),
        .testTarget(
            name: "SoundFXPlayerTests",
            dependencies: ["SoundFXPlayer"]),
    ]
)

