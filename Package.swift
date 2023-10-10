// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KarhooSDK",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "KarhooSDK",
            targets: ["KarhooSDK"]),
    ],
    dependencies: [
        .package(name: "OHHTTPStubs", url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.0.0"),
    ],
    targets: [
        .target(
            name: "KarhooSDK",
            path: "KarhooSDK"),
        .target(name: "Client",
                dependencies: ["KarhooSDK"],
                path: "Client"),
        .testTarget(
            name: "KarhooSDKTests",
            dependencies: ["KarhooSDK"],
            path: "KarhooSDKTests"),
        .testTarget(name: "KarhooSDKIntegrationTests",
                    dependencies: ["KarhooSDK", "OHHTTPStubs"],
                    path: "KarhooSDKIntegrationTests")
    ]
)
