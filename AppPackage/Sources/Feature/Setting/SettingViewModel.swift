import AppStorage
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
  private let store: AppSettingsStore

  public private(set) var uiState: SettingUiState

  public init(store: AppSettingsStore = .shared) {
    self.store = store
    self.uiState = SettingUiState(resetHour: store.resetHour, resetMinute: store.resetMinute)
  }

  public func updateResetTime(_ date: Date) {
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    let hour = components.hour ?? 4
    let minute = components.minute ?? 0
    guard hour != uiState.resetHour || minute != uiState.resetMinute else { return }
    uiState.resetHour = hour
    uiState.resetMinute = minute
    store.resetHour = hour
    store.resetMinute = minute
  }
}
