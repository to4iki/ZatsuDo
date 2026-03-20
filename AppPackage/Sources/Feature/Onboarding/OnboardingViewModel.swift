import Foundation
import Observation

public struct OnboardingUiState: Sendable, Equatable {
  public var currentPage: Int = 0
  public let pageCount: Int = 2
  public var isLastPage: Bool { currentPage >= pageCount - 1 }
}

@Observable
@MainActor
public final class OnboardingViewModel {
  public private(set) var uiState: OnboardingUiState = .init()

  public init() {}

  public func advancePage() {
    if uiState.currentPage < uiState.pageCount - 1 {
      uiState.currentPage += 1
    }
  }

  public func selectPage(_ index: Int) {
    guard (0..<uiState.pageCount).contains(index) else { return }
    uiState.currentPage = index
  }
}
