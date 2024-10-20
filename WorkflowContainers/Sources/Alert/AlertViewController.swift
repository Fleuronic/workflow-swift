// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit) && !os(watchOS)

import UIKit
import Workflow
import WorkflowUI
import ViewEnvironment

extension Alert {
	final class ViewController<Screen: WorkflowUI.Screen>: ScreenViewController<Alert.Screen<Screen>> {
		private let baseScreenViewController: DescribedViewController

		private var alertController: UIAlertController?

		required init(
			screen: Alert.Screen<Screen>,
			environment: ViewEnvironment
		) {
			baseScreenViewController = DescribedViewController(screen: screen.baseScreen, environment: environment)
			super.init(screen: screen, environment: environment)
		}

		override func viewDidLoad() {
			super.viewDidLoad()

			addChild(baseScreenViewController)
			view.addSubview(baseScreenViewController.view)
			baseScreenViewController.didMove(toParent: self)
		}

		override func viewDidLayoutSubviews() {
			super.viewDidLayoutSubviews()
			baseScreenViewController.view.frame = view.bounds
		}

		override func screenDidChange(from previousScreen: Alert.Screen<Screen>, previousEnvironment: ViewEnvironment) {
			super.screenDidChange(from: previousScreen, previousEnvironment: previousEnvironment)
			baseScreenViewController.update(screen: screen.baseScreen, environment: environment)

			if let alert = screen.alert {
				guard alertController == nil else { return }
				let alertController = UIAlertController(alert) { [weak self] in
					self?.alertController = nil
				}

				baseScreenViewController.present(alertController, animated: true)
				self.alertController = alertController
			}
		}

		override var childForStatusBarStyle: UIViewController? {
			baseScreenViewController
		}

		override var childForStatusBarHidden: UIViewController? {
			baseScreenViewController
		}

		override var childForHomeIndicatorAutoHidden: UIViewController? {
			baseScreenViewController
		}

		override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
			baseScreenViewController
		}

		override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
			baseScreenViewController.supportedInterfaceOrientations
		}
	}
}

// MARK: -
private extension UIAlertController {
	convenience init(_ alert: Alert, dismissHandler: @escaping () -> Void) {
		self.init(
			title: alert.title,
			message: alert.message,
			preferredStyle: .alert
		)
		
		alert.actions.map { action in
			UIAlertAction(
				title: action.title,
				style: .init(action.style),
				handler: { _ in
					action.handler()
					dismissHandler()
				}
			)
		}.forEach(addAction)
	}
}

// MARK: -
private extension UIAlertAction.Style {
	init(_ style: Alert.Action.Style) {
		self.init(rawValue: style.rawValue)!
	}
}

#endif
