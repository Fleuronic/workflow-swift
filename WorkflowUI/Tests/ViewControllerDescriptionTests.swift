/*
 * Copyright 2020 Square Inc.
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

#if canImport(UIKit)

    import XCTest

    import ReactiveSwift
    import Workflow
    @testable import WorkflowUI

    fileprivate class BlankViewController: UIViewController {}

    @objc fileprivate protocol MyProtocol {
        func update()
    }

    class ViewControllerDescriptionTests: XCTestCase {
        func test_build() {
            let description = ViewControllerDescription(
                build: { BlankViewController() },
                update: { _ in }
            )

            // Check built view controller
            let viewController = description.buildViewController()
            XCTAssertTrue(type(of: viewController) == BlankViewController.self)

            // Check another built view controller isn’t somehow the same instance
            let viewControllerAgain = description.buildViewController()
            XCTAssertFalse(viewController === viewControllerAgain)
        }

        func test_canUpdate() {
            let description = ViewControllerDescription(
                build: { BlankViewController() },
                update: { _ in }
            )

            let viewController = description.buildViewController()
            XCTAssertTrue(description.canUpdate(viewController: viewController))

            let otherViewController = UIViewController()
            XCTAssertFalse(description.canUpdate(viewController: otherViewController))

            final class SubclassViewController: BlankViewController {}

            // We can update subclasses too, as long as they pass an "is/as?" check.
            let subclassViewController = SubclassViewController()
            XCTAssertTrue(description.canUpdate(viewController: subclassViewController))
        }

        func test_canUpdate_abstractViewController() {
            func makeAbstractViewController() -> UIViewController & MyProtocol {
                class ConcreteViewController: UIViewController, MyProtocol {
                    func update() {}
                }
                return ConcreteViewController()
            }

            let viewController = makeAbstractViewController()

            let description = ViewControllerDescription(
                build: { viewController },
                update: { $0.update() }
            )

            XCTAssertTrue(description.canUpdate(viewController: viewController))
            XCTAssertFalse(description.canUpdate(viewController: UIViewController()))
        }

        func test_update() {
            var updateCount = 0
            let description = ViewControllerDescription(
                build: { BlankViewController() },
                update: { viewController in
                    XCTAssertTrue(type(of: viewController) == BlankViewController.self)
                    updateCount += 1
                }
            )

            XCTAssertEqual(updateCount, 0)

            // Build causes an initial update
            let viewController = description.buildViewController()
            XCTAssertEqual(updateCount, 1)

            description.update(viewController: viewController)
            XCTAssertEqual(updateCount, 2)

            description.update(viewController: viewController)
            XCTAssertEqual(updateCount, 3)
        }

        func test_screenViewController() {
            // Make sure ScreenViewController<T>.description(for:) generates a correct view controller
            // description

            struct MyScreen: Screen {
                func viewControllerDescription(environment: ViewEnvironment) -> ViewControllerDescription {
                    return MyScreenViewController.description(for: self, environment: environment)
                }
            }

            final class MyScreenViewController: ScreenViewController<MyScreen> {}

            let screen = MyScreen()
            let description = screen.viewControllerDescription(environment: .empty)

            let viewController = description.buildViewController()
            XCTAssertTrue(type(of: viewController) == MyScreenViewController.self)

            XCTAssertTrue(description.canUpdate(viewController: viewController))

            let viewControllerAgain = description.buildViewController()
            XCTAssertFalse(viewController === viewControllerAgain)
        }
    }

#endif
