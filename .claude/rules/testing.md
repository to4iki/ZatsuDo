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

## UserDefaults の分離

`AppSettingsStore` を利用するテストでは、テスト間の干渉を防ぐため専用の `UserDefaults` を使用する。

```swift
@MainActor
@Suite
struct ExampleViewModelTests {
  private let suiteName = "ExampleViewModelTests"

  init() {
    UserDefaults.standard.removePersistentDomain(forName: suiteName)
  }

  @Test
  func someAction_expectedBehavior() {
    let defaults = UserDefaults(suiteName: suiteName)!
    let store = AppSettingsStore(defaults: defaults)
    let viewModel = ExampleViewModel(store: store)

    // ...
  }
}
```

## テストケースの粒度

各 ViewModel に対して、最低限以下を網羅する:

- **主要 Action の正常系**: 状態が正しく更新されること
- **境界値・ガード条件**: 範囲外入力や同値スキップの検証
- **init からの状態復元**: Store からの初期値読み込みが正しいこと（永続化を行う ViewModel の場合）
