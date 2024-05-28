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
			name: "WorkflowTesting",
			targets: ["WorkflowTesting"]
		),
		.library(
			name: "WorkflowReactiveSwift",
			targets: ["WorkflowReactiveSwift"]
		),
		.library(
			name: "WorkflowReactiveSwiftTesting",
			targets: ["WorkflowReactiveSwift"]
		),
		.library(
			name: "ViewEnvironment",
			targets: ["ViewEnvironment"]
		),
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
			dependencies: ["WorkflowUI", "WorkflowReactiveSwift"],
			path: "WorkflowUI/Tests"
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
		)
	]
)
