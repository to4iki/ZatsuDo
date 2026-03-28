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

    #expect(viewModel.uiState.tasks[0].isDone == false)

    viewModel.toggleTask(id: taskId)

    #expect(viewModel.uiState.tasks[0].isDone == true)

    viewModel.toggleTask(id: taskId)

    #expect(viewModel.uiState.tasks[0].isDone == false)
  }

  @Test
  func toggleTask_ignoresInvalidId() {
    let viewModel = TaskListViewModel()

    viewModel.updateInputText("Buy milk")
    viewModel.addTask()

    let invalidId = ZatsuTask.ID(rawValue: "nonexistent")

    viewModel.toggleTask(id: invalidId)

    #expect(viewModel.uiState.tasks.count == 1)
    #expect(viewModel.uiState.tasks[0].isDone == false)
  }

  @Test
  func addTask_appendsNewTask() {
    let viewModel = TaskListViewModel()

    viewModel.updateInputText("Task 1")
    viewModel.addTask()

    viewModel.updateInputText("Task 2")
    viewModel.addTask()

    #expect(viewModel.uiState.tasks.count == 2)
    #expect(viewModel.uiState.tasks[0].name == "Task 1")
    #expect(viewModel.uiState.tasks[1].name == "Task 2")
  }

  @Test
  func addTask_ignoresEmptyInput() {
    let viewModel = TaskListViewModel()

    viewModel.addTask()

    #expect(viewModel.uiState.tasks.isEmpty)
  }

  @Test
  func addTask_trimsWhitespace() {
    let viewModel = TaskListViewModel()

    viewModel.updateInputText("  Buy milk  ")
    viewModel.addTask()

    #expect(viewModel.uiState.tasks.count == 1)
    #expect(viewModel.uiState.tasks[0].name == "Buy milk")
  }

  @Test
  func addTask_clearsInputText() {
    let viewModel = TaskListViewModel()

    viewModel.updateInputText("Buy milk")
    viewModel.addTask()

    #expect(viewModel.uiState.inputText == "")
  }

  @Test
  func updateInputText_updatesState() {
    let viewModel = TaskListViewModel()

    viewModel.updateInputText("Hello")

    #expect(viewModel.uiState.inputText == "Hello")
  }
}
