#!/usr/bin/env bash
# install/hardware/nvidia.sh - NVIDIA driver selection and installation.
# Picks the driver flavour matching the running kernel and asks the user
# what cannot be inferred (open vs proprietary modules).
# NOTE: this module does NOT touch bootloader config or kernel parameters.

install_gpu_nvidia() {
    step "Installing NVIDIA GPU drivers"

    # Choose driver flavour so the module matches the *running* kernel.
    # - stock mainline kernel            -> nvidia
    # - linux-lts                        -> nvidia-lts
    # - zen / hardened / third-party     -> nvidia-dkms (builds against any kernel)
    local kernel_pkg
    local running_kernel
    running_kernel="$(uname -r)"
    case $running_kernel in
        *lts*)     kernel_pkg="nvidia-lts" ;;
        *zen*|*hardened*|*-omarchy*) kernel_pkg="nvidia-dkms" ;;
        *)         kernel_pkg="nvidia" ;;
    esac
    # Safety net: DKMS works with any kernel. If neither nvidia nor nvidia-lts
    # promotion seems to match what pacman knows about, fall back to DKMS.
    if [[ $kernel_pkg == nvidia ]] && ! pkg_available_in_repo nvidia; then
        warn "nvidia not available in repositories; falling back to nvidia-dkms."
        kernel_pkg="nvidia-dkms"
    fi
    if [[ $kernel_pkg == nvidia-lts ]] && ! pkg_available_in_repo nvidia-lts; then
        warn "nvidia-lts not available in repositories; falling back to nvidia-dkms."
        kernel_pkg="nvidia-dkms"
    fi

    local flavour="proprietary"
    if ((INTERACTIVE)) && [[ -t 0 ]] && ! ((SUPPRESS_PROMPTS)) && ! ((DRY_RUN)); then
        log ""
        log "NVIDIA drivers come in two flavours:"
        log "  - open  : nvidia-open (recommended for Turing, i.e. GTX 16xx/RTX 20xx, and newer)"
        log "  - proprietary: 'nvidia' (older Kepler..Pascal GPUs)"
        if confirm "Use the open kernel modules (nvidia-open)?"; then
            flavour="open"
        fi
    fi

    local packages
    if [[ $flavour == "open" ]]; then
        if [[ $kernel_pkg == "nvidia" ]]; then
            packages=(nvidia-open nvidia-utils)
        else
            packages=(nvidia-open-dkms nvidia-utils)
        fi
    else
        if [[ $kernel_pkg == "nvidia" ]]; then
            packages=(nvidia nvidia-utils)
        elif [[ $kernel_pkg == "nvidia-lts" ]]; then
            packages=(nvidia-lts nvidia-utils)
        else
            packages=(nvidia-dkms nvidia-utils)
        fi
    fi

    log "Selected NVIDIA driver: ${packages[*]}"

    local -a missing=() p
    for p in "${packages[@]}"; do
        pkg_installed "$p" || missing+=("$p")
    done
    if ((${#missing[@]} == 0)); then
        ok "NVIDIA driver already installed."
    else
        install_official "${missing[@]}" || fatal "Failed to install NVIDIA driver packages."
        ok "NVIDIA driver installed."
    fi

    log "Wayland on NVIDIA: modeset is enabled by default in current drivers."
    log "If you use an old driver or hit issues, add nvidia-drm.modeset=1 to your boot"
    log "parameters manually - the installer does not modify your bootloader."
}
