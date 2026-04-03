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

  @Test
  func visibleTasks_hidesCompletedByDefault() {
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

  @Test
  func toggleShowCompletedTasks_togglesVisibility() {
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
