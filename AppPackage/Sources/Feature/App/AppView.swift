import OnboardingFeature
import SettingFeature
import SwiftUI
import TaskFeature

public struct AppView: View {
  @State private var appViewModel = AppViewModel()
  @State private var taskListViewModel = TaskListViewModel()
  @State private var onboardingViewModel = OnboardingViewModel()
  @State private var settingViewModel = SettingViewModel()

  public init() {}

  public var body: some View {
    @Bindable var appViewModel = appViewModel

    if appViewModel.uiState.isOnboardingCompleted {
      TaskListScreen(
        viewModel: taskListViewModel,
        onPresentSetting: { appViewModel.presentSetting() }
      )
      .sheet(isPresented: $appViewModel.isSettingPresented) {
        SettingScreen(viewModel: settingViewModel)
      }
      .transition(.opacity)
    } else {
      OnboardingScreen(
        viewModel: onboardingViewModel,
        onComplete: {
          withAnimation {
            appViewModel.completeOnboarding()
          }
        }
      )
      .transition(.opacity)
    }
  }
}

#Preview {
  AppView()
}
