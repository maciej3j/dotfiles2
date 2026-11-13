# Instalacja dotfiles2 — szczegóły

## Spis

1. [Wymagania](#wymagania)
2. [archinstall](#archinstall)
3. [Praca z install.sh](#praca-z-installsh)
4. [Moduły instalatora](#moduły-instalatora)
5. [Instalowane pakiety](#instalowane-pakiety)
6. [Pakiety AUR](#pakiety-aur)
7. [Sterowniki GPU](#sterowniki-gpu)
8. [Usługi systemowe](#usługi-systemowe)
9. [Chezmoi — wdrożenie dotfiles](#chezmoi--wdrożenie-dotfiles)
10. [Laptopy](#laptopy)
11. [Weryfikacja](#weryfikacja)

## Wymagania

- Arch Linux (instalator sprawdza `/etc/arch-release`).
- Konto użytkownika z sudo (instalator odmawia uruchomienia jako root).
- Połączenie z internetem.
- `pacman` w systemie.
- `git` (Chezmoi sama korzysta z git przy klonowaniu źródła).

## archinstall

Zalecane ustawienia, aby uniknąć kolizji z instalatorem:

- **Profile**: wybierz `minimal` — bez preinstalacji desktop environment.
- **Network**: NetworkManager.
- Karta graficzna: sterowniki dokańcza `install.sh` na podstawie detekcji `lspci`.
- Dysk / partycje / bootloader: dowolnie — instalator ich nie modyfikuje.

## Praca z install.sh

```bash
./install.sh [--gpu=...] [--sddm|--no-sddm] [--skip-upgrade] [--dots-only]
             [--with-optional] [--yes] [--dry-run] [--log FILE]
```

Kolejność działań:

1. Sprawdzenie: Arch? Nie-root? pacman obecny? internet działa?
2. Aktualizacja systemu (`pacman -Syu`) — pomijalna przez `--skip-upgrade`.
3. Instalacja pakietów z `packages/*.txt`.
4. Instalacja pakietów AUR (yay) z `packages/aur.txt`.
5. Wykrycie GPU i instalacja sterowników.
6. Usługi (NetworkManager, bluetooth, PipeWire, portale, SDDM...).
7. Konfiguracja laptopa (jeśli wykryto baterię).
8. Wdrożenie dotfiles przez Chezmoi.
9. Weryfikacja instalacji (logika z `install/verify.sh`).

Instalator jest **idempotentny** — ponowne uruchomienie nie niszczy konfiguracji.

## Moduły instalatora

```text
install/
├── lib/common.sh                   # log, sudo wrapper, pomocnicze sprawdziany
├── packages.sh                     # pacman z packages/*.txt + oh-my-zsh, chsh, rustup
├── aur.sh                          # bootstrap yay + packages/aur.txt
├── dotfiles.sh                     # chezmoi init/apply/update
├── services.sh                     # usługi systemowe/user + SDDM + portale + polkit
├── laptop.sh                       # moduł laptopa (PPD/TLP, brightnessctl, upower)
├── verify.sh                       # raport końcowy
└── hardware/{detect,amd,intel,nvidia}.sh
```

## Instalowane pakiety

Pełne listy: `packages/base.txt`, `hyprland.txt`, `desktop.txt`, `development.txt`, `terminal.txt`, `fonts.txt`. Każda nazwa pochodzi z audytu konfiguracji — dotyczy aplikacji, komend i fontów używanych przez Hyprland, Waybar, zsh i nvim.

## Pakiety AUR

`packages/aur.txt`:

- `wlctl-bin` — TUI używane przez moduł sieci waybar
- `catppuccin-gtk-theme-mocha` — motyw GTK dla `settings.ini`

Pakiety dostępne w oficjalnych repozytoriach są **pomijane** (nie instaluje się ich z AUR). Pakiety opcjonalne (`packages/optional.txt`, m.in. Docker) instalują się wyłącznie z `--with-optional`.

## Sterowniki GPU

- Wykrywanie: `lspci` (`install/hardware/detect.sh`), kategorie VGA/3D/Display.
- AMD: `mesa`, `vulkan-radeon`, `libva-mesa-driver`, `mesa-vdpau`, `vulkan-mesa-layers`.
- Intel: `mesa`, `vulkan-intel`, `intel-media-driver`, `libva-intel-driver` (starsze iGPU).
- NVIDIA: dobór pakietu pod aktualny kernel (`nvidia`, `nvidia-lts`, `nvidia-dkms`, `nvidia-open`) — wariant wykrywany przez analizę PCI device id (moduły open wspierają oficjalnie Turing 0x1Exx i nowsze; starsze karty zawsze dostają moduły proprietary), z fallbackiem na DKMS, gdy pakiet nie jest dostępny; przy DKMS instalowane są pasujące nagłówki kernela (np. `linux-lts-headers`); zawsze `nvidia-utils`.
- Hybrydowe GPU: instalator pyta, czy zainstalować sterowniki dla obu vendorów.
- Bootloader / `mkinitcpio` / parametry kernela **nie są** modyfikowane automatycznie.

## Usługi systemowe

- NetworkManager — `systemctl enable --now` (systemowy).
- bluetooth — `systemctl enable --now` (systemowy).
- pkgfile — timer `pkgfile-update.timer` (obsługa wtyczki `command-not-found`).
- SDDM — opcjonalnie (pytanie), motyw sddm-astronaut-theme.
- PipeWire / pipewire-pulse / WirePlumber — usługi **user** (`systemctl --user`), bez sudo.
- UPower / UDisks2 / portale — D-Bus activated, nie wymagają `systemctl enable`.

Kolizja agentów polkit: w sesji działa wyłącznie `hyprpolkitagent` uruchamiany z `dot_config/hypr/hyprland.lua`. Instalator zwarca uwagę, gdy wykryje drugiego agenta (np. polkit-gnome).

## Chezmoi — wdrożenie dotfiles

`install/dotfiles.sh`:

1. Sprawdza obecność chezmoi.
2. Jeśli `~/.local/share/chezmoi` istnieje i wskazuje repo maciej3j/dotfiles2 → `chezmoi update`.
3. Jeśli wskazuje inne repo → pytanie, czy zaaplikować z bieżącego clone'a.
4. W przeciwnym wypadku `chezmoi init --apply` z URL repo (network), z fallbackiem na lokalny checkout.
5. `chezmoi apply --interactive --source <repo>` — pytania tylko przy realnych różnicach, świeży system przechodzi bez zapytań (nadpisuje jedynie pliki już wdrożone).
6. Zwraca raport zmian.

Przykład ręcznej kontroli:

```bash
chezmoi diff                            # co zmieniłoby się
chezmoi status                          # stany wdrozienia
chezmoi managed                         # lista zarządzanych plików
```

## Laptopy

Moduł uruchamia się tylko gdy wykryta zostanie bateria (`/sys/class/power_supply/BAT*`):

- `brightnessctl` + `upower`,
- profil zasilania: **power-profiles-daemon** (używa `powerprofilesctl` w waybar) **albo** TLP (jeśli już zainstalowany i aktywny) — nigdy oba równocześnie,
- klucze głośność/jasność/play/metadane już istnieją w `hyprland.lua` (XF86*).

## Weryfikacja

Automatycznie na końcu `install.sh`; ręcznie:

```bash
bash -c 'source install/lib/common.sh; source install/verify.sh; run_verify'
```

Raport z kategoriami `[OK] / [MISSING] / [WARNING] / [FAIL]`: komendy, konfiguracje, fonty, sterowniki GPU, usługi, portale, polkit agent, konfiguracja Hyprland. Exit code 1 przy brakach krytycznych.
