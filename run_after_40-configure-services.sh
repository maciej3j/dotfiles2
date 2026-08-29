#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f /etc/arch-release ]]; then
  exit 0
fi

sudo systemctl enable --now NetworkManager.service bluetooth.service docker.service

if ! getent group docker | cut -d: -f4 | tr ',' '\n' | grep -qx "$USER"; then
  sudo usermod -aG docker "$USER"
  printf 'Added %s to the docker group; log out and back in before using Docker without sudo.\n' "$USER"
fi

# PipeWire is socket-activated; enabling its units makes it available before
# the first desktop application requests audio.
if systemctl --user show-environment >/dev/null 2>&1; then
  systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
  systemctl --user enable hyprpolkitagent.service
fi
