# We use my own video thumbnailer. It's much faster than stpv (which also works):
export PATH=$PATH:$HOME/.config/lf/kitty-pistol-previewer

# lf (not lfcd) is a directory changer. Essentially this:
# https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh
LF=$(which lf)
lf() {
    tmp="$(mktemp)"
    $LF -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}
