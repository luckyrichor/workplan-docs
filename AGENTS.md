# AGENTS.md

本文件为在本仓库工作的编码 agent 提供指引（Claude Code 读 `CLAUDE.md`、Codex 读 `AGENTS.md`，两者都指向这里）。

## 这是什么

三个月求职导向学习与项目实践计划的**计划层仓库**：岗位依据、总节奏、进度总览。本仓库**不含任何项目代码**，六个项目各有独立仓库。

所有交互默认使用中文。

## 工作区布局

这七个仓库并列放在同一个容器目录下。**容器目录本身不是 git 仓库**，每个子目录各自独立。

各机器的约定根目录（写死在 `scripts/bootstrap-workspace.sh` 里，不要随意换）：

| 机器 | 路径 |
|---|---|
| Mac | `/Users/lc/Project/WorkPlan` |
| `tx`（Ubuntu） | `/home/ubuntu/project/WorkPlan` |
| `luowindows` | `E:\WorkPlan`（短路径，避开 UE 的 MAX_PATH 限制） |

```
WorkPlan/                    ← 容器，不是仓库
├─ workplan-docs/            ← 本仓库：计划层
├─ agent-memory/             ← ④
├─ agent-ops-platform/       ← ③
├─ tactical-shooter-ue/      ← ①
├─ coop-combat-unity/        ← ②
├─ engine-core-labs/         ← ⑤
└─ backend-cloud-labs/       ← ⑥
```

换机器时用 `scripts/bootstrap-workspace.sh` 一次性克隆齐全。

## 文件角色与依赖链

四份依据文档构成**单向依赖链**，改动时自上而下保持一致：

1. `岗位.txt` — 18 个岗位官方链接，顺序即岗位编号 01–18（腾讯→字节→米哈游→拼多多）。
2. `岗位要求原文.md` — 18 个岗位的职责/要求/加分项原文（已删除工作年限）。**唯一事实来源**：任何"某岗位要求什么"的判断都回这里查证，不得凭印象补充 JD 未写的内容。
3. `岗位分析.md` — 分类、逐岗位解读、共性对比、公司特点、六项目映射。**所有决策的分析基础。**
4. `README-项目说明与当前方案.md` — 总入口，记录已确定的方案。

另有 `环境与踩坑记录.md`：三台机器的实际环境、代理机制差异、以及已经踩过的坑。**它不属于上面那条依据链**，是操作层的记录，动环境前必读。

岗位编号 01–18 在三份文件中严格对应，是跨文件引用的主键；调整时三份都要同步。

`岗位分析.md` 第五节与 README 第三节的六项目表格是重复表述，**改一处必须同步另一处**。

## 六个项目

| 原编号 | 仓库 | 对应岗位 | 分工模式 |
|---|---|---|---|
| ① | `tactical-shooter-ue` | 03、04，兼顾 12 | 混合：Claude 写 C++ / 用户在编辑器操作。**UE 5.6.1**，已安装 |
| ② | `coop-combat-unity` | 09 | 混合：同上。**Unity 2022.3.38f1c1**，已就绪 |
| ③ | `agent-ops-platform` | 05、07、10、11、14，**外加 08 作为子方向** | 偏产出：Claude 主写，用户做设计决策 |
| ④ | `agent-memory` | 01 | 偏产出：Claude 主写 + 设计问答文档 |
| ⑤ | `engine-core-labs` | 02 | 偏学习：Claude 写脚手架，核心算法用户实现 |
| ⑥ | `backend-cloud-labs` | 06、13、15、16、17 | 偏产出：拆成五个独立小实验 |

**③ 依赖 ④**：④ 以 API 服务形式提供记忆能力，③ 调用它。拆周计划或写技术方案时保持这条边界清晰，写明接口输入输出、调用时序、失败处理与集成验证。

**④ 不是从零开始**。它复用已存在的 `luckyrichor/agent-memory` 仓库（20+ 次提交的工程化骨架：多租户 RLS、事务 Outbox、租约 Job、不可覆盖版本），缺口是混合检索、生命周期管理、可观测性、SDK。动它之前先读 `agent-memory/CLAUDE.md`。

岗位 18（前端）明确不纳入实践。**岗位 08（字节 AI 全栈-客服平台）已于 2026-09-19 决定挂到 ③ `agent-ops-platform` 下作为子方向**，不新增第七个项目。

## 多机协作

**动环境之前先读 `环境与踩坑记录.md`** —— 三台机器的规格、已装工具、代理机制和已经踩过的坑都在那里，不要凭印象操作。

三台机器：Mac（本地）、`tx`（Ubuntu 24.04，常开，适合跑常驻服务）、`luowindows`（Windows 11，引擎唯一机器）。

### 五条硬规矩

1. **GitHub 是唯一事实源**。任何机器都只是工作副本。
2. **一个项目同一时间只在一台机器上改**。六个项目本就独立，不存在必须同机协作的场景。
3. **开工 `git pull`，收工 `git push`**，不留未推送的提交过夜。
4. **每个仓库自带一键重建环境**（`scripts/bootstrap.sh` + 锁文件）。换机器只跑这一条。
5. **密钥永不进仓库**。只放 `.env.example`；真值各机器本地维护（惯例：仓库内 `.local/`，已 gitignore）。

### 机器分工

| 项目 | Mac | tx | Windows |
|---|---|---|---|
| `tactical-shooter-ue` / `coop-combat-unity` | ✗ | ✗ | **唯一**（引擎只在那儿） |
| `agent-ops-platform` / `agent-memory` / `backend-cloud-labs` | ✓ | ✓ 推荐 | ✓ |
| `engine-core-labs` | ✓ | ✓ | ✓ |

tx 常开，适合让 ④ 的记忆 API 常驻，供 ③ 连接。引擎项目锁死 Windows。

### 三台机器的代理机制不一样

**不要拿一台的经验套另一台**（细节见 `环境与踩坑记录.md`）：

- **Mac**：Mihomo TUN，全局接管，ssh 也透明走代理
- **tx**：纯端口模式 + `.bashrc` 的环境变量，**只在交互式 shell 生效**；ssh 不读这些变量，是真直连
- **Windows**：Clash Verge TUN，依赖「服务模式」，服务没启用时整机域名访问全断

由此产生的一条操作要点：**远程非交互执行命令时默认没有代理**（`.bashrc` 早返回），需要代理的命令要显式 `export`。

### 跨平台细节

- 每个仓库都有 `.gitattributes` 强制 `eol=lf`，否则 Windows 与 Linux 来回切会产生满屏假 diff。
- ①② 必须开 **Git LFS**（Unity `.asset`/`.prefab`、UE `.uasset`/`.umap` 是二进制大文件）。建仓库时就配，事后补很麻烦。
- **在 Windows 上写文件绝不能带 BOM**，读 `.ps1` 则必须带 BOM —— 这条坑过两次，详见踩坑记录第 2 条。
- GitHub 账号统一 **luckyrichor**（`luckyrichor@gmail.com`），七个仓库全部 public，remote 全用 ssh。

## 节奏安排

每周投入 10–15 小时，13 周共约 130–195 小时，六条线并行。

**主力档轮转**：每周指定 1–2 个项目为主力（占当周 60–70% 时间），其余走维持档（1–2 小时，推进一小步并留记录）。每个里程碑标**预估工时**和**验收标准**。累计超出周预算时 `总节奏表.md` 直接显示赤字，**由用户决定砍什么，不要替他砍**。

进度记录写在**各项目仓库**的 `docs/progress.md`（跟着代码走不会漂移），汇总到本仓库的 `进度总览.md`。

## 写作与决策约束（用户明确要求，优先级高）

- **区分事实与推断**：JD 原文明确写的、与"行业常见要求/补充推断"必须显式区分，允许联网补充但要标注来源性质。
- **不夸大**：不把规划写成已完成成果，不把本地测试数据包装成生产规模，不把加分项改写为硬性门槛。
- **不预设降级**：⑤ 和 ⑥ 即使用户当下没时间反馈，也按既定方向持续推进产出，不因"时间可能不够"提前砍掉或缩水——取舍由用户自己做。
- **不安排模型算法、训练、微调、推理引擎优化方向的学习**。
- 不需要重新确认用户背景：Python 最熟练，C++/C#/Go 有基础，Agent 开发已较熟悉——直接进入引擎/框架层和有深度的工程问题，不安排语言零基础或 Agent 入门教程。
- **AI 产出的代码不等于可以写进简历**。用户要能在面试里讲清每个关键设计取舍，所以偏产出的项目要同步维护 `docs/design-decisions.md`。

## 待补充材料

`UnityGames` 参考项目用户尚未提供。在实际读到之前，**不得假设或杜撰其架构、内容或带做节奏**。

## 编辑惯例

- 文档顶部写明"来源核验日期/最后更新"，实质性修改时更新该日期。
- 中文正文；岗位条目标题格式为 `### NN 公司：岗位名` 与 `## 【岗位N】公司 - <链接标识>`。

## Docker 运行位置（用户明确要求）

**需要 Docker 时默认跑在 `tx` 服务器上**，不要在 Mac 或 Windows 上起容器。

确有必要在本地跑时，**必须先征得用户同意**，不要自行决定。

tx 上 `ubuntu` **已加入 `docker` 组**（2026-09-19），docker 命令不需要 `sudo`，Testcontainers 也可直接用。该机内存只有 7.5G，多个服务同时跑之前先看 `free -h`。

### 在 tx 上跑 Docker／测试前，必须先同步代码

本地改完直接去 tx 跑，而 tx 上还是旧代码 —— 结果是「测试通过」测的其实是旧版本，**这种假通过比失败更危险**。

用 `workplan-docs/scripts/run-on-tx.sh` 代替手工 ssh，它强制执行正确顺序：

```bash
bash workplan-docs/scripts/run-on-tx.sh agent-memory 'uv run pytest -q'
bash workplan-docs/scripts/run-on-tx.sh agent-memory 'docker compose up -d postgres'
```

它会：本地有未提交改动就拒绝 → push → tx pull → **校验两边哈希一致** → 才执行。哈希比对是最终判据，不是「命令有没有报错」。脚本还顺带剥掉了腾讯云登录横幅。

## 飞书文档：署名规范（Claude 与 Codex 都要遵守）

这台机器上 **Claude 和 Codex 都能以用户本人的身份**写飞书文档（走 `lark-channel` bridge 各自的 profile，`lark-cli docs +create --as user`）。文档作者都是 luochen，**光看作者分不出是谁写的**，所以靠正文首行的署名区分。

**每份文档的第一行必须是这样一行引用块**：

```markdown
> 🤖 **由 Claude Code 生成** · YYYY-MM-DD · 来源 `<仓库>@<短哈希>` · 工具 `lark-cli` profile `claude`
```

Codex 写的则是 `由 Codex 生成` 与 profile `codex`，其余格式一致。

三个字段都不是装饰：

- **谁写的** —— 出了问题知道找哪一边复盘
- **日期** —— 飞书的修改时间会被后续编辑覆盖，正文里这个是生成时点
- **来源仓库与提交哈希** —— 文档内容对应的是哪一版代码。**没有这个，文档过两周就无法判断是否已经过期**

### 位置：统一放「我的文档库」，不是云盘

飞书有两套系统，**别混**：**我的空间**（云盘 / Drive，文件夹树，链接 `/docx/…`）和**我的文档库**（个人知识库 / Wiki，节点树，链接 `/wiki/…`，有 `node_token` 与 `obj_token` 两个 token）。

**文档统一建在「我的文档库」**（`--space-id my_library`，2026-09-22 用户确认）。云盘只留文件类产物：导出的 PDF、截图、附件。

⚠️ 知识库里**没有纯文件夹** —— 当目录用的节点本身也是一篇（空）docx，靠嵌套形成层级。
⚠️ 很多 `drive` 命令不认 wiki 链接，会报 `not exist`；要底层资源先 `drive +inspect` 解包。

层级**按实际内容设计，不要套固定模板**。以后会有别的项目、别的类型的文档（学习笔记、调研、会议记录……），该怎么分就怎么分；**拿不准就在创建前的确认环节一起问用户**——要新建哪几层，也是要确认的内容之一。

**只建当前用得上的层级**，不要预先把空节点铺开：空节点就是一篇空文档，建一堆是噪声。**先 `wiki +node-list` 看有没有，已存在就复用。**

本仓库当前的实例（`my_library` 下）：

```
WorkPlan/
└── agent-memory/
    └── agent-memory 评审处置表（2026-09-22）
```

其余五个项目和「计划层」等用到时再建。

### 写入前必须先问

**以用户名义创建飞书文档前，先在对话里说明标题、大纲、以及放在哪个文件夹（含要新建哪几层），得到确认再写。** 新建文件夹同样要先确认。 仓库内的日常记录（`docs/progress.md`、`AGENTS.md` 等）不在此列，照常直接写。

理由：飞书文档是以用户本人身份创建的对外产物，未经确认就发出去，等于替他做了外发决定。

### 操作要点

```bash
export PATH="/home/ubuntu/.nvm/versions/node/v24.21.0/bin:$PATH"
export LARKSUITE_CLI_CONFIG_DIR=/home/ubuntu/.lark-channel/profiles/<profile>/lark-cli/lark-channel

lark-cli wiki +node-list --space-id my_library --as user                    # 先看层级
lark-cli wiki +node-create --space-id my_library --parent-node-token <父> \
  --title "<名字>" --obj-type docx --as user                                # 缺层级才建
lark-cli docs +create --as user --parent-token <节点token> \
  --title "<标题>" --content @./f.md --doc-format markdown                   # 一次建到位
```

- `LARKSUITE_CLI_CONFIG_DIR` 不指到 profile 目录就会报 `not configured`
- `--as user` 作者才是用户本人，`--as bot` 作者是机器人
- `--content @file` **只接受 cwd 下的相对路径**，绝对路径报 `unsafe file path`；用完清理
- 用户授权（`auth login`）与策略开关（`config strict-mode`）**属于用户自己的操作**，agent 不得代劳。［实测 2026-09-22］这类命令会被 Claude 的权限层直接拦下，拦得对。

## 记录规范：新内容写到哪儿

**本仓库的正文只维护 `AGENTS.md` 一份**，`CLAUDE.md` 永远只是几行指路。两份都写正文必然漂移，**不要往 `CLAUDE.md` 里加任何内容**。

| 内容类型 | 去处 |
|---|---|
| 本仓库的指引、约定、边界、分工方式 | 本仓库 `AGENTS.md` |
| 环境、机器、工具链、跨平台的坑 | `workplan-docs/环境与踩坑记录.md` |
| 已经发生的进展、验证结果、失败与返工 | 本仓库 `docs/progress.md` |
| 关键设计取舍及其理由（面试要讲的） | 本仓库 `docs/design-decisions.md` |
| 排期、工时预算、里程碑 | `workplan-docs/总节奏表.md` |
| 岗位要求本身 | `workplan-docs/岗位要求原文.md`（唯一事实来源，不要在别处改写） |

写进「环境与踩坑记录」时，用 **［实测］**／**［预警］** 标注区分「已验证的事实」和「未触发的已知风险」，不要把推断写成结论。
