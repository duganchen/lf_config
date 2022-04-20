# We use my own video thumbnailer. It's much faster than stpv (which also works):
export PATH=$PATH:$HOME/.config/lf/kitty-pistol-previewer

# lf (not lfcd) is a directory changer.
if command -v archivemount >/dev/null; then
    # This:
    # https://github.com/gokcehan/lf/wiki/Integrations#archivemount

    lf() {
        tmp="$(mktemp)"
        fid="$(mktemp)"
        command lf -command '$printf $id > '"$fid"'' -last-dir-path="$tmp" "$@"
        id="$(cat "$fid")"
        archivemount_dir="/tmp/__lf_archivemount_$id"
        if [ -f "$archivemount_dir" ]; then
            cat "$archivemount_dir" |
                while read -r line; do
                    sudo umount "$line"
                    rmdir "$line"
                done
            rm -f "$archivemount_dir"
        fi
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
else
    lf() {
        # Essentially this:
        # https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh

        tmp="$(mktemp)"
        # Use command to prevent a recursive call. See:
        # https://wiki.vifm.info/index.php/How_to_set_shell_working_directory_after_leaving_Vifm
        command lf -last-dir-path="$tmp" "$@"
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
fi
