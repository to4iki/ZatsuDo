import SharedModel
import SwiftUI

public struct TaskListScreen: View {
  private let viewModel: TaskListViewModel
  private let onPresentSetting: () -> Void

  public init(
    viewModel: TaskListViewModel,
    onPresentSetting: @escaping () -> Void
  ) {
    self.viewModel = viewModel
    self.onPresentSetting = onPresentSetting
  }

  public var body: some View {
    NavigationStack {
      TaskListView(
        uiState: viewModel.uiState,
        onToggleTask: { viewModel.toggleTask(id: $0) },
        onToggleShowCompleted: { viewModel.toggleShowCompletedTasks() },
        onUpdateInputText: { viewModel.updateInputText($0) },
        onAddTask: { viewModel.addTask() }
      )
      .navigationTitle(String(localized: "Today", bundle: .module))
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: onPresentSetting) {
            Image(systemName: "gearshape")
          }
        }
      }
    }
  }
}

#Preview {
  TaskListScreen(viewModel: .init(), onPresentSetting: {})
}
