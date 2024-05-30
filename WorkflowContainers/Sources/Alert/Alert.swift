// Copyright © Fleuronic LLC. All rights reserved.

public struct Alert {
	let title: String
	let message: String
	let actions: [Action]

	public init(
		title: String,
		message: String,
		actions: [Action]
	) {
		self.title = title
		self.message = message
		self.actions = actions
	}
}
