import FeatureCommon
import Foundation
import Observation
import SharedModel

public struct TaskUiState: Sendable, Identifiable, Equatable {
  public var id: ZatsuTask.ID
  public var name: String
  public var isDone: Bool
  public var createdAt: TimeInterval

  public var formattedCreatedAt: String {
    let date = Date(timeIntervalSince1970: createdAt)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter.string(from: date)
  }

  public init(id: ZatsuTask.ID, name: String, isDone: Bool, createdAt: TimeInterval) {
    self.id = id
    self.name = name
    self.isDone = isDone
    self.createdAt = createdAt
  }

  init(from model: ZatsuTask) {
    self.id = model.id
    self.name = model.name
    self.isDone = model.isDone
    self.createdAt = model.createdAt
  }
}

public struct TaskListUiState: Sendable, Equatable {
  public var tasks: [TaskUiState] = []
  public var showsCompletedTasks: Bool = false
  public var resetCountdown: String = ""
  public var inputText: String = ""

  public var visibleTasks: [TaskUiState] {
    if showsCompletedTasks {
      tasks
    } else {
      tasks.filter { !$0.isDone }
    }
  }
}

@Observable
@MainActor
public final class TaskListViewModel {
  public private(set) var uiState: TaskListUiState = .init()

  public init() {}

  public func toggleTask(id: ZatsuTask.ID) {
    guard let index = uiState.tasks.firstIndex(where: { $0.id == id }) else {
      Log.default.error("toggleTask: task not found id=\(id.rawValue)")
      return
    }
    uiState.tasks[index].isDone.toggle()
    Log.default.debug("toggleTask: id=\(id.rawValue), isDone=\(self.uiState.tasks[index].isDone)")
  }

  public func toggleShowCompletedTasks() {
    uiState.showsCompletedTasks.toggle()
    Log.default.debug(
      "toggleShowCompletedTasks: showsCompletedTasks=\(self.uiState.showsCompletedTasks)")
  }

  public func updateInputText(_ text: String) {
    uiState.inputText = text
  }

  public func addTask() {
    let name = uiState.inputText.trimmingCharacters(in: .whitespaces)
    guard !name.isEmpty else {
      return
    }
    uiState.tasks.append(
      TaskUiState(
        id: .init(rawValue: UUID().uuidString),
        name: name,
        isDone: false,
        createdAt: Date().timeIntervalSince1970
      ))
    uiState.inputText = ""
    Log.default.info("addTask: name=\(name, privacy: .private)")
  }
}
