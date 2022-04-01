// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PointSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PointSDK",
            targets: ["PointSDKWrapper"]
        ),
    ],
    dependencies: [
        .package(
            name: "Apollo",
            url: "https://github.com/apollographql/apollo-ios",
            .upToNextMajor(from: Version(0, 51, 2))
        ),
    ],
    targets: [
        .binaryTarget(
            name: "PointSDK",
            url: "https://github.com/agencyenterprise/point-ios/releases/download/0.1.0/PointSDK.xcframework.zip",
            checksum: "aad73949fb10790e164abecdb133e9693ec9c0eb7438898116f904c1626f9c6a"
        ),
        .target(
            name: "PointSDKWrapper",
            dependencies: [
                .byName(name: "Apollo", condition: .when(platforms: [.iOS])),
                .target(name: "PointSDK", condition: .when(platforms: [.iOS])),
            ],
            path: "Point-iOS"
        ),
    ]
)
