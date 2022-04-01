// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PointSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PointSDK",
            targets: ["PointSDK"]
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
            name: "Point-iOS",
            url: "https://github.com/agencyenterprise/point-ios/releases/download/0.5.1/PointSDK.xcframework.zip",
            checksum: "0ad7f5c30307c0599b478897724f6be1163ad525fa375379332b92b01bc3f45e"
        ),
        .target(
            name: "PointSDK",
            dependencies: [
                .byName(name: "Apollo", condition: .when(platforms: [.iOS])),
                .target(name: "PointSDK", condition: .when(platforms: [.iOS])),
            ],
            path: "Point-iOS",
            publicHeadersPath: "PointSDK.xcframework/Headers/"
        ),
    ]
)
