#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f /etc/arch-release ]] || command -v yay >/dev/null; then
  exit 0
fi

build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT
git clone --depth=1 https://aur.archlinux.org/yay.git "$build_dir/yay"
pushd "$build_dir/yay" >/dev/null
makepkg -si --needed --noconfirm
popd >/dev/null
