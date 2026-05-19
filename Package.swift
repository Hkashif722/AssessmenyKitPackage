// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AssessmentKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AssessmentKit",
            targets: ["AssessmentKit"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Hkashif722/SwiftUIUtility",
            branch: "update"
        ),
    ],
    targets: [
        .target(
            name: "AssessmentKit",
            dependencies: [
                .product(name: "SwiftUIUtilities", package: "SwiftUIUtility")
            ],
            path: "Sources/AssessmentKit",
            resources: [
//                .process("Resource/Media"),
                .process("Resource/Localization")
            ]
        ),
        .testTarget(
            name: "AssessmentKitTests",
            dependencies: ["AssessmentKit"],
            path: "Tests/AssessmentKitTests"
        )
    ]
)
