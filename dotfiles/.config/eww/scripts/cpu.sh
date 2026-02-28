#!/usr/bin/env bash
set -eo pipefail

state_file="/tmp/eww-cpu-prev-${UID:-1000}"

if ! read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat; then
  echo "0"
  exit 0
fi
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_all=$((idle + iowait))

if [[ ! -f "$state_file" ]]; then
  printf '%s %s\n' "$total" "$idle_all" > "$state_file" || true
  echo "0"
  exit 0
fi

if ! read -r prev_total prev_idle < "$state_file"; then
  echo "0"
  exit 0
fi
printf '%s %s\n' "$total" "$idle_all" > "$state_file" || true

diff_total=$((total - prev_total))
diff_idle=$((idle_all - prev_idle))

if ((diff_total <= 0)); then
  echo "0"
  exit 0
fi

usage=$(((100 * (diff_total - diff_idle)) / diff_total))
echo "$usage"
