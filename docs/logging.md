# ログ出力ガイド

## ログレベルの使い分け

| レベル | 用途 | 例 |
|--------|------|----|
| `debug` | 開発時のトレース・詳細な状態変化 | アクション呼び出し、トグル操作 |
| `info`  | 通常動作として記録に残すイベント | 永続化データの書き込み、タスク追加 |
| `error` | 予期しない状態・ガード条件への到達 | 存在しない ID への操作 |

## ログカテゴリ

現在は `default` カテゴリのみを使用する。

```swift
Log.default.info("...")
```

将来ネットワーク通信を扱う場合は、`AppLibrary` の `LogCategory` に新カテゴリを追加する。

```swift
// 追加例
public enum LogCategory: String {
  case `default`
  case network
}
```

## ログを置く場所

### ✅ ViewModel（Feature層）

アクションメソッドの内部でログを出力する。
`FeatureCommon` が `@_exported import Logger` で Logger を再エクスポートしているため、`import FeatureCommon` のみで `Log.default` が利用できる。

```swift
public func addTask() {
  // ...
  Log.default.info("addTask: name=\(name, privacy: .private)")
}
```

### ✅ Core層（AppStorage）

クライアントの **書き込み操作** でログを出力する。読み取りはログ不要。
AppStorage ターゲットには Logger を直接依存として追加する。

```swift
setIsCompleted: {
  Log.default.info("OnboardingClient: setIsCompleted=\($0)")
  store.isOnboardingCompleted = $0
}
```

### ❌ View / Screen

プレゼンテーション層の責務外のためログを置かない。

## プライバシー

ユーザーが入力したテキスト（タスク名など）は `privacy: .private` を付与し、ログ収集時に自動的に伏せる。ID・フラグ・数値はそのまま出力してよい。

```swift
// NG: タスク名がそのまま出力される
Log.default.info("addTask: name=\(name)")

// OK
Log.default.info("addTask: name=\(name, privacy: .private)")
Log.default.debug("toggleTask: id=\(id.rawValue), isDone=\(isDone)")
```
