#!/usr/bin/env bash
# Install the Startup Stress Test skills into local agent skill directories.
# Works on macOS, Linux and Git Bash on Windows.
#
# Usage:
#   ./scripts/install.sh [options]
#
# Options:
#   --target LIST     Comma-separated: claude-code, codex, copilot, agents, all
#                     (default: claude-code,codex)
#   --scope NAME      user | project (default: user)
#   --lang NAME       en | zh | both (default: both)
#   --project-root D  Project root used by --scope project (default: current dir)
#   --force           Replace an existing install (backs it up first)
#   --dry-run         Print what would happen without changing anything
#   -h, --help        Show this help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

TARGETS="claude-code,codex"
SCOPE="user"
LANG="both"
PROJECT_ROOT="$PWD"
FORCE=0
DRY_RUN=0

usage() {
  awk 'NR > 1 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "$0"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)       TARGETS="$2"; shift 2 ;;
    --scope)        SCOPE="$2"; shift 2 ;;
    --lang)         LANG="$2"; shift 2 ;;
    --project-root) PROJECT_ROOT="$2"; shift 2 ;;
    --force)        FORCE=1; shift ;;
    --dry-run)      DRY_RUN=1; shift ;;
    -h|--help)      usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

case "$SCOPE" in
  user|project) ;;
  *) echo "Invalid --scope '$SCOPE' (expected: user | project)" >&2; exit 1 ;;
esac

case "$LANG" in
  en)  SKILL_NAMES=(startup-stress-test) ;;
  zh)  SKILL_NAMES=(startup-stress-test-zh) ;;
  both) SKILL_NAMES=(startup-stress-test startup-stress-test-zh) ;;
  *) echo "Invalid --lang '$LANG' (expected: en | zh | both)" >&2; exit 1 ;;
esac

[[ "$TARGETS" == "all" ]] && TARGETS="claude-code,codex,copilot"
IFS=',' read -ra TARGET_LIST <<< "$TARGETS"

declare -a DEST_ROOTS=()

for target in "${TARGET_LIST[@]}"; do
  target="$(echo "$target" | tr -d '[:space:]')"
  [[ -z "$target" ]] && continue
  case "$target" in
    claude-code)
      if [[ "$SCOPE" == "user" ]]; then DEST_ROOTS+=("$HOME/.claude/skills")
      else DEST_ROOTS+=("$PROJECT_ROOT/.claude/skills"); fi ;;
    codex|agents)
      if [[ "$SCOPE" == "user" ]]; then DEST_ROOTS+=("$HOME/.agents/skills")
      else DEST_ROOTS+=("$PROJECT_ROOT/.agents/skills"); fi ;;
    copilot)
      if [[ "$SCOPE" == "user" ]]; then
        echo "Note: GitHub Copilot skills are project-scoped; skipping user scope for 'copilot'." >&2
      else
        DEST_ROOTS+=("$PROJECT_ROOT/.github/skills")
      fi ;;
    *) echo "Unknown --target '$target'" >&2; exit 1 ;;
  esac
done

# Deduplicate destination roots while preserving order (bash 3.2 compatible).
UNIQUE_ROOTS=()
for root in "${DEST_ROOTS[@]}"; do
  duplicate=0
  for seen in "${UNIQUE_ROOTS[@]}"; do
    if [[ "$seen" == "$root" ]]; then duplicate=1; break; fi
  done
  [[ $duplicate -eq 0 ]] && UNIQUE_ROOTS+=("$root")
done

echo "Repository : $REPO_ROOT"
echo "Scope      : $SCOPE"
echo "Languages  : $LANG (${SKILL_NAMES[*]})"
echo "Targets    : ${UNIQUE_ROOTS[*]}"
[[ $DRY_RUN -eq 1 ]] && echo "Mode       : DRY RUN (no changes)"
echo

STAMP="$(date +%Y%m%d%H%M%S)"
INSTALLED=0

for dest_root in "${UNIQUE_ROOTS[@]}"; do
  for name in "${SKILL_NAMES[@]}"; do
    src="$SKILLS_DIR/$name"
    dest="$dest_root/$name"

    if [[ ! -d "$src" || ! -f "$src/SKILL.md" ]]; then
      echo "ERROR: missing skill source: $src/SKILL.md" >&2
      exit 1
    fi

    if [[ -e "$dest" ]]; then
      if [[ $FORCE -eq 0 ]]; then
        echo "SKIP  $dest (already exists; use --force to replace)"
        continue
      fi
      backup="${dest}.bak.${STAMP}"
      echo "BACKUP $dest -> $backup"
      if [[ $DRY_RUN -eq 0 ]]; then mv "$dest" "$backup"; fi
    fi

    echo "INSTALL $src -> $dest"
    if [[ $DRY_RUN -eq 0 ]]; then
      mkdir -p "$dest_root"
      cp -R "$src" "$dest"
    fi
    INSTALLED=$((INSTALLED + 1))
  done
done

echo
if [[ $DRY_RUN -eq 1 ]]; then
  echo "Dry run complete: $INSTALLED install(s) planned."
else
  echo "Done: $INSTALLED install(s). Restart your agent (or run /reload-plugins in Claude Code) to pick up the skills."
  echo "Claude Code: /startup-stress-test or just describe your startup idea."
  echo "Codex CLI  : \$startup-stress-test (or let it match your prompt automatically)."
fi
