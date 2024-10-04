// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftUI-Utils",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "SwiftUI-Utils",
            targets: ["SwiftUI-Utils"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftUI-Utils",
            path: "Sources"
        ),
    ]
)
