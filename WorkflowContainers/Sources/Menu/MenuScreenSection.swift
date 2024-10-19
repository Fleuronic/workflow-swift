// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(AppKit)

import WorkflowMenuUI

public extension Menu.Screen {
	struct Section {
		let key: AnyHashable
		let screen: ScreenType
	}
}

// MARK: -
public extension Menu.Screen.Section {
	init<Key: Hashable>(
		key: Key? = AnyHashable?.none,
		screen: ScreenType
	) {
		self.screen = screen

		if let key {
			self.key = .init(key)
		} else {
			self.key = .init(ObjectIdentifier(ScreenType.self))
		}
	}
}

#endif
