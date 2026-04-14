---
paths:
  - "AppPackage/Tests/**/*.{swift}"
  - "AppPackage/Package.swift"
---

# テストルール

## フレームワーク

- **Swift Testing** (`import Testing`) を使用する
- XCTest は使用しない

## テストターゲットの配置

- テストターゲットは `AppPackage/Tests/Feature/<FeatureName>/` に配置する
- テストターゲット名は `<FeatureName>FeatureTests` とする
- `Package.swift` の `// -- Test --` セクションに `.testTarget` を追加する

```
AppPackage/Tests/Feature/App/AppViewModelTests.swift
AppPackage/Tests/Feature/Setting/SettingViewModelTests.swift
```

## テスト対象

- テストは ViewModel のロジックに対して書く
- View / Screen の UI テストはこのルールの対象外

## テストの書き方

### 構造

- `@MainActor @Suite struct <ClassName>Tests` で定義する
- ViewModel が `@MainActor` のため、テストも `@MainActor` で実行する

### 命名規則

- テスト関数名: `<action>_<expectedBehavior>` (英語、スネークケース区切り)
  - 例: `completeOnboarding_updatesUiStateAndStore`
  - 例: `selectPage_ignoresOutOfRangeIndex`

### アサーション

- `#expect` マクロを使用する
- `try #require` で前提条件の検証が必要な場合に使う

## 依存の差し替え

ViewModel のテストでは [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) の `withDependencies` を使用し、依存をテスト用の値に差し替える。

```swift
@MainActor
@Suite
struct ExampleViewModelTests {
  @Test
  func someAction_expectedBehavior() {
    withDependencies {
      $0.resetTimeClient.getHour = { 4 }
      $0.resetTimeClient.saveHour = { _ in }
    } operation: {
      let viewModel = ExampleViewModel()

      // ...
    }
  }
}
```

- `withDependencies` ブロック内で必要なエンドポイントのみオーバーライドする
- writer の呼び出しを検証したい場合はキャプチャ変数を使用する
- 依存を一切カスタマイズしない場合は `$0.resetTimeClient = .testValue` で一括設定できる

## テストケースの選定方針

テストは数より質を重視する。カバレッジは目的ではない。価値の低いテストは積極的に削除し、リファクタリング時に偽陽性を生む内部実装依存テストは避ける。

### 書くべきテスト

- **主要 Action の正常系**: `uiState` の最終状態が正しく更新されること
- **境界値・ガード条件**: 範囲外入力や同値スキップなど、振る舞いとして意味のある分岐
- **init からの状態復元**: 異なる入力で異なる出力が確認できる場合のみ。デフォルト → デフォルトのようなタウトロジカルなテストは不要

### 書くべきでないテスト

- **モック呼び出し検証**: `saveHour` の呼び出し回数など、内部実装に依存する検証は原則避ける（ただし「同値スキップで保存されないこと」のように、振る舞いそのものを表す場合は例外）
- **同一 Action の観点ごとの分割**: 1 つのテストで自然に検証できる複数の観点（追加・入力クリア・永続化など）は分割せず統合する
- **自明な setter のテスト**: `flag = true` を行うだけのメソッドなどはテストしない

### テスト統合の例

`addTask` の振る舞いは `tasks` 配列・`inputText` クリア・`uiState` 反映を 1 テストで検証する。永続化先への書き込み回数を別テストで検証する必要はない。
