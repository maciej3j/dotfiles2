#!/usr/bin/env bash
# install/hardware/nvidia.sh - NVIDIA driver selection and installation.
# - detects the running kernel and installed kernel packages,
# - picks driver flavour matching that kernel (nvidia / nvidia-lts / nvidia-dkms),
# - checks package availability before installing and falls back to DKMS,
# - installs matching kernel headers when DKMS is used,
# - decides open vs proprietary kernel modules from the PCI device id
#   (open is supported Turing 0x1Exx and newer; never assumed otherwise).
# NOTE: this module does NOT touch bootloader config or kernel parameters.

nvidia_display_device_ids() {
    # prints 4-hex device ids for NVIDIA display devices (lspci -nn output)
    lspci -nn 2>/dev/null \
        | grep -Ei 'VGA|3D|Display' \
        | grep '\[10de:' \
        | sed -n 's/.*\[10de:\([0-9a-fA-F]\{4\}\)\].*/\1/p' \
        | sort -u
}

nvidia_open_supported() {
    #$1 = 4-hex NVIDIA device id; open modules officially support Turing+
    local id="${1,,}"
    [[ $id =~ ^[0-9a-f]{4}$ ]] || return 1
    ((16#$id >= 16#1e00))
}

kernel_headers_for() {
    #$1 = running kernel release string; echoes matching headers package or nothing
    local krel="${1:-}"
    local kpkg="" hpkg=""
    case $krel in
        *-lts*)      kpkg="linux-lts" ;;
        *zen*)       kpkg="linux-zen" ;;
        *hardened*)  kpkg="linux-hardened" ;;
        *-rt*-*)     kpkg="linux-rt" ;;
        # unknown/custom kernel releases cannot be matched to repo headers
        *arch1-1*)   kpkg="linux" ;;
        *)           warn "Kernel '$krel' has a non-standard release name; DKMS needs its matching headers (install manually)." ; return 0 ;;
    esac
    if pkg_installed "$kpkg"; then
        hpkg="${kpkg}-headers"
        if pkg_installed "$hpkg"; then
            : # headers already there
        elif pkg_available_in_repo "$hpkg"; then
            printf '%s\n' "$hpkg"
        else
            warn "Kernel headers '$hpkg' are not available in repositories; DKMS may fail."
        fi
    else
        warn "Kernel '$krel' (package '$kpkg') is not installed; install matching kernel headers manually for DKMS."
    fi
}

install_gpu_nvidia() {
    step "Installing NVIDIA GPU drivers"

    local running_kernel
    running_kernel="$(uname -r)"
    log "Running kernel: $running_kernel"

    # ---------------------------------------------------------- driver flavour
    # The driver flavour must match the *running* kernel package, otherwise
    # fall back to DKMS which can build against any kernel.
    local flavour="dkms"
    local -a installed_kernels=()
    pacman -Qq linux        >/dev/null 2>&1 && installed_kernels+=(linux)
    pacman -Qq linux-lts    >/dev/null 2>&1 && installed_kernels+=(linux-lts)
    pacman -Qq linux-zen    >/dev/null 2>&1 && installed_kernels+=(linux-zen)
    pacman -Qq linux-hardened >/dev/null 2>&1 && installed_kernels+=(linux-hardened)
    log "Installed kernel packages: ${installed_kernels[*]:-none}"
    case $running_kernel in
        *-lts*)     pkg_installed linux-lts && flavour="lts" ;;
        *zen*)      : ;;   # flavour dkms (+ linux-zen-headers via kernel_headers_for)
        *hardened*) : ;;   # flavour dkms
        *arch1-1*)  pkg_installed linux && flavour="mainline" ;;
        *)          : ;;   # third-party/custom kernel -> dkms
    esac
    log "Driver flavour selected: $flavour"

    # ------------------------------------------------- open vs proprietary
    # Open kernel modules officially require Turing (0x1Exx) or newer.
    local open_decision="proprietary" id
    local known=0 older=0
    while IFS= read -r id; do
        if [[ $id =~ ^[0-9a-fA-F]{4}$ ]]; then
            known=1
            nvidia_open_supported "$id" || older=1
            if nvidia_open_supported "$id"; then
                log "NVIDIA device 10de:$id: Turing-or-newer (open kernel modules supported)."
            else
                log "NVIDIA device 10de:$id: pre-Turing generation (proprietary modules required)."
            fi
        fi
    done < <(nvidia_display_device_ids)
    if ((known == 0)); then
        warn "Could not read NVIDIA PCI device ids."
        if ((INTERACTIVE)) && [[ -t 0 ]] && ! ((SUPPRESS_PROMPTS)) && ! ((DRY_RUN)); then
            if confirm "Is your NVIDIA GPU Turing or newer (GTX 16xx / RTX 20xx and up)?"; then
                open_decision="open"
            fi
        else
            log "Defaulting to proprietary modules (supported by every NVIDIA generation)."
        fi
    elif ((older)); then
        # Any pre-Turing card in the system keeps us on proprietary modules.
        open_decision="proprietary"
        log "Using proprietary modules (system contains a pre-Turing NVIDIA GPU)."
    else
        open_decision="open"
        log "Using open kernel modules (all NVIDIA GPUs here support them)."
    fi

    # ------------------------------------------------- package selection
    local -a packages=()
    if [[ $open_decision == open ]]; then
        case $flavour in
            mainline) packages=(nvidia-open nvidia-utils) ;;
            lts)      packages=(nvidia-open-dkms nvidia-utils) ;;
            dkms)     packages=(nvidia-open-dkms nvidia-utils) ;;
        esac
    else
        case $flavour in
            mainline) packages=(nvidia nvidia-utils) ;;
            lts)      packages=(nvidia-lts nvidia-utils) ;;
            dkms)     packages=(nvidia-dkms nvidia-utils) ;;
        esac
    fi

    # Availability check with DKMS fallback before installing anything.
    local driver_pkg="${packages[0]}"
    if ! pkg_available_in_repo "$driver_pkg"; then
        warn "$driver_pkg is not available in repositories."
        if pkg_available_in_repo nvidia-dkms && [[ $driver_pkg != nvidia-dkms ]]; then
            log "Falling back to nvidia-dkms (builds against any kernel)."
            packages[0]="nvidia-dkms"
            driver_pkg="nvidia-dkms"
        else
            fatal "No suitable NVIDIA driver package found (nvidia / nvidia-lts / nvidia-dkms / nvidia-open)."
        fi
    fi

    # DKMS needs kernel headers matching the running kernel.
    if [[ $driver_pkg == *dkms ]]; then
        local headers
        headers="$(kernel_headers_for "$running_kernel")"
        [[ -n $headers ]] && packages+=("$headers")
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
