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

/// Generic base class that can be subclassed in order to to define a UI implementation that is powered by the
/// given screen type.
///
/// Using this base class, a screen can be implemented as:
/// ```
/// struct MyScreen: Screen {
///     func menuDescription(environment: ViewEnvironment) -> MenuDescription {
///         return MyScreenMenu.description(for: self)
///     }
/// }
///
/// private class MyScreenMenu: ScreenMenu<MyScreen> {
///     override func screenDidChange(from previousScreen: MyScreen, previousEnvironment: ViewEnvironment) {
///         // … update views as necessary
///     }
/// }
/// ```
open class ScreenMenu<ScreenType: Screen>: NSMenu {
	public private(set) final var screen: ScreenType
	public private(set) final var environment: ViewEnvironment
		
	public required init(
		screen: ScreenType, 
		environment: ViewEnvironment
	) {
		self.screen = screen
		self.environment = environment
			
		super.init(title: .init())
	}
		
	/// Subclasses should override this method in order to update any relevant UI bits when the screen model changes.
	open func screenDidChange(from previousScreen: ScreenType, previousEnvironment: ViewEnvironment) {}
	
	// MARK: NSCoding
	@available(*, unavailable)
	public required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
// 
// // MARK: -
public extension ScreenMenu {
	final var screenType: Screen.Type { ScreenType.self }
	
	final func update(
		screen: ScreenType, 
		environment: ViewEnvironment
	) {
		let previousScreen = self.screen
		self.screen = screen
		let previousEnvironment = self.environment
		self.environment = environment
	
		screenDidChange(from: previousScreen, previousEnvironment: previousEnvironment)
	}
	
	/// Convenience to create a menu description for the given screen
	/// value. See the example on the comment for ScreenMenu for
	/// usage.
	final class func description(for screen: ScreenType, environment: ViewEnvironment, performInitialUpdate: Bool = true) -> MenuDescription {
		.init(
			performInitialUpdate: performInitialUpdate,
			build: { 
				self.init(
					screen: screen,
					environment: environment
				) 
			},
			update: { 
				$0.update(
					screen: screen, 
					environment: environment
				)
			}
		)
	}
}

#endif
