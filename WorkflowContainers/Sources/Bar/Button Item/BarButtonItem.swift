// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

public extension Bar {
	struct ButtonItem {
		var content: Content
		var isEnabled: Bool
		var handler: () -> Void

		public init(
			content: Content,
			isEnabled: Bool = true,
			handler: @escaping () -> Void = {}
		) {
			self.content = content
			self.isEnabled = isEnabled
			self.handler = handler
		}
	}
}

#endif
