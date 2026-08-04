# 予約実行手順（航空会社直販）

Last updated: 2026-08-04

## 大原則

**OTA（Kiwi、Expedia、Trip.com等）では予約しない。必ず航空会社直販で予約する。**

理由:
1. **UM（お子さまひとり旅）はOTA発券券だと受付を拒否されることがある。** UMは航空会社のSSR（特別サービスリクエスト）で、多くの航空会社が「自社で発券された券のみ」を条件にしている
2. Kiwiのようなバーチャル・インターライン（別々の券を勝手に組み合わせる方式）は、遅延時の振替保護がなく、荷物のスルーチェックインもできない。子ども単独では致命的
3. 変更・キャンセル時に航空会社と直接やり取りできない

検索は Google Flights（SerpApi経由）で行い、**予約は必ず航空会社公式サイト／電話**に誘導する。

## 航空会社別 予約チャネル

| 航空会社 | 券の予約 | UM申込 | 備考 |
|---|---|---|---|
| **JAL** | 公式Web可 | **電話必須**（12歳未満の大人同伴なし予約） | 5歳以上で単独搭乗可。国際線に「JALスマイルサポート」の枠組みはない（国内線のみ）ため、国際線お問い合わせ窓口で個別に確認する |
| **ANA** | **電話必須** | **電話必須**（インターネット予約不可） | ジュニアパイロットは満5〜11歳。**ANA運航便のみ**でコードシェア便は不可。申込書・同意書を**英語**で記入 |
| **Emirates** | 公式Web可 | Web予約時に Special Assistance で "Unaccompanied Minor" を選択可。電話でも可 | USD 50／1レグ。12〜15歳は任意 |
| **Qatar Airways** | **電話／支店必須**（UM時） | オンライン不可。出発72時間前までにリクエスト、UMフォームは24〜48時間前まで | 5〜15歳が対象。12〜15歳は任意 |
| **Finnair** | 公式Web可 | 予約後にFinnairへ連絡 | 乗継はAY便同士・HEL・同日乗継のみ |
| **British Airways** | 公式Web可 | — | **14歳未満は単独搭乗不可**。梨花が14歳になるまで選択肢に入れない |

## 公式窓口

- JAL 国際線: https://www.jal.co.jp/jp/ja/inter/support/child/ ／ [お問い合わせ](https://www.jal.co.jp/jp/ja/support/)
- ANA 国際線ジュニアパイロット: https://www.ana.co.jp/ja/jp/guide/reservation/support/international/kids/
- Emirates Special assistance: https://www.emirates.com/english/help/faq-topics/special-assistance-and-requests/
- Qatar Airways: https://www.qatarairways.com/en/special-assistance.html
- Finnair: https://www.finnair.com/en/travel-information/travelling-with-children
- British Airways: https://www.britishairways.com/en-gb/information/travel-assistance/young-flyers

電話番号は変更されるため本ファイルにはハードコードしない。上記公式ページの問い合わせ先を都度参照すること。

## 提示フォーマット

候補が確定したら、便ごとに以下の「予約アクション」を出す:

```
### 予約アクション: [子どもの名前] [往路/復路]

- **便**: JL043 HND 10:25 → LHR 14:55（直行）
- **予約先**: JAL公式サイト https://www.jal.co.jp/
- **予約方法**: Web で予約 → 発券後にJAL国際線窓口へ電話し「12歳未満の同伴者なし搭乗」を申告
- **UM**: 梨花13歳 → JALは12〜15歳は任意。付けるなら電話で追加
- **期限の目安**: 出発72時間前まで（航空会社ごとに要確認）
- **参考価格**: ¥XXX,XXX（Google Flights時点、実売と差が出る）
```

## 注意事項

- **Google Flightsの表示価格 ≠ 航空会社直販価格。** 直販の方が高いことも安いこともある。必ず公式サイトで最終価格を確認する
- 検索結果の便名・時刻は必ず航空会社公式サイトで再確認する（スケジュール変更があるため）
- UM申込には**保護者の連絡先・お迎え担当者の氏名と連絡先**が必要。学校側の担当者情報を事前に用意する
- 12歳以上はGoogle Flights上「大人」扱い。UMの要否は年齢とは別に `um-policies.md` で判定する
