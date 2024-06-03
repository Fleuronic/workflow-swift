/*
 * Copyright 2020 Square Inc.
 * Copyright 2024 Fleuronic LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#if canImport(UIKit)

import UIKit
import Workflow
import ReactiveSwift
import ViewEnvironment

/// Drives view controllers from a root Workflow.
public final class WorkflowHostingController<ScreenType: Screen, Output>: UIViewController {
	public var rootViewEnvironment: ViewEnvironment {
		didSet {
			update(screen: workflowHost.rendering.value, environment: rootViewEnvironment)
		}
	}

	private(set) var rootViewController: UIViewController

	private let workflowHost: WorkflowHost<AnyWorkflow<ScreenType, Output>>
	private let (lifetime, token) = Lifetime.make()
	
	public init<W: AnyWorkflowConvertible>(
		workflow: W,
		rootViewEnvironment: ViewEnvironment = .empty,
		observers: [WorkflowObserver] = []
	) where W.Rendering == ScreenType, W.Output == Output {
		workflowHost = .init(
			workflow: workflow.asAnyWorkflow(),
			observers: observers
		)
		
		rootViewController = workflowHost
			.rendering
			.value
			.buildViewController(in: rootViewEnvironment)
			
		self.rootViewEnvironment = rootViewEnvironment

		super.init(nibName: nil, bundle: nil)
		
		addChild(rootViewController)
		rootViewController.didMove(toParent: self)
		
		workflowHost
			.rendering
			.signal
			.take(during: lifetime)
			.observeValues { [weak self] screen in
				guard let self = self else { return }
				
				self.update(screen: screen, environment: self.rootViewEnvironment)
			}
	}

	// MARK: UIViewController
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		rootViewController.view.frame = view.bounds
		view.addSubview(rootViewController.view)
		
		updatePreferredContentSizeIfNeeded()
	}
	
	override public func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		rootViewController.view.frame = view.bounds
	}
	
	override public var childForStatusBarStyle: UIViewController? {
		rootViewController
	}
	
	override public var childForStatusBarHidden: UIViewController? {
		rootViewController
	}
	
	override public var childForHomeIndicatorAutoHidden: UIViewController? {
		rootViewController
	}
	
	override public var childForScreenEdgesDeferringSystemGestures: UIViewController? {
		rootViewController
	}
	
	override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		rootViewController.supportedInterfaceOrientations
	}
	
	override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		rootViewController.preferredStatusBarUpdateAnimation
	}
	
	override public var childViewControllerForPointerLock: UIViewController? {
		rootViewController
	}
	
	override public func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
		super.preferredContentSizeDidChange(forChildContentContainer: container)
		
		guard container === rootViewController else { return }
		updatePreferredContentSizeIfNeeded()
	}
	
	// MARK: NSCoding
	@available(*, unavailable)
	public required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: -
public extension WorkflowHostingController {
	/// Emits output events from the bound workflow.
	var output: Signal<Output, Never> { workflowHost.output }

	/// Updates the root Workflow in this container.
	func update<W: AnyWorkflowConvertible>(workflow: W) where W.Rendering == ScreenType, W.Output == Output {
		workflowHost.update(workflow: workflow.asAnyWorkflow())
	}
}

// MARK: -
private extension WorkflowHostingController {
	func update(
		screen: ScreenType,
		environment: ViewEnvironment
	) {
		update(child: \.rootViewController, with: screen, in: environment)
		updatePreferredContentSizeIfNeeded()
	}
	
	func updatePreferredContentSizeIfNeeded() {
		guard
			case let newPreferredContentSize = rootViewController.preferredContentSize,
			newPreferredContentSize != preferredContentSize else { return }
		
		preferredContentSize = newPreferredContentSize
	}
}

#endif
