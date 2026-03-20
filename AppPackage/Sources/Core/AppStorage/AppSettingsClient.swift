import Dependencies
import DependenciesMacros

@DependencyClient
public struct AppSettingsClient: Sendable {
  // MARK: - Onboarding

  public var fetchIsOnboardingCompleted: @Sendable () -> Bool = { false }
  public var setIsOnboardingCompleted: @Sendable (Bool) -> Void

  // MARK: - Reset Time

  public var fetchResetHour: @Sendable () -> Int = { defaultResetHour }
  public var setResetHour: @Sendable (Int) -> Void
  public var fetchResetMinute: @Sendable () -> Int = { defaultResetMinute }
  public var setResetMinute: @Sendable (Int) -> Void

  // MARK: - Defaults

  public static let defaultResetHour = 4
  public static let defaultResetMinute = 0
}
