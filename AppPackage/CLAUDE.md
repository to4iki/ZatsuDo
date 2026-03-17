# AppPackage - 開発ガイド

アプリのメイン実装を行う SwiftPackage。

## ディレクトリ構造

- `Feature/App/` - 各フィーチャーを束ねるアプリのルート
- `Feature/Task/` - タスクに関する機能
- `Feature/Setting/` - 設定機能
- `Feature/Onboarding/` - オンボーディング機能
- `FeatureCommon/` - 各フィーチャーで共通利用するUIコンポーネント定義
- `Core/AppStorage/` - UserDefaults を抽象化したアプリ設定の永続化
- `Core/SharedModel/` - 共通利用するモデル定義
