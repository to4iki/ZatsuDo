import Dependencies

extension AppSettingsClient: DependencyKey {
  public static let liveValue: AppSettingsClient = {
    let store = AppSettingsStore()
    return AppSettingsClient(
      fetchIsOnboardingCompleted: { store.isOnboardingCompleted },
      setIsOnboardingCompleted: { store.isOnboardingCompleted = $0 },
      fetchResetHour: { store.resetHour },
      setResetHour: { store.resetHour = $0 },
      fetchResetMinute: { store.resetMinute },
      setResetMinute: { store.resetMinute = $0 }
    )
  }()

  public static let previewValue = AppSettingsClient(
    fetchIsOnboardingCompleted: { true },
    setIsOnboardingCompleted: { _ in },
    fetchResetHour: { defaultResetHour },
    setResetHour: { _ in },
    fetchResetMinute: { defaultResetMinute },
    setResetMinute: { _ in }
  )
}

extension DependencyValues {
  public var appSettingsClient: AppSettingsClient {
    get { self[AppSettingsClient.self] }
    set { self[AppSettingsClient.self] = newValue }
  }
}
