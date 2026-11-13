#!/usr/bin/env bash
# install.sh - dotfiles2 installer for fresh Arch Linux + Hyprland setups.
# Usage: ./install.sh [options]
#
# Options:
#   --gpu=amd|intel|nvidia|all|auto   GPU driver selection (default: auto-detect)
#   --skip-gpu                        skip GPU driver installation entirely
#   --with-optional                   also install packages/optional.txt (Docker etc.)
#   --sddm | --no-sddm                force enable / skip the SDDM display manager
#   --skip-upgrade                    do not run pacman -Syu first
#   --dots-only                       skip package installation; only deploy dotfiles
#                                     (no sudo, no network - local checkout only)
#   --yes                             assume yes for all prompts (non-interactive).
#                                     NOTE: --yes also means SDDM WILL be installed
#                                     and enabled, unless --no-sddm is given.
#   --dry-run                         print actions without executing them
#   --log FILE                        custom log file
#   --help                            this text

set -euo pipefail

#------------------------------------------------------------------------------
# Globals (filled by option parsing)
#------------------------------------------------------------------------------
SCRIPT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

#------------------------------------------------------------------------------
# Library
#------------------------------------------------------------------------------
source "$REPO_ROOT/install/lib/common.sh"
source "$REPO_ROOT/install/dotfiles.sh"
source "$REPO_ROOT/install/packages.sh"
source "$REPO_ROOT/install/aur.sh"
source "$REPO_ROOT/install/services.sh"
source "$REPO_ROOT/install/laptop.sh"
source "$REPO_ROOT/install/verify.sh"
GPU_DIR="$REPO_ROOT/install/hardware"

#------------------------------------------------------------------------------
# Main flow
#------------------------------------------------------------------------------
main() {
    step "dotfiles2 installer starting (log: $LOG_FILE)"
    log "Working directory: $REPO_ROOT"

    require_arch
    require_not_root
    require_pacman
    if ((DOTS_ONLY)); then
        log "--dots-only: skipping network and sudo checks (local checkout only)."
    else
        require_network
    fi
    if ((DRY_RUN)); then
        warn "DRY RUN mode: nothing will be executed, only printed."
    fi

    if ! ((DRY_RUN)) && ! ((DOTS_ONLY)); then
        sudo -v || fatal "sudo is required for pacman/services operations."
    fi

    if ((DOTS_ONLY)); then
        step "--dots-only: skipping package installation"
        deploy_dotfiles_local || fatal "Dotfiles deployment failed."
    else
        if ((DO_UPGRADE)); then
            upgrade_system
        else
            log "Skipping system upgrade (--skip-upgrade)."
        fi
        install_all_packages
        install_aur_packages
        install_gpus
        install_services
        setup_laptop
        deploy_dotfiles || fatal "Dotfiles deployment failed."
    fi

    step "Verification"
    if ! run_verify; then
        warn "Verification found critical problems - see the MISSING/FAIL entries above."
        log "Installation finished with problems; exit code non-zero."
        exit 1
    fi

    log ""
    log "Done. Log out and back in (or reboot) and pick the Hyprland (uwsm) session."
    log "Full install log: $LOG_FILE"
}

main "$@"
