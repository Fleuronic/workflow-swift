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

import ViewEnvironment

public struct AnyScreen: Screen {
	/// The original screen, retained for debugging
	public let wrappedScreen: Screen
}

// MARK: -
public extension AnyScreen {
	init<T: Screen>(_ screen: T) {
		if let anyScreen = screen as? AnyScreen {
			self = anyScreen
			return
		}
		wrappedScreen = screen
	}

	func menuDescription(environment: ViewEnvironment) -> MenuDescription {
		wrappedScreen.menuDescription(environment: environment)
	}
}

// MARK: -
public extension Screen {
	/// Wraps the screen in an AnyScreen
	func asAnyScreen() -> AnyScreen { .init(self) }
}

#endif
