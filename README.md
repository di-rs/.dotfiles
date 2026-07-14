# dotfiles

Personal configs for helix, ghostty, zsh/zim, herdr, pi, Claude Code, and the
agent-skills registry, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package whose internal path mirrors `$HOME`.

## Layout

```
helix/.config/helix/config.toml
ghostty/.config/ghostty/config.ghostty
zsh/.zshrc .zshenv .zprofile .zimrc
herdr/.config/herdr/config.toml
pi/.pi/agent/settings.json
agent-skills/.agents/.skill-lock.json
claude/.claude/settings.json .claude/plugins/known_marketplaces.json
```

## Install

```sh
git clone <this repo> ~/personal/.dotfiles
cd ~/personal/.dotfiles
./install.sh
```

`install.sh` installs GNU Stow if missing, then symlinks every package into
`$HOME`. If a target file already exists (e.g. a fresh machine's default
`.zshrc`), stow will refuse to overwrite it — move it aside first.

After stowing, restore agent skills from the lockfile:

```sh
npx skills experimental_install -g
```

## What's deliberately excluded

This repo only ever contains configuration, never state or secrets:

- **pi**: `auth.json` (live OAuth tokens) and `sessions/` (transcripts) are
  excluded. Only `settings.json` is tracked.
- **Claude Code**: `~/.claude.json` (account/session state), `projects/`,
  `sessions/`, `history.jsonl`, and caches are excluded. Only `settings.json`
  and the plugin marketplace list are tracked.
- **herdr**: `session.json` (live workspace/pane state), logs, and sockets are
  excluded. Only `config.toml` is tracked.
- **zim**: the `.zim/` framework directory itself isn't tracked — `.zshrc`
  already re-installs it from `.zimrc` via `zimfw` on first run.
- **agent-skills**: only `.skill-lock.json` is tracked, not the fetched skill
  content — `npx skills experimental_install -g` re-fetches it from source.
- Herdr's auto-generated integration shims (`~/.pi/agent/extensions/herdr-agent-state.ts`,
  `~/.claude/hooks/herdr-agent-state.sh`) aren't tracked; herdr regenerates
  and overwrites them on install/update anyway.
