import SharedModel
import SwiftUI

struct TaskListView: View {
  private let uiState: TaskListUiState

  init(
    uiState: TaskListUiState
  ) {
    self.uiState = uiState
  }

  var body: some View {
    List(uiState.tasks) { task in
      Text(task.name)
    }
  }
}

#Preview {
  TaskListView(
    uiState: .init(
      tasks: Array(0...10)
        .map(String.init)
        .map(ZatsuTask.sample(_:))
    ))
}
