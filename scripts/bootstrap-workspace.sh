#!/usr/bin/env bash
# 在一台新机器上拉齐整个工作区。
# 用法: bash workplan-docs/scripts/bootstrap-workspace.sh [容器目录]
# 默认容器目录 = 本脚本所在仓库的父目录。
set -euo pipefail

GH_USER="luckyrichor"
REPOS=(
  workplan-docs
  agent-memory
  agent-ops-platform
  tactical-shooter-ue
  coop-combat-unity
  engine-core-labs
  backend-cloud-labs
)

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
root="${1:-$(dirname "$here")}"
mkdir -p "$root"
cd "$root"

echo "容器目录: $root"
for r in "${REPOS[@]}"; do
  if [ -d "$r/.git" ]; then
    printf '%-24s 已存在，pull\n' "$r"
    git -C "$r" pull --ff-only --quiet || echo "  (pull 失败，可能有本地改动，跳过)"
  else
    printf '%-24s clone\n' "$r"
    git clone --quiet "https://github.com/${GH_USER}/${r}.git" "$r" || echo "  (clone 失败，仓库可能尚未创建)"
  fi
done

# 容器目录本身不是 git 仓库，放一个指路文件方便 Claude Code 定位计划层
cat > CLAUDE.md <<'INNER'
# CLAUDE.md

这是工作区容器目录，**本身不是 git 仓库**。七个子目录各自是独立仓库。

计划层、岗位依据、总节奏和多机协作规则在 **`workplan-docs/CLAUDE.md`**，
动任何项目之前先读那一份。各项目另有自己的 `CLAUDE.md`。
INNER

echo
echo "完成。计划层见 workplan-docs/CLAUDE.md"
