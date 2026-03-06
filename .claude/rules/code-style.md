---
paths:
  - "App/**/*.{swift}"
  - "AppPackage/**/*.{swift}"
  - "AppLibrary/**/*.{swift}"
---

# コードスタイルルール

## Swift

- 名前空間には enum を利用する
- 値型（structとenum）のエンティティは、Sendable、Equatable に準拠する

## SwiftUI

#### 共通化・可読性の向上を狙い、積極的にサブビュー化する

- body関数が大きくなりすぎた場合、privateな Computed-property またはメソッドに分割する
- シンプルなViewはメソッドに切り出すこと。ただし、ロジックを含む独立したコンポーネントは、structで定義しプレビュー可能なViewとして切り出すこと

```swift
struct ContentView: View {
  var body: some View {
    VStack {
      header
      content(title: "Title")
      CustomButton()
    }
  }

  private var header: some View {
    Text("Menu")
  }

  private func content(title: String) -> some View {
    Text(title)
  }
}

private struct CustomButton: View {
  var body: some View {
    // complex implementation
  }
}
```

#### ViewModifier の中で分岐を実装する

identityが変わらず描画効率が良いので、条件分岐は ViewModifier の中に記述する。

```swift
ComplexView()
  .disabled(isEnabled ? false : true)
```

#### Viewを拡張したい場合は原則としてextensionを使用し、状態保持が必要な場合のみ ViewModifier を実装する

```swift
struct WrapViewInCircle: ViewModifier {
  let borderWidth: CGFloat
  func body(content: Content) -> some View {}
}
```

状態保持しない場合には、extensionで実装すること。

```swift
extension View {
  func wrapViewInCircle(borderWidth: CGFloat) -> some View {}
}
```
