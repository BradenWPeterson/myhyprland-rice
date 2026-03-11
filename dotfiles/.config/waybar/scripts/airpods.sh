#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/airpods.conf"
NAME="AirPods"
MAC=""

if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
fi

find_mac() {
  if [[ -n "$MAC" ]]; then
    echo "$MAC"
    return 0
  fi

  bluetoothctl devices | while read -r _ dev_mac dev_name_rest; do
    if [[ -n "$dev_name_rest" ]]; then
      if [[ "$dev_name_rest" == *"$NAME"* ]]; then
        echo "$dev_mac"
        return 0
      fi
    fi
  done

  return 1
}

is_connected() {
  local dev_mac="$1"
  bluetoothctl info "$dev_mac" | grep -q "Connected: yes"
}

status_json() {
  local dev_mac
  if ! dev_mac=$(find_mac); then
    printf '{"text":"󰂯 %s","class":"missing","tooltip":"AirPods not found. Pair once or set MAC in airpods.conf"}\n' "$NAME"
    return 0
  fi

  if is_connected "$dev_mac"; then
    printf '{"text":"󰂱 %s","class":"connected","tooltip":"Connected (%s)"}\n' "$NAME" "$dev_mac"
  else
    printf '{"text":"󰂯 %s","class":"disconnected","tooltip":"Disconnected (%s)"}\n' "$NAME" "$dev_mac"
  fi
}

toggle_connection() {
  local dev_mac
  if ! dev_mac=$(find_mac); then
    echo "AirPods not found. Pair once or set MAC in airpods.conf" >&2
    exit 1
  fi

  bluetoothctl power on >/dev/null

  if is_connected "$dev_mac"; then
    bluetoothctl disconnect "$dev_mac" >/dev/null
  else
    bluetoothctl connect "$dev_mac" >/dev/null
  fi
}

case "${1:-}" in
  --toggle)
    toggle_connection
    ;;
  --status|"")
    status_json
    ;;
  *)
    echo "Usage: $0 [--status|--toggle]" >&2
    exit 2
    ;;
esac
