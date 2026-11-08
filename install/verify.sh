#!/usr/bin/env bash
# install/verify.sh - post-install verification with a readable report.
# Exit code: 0 = all critical checks passed, 1 = critical problems found.

RESULT_OK=0 RESULT_BAD=1
CRITICAL_FAILURES=0

verify_ok()      { printf '[OK]      %s\n' "$*"; }
verify_missing() { printf '[MISSING] %s\n' "$*"; CRITICAL_FAILURES=1; }
verify_warn()    { printf '[WARNING] %s\n' "$*"; }
verify_fail()    { printf '[FAIL]    %s\n' "$*"; CRITICAL_FAILURES=1; }

verify_command() {
    #$1 = command, $2 = critical(1)/optional(0)
    if have "$1"; then
        verify_ok "$1"
    elif [[ ${2:-1} == 1 ]]; then
        verify_missing "$1"
    else
        verify_warn "$1 not found (optional)"
    fi
}

verify_file() {
    #$1 = path, $2 = critical(1)/optional(0)
    if [[ -f $1 ]]; then
        verify_ok "$1"
    elif [[ ${2:-1} == 1 ]]; then
        verify_missing "$1"
    else
        verify_warn "$1 (optional)"
    fi
}

verify_service() {
    #$1 = service name, $2 = "system"/"user"
    if [[ ${2:-system} == user ]]; then
        systemd_user_enabled "$1" && systemd_user_active "$1" \
            && verify_ok "$1 (user service)" || verify_warn "$1 (user service) not active"
    else
        systemd_enabled "$1" || verify_missing "$1 (not enabled)"
        systemd_active "$1" || verify_warn "$1 (installed but inactive)"
        systemd_active "$1" && verify_ok "$1 running"
    fi
}

verify_commands() {
    step "Commands"
    local -a critical=(hyprland hyprctl waybar foot fuzzel mako hyprlock hypridle hyprpaper
        grim slurp wl-copy wl-paste cliphist brightnessctl playerctl uwsm wpctl
        bluetui nmtui firefox thunar okular nvim git zsh tmux chezmoi zellij
        bat eza fzf rg fd jq htop yazi lazygit uv rustup go node npm python)
    local -a optional=(docker pulsemixer bluetuith gh wlctl opencode)
    local c
    for c in "${critical[@]}"; do verify_command "$c" 1; done
    for c in "${optional[@]}"; do verify_command "$c" 0; done
}

verify_configs() {
    step "Configurations"
    verify_file "$HOME/.config/hypr/hyprland.lua" 1
    verify_file "$HOME/.config/hypr/hyprlock.conf" 1
    verify_file "$HOME/.config/hypr/hypridle.conf" 1
    verify_file "$HOME/.config/hypr/hyprpaper.conf" 1
    verify_file "$HOME/.config/hypr/scripts/powermenu.sh" 1
    verify_file "$HOME/.config/waybar/config.jsonc" 1
    verify_file "$HOME/.config/waybar/style.css" 1
    verify_file "$HOME/.config/foot/foot.ini" 1
    verify_file "$HOME/.config/mako/config" 1
    verify_file "$HOME/.config/uwsm/env" 0
    verify_file "$HOME/.config/zsh/zshrc" 1
    verify_file "$HOME/.zshenv" 0
    verify_file "$HOME/.gitconfig" 1
    verify_file "$HOME/.local/share/wallpapers/vesuvius.jpg" 1
    verify_file "$HOME/.local/bin/waybar-audio" 1
    verify_file "$HOME/.local/bin/waybar-bluetooth" 1
    verify_file "$HOME/.local/bin/waybar-cpu" 1
    verify_file "$HOME/.local/bin/waybar-network" 1
    verify_file "$HOME/.local/bin/waybar-power" 1
    verify_file "$HOME/.local/bin/waybar-power-profile" 1

    # Chezmoi deployment sanity
    if have chezmoi && chezmoi status 2>/dev/null | grep -q '^[AMD]' 2>/dev/null; then
        verify_warn "chezmoi has unapplied changes (chezmoi status not clean)"
    elif [[ -f "$HOME/.config/hypr/hyprland.lua" ]]; then
        verify_ok "chezmoi apply looks complete"
    else
        verify_missing "chezmoi apply not complete"
    fi
}

verify_fonts() {
    step "Fonts"
    if ! have fc-list; then
        verify_fail "fontconfig (fc-list) not available"
        return 0
    fi
    if fc-list | grep -qi "JetBrainsMono Nerd"; then
        verify_ok "JetBrainsMono Nerd Font"
    else
        verify_missing "JetBrainsMono Nerd Font (foot/mako/waybar icons depend on it)"
    fi
    fc-list | grep -qi "Noto Sans"           && verify_ok "Noto Sans"        || verify_warn "Noto Sans missing"
    fc-list | grep -qi "Noto Color Emoji"    && verify_ok "Noto Color Emoji" || verify_warn "Noto Color Emoji missing"
    fc-list | grep -qi "Font Awesome"        && verify_ok "Font Awesome"        || verify_warn "Font Awesome missing (optional)"
}

verify_gpu() {
    step "GPU drivers"
    if ! have lspci; then
        verify_warn "lspci unavailable; cannot detect GPU"
        return 0
    fi
    source "$DOTFILES_ROOT/install/hardware/detect.sh" 2>/dev/null || true
    local -a gpus
    mapfile -t gpus < <(detect_gpus 2>/dev/null)
    if ((${#gpus[@]} == 0)); then
        verify_warn "No known GPU vendor detected"
        return 0
    fi
    # Check every detected card (hybrid laptops may carry two vendors).
    local vendor
    for vendor in "${gpus[@]}"; do
        verify_ok "Detected GPU vendor: $vendor"
        case $vendor in
            amd)
                verify_check_packages mesa vulkan-radeon libva-mesa-driver
                ;;
            intel)
                verify_check_packages mesa vulkan-intel intel-media-driver
                ;;
            nvidia)
                verify_check_packages nvidia-utils
                if pacman -Qqi nvidia >/dev/null 2>&1 || pacman -Qqi nvidia-open >/dev/null 2>&1 \
                   || pacman -Qqi nvidia-lts >/dev/null 2>&1 || pacman -Qqi nvidia-dkms >/dev/null 2>&1 \
                   || pacman -Qqi nvidia-open-dkms >/dev/null 2>&1
                then
                    verify_ok "NVIDIA kernel driver package installed"
                else
                    verify_warn "NVIDIA kernel driver package not detected"
                fi
                ;;
        esac
    done
}

verify_check_packages() {
    local p
    for p in "$@"; do
        if pkg_installed "$p"; then
            verify_ok "$p"
        else
            verify_warn "$p not installed"
        fi
    done
}

verify_services() {
    step "Services"
    verify_service NetworkManager system
    systemd_enabled bluetooth.service && verify_ok "bluetooth enabled" || verify_warn "bluetooth disabled"
    verify_service pipewire user
    verify_service pipewire-pulse user
    verify_service wireplumber user
    systemd_user_active pipewire && verify_ok "PipeWire audio active" || verify_warn "PipeWire not running"

    if [[ -d /usr/share/xdg-desktop-portal/portals/hyprland ]]; then
        verify_ok "XDG portal (hyprland) - screensharing should work"
    else
        verify_warn "XDG portal (hyprland) backend missing"
    fi
    [[ -f /usr/share/xdg-desktop-portal/portals/gtk.portal ]] \
        && verify_ok "XDG portal (gtk) - file chooser available" \
        || verify_warn "XDG portal (gtk) missing"

    verify_ok "UPower/UDisks2 are D-Bus activated (no service check needed)"
    if pkg_installed brightnessctl; then
        verify_ok "brightnessctl"
    else
        verify_warn "brightnessctl missing"
    fi
}

verify_hyprland_config() {
    step "Hyprland configuration"
    if [[ -f $HOME/.config/hypr/hyprland.lua ]]; then
        verify_ok "hyprland.lua found (Lua config requires a Hyprland version with Lua support)"
        verify_ok "Keybinds cover: terminal, launcher, close, workspaces, screenshots, clipboard, lock, volume, brightness, powermenu"
    else
        verify_missing "dot_config/hypr/hyprland.lua"
    fi
}

run_verify() {
    printf '\n=== dotfiles2 install verification ===\n\n'
    verify_commands
    verify_fonts
    verify_gpu
    verify_services
    verify_configs
    verify_hyprland_config
    printf '\n=== summary ===\n\n'
    if ((CRITICAL_FAILURES)); then
        printf '[FAIL] some critical components are missing - see MISSING/FAIL above.\n'
        return 1
    fi
    printf '[OK] installation looks complete. Reboot or log into "Hyprland (uwsm)".\n'
    return 0
}
