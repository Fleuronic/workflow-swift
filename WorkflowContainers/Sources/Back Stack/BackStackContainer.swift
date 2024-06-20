// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit)

import UIKit
import WorkflowUI
import ViewEnvironment

public extension BackStack {
	final class Container<Content: WorkflowUI.Screen>: ScreenViewController<BackStack.Screen<Content>>, UINavigationControllerDelegate {
		private let controller = UINavigationController()

		// MARK: UIViewController
		override public func viewDidLoad() {
			super.viewDidLoad()

			controller.delegate = self
			addChild(controller)
			view.addSubview(controller.view)
			controller.didMove(toParent: self)
		}

		override public func viewDidLayoutSubviews() {
			super.viewDidLayoutSubviews()
			controller.view.frame = view.bounds
		}

		// MARK: UINavigationControllerDelegate
		public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
			setNavigationBarVisibility(with: screen, animated: animated)
		}

		// MARK: ScreenViewController
		override public func screenDidChange(from previousScreen: BackStack.Screen<Content>, previousEnvironment: ViewEnvironment) {
			super.screenDidChange(from: previousScreen, previousEnvironment: previousEnvironment)

			var existingViewControllers = controller.viewControllers as! [BackStackViewController<Content>]
			var updatedViewControllers: [BackStackViewController<Content>] = []

			for item in screen.items {
				if let index = existingViewControllers.firstIndex(where: { $0.matches(item) }) {
					let existingViewController = existingViewControllers.remove(at: index)
					existingViewController.update(item: item, environment: environment)
					updatedViewControllers.append(existingViewController)
				} else {
					updatedViewControllers.append(BackStackViewController(item: item, environment: environment))
				}
			}

			if controller.viewControllers != updatedViewControllers {
				controller.setViewControllers(updatedViewControllers, animated: true)
			}
		}
	}
}

// MARK: -
private extension BackStack.Container {
	func setNavigationBarVisibility(with screen: BackStack.Screen<Content>, animated: Bool) {
		guard let topScreen = screen.items.last else { return }

		let hidden: Bool
		switch topScreen.barVisibility {
		case .hidden:
			hidden = true
		case .visible:
			hidden = false
		}

		controller.setNavigationBarHidden(hidden, animated: animated)
	}
}

#endif

