import OnboardingFeature
import Testing

@MainActor
@Suite
struct OnboardingViewModelTests {
  @Test
  func advancePage_stopsAtLastPage() {
    let viewModel = OnboardingViewModel()

    #expect(viewModel.uiState.currentPage == 0)

    viewModel.advancePage()
    #expect(viewModel.uiState.currentPage == 1)

    viewModel.advancePage()
    #expect(viewModel.uiState.currentPage == 1)
  }

  @Test
  func selectPage_ignoresOutOfRangeIndex() {
    let viewModel = OnboardingViewModel()

    viewModel.selectPage(-1)
    #expect(viewModel.uiState.currentPage == 0)

    viewModel.selectPage(2)
    #expect(viewModel.uiState.currentPage == 0)

    viewModel.selectPage(1)
    #expect(viewModel.uiState.currentPage == 1)
  }
}
