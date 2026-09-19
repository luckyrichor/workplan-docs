# workplan-docs

三个月求职导向学习与项目实践计划的**计划层**：岗位依据、总节奏、进度总览。不含项目代码。

最后更新：2026-09-19

## 目标

围绕腾讯、字节跳动、米哈游、拼多多共 18 个技术岗位的真实 JD 要求，用三个月时间学习和做项目实践，积累可写进简历、能讲给面试官听的具体证据。

## 文件

| 文件 | 作用 |
|---|---|
| `岗位.txt` | 18 个岗位官方链接，顺序即岗位编号 01–18 |
| `岗位要求原文.md` | 18 个岗位职责/要求/加分项原文（已删除工作年限）——**唯一事实来源** |
| `岗位分析.md` | 分类、逐岗位解读、共性对比、六项目映射——**决策的分析基础** |
| `README-项目说明与当前方案.md` | 方案总入口 |
| `总节奏表.md` | 13 周 × 6 项目排期与工时预算 |
| `进度总览.md` | 各项目进度汇总看板 |

## 六个项目

各有独立仓库，并列放在同一容器目录下：

| 仓库 | 方向 | 对应岗位 |
|---|---|---|
| [`tactical-shooter-ue`](https://github.com/luckyrichor/tactical-shooter-ue) | UE C++ 战术射击原型 | 03、04，兼顾 12 |
| [`coop-combat-unity`](https://github.com/luckyrichor/coop-combat-unity) | Unity C# 联机战斗原型 | 09 |
| [`agent-ops-platform`](https://github.com/luckyrichor/agent-ops-platform) | Agent 应用与可观测评测平台 | 05、07、10、11、14 |
| [`agent-memory`](https://github.com/luckyrichor/agent-memory) | 跨会话记忆系统 | 01 |
| [`engine-core-labs`](https://github.com/luckyrichor/engine-core-labs) | 游戏引擎通用模块实验 | 02 |
| [`backend-cloud-labs`](https://github.com/luckyrichor/backend-cloud-labs) | 后端服务与云原生实验 | 06、13、15、16、17 |

`agent-ops-platform` 通过 API 调用 `agent-memory`。其余项目相互独立。

## 在新机器上开工

```bash
git clone https://github.com/luckyrichor/workplan-docs.git
bash workplan-docs/scripts/bootstrap-workspace.sh
```

会把七个仓库克隆到同一个容器目录下。各项目的环境依赖见各自仓库的 README。

## 范围说明

岗位 18（前端）不纳入实践。岗位 08 保留分析但尚未分配到项目。本计划中的项目对应关系代表**目标关联**，不意味着单个项目自动完整覆盖对应岗位的全部要求。
