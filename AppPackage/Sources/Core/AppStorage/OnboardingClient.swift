import Dependencies
import DependenciesMacros
import Logger

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
      setIsCompleted: {
        Log.default.info("OnboardingClient: setIsCompleted=\($0)")
        store.isOnboardingCompleted = $0
      }
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
