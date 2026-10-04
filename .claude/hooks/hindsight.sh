#!/usr/bin/env bash
# Startet einen Einstiegspunkt aus @vectorize-io/hindsight-coding-agents
# (Hook-Skripte oder MCP-Server). Das Paket wird beim ersten Aufruf in den
# Cache installiert, weil Cloud-Container bei jeder Sitzung frisch starten.
#
# Ohne HINDSIGHT_API_TOKEN passiert nichts: Hooks beenden sich still, damit
# Sitzungen ohne eingerichtetes Hindsight normal weiterlaufen.
set -u

VERSION="0.8.0"
ENTRY="${1:?Einstiegspunkt fehlt, z.B. claude-hook.js}"
PKG_DIR="${HOME}/.cache/hindsight-coding-agents/${VERSION}"
DIST="${PKG_DIR}/node_modules/@vectorize-io/hindsight-coding-agents/dist"

if [ -z "${HINDSIGHT_API_TOKEN:-}" ]; then
  if [ "$ENTRY" = "mcp-server.js" ]; then
    echo "hindsight: HINDSIGHT_API_TOKEN nicht gesetzt" >&2
    exit 1
  fi
  cat >/dev/null
  exit 0
fi

if [ ! -f "${DIST}/${ENTRY}" ]; then
  mkdir -p "$(dirname "$PKG_DIR")"
  TMP="$(mktemp -d "${PKG_DIR}.XXXXXX")"
  if npm install --silent --no-audit --no-fund --prefix "$TMP" \
       "@vectorize-io/hindsight-coding-agents@${VERSION}" >&2; then
    mv -T "$TMP" "$PKG_DIR" 2>/dev/null || rm -rf "$TMP"
  else
    rm -rf "$TMP"
    echo "hindsight: Installation fehlgeschlagen" >&2
    exit 0
  fi
fi

export HINDSIGHT_SERVER_MODE=cloud
export HINDSIGHT_MCP_HARNESS=claude-code
export HINDSIGHT_MCP_PROJECT_CWD="${CLAUDE_PROJECT_DIR:-$PWD}"
# Kein headless `claude -p`-Lauf beim Sitzungsstart (bis zu 2 $) und keine
# Selbst-Updates der gepinnten Version.
export HINDSIGHT_CODEBASE_SURVEY="${HINDSIGHT_CODEBASE_SURVEY:-false}"
export HINDSIGHT_AUTO_UPDATE="${HINDSIGHT_AUTO_UPDATE:-false}"

exec node "${DIST}/${ENTRY}"
