///*
// * Copyright 2020 Square Inc.
// * Copyright 2024 Fleuronic LLC
// *
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *     http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//#if canImport(AppKit)
//
//import AppKit
//import ViewEnvironment
//
//public final class DescribedMenu: NSMenu {}
//
//// MARK: -
//public extension DescribedMenu {
//	convenience init<S: Screen>(
//		screen: S,
//		environment: ViewEnvironment
//	) {
//		self = screen.menuDescription(environment: environment).buildMenu()
//	}
//
//	func update(description: MenuDescription) {
//		description.update(menu: self)
//	}
//
//	func update<S: Screen>(
//		screen: S,
//		environment: ViewEnvironment
//	) {
//		update(description: screen.MenuDescription(environment: environment))
//	}
//}
//
//private extension DescribedMenu {
//	private func updatePreferredContentSizeIfNeeded() {
//		guard
//			case let newPreferredContentSize = currentMenu.preferredContentSize,
//			newPreferredContentSize != preferredContentSize else { return }
//
//		preferredContentSize = newPreferredContentSize
//	}
//}
//
//#endif
