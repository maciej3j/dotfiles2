#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f /etc/arch-release ]]; then
  printf 'Skipping Arch package installation: this is not Arch Linux.\n'
  exit 0
fi

sudo -v
sudo pacman -Syu --needed --noconfirm \
  bluez \
  bluez-utils \
  adwaita-icon-theme \
  brightnessctl \
  docker \
  docker-buildx \
  fd \
  foot \
  fuzzel \
  fzf \
  firefox \
  greetd \
  greetd-tuigreet \
  git \
  grim \
  hypridle \
  hyprland \
  hyprlock \
  hyprpolkitagent \
  hyprpaper \
  lazygit \
  mako \
  mesa \
  neovim \
  networkmanager \
  nodejs \
  npm \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  pipewire \
  pipewire-pulse \
  playerctl \
  polkit \
  prettier \
  python \
  python-pip \
  ruff \
  ripgrep \
  rust-analyzer \
  rustup \
  slurp \
  stylua \
  thunar \
  ttf-dejavu \
  ttf-jetbrains-mono-nerd \
  tmux \
  qt5-wayland \
  qt6-wayland \
  uwsm \
  uv \
  waybar \
  wireplumber \
  wl-clipboard \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-hyprland \
  xorg-xwayland \
  yazi \
  zsh

if ! rustup toolchain list | grep -q '^stable'; then
  rustup default stable
fi
