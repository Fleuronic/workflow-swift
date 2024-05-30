// Copyright © Fleuronic LLC. All rights reserved.

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
