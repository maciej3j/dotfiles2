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
  adwaita-icon-theme \
  base-devel \
  bat \
  bluez \
  bluez-utils \
  brightnessctl \
  chezmoi \
  curl \
  docker \
  docker-buildx \
  eza \
  fd \
  foot \
  fuzzel \
  fzf \
  firefox \
  github-cli \
  greetd \
  greetd-tuigreet \
  git \
  go \
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
  sudo \
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

git config --global user.email "maciej.ko1444@gmail.com"
git config --global user.name "Maciej Kowalski"
if ! rustup toolchain list | grep -q '^stable'; then
  rustup default stable
fi

if ! command -v yay >/dev/null 2>&1; then
  git clone --depth=1 https://aur.archlinux.org/yay.git

  cd yay
  makepkg -si --needed --noconfirm
  cd ..
  rm -rf yay
fi

source_dir="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
if [[ -d "$source_dir/.git" ]]; then
  chezmoi update
else
  chezmoi init --apply maciej3j/dotfiles2
fi

if [[ ! -d "$HOME/.oh-my-zsh/.git" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  git -C "$HOME/.oh-my-zsh" pull --ff-only
fi

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
  chsh -s "$(command -v zsh)"
fi

zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only
  else
    git clone --depth=1 "$repo" "$dest"
  fi
}

clone_or_update \
  https://github.com/zsh-users/zsh-autosuggestions.git \
  "$zsh_custom/plugins/zsh-autosuggestions"

clone_or_update \
  https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  "$zsh_custom/plugins/fast-syntax-highlighting"

clone_or_update \
  https://github.com/marlonrichert/zsh-autocomplete.git \
  "$zsh_custom/plugins/zsh-autocomplete"

tpm_dir="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$tpm_dir/.git" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$tpm_dir"
fi

"$tpm_dir/bin/install_plugins"

sudo systemctl enable --now NetworkManager.service bluetooth.service docker.service

if ! getent group docker | cut -d: -f4 | tr ',' '\n' | grep -qx "$USER"; then
  sudo usermod -aG docker "$USER"
  printf 'Added %s to the docker group; log out and back in before using Docker without sudo.\n' "$USER"
fi


# PipeWire is socket-activated; enabling its units makes it available before
# the first desktop application requests audio.
# if systemctl --user show-environment >/dev/null 2>&1; then
#   systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
#   systemctl --user enable hyprpolkitagent.service
# fi

gh auth login
