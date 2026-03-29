import SharedModel
import TaskFeature
import Testing

@MainActor
@Suite
struct TaskListViewModelTests {
  @Test
  func toggleTask_togglesDoneState() {
    let viewModel = TaskListViewModel()

    viewModel.updateInputText("Buy milk")
    viewModel.addTask()

    let taskId = viewModel.uiState.tasks[0].id
    viewModel.toggleTask(id: taskId)

    #expect(viewModel.uiState.tasks[0].isDone == true)
  }

  @Test
  func toggleTask_ignoresInvalidId() {
    let viewModel = TaskListViewModel()

    viewModel.updateInputText("Buy milk")
    viewModel.addTask()

    viewModel.toggleTask(id: ZatsuTask.ID(rawValue: "nonexistent"))

    #expect(viewModel.uiState.tasks[0].isDone == false)
  }

  @Test
  func addTask_appendsTaskAndClearsInput() {
    let viewModel = TaskListViewModel()

    viewModel.updateInputText("Task 1")
    viewModel.addTask()

    #expect(viewModel.uiState.tasks.count == 1)
    #expect(viewModel.uiState.tasks[0].name == "Task 1")
    #expect(viewModel.uiState.inputText == "")
  }

  @Test
  func addTask_ignoresEmptyInput() {
    let viewModel = TaskListViewModel()

    viewModel.addTask()
    #expect(viewModel.uiState.tasks.isEmpty)

    viewModel.updateInputText("   ")
    viewModel.addTask()
    #expect(viewModel.uiState.tasks.isEmpty)
  }
}
