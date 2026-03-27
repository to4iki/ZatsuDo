import AppStorage
import Dependencies
import Foundation
import Observation

public struct AppUiState: Sendable, Equatable {
  public var isOnboardingCompleted: Bool
}

@Observable
@MainActor
public final class AppViewModel {
  @ObservationIgnored
  @Dependency(\.appSettingsClient) private var client

  public private(set) var uiState: AppUiState
  public var isSettingPresented: Bool = false

  public init() {
    self.uiState = AppUiState(isOnboardingCompleted: client.fetchIsOnboardingCompleted())
  }

  public func completeOnboarding() {
    client.setIsOnboardingCompleted(true)
    uiState.isOnboardingCompleted = true
  }

  public func presentSetting() {
    isSettingPresented = true
  }
}
