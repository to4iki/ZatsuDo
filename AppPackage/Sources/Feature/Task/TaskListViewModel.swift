import AppStorage
import Dependencies
import FeatureCommon
import Foundation
import Observation
import SharedModel

public struct TaskUiState: Sendable, Identifiable, Equatable {
  public var id: ZatsuTask.ID
  public var name: String
  public var isDone: Bool
  public var createdAtText: String

  public init(id: ZatsuTask.ID, name: String, isDone: Bool, createdAtText: String) {
    self.id = id
    self.name = name
    self.isDone = isDone
    self.createdAtText = createdAtText
  }

  init(from model: ZatsuTask) {
    self.id = model.id
    self.name = model.name
    self.isDone = model.isDone
    self.createdAtText = DateFormatText.yyyyMdHHmm(
      from: Date(timeIntervalSince1970: model.createdAt))
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
  @ObservationIgnored
  @Dependency(\.date) private var date

  @ObservationIgnored
  @Dependency(\.taskStorageClient) private var storageClient

  @ObservationIgnored
  private var tasks: [ZatsuTask] = []

  public private(set) var uiState: TaskListUiState = .init()

  public init() {
    @Dependency(\.taskStorageClient) var storageClient
    let loaded = storageClient.getTasks()
    self.tasks = loaded
    self.uiState.tasks = loaded.map(TaskUiState.init(from:))
  }

  public func toggleTask(id: ZatsuTask.ID) {
    guard let index = tasks.firstIndex(where: { $0.id == id }) else {
      Log.default.error("toggleTask: task not found id=\(id.rawValue)")
      return
    }
    let task = tasks[index]
    tasks[index] = ZatsuTask(
      id: task.id, name: task.name, isDone: !task.isDone, createdAt: task.createdAt)
    uiState.tasks[index].isDone.toggle()
    storageClient.saveTasks(tasks)
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
    let task = ZatsuTask(
      id: .init(rawValue: UUID().uuidString),
      name: name,
      isDone: false,
      createdAt: date.now.timeIntervalSince1970
    )
    tasks.append(task)
    uiState.tasks.append(TaskUiState(from: task))
    uiState.inputText = ""
    storageClient.saveTasks(tasks)
    Log.default.info("addTask: name=\(name, privacy: .private)")
  }
}
