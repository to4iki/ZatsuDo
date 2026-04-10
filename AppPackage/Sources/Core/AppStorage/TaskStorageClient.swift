import Dependencies
import DependenciesMacros
import Foundation
import Logger
import SharedModel

@DependencyClient
public struct TaskStorageClient: Sendable {
  public var getTasks: @Sendable () -> [ZatsuTask] = { [] }
  public var saveTasks: @Sendable ([ZatsuTask]) -> Void = { _ in }
}

extension TaskStorageClient: DependencyKey {
  public static let liveValue: TaskStorageClient = {
    let store = AppSettingsStore()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    return TaskStorageClient(
      getTasks: {
        guard let data = store.tasksData else { return [] }
        return (try? decoder.decode([ZatsuTask].self, from: data)) ?? []
      },
      saveTasks: { tasks in
        Log.default.info("TaskStorageClient: saveTasks count=\(tasks.count)")
        store.tasksData = try? encoder.encode(tasks)
      }
    )
  }()

  public static let previewValue = TaskStorageClient()
}

extension DependencyValues {
  public var taskStorageClient: TaskStorageClient {
    get { self[TaskStorageClient.self] }
    set { self[TaskStorageClient.self] = newValue }
  }
}
