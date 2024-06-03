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
import ViewEnvironment

/// Screens are the building blocks of an interactive application.
///
/// Conforming types contain any information needed to populate a screen: data,
/// styling, event handlers, etc.
public protocol Screen {
	/// A menu description that acts as a recipe to either build
	/// or update a previously-built menu to match this screen.
	func menuDescription(environment: ViewEnvironment) -> MenuDescription
}

// MARK: -
public extension Screen {
	/// Update the given menu with the content from the screen.
	///
	/// ### Note
	/// You must pass a menu previously created by a compatible `menuDescription`
	/// that passes `canUpdate(menu:with:)`. Failure to do so will result in a fatal precondition.
	func update(menu: NSMenu, with environment: ViewEnvironment) {
		menuDescription(environment: environment).update(menu: menu)
	}

	/// Construct and update a new menu as described by this Screen.
	/// The menu will be updated before it is returned, so it is fully configured and prepared for display.
	func buildMenu(in environment: ViewEnvironment) -> NSMenu {
		menuDescription(environment: environment).buildMenu()
	}
}

#endif
