#!/usr/bin/env bash
# install/hardware/amd.sh - AMD GPU driver stack (Mesa, Vulkan Radeon, VA-API).

install_gpu_amd() {
    step "Installing AMD GPU drivers"
    local packages=(mesa vulkan-radeon vulkan-mesa-layers libva-mesa-driver mesa-vdpau)
    local -a missing=() p
    for p in "${packages[@]}"; do
        pkg_installed "$p" || missing+=("$p")
    done
    if ((${#missing[@]} == 0)); then
        ok "AMD GPU drivers already installed."
        return 0
    fi
    install_official "${missing[@]}" || fatal "Failed to install AMD GPU drivers."
    ok "AMD GPU drivers installed (Mesa + Vulkan Radeon + VA-API)."
}
