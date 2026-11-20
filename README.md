# herdr-fork-pane

A Claude Code plugin for the Herdr app. `/fork-pane` splits the pane your Claude Code session runs in and starts a fork of that session beside it: the whole conversation so far, under a new session id. Talk to the fork about the work without touching the original.

```
/fork-pane          split right (side by side)
/fork-pane down     split down (stacked)
```

## Install

Needs Claude Code 2.1.329 or later (any version with `${CLAUDE_SESSION_ID}` in skills), the Herdr app with `herdr-app` on your `PATH`, and `python3`.

```
/plugin marketplace add mayank-arora/herdr-fork-pane
/plugin install herdr-fork-pane@herdr-fork-pane
```

Or, from a clone, for one session only: `claude --plugin-dir /path/to/herdr-fork-pane`.

## How it works

1. The skill passes `${CLAUDE_SESSION_ID}` to `scripts/fork-pane.sh`.
2. The script finds this terminal's pane from `$HC_TERMINAL_ID` in `herdr-app ls` (falling back to the focused pane).
3. It runs `herdr-app do pane.split` with an `argv` that changes to the session's folder, carries over its `PATH`, and runs `claude --resume <id> --fork-session`.

## Known behaviour

- The fork starts in your default permission mode and settings, not the original session's flags (for example a `--permission-mode` passed on the command line).
- The fork shows the conversation up to the `/fork-pane` call; it does not see what the original says afterwards.
- It works only inside Herdr: outside it, `herdr-app` is missing and the command says so.

## Licence

MIT. See [LICENSE](LICENSE).
