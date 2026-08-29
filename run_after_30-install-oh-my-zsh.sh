#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "$HOME/.oh-my-zsh/.git" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  git -C "$HOME/.oh-my-zsh" pull --ff-only
fi

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
  chsh -s "$(command -v zsh)"
fi
