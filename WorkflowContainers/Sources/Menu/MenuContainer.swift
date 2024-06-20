// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(AppKit)

import AppKit
import WorkflowMenuUI
import ViewEnvironment

public extension Menu {
	final class Container<Content: WorkflowMenuUI.Screen>: ScreenMenu<Menu.Screen<Content>> {
		private let superDelegate: MenuDelegate
		private var menus: [AnyHashable: NSMenu] = [:]
		private var separatorItems: [AnyHashable: NSMenuItem] = [:]

		public required init(screen: Menu.Screen<Content>, environment: ViewEnvironment) {
			superDelegate = MenuDelegate()
			super.init(screen: screen, environment: environment)
			delegate = superDelegate
		}

		// MARK: ScreenMenu
		override public func screenDidChange(from previousScreen: Menu.Screen<Content>, previousEnvironment: ViewEnvironment) {
			super.screenDidChange(from: previousScreen, previousEnvironment: previousEnvironment)

			let keys = screen.sections.map(\.key)
			let previousKeys = previousScreen.sections.map(\.key)
			let removedKeys = previousKeys.filter { !keys.contains($0) }
			removedKeys.forEach { menus.removeValue(forKey: $0) }

			let items = screen.sections.flatMap { section in
				let previousMenu = menus[section.key]
				let menu = previousMenu ?? {
					let menu = section.screen.buildMenu(in: environment)
					superDelegate.subDelegates[section.key] = menu.delegate
					menus[section.key] = menu
					return menu
				}()

				if previousMenu != nil {
					section.screen.update(menu: menu, with: environment)
				}

				return menu.items + [separatorItems[section.key] ?? {
					let item = NSMenuItem.separator()
					separatorItems[section.key] = item
					return item
				}()]
			}

			if self.items != items {
				items.forEach { $0.menu = nil }
				self.items = items
			}
		}
	}
}

#endif

