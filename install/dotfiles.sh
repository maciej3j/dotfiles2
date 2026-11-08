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
            else
                chezmoi update || warn "chezmoi update failed; falling back to apply."
            fi
        else
            warn "Existing chezmoi source points to a different repository: ${origin:-<unknown>}"
            if confirm "Apply dotfiles from the current checkout ($DOTFILES_ROOT) instead?"; then
                _apply_local_source
            else
                log "Keeping existing chezmoi source. Deploy skipped."
                return 0
            fi
        fi
    else
        # Fresh system: initialize chezmoi from the canonical repo URL.
        if ((DRY_RUN)); then
            log "[dry-run] chezmoi init --apply $REPO_URL_HTTPS"
            return 0
        fi
        if ! chezmoi init --apply "$REPO_URL_HTTPS"; then
            # Upstream clone may fail (no network to github or repo private);
            # fall back to this checkout.
            warn "chezmoi init from network failed; applying local checkout instead."
            _apply_local_source
        fi
    fi

    # --interactive only prompts when something would actually change, so a
    # fresh system results in zero prompts and an existing system is asked
    # file-by-file instead of being overwritten blindly.
    if ((DRY_RUN)); then
        log "[dry-run] chezmoi apply (interactive on conflict only)"
        return 0
    fi
    if [[ -t 0 ]] && ! ((SUPPRESS_PROMPTS)); then
        chezmoi apply --interactive --source "$DOTFILES_ROOT" || true
    else
        chezmoi apply --source "$DOTFILES_ROOT" || warn "chezmoi apply reported an error."
    fi
    ok "dotfiles deployed."
}

_apply_local_source() {
    have chezmoi || return 1
    if ((DRY_RUN)); then
        log "[dry-run] chezmoi apply --source $DOTFILES_ROOT"
        return 0
    fi
    if [[ -t 0 ]] && ! ((SUPPRESS_PROMPTS)); then
        chezmoi apply --interactive --source "$DOTFILES_ROOT" || warn "chezmoi apply (local source) reported errors."
    else
        chezmoi apply --source "$DOTFILES_ROOT" || warn "chezmoi apply (local source) reported errors."
    fi
}
