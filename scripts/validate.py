#!/usr/bin/env python3
"""Validate this repository's Agent Skills and Claude Code plugin manifests.

Pure standard library only: no PyYAML, no pip install, works offline.
Run: python scripts/validate.py
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
SKILLS_DIR = ROOT / "skills"
NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
PLACEHOLDER_RE = re.compile(
    r"YOUR_GITHUB_USERNAME|<user>|<username>|your-username|example\.com/[^\s]*/startup",
    re.IGNORECASE,
)
README_FILES = ("README.md", "README.zh-CN.md")

# Key figures that must stay identical across the EN and ZH scripts.
SHARED_MARKERS = (
    "0.5%-2%",
    "1%-3%",
    "10%-20%",
    "30,000",
    "250",
    "105",
    "15%",
    "¥50",
    "180",
)

errors = []
warnings = []


def strip_quotes(value):
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
        return value[1:-1]
    return value


def parse_frontmatter(text):
    """Minimal YAML frontmatter reader for the flat maps used by SKILL.md."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None
    end = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end = i
            break
    if end is None:
        return None

    data = {}
    section = None
    for line in lines[1:end]:
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if line.startswith((" ", "\t")) and section:
            key, sep, value = line.strip().partition(":")
            if sep:
                data[section][key.strip()] = strip_quotes(value.strip())
            continue
        key, sep, value = line.partition(":")
        if not sep:
            continue
        key = key.strip()
        value = strip_quotes(value.strip())
        if key == "metadata" and value == "":
            data[key] = {}
            section = key
        else:
            data[key] = value
            section = None
    return data


def load_json(rel_path):
    path = ROOT / rel_path
    if not path.is_file():
        errors.append("Missing file: %s" % rel_path)
        return None
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (ValueError, OSError) as exc:
        errors.append("Invalid JSON in %s: %s" % (rel_path, exc))
        return None


# --- 1. Validate every skill directory -------------------------------------
skill_dirs = sorted(p for p in SKILLS_DIR.iterdir() if p.is_dir()) if SKILLS_DIR.is_dir() else []
if not skill_dirs:
    errors.append("No skill directories found under skills/")

for skill_dir in skill_dirs:
    name = skill_dir.name
    skill_md = skill_dir / "SKILL.md"
    label = "skills/%s/SKILL.md" % name
    if not skill_md.is_file():
        errors.append("Missing %s" % label)
        continue

    text = skill_md.read_text(encoding="utf-8")
    fm = parse_frontmatter(text)
    if fm is None:
        errors.append("%s: missing or unclosed YAML frontmatter" % label)
        continue

    fm_name = fm.get("name", "")
    if not fm_name:
        errors.append("%s: frontmatter field 'name' is required" % label)
    else:
        if not NAME_RE.match(fm_name):
            errors.append("%s: name '%s' must be lowercase kebab-case" % (label, fm_name))
        if len(fm_name) > 64:
            errors.append("%s: name exceeds 64 characters" % label)
        if fm_name != name:
            errors.append("%s: name '%s' does not match directory '%s'" % (label, fm_name, name))

    description = fm.get("description", "")
    if not description:
        errors.append("%s: frontmatter field 'description' is required" % label)
    elif len(description) > 1024:
        errors.append("%s: description exceeds 1024 characters" % label)

    compatibility = fm.get("compatibility", "")
    if compatibility and len(compatibility) > 500:
        errors.append("%s: compatibility exceeds 500 characters" % label)

    line_count = len(text.splitlines())
    if line_count >= 500:
        warnings.append("%s: %d lines; consider moving detail into references/" % (label, line_count))

    missing = [m for m in SHARED_MARKERS if m not in text]
    if missing:
        errors.append("%s: key benchmark data missing: %s" % (label, ", ".join(missing)))
    else:
        print("  OK  %-28s %3d lines, %d benchmark markers" % (name, line_count, len(SHARED_MARKERS)))

# --- 2. Validate Claude Code plugin manifests ------------------------------
plugin = load_json(".claude-plugin/plugin.json")
marketplace = load_json(".claude-plugin/marketplace.json")

if plugin:
    if not plugin.get("name"):
        errors.append(".claude-plugin/plugin.json: 'name' is required")
    print("  OK  plugin.json name=%s version=%s" % (plugin.get("name"), plugin.get("version")))

if marketplace:
    if not marketplace.get("name"):
        errors.append(".claude-plugin/marketplace.json: 'name' is required")
    if not marketplace.get("owner"):
        errors.append(".claude-plugin/marketplace.json: 'owner' is required")
    entries = marketplace.get("plugins")
    if not isinstance(entries, list) or not entries:
        errors.append(".claude-plugin/marketplace.json: 'plugins' must be a non-empty array")
    else:
        entry = entries[0]
        if plugin and entry.get("name") != plugin.get("name"):
            errors.append("marketplace entry name must match plugin.json name")
        if plugin and entry.get("version") != plugin.get("version"):
            errors.append(
                "version mismatch: plugin.json=%s marketplace.json=%s"
                % (plugin.get("version"), entry.get("version"))
            )
        if entry.get("source") != "./":
            warnings.append("marketplace entry source is '%s'; './' is expected for a self-hosted repo" % entry.get("source"))
        print("  OK  marketplace.json name=%s source=%s" % (marketplace.get("name"), entry.get("source")))

# --- 3. Repository hygiene -------------------------------------------------
for rel in README_FILES + ("LICENSE", "scripts/install.sh", "scripts/install.ps1"):
    if not (ROOT / rel).is_file():
        errors.append("Missing repository file: %s" % rel)

# No leftover username / repo placeholders in any published document.
for rel in (
    ".claude-plugin/plugin.json",
    ".claude-plugin/marketplace.json",
    "LICENSE",
) + README_FILES + tuple(
    "skills/%s/SKILL.md" % p.name for p in skill_dirs
):
    path = ROOT / rel
    if not path.is_file():
        continue
    hit = PLACEHOLDER_RE.search(path.read_text(encoding="utf-8"))
    if hit:
        errors.append("%s: unresolved placeholder %r" % (rel, hit.group(0)))

# Both READMEs must link to each other (the language switcher), including a
# plain-text fallback for users who cannot load the badge images.
for rel, other in (("README.md", "README.zh-CN.md"), ("README.zh-CN.md", "README.md")):
    path = ROOT / rel
    if not path.is_file():
        continue
    text = path.read_text(encoding="utf-8")
    has_badge = 'href="%s"' % other in text
    has_text_link = "](%s)" % other in text
    if not (has_badge and has_text_link):
        errors.append(
            "%s: language switcher must have both a button link and a text link to %s"
            % (rel, other)
        )
    else:
        print("  OK  %-20s language switch -> %s" % (rel, other))

# Install instructions in both languages must point at the repository declared
# in plugin.json, not at the old placeholder / a stale repo name.
if plugin:
    repo_slug = urlparse(plugin.get("repository", "")).path.strip("/")
    if repo_slug.endswith(".git"):
        repo_slug = repo_slug[:-4]
    if repo_slug:
        for rel in README_FILES:
            path = ROOT / rel
            if not path.is_file():
                continue
            text = path.read_text(encoding="utf-8")
            slugs = set(re.findall(r"plugin marketplace add ([^\s`]+)", text)) - {"...", "…"}
            if not slugs:
                errors.append("%s: missing 'claude plugin marketplace add <owner/repo>'" % rel)
            elif slugs != {repo_slug}:
                errors.append(
                    "%s: install command points at %s, expected %s"
                    % (rel, ", ".join(sorted(slugs)), repo_slug)
                )
            if "git clone https://github.com/%s.git" % repo_slug not in text:
                warnings.append("%s: missing git clone command for %s" % (rel, repo_slug))
            else:
                print("  OK  %-20s install commands -> %s" % (rel, repo_slug))

# --- 4. Report -------------------------------------------------------------
print()
for msg in warnings:
    print("  WARN  %s" % msg)
for msg in errors:
    print("  FAIL  %s" % msg)

if errors:
    print("\nValidation FAILED: %d error(s), %d warning(s)." % (len(errors), len(warnings)))
    sys.exit(1)

print("Validation passed: %d skill(s), 0 error(s), %d warning(s)." % (len(skill_dirs), len(warnings)))
