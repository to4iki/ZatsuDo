import AppStorage
import Foundation
import SettingFeature
import Testing

@MainActor
@Suite
struct SettingViewModelTests {
  private let suiteName = "SettingViewModelTests"

  init() {
    UserDefaults.standard.removePersistentDomain(forName: suiteName)
  }

  @Test
  func updateResetTime_persistsToStore() {
    let defaults = UserDefaults(suiteName: suiteName)!
    let store = AppSettingsStore(defaults: defaults)
    let viewModel = SettingViewModel(store: store)

    var components = DateComponents()
    components.hour = 7
    components.minute = 30
    let date = Calendar.current.date(from: components)!

    viewModel.updateResetTime(date)

    #expect(viewModel.uiState.resetHour == 7)
    #expect(viewModel.uiState.resetMinute == 30)
    #expect(store.resetHour == 7)
    #expect(store.resetMinute == 30)
  }

  @Test
  func updateResetTime_skipsWhenValueUnchanged() {
    let defaults = UserDefaults(suiteName: suiteName)!
    let store = AppSettingsStore(defaults: defaults)
    let viewModel = SettingViewModel(store: store)

    let initialHour = viewModel.uiState.resetHour
    let initialMinute = viewModel.uiState.resetMinute

    var components = DateComponents()
    components.hour = initialHour
    components.minute = initialMinute
    let sameDate = Calendar.current.date(from: components)!

    viewModel.updateResetTime(sameDate)

    #expect(viewModel.uiState.resetHour == initialHour)
    #expect(viewModel.uiState.resetMinute == initialMinute)
  }

  @Test
  func init_loadsDefaultValues() {
    let defaults = UserDefaults(suiteName: suiteName)!
    let store = AppSettingsStore(defaults: defaults)
    let viewModel = SettingViewModel(store: store)

    #expect(viewModel.uiState.resetHour == AppSettingsStore.defaultResetHour)
    #expect(viewModel.uiState.resetMinute == AppSettingsStore.defaultResetMinute)
  }
}
