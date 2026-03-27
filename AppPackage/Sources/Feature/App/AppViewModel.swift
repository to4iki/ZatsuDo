import AppStorage
import Dependencies
import Foundation
import Observation

public struct AppUiState: Sendable, Equatable {
  public var isOnboardingCompleted: Bool = false
}

@Observable
@MainActor
public final class AppViewModel {
  @ObservationIgnored
  @Dependency(\.onboardingClient) private var client

  public private(set) var uiState: AppUiState
  public var isSettingPresented: Bool = false

  public init() {
    @Dependency(\.onboardingClient) var onboardingClient
    self.uiState = AppUiState(isOnboardingCompleted: onboardingClient.fetchIsCompleted())
  }

  public func completeOnboarding() {
    client.setIsCompleted(true)
    uiState.isOnboardingCompleted = true
  }

  public func presentSetting() {
    isSettingPresented = true
  }
}
