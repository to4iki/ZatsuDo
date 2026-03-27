import Dependencies
import DependenciesMacros

@DependencyClient
public struct AppSettingsClient: Sendable {
  // MARK: - Onboarding

  public var fetchIsOnboardingCompleted: @Sendable () -> Bool
  public var setIsOnboardingCompleted: @Sendable (Bool) -> Void

  // MARK: - Reset Time

  public var fetchResetHour: @Sendable () -> Int
  public var setResetHour: @Sendable (Int) -> Void
  public var fetchResetMinute: @Sendable () -> Int
  public var setResetMinute: @Sendable (Int) -> Void

  // MARK: - Defaults

  public static let defaultResetHour = 4
  public static let defaultResetMinute = 0
}

extension AppSettingsClient: DependencyKey {
  public static let liveValue: AppSettingsClient = {
    let store = AppSettingsStore()
    return AppSettingsClient(
      fetchIsOnboardingCompleted: { store.isOnboardingCompleted },
      setIsOnboardingCompleted: { store.isOnboardingCompleted = $0 },
      fetchResetHour: { store.resetHour },
      setResetHour: { store.resetHour = $0 },
      fetchResetMinute: { store.resetMinute },
      setResetMinute: { store.resetMinute = $0 }
    )
  }()

  public static let previewValue = AppSettingsClient(
    fetchIsOnboardingCompleted: { true },
    setIsOnboardingCompleted: { _ in },
    fetchResetHour: { defaultResetHour },
    setResetHour: { _ in },
    fetchResetMinute: { defaultResetMinute },
    setResetMinute: { _ in }
  )
}

extension DependencyValues {
  public var appSettingsClient: AppSettingsClient {
    get { self[AppSettingsClient.self] }
    set { self[AppSettingsClient.self] = newValue }
  }
}
