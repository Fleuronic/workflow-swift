#if canImport(AppKit)

import AppKit

/// A MenuDescription acts as a "recipe" for building and updating a specific `UIMenu`.
/// It describes how to _create_ and later _update_ a given view controller instance, without creating one
/// itself. This means it is a lightweight currency you can create and pass around to describe a view controller,
/// without needing to create one.
///
/// The most common use case for a `MenuDescription` is to return it from your `Screen`'s
/// `menuDescription(environment:)` method. The `WorkflowUI` machinery (or your
/// custom container view controller) will then use this view controller description to create or update the
/// on-screen presented view controller.
///
/// As a creator of a custom container view controller, you will usually pass this view controller description to
/// a `DescribedMenu`, which will internally create and manage the described view
/// controller for its current view controller description. However, you can also directly invoke the public
/// methods such as `buildMenu()`, `update(menu:)`, if you are
/// manually managing your own view controller hierarchy.
public struct MenuDescription {
	/// If an initial call to `update(menu:)` will be performed
	/// when the view controller is created. Defaults to `true`.
	///
	/// ### Note
	/// When creating container view controllers that contain other view controllers
	/// (eg, a navigation stack), you usually want to set this value to `false` to avoid
	/// duplicate updates to your children if they are created in `init`.
	public var performInitialUpdate: Bool

	private let build: () -> NSMenu
	private let update: (NSMenu) -> Void
}

#endif
