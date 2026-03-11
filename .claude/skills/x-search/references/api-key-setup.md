# XAI API Key セットアップ

## APIキーの取得

1. https://console.x.ai にアクセス
2. アカウントを作成またはログイン
3. API Keys セクションで新しいキーを生成
4. キーは `xai-` で始まる文字列

## セットアップ方法

### 方法1: ファイルに保存（推奨）

```bash
mkdir -p ~/.config/xai
echo -n "xai-YOUR_API_KEY_HERE" > ~/.config/xai/api_key
chmod 600 ~/.config/xai/api_key
```

スクリプトが自動的にこのファイルを読み込みます。

### 方法2: 環境変数

シェルの設定ファイル（`~/.zshrc` や `~/.bashrc`）に追加:

```bash
export XAI_API_KEY="xai-YOUR_API_KEY_HERE"
```

追加後に反映:

```bash
source ~/.zshrc
```

### 方法3: 一時的に設定

コマンド実行時に直接指定:

```bash
XAI_API_KEY="xai-YOUR_API_KEY_HERE" bash x_search.sh "query"
```

## 優先順位

スクリプトは以下の順序でキーを探します:

1. 環境変数 `XAI_API_KEY`
2. ファイル `~/.config/xai/api_key`

どちらも見つからない場合はエラーになります。

## セキュリティ注意事項

- APIキーをGitにコミットしない（`.gitignore` に追加）
- ファイルのパーミッションは `600`（所有者のみ読み書き可）に設定
- キーが漏洩した場合は https://console.x.ai で即座にローテーション
