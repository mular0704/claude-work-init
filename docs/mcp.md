# github MCP への接続方法

## TOKEN作成

以下は必須

|項目|	設定値|
|-|-|
|Repository access|	All repositories を選択（または estate_analysis を個別指定）|
|Contents|	Read-only 以上|
|Issues|	Read-only 以上|
|Metadata|	Read-only（必須）|

## GitHub MCP サーバーを Claude Code に登録する

登録方法には「リモート接続（推奨・簡単）」と「Dockerローカル接続」の2種類があります。通常はリモート接続を使います。

### ▼ 方法A：リモート接続（推奨）

Claude Code CLI のバージョン 2.1.1 以降 を使っている場合はこちらです（claude --version で確認できます）。

ターミナルで以下を実行します。YOUR_GITHUB_PAT の部分を先ほどコピーしたトークンに置き換えてください。
```
claude mcp add-json github '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer YOUR_GITHUB_PAT"}}'
```


#### ▼ トークンを直接書かずに安全に設定する方法（推奨）

トークンをコマンドに直接書くとシェル履歴に残るリスクがあります。.env ファイルに保存する方法がより安全です。

まず、作業用のディレクトリで .env ファイルを作成します。
```
# .env ファイルを作成してトークンを書き込む
echo "GITHUB_PAT=ここに取得したトークンを貼り付ける" > .env

# .env をgit管理対象外にする（gitリポジトリの場合）
echo ".env" >> .gitignore

```

続いて、.env ファイルからトークンを読み取りつつ MCP を登録します。

```
claude mcp add-json github '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer '"$(grep GITHUB_PAT .env | cut -d '=' -f2)"'"}}'
```

### ▼ 方法B：Dockerローカル接続（Docker が既に入っている場合）

```
claude mcp add github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=YOUR_GITHUB_PAT \
  -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

## Knowledge
### アクセスできない。（404等）

- 今登録されている MCP の設定を確認
  ```
  claude mcp get github
  ```
- PAT が実際にそのリポジトリにアクセスできるか直接テスト
  ```
  curl -H "Authorization: Bearer あなたのGITHUB_PAT" \
    https://api.github.com/repos/mular0704/estate_analysis
  ```

- 設定ファイルを直接確認する
  ```
  cat ~/.claude.json
  ```
### 登録するTOKENを間違えた

- MCP 削除
  ```
  # 削除
  claude mcp remove github
  ```
再登録後は「アクセスできない」場合の手順で接続を確認

/mcp で github · ✓ connected に変わっていれば成功
