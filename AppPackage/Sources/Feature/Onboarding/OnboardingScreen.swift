import SwiftUI

public struct OnboardingScreen: View {
  private let viewModel: OnboardingViewModel
  private let onComplete: () -> Void

  public init(
    viewModel: OnboardingViewModel,
    onComplete: @escaping () -> Void
  ) {
    self.viewModel = viewModel
    self.onComplete = onComplete
  }

  public var body: some View {
    OnboardingView(
      uiState: viewModel.uiState,
      pageSelection: Binding(
        get: { viewModel.uiState.currentPage },
        set: { viewModel.selectPage($0) }
      ),
      onAdvance: { viewModel.advancePage() },
      onComplete: onComplete
    )
  }
}

#Preview {
  OnboardingScreen(viewModel: .init(), onComplete: {})
}
