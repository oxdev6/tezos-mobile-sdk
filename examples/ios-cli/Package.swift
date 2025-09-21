// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "TezosMobileExample",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(path: "../../ios-sdk")
    ],
    targets: [
        .executableTarget(
            name: "TezosMobileExample",
            dependencies: [
                .product(name: "TezosMobileSDK", package: "ios-sdk")
            ]
        )
    ]
)


