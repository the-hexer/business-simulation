# Startup Stress Test

<div align="right">
  <a href="README.md"><img src="https://img.shields.io/badge/EN-English-0969da?style=flat-square" alt="EN: English"></a>
  <a href="README.zh-CN.md"><img src="https://img.shields.io/badge/ZH-%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-6e7781?style=flat-square" alt="ZH: 简体中文"></a>
</div>

Language: **English (default)** · [简体中文](README.zh-CN.md)

> Throw your startup idea into the most unforgiving market data you can find, and see whether it survives 180 days.

This is a Skill you install into an AI coding agent. Describe a business idea, and it becomes a calm, blunt **"Startup Stress Tester"** that uses median-to-pessimistic industry benchmarks to walk your idea from Day 1 to Day 180: finding users, launching, watching what real users actually do, running the cash-flow numbers, and finally forcing a decision before the money runs out.

It does not write a business plan and it does not cheer you on. It does exactly one thing: **surface the fatal problems while you still do not have to pay for them in real life.**

---

## What you get

- **Your assumptions taken apart**: the core value proposition, value proposition canvases for 8 candidate segments, and 3 user personas tagged with their "decision blockers"
- **Numbers with no sugar-coating**: cold-start traffic, conversion funnel, CAC, churn, initial capital, monthly burn, remaining runway and MRR — laid open at every key milestone
- **A story you actually steer**: at key decisions it pauses and offers A/B/C options, but also accepts a plan you write yourself; your plan gets assessed for feasibility, cost, risk and odds of success before the next stage is simulated
- **A retrospective you can take away**: focused on *why traffic is hard* and *why paid conversion is low*, with things you can do tomorrow — not "go optimize the product"

**A taste of the output** (excerpt; the actual run changes with your choices):

> **[Day 90]** "Fast-forward 90 days. Total post impressions: 30,000; total link clicks: 300 (1% CTR). Unique visitors who actually reached the site: 250. After browsing, **5 of them** completed sign-up. **Website sign-up conversion rate: 2%**. That is our entire initial user base."
>
> **[Day 91]** "In the first week after launch, **user retention: 0%**. **Paid conversion: 0%**. This is a typical — and severe — start."
>
> **[Day 180]** Business Health Dashboard: 105 total users / 1 paying user / MRR ¥50 / monthly churn 15% / remaining runway likely under 2 months — "You must choose before the company dies: persevere, pivot, or shut down."

**What it is not for**: writing code, producing a technical design, generating market research reports, or drafting an investor deck. It is an adversarial business simulation, not a deliverable generator.

---

## Three steps to start

1. **Install it** (pick one method below; takes a minute or two)
2. **State your idea in one sentence**, e.g. *"I want to build an AI code-review SaaS for indie developers at ¥50/month"*
3. **Make the choices** — it stops and waits for you at decision points, and never decides on your behalf

You do not need to remember a command afterwards: simply describing your idea triggers it. You can also invoke it explicitly:

| Agent | Explicit invocation |
| --- | --- |
| Claude Code | `/startup-stress-test` (English) or `/startup-stress-test-zh` (Chinese) |
| Codex CLI | `$startup-stress-test` / `$startup-stress-test-zh` |

The output language follows the language you ask in; the underlying data is identical either way.

---

## Install

### Claude Code: two commands (recommended)

```bash
claude plugin marketplace add the-hexer/business-simulation
claude plugin install startup-stress-test@startup-stress-test-marketplace
```

Inside a Claude Code session you can also use `/plugin marketplace add the-hexer/business-simulation` and `/plugin install startup-stress-test@startup-stress-test-marketplace`. Both the English and the Chinese Skill are installed together.

### Other agents: the installer script

The script lives in this repository, so clone it first:

```bash
# macOS / Linux / Git Bash on Windows
git clone https://github.com/the-hexer/business-simulation.git
cd business-simulation
./scripts/install.sh --target claude-code,codex --scope user --lang both
```

```powershell
# Windows PowerShell
git clone https://github.com/the-hexer/business-simulation.git
cd business-simulation
.\scripts\install.ps1 -Target claude-code,codex -Scope user -Lang both
```

Useful variants: `--lang en` for English only, `--scope project` to install into the current project, `--dry-run` to preview every path before anything is touched. Run `./scripts/install.sh --help` for the full option list. The script only copies folders — it executes no remote code — and backs up an existing install before overwriting it.

### Any compatible agent: just copy the folder

Copy the whole `skills/startup-stress-test/` or `skills/startup-stress-test-zh/` directory to the matching location:

| Agent | User scope | Project scope |
| --- | --- | --- |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex CLI / Cursor / Amp | `~/.agents/skills/` | `.agents/skills/` |
| GitHub Copilot | — | `.github/skills/` |

Each Skill is **self-contained** — the entire script is inside `SKILL.md`, so it works immediately with no extra files. Restart your agent afterwards (`/reload-plugins` works in Claude Code).

---

## What one simulation looks like

| When | Stage | What happens |
| --- | --- | --- |
| Before starting | Fact check | Extracts factual claims from your idea and verifies them; asks you before proceeding if anything looks off |
| Day 1–5 | A harsh market audit | Deconstructs the value proposition → canvases for 8 segments (focused on monetisation difficulty and acquisition barriers) → 3 personas (price sensitivity, loyalty to existing tools, scepticism toward newcomers) |
| Day 90 | Launch and first data | MVP goes live with initial capital / burn / runway; one cold-start community push produces real traffic and sign-up numbers |
| Day 91 | Indifference and churn | Follows those few users individually to see retention and paid conversion |
| Day 180 | Judgment day | Spends the remaining funds on paid acquisition, shows the Business Health Dashboard, and forces a persevere / pivot / shut-down call before cash hits zero |
| End | Retrospective | Root-cause analysis, concrete next actions, and the option to restart carrying this run's scars |

### About "it stops and waits for you"

The simulator does not invent a smooth success story. At decision points — which segments to chase, what to do about dismal numbers, how to handle a cash-flow warning — it pauses, offers A/B/C options, **and lets you write your own plan as free-form text**. Your plan is quickly assessed (feasibility; time, money and manpower cost; potential risks; probability of success), then its impact on cash, morale and reputation is calculated into the next stage. Overly idealistic ideas ("make it go viral overnight") get explicit negative feedback and a very low success probability.

---

## Why the numbers are so brutal

Because they deliberately use industry medians or worse, to counter survivorship bias:

| Metric | Benchmark |
| --- | --- |
| Cold-start community CTR | 0.5%–2% |
| Site visit → sign-up | 1%–3% |
| Free → paid (SaaS / content products) | 0.5%–2% ← the financial bottleneck of the whole simulation |
| Early-stage monthly churn | 10%–20% |
| CAC | Set high for the industry (tens to hundreds of yuan B2C, thousands B2B) |

Amounts stay in `¥` as in the original prompt — converting them to USD would change what the numbers mean. To tailor the simulation to your market, edit these figures and example amounts directly in `SKILL.md`; **keep the English and Chinese copies in sync afterwards**.

---

## Which language version?

| Skill | Language | Best for |
| --- | --- | --- |
| `startup-stress-test` | English | English-speaking teams, sharing the simulation with international colleagues |
| `startup-stress-test-zh` | 简体中文 | Ideas and discussions in Chinese |

Both scripts share the same structure, stages and data; only the language differs. Installing both is fine — the agent picks based on the language of your prompt. If you want just one, use `--lang en` or `--lang zh`.

---

## FAQ

**Does it need internet access?** No. With search tools available it verifies factual claims in your idea and looks up industry data to refine the benchmarks; without them the full simulation still runs, just with a lighter fact-check step.

**Is it negative the whole time?** It stays blunt, but the goal is to expose problems, not to dismiss you. The final stage always gives targeted, actionable advice — for example "put up a pre-sale page before writing the first line of code and see if anyone will pay a ¥10 deposit".

**Will it change my files, run commands or send requests?** No. This is a pure instruction Skill that only outputs a text simulation. The installer script is the only thing that touches files, and it only copies Skill folders.

**I installed it but nothing happens.** Restart your agent, or run `/reload-plugins` in Claude Code; in Codex you can invoke `$startup-stress-test` explicitly. Making your idea more concrete also helps triggering.

**Can I change direction mid-run or start over?** Yes. Your choices change what happens next, and after the retrospective you can restart carrying the lessons from this run.

**Which agents are supported?** Anything following the [agentskills.io](https://agentskills.io/specification) specification. Verified paths are listed above: Claude Code, Codex CLI, GitHub Copilot, Cursor / Amp and others.

---

## Credits

The original startup simulation prompt comes from [easychen/opc-methodology](https://github.com/easychen/opc-methodology) (《一人企业方法论》, the One-Person Company methodology). This project repackages it as installable Agent Skills and adds an English version plus multi-agent installers.

---

## Maintainer notes

The repository is published at [the-hexer/business-simulation](https://github.com/the-hexer/business-simulation) (public, default branch `main`). `.claude-plugin/` must stay at the repository root or `/plugin marketplace add` cannot find the manifest. `README.md` is the default English document and `README.zh-CN.md` is the Chinese one; keep the language-switch links in both files. After changing content, bump `version` in both JSON manifests in sync (Claude Code uses it to decide whether to push an update). Local check: `python scripts/validate.py` (pure standard library, works offline); CI re-checks that the key figures in both scripts still match on every push and PR.

MIT © 2026 the-hexer · see [LICENSE](LICENSE)
