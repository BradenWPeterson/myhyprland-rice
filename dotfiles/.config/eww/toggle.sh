#!/usr/bin/env bash

if ! pgrep -x eww >/dev/null 2>&1; then
  eww daemon >/dev/null 2>&1 &
  sleep 0.2
fi

eww open --toggle space-telemetry
