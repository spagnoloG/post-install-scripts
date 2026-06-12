#!/usr/bin/env sh

set -eu

emoji_data=

for path in \
    "${XDG_DATA_HOME:-$HOME/.local/share}/emoji/emoji-test.txt" \
    /usr/share/unicode/emoji/emoji-test.txt \
    /usr/share/emoji/emoji-test.txt
do
    if [ -r "$path" ]; then
        emoji_data="$path"
        break
    fi
done

if [ -z "$emoji_data" ]; then
    printf '%s\n' 'Install unicode-emoji to use the emoji picker' |
        fuzzel --dmenu --prompt 'Emoji> ' >/dev/null || true
    exit 1
fi

selection="$(
    awk '
        /; fully-qualified/ {
            value = $0
            sub(/^.*# /, "", value)
            emoji = value
            sub(/ .*/, "", emoji)
            name = value
            sub(/^[^ ]+ E[0-9.]+ /, "", name)
            print emoji " " name
        }
    ' "$emoji_data" | fuzzel --dmenu --prompt 'Emoji> '
)" || exit 0

[ -n "$selection" ] || exit 0

emoji="${selection%%[[:space:]]*}"
printf '%s' "$emoji" | wl-copy
