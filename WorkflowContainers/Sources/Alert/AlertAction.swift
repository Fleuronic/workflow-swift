// Copyright © Fleuronic LLC. All rights reserved.

public extension Alert {
	struct Action {
		let title: String
		let style: Style
		let handler: () -> Void

		public init(
			title: String,
			style: Style = .default,
			handler: @escaping () -> Void = {}
		) {
			self.title = title
			self.style = style
			self.handler = handler
		}
	}
}
