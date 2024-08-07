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

import Foundation

/// Represents the lifetime of an object.
///
/// Once ended, the `onEnded` closure is called.
public final class Lifetime: @unchecked Sendable {
	public private(set) var hasEnded: Bool = false
	
	private var onEndedActions: [() -> Void] = []

	deinit { end() }
}

public extension Lifetime {
	/// Hook to clean-up after end of `lifetime`.
	func onEnded(_ action: @escaping () -> Void) {
		assert(!hasEnded, "Lifetime used after being ended.")
		onEndedActions.append(action)
	}
}

extension Lifetime {
	func end() {
		guard !hasEnded else { return }
		
		hasEnded = true
		onEndedActions.forEach { $0() }
	}
}
