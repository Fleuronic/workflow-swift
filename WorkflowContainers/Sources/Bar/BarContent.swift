// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

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

#endif
