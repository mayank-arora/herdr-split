---
name: fork-pane
description: Fork this Claude Code session into a new Herdr split pane, with the whole conversation so far, under a new session id. Run as /fork-pane, or /fork-pane down for a horizontal split.
disable-model-invocation: true
argument-hint: "[right|down]"
allowed-tools: Bash(bash:*)
---

!`bash ${CLAUDE_SKILL_DIR}/../../scripts/fork-pane.sh ${CLAUDE_SESSION_ID} $ARGUMENTS`

Above is the result of splitting the Herdr pane. If it shows a `pane` and `terminal`, reply only "Forked into the new pane." Otherwise show the error line and stop. Do not retry.
