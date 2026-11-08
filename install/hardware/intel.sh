#!/usr/bin/env bash
# install/hardware/intel.sh - Intel GPU driver stack (Mesa, Vulkan Intel, media driver).

install_gpu_intel() {
    step "Installing Intel GPU drivers"
    # libva-intel-driver covers pre-Broadwell iGPUs via i965, intel-media-driver
    # covers Broadwell+ via iHD; both are small and can coexist.
    local packages=(mesa vulkan-intel vulkan-mesa-layers intel-media-driver libva-intel-driver)
    local -a missing=() p
    for p in "${packages[@]}"; do
        pkg_installed "$p" || missing+=("$p")
    done
    if ((${#missing[@]} == 0)); then
        ok "Intel GPU drivers already installed."
        return 0
    fi
    install_official "${missing[@]}" || fatal "Failed to install Intel GPU drivers."
    ok "Intel GPU drivers installed (Mesa + Vulkan + media driver)."
}
