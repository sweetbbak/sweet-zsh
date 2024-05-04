
# shellcheck disable=SC2034
# allow for easy path handling w/o duplicate entries
typeset -U path PATH
typeset -U path cdpath fpath manpath
# Timezone
export TZ=America/Anchorage
export ZDOTDIR="$HOME/.config/zsh"

# bins
path=(
    ~/.local/bin
    ~/bin
    ~/scripts
    ~/.cargo/bin
    ~/go/bin
    ~/.local/share/nvim/mason/bin
    $path
)

# get dirs at 1 depth in bin - use this sparingly
path+=(~/bin/**/*(N/))

# Define user directories
XDG_DATA_HOME="$HOME/.local/share"
XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_STATE_HOME="$HOME/.local/state"
# Define xdg-user-dirs
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"

export PATH

fpath+=(
    "$HOME/.config/zsh/completions/"
)

export FPATH
# source your secrets from another file and dont push them to git
