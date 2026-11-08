#!/usr/bin/env bash
# install/lib/common.sh - shared helpers for the dotfiles2 installer.
# NOTE: this file is sourced by install.sh; it does not decide the strictness
#       of the shell (sans -e) - the orchestrator (install.sh) does that.

# ------------------------------------------------------------------ constants
REPO_URL_HTTPS="https://github.com/maciej3j/dotfiles2.git"

DOTFILES_ROOT=""
if [[ -z ${DOTFILES_ROOT:-} ]]; then
    if [[ -n ${BASH_SOURCE[0]:-} ]]; then
        DOTFILES_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
    fi
fi

DRY_RUN=0
INTERACTIVE=1
# shellcheck disable=SC2034  # may be overridden by caller
SUPPRESS_PROMPTS=0

LOG_FILE="${DOTFILES_LOG:-${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles2-install.log}"

# --------------------------------------------------------------- output/log
if [[ ! -d "$(dirname -- "$LOG_FILE")" ]]; then
    mkdir -p "$(dirname -- "$LOG_FILE")" 2>/dev/null || true
fi

_log_write() {
    printf '%s\n' "$*" >>"$LOG_FILE" 2>/dev/null || true
}

log() {
    printf '%s\n' "$*"
    _log_write "$*"
}

ok() {
    log "[OK] $*"
}

warn() {
    if [[ -t 1 ]]; then printf '\033[33m[WARN]\033[0m %s\n' "$*"; else log "[WARN] $*"; fi
    _log_write "[WARN] $*"
}

err() {
    if [[ -t 1 ]]; then printf '\033[31m[ERR]\033[0m %s\n' "$*" >&2; else log "[ERR] $*" >&2; fi
    _log_write "[ERR] $*"
}

fatal() {
    err "FATAL: $*"
    _log_write "FATAL: $* (aborted)"
    exit 1
}

step() {
    log ""
    log "==> $*"
}

# Log every executed command (helps with post-install troubleshooting).
run() {
    _log_write "exec: $*"
    "$@"
}

runsudo() {
    if ((DRY_RUN)); then
        log "[dry-run] sudo $*"
        return 0
    fi
    if ((EUID == 0)); then
        run "$@"
    else
        run sudo "$@"
    fi
}

# -------------------------------------------------------------- boolean hlp
have() { command -v "$1" >/dev/null 2>&1; }

pkg_installed() {
    pacman -Qqi -- "$1" >/dev/null 2>&1
}

pkg_available_in_repo() {
    pacman -Si -- "$1" >/dev/null 2>&1
}

systemd_active() {
    systemctl is-active --quiet -- "$1" >/dev/null 2>&1
}

systemd_user_active() {
    systemctl --user is-active --quiet -- "$1" >/dev/null 2>&1
}

systemd_enabled() {
    systemctl is-enabled --quiet -- "$1" >/dev/null 2>&1
}

systemd_user_enabled() {
    systemctl --user is-enabled --quiet -- "$1" >/dev/null 2>&1
}

enable_service() {
    #$1 = service name, $2 optional = "now"
    local svc="${1:-}" and_now="${2:-}"
    ((DRY_RUN)) && { log "[dry-run] enable systemd service: $svc $and_now"; return 0; }
    if ! systemd_enabled "$svc"; then
        runsudo systemctl enable "$svc" $and_now
    fi
}

enable_user_service() {
    local svc="${1:-}" and_now="${2:-}"
    ((DRY_RUN)) && { log "[dry-run] enable user service: $svc $and_now"; return 0; }
    if ! systemd_user_enabled "$svc"; then
        systemctl --user enable "$svc" $and_now
    fi
}

# ----------------------------------------------------------- confirm dialog
confirm() {
    #$1 = prompt text, return 0 if user agrees
    if ((DRY_RUN)) || ((SUPPRESS_PROMPTS)); then
        log "[assume yes] $1"
        return 0
    fi
    if [[ ! -t 0 ]]; then
        warn "No TTY available, assuming 'no' for: $1"
        return 1
    fi
    local reply=""
    printf '%s [y/N] ' "$1"
    read -r reply
    [[ $reply == [Yy]* ]]
}

# ------------------------------------------------------------ system checks
require_arch() {
    if [[ ! -f /etc/arch-release && "$(grep -s '^ID=' /etc/os-release | head -1)" != 'ID=arch' ]]; then
        fatal "This installer supports Arch Linux only (/etc/arch-release not found)."
    fi
    ok "Detected Arch Linux."
}

require_not_root() {
    if ((EUID == 0)); then
        fatal "Do NOT run the installer as root. Run it as your regular user; sudo is used only where needed."
    fi
    ok "Running as unprivileged user: $(id -un)"
}

require_pacman() {
    have pacman || fatal "pacman not found. Is this an Arch Linux system?"
    ok "pacman found."
}

require_network() {
    step "Checking network connectivity"
    if have curl && curl -4fsSI --max-time 10 https://www.archlinux.org/ >/dev/null 2>&1; then
        ok "Network reachable."
        return 0
    fi
    if ping -c1 -W3 1.1.1.1 >/dev/null 2>&1; then
        ok "Network reachable (ping)." # curl may miss but general connectivity works
        return 0
    fi
    fatal "No network connectivity. Please connect and re-run ./install.sh"
}

# ------------------------------------------------------------ package lists
# Read newline separated package list; strips comments ("# ...") and blank lines.
read_package_list() {
    #$1 = file path; stdout = package names
    local file="${1:-}"
    [[ -f $file ]] || fatal "Missing package list: $file"
    sed -e 's/#.*$//' -e 's/[[:space:]]*$//' -e '/^[[:space:]]*$/d' -- "$file"
}

# ---------------------------------------------------------- system update
upgrade_system() {
    step "Updating system (pacman -Syu)"
    if ((DRY_RUN)); then
        log "[dry-run] sudo pacman -Syu --needed --noconfirm"
        return 0
    fi
    pacman -Sy >/dev/null
    if ! runsudo pacman -Syu --needed --noconfirm; then
        warn "System update failed. Continue anyway."
    fi
}

install_official() {
    #$@ = package names; returns non-zero when a package cannot be resolved.
    if ((DRY_RUN)); then
        log "[dry-run] sudo pacman -S --needed --noconfirm $*"
        return 0
    fi
    runsudo pacman -S --needed --noconfirm "$@"
}
