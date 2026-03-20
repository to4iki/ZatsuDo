import SwiftUI

struct SettingView: View {
  private let uiState: SettingUiState
  private let onUpdateResetTime: (Date) -> Void

  init(
    uiState: SettingUiState,
    onUpdateResetTime: @escaping (Date) -> Void
  ) {
    self.uiState = uiState
    self.onUpdateResetTime = onUpdateResetTime
  }

  var body: some View {
    Form {
      resetTimeSection
    }
  }

  private var resetTimeSection: some View {
    Section {
      DatePicker(
        String(localized: "ResetTime", bundle: .module),
        selection: Binding(
          get: { uiState.resetDate },
          set: { onUpdateResetTime($0) }
        ),
        displayedComponents: .hourAndMinute
      )
    } header: {
      Label(
        String(localized: "ResetSectionHeader", bundle: .module),
        systemImage: "clock"
      )
    } footer: {
      Text(String(localized: "ResetTimeDescription", bundle: .module))
    }
  }
}

#Preview {
  SettingView(
    uiState: .init(resetHour: 4, resetMinute: 0),
    onUpdateResetTime: { _ in }
  )
}
