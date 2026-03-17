import Foundation

public final class AppSettingsStore: @unchecked Sendable {
  private let defaults: UserDefaults

  public static let shared = AppSettingsStore()

  public init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  // MARK: - Onboarding

  public var isOnboardingCompleted: Bool {
    get { defaults.bool(forKey: Keys.isOnboardingCompleted) }
    set { defaults.set(newValue, forKey: Keys.isOnboardingCompleted) }
  }

  // MARK: - Reset Time

  public var resetHour: Int {
    get { defaults.object(forKey: Keys.resetHour) as? Int ?? Defaults.resetHour }
    set { defaults.set(newValue, forKey: Keys.resetHour) }
  }

  public var resetMinute: Int {
    get { defaults.object(forKey: Keys.resetMinute) as? Int ?? Defaults.resetMinute }
    set { defaults.set(newValue, forKey: Keys.resetMinute) }
  }
}

extension AppSettingsStore {
  private enum Keys {
    static let isOnboardingCompleted = "isOnboardingCompleted"
    static let resetHour = "resetHour"
    static let resetMinute = "resetMinute"
  }

  private enum Defaults {
    static let resetHour = 4
    static let resetMinute = 0
  }
}
