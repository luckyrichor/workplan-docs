#!/usr/bin/env bash
# 在 tx 上跑命令，但先保证 tx 的代码是最新的。
#
#   bash run-on-tx.sh <仓库名> '<要执行的命令>'
#
# 例：
#   bash run-on-tx.sh agent-memory 'uv run pytest -q'
#   bash run-on-tx.sh agent-memory 'docker compose up -d postgres'
#
# 解决的问题：本地改完代码直接去 tx 跑 Docker/测试，而 tx 上还是旧代码，
# 结果「测试通过」测的是旧版本——这种假通过比失败更危险。
#
# 本脚本强制顺序：本地检查 → push → tx pull → 校验两边哈希一致 → 才执行。
set -euo pipefail

REPO="${1:?用法: run-on-tx.sh <仓库名> '<命令>'}"
CMD="${2:?用法: run-on-tx.sh <仓库名> '<命令>'}"
TX_ROOT="/home/ubuntu/project/WorkPlan"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
local_repo="$here/$REPO"

# 腾讯云登录会打印一大幅 ASCII 二维码和扫码提示，污染所有输出。
# 用一个哨兵标记，只保留标记之后的内容。
tx_run() {
  ssh -o BatchMode=yes tx "echo '@@BEGIN@@'; $1" 2>&1 | sed -n '/@@BEGIN@@/,$p' | tail -n +2
}

[ -d "$local_repo/.git" ] || { echo "找不到本地仓库: $local_repo" >&2; exit 1; }

# 1. 本地有未提交改动就拒绝——否则 tx 上跑的还是少了这些改动的版本
dirty="$(git -C "$local_repo" status --porcelain | wc -l | tr -d ' ')"
if [ "$dirty" != "0" ]; then
  echo "本地有 $dirty 项未提交改动，先提交再跑（否则 tx 上测的不是你当前的代码）：" >&2
  git -C "$local_repo" status --short >&2
  exit 1
fi

# 2. 推送
echo "[1/4] push $REPO"
git -C "$local_repo" push --quiet origin HEAD

# 3. tx 拉取（保留错误输出，见踩坑记录：吞掉错误会看不出没拉成）
echo "[2/4] tx pull"
tx_run "cd $TX_ROOT/$REPO && git pull --ff-only" | tail -3 || true

# 4. 校验哈希一致——这是最终判据，不是「命令有没有报错」
local_sha="$(git -C "$local_repo" rev-parse HEAD)"
tx_sha="$(tx_run "git -C $TX_ROOT/$REPO rev-parse HEAD" | tr -d '\r\n ')"
echo "[3/4] 校验  本地 ${local_sha:0:8} / tx ${tx_sha:0:8}"
[ "$local_sha" = "$tx_sha" ] || { echo "哈希不一致，中止——tx 上的代码不是你要测的版本" >&2; exit 1; }

# 5. 执行
echo "[4/4] 在 tx 执行: $CMD"
echo "----------------------------------------"
tx_run "cd $TX_ROOT/$REPO && $CMD"
