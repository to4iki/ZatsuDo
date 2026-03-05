import SwiftUI

public struct SettingScreen: View {
  public init() {}

  public var body: some View {
    NavigationStack {
      SettingView()
        .navigationTitle(String(localized: "Setting", bundle: .module))
    }
  }
}

#Preview {
  SettingScreen()
}
