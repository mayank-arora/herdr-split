# herdr-split

A Claude Code plugin for the Herdr app. `/split` splits the pane your Claude Code session runs in and starts a fork of that session beside it: the whole conversation so far, under a new session id. Talk to the fork about the work without touching the original.

```
/split          the fork opens on the right (also: /split side)
/split down     the fork opens below (also: below, bottom)
```

## Install

Needs Claude Code 2.1.329 or later (any version with `${CLAUDE_SESSION_ID}` in skills), the Herdr app with `herdr-app` on your `PATH`, and `python3`.

```
npx skills add mayank-arora/herdr-split -g -a claude-code
```

This installs a plain skill into `~/.claude/skills/split`, so the command is `/split`. Update it with `npx skills update split`.

It is also a Claude Code plugin, if you prefer `/plugin` to manage it; plugin skills show with a prefix, as `/herdr-split:split`:

```
/plugin marketplace add mayank-arora/herdr-split
/plugin install herdr-split@herdr-split
```

## How it works

1. The skill passes `${CLAUDE_SESSION_ID}` to `skills/split/scripts/split.sh`.
2. The script finds this terminal's pane from `$HC_TERMINAL_ID` in `herdr-app ls` (falling back to the focused pane).
3. It runs `herdr-app do pane.split` with an `argv` that changes to the session's folder, carries over its `PATH`, and runs `claude --resume <id> --fork-session`.

## Known behaviour

- The fork starts in your default permission mode and settings, not the original session's flags (for example a `--permission-mode` passed on the command line).
- The fork shows the conversation up to the `/split` call; it does not see what the original says afterwards.
- It works only inside Herdr: outside it, `herdr-app` is missing and the command says so.
- The fork does not connect to your IDE, so the original session keeps it (selections, diagnostics). Run `/ide` in the fork to move it there.
- To close the fork, use Cmd+Shift+W (closes one pane). In Herdr's default keys, Cmd+W closes the whole tab, both sessions included. To swap them, edit `cmd-w` and `cmd-shift-w` in `~/.config/herdr-app/keys.json`; Herdr then stops adding new default shortcuts to that file on upgrades.

## Licence

MIT. See [LICENSE](LICENSE).
