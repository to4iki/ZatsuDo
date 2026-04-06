import Foundation

/// Thread-safety note: All properties delegate to `UserDefaults`, which is
/// thread-safe. The only stored property (`defaults`) is `let`, so there is
/// no mutable shared state in this class.
final class AppSettingsStore: @unchecked Sendable {
  private let defaults: UserDefaults

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  // MARK: - Onboarding

  var isOnboardingCompleted: Bool {
    get { defaults.bool(forKey: Keys.isOnboardingCompleted) }
    set { defaults.set(newValue, forKey: Keys.isOnboardingCompleted) }
  }

  // MARK: - Reset Time

  var resetHour: Int {
    get { defaults.object(forKey: Keys.resetHour) as? Int ?? ResetTimeClient.defaultHour }
    set { defaults.set(newValue, forKey: Keys.resetHour) }
  }

  var resetMinute: Int {
    get {
      defaults.object(forKey: Keys.resetMinute) as? Int ?? ResetTimeClient.defaultMinute
    }
    set { defaults.set(newValue, forKey: Keys.resetMinute) }
  }

  // MARK: - Tasks

  var tasksData: Data? {
    get { defaults.data(forKey: Keys.tasksData) }
    set { defaults.set(newValue, forKey: Keys.tasksData) }
  }
}

extension AppSettingsStore {
  private enum Keys {
    static let isOnboardingCompleted = "isOnboardingCompleted"
    static let resetHour = "resetHour"
    static let resetMinute = "resetMinute"
    static let tasksData = "tasksData"
  }
}
