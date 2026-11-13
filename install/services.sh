#!/usr/bin/env bash
# install/services.sh - system and user services for the Hyprland session.

SYSTEM_SERVICES=(NetworkManager bluetooth.service pkgfile-update.timer)
USER_SERVICES=(pipewire pipewire-pulse wireplumber)

config_display_manager() {
    step "Display manager (SDDM)"
    # Modes: yes (install+enable), no (skip), auto (prompt on interactive TTY).
    local sddm_mode="${SDDM_MODE:-auto}"
    if [[ $sddm_mode == no ]]; then
        log "Skipping SDDM configuration (--no-sddm)."
        return 0
    fi
    if [[ $sddm_mode == auto ]]; then
        if ((DRY_RUN)) || ((SUPPRESS_PROMPTS)) || [[ ! -t 0 ]]; then
            log "Skipping SDDM configuration (non-interactive). Configure manually if needed."
            return 0
        fi
        if ! confirm "Install and enable SDDM as display manager (recommended on a fresh system)?"; then
            log "Skipping SDDM. You can start Hyprland manually via 'uwsm start hyprland'."
            return 0
        fi
    fi

    pkg_installed sddm || install_official sddm || fatal "Failed to install sddm."

    # Theme: sddm-astronaut-theme (git-based, mirrors scripts/1_install_first.sh).
    local theme_dir="/usr/share/sddm/themes/sddm-astronaut-theme"
    if ((DRY_RUN)); then
        log "[dry-run] install sddm-astronaut-theme + sddm theme config"
    elif [[ -d $theme_dir/.git ]]; then
        git -C "$theme_dir" pull --ff-only || warn "Could not update sddm-astronaut-theme."
    elif [[ ! -e $theme_dir ]]; then
        runsudo git clone --branch master --depth=1 \
            https://github.com/Keyitdev/sddm-astronaut-theme.git -- "$theme_dir" \
            || fatal "Failed to clone sddm-astronaut-theme."
        ok "sddm-astronaut-theme cloned."
    else
        warn "SDDM theme directory exists but is not a git checkout: $theme_dir (left untouched)."
    fi
    if ! ((DRY_RUN)); then
        runsudo install -Dm644 "$DOTFILES_ROOT/scripts/sddm-theme.conf" /etc/sddm.conf.d/10-theme.conf \
            || warn "Could not install sddm theme config."
    fi

    # Refuse to fight over the seat with another active display manager.
    local dm_link="/etc/systemd/system/display-manager.service"
    if [[ -L $dm_link ]]; then
        local current_dm
        current_dm="$(readlink -- "$dm_link")"
        if [[ $current_dm != *sddm* ]]; then
            log "Another display manager is enabled: $current_dm."
            if ! ((SUPPRESS_PROMPTS)) && ! confirm "Replace it with SDDM? (disables $current_dm)"; then
                warn "SDDM installed but not enabled."
                return 0
            fi
            if ! ((DRY_RUN)); then
                runsudo systemctl disable --now "$current_dm" || warn "Could not disable $current_dm."
            else
                log "[dry-run] sudo systemctl disable --now $current_dm"
            fi
        fi
    fi
    if ! systemd_enabled sddm.service; then
        runsudo systemctl enable sddm.service || warn "Could not enable sddm.service."
    else
        ok "sddm.service already enabled."
    fi
}

config_system_services() {
    step "Enabling system services"
    local svc
    for svc in "${SYSTEM_SERVICES[@]}"; do
        # pkgfile's update timer only makes sense when pkgfile is installed.
        if [[ $svc == pkgfile-update.timer ]] && ! pkg_installed pkgfile; then
            log "pkgfile not installed, skipping $svc."
            continue
        fi
        if systemd_enabled "$svc"; then
            ok "$svc already enabled."
            continue
        fi
        if runsudo systemctl enable --now "$svc"; then
            ok "$svc enabled."
        else
            warn "Failed to enable $svc (check manually)."
        fi
    done
}

config_user_services() {
    step "Enabling user services (PipeWire, WirePlumber)"
    local svc
    for svc in "${USER_SERVICES[@]}"; do
        if systemd_user_enabled "$svc"; then
            ok "$svc (user) already enabled."
            continue
        fi
        if systemctl --user enable --now "$svc" 2>/dev/null; then
            ok "$svc (user) enabled."
        else
            warn "Failed to enable user service $svc."
        fi
    done
}

check_portals() {
    step "Verifying XDG portals"
    local portal_dir="/usr/share/xdg-desktop-portal/portals"
    local -a expected=(hyprland.portal gtk.portal)
    local missing=0 f
    for f in "${expected[@]}"; do
        if [[ -f $portal_dir/$f ]]; then
            ok "Portal present: $f"
        else
            err "Portal missing: $portal_dir/$f"
            missing=1
        fi
    done
    ((missing)) && warn "Screensharing/file dialogs may not work; reinstall xdg-desktop-portal-hyprland and xdg-desktop-portal-gtk."
    return 0
}

config_polkit() {
    step "Polkit agent"
    if pkg_installed hyprpolkitagent; then
        ok "hyprpolkitagent installed; launched from the Hyprland session (dot_config/hypr/hyprland.lua)."
    else
        warn "hyprpolkitagent not installed - privilege prompts will not appear."
    fi
    if [[ -f /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop ]]; then
        warn "Legacy polkit-gnome agent detected; two agents running at once is not supported."
    fi
}

install_services() {
    config_display_manager
    config_system_services
    config_user_services
    check_portals
    config_polkit
    log ""
    log "Note: UPower and UDisks2 are D-Bus activated - no manual systemctl enable is needed."
}
