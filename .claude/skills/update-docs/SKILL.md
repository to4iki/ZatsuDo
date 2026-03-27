---
name: update-docs
description: CLAUDE.md、docs/ディレクトリを最新のコードに合わせて更新する。
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
---

# ドキュメント更新スキル

以下の手順で、CLAUDE.md、docs/ディレクトリのドキュメントを更新すること。

## 対象ファイル

### ルートドキュメント

- `README.md` - プロジェクト概要
- `CLAUDE.md` - AI開発ガイド（ルート）

### サブディレクトリの CLAUDE.md

- `AppPackage/CLAUDE.md` - AppPackage の開発ガイド
- `AppLibrary/CLAUDE.md` - AppLibrary の開発ガイド
- `docs/CLAUDE.md` - docs/ のナビゲーションガイド

### docs/ディレクトリ

- `docs/README.md` - ドキュメント目次
- `docs/setup.md` - セットアップ手順
- `docs/features.md` - 機能概要
- `docs/architecture.md` - アーキテクチャ概要

## 更新手順

1. **現状把握** - 現在のコードベース構造を確認
   - ディレクトリ構造（Glob でファイル一覧を取得）
   - 主要な機能・コンポーネント
   - 依存関係（`AppPackage/Package.swift`、`AppLibrary/Package.swift`）
   - 開発コマンド（`Makefile`）

2. **既存ドキュメント確認** - 対象ファイルをすべて読む
   - `README.md`、`CLAUDE.md`（ルートおよびサブディレクトリ）
   - `docs/` 配下のすべてのファイル

3. **差分分析** - コードと既存ドキュメントの差分を特定
   - `git log --oneline -20` で直近の変更履歴を確認
   - `git diff HEAD~5..HEAD -- '*.swift' '*.md' 'Package.swift'` で具体的な変更内容を把握
   - 新規追加・削除された機能、モジュール、コマンドを洗い出す

4. **更新内容の提案** - 変更が必要な箇所を一覧で提示し、ユーザーの承認を得る

5. **ドキュメント更新** - 承認後、ファイルを更新

## 更新のガイドライン

### README.md

- プロジェクトの目的と機能を簡潔に説明
- 開発環境のセットアップ手順を最新に保つ
- 利用可能なコマンド一覧を正確に記載

### CLAUDE.md（ルート）

- アーキテクチャの概要を維持
- 重要な規約・パターンを文書化
- 開発コマンドを最新に保つ
- 各サブディレクトリの CLAUDE.md との整合性を確認

### サブディレクトリの CLAUDE.md

- **`AppPackage/CLAUDE.md`**: AppPackage 内のモジュール構成・規約・テスト方針を最新に保つ
- **`AppLibrary/CLAUDE.md`**: AppLibrary 内のライブラリ構成・API概要を最新に保つ
- **`docs/CLAUDE.md`**: docs/ 配下のドキュメント構成とナビゲーションを最新に保つ

### docs/ディレクトリ

#### docs/README.md（目次）

- 新規ドキュメント追加時にリンクを追加
- ドキュメント削除時にリンクを削除
- カテゴリ構成の見直し

#### docs/features.md（機能概要）

- 新機能追加時に概要を追記
- 機能削除時に該当箇所を削除
- 機能の優先度や重要度の変更を反映

#### docs/setup.md（セットアップ手順）

- 新規の依存関係や環境変数の追加を反映
- セットアップ手順の変更を反映

#### docs/architecture.md（アーキテクチャ概要）

- 新規のモジュールやコンポーネントの追加を反映
- 既存のモジュールの変更を反映
- アーキテクチャの全体像を最新に保つ

## ユーザー指定の更新内容

$ARGUMENTS
