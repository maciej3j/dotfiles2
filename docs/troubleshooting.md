# Rozwiązywanie problemów — dotfiles2

## Instalator

**Instalator zatrzymuje się na "No network connectivity"**
Sprawdź `ping 1.1.1.1`. Na Wi-Fi użyj `nmtui` lub:
`nmcli device wifi connect "SSID" password "PASS"`. Po podłączeniu uruchom `./install.sh` ponownie.

**`error: target not found: <pakiet>`**
Nazwa pakietu mogła zmienić się w repo. Sprawdź `pacman -Ss <nazwa>` oraz AUR, popraw wpis w `packages/*.txt` i uruchom ponownie.

**Budowa `yay` z AUR się nie udaje**
Upewnij się, że `base-devel` jest zainstalowany i że nie uruchamiasz instalatora jako root.
Ręcznie:

```bash
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

**Dwa agenty polkit jednocześnie**
W sesji działa tylko `hyprpolkitagent` (startuje z `hyprland.lua`). Jeśli masz np. `polkit-gnome` w autostartie, usuń go — jednoczesne agenty nie są obsługiwane.

## Hyprland / sesja

**Po instalacji nie ma graficznej sesji**
Zrestartuj system i wybierz w SDDM sesję **Hyprland (uwsm)**. Bez SDDM można wystartować ręcznie z TTY: `uwsm start hyprland` (plain `Hyprland` też zadziała, ale bez uWSM env).

**Konfiguracja Hyprland nie działa**
Konfiguracja jest w Lua (`~/.config/hypr/hyprland.lua`) — wymaga Hyprlanda z obsługą Lua. Sprawdź `pacman -Qi hyprland` (aktualna wersja z oficjalnego repo). Musi istnieć `~/.config/hypr/hyprland.lua`.

**Screensharing nie działa (OBS / Discord / Firefox)**
Wymagane działające `pipewire`, `pipewire-pulse`, `wireplumber` oraz portale. Sprawdź:

```bash
systemctl --user status pipewire pipewire-pulse wireplumber
ls /usr/share/xdg-desktop-portal/portals/
systemctl --user restart xdg-desktop-portal.service pipewire pipewire-pulse wireplumber
```

**NVIDIA: zamrażanie / czarny ekran w Wayland**
Sprawdź czy sterownik ma włączony modeset: `nvidia-drm.modeset=1` (instalator nie zmienia bootloadera; sterowniki ≥ 565 mają modeset domyślnie).

**Głośność / jasność / przełączanie playeractor nie działają**
Klawisze `XF86*` są zbindowane w `hyprland.lua` (wpctl/playerctl/brightnessctl). Wymagane: WirePlumber, playerctl, brightnessctl (z `packages/hyprland.txt`). Zadbaj też, że `sensors` (lm_sensors) jest zainstalowane gdy chcesz temperaturę CPU w Waybar.

## Waybar / zsh / nvim

**Ikony w Waybar to pytajniki / kwadraty**
Zainstalowane musi być `ttf-jetbrains-mono-nerd` (font z ikonami Nerd). Po instalacji: `fc-cache -f` i restart waybar. To samo dotyczy foot i mako.

**`zsh: command not found: eza / bat / zellij / yazi`**
Uruchom `./install.sh` ponownie — instalator jest idempotentny i doinstaluje brakujące pakiety.

**oh-my-zsh: brak pluginów zsh-autosuggestions / fast-syntax-highlighting**
Instalator klonuje je do `$ZSH_CUSTOM/plugins/` (sekcja "Installing oh-my-zsh"). Jeżeli katalogi istnieją ale są nie-gitowe — usuń je ręcznie i ponów `./install.sh`.

**Docker**
To pakiet opcjonalny: `./install.sh --with-optional`, a następnie (instalator nie robi tego automatycznie):

```bash
sudo systemctl enable --now docker.socket
sudo usermod -aG docker "$USER"   # wyloguj się, by grupa zadziałała
```

## Chezmoi

**`chezmoi diff` pokazuje zmiany, których nie chcę**
Edytuj źródło: `chezmoi edit <plik>` (otwiera plik źródłowy w `~/.local/share/chezmoi`), albo wyklucz go w `~/.chezmoiignore`. Potraktuj `chezmoi apply --interactive` per-plik.

**Chcę wrócić do stanu z repo**
```bash
chezmoi update
```

**Chcę trzymać własny forhover konfiguracji**
Uruchom `chezmoi apply --interactive --source /ścieżka/Twojego/clone` — instalator tak samo robi `--dots-only`.

## Debug

```bash
# cały log instalacji
~/.cache/dotfiles2-install.log

# symulacja
./install.sh --dry-run

# usługi
systemctl status NetworkManager bluetooth
systemctl --user status pipewire pipewire-pulse wireplumber

# logi sesji Hyprland
~/.cache/hyprland/

# weryfikacja
bash -c 'source install/lib/common.sh; source install/verify.sh; run_verify'
```
