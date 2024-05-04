
export EDITOR='nvim'
export SHELL=/bin/bash
export HISTFILE="$HOME/.config/zsh/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export PAGER='bat --color=always'
export DIFFPROG="nvim -d"
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT='-c'

printf "\x1b[38;5;116m%s\x1b[0m\n" "／人◕ ‿‿ ◕人＼ [$USER@$HOST]"

# ╭────────╮
# │starship│
# ╰────────╯
#
# --- uncomment your theme ---
# STARSHIP_THEME="$HOME/.config/starship/starship.toml"
STARSHIP_THEME="$HOME/.config/starship/gum.toml"
# ---------------------------


export STARSHIP_CONFIG="$STARSHIP_THEME"

if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
else
  # fallback prompt
  PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
  RPROMPT='%*'
  export PROMPT RPROMPT
fi


# ╭──────╮
# │Zoxide│
# ╰──────╯
#
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  true
fi

# ╭────────╮
# │Keybinds│
# ╰────────╯
#

WORDCHARS='~!#$%^&*(){}[]<>?.+;-'
bindkey '^[[1;5C' forward-word     # ctrl + ->
bindkey '^[[1;5D' backward-word    # ctrl + <-
bindkey '^H' backward-kill-word    # ctrl+backspace delete word
bindkey '^U' backward-kill-line    # ctrl+backspace delete word
bindkey ' ' magic-space            # history expansion on space
bindkey '^Z' undo                  # shift + tab undo last action
bindkey '^[/'     redo
bindkey '^f' emacs-forward-word
bindkey '^a' emacs-backward-word

# history binds - match characters history search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
# ╭───────╮
# │Options│
# ╰───────╯
#

setopt extendedglob
setopt auto_cd
setopt auto_pushd
setopt interactive_comments
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt inc_append_history
setopt share_history

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$_zcompcache"
fpath+="${0:A:h}/functions"

# load compinit
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# expand aliases
zle -C alias-expension complete-word _generic
bindkey '^e' alias-expension

# ╭───────╮
# │Plugins│
# ╰───────╯
#
# check if file exists and source it
function __source() {
    # shellcheck source=/dev/null
    [ -f "$1" ] && source "$1"
    [ ! -f "$1" ] && echo -e "file [$1] is missing" && return 1
}

# {sourced_file} {plugin_repo}
function __check_plugin() {
    # shellcheck source=/dev/null
    if [ -f "$1" ]; then
        __source "${1}"
    else
        cd "$HOME/.config/zsh" || echo "couldnt CD"
        dirname="$(basename "$2")"
        dirname="${dirname/.git/}"

        [  ! -d "$dirname" ] && git clone "${2}" 

        [ -f "$1" ] && source "${1}"
        [ ! -f "$1" ] && echo -e "[WARN] error loading plugin [$2]"
    fi
}

# user defined aliases - functiongs
__source "$HOME/.config/zsh/alias.zsh"
__source "$HOME/.config/zsh/functions.zsh"

# double tap ESC to prepend line with SUDO
[ ! -f  "$HOME/.config/zsh/zsh-sudo-plugin.zsh" ] && {
    if command -v curl >/dev/null; then
        curl -fsSl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh > "$HOME/.config/zsh/zsh-sudo-plugin.zsh"
    else 
        wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -O "$HOME/.config/zsh/zsh-sudo-plugin.zsh"
    fi
}
__source "$HOME/.config/zsh/zsh-sudo-plugin.zsh"

#fzf tab complete 
__check_plugin "$HOME/.config/zsh/fzf-tab/fzf-tab.plugin.zsh" "https://github.com/Aloxaf/fzf-tab.git"

# fzf reverse ctrl_r history search
__check_plugin "$HOME/.config/zsh/zsh-fzf-history-search/zsh-fzf-history-search.zsh" "https://github.com/joshskidmore/zsh-fzf-history-search.git"

# auto suggestions
__check_plugin "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" "https://github.com/zsh-users/zsh-autosuggestions.git"

# tab sources for better completion
zstyle ':autocomplete:*' default-context history-incremental-search-backward
__check_plugin "$HOME/.config/zsh/fzf-tab-source/fzf-tab-source.plugin.zsh" "https://github.com/Freed-Wu/fzf-tab-source.git"

# fzf completion options
zstyle ':completion:*' fzf-search-display true
zstyle ':completion:alias-expension:*' completer _expand_alias
zstyle ':fzf-tab:complete:*:options' fzf-preview 
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:*' fzf-bindings 'ctrl-v:execute-silent({_FTB_INIT_}$EDITOR "$realpath")'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'

# Syntax highlighting must be loaded last
__check_plugin "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "https://github.com/zsh-users/zsh-syntax-highlighting.git" 
