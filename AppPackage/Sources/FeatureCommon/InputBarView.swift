import Logger
import SwiftUI

public struct InputBarView: View {
  private let placeholder: String
  private let text: Binding<String>
  private let onSubmit: () -> Void

  public init(
    placeholder: String,
    text: Binding<String>,
    onSubmit: @escaping () -> Void
  ) {
    self.placeholder = placeholder
    self.text = text
    self.onSubmit = onSubmit
  }

  public var body: some View {
    HStack(spacing: 12) {
      Image(systemName: "mic")
        .font(.system(size: 20))
        .foregroundStyle(DesignSystem.Color.actionInactive)
        .accessibilityHidden(true)

      TextField(placeholder, text: text)
        .submitLabel(.send)
        .onSubmit {
          Log.default.debug("InputBarView: submitted via keyboard")
          onSubmit()
        }

      Button(action: {
        Log.default.debug("InputBarView: submitted via button")
        onSubmit()
      }) {
        Image(systemName: "arrow.up.circle.fill")
          .font(.system(size: 28))
          .foregroundStyle(
            text.wrappedValue.isEmpty
              ? DesignSystem.Color.actionInactive : DesignSystem.Color.actionActive)
      }
      .disabled(text.wrappedValue.isEmpty)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(.ultraThinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .padding(.horizontal, 16)
    .padding(.bottom, 8)
  }
}

#Preview {
  InputBarView(
    placeholder: "タスクを追加",
    text: .constant(""),
    onSubmit: {}
  )
}
