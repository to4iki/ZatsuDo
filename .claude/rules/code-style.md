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

#### View の記述スタイル

- View のプロパティは `var` を基本とし、アクセス修飾子（`internal` など）は省略する
- コレクション要素として扱う構造体は原則 `Identifiable` に準拠させ、`ForEach` で `id:` を指定せずに済むようにする
- 色は `Color` 型を明示する（例: `Color.red`）。画像・文字列もリテラルで記述し、不要な間接化を避ける
- View の表示切替は `.opacity` や三項演算子で要素を差し替えるより、`if` / `else` で View 構造そのものを分岐させることを優先する（読み手の認識負荷が低い）
  - ただし、同一の View への単一プロパティ適用（`.disabled(...)` 等）は ViewModifier 内で条件式を書いてよい（identity が変わらず描画効率が良い）
- 独自 ViewModifier の乱用は避ける。標準APIで表現できる範囲は標準APIを使う（AI生成・レビューとの相性を確保する）
- `return` 文や式全体に複雑な三項演算子・メソッドチェーンを詰め込まず、一度ローカル変数に束縛してから返す（デバッグ容易性）
- 型推論コスト削減のため、初期値がある場合でも型を省略しない（例: `let count: Int = 0`）

#### アクセシビリティ

- 装飾的なアイコン（アクションを持たない `Image(systemName:)` など）には `.accessibilityHidden(true)` を付与する
- `.opacity(0)` で非表示にしたインタラクティブ要素には `.disabled()` と `.accessibilityHidden()` も併せて付与し、VoiceOverからのフォーカスとタップを防止する

## コメント

原則「コメントを書かない」ではなく、**なぜそう書いたか・どう流れるか**が非自明な箇所には積極的に残す。`private` 関数であっても対象にする。

- 処理の流れが複数段ある箇所には、番号付きコメント（`// 1. ...`, `// 2. ...`）で Overview を示す
- OS / SDK バージョン固有の不具合・ワークアラウンドは、対象バージョンを必ず明記する（例: `// iOS 17.0-17.2 で発生する ~ の回避`）
- 試行して採用しなかった実装も、理由と共に残しておくと再検討時の判断材料になる（循環参照回避のための仮説など）
- 仕様・ドメイン知識が背景にある場合は、コード上から読み取れないその背景を書く

ただしコメントは完璧を目指さない。実装と乖離したコメントは害になるため、更新が難しくなる詳細な What（コードを見れば分かる内容）は書かない。

## ログ出力

### ログレベルの使い分け

| レベル | 用途 | 例 |
|--------|------|----|
| `debug` | 開発時のトレース・詳細な状態変化 | アクション呼び出し、トグル操作 |
| `info`  | 通常動作として記録に残すイベント | 永続化データの書き込み、タスク追加 |
| `error` | 予期しない状態・ガード条件への到達 | 存在しない ID への操作 |
