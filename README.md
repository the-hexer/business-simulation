# 创业压力测试 · Startup Stress Test

> 把你的创业想法扔进最真实的市场数据里，看它能不能活过 180 天。

这是一个装进 AI 编程助手里的 Skill。你描述一个创业点子，它会扮演一位冷静、直言不讳的「创业压力测试员」，用行业中位数甚至偏下的悲观数据，陪你把想法从 Day 1 推演到 Day 180：找用户、上线、看真实用户行为、算现金流，直到钱快烧完时逼你做选择。

它不写商业计划书，也不给你打气。它做的事只有一件：**在你还不需要付出真实代价的时候，把致命问题提前暴露出来。**

---

## 你会得到什么

- **一份被拆解过的假设**：核心价值主张、8 个候选用户群的价值主张画布、3 个带「决策障碍」标签的用户画像
- **一组不留情面的数字**：冷启动流量、转化漏斗、CAC、流失率、初始资金、月度燃烧率、剩余跑道、MRR，每个关键节点都摊开给你看
- **真正由你决定的走向**：关键决策点会停下来给 A/B/C 选项，也接受你自己写的方案；你的方案会被评估可行性、成本、风险和成功概率，再推演下一阶段
- **一次可带走的复盘**：重点分析「流量为什么难」和「付费转化为什么低」，给出能马上做的动作，而不是「再优化一下产品」

**效果预览**（节选，实际输出会随你的选择变化）：

> **【Day 90】** "时间快进 90 天……帖子总曝光 30,000 次，链接总点击 300 次（点击率 1%）。最终抵达网站的独立访客 250 人。经过浏览，其中 **5 人** 完成了注册。**网站注册转化率：2%**。这就是我们全部的初始用户。"
>
> **【Day 91】** "上线第一周，**用户留存率：0%**。**付费转化：0%**。这是一个典型且严峻的开局。"
>
> **【Day 180】** 商业健康度仪表盘：总用户 105 人 / 付费用户 1 人 / MRR ¥50 / 月流失率 15% / 剩余跑道可能已不足 2 个月 —— "你必须在公司倒闭前做出选择：坚持、转型、关闭。"

**它不适合**：写代码、出技术实现方案、做市场调研报告、写融资 BP。它是一次对抗性的商业推演，不是交付物生成器。

---

## 三步开始

1. **装好**（下面挑一种方式，一两分钟）
2. **说一句你的想法**，例如：*「我想做一个面向独立开发者的 AI 代码审查 SaaS，订阅 ¥50/月」*
3. **跟着它做选择** —— 遇到决策点它会停下等你，不会替你决定

装好后不需要记命令：直接描述想法就会自动触发。也可以显式调用：

| Agent | 显式调用 |
| --- | --- |
| Claude Code | `/startup-stress-test`（英文）或 `/startup-stress-test-zh`（中文） |
| Codex CLI | `$startup-stress-test` / `$startup-stress-test-zh` |

输出语言跟随你的提问：用中文问就得到中文推演，用英文问就得到英文推演，数据不变。

---

## 安装

### Claude Code：两条命令（推荐）

```bash
claude plugin marketplace add the-hexer/business-simulation
claude plugin install startup-stress-test@startup-stress-test-marketplace
```

在 Claude Code 会话里也可以用 `/plugin marketplace add ...` 和 `/plugin install ...`。中英两个 Skill 会一起装上。

### 其他 agent：安装脚本

```bash
# macOS / Linux / Windows Git Bash
./scripts/install.sh --target claude-code,codex --scope user --lang both
```

```powershell
# Windows PowerShell
.\scripts\install.ps1 -Target claude-code,codex -Scope user -Lang both
```

常用变体：只想装中文加 `--lang zh`、装到当前项目加 `--scope project`、先看看会改哪些文件加 `--dry-run`。完整参数用 `./scripts/install.sh --help` 查看。脚本只复制文件夹，不会执行任何远程代码；覆盖已有安装时会自动先备份。

### 任何兼容 agent：直接复制目录

把 `skills/startup-stress-test/` 或 `skills/startup-stress-test-zh/` 整个文件夹复制到对应位置：

| Agent | 用户级 | 项目级 |
| --- | --- | --- |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex CLI / Cursor / Amp | `~/.agents/skills/` | `.agents/skills/` |
| GitHub Copilot | — | `.github/skills/` |

两个 Skill 各自**自包含**——剧本全文就在 `SKILL.md` 里，复制完立刻可用，不需要额外文件。装完重启 agent（Claude Code 可执行 `/reload-plugins`）。

---

## 一次模拟会经历什么

| 时间 | 阶段 | 会发生什么 |
| --- | --- | --- |
| 开始前 | 事实校验 | 提取你想法里的事实性描述并核对，有疑点先找你确认 |
| Day 1–5 | 严酷的市场审视 | 解构价值主张 → 8 个用户群的画布（重点看变现难度和获客壁垒）→ 3 个用户画像（标注价格敏感度、对现有工具的忠诚度、对新品的怀疑） |
| Day 90 | 上线即挑战 | MVP 上线，展示初始资金 / 燃烧率 / 跑道；一次社区冷启动后给出真实流量与注册数据 |
| Day 91 | 用户冷漠与流失 | 逐个追踪那几位用户的真实行为，看留存和付费转化 |
| Day 180 | 审判日 | 投入剩余资金做付费推广，给出商业健康度仪表盘，逼你在现金流耗尽前选择坚持 / 转型 / 关闭 |
| 结束 | 复盘与迭代 | 分析根因、给可执行建议，并提供带着这次教训重启模拟的选项 |

### 关于「停下来等你」

模拟器不会一路顺风地编故事。遇到「选哪些细分客户」「惨淡数据怎么办」「现金流预警」这类节点，它会暂停、给出 A/B/C 选项，**同时允许你直接用开放式文本写自己的方案**。你的方案会被快速评估（可行性、时间与金钱与人力成本、潜在风险、成功概率），再演算对现金、士气、声誉的影响。想法过于理想化（比如「让产品一夜爆红」）会收到明确的负面反馈和很低的成功率。

---

## 为什么数据这么「残酷」

因为它刻意取行业中位数甚至偏下的悲观值，用来对抗幸存者偏差：

| 指标 | 基准 |
| --- | --- |
| 社区冷启动点击率 | 0.5%–2% |
| 网站访问 → 注册 | 1%–3% |
| 免费 → 付费（SaaS / 内容产品） | 0.5%–2% ← 整个模拟的财务瓶颈 |
| 早期月流失率 | 10%–20% |
| CAC | 按行业设定高昂值（B2C 数十至数百元，B2B 数千元） |

金额沿用原文的 `¥`。想让模拟更贴近你的市场，可以直接编辑 `SKILL.md` 里的这些数字和示例金额；**改完记得中英两份保持同步**。

---

## 中英版本怎么选

| Skill | 语言 | 适合 |
| --- | --- | --- |
| `startup-stress-test` | English | 英文工作环境、需要把推演结果发给国际团队 |
| `startup-stress-test-zh` | 简体中文 | 中文想法、中文讨论 |

两份剧本结构、阶段、数据完全一致，只是语言不同。默认两个都装也没问题，agent 会按你的提问语言匹配；只想要一个的话，安装时加 `--lang en` 或 `--lang zh`。

---

## 常见问题

**需要联网吗？** 不强制。有搜索工具时，它会先核对想法里的事实描述、查行业数据来优化基准；没有搜索工具也能完整跑完，只是事实校验环节会简化。

**它会不会一直泼冷水？** 会一直直言不讳，但目标是暴露问题而不是否定你。最后一阶段一定给针对性的、可操作的建议，例如「写第一行代码前先做预售页，看有没有人愿意付 10 元定金」。

**会改我的文件、执行命令或发请求吗？** 不会。这是纯指令型 Skill，只输出文字推演；安装脚本是唯一会动文件的东西，且只复制 Skill 文件夹。

**装了却没反应？** 重启 agent，或在 Claude Code 里执行 `/reload-plugins`；Codex 可用 `$startup-stress-test` 显式调用。也可以直接把想法说得更具体一些，更容易触发。

**能中途换方向或重来吗？** 能。你的选择会改变后续剧情；模拟结束后可以带着这次的「伤疤」和教训重新开始。

**支持哪些 agent？** 遵循 [agentskills.io](https://agentskills.io/specification) 规范的都支持，已验证的安装路径见上表：Claude Code、Codex CLI、GitHub Copilot、Cursor / Amp 等。

---

## English (quick start)

A bilingual Agent Skill that runs a pessimistic, data-driven 180-day startup simulation with interactive decision points. Install, then simply describe your idea.

```bash
claude plugin marketplace add the-hexer/business-simulation
claude plugin install startup-stress-test@startup-stress-test-marketplace

# or for any compatible agent
./scripts/install.sh --target claude-code,codex --scope user --lang en
```

Skill locations: `~/.claude/skills/` (Claude Code), `~/.agents/skills/` (Codex / Cursor / Amp), `.github/skills/` (Copilot, project-scoped).

---

## 致谢

原始创业模拟提示词来自 [easychen/opc-methodology](https://github.com/easychen/opc-methodology)（《一人企业方法论》）。本项目在其基础上整理为可安装的 Agent Skills，补充英文版本与多 agent 安装方式。

---

## 维护者备注

本仓库已发布为 [the-hexer/business-simulation](https://github.com/the-hexer/business-simulation)（public，默认分支 `main`）。`.claude-plugin/` 必须保持在仓库根目录，否则 `/plugin marketplace add` 找不到清单。改动内容后同步 bump 两个 JSON 里的 `version`（Claude Code 靠版本号判断是否需要推送更新）。本地校验：`python scripts/validate.py`（纯标准库、离线可跑）；CI 会在每次 push / PR 自动检查两份剧本的关键数据是否一致。

MIT © 2026 the-hexer · 见 [LICENSE](LICENSE)
