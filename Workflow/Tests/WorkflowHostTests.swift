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

import Workflow
import XCTest

final class WorkflowHostTests: XCTestCase {
	func test_updatedInputCausesRenderPass() {
		let host = WorkflowHost(workflow: TestWorkflow(step: .first))

		XCTAssertEqual(1, host.rendering.value)

		host.update(workflow: TestWorkflow(step: .second))

		XCTAssertEqual(2, host.rendering.value)
	}

	fileprivate struct TestWorkflow: Workflow {
		var step: Step
		enum Step {
			case first
			case second
		}

		struct State {}
		func makeInitialState() -> State {
			return State()
		}

		typealias Rendering = Int

		func render(state: State, context: RenderContext<TestWorkflow>) -> Rendering {
			switch step {
			case .first:
				return 1
			case .second:
				return 2
			}
		}
	}
}
