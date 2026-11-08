#!/usr/bin/env bash
# install/laptop.sh - optional laptop configuration (battery, brightness,
# power profiles). Runs only when a battery is detected.

setup_laptop() {
    step "Laptop configuration"
    if ! compgen -G '/sys/class/power_supply/BAT*' >/dev/null 2>&1; then
        log "No battery detected - this is not a laptop. Skipping laptop module."
        return 0
    fi
    ok "Battery detected."

    # brightnessctl is part of packages/hyprland.txt; verify here anyway.
    if ! pkg_installed brightnessctl; then
        install_official brightnessctl || warn "brightnessctl install failed."
    fi
    if ! pkg_installed upower; then
        install_official upower || warn "upower install failed."
    fi

    # Only one power manager may be active: power-profiles-daemon OR TLP.
    if systemd_active tlp.service; then
        log "TLP detected and active - keeping TLP, skipping power-profiles-daemon."
    elif pkg_installed tlp; then
        warn "TLP is installed but not active."
        if confirm "Enable TLP instead of power-profiles-daemon?"; then
            runsudo systemctl enable --now tlp.service || warn "Could not enable tlp.service."
        else
            _enable_ppd
        fi
    else
        _enable_ppd
    fi

    if systemd_active power-profiles-daemon.service; then
        ok "power-profiles-daemon active (used by waybar-power-profile)."
    elif systemd_active tlp.service; then
        ok "TLP active. Note: waybar-power-profile uses powerprofilesctl and needs PPD."
    fi

    ok "Battery status in waybar, brightness/multimedia keys are configured in dot_config/hypr/hyprland.lua."
}

_enable_ppd() {
    if pkg_installed power-profiles-daemon && ! systemd_enabled power-profiles-daemon; then
        runsudo systemctl enable --now power-profiles-daemon \
            || warn "Could not enable power-profiles-daemon."
    elif systemd_enabled power-profiles-daemon; then
        ok "power-profiles-daemon already enabled."
    else
        warn "power-profiles-daemon not installed; install it to use waybar-power-profile."
    fi
}
