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
#   --yes                             assume yes for all prompts (non-interactive)
#   --dry-run                         print actions without executing them
#   --log FILE                        custom log file
#   --help                            this text

set -euo pipefail

#------------------------------------------------------------------------------
# Globals (filled by option parsing)
#------------------------------------------------------------------------------
GPU_MODE="auto"        # auto | amd | intel | nvidia | all | skip
WITH_OPTIONAL=0
SDDM_MODE="auto"      # yes | no | auto
DO_UPGRADE=1
DOTS_ONLY=0

SCRIPT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

usage() { printf '%s\n' "$1"; exit "$2"; }

parse_args() {
    local arg
    while (($#)); do
        arg="$1"; shift
        case $arg in
            --gpu=*)        GPU_MODE="${arg#--gpu=}" ;;
            --skip-gpu)     GPU_MODE="skip" ;;
            --with-optional) WITH_OPTIONAL=1 ;;
            --sddm)         SDDM_MODE="yes" ;;
            --no-sddm)      SDDM_MODE="no" ;;
            --skip-upgrade) DO_UPGRADE=0 ;;
            --dots-only)    DOTS_ONLY=1 ;;
            --yes)          SUPPRESS_PROMPTS=1 ;;
            --dry-run)      DRY_RUN=1 ;;
            --log)          LOG_FILE="${1:?--log needs a value}"; shift ;;
            --help|-h)      usage "Usage: ./install.sh [options] - see header of install.sh" 0 ;;
            *) usage "Unknown option: $arg\nRun ./install.sh --help for usage." 1 ;;
        esac
    done
    case $GPU_MODE in
        auto|amd|intel|nvidia|all|skip) ;;
        *) usage "Invalid --gpu value: $GPU_MODE" 1 ;;
    esac
}

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
# GPU step
#------------------------------------------------------------------------------
install_gpus() {
    [[ $GPU_MODE != skip ]] || { log "Skipping GPU driver setup (--skip-gpu)."; return 0; }
    step "GPU detection / driver setup"
    source "$GPU_DIR/detect.sh"
    have lspci || fatal "lspci missing; install pciutils or rerun with --skip-gpu."
    local -a detected
    mapfile -t detected < <(detect_gpus)

    local -a selected=()
    if [[ $GPU_MODE == auto ]]; then
        if ((${#detected[@]} == 1)); then
            selected=("${detected[@]}")
            log "Detected GPU vendor: ${detected[0]}"
        elif ((${#detected[@]} > 1)); then
            warn "Multiple GPUs detected: ${detected[*]} (hybrid graphics)."
            log "GPU drivers for each detected vendor can be installed together."
            if confirm "Install drivers for ALL detected GPUs (${detected[*]})?"; then
                selected=("${detected[@]}")
            else
                selected=($(ask_gpu_choice "${detected[@]}"))
            fi
        else
            warn "No GPU detected via lspci."
            if ((SUPPRESS_PROMPTS)) || ! [[ -t 0 ]]; then
                log "Continuing without GPU driver installation. Rerun with --gpu=amd|intel|nvidia to force one."
                return 0
            fi
            selected=($(ask_gpu_choice amd intel nvidia))
        fi
    else
        selected=(${GPU_MODE//,/ })
    fi

    local vendor
    for vendor in "${selected[@]}"; do
        case $vendor in
            amd)    source "$GPU_DIR/amd.sh";   install_gpu_amd ;;
            intel)  source "$GPU_DIR/intel.sh";  install_gpu_intel ;;
            nvidia) source "$GPU_DIR/nvidia.sh"; install_gpu_nvidia ;;
            all)    source "$GPU_DIR/amd.sh"; install_gpu_amd
                    source "$GPU_DIR/intel.sh"; install_gpu_intel
                    source "$GPU_DIR/nvidia.sh"; install_gpu_nvidia ;;
            *) warn "Unknown GPU kind: $vendor (skipped)" ;;
        esac
    done
}

ask_gpu_choice() {
    #$@ = options to choose from; echoes the chosen vendor
    if ! [[ -t 0 ]]; then
        printf '%s\n' $1 # first option as fallback
        return 0
    fi
    local i choice options=("$@")
    printf 'Available GPU kinds:\n'
    for i in "${!options[@]}"; do
        printf '  %d) %s\n' $((i + 1)) "${options[$i]}"
    done
    local reply=""
    printf 'Select GPU vendor [1-%d] (comma-separated for hybrid): ' "${#options[@]}"
    read -r reply
    [[ -n $reply ]] || reply="1"
    local out="" n
    local -a picks
    mapfile -t picks < <(printf '%s\n' ${reply//,/ }) # shellcheck disable=SC2206,SC2086
    for n in "${picks[@]}"; do
        if [[ $n =~ ^[0-9]+$ ]] && ((n >= 1 && n <= ${#options[@]})); then
            out+=" ${options[$((n - 1))]}"
        fi
    done
    [[ -n ${out// } ]] || out=" $1"
    printf '%s\n' "${out// / }"
}

#------------------------------------------------------------------------------
# Main flow
#------------------------------------------------------------------------------
main() {
    parse_args "$@"

    # Log everything (start at fresh log each run).
    : >"$LOG_FILE" 2>/dev/null || true
    step "dotfiles2 installer starting (log: $LOG_FILE)"
    log "Working directory: $REPO_ROOT"

    require_arch
    require_not_root
    require_pacman
    require_network
    if ((DRY_RUN)); then
        warn "DRY RUN mode: nothing will be executed, only printed."
    fi

    if ! ((DRY_RUN)); then
        sudo -v || fatal "sudo is required for pacman/services operations."
    else
        log "DRY RUN: skipping sudo validation."
    fi

    if ((DOTS_ONLY)); then
        step "--dots-only: skipping package installation"
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
    fi
    deploy_dotfiles

    step "Verification"
    if run_verify; then
        :
    else
        warn "Verification reported problems - review the report above."
    fi

    log ""
    log "Done. Log out and back in (or reboot) and pick the Hyprland (uwsm) session."
    log "Full install log: $LOG_FILE"
}

main "$@"
