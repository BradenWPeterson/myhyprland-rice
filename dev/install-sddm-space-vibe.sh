#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_SRC="$REPO_ROOT/dotfiles/.local/share/sddm/themes/space-vibe"
THEME_DST="/usr/share/sddm/themes/space-vibe"
CONF_DST="/etc/sddm.conf.d/10-space-vibe.conf"

if [[ ! -d "$THEME_SRC" ]]; then
  echo "Theme source not found: $THEME_SRC" >&2
  exit 1
fi

sudo install -d "$THEME_DST"
sudo cp "$THEME_SRC"/* "$THEME_DST"/
sudo install -d /etc/sddm.conf.d
printf '[Theme]\nCurrent=space-vibe\n' | sudo tee "$CONF_DST" >/dev/null

echo "Installed SDDM theme: space-vibe"
echo "Active theme set in: $CONF_DST"
echo "Reboot or restart SDDM to see changes."
