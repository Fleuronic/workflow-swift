// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Workflow",
    platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.watchOS(.v6)
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

        // MARK: WorkflowReactiveSwift

        .library(
            name: "WorkflowReactiveSwift",
            targets: ["WorkflowReactiveSwift"]
        ),

		// MARK: WorkflowConcurrency

		.library(
			name: "WorkflowConcurrency",
			targets: ["WorkflowConcurrency"]
		),

        // MARK: ViewEnvironment

        .library(
            name: "ViewEnvironment",
            targets: ["ViewEnvironment"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", from: "7.1.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.44.14"),
    ],
    targets: [
        // MARK: Workflow

        .target(
            name: "Workflow",
            dependencies: ["ReactiveSwift"],
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
            dependencies: ["WorkflowUI", "WorkflowReactiveSwift"],
            path: "WorkflowUI/Tests"
        ),

        // MARK: WorkflowReactiveSwift

        .target(
            name: "WorkflowReactiveSwift",
            dependencies: ["ReactiveSwift", "Workflow"],
            path: "WorkflowReactiveSwift/Sources"
        ),

		// MARK: WorkflowConcurrency

		.target(
			name: "WorkflowConcurrency",
			dependencies: ["Workflow"],
			path: "WorkflowConcurrency/Sources"
		),

        // MARK: ViewEnvironment

        .target(
            name: "ViewEnvironment",
            path: "ViewEnvironment/Sources"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
