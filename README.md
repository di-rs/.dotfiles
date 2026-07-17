# dotfiles

Personal configs for Homebrew packages, helix, ghostty, zsh/zim, herdr, pi,
Claude Code, and the agent-skills registry, managed with
[GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package whose internal path mirrors `$HOME`.

## Layout

```
brew/.Brewfile                                                          (macOS only)
macos/.zprofile                                                         (macOS only)
karabiner/.config/karabiner/assets/complex_modifications/*.json         (macOS only)
helix/.config/helix/config.toml .config/helix/languages.toml
ghostty/.config/ghostty/config.ghostty
zsh/.zshrc .zshenv .zimrc
herdr/.config/herdr/config.toml
pi/.pi/agent/settings.json
agent-skills/.agents/.skill-lock.json
claude/.claude/settings.json
bin/.local/bin/*                                                        (personal scripts, on PATH via .zshenv)
git/.config/git/ignore  personal/.gitconfig                             (global excludes + di-rs identity)
hunk/.config/hunk/config.toml
```

`bin` holds personal scripts stowed into `~/.local/bin` (already on `PATH`
via `zsh/.zshenv`). `review <pr>` opens a PR's diff in the hunk TUI and
posts the inline notes you leave back to the PR as a review (needs `gh`).

## Git identity (work vs di-rs)

`git/personal/.gitconfig` sets the **di-rs** (personal) identity and is loaded
only for repos under `~/personal/` — including this one. It sets `user.email`
plus `credential.https://github.com.username = di-rs`, so `gh` serves the di-rs
token there while everything else stays on the work account.

Two things are *machine-local* and not tracked here (they hold or select the
work identity, which differs per device), so set them up once on each machine:

1. Add the conditional include to `~/.gitconfig` (real file, untracked):

   ```gitconfig
   [includeIf "gitdir:~/personal/"]
       path = ~/personal/.gitconfig
   ```

2. Log the di-rs account into `gh` alongside your default account:

   ```sh
   gh auth login   # GitHub.com → HTTPS → account di-rs
   ```

After that, commits and pushes from anywhere under `~/personal/` use di-rs
automatically. Verify with `git -C ~/personal/.dotfiles config user.email`.

`brew`, `macos`, and `karabiner` are only stowed on macOS (`install.sh`
checks `uname -s`). On Linux, `.Brewfile`, the Mac-specific `.zprofile` PATH
entries, and the Karabiner rule are skipped entirely — everything else is
cross-platform.

Karabiner writes its own live state (`karabiner.json`, `automatic_backups/`,
logs) directly into `~/.config/karabiner`, so only the specific rule file
under `assets/complex_modifications/` is stowed — `install.sh` pre-creates
real directories down to that file so stow doesn't turn the whole
`~/.config/karabiner` directory into a symlink into this repo (it did, once;
don't let that regress).

`caps_lock_to_f13.json` remaps Caps Lock to F13, which herdr's `config.toml`
uses as its `prefix` key (a raw Caps Lock press can't be bound directly —
it's a hardware toggle, not a normal keycode, until remapped). After
stowing, Karabiner needs one-time manual setup that can't be scripted:
open Karabiner-Elements, grant Input Monitoring + Accessibility permissions
when prompted, then go to Complex Modifications → Add rule → enable
"Caps Lock to F13 (for herdr prefix)".

`.Brewfile` is generated with `brew bundle dump` and read via
`brew bundle --global` (which looks for `~/.Brewfile`). Regenerate it after
installing/removing packages:

```sh
brew bundle dump --file=~/personal/.dotfiles/brew/.Brewfile --force
dotsync "update Brewfile"
```

## Install

```sh
git clone <this repo> ~/personal/.dotfiles
cd ~/personal/.dotfiles
./install.sh
```

`install.sh` detects the OS, installs GNU Stow if missing (via Homebrew on
macOS; on Linux it expects your distro's package manager, e.g.
`apt install stow`), symlinks the relevant packages into `$HOME`, and on
macOS runs `brew bundle --global` to install everything listed in
`.Brewfile`. If a target file already exists (e.g. a fresh machine's default
`.zshrc`), stow will refuse to overwrite it — move it aside first.

After stowing, restore agent skills from the lockfile:

```sh
npx skills experimental_install -g
```

fnm has no config file — its behavior comes from env vars set in `.zshrc`
(already tracked) plus whichever version is symlinked as its `default` alias,
which lives in fnm's data dir, not something stow can track. `install.sh`
pins that explicitly: `fnm install --lts && fnm default lts-latest`. Don't
hardcode a Node bin path into `.zshrc` for tools like `pi` — that silently
pins to whatever version was default at the time and stops tracking
`fnm default` when it changes (this repo hit exactly that bug once).

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
