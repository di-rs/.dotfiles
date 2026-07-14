#!/usr/bin/env bash
# Bootstraps this dotfiles repo onto a new machine.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(helix ghostty zsh herdr pi agent-skills claude)

IS_MACOS=false
[[ "$(uname -s)" == "Darwin" ]] && IS_MACOS=true

# brew (.Brewfile) and macos (.zprofile) are Mac-only; skip on Linux.
if $IS_MACOS; then
  PACKAGES+=(brew macos)
fi

if ! command -v stow >/dev/null 2>&1; then
  if $IS_MACOS; then
    echo "Installing GNU Stow..."
    brew install stow
  else
    echo "GNU Stow is required. Install it with your distro's package" \
         "manager (e.g. apt install stow) and re-run this script."
    exit 1
  fi
fi

cd "$DOTFILES_DIR"
stow -v -t "$HOME" "${PACKAGES[@]}"

if $IS_MACOS; then
  echo "Installing Homebrew packages from .Brewfile..."
  brew bundle --global
fi

if command -v fnm >/dev/null 2>&1; then
  echo "Setting fnm default Node to lts-latest..."
  fnm install --lts
  fnm default lts-latest
fi

echo
echo "Done. A few things stow can't do for you:"
echo "  - zim modules install on first shell start (see .zshrc)."
echo "  - Restore agent skills from the lockfile:"
echo "      npx skills experimental_install -g"
echo "  - pi's auth.json and Claude Code's OAuth state are deliberately not"
echo "    tracked here; log in again on this machine."
