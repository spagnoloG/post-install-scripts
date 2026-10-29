#!/usr/bin/env bash
set -uo pipefail

main() {
  command -v acpi >/dev/null 2>&1 || return 0

  local line state capacity icon
  local battery_pattern='^Battery[[:space:]]+[0-9]+:[[:space:]]*([^,]+),[[:space:]]*([0-9]+)%'

  while IFS= read -r line; do
    [[ "$line" =~ $battery_pattern ]] || continue
    state=${BASH_REMATCH[1]}
    capacity=${BASH_REMATCH[2]}

    case "$state" in
      Charging) icon='⚡' ;;
      Discharging) icon='🔋' ;;
      Full|'Not charging') icon='🔌' ;;
      *) icon='🔋' ;;
    esac

    # Command output in tmux's #() is literal: keep a single percent sign.
    printf '%s %s%%' "$icon" "$capacity"
    return 0
  done < <(LC_ALL=C acpi -b 2>/dev/null)
}

main "$@"
