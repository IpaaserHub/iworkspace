# iworkspace

Claude Code を使って、リサーチやコンテンツ作成などの **コーディング以外のビジネスタスク** を自動化するためのワークスペースです。

## できること

### X Deep Search スキル

`/x-search` コマンドで、X（旧Twitter）上の情報を AI が自動で検索・分析・レポート化します。

| 機能 | 説明 |
|------|------|
| キーワード検索 | 特定のトピックに関する投稿を収集・分析 |
| 競合リサーチ | 競合企業を多角的に段階調査（自動で複数検索を並行実行） |
| トレンドリサーチ | 業界トレンドやセンチメントを把握 |
| 画像・動画の読み取り | 投稿に含まれる画像や動画の内容も分析可能 |
| メモリー機能 | あなたの趣味嗜好を記憶し、次回以降のリサーチに反映 |

**使用例:**
- 「Claude Code」に関するXでの反応を調べて → キーワード検索
- 競合のAI SaaSツールを徹底調査して → 競合リサーチ
- 最近のAIエージェントのトレンドを調べて → トレンドリサーチ

---

## セットアップ手順

### 前提条件

- **Claude Code** がインストール済みであること
- **ターミナル**（Mac の場合はターミナル.app）が使えること

> Claude Code のインストールがまだの方は [公式サイト](https://code.claude.com/docs/ja/overview) を参照してください。

---

### ステップ 1: このプロジェクトをダウンロード

ターミナルを開いて、以下をコピー＆ペーストして実行してください。

```bash
git clone https://github.com/ipaaser/iworkspace.git
```

> **git が入っていない場合:** GitHub のページから「Code」→「Download ZIP」でダウンロードし、解凍してください。

---

### ステップ 2: xAI の API キーを取得

X検索スキルは [xAI（Grok）](https://console.x.ai/) の API を使用します。API キーを取得してください。

1. [https://console.x.ai/](https://console.x.ai/) にアクセス
2. アカウントを作成 or ログイン
3. 「API Keys」から新しいキーを作成
4. `xai-` で始まるキーが表示されるので、コピーして保存

> API の利用には料金が発生します。詳しくは xAI の料金ページを確認してください。

---

### ステップ 3: API キーを設定

ターミナルで以下をコピー＆ペーストして実行してください。

```bash
mkdir -p ~/.config/xai
```

次に、以下のコマンドの `ここにAPIキーを貼り付け` の部分を、ステップ2で取得したキーに置き換えて実行してください。

```bash
echo -n "ここにAPIキーを貼り付け" > ~/.config/xai/api_key
chmod 600 ~/.config/xai/api_key
```

**実行例:**
```bash
echo -n "xai-abc123def456..." > ~/.config/xai/api_key
chmod 600 ~/.config/xai/api_key
```

> `chmod 600` はキーを自分だけが読めるようにするセキュリティ設定です。

---

### ステップ 4: Claude Code で開く

ターミナルで以下を実行して、このプロジェクトを Claude Code で開きます。

```bash
cd iworkspace
claude
```

---

### ステップ 5: 使ってみる

Claude Code が起動したら、以下のように話しかけるだけで OK です。

```
/x-search
```

あとは Claude が対話形式で検索内容を聞いてくれます。

または、直接リクエストすることもできます：

```
Xで「Claude Code」についての反応を調べて
```

```
AI SDR市場の競合を徹底的にリサーチして
```

---

## 検索結果の保存場所

検索結果は自動的に以下に保存されます。

```
workspace/x-results/
├── reports/    ← レポート（Markdown形式、人が読む用）
└── outputs/    ← 生データ（JSON形式）
```

---

## トラブルシューティング

### 「API キーが見つかりません」と表示される

→ ステップ3を再確認してください。以下のコマンドでキーが保存されているか確認できます：

```bash
cat ~/.config/xai/api_key
```

`xai-` で始まるキーが表示されれば OK です。

### 検索結果が返ってこない

→ xAI のアカウントにクレジット（残高）があるか確認してください。[https://console.x.ai/](https://console.x.ai/) の Billing ページで確認できます。

### Claude Code が起動しない

→ Claude Code が正しくインストールされているか確認してください：

```bash
claude --version
```

バージョン番号が表示されれば OK です。

---

## 今後追加予定のスキル

- 高品質なスライド作成スキル（coming soon）
- ランディングページ・WEB サイトリサーチ・作成スキル
- NotebookLM との連携スキル
