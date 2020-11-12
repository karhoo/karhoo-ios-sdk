// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KarhooSDK",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "KarhooSDK",
            targets: ["KarhooSDK"]),
    ],
    dependencies: [
        .package(name: "KeychainSwift", url: "https://github.com/evgenyneu/keychain-swift", from: "19.0.0"),
        .package(name: "Reachability", url: "https://github.com/ashleymills/Reachability.swift", from: "5.0.0"),
        .package(name: "OHHTTPStubs", url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.0.0"),
    ],
    targets: [
        .target(
            name: "KarhooSDK",
            dependencies: [.product(name: "Reachability", package: "Reachability"),
                           .product(name: "KeychainSwift", package: "KeychainSwift")],
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
