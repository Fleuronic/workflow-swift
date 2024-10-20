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
import class Workflow.Lifetime
import ReactiveSwift

/// Convenience to use `SignalProducer` as a `Workflow`
///
/// `Output` of this `Workflow` can be mapped to a `WorkflowAction`.
///
/// - Important:
/// In a `render()` call, if running multiple `SignalProducer`s
/// or if a `SignalProducer` can change in-between render passes,
/// use a `Worker` instead or use an explicit `key` while `running`.
///
/// ```
/// func render(state: State, context: RenderContext<Self>) -> MyScreen {
///     signalProducer
///         .mapOutput { MyAction($0) }
///         .running(in: context, key: "UniqueKeyForSignal")
///
///     return MyScreen()
/// }
/// ```
#if compiler(<6.0)
extension SignalProducer: AnyWorkflowConvertible where Error == Never {
	public func asAnyWorkflow() -> AnyWorkflow<Void, Value> {
		SignalProducerWorkflow(signalProducer: self).asAnyWorkflow()
	}
}
#else
extension SignalProducer: @retroactive AnyWorkflowConvertible where Error == Never {
	public func asAnyWorkflow() -> AnyWorkflow<Void, Value> {
		SignalProducerWorkflow(signalProducer: self).asAnyWorkflow()
	}
}
#endif

// MARK: -
struct SignalProducerWorkflow<Value> {
	let signalProducer: SignalProducer<Value, Never>	
}

// MARK: -
extension SignalProducerWorkflow: Workflow {
	public typealias Output = Value
	public typealias State = Void
	public typealias Rendering = Void

	public func render(
		state: State, 
		context: RenderContext<Self>
	) -> Rendering {
		let sink = context.makeSink(of: Action.self)
		context.runSideEffect(key: "") { [signalProducer] lifetime in
			signalProducer
				.take(during: lifetime.reactiveLifetime)
				.map(Action.init)
				.observe(on: QueueScheduler.main)
				.startWithValues(sink.send)
		}
	}
}

// MARK: -
extension SignalProducerWorkflow {
	struct Action {
		let output: Value
	}
}

// MARK: -
extension SignalProducerWorkflow.Action: WorkflowAction {
	typealias WorkflowType = SignalProducerWorkflow

	func apply(toState state: inout Void) -> Value? { output }
}

// MARK: -
private extension Lifetime {
	var reactiveLifetime: ReactiveSwift.Lifetime {
		let (lifetime, token) = ReactiveSwift.Lifetime.make()
		onEnded { token.dispose() }
		return lifetime
	}
}
