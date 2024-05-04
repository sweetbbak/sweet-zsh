#!/usr/bin/env bash
# install this zsh configuration
# this script will opt for backing up any existing files instead of overwriting
# it will create a .zshenv in $HOME and a directory at $HOME/.config/zsh/
set -x
set -euo pipefail

# example: mv-backup ./conf/.zshenv $HOME/.zshenv
mv-backup() {
    if [ -f "$2" ] || [ -d "$2" ]; then
        mv "$2" "$2-bak"
        mv-backup "${1}" "${2}"
    else
        builtin cp -r "$1" "$2"
    fi
}

copy-config() {
    mv-backup ./conf/.zshenv "${HOME}/.zshenv"
    mv-backup ./conf/zsh "${HOME}/.config/zsh"
}


G="\x1b[32m"
C="\x1b[0m"
cat <<EOF
$(echo -e "${G}╭─────────╮${C}\n${G}│${C}sweet-zsh${G}│${C}\n${G}╰─────────╯${C}")
EOF

read -r -N1 -p "Setup ZSH config? [y/N]: " yesno
case "$yesno" in
    [Yy]*) echo -e "\nSetting up zsh config..." && copy-config  ;;
    *) exit ;;
esac
