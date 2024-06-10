// swift-tools-version:5.10
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
			name: "ViewEnvironment",
			targets: ["ViewEnvironment"]
		)
	],
	dependencies: [.package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", from: "7.1.1")],
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
			dependencies: ["WorkflowUI"],
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
			dependencies: ["ReactiveSwift", "Workflow"],
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
			name: "ViewEnvironment",
			path: "ViewEnvironment/Sources"
		),
	]
)
