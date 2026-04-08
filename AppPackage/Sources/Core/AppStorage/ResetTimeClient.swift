import Dependencies
import DependenciesMacros
import Logger

@DependencyClient
public struct ResetTimeClient: Sendable {
  public var getHour: @Sendable () -> Int = { defaultHour }
  public var saveHour: @Sendable (Int) -> Void = { _ in }
  public var getMinute: @Sendable () -> Int = { defaultMinute }
  public var saveMinute: @Sendable (Int) -> Void = { _ in }

  // MARK: - Defaults

  public static let defaultHour = 4
  public static let defaultMinute = 0
}

extension ResetTimeClient: DependencyKey {
  public static let liveValue: ResetTimeClient = {
    let store = AppSettingsStore()
    return ResetTimeClient(
      getHour: { store.resetHour },
      saveHour: {
        Log.default.info("ResetTimeClient: saveHour=\($0)")
        store.resetHour = $0
      },
      getMinute: { store.resetMinute },
      saveMinute: {
        Log.default.info("ResetTimeClient: saveMinute=\($0)")
        store.resetMinute = $0
      }
    )
  }()

  public static let previewValue = ResetTimeClient()
}

extension DependencyValues {
  public var resetTimeClient: ResetTimeClient {
    get { self[ResetTimeClient.self] }
    set { self[ResetTimeClient.self] = newValue }
  }
}
