// Copyright © Fleuronic LLC. All rights reserved.

public extension Bar {
	struct Content {
		var title: String?
		var leftItem: ButtonItem?
		var rightItem: ButtonItem?

		public init(
			title: String? = nil,
			leftItem: ButtonItem? = nil,
			rightItem: ButtonItem? = nil
		) {
			self.title = title
			self.leftItem = leftItem
			self.rightItem = rightItem
		}
	}
}
