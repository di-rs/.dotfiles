#!/bin/sh
# Reload any Helix (hx) pane in the current Herdr workspace after an agent
# (Claude Code / pi) edits files on disk, so the buffer doesn't go stale.
#
# Safety: Helix's :reload / :reload-all silently discard unsaved local edits
# with no warning or confirmation (verified empirically — this is not
# documented anywhere, and Helix's status-line "[+]" modified indicator
# cannot be reliably scraped from a herdr pane read: it gets clipped by
# status-line width truncation on long file paths, tested and confirmed
# to fail silently).
#
# Real safety instead comes from two things working together:
#   1. helix/.config/helix/config.toml has [editor.auto-save] focus-lost =
#      true, so Helix flushes any edit to disk the instant its pane loses
#      focus.
#   2. This script skips any pane that is *currently focused* — i.e. never
#      touches a buffer the user might be actively typing into right now.
# Together: an unfocused Helix pane's content is always already saved: the
# only content it could otherwise still be holding unsaved.
#
# Called from:
#   - Claude Code PostToolUse hook (claude/.claude/settings.json)
#   - pi tool_execution_end extension (pi/.pi/agent/extensions/herdr-helix-reload.ts)

set -eu

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_WORKSPACE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

pane_list_json=$(herdr pane list --workspace "$HERDR_WORKSPACE_ID" 2>/dev/null) || exit 0
panes=$(printf '%s' "$pane_list_json" | jq -r '.result.panes[].pane_id' 2>/dev/null) || exit 0

for pane in $panes; do
  is_hx=$(herdr pane process-info --pane "$pane" 2>/dev/null \
    | jq -e '(.result.process_info.foreground_processes // []) | any(.name == "hx")' 2>/dev/null) || is_hx=false
  [ "$is_hx" = "true" ] || continue

  focused=$(printf '%s' "$pane_list_json" \
    | jq -r --arg id "$pane" '.result.panes[] | select(.pane_id == $id) | .focused' 2>/dev/null) || focused=true
  [ "$focused" = "false" ] || continue

  herdr pane send-keys "$pane" Escape ':' r e l o a d '-' a l l Return >/dev/null 2>&1 || true
done

exit 0
