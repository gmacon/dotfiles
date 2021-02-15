swcolor () {
    local new_scheme
    if [ -z "$1" ]; then
        if [ "$LC_COLORSCHEME_INFO" = "light" ]; then
            new_scheme=dark;
        else
            new_scheme=light;
        fi
    else
        new_scheme="$1"
    fi
    . "$HOME/.fresh/build/colors/base16-solarized-$new_scheme.sh"
    export LC_COLORSCHEME_INFO="$new_scheme"
}
