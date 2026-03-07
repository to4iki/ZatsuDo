import SharedModel
import SwiftUI

public struct TaskListScreen: View {
  private let viewModel: TaskListViewModel

  public init(
    viewModel: TaskListViewModel
  ) {
    self.viewModel = viewModel
  }

  public var body: some View {
    NavigationStack {
      TaskListView(
        uiState: viewModel.uiState,
        onToggleTask: { viewModel.toggleTask(id: $0) },
        onUpdateInputText: { viewModel.updateInputText($0) },
        onAddTask: { viewModel.addTask() }
      )
      .navigationTitle(String(localized: "Today", bundle: .module))
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

#Preview {
  TaskListScreen(viewModel: .init())
}
