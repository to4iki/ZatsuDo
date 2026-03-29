import FeatureCommon
import Foundation
import Observation
import SharedModel

public struct TaskUiState: Sendable, Identifiable, Equatable {
  public var id: ZatsuTask.ID
  public var name: String
  public var isDone: Bool

  public init(id: ZatsuTask.ID, name: String, isDone: Bool) {
    self.id = id
    self.name = name
    self.isDone = isDone
  }

  init(from model: ZatsuTask) {
    self.id = model.id
    self.name = model.name
    self.isDone = model.isDone
  }
}

public struct TaskListUiState: Sendable, Equatable {
  public var tasks: [TaskUiState] = []
  public var resetCountdown: String = ""
  public var inputText: String = ""
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
        isDone: false
      ))
    uiState.inputText = ""
    Log.default.info("addTask: name=\(name, privacy: .private)")
  }
}
