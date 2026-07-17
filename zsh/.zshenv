# Let zim own compinit; skip the global /etc/zsh/zshrc one (avoids double init).
skip_global_compinit=1

# rust / cargo (eza, fnm, etc. live here on some machines)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# uv / local bin (uv, zoxide, user binaries)
export PATH="$HOME/.local/bin:$PATH"

export RUSTFLAGS="-C target-feature=-crt-static"

