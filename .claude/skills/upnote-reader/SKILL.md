---
name: upnote-reader
description: UpnoteのローカルSQLite DBを読み取り、ノートの一覧表示・本文取得・全文検索を行う。
argument-hint: "[ノートブック名 or 検索キーワード]"
---

# Upnote Reader

UpnoteのローカルSQLite DBを直接クエリしてノートを読み取るスキル。**読み取り専用**で使用すること。

## DB情報

- **パス**: `~/Library/Containers/com.getupnote.desktop/Data/Library/Application Support/UpNote/upnote.sqlite3`
- **必須オプション**: `-readonly` を必ず付けること

```bash
DB="$HOME/Library/Containers/com.getupnote.desktop/Data/Library/Application Support/UpNote/upnote.sqlite3"
sqlite3 -readonly "$DB" "<SQL>"
```

## テーブルスキーマ

### notes
| カラム | 型 | 説明 |
|--------|------|------|
| id | TEXT PK | ノートID |
| title | TEXT | タイトル |
| text | TEXT | プレーンテキスト本文 |
| html | TEXT | HTML本文 |
| summary | TEXT | 要約 |
| createdAt | DOUBLE | 作成日時（Unix timestamp） |
| updatedAt | DOUBLE | 更新日時（Unix timestamp） |
| trashed | INTEGER | ゴミ箱フラグ (0/1) |
| deleted | INTEGER | 削除フラグ (0/1) |
| bookmarked | INTEGER | ブックマークフラグ |
| pinned | INTEGER | ピン留めフラグ |
| hasTodo | INTEGER | TODO含有フラグ |
| tagLinks | TEXT | タグリンク（JSON） |

### notebooks
| カラム | 型 | 説明 |
|--------|------|------|
| id | TEXT PK | ノートブックID |
| title | TEXT | ノートブック名 |
| notes | TEXT | ノートIDリスト（JSON） |
| parent | TEXT | 親ノートブックID |
| childNotebooks | TEXT | 子ノートブックIDリスト |
| deleted | INTEGER | 削除フラグ |

### organizers（notes ↔ notebooks の中間テーブル）
| カラム | 型 | 説明 |
|--------|------|------|
| id | TEXT PK | オーガナイザーID |
| noteId | TEXT | ノートID → notes.id |
| notebookId | TEXT | ノートブックID → notebooks.id |
| deleted | INTEGER | 削除フラグ |

### tags
| カラム | 型 | 説明 |
|--------|------|------|
| id | TEXT PK | タグID |
| title | TEXT | タグ名 |
| notes | TEXT | ノートIDリスト（JSON） |
| deleted | INTEGER | 削除フラグ |

## ノートブック一覧

| 名前 | ID |
|------|------|
| Accounts | 5c876eaf-7ea2-4e76-aa45-c5cc58c7f492 |
| Daily log | ede5c7d2-4d0b-4a4f-9d7a-3c7d7c4c2a70 |
| GREE | 0a330879-239d-4aa1-b5aa-0cbe098c54c7 |
| Recipe | b3325367-0a99-4177-80f0-3218dfa45dec |
| etc | e5f27a40-71e9-4ee3-ac06-6bbf4408b74e |
| log | ed2eb906-2f62-4e0a-862b-5ef5bf9be5cd |

## クエリパターン

### ノートブック内のノート一覧（更新日時降順）
```sql
SELECT n.title, datetime(n.updatedAt / 1000, 'unixepoch', 'localtime') as updated
FROM notes n
JOIN organizers o ON o.noteId = n.id AND o.deleted = 0
WHERE o.notebookId = '<NOTEBOOK_ID>'
  AND n.trashed = 0 AND n.deleted = 0
ORDER BY n.updatedAt DESC
LIMIT 20;
```

### ノートの本文取得（タイトル指定）
```sql
SELECT n.text
FROM notes n
WHERE n.title = '<TITLE>'
  AND n.trashed = 0 AND n.deleted = 0;
```

### 全文検索
```sql
SELECT n.title, datetime(n.updatedAt / 1000, 'unixepoch', 'localtime') as updated
FROM notes n
WHERE n.text LIKE '%<KEYWORD>%'
  AND n.trashed = 0 AND n.deleted = 0
ORDER BY n.updatedAt DESC
LIMIT 20;
```

### 最近更新されたノート
```sql
SELECT n.title, nb.title as notebook, datetime(n.updatedAt / 1000, 'unixepoch', 'localtime') as updated
FROM notes n
JOIN organizers o ON o.noteId = n.id AND o.deleted = 0
JOIN notebooks nb ON nb.id = o.notebookId
WHERE n.trashed = 0 AND n.deleted = 0
ORDER BY n.updatedAt DESC
LIMIT 20;
```

## 実行手順

1. **引数を解釈する**: `$ARGUMENTS` がノートブック名（Accounts, Daily log, GREE, Recipe, etc, log）に一致すればそのノートブック内のノート一覧を表示。それ以外は全文検索キーワードとして扱う。
2. **sqlite3コマンドを組み立てて実行**: 上記クエリパターンを参考に、状況に応じた適切なSQLを組み立てる。
3. **結果を整形して提示**: ノート一覧はタイトルと更新日時の表形式、本文はそのまま表示。
4. **ユーザーの追加リクエストに対応**: 特定ノートの本文表示、絞り込み検索など。

## 注意事項

- **読み取り専用**: INSERT/UPDATE/DELETE は絶対に実行しない。`-readonly` フラグを必ず使用する。
- **本文が長い場合**: `substr(n.text, 1, 2000)` で切り詰めて表示し、続きが必要か確認する。
- **タイムスタンプ**: Unix timestamp（**ミリ秒**）で格納。`datetime(col / 1000, 'unixepoch', 'localtime')` で日本時間に変換。
