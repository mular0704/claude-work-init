.PHONY: new help clean list

# .env が存在すれば読み込む
-include .env
export

# デフォルトのベースディレクトリ（業務リポジトリの親ディレクトリ）
# .env の BASE_DIR が未設定の場合のフォールバック
BASE_DIR ?= $(HOME)/claude-work

# 使い方を表示
help:
	@echo ""
	@echo "=== Claude Code 業務リポジトリ初期化ツール ==="
	@echo ""
	@echo "使い方:"
	@echo "  make new NAME=経費精算                           # 新しい業務リポジトリを作成"
	@echo "  make new NAME=経費精算 DESC=\"毎月の経費精算を半自動化する\"   # 説明付き"
	@echo "  make new NAME=プレゼン資料 BASE_DIR=/data/work   # 別の親ディレクトリに作成"
	@echo "  source ./enter.sh 経費精算                       # 作成後にそのまま cd"
	@echo "  make list                                        # 既存リポジトリ一覧"
	@echo "  make help                                        # このヘルプを表示"
	@echo ""
	@echo ".env による設定 (BASE_DIR をコマンドライン引数なしで固定したい場合):"
	@echo "  $ cp .env.example .env"
	@echo "  .env 内の BASE_DIR= に絶対パスを設定してください"
	@echo "  現在の BASE_DIR: $(BASE_DIR)"
	@echo ""
	@echo "補足:"
	@echo "  make 実行中には親シェルを cd できないため、自動移動したい場合は enter.sh を source してください"
	@echo ""

# 新しい業務リポジトリを作成
new:
ifndef NAME
	@echo "エラー: NAME を指定してください"
	@echo "例: make new NAME=経費精算"
	@exit 1
endif
	@bash init.sh "$(BASE_DIR)" "$(NAME)" "$(DESC)"

# 既存リポジトリの一覧を表示
list:
	@echo ""
	@echo "=== 既存の業務リポジトリ ($(BASE_DIR)) ==="
	@echo ""
	@if [ -d "$(BASE_DIR)" ]; then \
		for dir in "$(BASE_DIR)"/*/; do \
			if [ -f "$$dir/PLAN.md" ]; then \
				name=$$(basename "$$dir"); \
				created=$$(stat -f "%Sm" -t "%Y-%m-%d" "$$dir/PLAN.md" 2>/dev/null || stat -c "%y" "$$dir/PLAN.md" 2>/dev/null | cut -d' ' -f1); \
				echo "  📁 $$name  (作成: $$created)"; \
			fi \
		done \
	else \
		echo "  (まだリポジトリがありません)"; \
	fi
	@echo ""
