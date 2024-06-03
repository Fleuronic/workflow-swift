#if canImport(AppKit)

import AppKit

/// A MenuDescription acts as a "recipe" for building and updating a specific `NSMenu`.
/// It describes how to _create_ and later _update_ a given menu instance, without creating one
/// itself. This means it is a lightweight currency you can create and pass around to describe a menu,
/// without needing to create one.
///
/// The most common use case for a `MenuDescription` is to return it from your `Screen`'s
/// `menuDescription(environment:)` method. The `WorkflowUI` machinery (or your
/// custom container menu) will then use this menu description to create or update the
/// on-screen presented menu.
///
/// As a creator of a custom container menu, you will usually pass this menu description to
/// a `DescribedMenu`, which will internally create and manage the described menu
/// for its current menu description. However, you can also directly invoke the public
/// methods such as `buildMenu()`, `update(menu:)`, if you are
/// manually managing your own menu hierarchy.
public struct MenuDescription {
	private let build: () -> NSMenu
	private let update: (NSMenu) -> Void

	/// If an initial call to `update(menu:)` will be performed
	/// when the menu is created. Defaults to `true`.
	///
	/// ### Note
	/// When creating container menus that contain other menus
	/// (eg, a navigation stack), you usually want to set this value to `false` to avoid
	/// duplicate updates to your children if they are created in `init`.
	public var performInitialUpdate: Bool
}

public extension MenuDescription {
	/// Constructs a menu description by providing closures used to
	/// build and update a specific menu type.
	///
	/// - Parameters:
	///   - performInitialUpdate: If an initial call to `update(menu:)`
	///     will be performed when the menu is created. Defaults to `true`.
	///
	///   - type: The type of menu produced by this description.
	///     Typically, should should be able to omit this parameter, but
	///     in cases where type inference has trouble, it’s offered as
	///     an escape hatch.
	///
	///   - build: Closure that produces a new instance of the menu
	///
	///   - update: Closure that updates the given menu
	init<Menu: NSMenu>(
		performInitialUpdate: Bool = true,
		type: Menu.Type = Menu.self,
		build: @escaping () -> Menu,
		update: @escaping (Menu) -> Void
	) {
		self.performInitialUpdate = performInitialUpdate
		self.build = build
		self.update = { untypedMenu in
			guard let menu = untypedMenu as? Menu else {
				fatalError("Unable to update \(untypedMenu), expecting a \(Menu.self)")
			}
			
			update(menu)
		}
	}

	/// Construct and update a new menu as described by this menu description.
	/// The menu will be updated before it is returned, so it is fully configured and prepared for display.
	func buildMenu() -> NSMenu {
		let menu = build()
		
		if performInitialUpdate {
			// Perform an initial update of the built menu
			update(menu: menu)
		}
		
		return menu
	}

	/// Update the given menu with the content from the menu description.
	///
	/// - Parameters:
	///   - menu: The menu to update.
	///
	/// ### Note
	/// You must pass a menu previously created by a compatible `MenuDescription`
	/// that passes `canUpdate(menu:)`. Failure to do so will result in a fatal precondition.
	func update(menu: NSMenu) {
		update(menu)
	}
}

#endif
