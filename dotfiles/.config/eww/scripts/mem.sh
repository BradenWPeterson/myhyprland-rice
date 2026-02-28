#!/usr/bin/env bash
set -eo pipefail

mem_total_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
mem_avail_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)

if [[ -z "${mem_total_kb:-}" || -z "${mem_avail_kb:-}" || "$mem_total_kb" -eq 0 ]]; then
  echo "0"
  exit 0
fi

mem_used_kb=$((mem_total_kb - mem_avail_kb))
usage=$((100 * mem_used_kb / mem_total_kb))
echo "$usage"
