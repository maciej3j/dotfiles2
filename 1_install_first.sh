#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f /etc/arch-release ]]; then
  printf 'This bootstrap script supports Arch Linux only.\n' >&2
  exit 1
fi

if [[ ${EUID} -eq 0 ]]; then
  printf 'Run this script as your regular user, not root.\n' >&2
  exit 1
fi

sudo -v
sudo pacman -Syu --needed --noconfirm \
  base-devel \
  chezmoi \
  curl \
  fd \
  fzf \
  git \
  go \
  ripgrep \
  sudo

source_dir="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
if [[ -d "$source_dir/.git" ]]; then
  chezmoi update
else
  chezmoi init --apply maciej3j/dotfiles2
fi
