import AppStorage
import Dependencies
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
  @ObservationIgnored
  @Dependency(\.appSettingsClient) private var client

  public private(set) var uiState: SettingUiState

  public init() {
    self.uiState = SettingUiState(
      resetHour: client.fetchResetHour(),
      resetMinute: client.fetchResetMinute()
    )
  }

  public func updateResetTime(_ date: Date) {
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    let hour = components.hour ?? AppSettingsClient.defaultResetHour
    let minute = components.minute ?? AppSettingsClient.defaultResetMinute
    guard hour != uiState.resetHour || minute != uiState.resetMinute else { return }
    uiState.resetHour = hour
    uiState.resetMinute = minute
    client.setResetHour(hour)
    client.setResetMinute(minute)
  }
}
