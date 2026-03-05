# AppPackage 開発ガイド

アプリのメイン実装を行う SwiftPackage。

## ディレクトリ構造

- `Feature/App/` - 各フィーチャーを束ねるアプリのルート
- `Feature/Discover/` - ホワイトノイズ音楽再生、組み合わせ機能
- `Feature/Setting/` - 設定機能
- `FeatureCommon/` - 各フィーチャーで共通利用するコンポーネント定義
- `Core/AudioCore/` - 音声関連の基盤実装
- `Core/SharedModel/` - 共通利用するモデル定義
