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
  brightnessctl \
  bluetui \
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
  git \
  go \
  grim \
  hypridle \
  hyprland \
  hyprlock \
  hyprpolkitagent \
  hyprpaper \
  htop \
  lazygit \
  lm_sensors \
  mako \
  mesa \
  neovim \
  nodejs \
  npm \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  opencode \
  okular \
  pipewire \
  pipewire-pulse \
  power-profiles-daemon \
  playerctl \
  polkit \
  prettier \
  python \
  ruff \
  sddm \
  ripgrep \
  rustup \
  slurp \
  stylua \
  thunar \
  ttf-dejavu \
  ttf-jetbrains-mono-nerd \
  qt5-wayland \
  qt6-wayland \
  qt6-multimedia-ffmpeg \
  qt6-svg \
  qt6-virtualkeyboard \
  uwsm \
  uv \
  waybar \
  wireplumber \
  wl-clipboard \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-hyprland \
  xorg-xwayland \
  yazi \
  zellij \
  zsh

git config --global user.email "maciej.ko1444@gmail.com"
git config --global user.name "Maciej Kowalski"

rustup default stable
rustup component add rust-analyzer rustfmt clippy

if ! command -v yay >/dev/null 2>&1; then
    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "$tmp_dir"' EXIT

    git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp_dir/yay"
    makepkg -si --needed --noconfirm -D "$tmp_dir/yay"
fi

yay -S --needed --noconfirm wlctl-bin omp-bin

theme_dir="/usr/share/sddm/themes/sddm-astronaut-theme"
if [[ -d "$theme_dir/.git" ]]; then
  sudo git -C "$theme_dir" pull --ff-only
elif [[ ! -e "$theme_dir" ]]; then
  sudo git clone --branch master --depth=1 \
    https://github.com/Keyitdev/sddm-astronaut-theme.git "$theme_dir"
else
  printf 'SDDM theme directory exists but is not a Git repository: %s\n' "$theme_dir" >&2
  exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
sudo install -Dm644 "$script_dir/sddm-theme.conf" /etc/sddm.conf.d/10-theme.conf
sudo systemctl enable sddm.service


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

sudo systemctl enable --now docker.socket

if ! id -nG "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
fi

if ! gh auth status >/dev/null 2>&1; then
  gh auth login --git-protocol ssh
fi

source_dir="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
if [[ -d "$source_dir/.git" ]]; then
    git -C "$source_dir" remote set-url origin \
        git@github.com:maciej3j/dotfiles2.git
    chezmoi update
else
  chezmoi init --apply git@github.com:maciej3j/dotfiles2.git
fi
