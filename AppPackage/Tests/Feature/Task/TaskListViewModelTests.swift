import AppStorage
import Dependencies
import Foundation
import SharedModel
import TaskFeature
import Testing

@MainActor
@Suite
struct TaskListViewModelTests {
  @Test
  func toggleTask_togglesDoneState() {
    withDependencies {
      $0.taskStorageClient.readTasks = { [] }
      $0.taskStorageClient.writeTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      viewModel.updateInputText("Buy milk")
      viewModel.addTask()

      let taskId = viewModel.uiState.tasks[0].id
      viewModel.toggleTask(id: taskId)

      #expect(viewModel.uiState.tasks[0].isDone == true)
    }
  }

  @Test
  func addTask_appendsTaskAndClearsInput() {
    withDependencies {
      $0.taskStorageClient.readTasks = { [] }
      $0.taskStorageClient.writeTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      viewModel.updateInputText("Task 1")
      viewModel.addTask()

      #expect(viewModel.uiState.tasks.count == 1)
      #expect(viewModel.uiState.tasks[0].name == "Task 1")
      #expect(viewModel.uiState.inputText == "")
    }
  }

  @Test
  func addTask_ignoresEmptyInput() {
    withDependencies {
      $0.taskStorageClient.readTasks = { [] }
      $0.taskStorageClient.writeTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      viewModel.addTask()
      #expect(viewModel.uiState.tasks.isEmpty)

      viewModel.updateInputText("   ")
      viewModel.addTask()
      #expect(viewModel.uiState.tasks.isEmpty)
    }
  }

  @Test
  func addTask_setsCreatedAtText() {
    let fixedDate = Date(timeIntervalSince1970: 1_775_358_000)  // 2026-04-03 10:00 JST
    withDependencies {
      $0.date = .constant(fixedDate)
      $0.taskStorageClient.readTasks = { [] }
      $0.taskStorageClient.writeTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      viewModel.updateInputText("Timed task")
      viewModel.addTask()

      #expect(viewModel.uiState.tasks[0].createdAtText.contains("2026"))
    }
  }

  @Test
  func addTask_persistsToStorage() {
    var savedTasks: [ZatsuTask]?
    withDependencies {
      $0.taskStorageClient.readTasks = { [] }
      $0.taskStorageClient.writeTasks = { savedTasks = $0 }
    } operation: {
      let viewModel = TaskListViewModel()

      viewModel.updateInputText("Persist me")
      viewModel.addTask()

      #expect(savedTasks?.count == 1)
      #expect(savedTasks?[0].name == "Persist me")
    }
  }

  @Test
  func init_restoresTasksFromStorage() {
    let storedTasks: [ZatsuTask] = [
      ZatsuTask(id: "task-1", name: "Stored task", isDone: false, createdAt: 1_775_358_000)
    ]
    withDependencies {
      $0.taskStorageClient.readTasks = { storedTasks }
      $0.taskStorageClient.writeTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      #expect(viewModel.uiState.tasks.count == 1)
      #expect(viewModel.uiState.tasks[0].name == "Stored task")
    }
  }

  @Test
  func visibleTasks_hidesCompletedByDefault() {
    withDependencies {
      $0.taskStorageClient.readTasks = { [] }
      $0.taskStorageClient.writeTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      viewModel.updateInputText("Task A")
      viewModel.addTask()
      viewModel.updateInputText("Task B")
      viewModel.addTask()

      let taskAId = viewModel.uiState.tasks[0].id
      viewModel.toggleTask(id: taskAId)

      #expect(viewModel.uiState.tasks.count == 2)
      #expect(viewModel.uiState.visibleTasks.count == 1)
      #expect(viewModel.uiState.visibleTasks[0].name == "Task B")
    }
  }

  @Test
  func toggleShowCompletedTasks_togglesVisibility() {
    withDependencies {
      $0.taskStorageClient.readTasks = { [] }
      $0.taskStorageClient.writeTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      viewModel.updateInputText("Task A")
      viewModel.addTask()

      let taskId = viewModel.uiState.tasks[0].id
      viewModel.toggleTask(id: taskId)

      #expect(viewModel.uiState.visibleTasks.count == 0)

      viewModel.toggleShowCompletedTasks()

      #expect(viewModel.uiState.showsCompletedTasks == true)
      #expect(viewModel.uiState.visibleTasks.count == 1)

      viewModel.toggleShowCompletedTasks()

      #expect(viewModel.uiState.showsCompletedTasks == false)
      #expect(viewModel.uiState.visibleTasks.count == 0)
    }
  }
}
