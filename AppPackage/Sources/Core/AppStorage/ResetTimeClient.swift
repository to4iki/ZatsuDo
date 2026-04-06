import Dependencies
import DependenciesMacros
import Logger

@DependencyClient
public struct ResetTimeClient: Sendable {
  public var readHour: @Sendable () -> Int = { defaultHour }
  public var writeHour: @Sendable (Int) -> Void = { _ in }
  public var readMinute: @Sendable () -> Int = { defaultMinute }
  public var writeMinute: @Sendable (Int) -> Void = { _ in }

  // MARK: - Defaults

  public static let defaultHour = 4
  public static let defaultMinute = 0
}

extension ResetTimeClient: DependencyKey {
  public static let liveValue: ResetTimeClient = {
    let store = AppSettingsStore()
    return ResetTimeClient(
      readHour: { store.resetHour },
      writeHour: {
        Log.default.info("ResetTimeClient: writeHour=\($0)")
        store.resetHour = $0
      },
      readMinute: { store.resetMinute },
      writeMinute: {
        Log.default.info("ResetTimeClient: writeMinute=\($0)")
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
