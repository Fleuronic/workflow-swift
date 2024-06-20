// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(AppKit)

import AppKit
import WorkflowMenuUI
import ViewEnvironment

public extension Menu {
	typealias Section<Screen: WorkflowMenuUI.Screen> = Menu.Screen<Screen>.Section

	struct Screen<ScreenType: WorkflowMenuUI.Screen> {
		let sections: [Section]

		public init(sections: [Section?]) {
			self.sections = sections.compactMap { $0 }
		}
	}
}

// MARK: -
extension Menu.Screen: Screen {
	public func menuDescription(environment: ViewEnvironment) -> MenuDescription {
		Menu.Container.description(for: self, environment: environment)
	}
}

#endif
