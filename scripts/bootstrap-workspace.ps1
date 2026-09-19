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
# CLAUDE.md

这是工作区容器目录，**本身不是 git 仓库**。七个子目录各自是独立仓库。

先读 **``workplan-docs/CLAUDE.md``**（计划层、六项目分工、多机协作规则），
动环境之前再读 **``workplan-docs/环境与踩坑记录.md``**（三台机器的实际状态与已踩过的坑）。
各项目另有自己的 ``CLAUDE.md``。
"@ | ForEach-Object { [System.IO.File]::WriteAllText("$Root\CLAUDE.md", $_, (New-Object System.Text.UTF8Encoding($false))) }  # 不能用 Set-Content -Encoding UTF8：PS 5.1 会写 BOM

Write-Host "`n完成。引擎项目还需要："
Write-Host "  git lfs install        # tactical-shooter-ue / coop-combat-unity 用 LFS 管理二进制资产"
Write-Host "  计划层见 $Root\workplan-docs\CLAUDE.md"
