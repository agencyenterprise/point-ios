// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "0.1.17"
let moduleName = "PointSDK"
let checksum = "edd46419cbfd01622c8625aa6d0519bff88abd3c056cbb7e1faa02314e914838"

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
        .package(
            name: "SQLite",
            url: "https://github.com/stephencelis/SQLite.swift",
            .upToNextMajor(from: Version(0, 13, 3))
        ),
    ],
    targets: [
        .binaryTarget(
            name: moduleName,
            url: "https://github.com/agencyenterprise/point-ios/releases/download/\(version)/\(moduleName).xcframework.zip",
            checksum: checksum
        ),
        .target(
            name: "PointSDKWrapper",
            dependencies: [
                .byName(name: "Apollo", condition: .when(platforms: [.iOS])),
                .byName(name: "SQLite", condition: .when(platforms: [.iOS])),
                .target(name: "PointSDK", condition: .when(platforms: [.iOS])),
            ],
            path: "Point-iOS",
            exclude: [
                "../PointReferenceApp",
            ]
        ),
    ]
)
