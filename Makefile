.PHONY: new help clean

# デフォルトのベースディレクトリ（業務リポジトリの親ディレクトリ）
BASE_DIR ?= $(HOME)/claude-work

# 使い方を表示
help:
	@echo ""
	@echo "=== Claude Code 業務リポジトリ初期化ツール ==="
	@echo ""
	@echo "使い方:"
	@echo "  make new NAME=経費精算                  # 新しい業務リポジトリを作成"
	@echo "  make new NAME=経費精算 DESC=\"毎月の経費精算を半自動化する\"  # 説明付き"
	@echo "  make new NAME=プレゼン資料 BASE_DIR=~/work  # 別の親ディレクトリに作成"
	@echo "  make list                               # 既存リポジトリ一覧"
	@echo "  make help                               # このヘルプを表示"
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
