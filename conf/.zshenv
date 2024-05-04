# shellcheck source=/dev/null
if [ -f  "$HOME/.config/zsh/.zshenv" ]; then
    source "$HOME/.config/zsh/.zshenv"
else
    printf "[WARN] \x1b[31m%s\x1b[0m\n" "unable to locate file [$HOME/.config/zsh/.zshenv] - config not loaded"
fi
