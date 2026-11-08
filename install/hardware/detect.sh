#!/usr/bin/env bash
# install/hardware/detect.sh - GPU detection via lspci.
# Prints detected vendors (one per line): amd | intel | nvidia.
# Should be sourced by install.sh (uses install/lib/common.sh helpers).

detect_gpus() {
    if ! have lspci; then
        err "lspci not available (is pciutils installed?). Cannot detect GPU."
        return 1
    fi

    local vendor vendor_id
    for vendor in amd intel nvidia; do
        case $vendor in
            amd)    vendor_id=1002 ;;
            intel)  vendor_id=8086 ;;
            nvidia) vendor_id=10de ;;
        esac
        # display-class devices (VGA/3D/Display) from that vendor
        if lspci -nnm -d "${vendor_id}:*" 2>/dev/null | grep -Ei '"[^"]*(VGA|3D|Display)' >/dev/null; then
            printf '%s\n' "$vendor"
        fi
    done
}

gpu_vendor_for_device() {
    #$1 = numeric PCI vendor id e.g. 10de
    case "${1,,}" in
        10de)  printf 'nvidia' ;;
        1002)  printf 'amd' ;;
        8086)  printf 'intel' ;;
        *) printf '' ;;
    esac
}
