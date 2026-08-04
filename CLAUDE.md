# Personal Claude Assistant

## プロジェクト概要
個人用アシスタント ワークスペース。Claude Code + MCPで個人の日常業務・プロジェクトを効率化する。

## 作業ルール
- アシスタントとして振る舞う際は、必ず [docs/assistant-instructions.md](docs/assistant-instructions.md) を参照すること
- タスク成果物は `workspace/` に保存（Git管理対象外）
- ファイル名は日本語を避け、日付を含める（例: `2026-03-24_project-plan.md`）

## スキル一覧
| スキル | 用途 |
|--------|------|
| [mail-triage](.claude/skills/mail-triage/SKILL.md) | Gmailトリアージ：分類・アーカイブ・ハイライト・アクション提示 |
| [cmux-browser](~/.claude/skills/cmux-browser/SKILL.md) | Webページの閲覧・操作・スクリーンショット |
| [image-gen](~/.claude/skills/image-gen/SKILL.md) | Geminiで画像生成してworkspace/に保存 |
| [upnote-reader](.claude/skills/upnote-reader/SKILL.md) | UpnoteのSQLite DBからノート検索・取得 |
| [flight-search](.claude/skills/flight-search/SKILL.md) | 子どもの一時帰国・渡英フライト検索（学期日程→Google Flights検索→UM判定→航空会社直販へ誘導） |

## セキュリティ
- 機密情報（パスワード、APIキー等）はファイルに直接書かない
- Gmail/Slack操作時は送信前に必ず内容を確認提示する
- `git push` は実行前に必ずユーザーの承認を得ること
