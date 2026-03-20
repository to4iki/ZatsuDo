import AppStorage
import Foundation
import Observation

public struct AppUiState: Sendable, Equatable {
  public var isOnboardingCompleted: Bool
}

@Observable
@MainActor
public final class AppViewModel {
  private let store: AppSettingsStore

  public private(set) var uiState: AppUiState
  public var isSettingPresented: Bool = false

  public init(store: AppSettingsStore = .shared) {
    self.store = store
    self.uiState = AppUiState(isOnboardingCompleted: store.isOnboardingCompleted)
  }

  public func completeOnboarding() {
    store.isOnboardingCompleted = true
    uiState.isOnboardingCompleted = true
  }

  public func presentSetting() {
    isSettingPresented = true
  }
}
