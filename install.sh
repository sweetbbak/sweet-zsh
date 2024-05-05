#!/usr/bin/env bash
# install this zsh configuration
# this script will opt for backing up any existing files instead of overwriting
# it will create a .zshenv in $HOME and a directory at $HOME/.config/zsh/
set -x
set -uo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# example: mv-backup ./conf/.zshenv $HOME/.zshenv
mv-backup() {
    cp -r "$1" "$2"
}

copy-config() {
    mv-backup "$SCRIPT_DIR/conf/.zshenv" "${HOME}/.zshenv"
    mv-backup "$SCRIPT_DIR/conf/zsh/.zshenv" "${HOME}/.config/zsh/.zshenv"
    mv-backup "$SCRIPT_DIR/conf/zsh/.zshrc" "${HOME}/.config/zsh"
    mv-backup "$SCRIPT_DIR/conf/zsh/functions.zsh" "${HOME}/.config/zsh"
    mv-backup "$SCRIPT_DIR/conf/zsh/alias.zsh" "${HOME}/.config/zsh"
}

function __check_plugin() {
    cd "$HOME/.config/zsh" || echo "couldnt CD"

    dirname="$(basename "$2")"
    dirname="${dirname/.git/}"

    [  ! -d "$dirname" ] && git clone "${2}" 
    [ ! -f "$1" ] && echo -e "[WARN] error loading plugin [$2]"
}

check_dep() {
    local ex=""
    for x in "${@}"; do
        if ! command -v "$x" >/dev/null; then
            echo "please install $x before rerunning..." && ex+="$x "
        fi
    done

    if [ "$ex" != "" ]; then
        echo "please install $ex before rerunning..." && exit
    fi

}

installer() {
    check_dep git curl

    mkdir -p "$HOME/.config/zsh"

    [ ! -f "$HOME/.config/zsh/zsh-sudo-plugin.zsh" ] && curl -fsSl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh > "$HOME/.config/zsh/zsh-sudo-plugin.zsh"

    # fzf tab
    __check_plugin "$HOME/.config/zsh/fzf-tab/fzf-tab.plugin.zsh" "https://github.com/Aloxaf/fzf-tab.git"

    # fzf reverse ctrl_r history search
    __check_plugin "$HOME/.config/zsh/zsh-fzf-history-search/zsh-fzf-history-search.zsh" "https://github.com/joshskidmore/zsh-fzf-history-search.git"

    # auto suggestions
    __check_plugin "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" "https://github.com/zsh-users/zsh-autosuggestions.git"

    # tab sources for better completion
    __check_plugin "$HOME/.config/zsh/fzf-tab-source/fzf-tab-source.plugin.zsh" "https://github.com/Freed-Wu/fzf-tab-source.git"

    # Syntax highlighting must be loaded last
    __check_plugin "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "https://github.com/zsh-users/zsh-syntax-highlighting.git" 
}

main() {
    [ -d "$HOME/.config/zsh" ] && mv "$HOME/.config/zsh" "$HOME/.config/zsh-bak"
    installer
    copy-config
}


G="\x1b[32m"
C="\x1b[0m"
cat <<EOF
$(echo -e "${G}╭─────────╮${C}\n${G}│${C}sweet-zsh${G}│${C}\n${G}╰─────────╯${C}")
EOF

read -r -N1 -p "Setup ZSH config? [Y/n]: " yesno
case "$yesno" in
    [Nn]*) exit ;;
    *) echo -e "\nSetting up zsh config..." && main  ;;
esac
