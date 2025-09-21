// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TezosMobileSDK",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "TezosMobileSDK",
            targets: ["TezosMobileSDK"]
        ),
    ],
    targets: [
        .target(
            name: "TezosMobileSDK"
        ),
        .testTarget(
            name: "TezosMobileSDKTests",
            dependencies: ["TezosMobileSDK"]
        ),
    ]
)
