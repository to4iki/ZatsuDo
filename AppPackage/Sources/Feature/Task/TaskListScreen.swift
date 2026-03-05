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
      TaskListView(uiState: viewModel.uiState)
        .navigationTitle(String(localized: "TaskList", bundle: .module))
    }
  }
}

#Preview {
  TaskListScreen(viewModel: .init())
}
