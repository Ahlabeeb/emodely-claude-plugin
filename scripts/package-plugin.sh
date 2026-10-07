#!/usr/bin/env bash
# Builds the zip that claude.ai / Desktop accept under Customize > Plugins >
# Add > Upload plugin. Packs the committed plugin folder only (git archive),
# so untracked or ignored files can never end up in the upload.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
if ! git diff --quiet HEAD -- plugins/emodely-engine || [[ -n "$(git ls-files --others --exclude-standard plugins/emodely-engine)" ]]; then
  echo "commit the plugin folder first: the zip is built from HEAD" >&2; exit 1
fi
version=$(git show HEAD:plugins/emodely-engine/.claude-plugin/plugin.json | sed -n 's/.*"version": *"\([^"]*\)".*/\1/p')
mkdir -p dist
out="dist/emodely-engine-${version}.zip"
git archive --format=zip -o "$out" HEAD:plugins/emodely-engine
echo "$out"
