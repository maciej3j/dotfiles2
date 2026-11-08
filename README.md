# dotfiles2

Kompletny setup **Arch Linux + Hyprland** zarządzany przez Chezmoi. Wystarczy jedna komenda:

```bash
git clone https://github.com/maciej3j/dotfiles2.git
cd dotfiles2
./install.sh
```

## Co dostajesz

- **Hyprland** (konfiguracja w Lua: `dot_config/hypr/hyprland.lua`), hyprlock, hypridle, hyprpaper
- **Waybar** z modułami: workspaces, okno aktywne, CPU/temperatura, RAM, sieć, bluetooth, bateria, profil zasilania, zegar, tray
- **foot** jako terminal, **fuzzel** jako launcher/dmenu, **mako** jako powiadomienia
- **uWSM** do startu sesji + środowisko Wayland (`dot_config/uwsm/env`)
- Chezmoi wdraża wszystkie dotfiles (nic nie jest kopiowane ręcznie)
- Modularny instalator `install/`: pakiety, AUR, sterowniki GPU (AMD/Intel/NVIDIA), usługi, SDDM, laptopy, weryfikacja

## Wymagania

- Świeża instalacja **Arch Linux** (zalecana przez `archinstall`)
- Konto użytkownika z dostępem do `sudo`
- Połączenie z internetem

## Zalecane ustawienia archinstall

- Profil: **bez desktop environment** — instalator sam wdraża Hyprland
- Sieć: **NetworkManager** (używany przez konfigurację i narzędzia TUI)
- Wszystko inne (dysk, partycje, bootloader, kernel) dowolnie — instalator tego nie dotyka
- Konto użytkownika z uprawnieniami sudo

## Pierwsze kroki po instalacji systemu

```bash
sudo pacman -S git    # jeśli archinstall nie zainstalował
git clone https://github.com/maciej3j/dotfiles2.git
cd dotfiles2
./install.sh
```

## Opcje instalacji

| Opcja | Opis |
|---|---|
| `--gpu=amd\|intel\|nvidia\|all` | wymuś zestaw sterowników GPU (domyślnie automat z `lspci`) |
| `--skip-gpu` | pomiń instalację sterowników GPU |
| `--with-optional` | doinstaluj też `packages/optional.txt` (Docker itd.) |
| `--sddm` / `--no-sddm` | wymuś instalację / pominięcie menedżera wyświetlania SDDM |
| `--skip-upgrade` | pomiń wstępne `pacman -Syu` |
| `--dots-only` | tylko wdrożenie dotfiles (bez pakietów i usług) |
| `--yes` | przyjmij "tak" we wszystkich pytaniach |
| `--dry-run` | pokaż planowane operacje bez ich wykonywania |
| `--log FILE` | zapisz log do wskazanego pliku |

Pełny log trafia też do `~/.cache/dotfiles2-install.log`.

## Uruchomienie

Po instalacji zaloguj się ponownie lub zrestartuj system i wybierz w SDDM sesję **Hyprland (uwsm)**.

## Aktualizacja konfiguracji

```bash
chezmoi update      # pobiera zmiany z repo i stosuje je
chezmoi diff        # podpisuje co miałoby się zmienić
```

Aby stosować zmiany z lokalnego clone (np. własne testy):

```bash
cd ~/dotfiles2
chezmoi apply --interactive --source .
```

## Obsługa GPU

- **AMD**: Mesa, Vulkan Radeon, VA-API, VDPAU
- **Intel**: Mesa, Vulkan Intel, intel-media-driver (+ libva-intel-driver dla starszych iGPU)
- **NVIDIA**: dobór sterownika pod kernel (nvidia / nvidia-lts / nvidia-dkms / nvidia-open) + nvidia-utils; pytanie o moduły open vs proprietary
- **Hybrydowe GPU**: pytanie, czy sterować oboma vendorami
- Instalator nie modyfikuje bootloadera ani parametrów kernela automatycznie

Więcej: `docs/installation.md` i `docs/troubleshooting.md`.
