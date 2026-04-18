# ~/.zshrc

# --- Zinit bootstrap ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt HIST_VERIFY SHARE_HISTORY INC_APPEND_HISTORY
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS

# --- Vi mode ---
bindkey -v
export KEYTIMEOUT=1
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^P' history-substring-search-up
bindkey -M viins '^N' history-substring-search-down

# --- Hostname color (deterministic per host) ---
function _host_color() {
  local hash=$(hostname | cksum | awk '{print $1}')
  local palette=(33 39 45 51 75 81 111 117 147 183 208 214 220 46 82 118 154 190 198 201 207 213)
  echo ${palette[$((hash % ${#palette[@]} + 1))]}
}
HOST_COLOR=$(_host_color)

# --- Plugins ---
# Order matters: widget-defining plugins before widget-wrapping ones
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search

# OMZ libs that gentoo depends on
zinit snippet OMZL::git.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# The gentoo theme
zinit snippet OMZT::gentoo

# Syntax highlighting must load last (wraps all previously defined widgets)
zinit light zdharma-continuum/fast-syntax-highlighting

# --- Completion (after plugins so their completions register) ---
autoload -Uz compinit && compinit
zinit cdreplay -q
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# # --- Prompt customization (must come AFTER theme loads) ---
# # Repaint hostname with our per-host color, bold it for prominence
# PROMPT="${PROMPT//\%m/%F{$HOST_COLOR}%B%m%b%f}"
#
# # Shorten path: ~ for home, last 3 dirs only (servers have deep paths)
# PROMPT="${PROMPT//\%~/%3~}"
#
# # Exit status indicator: color the % red on failure, keep white on success
# PROMPT="${PROMPT//\%\#/%(?.%F{white\}.%F{red\})%#%f}"
#
# # --- Vi mode indicator in right prompt ---
# VIMODE='%F{green}[I]%f'
# function zle-keymap-select {
#   case $KEYMAP in
#     vicmd)      VIMODE='%F{208}[N]%f' ;;
#     main|viins) VIMODE='%F{green}[I]%f' ;;
#   esac
#   zle reset-prompt
# }
# zle -N zle-keymap-select
# function zle-line-init { VIMODE='%F{green}[I]%f'; zle -K viins }
# zle -N zle-line-init
# RPROMPT='$VIMODE'
#
# # --- Aliases ---
# alias ll='ls -lah --color=auto'
# alias ..='cd ..'
# alias ...='cd ../..'
# alias grep='grep --color=auto'
#
# # --- Host-specific overrides ---
# [ -f ~/.zshrc.local ] && source ~/.zshrc.local
