# Personal Claude Assistant

個人用アシスタント ワークスペース。Claude Code + MCP連携により、日常業務・個人プロジェクト（スケジュール管理、メール、リサーチ、文書作成等）を効率化する。

## セットアップ

### 前提条件
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) がインストール済み
- Node.js (npx が使えること)
- Python 3 + [uv](https://docs.astral.sh/uv/)
- [Bun](https://bun.sh/)

### 1. セットアップ実行
```bash
./scripts/setup.sh
```

セットアップスクリプトが以下を自動実行する:
- 依存ツールの存在確認
- `.mcp.json` の対話的生成（Google Workspace トークン入力）
- Google OAuth クライアントシークレットの確認

### 2. 事前準備（トークン類）

| 項目 | 取得方法 |
|------|----------|
| **Google OAuth クライアントシークレット** | [Google Cloud Console](https://console.cloud.google.com/apis/credentials) で OAuth クライアント ID 作成 → `client_secret_*.json` をプロジェクトルートに配置 |

### 3. 動作確認
```bash
claude
```
- 「今日の予定を教えて」 → Google Calendar
- 「未読メールを確認して」 → Gmail

## 使い方例

### スケジュール管理
```
今日の予定を教えて
今週の空き時間を教えて
```

### メール対応
```
未読メールを確認して
○○からのメールに返信の下書きを作って
```

### リサーチ・資料作成
```
○○について調べて workspace/ にまとめて
以下の内容でブログ記事の下書きを作って
```

## ディレクトリ構成
```
personal-assistant/
├── CLAUDE.md          # プロジェクト指示（基幹ルール）
├── README.md
├── .mcp.json          # MCP設定（Git管理対象外）
├── docs/              # ドキュメント
├── templates/         # テンプレート集
├── drafts/            # 作成中の下書き
└── workspace/         # タスク成果物（Git管理対象外）
```
