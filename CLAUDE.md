# CLAUDE.md - AI開発ガイド

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

## Moduler Rules

- `code-style.md` - コードスタイル
- `architecture.md` - アーキテクチャ
- `testing.md` - テスト

## Skills

- `/update-docs` - ドキュメント更新
