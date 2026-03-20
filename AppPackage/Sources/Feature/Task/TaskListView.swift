import FeatureCommon
import SharedModel
import SwiftUI

struct TaskListView: View {
  private let uiState: TaskListUiState
  private let onToggleTask: (ZatsuTask.ID) -> Void
  private let onUpdateInputText: (String) -> Void
  private let onAddTask: () -> Void

  init(
    uiState: TaskListUiState,
    onToggleTask: @escaping (ZatsuTask.ID) -> Void,
    onUpdateInputText: @escaping (String) -> Void,
    onAddTask: @escaping () -> Void
  ) {
    self.uiState = uiState
    self.onToggleTask = onToggleTask
    self.onUpdateInputText = onUpdateInputText
    self.onAddTask = onAddTask
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      taskList
      inputBar
    }
    .ignoresSafeArea(.keyboard)
  }

  private var taskList: some View {
    List {
      Section {
        ForEach(uiState.tasks) { task in
          TaskRowView(task: task, onToggle: { onToggleTask(task.id) })
        }
      } header: {
        if !uiState.resetCountdown.isEmpty {
          Text(String(localized: "UntilReset \(uiState.resetCountdown)", bundle: .module))
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
    .listStyle(.insetGrouped)
    .overlay {
      if uiState.tasks.isEmpty {
        ContentUnavailableView(
          String(localized: "NoTasks", bundle: .module),
          systemImage: "checklist",
          description: Text(String(localized: "NoTasksDescription", bundle: .module))
        )
      }
    }
    .safeAreaInset(edge: .bottom) {
      Color.clear.frame(height: 80)
    }
  }

  private var inputBar: some View {
    InputBarView(
      placeholder: String(localized: "AddTask", bundle: .module),
      text: Binding(get: { uiState.inputText }, set: { onUpdateInputText($0) }),
      onSubmit: onAddTask
    )
  }
}

private struct TaskRowView: View {
  let task: TaskUiState
  let onToggle: () -> Void

  var body: some View {
    Button(action: onToggle) {
      HStack(spacing: 12) {
        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
          .font(.system(size: 22))
          .foregroundStyle(task.isDone ? Color.accentColor : Color.secondary)

        Text(task.name)
          .strikethrough(task.isDone)
          .foregroundStyle(task.isDone ? Color.secondary : Color.primary)

        Spacer()
      }
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  TaskListView(
    uiState: .init(
      tasks: [
        TaskUiState(id: "1", name: "test", isDone: false)
      ],
      resetCountdown: "8h 30m"
    ),
    onToggleTask: { _ in },
    onUpdateInputText: { _ in },
    onAddTask: {}
  )
}
