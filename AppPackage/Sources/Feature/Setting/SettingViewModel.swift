import Foundation
import Observation

public struct SettingUiState: Sendable, Equatable {
  public var resetHour: Int
  public var resetMinute: Int

  public var resetDate: Date {
    var components = DateComponents()
    components.hour = resetHour
    components.minute = resetMinute
    return Calendar.current.date(from: components) ?? .now
  }
}

@Observable
@MainActor
public final class SettingViewModel {
  private static let resetHourKey = "resetHour"
  private static let resetMinuteKey = "resetMinute"

  public private(set) var uiState: SettingUiState

  public init() {
    let defaults = UserDefaults.standard
    let hour = defaults.object(forKey: Self.resetHourKey) as? Int ?? 4
    let minute = defaults.object(forKey: Self.resetMinuteKey) as? Int ?? 0
    self.uiState = SettingUiState(resetHour: hour, resetMinute: minute)
  }

  public func updateResetTime(_ date: Date) {
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    let hour = components.hour ?? 4
    let minute = components.minute ?? 0
    guard hour != uiState.resetHour || minute != uiState.resetMinute else { return }
    uiState.resetHour = hour
    uiState.resetMinute = minute
    UserDefaults.standard.set(hour, forKey: Self.resetHourKey)
    UserDefaults.standard.set(minute, forKey: Self.resetMinuteKey)
  }
}
