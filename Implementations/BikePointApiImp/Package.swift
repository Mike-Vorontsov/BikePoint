// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BikePointApiImp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BikePointApiImp",
            targets: ["BikePointApiImp"]),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(path: "../TestUtils"),
        .package(path: "../NetworkInterface"),
        .package(path: "../BikePointApiInterface"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BikePointApiImp",
            dependencies: [
                "Common",
                "NetworkInterface",
                "BikePointApiInterface"
            ]
        ),
        .testTarget(
            name: "BikePointApiImpTests",
            dependencies: [
                "TestUtils",
                "BikePointApiImp"
            ]
        ),
    ]
)
