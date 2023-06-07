// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Workflow",
    platforms: [
        .iOS("14.0"),
        .macOS("10.15"),
    ],
    products: [
        // MARK: Workflow

        .library(
            name: "Workflow",
            targets: ["Workflow"]
        ),
        .library(
            name: "WorkflowTesting",
            targets: ["WorkflowTesting"]
        ),

        // MARK: WorkflowUI

        .library(
            name: "WorkflowUI",
            targets: ["WorkflowUI"]
        ),
        .library(
            name: "WorkflowSwiftUI",
            targets: ["WorkflowSwiftUI"]
        ),

        // MARK: WorkflowCombine

        .library(
            name: "WorkflowCombine",
            targets: ["WorkflowCombine"]
        ),
        .library(
            name: "WorkflowCombineTesting",
            targets: ["WorkflowCombineTesting"]
        ),

        // MARK: ViewEnvironment

        .library(
            name: "ViewEnvironment",
            targets: ["ViewEnvironment"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.44.14"),
    ],
    targets: [
        // MARK: Workflow

        .target(
            name: "Workflow",
            dependencies: [],
            path: "Workflow/Sources"
        ),
        .testTarget(
            name: "WorkflowTests",
            dependencies: ["Workflow"],
            path: "Workflow/Tests"
        ),
        .target(
            name: "WorkflowTesting",
            dependencies: ["Workflow"],
            path: "WorkflowTesting/Sources"
        ),
        .testTarget(
            name: "WorkflowTestingTests",
            dependencies: ["WorkflowTesting"],
            path: "WorkflowTesting/Tests"
        ),

        // MARK: WorkflowUI

        .target(
            name: "WorkflowUI",
            dependencies: ["Workflow", "ViewEnvironment"],
            path: "WorkflowUI/Sources"
        ),
        .testTarget(
            name: "WorkflowUITests",
            dependencies: ["WorkflowUI"],
            path: "WorkflowUI/Tests"
        ),
        .target(
            name: "WorkflowSwiftUI",
            dependencies: ["Workflow"],
            path: "WorkflowSwiftUI/Sources"
        ),

        // MARK: WorkflowCombine

        .target(
            name: "WorkflowCombine",
            dependencies: ["Workflow"],
            path: "WorkflowCombine/Sources"
        ),
        .testTarget(
            name: "WorkflowCombineTests",
            dependencies: ["WorkflowCombineTesting"],
            path: "WorkflowCombine/Tests"
        ),
        .target(
            name: "WorkflowCombineTesting",
            dependencies: ["WorkflowCombine", "WorkflowTesting"],
            path: "WorkflowCombine/Testing"
        ),
        .testTarget(
            name: "WorkflowCombineTestingTests",
            dependencies: ["WorkflowCombineTesting"],
            path: "WorkflowCombine/TestingTests"
        ),

        // MARK: ViewEnvironment

        .target(
            name: "ViewEnvironment",
            path: "ViewEnvironment/Sources"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
