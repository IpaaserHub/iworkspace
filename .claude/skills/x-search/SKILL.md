---
name: x-search
description: Search X (Twitter) for real-time posts, trends, and discussions using the Grok API. Use this skill whenever the user wants to search X/Twitter, find tweets, check what people are saying on X, monitor social media discussions, look up X user posts, find trending topics on X, or gather social sentiment. Also trigger when the user mentions "x-search", "tweet search", "X posts", or wants real-time social media information from X/Twitter.
---

# X検索スキル

X（旧Twitter）上の投稿をリアルタイムで検索するスキルです。

## モード選択

ユーザーのリクエストに応じて、以下のモードを判断する：

- **通常検索**: キーワード検索、アカウント検索など → ステップ1へ進む
- **競合リサーチ**: 競合企業やプロダクトを徹底調査したい場合 → `references/competitive-research.md` を読み込んでそのフローに従う
- **トレンド調査**: 特定トピックのトレンド・世論・盛り上がりを多角的に調査したい場合 → `references/trend-research.md` を読み込んでそのフローに従う

**モード判断基準**：

| モード | トリガーワード例 |
|---|---|
| 競合リサーチ | 「競合」「競合調査」「〇〇社を徹底的に調べて」 |
| トレンド調査 | 「トレンド」「世論」「盛り上がり」「話題」「反応を徹底的に」 |
| 通常検索 | 上記に該当しない一般的な検索リクエスト |

ユーザーがどれか判断できない場合は、AskUserQuestion で確認する。

## ステップ1: 検索要件の確認（不明瞭な場合のみ）

ユーザーのリクエストを受けたら、まず検索に必要な情報が十分かを判断する。

**以下のいずれかが不明瞭な場合**、AskUserQuestion ツールで確認する：
- 検索キーワード / トピックが曖昧（例:「最近のニュース調べて」→ 何のニュースか不明）
- 期間を絞るべきか判断できない
- 特定アカウントに絞りたいのか不明
- 日本語で検索するか英語で検索するか、または両方か

**確認が不要なケース**（そのまま検索に進む）：
- キーワードが明確（例:「Claude Codeについての反応を調べて」）
- 十分な条件が指定されている（例:「@OpenAI の直近1週間の投稿を検索して」）

確認時の質問例：
```
AskUserQuestion:
  "X検索の条件を確認させてください：
   - 検索キーワード: 〇〇 でよいですか？
   - 期間: 特に指定はありますか？（例: 直近1週間、今月など）
   - 特定のアカウントに絞りますか？
   - その他の条件はありますか？"
```

## ステップ2: x-search エージェントに委任

このスキルは **x-search サブエージェント** に検索を委任します。メインエージェントが直接検索スクリプトを実行するのではなく、Agent ツールで `subagent_type: "x-search"` を起動してください。

検索要件が確定したら、以下のようにサブエージェントを起動します：

```
Agent tool:
  subagent_type: "x-search"
  description: "X検索: <検索内容の要約>"
  prompt: "<ユーザーのリクエストを具体的に伝える。検索キーワード、期間指定、特定アカウント指定などを含める>"
```

### プロンプトに含めるべき情報

- 検索したいキーワードやトピック
- 期間の指定（あれば）
- 特定アカウントの指定（あれば）
- 画像/動画検索の要否
- Web検索の併用要否
- その他ユーザーが指定した条件

### 並行検索

複数の検索が必要な場合は、複数のx-searchエージェントを**最大4つまで**並行して起動できる。1つのメッセージ内で複数のAgent toolを同時に呼び出すこと。

## 結果の取り扱い

x-searchエージェントが以下を自動的に行います：
- Grok APIを使ったX検索の実行
- レポート（Markdown）の保存: `/Users/shotanakayama/projects/iworkspace/workspace/x-results/reports/`
- APIレスポンス生データ（JSON）の保存: `/Users/shotanakayama/projects/iworkspace/workspace/x-results/outputs/`

エージェントから結果が返ってきたら、ユーザーにわかりやすく要約して伝えてください。
