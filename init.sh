#!/usr/bin/env bash
set -euo pipefail

# ============================================================
#  Claude Code 業務リポジトリ初期化スクリプト
#
#  参考: minorun365「Claude Codeでコーディング以外の仕事を
#        半自動化しまくっている話」
#  https://qiita.com/minorun365/items/114f53def8cb0db60f47
# ============================================================

BASE_DIR="${1:?ベースディレクトリを指定してください}"
PROJECT_NAME="${2:?プロジェクト名を指定してください}"
PROJECT_DESC="${3:-}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/templates"
TODAY="$(date +%Y-%m-%d)"

# --- リポジトリ名を安全なディレクトリ名に変換 ---
# 日本語はそのまま使えるが、スラッシュやスペースなどは置換
SAFE_NAME="$(echo "${PROJECT_NAME}" | tr ' /' '-_')"
REPO_DIR="${BASE_DIR}/${SAFE_NAME}"

# --- 既存チェック ---
if [ -d "${REPO_DIR}" ]; then
    echo "⚠️  既にリポジトリが存在します: ${REPO_DIR}"
    echo "   既存のリポジトリで Claude Code を起動してください。"
    exit 1
fi

echo ""
echo "🚀 新しい業務リポジトリを作成します"
echo "   名前: ${PROJECT_NAME}"
echo "   場所: ${REPO_DIR}"
[ -n "${PROJECT_DESC}" ] && echo "   概要: ${PROJECT_DESC}"
echo ""

# --- ディレクトリ構造を作成 ---
mkdir -p "${REPO_DIR}"
mkdir -p "${REPO_DIR}/docs"           # 参考資料・PDF置き場
mkdir -p "${REPO_DIR}/output"         # 成果物の出力先
mkdir -p "${REPO_DIR}/templates"      # テンプレートファイル
mkdir -p "${REPO_DIR}/scripts"        # 自動化スクリプト

# --- テンプレートファイルをコピーして変数を展開 ---
expand_template() {
    local src="$1"
    local dst="$2"
    sed \
        -e "s|{{PROJECT_NAME}}|${PROJECT_NAME}|g" \
        -e "s|{{PROJECT_DESC}}|${PROJECT_DESC}|g" \
        -e "s|{{TODAY}}|${TODAY}|g" \
        "${src}" > "${dst}"
}

expand_template "${TEMPLATE_DIR}/PLAN.md"      "${REPO_DIR}/PLAN.md"
expand_template "${TEMPLATE_DIR}/SPEC.md"      "${REPO_DIR}/SPEC.md"
expand_template "${TEMPLATE_DIR}/TODO.md"      "${REPO_DIR}/TODO.md"
expand_template "${TEMPLATE_DIR}/KNOWLEDGE.md" "${REPO_DIR}/KNOWLEDGE.md"
expand_template "${TEMPLATE_DIR}/CLAUDE.md"    "${REPO_DIR}/CLAUDE.md"

# --- .gitignore ---
cat > "${REPO_DIR}/.gitignore" << 'GITIGNORE'
# OS
.DS_Store
Thumbs.db

# 機密情報が入りがちなファイル
*.env
credentials.json
token.json

# 一時ファイル
*.tmp
*.bak
GITIGNORE

# --- Git 初期化 ---
(
    cd "${REPO_DIR}"
    git init --quiet
    git add -A
    git commit --quiet -m "🎉 初期化: ${PROJECT_NAME}"
)

# --- 完了メッセージ ---
echo "✅ リポジトリを作成しました！"
echo ""
echo "📂 ディレクトリ構成:"
echo "   ${REPO_DIR}/"
echo "   ├── CLAUDE.md        … Claude Code 用の指示書"
echo "   ├── PLAN.md          … やりたいことを音声入力でダンプ"
echo "   ├── SPEC.md          … Claudeとの壁打ちで仕様を整理"
echo "   ├── TODO.md          … タスク管理"
echo "   ├── KNOWLEDGE.md     … 学び・ナレッジの蓄積"
echo "   ├── docs/            … 参考資料・PDF置き場"
echo "   ├── output/          … 成果物の出力先"
echo "   ├── templates/       … テンプレートファイル"
echo "   └── scripts/         … 自動化スクリプト"
echo ""
echo "🎯 次のステップ:"
echo "   1. cd ${REPO_DIR}"
echo "   2. PLAN.md に音声入力でやりたいことをダンプ"
echo "   3. claude と打って Claude Code を起動"
echo "   4. 「PLAN.md を読んで、この業務の半自動化を一緒に考えて」と話しかける"
echo ""
