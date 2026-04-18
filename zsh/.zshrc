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

# Syntax highlighting must load last (wraps all previously defined widgets)
zinit light zdharma-continuum/fast-syntax-highlighting

# --- Completion (after plugins so their completions register) ---
autoload -Uz compinit && compinit
zinit cdreplay -q
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

autoload -Uz colors && colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # display this when there are staged changes
zstyle ':vcs_info:*' actionformats '%F{5}(%F{2}%b%F{3}|%F{1}%a%c%u%m%F{5})%f '
zstyle ':vcs_info:*' formats '%F{5}(%F{2}%b%c%u%m%F{5})%f '
zstyle ':vcs_info:svn:*' branchformat '%b'
zstyle ':vcs_info:svn:*' actionformats '%F{5}(%F{2}%b%F{1}:%{3}%i%F{3}|%F{1}%a%c%u%m%F{5})%f '
zstyle ':vcs_info:svn:*' formats '%F{5}(%F{2}%b%F{1}:%F{3}%i%c%u%m%F{5})%f '
zstyle ':vcs_info:*' enable git cvs svn
zstyle ':vcs_info:git*+set-message:*' hooks untracked-git

+vi-untracked-git() {
  if command git status --porcelain 2>/dev/null | command grep -q '??'; then
    hook_com[misc]='%F{red}?'
  else
    hook_com[misc]=''
  fi
}

gentoo_precmd() {
  vcs_info
}

autoload -U add-zsh-hook
add-zsh-hook precmd gentoo_precmd

PROMPT='%B%(!.%F{red}.%F{green})%n@%F{$HOST_COLOR}%m%b%f %F{blue}%(!.%1~.%3~)%f ${vcs_info_msg_0_}%(?.%F{blue}.%F{red})%(!.#.$)%f%k%b '
