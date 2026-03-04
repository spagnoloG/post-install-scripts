#!/usr/bin/env bash
set -uo pipefail

current_wifi_dev() {
  nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '
    $2=="wifi" && $3=="connected"{print $1; exit}
    $2=="wifi" && !found{cand=$1}
    END{ if(!found && cand!="") print cand }'
}

signal_icon() {
  printf '󰖩'
}

truncate_ssid() {
  local ssid=${1:-}
  local max_len=24

  if (( ${#ssid} <= max_len )); then
    printf '%s' "$ssid"
  else
    printf '%s...' "${ssid:0:max_len-3}"
  fi
}

main() {
  command -v nmcli >/dev/null 2>&1 || exit 0

  local tmux_mode=0
  local dev ssid signal line pct

  [[ "${1:-}" == "--tmux" ]] && tmux_mode=1

  dev="$(current_wifi_dev || true)"
  [[ -n "${dev:-}" ]] || {
    printf '󰖪'
    exit 0
  }

  ssid="$(nmcli -g GENERAL.CONNECTION device show "$dev" 2>/dev/null | head -n 1 || true)"
  line="$(nmcli -t -f IN-USE,SIGNAL dev wifi list ifname "$dev" --rescan no 2>/dev/null | awk -F: '$1=="*"{print; exit}' || true)"
  signal="${line##*:}"

  [[ -n "${ssid:-}" && "${ssid:-}" != "--" ]] || ssid="unknown"
  [[ "${signal:-}" =~ ^[0-9]+$ ]] || signal=0

  pct='%'
  (( tmux_mode )) && pct='%%'

  printf '%s %s %s%s' "$(signal_icon "$signal")" "$(truncate_ssid "$ssid")" "$signal" "$pct"
}

main "$@"
