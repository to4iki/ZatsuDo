import AppFeature
import AppStorage
import Foundation
import Testing

@MainActor
@Suite
struct AppViewModelTests {
  private let suiteName = "AppViewModelTests"

  init() {
    UserDefaults.standard.removePersistentDomain(forName: suiteName)
  }

  @Test
  func completeOnboarding_updatesUiStateAndStore() {
    let defaults = UserDefaults(suiteName: suiteName)!
    let store = AppSettingsStore(defaults: defaults)
    let viewModel = AppViewModel(store: store)

    #expect(viewModel.uiState.isOnboardingCompleted == false)
    #expect(store.isOnboardingCompleted == false)

    viewModel.completeOnboarding()

    #expect(viewModel.uiState.isOnboardingCompleted == true)
    #expect(store.isOnboardingCompleted == true)
  }
}
