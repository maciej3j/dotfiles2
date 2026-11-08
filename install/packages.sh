#!/usr/bin/env bash
# install/packages.sh - install all packages from packages/*.txt plus
# user-level shell tooling (oh-my-zsh, zsh plugins, rustup toolchain).

install_package_group() {
    #$1 = name, $2 = txt file
    step "Installing packages: $1 (${2})"
    local -a pkgs missing=() p
    mapfile -t pkgs < <(read_package_list "$2")
    ((${#pkgs[@]})) || { warn "No packages defined in $2"; return 0; }

    for p in "${pkgs[@]}"; do
        pkg_available_in_repo "$p" || { warn "$1: package not found in official repos: $p (skipping)"; continue; }
        pkg_installed "$p" || missing+=("$p")
    done

    if ((${#missing[@]} == 0)); then
        ok "$1: all packages already installed."
        return 0
    fi
    install_official "${missing[@]}" || fatal "Failed to install package group '$1' (packages: ${missing[*]})."
    ok "$1 installed: ${missing[*]}"
}

refresh_font_cache() {
    step "Refreshing font cache"
    if ((DRY_RUN)); then
        log "[dry-run] fc-cache -f"
        return 0
    fi
    if have fc-cache; then
        >/dev/null 2>&1 fc-cache -f || warn "fc-cache returned non-zero."
        ok "Font cache rebuilt."
    else
        warn "fc-cache not available (fontconfig missing)."
    fi
}

configure_chsh() {
    step "Ensuring zsh is the login shell"
    local current_shell zsh
    zsh="$(command -v zsh || true)"
    [[ -n $zsh ]] || { warn "zsh binary not found, skipping chsh."; return 0; }
    current_shell="$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7)"
    if [[ $current_shell != "$zsh" ]]; then
        log "Changing login shell to $zsh (will prompt for password)."
        if ((DRY_RUN)); then
            log "[dry-run] chsh -s $zsh"
        else
            chsh -s "$zsh" || warn "chsh failed; default shell unchanged."
        fi
    else
        ok "Login shell already zsh."
    fi
}

install_oh_my_zsh() {
    step "Installing oh-my-zsh and zsh plugins"
    local zsh_home="${ZSH:-$HOME/.oh-my-zsh}"
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local -A plugin_repos=(
        [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
        [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
        [zsh-autocomplete]="https://github.com/marlonrichert/zsh-autocomplete.git"
    )
    local -A dirs=(
        [ohmyzsh]="$zsh_home"
        [zsh-autosuggestions]="$zsh_custom/plugins/zsh-autosuggestions"
        [fast-syntax-highlighting]="$zsh_custom/plugins/fast-syntax-highlighting"
        [zsh-autocomplete]="$zsh_custom/plugins/zsh-autocomplete"
    )
    local name d
    for name in ohmyzsh zsh-autosuggestions fast-syntax-highlighting zsh-autocomplete; do
        d="${dirs[$name]}"
        if [[ -d $d/.git ]]; then
            ok "$name already present."
            continue
        fi
        if [[ -e $d ]]; then
            warn "$name: $d exists but is not a git checkout - leaving it untouched."
            continue
        fi
        ((DRY_RUN)) && { log "[dry-run] git clone ${plugin_repos[$name]} -> $d"; continue; }
        git clone --depth=1 "${plugin_repos[$name]}" -- "$d" \
            || warn "Failed to clone $name (continuing)."
    done
}

configure_rustup() {
    step "Configuring rustup toolchain (stable)"
    have rustup || { warn "rustup not found, skipping."; return 0; }
    if ((DRY_RUN)); then
        log "[dry-run] rustup default stable + components"
        return 0
    fi
    rustup default stable || warn "rustup default failed."
    rustup component add rust-analyzer rustfmt clippy || warn "rustup components failed."
    ok "rustup configured."
}

setup_github_cli() {
    step "GitHub CLI (gh)"
    have gh || { warn "gh not found, skipping."; return 0; }
    if gh auth status >/dev/null 2>&1; then
        ok "gh already authenticated."
    elif ((INTERACTIVE)) && [[ -t 0 ]] && ! ((SUPPRESS_PROMPTS)); then
        if confirm "Run 'gh auth login' now? (needed for git@ SSH checks and pull requests)"; then
            gh auth login || warn "gh auth login failed; you can rerun it later."
        fi
    else
        warn "gh is not authenticated. Run: gh auth login"
    fi
}

install_all_packages() {
    local packages_dir="$DOTFILES_ROOT/packages"
    install_package_group "base"       "$packages_dir/base.txt"
    install_package_group "hyprland"   "$packages_dir/hyprland.txt"
    install_package_group "desktop"    "$packages_dir/desktop.txt"
    install_package_group "development" "$packages_dir/development.txt"
    install_package_group "terminal"   "$packages_dir/terminal.txt"
    install_package_group "fonts"      "$packages_dir/fonts.txt"

    if ((WITH_OPTIONAL)); then
        step "Installing optional packages (with-optional)"
        install_package_group "optional" "$packages_dir/optional.txt"
    else
        log "Skipping optional packages (packages/optional.txt). Use --with-optional to include them."
    fi

    configure_chsh
    install_oh_my_zsh
    configure_rustup
    setup_github_cli
    refresh_font_cache
}
