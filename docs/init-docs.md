# 使用方法

### セットアップ（初回のみ）
```
# このツールを好きな場所に clone or ダウンロード
cd ~/claude-work-init
chmod +x init.sh
```

### 新しい業務リポジトリを作る
```
# 基本
make new NAME=経費精算

# 説明付き
make new NAME=経費精算 DESC="毎月のクレカ明細からfreee入力用シートを生成する"

# 親ディレクトリを指定
make new NAME=稼働報告 BASE_DIR=~/work/ai-tasks
```


### 作業を始める
```
cd ~/claude-work/経費精算
# PLAN.md を開いて音声入力でやりたいことをダンプ
# その後 Claude Code を起動
claude
```

Claude Code に「PLAN.md を読んで、この業務の半自動化を一緒に考えて」と話しかければ、記事で紹介されているワークフローがすぐに始まる。

### 4. 既存リポジトリの一覧
```
make list
```

出力例:
```
=== 既存の業務リポジトリ (/Users/you/claude-work) ===

  📁 経費精算  (作成: 2026-04-01)
  📁 稼働報告  (作成: 2026-04-01)
  📁 プレゼン資料  (作成: 2026-03-28)
```

