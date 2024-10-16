// swift-tools-version:5.8
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
		.library(
			name: "Workflow",
			targets: ["Workflow"]
		),
		.library(
			name: "WorkflowUI",
			targets: ["WorkflowUI"]
		),
		.library(
			name: "WorkflowMenuUI",
			targets: ["WorkflowMenuUI"]
		),
		.library(
			name: "WorkflowContainers",
			targets: ["WorkflowContainers"]
		),
		.library(
			name: "WorkflowTesting",
			targets: ["WorkflowTesting"]
		),
		.library(
			name: "WorkflowConcurrency",
			targets: ["WorkflowConcurrency"]
		),
		.library(
			name: "WorkflowConcurrencyTesting",
			targets: ["WorkflowConcurrencyTesting"]
		),
		.library(
			name: "WorkflowReactiveSwift",
			targets: ["WorkflowReactiveSwift"]
		),
		.library(
			name: "WorkflowReactiveSwiftTesting",
			targets: ["WorkflowReactiveSwiftTesting"]
		),
		.library(
			name: "ViewEnvironment",
			targets: ["ViewEnvironment"]
		)
	],
	dependencies: [.package(url: "https://github.com/Fleuronic/ReactiveSwift.git", branch: "main")],
	targets: [
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
			name: "WorkflowUI",
			dependencies: ["Workflow", "ViewEnvironment"],
			path: "WorkflowUI/Sources"
		),
		.testTarget(
			name: "WorkflowUITests",
			dependencies: ["WorkflowUI", "WorkflowConcurrency"],
			path: "WorkflowUI/Tests"
		),
		.target(
			name: "WorkflowMenuUI",
			dependencies: ["Workflow", "ViewEnvironment"],
			path: "WorkflowMenuUI/Sources"
		),
		.testTarget(
			name: "WorkflowMenuUITests",
			dependencies: ["WorkflowMenuUI", "WorkflowConcurrency"],
			path: "WorkflowMenuUI/Tests"
		),
		.target(
			name: "WorkflowContainers",
			dependencies: ["WorkflowUI", "WorkflowMenuUI"],
			path: "WorkflowContainers/Sources"
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
		.target(
			name: "WorkflowConcurrency",
			dependencies: ["Workflow"],
			path: "WorkflowConcurrency/Sources"
		),
		.testTarget(
			name: "WorkflowConcurrencyTests",
			dependencies: ["WorkflowConcurrencyTesting"],
			path: "WorkflowConcurrency/Tests"
		),
		.target(
			name: "WorkflowConcurrencyTesting",
			dependencies: ["WorkflowConcurrency", "WorkflowTesting"],
			path: "WorkflowConcurrency/Testing"
		),
		.testTarget(
			name: "WorkflowConcurrencyTestingTests",
			dependencies: ["WorkflowConcurrencyTesting"],
			path: "WorkflowConcurrency/TestingTests"
		),
		.target(
			name: "WorkflowReactiveSwift",
			dependencies: ["ReactiveSwift", "Workflow"],
			path: "WorkflowReactiveSwift/Sources"
		),
		.testTarget(
			name: "WorkflowReactiveSwiftTests",
			dependencies: ["WorkflowReactiveSwiftTesting"],
			path: "WorkflowReactiveSwift/Tests"
		),
		.target(
			name: "WorkflowReactiveSwiftTesting",
			dependencies: ["WorkflowReactiveSwift", "WorkflowTesting"],
			path: "WorkflowReactiveSwift/Testing"
		),
		.testTarget(
			name: "WorkflowReactiveSwiftTestingTests",
			dependencies: ["WorkflowReactiveSwiftTesting"],
			path: "WorkflowReactiveSwift/TestingTests"
		),
		.target(
			name: "ViewEnvironment",
			path: "ViewEnvironment/Sources"
		),
	]
)
