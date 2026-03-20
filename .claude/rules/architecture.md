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

- `Screen` と `ViewModel` (UiState & Action) は 1:1 で対応させる
- `View` は直接 `ViewModel` を参照しない
  - `Screen` を介して init 経由で UiState をバインドすること - 宣言的UIの原則
  - 状態を更新したい場合には、 `Screen` にイベントを通知し、 `Screen` が Action を呼び出すこと

```
screen → view
screen → viewModel (UiState & Action)
```

### ViewModelパターン

- `Action` - システムに対する要求を示す
  - 名詞はじまりのライフサイクル(viewDidLoad)やタップイベント(didTapXxxButton)ではなく動詞始まりとする
- `UiState` - ビューの状態を表す
  - 画面の状態を表すプロパティを定義する。画面を構成する要素そのもの
- `View` - ステートレスなビュー
  - `Screen` から呼び出されるステートレスなビュー
  - 表示要素の生成(加工・フィルタ)はViewで行わずに、`UiState.init` 内で行うこと

## 詳細

[docs/architecture.md](../../docs/architecture.md)
