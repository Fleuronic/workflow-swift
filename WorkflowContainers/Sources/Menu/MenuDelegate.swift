// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(AppKit)

import AppKit

final class MenuDelegate: NSObject, NSMenuDelegate {
	var subDelegates: [AnyHashable: NSMenuDelegate] = [:]

	func menuWillOpen(_ menu: NSMenu) {
		subDelegates.values.forEach { delegate in
			delegate.menuWillOpen?(menu)
		}
	}

	func menuDidClose(_ menu: NSMenu) {
		subDelegates.values.forEach { delegate in
			delegate.menuDidClose?(menu)
		}
	}
}

#endif
