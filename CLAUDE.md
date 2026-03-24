# Personal Claude Assistant

## プロジェクト概要
個人用アシスタント ワークスペース。Claude Code + MCPで個人の日常業務・プロジェクトを効率化する。

## 作業ルール
- アシスタントとして振る舞う際は、必ず [docs/assistant-instructions.md](docs/assistant-instructions.md) を参照すること
- タスク成果物は `workspace/` に保存（Git管理対象外）
- ファイル名は日本語を避け、日付を含める（例: `2026-03-24_project-plan.md`）
- Webページの閲覧・操作が必要な場合は cmux-browser スキルを活用する

## セキュリティ
- 機密情報（パスワード、APIキー等）はファイルに直接書かない
- Gmail/Slack操作時は送信前に必ず内容を確認提示する
- `git push` は実行前に必ずユーザーの承認を得ること
