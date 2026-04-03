import SwiftUI

struct OnboardingView: View {
  private let uiState: OnboardingUiState
  @Binding var pageSelection: Int
  private let onAdvance: () -> Void
  private let onComplete: () -> Void

  init(
    uiState: OnboardingUiState,
    pageSelection: Binding<Int>,
    onAdvance: @escaping () -> Void,
    onComplete: @escaping () -> Void
  ) {
    self.uiState = uiState
    self._pageSelection = pageSelection
    self.onAdvance = onAdvance
    self.onComplete = onComplete
  }

  var body: some View {
    VStack {
      pageContent
      actionButton
    }
  }

  private var pageContent: some View {
    TabView(selection: $pageSelection) {
      page1.tag(0)
      page2.tag(1)
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
  }

  private var page1: some View {
    OnboardingPageView(
      iconName: "square.and.pencil",
      title: String(localized: "OnboardingPage1Title", bundle: .module),
      description: String(localized: "OnboardingPage1Body", bundle: .module)
    )
  }

  private var page2: some View {
    OnboardingPageView(
      iconName: "arrow.counterclockwise",
      title: String(localized: "OnboardingPage2Title", bundle: .module),
      description: String(localized: "OnboardingPage2Body", bundle: .module)
    )
  }

  private var actionButton: some View {
    Button(action: {
      if uiState.isLastPage {
        onComplete()
      } else {
        withAnimation {
          onAdvance()
        }
      }
    }) {
      Text(
        uiState.isLastPage
          ? String(localized: "GetStarted", bundle: .module)
          : String(localized: "Next", bundle: .module)
      )
      .font(.headline)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
    }
    .buttonStyle(.borderedProminent)
    .padding(.horizontal, 20)
    .padding(.bottom, 40)
  }
}

private struct OnboardingPageView: View {
  let iconName: String
  let title: String
  let description: String

  var body: some View {
    VStack(spacing: 16) {
      Spacer()
      Image(systemName: iconName)
        .font(.system(size: 64))
        .foregroundStyle(Color.accentColor)
        .accessibilityHidden(true)
      Text(title)
        .font(.title)
        .bold()
        .multilineTextAlignment(.center)
      Text(description)
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
      Spacer()
    }
  }
}

#Preview {
  OnboardingView(
    uiState: .init(),
    pageSelection: .constant(0),
    onAdvance: {},
    onComplete: {}
  )
}
