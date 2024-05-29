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

import os.signpost

/// Namespace for Worker logging
public enum WorkerLogging {}

// MARK: -
public extension WorkerLogging {
	static var enabled: Bool {
		get { OSLog.active === OSLog.worker }
		set { OSLog.active = newValue ? .worker : .disabled }
	}
}

// MARK: -
/// Logs Worker events to OSLog
final class WorkerLogger<WorkerType: Worker> {
	init() {}
}

// MARK: -
extension WorkerLogger {
	var signpostID: OSSignpostID { 
		.init(
			log: .active, 
			object: self
		) 
	}

	func logStarted() {
		os_signpost(
			.begin,
			log: .active,
			name: "Running",
			signpostID: signpostID,
			"Worker: %{private}@",
			String(describing: WorkerType.self)
		)
	}

	func logFinished(status: StaticString) {
		os_signpost(
			.end, 
			log: .active, 
			name: "Running", 
			signpostID: signpostID, 
			status
		)
	}

	func logOutput() {
		os_signpost(
			.event,
			log: .active,
			name: "Worker Event",
			signpostID: signpostID,
			"Event: %{private}@",
			String(describing: WorkerType.self)
		)
	}
}

// MARK: -
private extension OSLog {
	static let worker = OSLog(
		subsystem: "com.squareup.WorkflowReactiveSwift", 
		category: "Worker"
	)

	static var active: OSLog = .disabled
}
