import AppStorage
import Dependencies
import Foundation
import SettingFeature
import Testing

@MainActor
@Suite
struct SettingViewModelTests {
  @Test
  func updateResetTime_persistsToClient() {
    var savedHour: Int?
    var savedMinute: Int?

    withDependencies {
      $0.resetTimeClient.getHour = { ResetTimeClient.defaultHour }
      $0.resetTimeClient.getMinute = { ResetTimeClient.defaultMinute }
      $0.resetTimeClient.saveHour = { savedHour = $0 }
      $0.resetTimeClient.saveMinute = { savedMinute = $0 }
    } operation: {
      let viewModel = SettingViewModel()

      var components = DateComponents()
      components.hour = 7
      components.minute = 30
      let date = Calendar.current.date(from: components)!

      viewModel.updateResetTime(date)

      #expect(viewModel.uiState.resetHour == 7)
      #expect(viewModel.uiState.resetMinute == 30)
      #expect(savedHour == 7)
      #expect(savedMinute == 30)
    }
  }

  @Test
  func updateResetTime_skipsWhenValueUnchanged() {
    var saveHourCallCount = 0
    var saveMinuteCallCount = 0

    withDependencies {
      $0.resetTimeClient.getHour = { ResetTimeClient.defaultHour }
      $0.resetTimeClient.getMinute = { ResetTimeClient.defaultMinute }
      $0.resetTimeClient.saveHour = { _ in saveHourCallCount += 1 }
      $0.resetTimeClient.saveMinute = { _ in saveMinuteCallCount += 1 }
    } operation: {
      let viewModel = SettingViewModel()

      let initialHour = viewModel.uiState.resetHour
      let initialMinute = viewModel.uiState.resetMinute

      var components = DateComponents()
      components.hour = initialHour
      components.minute = initialMinute
      let sameDate = Calendar.current.date(from: components)!

      viewModel.updateResetTime(sameDate)

      #expect(viewModel.uiState.resetHour == initialHour)
      #expect(viewModel.uiState.resetMinute == initialMinute)
      #expect(saveHourCallCount == 0)
      #expect(saveMinuteCallCount == 0)
    }
  }
}
