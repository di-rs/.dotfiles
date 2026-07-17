# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi

# opencode
[[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH"
export LOCAL_API_KEY=local

# fnm (Node version manager) + zoxide — guard so a missing tool is a no-op
command -v fnm    >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# WSL + Docker Desktop: /usr/share/zsh/vendor-completions/_docker is a symlink
# into Docker Desktop's WSL mount, which dangles whenever Docker Desktop isn't
# running. zim's completion module zstat's every completion in $fpath and bails
# (with `return 1`, before defining `compdef`) the moment it hits a broken link
# — which then breaks the ohmyzsh git plugin's compdef calls at startup. Mirror
# only the *resolvable* vendor completions into a user dir (the `-.` glob
# qualifier drops dangling links) and swap that into $fpath for the system dir.
# Rebuilt each start so it tracks Docker Desktop coming and going.
() {
  local vc=/usr/share/zsh/vendor-completions
  [[ -d $vc ]] || return
  local shadow=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/vendor-completions
  mkdir -p $shadow && rm -f $shadow/*(N) && ln -s $vc/*(N-.) $shadow/ 2>/dev/null
  fpath=(${fpath:#$vc} $shadow)
}

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing (portable: no homebrew dependency).
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# Move the path from the minimal theme's right prompt to the front of the
# left prompt, keeping the rest of the theme (lambda, keymap char, git info) as-is.
PS1=$'%F{244}$(prompt-pwd)%f ${SSH_TTY:+"%m "}${VIRTUAL_ENV:+"${VIRTUAL_ENV:t} "}%(1j.%{\E[${MNML_BGJOB_MODE}m%}.)%F{%(?.${MNML_OK_COLOR}.${MNML_ERR_COLOR})}%(!.#.${MNML_USER_CHAR})%f%{\E[0m%} $(_prompt_mnml_keymap) '
RPS1='${(e)git_info[rprompt]}'

# dotfiles
alias dotcd="cd ~/personal/.dotfiles"
dotsync() {
  git -C ~/personal/.dotfiles add -A \
    && git -C ~/personal/.dotfiles commit -m "${*:-update $(date '+%Y-%m-%d %H:%M')}" \
    && git -C ~/personal/.dotfiles push
}

# ---------------------------------------------------------------------------
# Local machine extras (merged from the previous oh-my-zsh WSL setup)
# ---------------------------------------------------------------------------

export EDITOR='hx'

# ls / file-tree (eza)
alias ll="eza -l -g --icons --git"
alias llt="eza -1 --icons --tree --git-ignore"
alias l='eza'
alias la='eza -lh --all'
alias lsa='ls -lah'
alias lf='lfcd'
alias md='mkdir -p'

# core
alias grep='grep --color=auto'
alias cl="clear"

# git helpers (rely on zim's ohmyzsh git-plugin aliases: gaa, gcam, gp, gpsup, gcd, gl)
gpa()     { gaa; gcam "$1"; gp; }
gpasup()  { gaa; gcam "$1"; gpsup; }
gpan()    { gaa; gcam --no-verify "$1"; gp; }
gpansup() { gaa; gcam --no-verify "$1"; gpsup; }
gcbd()    { gcd; gl; git checkout "$1" 2>/dev/null || git checkout -b "$1"; }

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
alias p="pnpm"

# Vite+ (https://viteplus.dev)
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

# WSL / Windows interop (no-op on macOS/Linux without WSL)
if grep -qi microsoft /proc/version 2>/dev/null; then
  alias start="explorer.exe"
fi
