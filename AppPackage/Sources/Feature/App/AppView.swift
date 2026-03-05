import SwiftUI
import TaskFeature

public struct AppView: View {
  @State private var taskListViewModel = TaskListViewModel()

  public init() {}

  public var body: some View {
    TaskListScreen(viewModel: taskListViewModel)
  }
}

#Preview {
  AppView()
}
