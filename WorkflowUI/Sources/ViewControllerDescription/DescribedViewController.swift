/*
 * Copyright 2020 Square Inc.
 * Copyright 2024 Fleuronic LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

import UIKit
import ViewEnvironment

public final class DescribedViewController: UIViewController {
	var currentViewController: UIViewController
	
	public init(description: ViewControllerDescription) {
		self.currentViewController = description.buildViewController()
		super.init(nibName: nil, bundle: nil)
		
		addChild(currentViewController)
		currentViewController.didMove(toParent: self)
	}
	
	// MARK: UIViewController
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		currentViewController.view.frame = view.bounds
		view.addSubview(currentViewController.view)
		
		updatePreferredContentSizeIfNeeded()
	}
	
	override public func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		currentViewController.view.frame = view.bounds
	}

	#if !os(tvOS)
	override public var childForStatusBarStyle: UIViewController? {
		currentViewController
	}
	
	override public var childForStatusBarHidden: UIViewController? {
		currentViewController
	}
	
	override public var childForHomeIndicatorAutoHidden: UIViewController? {
		currentViewController
	}
	
	override public var childForScreenEdgesDeferringSystemGestures: UIViewController? {
		currentViewController
	}
	
	override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		currentViewController.supportedInterfaceOrientations
	}
	
	override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		currentViewController.preferredStatusBarUpdateAnimation
	}
	
	override public var childViewControllerForPointerLock: UIViewController? {
		currentViewController
	}
	#endif

	override public func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
		super.preferredContentSizeDidChange(forChildContentContainer: container)
		
		guard container === currentViewController else { return }
		updatePreferredContentSizeIfNeeded()
	}
	
	// MARK: NSCoding
	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) is unavailable")
	}
}

// MARK: -
public extension DescribedViewController {
	convenience init<S: Screen>(
		screen: S, 
		environment: ViewEnvironment
	) {
		self.init(description: screen.viewControllerDescription(environment: environment))
	}

	func update(description: ViewControllerDescription) {
		if description.canUpdate(viewController: currentViewController) {
			description.update(viewController: currentViewController)
		} else {
			currentViewController.willMove(toParent: nil)
			currentViewController.viewIfLoaded?.removeFromSuperview()
			currentViewController.removeFromParent()
			
			currentViewController = description.buildViewController()
			addChild(currentViewController)
			
			if isViewLoaded {
				currentViewController.view.frame = view.bounds
				view.addSubview(currentViewController.view)
				updatePreferredContentSizeIfNeeded()
			}
			
			currentViewController.didMove(toParent: self)
			updatePreferredContentSizeIfNeeded()
		}
	}

	func update<S: Screen>(
		screen: S, 
		environment: ViewEnvironment
	) {
		update(description: screen.viewControllerDescription(environment: environment))
	}
}

private extension DescribedViewController {
	private func updatePreferredContentSizeIfNeeded() {
		guard
			case let newPreferredContentSize = currentViewController.preferredContentSize,
			newPreferredContentSize != preferredContentSize else { return }
		
		preferredContentSize = newPreferredContentSize
	}
}

#endif
