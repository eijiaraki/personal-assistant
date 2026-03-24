# Personal Claude Assistant - プロジェクト仕様書

## MCP連携仕様

| MCP サーバー | 用途 | ランタイム |
|-------------|------|-----------|
| Google Workspace | Gmail、カレンダー、Drive、Docs等 | uv (Python) |
| Upnote | 個人メモ・ノート管理 | bun |

## ドキュメント体系

| ファイル | 役割 |
|---------|------|
| `CLAUDE.md` | 基幹ルール。常にコンテキストに読み込まれる |
| `docs/SPECIFICATION.md` | プロジェクト仕様（このファイル） |
| `docs/assistant-instructions.md` | ユーザー情報・行動指針・MCP使い分け |
| `README.md` | セットアップ手順・使い方 |

## Git管理ポリシー
- `workspace/` はタスク成果物格納先のため `.gitignore` で除外
- `client_secret_*.json` や `.mcp.json` は機密情報を含むため `.gitignore` で除外
