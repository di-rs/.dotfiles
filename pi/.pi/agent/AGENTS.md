## Environment

You are always running inside **Herdr**, a terminal multiplexer built for coding agents (workspaces, tabs, panes). Use the `herdr` CLI to inspect neighboring panes, split off a scratch terminal, run and read background commands, or hand off work to another agent — no need for tmux or subshell tricks.

- **Diff review**: the user reviews changesets with `hunk` (`hunk diff`, `hunk show`) — a review-first terminal diff viewer, not raw `git diff`. Prefer pointing the user at `hunk` over dumping a diff inline when they want to review a changeset.
- **Editing/viewing files in terminal**: the user's editor is **Helix** (`hx`). Any file you edit that's open in a Helix pane auto-reloads within seconds (a herdr extension runs `:reload-all` after your edit/write tool calls) — no need to tell the user to reload it manually.
