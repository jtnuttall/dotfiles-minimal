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

# --- Spaceship configuration (MUST be set before spaceship loads) ---
SPACESHIP_PROMPT_ORDER=(
  user          # always show username
  host          # always show hostname (colored per-host)
  dir           # current directory
  git           # branch + dirty/ahead/behind indicators
  exec_time     # only appears for commands >5s
  line_sep      # newline before prompt symbol
  vi_mode       # [I] / [N] indicator
  exit_code     # only appears on non-zero exit
  char          # prompt symbol
)

# Always show user@host, even when not SSHed
SPACESHIP_USER_SHOW=always
SPACESHIP_HOST_SHOW=always
SPACESHIP_HOST_COLOR=$HOST_COLOR

# Visual tweaks
SPACESHIP_USER_COLOR=245
SPACESHIP_DIR_COLOR=yellow
SPACESHIP_GIT_BRANCH_COLOR=magenta
SPACESHIP_GIT_STATUS_COLOR=red
SPACESHIP_CHAR_SYMBOL='❯ '
SPACESHIP_CHAR_SUCCESS_COLOR=green
SPACESHIP_CHAR_FAILURE_COLOR=red

# Vi mode styling
SPACESHIP_VI_MODE_INSERT='[I]'
SPACESHIP_VI_MODE_NORMAL='[N]'
SPACESHIP_VI_MODE_COLOR_INSERT=green
SPACESHIP_VI_MODE_COLOR_NORMAL=208

# --- Plugins ---
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search

zinit light spaceship-prompt/spaceship-vi-mode
zinit light spaceship-prompt/spaceship-prompt

zinit light zdharma-continuum/fast-syntax-highlighting

# --- Completion (after plugins so their completions register) ---
autoload -Uz compinit && compinit
zinit cdreplay -q
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# --- Aliases ---
alias ll='ls -lah --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# --- Host-specific overrides ---
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
