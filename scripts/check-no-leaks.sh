#!/usr/bin/env bash
# Fails if the plugin repo contains anything other than config, skill text and
# docs, or anything that looks like engine code or data, internal
# infrastructure or a secret. Everyone who installs the plugin can read this
# repo, so this script holds only generic patterns. Patterns that would name
# private things themselves come from the LEAK_EXTRA_PATTERNS environment
# variable (one extended regex per line): a repository secret in CI, a local
# file for maintainers. CI fails if they are missing.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
report() { echo "LEAK-CHECK FAIL: $*" >&2; fail=1; }

# 1. Allow-list of tracked files.
allowed='^(\.claude-plugin/marketplace\.json|plugins/emodely-engine/\.claude-plugin/plugin\.json|plugins/emodely-engine/\.mcp\.json|plugins/emodely-engine/skills/[a-z0-9-]+/SKILL\.md|README\.md|LICENSE|docs/[a-z0-9-]+\.md|scripts/check-no-leaks\.sh|scripts/package-plugin\.sh|\.github/workflows/[a-z0-9-]+\.yml|\.gitignore|\.gitattributes)$'
while IFS= read -r f; do
  [[ "$f" =~ $allowed ]] || report "file not on the allow-list: $f"
done < <(git ls-files)

# 2. The plugin's only component config: exactly one MCP server, the public
#    engine endpoint, with no headers; the manifest declares no components.
py=python3; "$py" -c 1 2>/dev/null || py=python
"$py" - <<'PY' || report "MCP server map or plugin manifest is not exactly the approved config"
import json, sys
mcp = json.load(open("plugins/emodely-engine/.mcp.json", encoding="utf-8"))
ok = mcp == {"mcpServers": {"emodely-engine": {"type": "http", "url": "https://engine.emodely.com/mcp"}}}
manifest = json.load(open("plugins/emodely-engine/.claude-plugin/plugin.json", encoding="utf-8"))
allowed = {"name", "displayName", "version", "description", "author", "homepage", "license", "keywords"}
ok = ok and set(manifest) <= allowed
sys.exit(0 if ok else 1)
PY

# 3. Generic forbidden content.
patterns=(
  '([0-9]{1,3}\.){3}[0-9]{1,3}'                       # IPv4 literals (servers)
  'supabase\.(co|in)'                                 # database / auth project hosts
  'emk_[A-Za-z0-9_-]{8,}|sb_(secret|publishable)_|eyJ[A-Za-z0-9_-]{10,}|BEGIN [A-Z ]*PRIVATE KEY|gh[pousr]_[A-Za-z0-9]{20,}'
  '(api[_-]?key|secret|password|token)["'"'"' ]*[:=] *["'"'"'][^"'"'"' $]{8,}'
  '(api[_-]?key|secret|password|token)[A-Za-z0-9_]*["'"'"' ]*[:=] *[A-Za-z0-9_+/=-]{12,}'   # unquoted values
  '[0-9]\.[0-9]{4,}'                                  # high-precision numbers (coefficients), any layout
  '[0-9][eE][-+][0-9]+'                               # scientific notation
)
extra=()
if [[ -n "${LEAK_EXTRA_PATTERNS:-}" ]]; then
  while IFS= read -r p; do
    p=${p%$'\r'}
    [[ -n "$p" ]] || continue
    # A pattern grep cannot parse would silently match nothing, so reject it.
    if grep -qE -- "$p" /dev/null; [[ $? -ge 2 ]]; then report "a private pattern is not a valid extended regex"; continue; fi
    extra+=("$p")
  done <<< "$LEAK_EXTRA_PATTERNS"
else
  echo "warning: LEAK_EXTRA_PATTERNS not set; private patterns skipped" >&2
fi
# CI on main sets LEAK_REQUIRE_PRIVATE=1 (pull-request runs get no secrets).
if [[ -n "${LEAK_REQUIRE_PRIVATE:-}" && ${#extra[@]} -eq 0 ]]; then report "LEAK_EXTRA_PATTERNS is missing or holds no usable pattern"; fi

# Every tracked file, this script included (its generic patterns are written
# so that they do not match their own text).
while IFS= read -r f; do
  for p in "${patterns[@]}" "${extra[@]}"; do
    if grep -qEi -- "$p" "$f"; then report "$f matches a forbidden pattern (line $(grep -nEi -- "$p" "$f" | head -1 | cut -d: -f1))"; fi
  done
  # GitHub references: only this plugin repository may be named.
  while IFS= read -r ref; do
    [[ "$ref" == "ahlabeeb/emodely-claude-plugin" ]] || report "$f names another repository"
  done < <(grep -oiE '(github\.com[/:]|marketplace add +)[A-Za-z0-9._-]+/[A-Za-z0-9._-]+' "$f" | sed -E 's#^(github\.com[/:]|marketplace add +)##I; s#\.git$##I' | tr 'A-Z' 'a-z')
  while IFS= read -r ref; do
    [[ "$ref" == "ahlabeeb/emodely-claude-plugin" ]] || report "$f names another repository"
  done < <(grep -oiE 'Ahlabeeb/[A-Za-z0-9._-]+' "$f" | tr 'A-Z' 'a-z')
done < <(git ls-files)

if [[ $fail -ne 0 ]]; then exit 1; fi
echo "leak check passed ($(git ls-files | wc -l | tr -d ' ') files, ${#extra[@]} private patterns)"
