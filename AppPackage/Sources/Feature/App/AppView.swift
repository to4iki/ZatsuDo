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
    if appViewModel.uiState.isOnboardingCompleted {
      TaskListScreen(
        viewModel: taskListViewModel,
        onPresentSetting: { appViewModel.presentSetting() }
      )
      .sheet(
        isPresented: Binding(
          get: { appViewModel.uiState.isSettingPresented },
          set: { if !$0 { appViewModel.dismissSetting() } }
        )
      ) {
        SettingScreen(viewModel: settingViewModel)
      }
    } else {
      OnboardingScreen(
        viewModel: onboardingViewModel,
        onComplete: {
          withAnimation {
            appViewModel.completeOnboarding()
          }
        }
      )
    }
  }
}

#Preview {
  AppView()
}
