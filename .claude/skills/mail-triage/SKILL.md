---
name: mail-triage
description: Gmailの受信トレイをトリアージする。未読・未処理メールを確認し、アクション必要なものの提示・返信案の作成、メルマガのハイライト表示、不要メールのアーカイブを行い、Inboxをスター付きメールのみにする。
argument-hint: なし（引数不要）
allowed-tools: mcp__google-workspace__search_gmail_messages, mcp__google-workspace__get_gmail_messages_content_batch, mcp__google-workspace__batch_modify_gmail_message_labels
---

# Mail Triage Skill

## 概要

エイジさん（eiji.araki@gmail.com）のGmail受信トレイをトリアージする。
最終目標：**スター付きメール以外はInboxが空**の状態。

---

## Step 1: 受信トレイの取得

```
search_gmail_messages(query="in:inbox", page_size=50)
```

次に全メールのメタデータ（件名・送信者・日付）を一括取得：

```
get_gmail_messages_content_batch(message_ids=[...], format="metadata")
```

> ⚠️ `format="full"` は一括25通超えると容量超過エラーになる。まずメタデータで分類し、アクション系のみ詳細取得する。

---

## Step 2: メールの分類

### カテゴリ判定

| カテゴリ | 判定基準 | 処理 |
|---------|---------|------|
| **アクション必要** | 返信・支払い・提出・手配が必要なもの | → Step 3A |
| **プロモ・EC・通知** | セール・配送通知・購買確認・プライバシーポリシー等 | → アーカイブ |
| **ニュース・メルマガ** | The Economist / Business Insider / クーリエ・ジャポン / 週刊誌等 | → Step 3B |
| **過去のイベント通知** | 既に日付が過ぎたイベント案内・会場案内 | → アーカイブ |
| **学校・重要機関からのお知らせ** | 子供の学校・ビザ・行政等 | 内容確認のうえ判断 |

---

## Step 3A: アクション系メールの処理

アクション系メールは詳細取得（`format="full"`）して内容確認：

```
get_gmail_messages_content_batch(message_ids=[アクション系のIDのみ], format="full")
```

### アクション種別ごとの対応

**返信が必要なもの：**
- 返信案を提案 → エイジさんの承認または修正指示を得て送信

**返信以外のアクションが必要なもの（支払い・書類提出・フォーム回答等）：**
- 締切・金額・手順など必要情報を整理してエイジさんに提示
- **締切が2週間以上先** → 期日1週間前までSnooze（スター付き＋Inboxに残す）
- **締切が2週間以内** → 即座にスター付きでInbox維持、要対応を提示

**いずれのアクションも今すぐ行わないもの：**
- 既読 + スター + Inbox維持

### ラベル操作（アクション系）

```
batch_modify_gmail_message_labels(
  message_ids=[アクション系IDs],
  add_label_ids=["STARRED"]
)
```

---

## Step 3B: ニュース・メルマガの処理

1. 詳細取得してハイライトをまとめる
2. ハイライトをエイジさんに提示
3. エイジさんがOKしたらアーカイブ

### ハイライトの書き方
- 各記事・トピックを **2〜5文** で要約
- 主要論点・背景・インパクトが伝わる内容にする
- 単なるタイトル羅列や一行要約は避ける

**例外：週刊金融日記は未読のままInbox維持**（エイジさんの好み）

---

## Step 4: 一括処理の実行

### アーカイブ（プロモ・EC・過去通知）
```
batch_modify_gmail_message_labels(
  message_ids=[アーカイブ対象IDs],
  remove_label_ids=["INBOX"]
)
```

### 既読＋アーカイブ（ニュース・メルマガ）
```
batch_modify_gmail_message_labels(
  message_ids=[メルマガIDs],
  remove_label_ids=["INBOX", "UNREAD"]
)
```

### スター付き（アクション必要）
```
batch_modify_gmail_message_labels(
  message_ids=[アクション系IDs],
  add_label_ids=["STARRED"]
)
```

> 3操作は並行実行可能（依存関係なし）

---

## Step 5: 結果報告

処理後に以下をエイジさんに報告：

1. **スター付きInboxに残ったもの**（件名・締切・対応内容を一覧）
2. **ニュース・メルマガのハイライト**（OKをもらったらアーカイブ）
3. **処理済みの集計**（アーカイブ数・既読数等）

---

## 注意事項

- **送信・削除・実際のアーカイブ実行前** は必ずエイジさんに確認
- Gmail APIレート制限：バッチは25通まで
- Gmailラベル一覧：`INBOX`, `UNREAD`, `STARRED`, `TRASH`
- メールアドレス: `eiji.araki@gmail.com`
