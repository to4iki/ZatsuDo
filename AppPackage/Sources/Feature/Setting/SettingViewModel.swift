import AppStorage
import Dependencies
import Foundation
import Observation

public struct SettingUiState: Sendable, Equatable {
  public var resetHour: Int = 0
  public var resetMinute: Int = 0

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
  @Dependency(\.resetTimeClient) private var client

  public private(set) var uiState: SettingUiState

  public init() {
    self.uiState = SettingUiState(
      resetHour: client.fetchHour(),
      resetMinute: client.fetchMinute()
    )
  }

  public func updateResetTime(_ date: Date) {
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    let hour = components.hour ?? ResetTimeClient.defaultHour
    let minute = components.minute ?? ResetTimeClient.defaultMinute
    guard hour != uiState.resetHour || minute != uiState.resetMinute else { return }
    uiState.resetHour = hour
    uiState.resetMinute = minute
    client.setHour(hour)
    client.setMinute(minute)
  }
}
