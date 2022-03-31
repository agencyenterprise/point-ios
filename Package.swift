// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PointSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PointSDK",
            type: .dynamic,
            targets: ["PointSDKBinary"]
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
            name: "PointSDKBinary",
            url: "https://github.com/agencyenterprise/point-sdk-ios-sample/blob/main/PointSDK.xcframework.zip",
            checksum: "a051917cb854cd15b9f96ea011831e959bb1bd7e8aaaa3851efc57f0ca56651a"
        ),
    ]
)
