# AI開発ガイド

雑にToDoを管理するアプリ。
UI実装には SwiftUI を利用する。

## 開発環境

- プロジェクトの開発環境の構築には、mise を使う
- Git worktree を利用する際は、作成したディレクトリで、`mise trust` を実行すること

## ディレクトリ構造

- `App/` - メインターゲットでアプリのエントリポイント、本実装は AppPackage で行う
- `AppPackage/` - アプリのメイン実装を行うSwiftPackage
- `AppLibrary/` - ドメインに依存しない3rdパーティ相当のライブラリ実装を行うSwiftPackage

## 開発コマンド

- `make swiftformat` - フォーマット

## ビルド・テスト検証

コード変更後のビルド確認には Xcode MCP を使用する。`xcodebuild` コマンドは利用しないこと。

1. `mcp__xcode__XcodeListWindows` で対象の `tabIdentifier` を取得する
2. `mcp__xcode__BuildProject` でビルドを実行する
3. テスト実行には `mcp__xcode__RunAllTests` または `mcp__xcode__RunSomeTests` を使用する

## Moduler Rules

- `code-style.md` - コードスタイル
- `architecture.md` - アーキテクチャ
- `testing.md` - テスト

## Skills

- `/update-docs` - ドキュメント更新
