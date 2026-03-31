// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AssessmentKit",
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
        // ⚠️ Replace with your actual SwiftUIUtilities remote URL + version/branch
        .package(
            path: "/Users/kashifhussain/Desktop/OJT_New_Design/SwiftUIUtility/SwiftUIUtility"
        )
    ],
    targets: [
        .target(
            name: "AssessmentKit",
            dependencies: [
                .product(name: "SwiftUIUtilities", package: "SwiftUIUtility")
            ],
            path: "Sources/AssessmentKit"
        ),
        .testTarget(
            name: "AssessmentKitTests",
            dependencies: ["AssessmentKit"],
            path: "Tests/AssessmentKitTests"
        )
    ]
)
