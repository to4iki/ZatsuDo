import Dependencies
import DependenciesMacros
import Logger

@DependencyClient
public struct OnboardingClient: Sendable {
  public var readIsCompleted: @Sendable () -> Bool = { true }
  public var writeIsCompleted: @Sendable (Bool) -> Void = { _ in }
}

extension OnboardingClient: DependencyKey {
  public static let liveValue: OnboardingClient = {
    let store = AppSettingsStore()
    return OnboardingClient(
      readIsCompleted: { store.isOnboardingCompleted },
      writeIsCompleted: {
        Log.default.info("OnboardingClient: writeIsCompleted=\($0)")
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
