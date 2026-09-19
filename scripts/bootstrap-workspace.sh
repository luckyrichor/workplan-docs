#!/usr/bin/env bash
# 在任意一台机器上拉齐整个工作区（七个仓库）。
#
#   bash bootstrap-workspace.sh            # 用该平台的约定路径
#   bash bootstrap-workspace.sh /自定义/路径
#
# 约定路径（不传参数时）：
#   macOS    /Users/<你>/Project/WorkPlan
#   Linux    ~/project/WorkPlan
#   Windows  E:\WorkPlan   （Git Bash 下写作 /e/WorkPlan）
#
# 幂等：已存在的仓库执行 pull，不存在的才 clone。
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

default_root() {
  case "$(uname -s)" in
    Darwin)            echo "$HOME/Project/WorkPlan" ;;
    Linux)             echo "$HOME/project/WorkPlan" ;;
    MINGW*|MSYS*|CYGWIN*) echo "/e/WorkPlan" ;;   # UE 对路径长度敏感，根目录要短
    *)                 echo "$HOME/project/WorkPlan" ;;
  esac
}

root="${1:-$(default_root)}"
mkdir -p "$root"
cd "$root"
echo "工作区: $root"
echo

for r in "${REPOS[@]}"; do
  if [ -d "$r/.git" ]; then
    printf '%-22s ' "$r"
    if git -C "$r" pull --ff-only --quiet 2>/dev/null; then echo "已更新"; else echo "跳过（有本地改动或分叉）"; fi
  else
    printf '%-22s ' "$r"
    git clone --quiet "git@github.com:${GH_USER}/${r}.git" "$r" && echo "已克隆" || echo "克隆失败"
  fi
done

# 容器目录本身不是 git 仓库，放指路文件方便各类编码 agent 定位计划层。
# 两份内容相同：Claude Code 读 CLAUDE.md，Codex 读 AGENTS.md。
cat > AGENTS.md <<'INNER'
# AGENTS.md

这是工作区容器目录，**本身不是 git 仓库**。七个子目录各自是独立仓库。

先读 `workplan-docs/AGENTS.md`（计划层、六项目分工、多机协作规则），
动环境之前再读 `workplan-docs/环境与踩坑记录.md`（三台机器的实际状态与已踩过的坑）。
各项目仓库内另有自己的 `AGENTS.md`。

（`CLAUDE.md` 与本文件内容相同，是给 Claude Code 的同名副本；改动请两份一起改。）
INNER

cat > CLAUDE.md <<'INNER'
# CLAUDE.md

这是工作区容器目录，**本身不是 git 仓库**。七个子目录各自是独立仓库。

先读 `workplan-docs/AGENTS.md`（计划层、六项目分工、多机协作规则），
动环境之前再读 `workplan-docs/环境与踩坑记录.md`（三台机器的实际状态与已踩过的坑）。
各项目仓库内另有自己的 `AGENTS.md`。

（`AGENTS.md` 与本文件内容相同，是给 Codex 等工具的同名副本；改动请两份一起改。）
INNER

echo
echo "完成。下一步："
echo "  1. 计划层见 $root/workplan-docs/CLAUDE.md"
echo "  2. 首次使用需配 git 身份与推送凭据，见 workplan-docs/README.md「在新机器上开工」"
