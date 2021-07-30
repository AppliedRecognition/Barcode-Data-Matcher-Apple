// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BarcodeDataMatcher",
    platforms: [
        .iOS(.v10), .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BarcodeDataMatcher",
            targets: ["BarcodeDataMatcher"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/AppliedRecognition/AAMVA-Barcode-Parser-Apple.git", from: "1.4.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BarcodeDataMatcher",
            dependencies: ["AAMVABarcodeParser"]),
        .testTarget(
            name: "BarcodeDataMatcherTests",
            dependencies: ["BarcodeDataMatcher"],
            resources: [
                .process("barcode_data/1.txt"),
                .process("barcode_data/2.txt"),
                .process("barcode_data/3.txt"),
                .process("barcode_data/4.txt")
            ]),
    ]
)
