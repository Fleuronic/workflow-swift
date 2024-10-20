// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

import UIKit
import WorkflowUI
import ViewEnvironment

public extension BackStack {
	typealias Item = Screen<AnyScreen>.Item

	struct Screen<ScreenType: WorkflowUI.Screen> {
		let items: [Item]

		public init(items: [Item?]) {
			self.items = items.compactMap { $0 }
		}
	}
}

// MARK: -
extension BackStack.Screen: Screen {
	public func viewControllerDescription(environment: ViewEnvironment) -> ViewControllerDescription {
		BackStack.Container.description(for: self, environment: environment)
	}
}

#endif
