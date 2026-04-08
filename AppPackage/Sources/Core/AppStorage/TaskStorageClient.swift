import Dependencies
import DependenciesMacros
import Logger
import SharedModel

@DependencyClient
public struct TaskStorageClient: Sendable {
  public var readTasks: @Sendable () -> [ZatsuTask] = { [] }
  public var writeTasks: @Sendable ([ZatsuTask]) -> Void = { _ in }
}

extension TaskStorageClient: DependencyKey {
  public static let liveValue: TaskStorageClient = {
    let store = AppSettingsStore()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    return TaskStorageClient(
      readTasks: {
        guard let data = store.tasksData else { return [] }
        return (try? decoder.decode([ZatsuTask].self, from: data)) ?? []
      },
      writeTasks: { tasks in
        Log.default.info("TaskStorageClient: writeTasks count=\(tasks.count)")
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
