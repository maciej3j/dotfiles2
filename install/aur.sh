#!/usr/bin/env bash
# install/aur.sh - AUR helper (yay) bootstrap and package installation.
# Never runs the AUR helper as root.

install_yay() {
    step "Preparing AUR helper (yay)"
    if have yay; then
        ok "yay already installed."
        return 0
    fi

    ((DRY_RUN)) && { log "[dry-run] build and install yay from AUR"; return 0; }

    local tmpdir
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' RETURN

    if git clone --depth=1 https://aur.archlinux.org/yay.git "$tmpdir/yay"; then
        makepkg -si --needed --noconfirm -D "$tmpdir/yay" \
            || fatal "Failed to build yay. Install it manually and re-run."
        trap - RETURN
        rm -rf "$tmpdir"
        have yay || fatal "yay build finished but binary is not available."
        ok "yay installed from AUR."
    else
        fatal "Could not clone yay from AUR. Check network."
    fi
}

install_aur_packages() {
    local list_file="$DOTFILES_ROOT/packages/aur.txt"
    have yay || install_yay

    step "Installing AUR packages (${list_file})"
    local -a pkgs missing=() skipped=() p
    mapfile -t pkgs < <(read_package_list "$list_file")
    ((${#pkgs[@]})) || { ok "No AUR packages configured."; return 0; }

    for p in "${pkgs[@]}"; do
        if pkg_available_in_repo "$p"; then
            skipped+=("$p")
        elif pkg_installed "$p" || (have yay && yay -Qqi "$p" >/dev/null 2>&1); then
            ok "AUR package already installed: $p"
        else
            missing+=("$p")
        fi
    done
    for p in "${skipped[@]}"; do
        log "AUR package '$p' is now available in official repos - NOT installed from AUR."
    done
    ((${#missing[@]})) || { ok "No missing AUR packages."; return 0; }

    log "AUR packages to install: ${missing[*]}"
    if ((DRY_RUN)); then
        log "[dry-run] yay -S --needed --noconfirm ${missing[*]}"
        return 0
    fi
    yay -S --needed --noconfirm -- "${missing[@]}" || fatal "yay failed to install: ${missing[*]}"
    ok "AUR packages installed: ${missing[*]}"
}
