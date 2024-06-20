// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit)

import UIKit

extension Bar.ButtonItem {
	final class Backing: UIBarButtonItem {
		var handler: () -> Void = {}

		init(_ item: Bar.ButtonItem) {
			super.init()

			target = self
			action = #selector(onTapped)

			back(item)
		}

		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError()
		}
	}
}

extension Bar.ButtonItem.Backing {
	func back(_ item: Bar.ButtonItem) {
		handler = item.handler
		isEnabled = item.isEnabled

		switch item.content {
		case let .text(title):
			self.title = title
			customView = nil
		case let .icon(image):
			self.image = image
			customView = nil
		case .spinner:
			let activityIndicatorView = UIActivityIndicatorView(style: .medium)
			customView = activityIndicatorView
			activityIndicatorView.startAnimating()
		case .back:
			image = .init(systemName: "chevron.left")!
		}
	}
}

@objc private extension Bar.ButtonItem.Backing {
	func onTapped() {
		handler()
	}
}

#endif
