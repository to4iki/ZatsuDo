import Foundation
import Observation

public struct AppUiState: Sendable, Equatable {
  public var isOnboardingCompleted: Bool
  public var isSettingPresented: Bool = false
}

@Observable
@MainActor
public final class AppViewModel {
  private static let onboardingCompletedKey = "isOnboardingCompleted"

  public private(set) var uiState: AppUiState

  public init() {
    let completed = UserDefaults.standard.bool(forKey: Self.onboardingCompletedKey)
    self.uiState = AppUiState(isOnboardingCompleted: completed)
  }

  public func completeOnboarding() {
    UserDefaults.standard.set(true, forKey: Self.onboardingCompletedKey)
    uiState.isOnboardingCompleted = true
  }

  public func presentSetting() {
    uiState.isSettingPresented = true
  }

  public func dismissSetting() {
    uiState.isSettingPresented = false
  }
}
