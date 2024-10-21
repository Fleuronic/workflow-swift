// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

import UIKit
import WorkflowUI
import ViewEnvironment

final class BackStackViewController<ScreenType: Screen>: UIViewController {
	let key: AnyHashable
	let environment: ViewEnvironment
	let contentViewController: DescribedViewController

	init(item: BackStack.Screen<ScreenType>.Item, environment: ViewEnvironment) {
		key = item.key
		contentViewController = .init(screen: item.screen, environment: environment)
		self.environment = environment

		super.init(nibName: nil, bundle: nil)

		update(barVisibility: item.barVisibility)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: UIViewController
	override func viewDidLoad() {
		super.viewDidLoad()

		addChild(contentViewController)
		view.addSubview(contentViewController.view)
		contentViewController.didMove(toParent: self)
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		contentViewController.view.frame = view.bounds
	}
}

extension BackStackViewController {
	func matches(_ item: BackStack.Screen<ScreenType>.Item) -> Bool {
		item.key == key && type(of: item.screen) == ScreenType.self
	}

	func update(item: BackStack.Screen<ScreenType>.Item, environment: ViewEnvironment) {
		contentViewController.update(screen: item.screen, environment: environment)
		update(barVisibility: item.barVisibility)
	}
}

private extension BackStackViewController {
	private func update(barVisibility: Bar.Visibility) {
		navigationItem.hidesBackButton = true

		guard case let .visible(barContent) = barVisibility else { return }

		switch barContent.leftItem {
		case .none:
			if navigationItem.leftBarButtonItem != nil {
				navigationItem.setLeftBarButton(nil, animated: true)
			}
		case let .some(item):
			if let leftItemBacking = navigationItem.leftBarButtonItem as? Bar.ButtonItem.Backing {
				leftItemBacking.back(item)
			} else {
				navigationItem.setLeftBarButton(Bar.ButtonItem.Backing(item), animated: true)
			}
		}

		switch barContent.rightItem {
		case .none:
			if navigationItem.rightBarButtonItem != nil {
				navigationItem.setRightBarButton(nil, animated: true)
			}
		case let .some(item):
			if let rightItemBacking = navigationItem.rightBarButtonItem as? Bar.ButtonItem.Backing {
				rightItemBacking.back(item)
			} else {
				navigationItem.setRightBarButton(Bar.ButtonItem.Backing(item), animated: true)
			}
		}

		navigationItem.title = barContent.title ?? ""
	}
}

#endif

