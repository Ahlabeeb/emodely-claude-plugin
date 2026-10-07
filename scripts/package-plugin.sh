#!/usr/bin/env bash
# Builds the zip that claude.ai / Desktop accept under Customize > Plugins >
# Add > Upload plugin. Packs the committed plugin folder only (git archive),
# so untracked or ignored files can never end up in the upload.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
version=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' plugins/emodely-engine/.claude-plugin/plugin.json)
mkdir -p dist
out="dist/emodely-engine-${version}.zip"
git archive --format=zip -o "$out" HEAD:plugins/emodely-engine
echo "$out"
