---
paths:
  - "AppPackage/**/*.{swift}"
---

# アーキテクチャルール

## モジュール戦略

- featureを跨いで利用するコードに関して、Uiコンポーネントは FeatureCommon モジュールに配置する

### 依存関係

```
feature → core
feature → featureCommon
```

- coreはfeatureに依存しない
- feature同士の依存は禁止

## 依存注入 (DI)

- [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) を使用する
- Core層のクライアントは `@DependencyClient` マクロで定義する
- ViewModel では `@Dependency` プロパティラッパーで依存を取得する
- Preview では `withDependencies` で `previewValue` を注入する

## ビューの状態管理

### Single Source of Truth

- 状態の出どころは常に1つに保つ。ViewModel と View の双方に同じ状態を持たせない
- `@FocusState` / `@State` のように View 固有でしか意味を持たない状態（フォーカス、スクロール位置、アニメーション駆動フラグなど）は ViewModel に引き上げない。View 側に残す
- ViewModel から View 側の状態変化をトリガーしたい場合は、`PassthroughSubject` やイベント通知型の値を経由して View が自律的に更新する形を優先する
- `@EnvironmentObject` は使用しない。横断的な値の受け渡しは `@Environment` のカスタムキー（例: `dismissSheet`, `formStyle`）で最小範囲に限定する

### Screen / ViewModel / View の責務

- `Screen` と `ViewModel` (UiState & Action) は 1:1 で対応させる
- `View` は直接 `ViewModel` を参照しない
  - `Screen` を介して init 経由で UiState をバインドすること - 宣言的UIの原則
  - 状態を更新したい場合には、 `Screen` にイベントを通知し、 `Screen` が Action を呼び出すこと
- 責務分割は厳格さより読みやすさを優先する。View 側で完結する軽微な整形や、ViewModel 側の簡単な同期処理までを無理に分離しない

```
screen → view
screen → viewModel (UiState & Action)
```

### ViewModelパターン

- `Action` - システムに対する要求を示す
  - 名詞はじまりのライフサイクル(viewDidLoad)やタップイベント(didTapXxxButton)ではなく動詞始まりとする
- `UiState` - ビューの状態を表す
  - 画面の状態を表すプロパティを定義する。画面を構成する要素そのもの
  - API レスポンスやドメインモデルをそのまま持たせず、View 専用の構造体として再定義する。`Identifiable` に準拠させ、`ForEach` の `id:` 指定を不要にする
- `View` - ステートレスなビュー
  - `Screen` から呼び出されるステートレスなビュー
  - 表示要素の生成(加工・フィルタ・フォーマット済みString化)はViewで行わずに、`UiState.init` 内で行うこと
  - Preview 容易性のため、ViewModel を保持しない `XxxScreenContent` を切り出してよい

## ライブラリ選定

- 依存は最小限に保つ。SwiftUI 補助ライブラリ（Navigation 系、Algorithms 系など）は標準APIで明確に不足を感じた時点で初めて採用を検討する
- Alert や直前のコンテキストに強く依存するUI表現のように、SwiftUI の宣言的記述で不自然になる箇所は UIKit ベース（Builder パターン等）での実装も選択肢に入れる

## 詳細

[docs/architecture.md](../../docs/architecture.md)
