# 注意：本文件必须保存为「带 BOM 的 UTF-8」。
# PowerShell 5.1 会把无 BOM 的 .ps1 当 ANSI/GBK 读，里面的中文会乱码并导致解析失败。
# 详见 workplan-docs/环境与踩坑记录.md 第 2 条。
#
# 在 Windows 上拉齐整个工作区（七个仓库）。
#
#   powershell -ExecutionPolicy Bypass -File bootstrap-workspace.ps1
#   powershell -ExecutionPolicy Bypass -File bootstrap-workspace.ps1 -Root D:\WorkPlan
#
# 默认根目录 E:\WorkPlan —— 刻意选短路径，UE 对路径长度敏感，
# 放在 Documents 等深层目录下容易触发 Windows MAX_PATH 限制。
param([string]$Root = "E:\WorkPlan")

$ErrorActionPreference = "Stop"
$GhUser = "luckyrichor"
$Repos  = @(
  "workplan-docs", "agent-memory", "agent-ops-platform",
  "tactical-shooter-ue", "coop-combat-unity",
  "engine-core-labs", "backend-cloud-labs"
)

New-Item -ItemType Directory -Force -Path $Root | Out-Null
Set-Location $Root
Write-Host "工作区: $Root`n"

foreach ($r in $Repos) {
  $pad = $r.PadRight(22)
  if (Test-Path "$r\.git") {
    git -C $r pull --ff-only --quiet 2>$null
    if ($LASTEXITCODE -eq 0) { Write-Host "$pad 已更新" } else { Write-Host "$pad 跳过（有本地改动或分叉）" }
  } else {
    git clone --quiet "git@github.com:$GhUser/$r.git" $r 2>$null
    if ($LASTEXITCODE -eq 0) { Write-Host "$pad 已克隆" } else { Write-Host "$pad 克隆失败" }
  }
}

@"
# AGENTS.md

这是工作区容器目录，**本身不是 git 仓库**。七个子目录各自是独立仓库。

先读 ``workplan-docs/AGENTS.md``（计划层、六项目分工、多机协作规则），
动环境之前再读 ``workplan-docs/环境与踩坑记录.md``（三台机器的实际状态与已踩过的坑）。
各项目仓库内另有自己的 ``AGENTS.md``。

## 记录规范

各仓库的正文**只维护 ``AGENTS.md``**，``CLAUDE.md`` 永远只是指路，**不要往 CLAUDE.md 里加内容**。
新内容按类型分流：仓库指引进该仓库 ``AGENTS.md``；环境与工具链的坑进 ``workplan-docs/环境与踩坑记录.md``；
已发生的进展进各仓库 ``docs/progress.md``；设计取舍进 ``docs/design-decisions.md``；排期进 ``workplan-docs/总节奏表.md``。

（``CLAUDE.md`` 与本文件内容相同，是给 Claude Code 的同名副本；改动请两份一起改。）
"@ | ForEach-Object { [System.IO.File]::WriteAllText("$Root\AGENTS.md", $_, (New-Object System.Text.UTF8Encoding($false))) }

@"
# CLAUDE.md

这是工作区容器目录，**本身不是 git 仓库**。七个子目录各自是独立仓库。

先读 ``workplan-docs/AGENTS.md``（计划层、六项目分工、多机协作规则），
动环境之前再读 ``workplan-docs/环境与踩坑记录.md``（三台机器的实际状态与已踩过的坑）。
各项目仓库内另有自己的 ``AGENTS.md``。

## 记录规范

各仓库的正文**只维护 ``AGENTS.md``**，``CLAUDE.md`` 永远只是指路，**不要往 CLAUDE.md 里加内容**。
新内容按类型分流：仓库指引进该仓库 ``AGENTS.md``；环境与工具链的坑进 ``workplan-docs/环境与踩坑记录.md``；
已发生的进展进各仓库 ``docs/progress.md``；设计取舍进 ``docs/design-decisions.md``；排期进 ``workplan-docs/总节奏表.md``。

（``AGENTS.md`` 与本文件内容相同，是给 Codex 等工具的同名副本；改动请两份一起改。）
"@ | ForEach-Object { [System.IO.File]::WriteAllText("$Root\CLAUDE.md", $_, (New-Object System.Text.UTF8Encoding($false))) }

Write-Host "`n完成。引擎项目还需要："
Write-Host "  git lfs install        # tactical-shooter-ue / coop-combat-unity 用 LFS 管理二进制资产"
Write-Host "  计划层见 $Root\workplan-docs\AGENTS.md"
