import Dependencies
import DependenciesMacros

@DependencyClient
public struct OnboardingClient: Sendable {
  public var fetchIsCompleted: @Sendable () -> Bool = { true }
  public var setIsCompleted: @Sendable (Bool) -> Void = { _ in }
}

extension OnboardingClient: DependencyKey {
  public static let liveValue: OnboardingClient = {
    let store = AppSettingsStore()
    return OnboardingClient(
      fetchIsCompleted: { store.isOnboardingCompleted },
      setIsCompleted: { store.isOnboardingCompleted = $0 }
    )
  }()

  public static let previewValue = OnboardingClient()
}

extension DependencyValues {
  public var onboardingClient: OnboardingClient {
    get { self[OnboardingClient.self] }
    set { self[OnboardingClient.self] = newValue }
  }
}
