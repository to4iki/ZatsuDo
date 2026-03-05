import Observation
import SharedModel

public struct TaskListUiState: Sendable {
  public var tasks: [ZatsuTask]

  public init(tasks: [ZatsuTask] = []) {
    self.tasks = tasks
  }
}

@Observable
@MainActor
public final class TaskListViewModel {
  public private(set) var uiState: TaskListUiState = .init()

  public init() {}
}
