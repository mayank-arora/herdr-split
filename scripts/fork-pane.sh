#!/usr/bin/env bash
# Split the Herdr pane this Claude Code session runs in and start a fork of
# the session beside it: claude --resume <id> --fork-session.
set -euo pipefail

session_id="${1:-}"
direction="${2:-right}"
working_directory="${3:-$PWD}"

fail() { echo "fork-pane: $*" >&2; exit 1; }

[[ -n "$session_id" && "$session_id" != *'${'* ]] || fail "no session id (needs Claude Code with \${CLAUDE_SESSION_ID})"
[[ "$direction" == right || "$direction" == down ]] || fail "direction must be right or down, got '$direction'"
command -v herdr-app >/dev/null || fail "herdr-app not on PATH; run this inside the Herdr app"
command -v python3 >/dev/null || fail "python3 is needed to read herdr-app's JSON"

# Find the pane holding this terminal; fall back to the focused pane.
pane=""
if [[ -n "${HC_TERMINAL_ID:-}" ]]; then
  pane="$(herdr-app ls | python3 -c '
import json, sys
wanted = sys.argv[1]
def walk(node):
    if isinstance(node, dict):
        if node.get("terminal") == wanted and node.get("pane"):
            print(node["pane"]); sys.exit()
        for value in node.values(): walk(value)
    elif isinstance(node, list):
        for value in node: walk(value)
walk(json.load(sys.stdin))
' "$HC_TERMINAL_ID")"
fi

# pane.split has no cwd argument, so the new terminal changes directory itself.
# --resume finds the transcript by project folder, so this cwd must match.
# Herdr starts new panes with a bare PATH; carry this session's so hooks find node and friends.
printf -v inner 'export PATH=%q && cd %q && exec claude --resume %q --fork-session' "$PATH" "$working_directory" "$session_id"

request="$(python3 -c '
import json, sys
direction, pane, inner = sys.argv[1:4]
request = {"direction": direction, "argv": ["sh", "-c", inner]}
if pane: request["pane"] = pane
print(json.dumps(request))
' "$direction" "$pane" "$inner")"

herdr-app do pane.split "$request"
