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

#if canImport(AppKit)

import AppKit
import Workflow
import ReactiveSwift
import ViewEnvironment

/// Drives menus from a root Workflow.
public final class WorkflowHostingController<ScreenType: Screen, Output> {
	public let menu: NSMenu
	
	public var rootViewEnvironment: ViewEnvironment {
		didSet {
			update(screen: workflowHost.rendering.value, environment: rootViewEnvironment)
		}
	}

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
		

		let rendering = workflowHost.rendering
		self.rootViewEnvironment = rootViewEnvironment
		menu = rendering.value.buildMenu(in: rootViewEnvironment)
		
		rendering.signal.take(during: lifetime).observeValues { [weak self] screen in
			guard let self = self else { return }
				
			self.update(screen: screen, environment: self.rootViewEnvironment)
		}
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
		let description = screen.menuDescription(environment: environment)
		description.update(menu: menu)
	}
}

#endif
