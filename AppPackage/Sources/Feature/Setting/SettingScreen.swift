import AppStorage
import Dependencies
import SwiftUI

public struct SettingScreen: View {
  private let viewModel: SettingViewModel

  public init(viewModel: SettingViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    NavigationStack {
      SettingView(
        uiState: viewModel.uiState,
        onUpdateResetTime: { viewModel.updateResetTime($0) }
      )
      .navigationTitle(String(localized: "Setting", bundle: .module))
    }
  }
}

#Preview {
  withDependencies {
    $0.resetTimeClient = .previewValue
  } operation: {
    SettingScreen(viewModel: .init())
  }
}
