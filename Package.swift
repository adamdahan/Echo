// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Remote Echo HTTP

//let package = Package(
//    name: "Echo",
//    platforms: [
//        .iOS(.v13),
//    ],
//    products: [
//        .library(name: "Echo", targets: ["Echo"])
//    ],
//    dependencies: [
//        .package(
//            url: "https://github.com/madeofmoney/EchoHTTP.git",
//            from: "1.0.0"
//        ),
//        .package(url: "https://github.com/RobertoMachorro/Highlightr.git", .branch("master"))
//    ],
//    targets: [
//        .target(
//            name: "Echo",
//            dependencies: ["EchoHTTP", "Highlightr"]
//        )
//    ]
//)

// Local Echo HTTP
// Make sure to drag EchoHTTP into root of SilverEskimo Project

let package = Package(
    name: "Echo",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "Echo", targets: ["Echo"])
    ],
    dependencies: [
        .package(
            path: "../EchoHTTP"
        ),
        .package(url: "https://github.com/RobertoMachorro/Highlightr.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "Echo",
            dependencies: ["EchoHTTP", "Highlightr"]
        )
    ]
)
