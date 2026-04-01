#!/usr/bin/env bash

# source ./enter.sh <NAME> [DESC...]
# 新規プロジェクト作成後、現在のシェルをそのディレクトリへ移動する。

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "このスクリプトは source して使ってください。"
    echo "例: source ./enter.sh 経費精算 \"毎月の経費精算を半自動化する\""
    exit 1
fi

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -lt 1 ]]; then
    echo "エラー: プロジェクト名を指定してください"
    echo "例: source ./enter.sh 経費精算"
    return 1
fi

PROJECT_NAME="$1"
PROJECT_DESC="${2:-}"

if [[ -f "${SCRIPT_DIR}/.env" ]]; then
    # シンプルな KEY=VALUE を想定したローカル設定ファイル
    set -a
    source "${SCRIPT_DIR}/.env"
    set +a
fi

BASE_DIR="${BASE_DIR:-$HOME/claude-work}"
SAFE_NAME="$(echo "${PROJECT_NAME}" | tr ' /' '-_')"
REPO_DIR="${BASE_DIR}/${SAFE_NAME}"

bash "${SCRIPT_DIR}/init.sh" "${BASE_DIR}" "${PROJECT_NAME}" "${PROJECT_DESC}"
cd "${REPO_DIR}"

echo "📍 カレントディレクトリを移動しました: ${REPO_DIR}"
