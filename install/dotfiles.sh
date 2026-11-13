#!/usr/bin/env bash
# install/dotfiles.sh - deploy dotfiles with chezmoi. Never copies dot_*
# files manually; all deployment goes through chezmoi.

require_chezmoi() {
    if ((DRY_RUN)); then
        log "[dry-run] chezmoi check"
        return 0
    fi
    have chezmoi || true
    if ! have chezmoi; then
        fatal "chezmoi is not installed. Did install.sh run install_package_group base first?"
    fi
    ok "chezmoi available: $(command -v chezmoi)"
}

chezmoi_source_dir() {
    printf '%s\n' "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
}

# Applies dotfiles from the CURRENT checkout (no network needed).
_chezmoi_apply_local() {
    ((DRY_RUN)) && { log "[dry-run] chezmoi apply --source $DOTFILES_ROOT"; return 0; }
    if [[ -t 0 ]] && ! ((SUPPRESS_PROMPTS)); then
        chezmoi apply --interactive --source "$DOTFILES_ROOT"
    else
        chezmoi apply --source "$DOTFILES_ROOT"
    fi
}

# Deploy from the local checkout only; does not need network or sudo.
deploy_dotfiles_local() {
    require_chezmoi
    step "Deploying dotfiles via chezmoi (local checkout)"
    if _chezmoi_apply_local; then
        ok "dotfiles deployed."
        return 0
    fi
    err "chezmoi apply failed - dotfiles were NOT fully deployed."
    return 1
}

# Full deploy (fresh install path): wire up ~/.local/share/chezmoi, then apply.
deploy_dotfiles() {
    require_chezmoi

    local source_dir
    source_dir="$(chezmoi_source_dir)"
    step "Deploying dotfiles via chezmoi"

    if [[ -d $source_dir/.git ]]; then
        local origin
        origin="$(git -C "$source_dir" remote get-url origin 2>/dev/null || printf '')"
        if [[ $origin == *maciej3j/dotfiles2* ]]; then
            ok "Existing chezmoi source matches this repository ($origin)."
            if ((DRY_RUN)); then
                log "[dry-run] chezmoi update"
            elif ! chezmoi update; then
                warn "chezmoi update failed; falling back to apply from the local checkout."
            fi
        else
            warn "Existing chezmoi source points to a different repository: ${origin:-<unknown>}"
            if confirm "Apply dotfiles from the current checkout ($DOTFILES_ROOT) instead?"; then
                : # proceed to local apply below
            else
                log "Keeping existing chezmoi source. Deploy skipped."
                return 0
            fi
        fi
    else
        # Fresh system: initialize chezmoi from the canonical repo URL.
        if ((DRY_RUN)); then
            log "[dry-run] chezmoi init --apply $REPO_URL_HTTPS"
        elif ! chezmoi init --apply "$REPO_URL_HTTPS"; then
            # Upstream clone may fail (offline, repo moved); fall back locally.
            warn "chezmoi init from network failed; applying local checkout instead."
        fi
    fi

    if _chezmoi_apply_local; then
        ok "dotfiles deployed."
        return 0
    fi
    err "chezmoi apply failed - dotfiles were NOT fully deployed."
    return 1
}
