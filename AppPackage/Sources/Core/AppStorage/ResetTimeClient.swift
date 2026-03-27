import Dependencies
import DependenciesMacros

@DependencyClient
public struct ResetTimeClient: Sendable {
  public var fetchHour: @Sendable () -> Int = { defaultHour }
  public var setHour: @Sendable (Int) -> Void = { _ in }
  public var fetchMinute: @Sendable () -> Int = { defaultMinute }
  public var setMinute: @Sendable (Int) -> Void = { _ in }

  // MARK: - Defaults

  public static let defaultHour = 4
  public static let defaultMinute = 0
}

extension ResetTimeClient: DependencyKey {
  public static let liveValue: ResetTimeClient = {
    let store = AppSettingsStore()
    return ResetTimeClient(
      fetchHour: { store.resetHour },
      setHour: { store.resetHour = $0 },
      fetchMinute: { store.resetMinute },
      setMinute: { store.resetMinute = $0 }
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
