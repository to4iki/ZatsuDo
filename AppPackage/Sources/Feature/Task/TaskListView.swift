import FeatureCommon
import SharedModel
import SwiftUI

struct TaskListView: View {
  private let uiState: TaskListUiState
  private let onToggleTask: (ZatsuTask.ID) -> Void
  private let onToggleShowCompleted: () -> Void
  private let onUpdateInputText: (String) -> Void
  private let onAddTask: () -> Void

  init(
    uiState: TaskListUiState,
    onToggleTask: @escaping (ZatsuTask.ID) -> Void,
    onToggleShowCompleted: @escaping () -> Void,
    onUpdateInputText: @escaping (String) -> Void,
    onAddTask: @escaping () -> Void
  ) {
    self.uiState = uiState
    self.onToggleTask = onToggleTask
    self.onToggleShowCompleted = onToggleShowCompleted
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
        ForEach(uiState.visibleTasks) { task in
          TaskRowView(task: task, onToggle: { onToggleTask(task.id) })
        }
      } header: {
        sectionHeader
      }
    }
    .listStyle(.insetGrouped)
    .overlay {
      if uiState.visibleTasks.isEmpty {
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

  private var sectionHeader: some View {
    HStack {
      if !uiState.resetCountdown.isEmpty {
        Text(String(localized: "UntilReset \(uiState.resetCountdown)", bundle: .module))
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      Spacer()
      Button(action: onToggleShowCompleted) {
        Image(
          systemName: uiState.showsCompletedTasks
            ? "line.3.horizontal.decrease.circle.fill"
            : "line.3.horizontal.decrease.circle"
        )
        .font(.body)
        .foregroundStyle(uiState.showsCompletedTasks ? Color.accentColor : .secondary)
      }
      .buttonStyle(.plain)
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
          .accessibilityHidden(true)

        VStack(alignment: .leading, spacing: 2) {
          Text(task.name)
            .strikethrough(task.isDone)
            .foregroundStyle(task.isDone ? Color.secondary : Color.primary)

          Text(task.createdAtText)
            .font(.caption2)
            .foregroundStyle(.tertiary)
        }

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
        TaskUiState(
          id: "1",
          name: "test",
          isDone: false,
          createdAtText: DateFormatText.yyyyMdHHmm(from: Date())
        )
      ],
      resetCountdown: "8h 30m"
    ),
    onToggleTask: { _ in },
    onToggleShowCompleted: {},
    onUpdateInputText: { _ in },
    onAddTask: {}
  )
}
