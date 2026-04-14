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
  func addTask_appendsTaskAndClearsInput() {
    withDependencies {
      $0.taskStorageClient.getTasks = { [] }
      $0.taskStorageClient.saveTasks = { _ in }
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
      $0.taskStorageClient.getTasks = { [] }
      $0.taskStorageClient.saveTasks = { _ in }
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
  func init_restoresTasksFromStorage() {
    let storedTasks: [ZatsuTask] = [
      ZatsuTask(id: "task-1", name: "Stored task", isDone: false, createdAt: 1_775_358_000)
    ]
    withDependencies {
      $0.taskStorageClient.getTasks = { storedTasks }
      $0.taskStorageClient.saveTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      #expect(viewModel.uiState.tasks.count == 1)
      #expect(viewModel.uiState.tasks[0].name == "Stored task")
    }
  }

  @Test
  func toggleShowCompletedTasks_filtersVisibleTasksByDoneState() {
    withDependencies {
      $0.taskStorageClient.getTasks = { [] }
      $0.taskStorageClient.saveTasks = { _ in }
    } operation: {
      let viewModel = TaskListViewModel()

      viewModel.updateInputText("Task A")
      viewModel.addTask()
      viewModel.updateInputText("Task B")
      viewModel.addTask()

      let taskAId = viewModel.uiState.tasks[0].id
      viewModel.toggleTask(id: taskAId)

      #expect(viewModel.uiState.tasks[0].isDone == true)
      #expect(viewModel.uiState.visibleTasks.count == 1)
      #expect(viewModel.uiState.visibleTasks[0].name == "Task B")

      viewModel.toggleShowCompletedTasks()

      #expect(viewModel.uiState.showsCompletedTasks == true)
      #expect(viewModel.uiState.visibleTasks.count == 2)
    }
  }
}
