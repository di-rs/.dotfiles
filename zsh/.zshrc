# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/dima/.zsh/completions:"* ]]; then export FPATH="/Users/dima/.zsh/completions:$FPATH"; fi


# opencode
export PATH=/Users/dima/.opencode/bin:$PATH
export LOCAL_API_KEY=local

eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(zoxide init zsh)"

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
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

# bun completions
[ -s "/Users/dima/.bun/_bun" ] && source "/Users/dima/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
. "/Users/dima/.deno/env"
