import Dependencies
import DependenciesMacros
import Logger

@DependencyClient
public struct OnboardingClient: Sendable {
  public var getIsCompleted: @Sendable () -> Bool = { true }
  public var saveIsCompleted: @Sendable (Bool) -> Void = { _ in }
}

extension OnboardingClient: DependencyKey {
  public static let liveValue: OnboardingClient = {
    let store = AppSettingsStore()
    return OnboardingClient(
      getIsCompleted: { store.isOnboardingCompleted },
      saveIsCompleted: {
        Log.default.info("OnboardingClient: saveIsCompleted=\($0)")
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
