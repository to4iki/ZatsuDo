import AppFeature
import AppStorage
import Dependencies
import Foundation
import Testing

@MainActor
@Suite
struct AppViewModelTests {
  @Test
  func completeOnboarding_updatesUiState() {
    var didSetOnboardingCompleted = false

    withDependencies {
      $0.onboardingClient.readIsCompleted = { false }
      $0.onboardingClient.writeIsCompleted = { _ in didSetOnboardingCompleted = true }
    } operation: {
      let viewModel = AppViewModel()

      #expect(viewModel.uiState.isOnboardingCompleted == false)

      viewModel.completeOnboarding()

      #expect(viewModel.uiState.isOnboardingCompleted == true)
      #expect(didSetOnboardingCompleted == true)
    }
  }

  @Test
  func presentSetting_updatesFlag() {
    withDependencies {
      $0.onboardingClient.readIsCompleted = { false }
    } operation: {
      let viewModel = AppViewModel()

      #expect(viewModel.isSettingPresented == false)

      viewModel.presentSetting()

      #expect(viewModel.isSettingPresented == true)
    }
  }

  @Test
  func init_restoresOnboardingStateFromClient() {
    withDependencies {
      $0.onboardingClient.readIsCompleted = { true }
    } operation: {
      let viewModel = AppViewModel()

      #expect(viewModel.uiState.isOnboardingCompleted == true)
    }
  }
}
