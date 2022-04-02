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
            checksum: "830a17acd070710a988fd83cc01ef053993dbf7905302649741e1b6c37eb604c"
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
