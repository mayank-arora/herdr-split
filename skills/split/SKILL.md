---
name: split
description: Fork this Claude Code session into a new Herdr pane, with the whole conversation so far, under a new session id. /split opens it on the right; /split down opens it below.
disable-model-invocation: true
argument-hint: "[right|down]"
allowed-tools: Bash(bash:*)
---

!`bash ${CLAUDE_SKILL_DIR}/scripts/split.sh ${CLAUDE_SESSION_ID} $ARGUMENTS`

Above is the result of splitting the Herdr pane. If it shows a `pane` and `terminal`, reply only "Forked into the new pane." Otherwise show the error line and stop. Do not retry.
