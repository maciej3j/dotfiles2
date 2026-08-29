# Arch Linux + Hyprland dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source state for a
complete Arch Linux desktop and development environment. It installs Hyprland,
Waybar, locking/idle/wallpaper tools, audio, networking, Bluetooth, Docker,
and the listed developer tools. Existing Neovim and tmux configurations are
managed at `~/.config/nvim` and `~/.tmux.conf` respectively.

## Fresh installation

1. Install Arch Linux with a regular user in the `wheel` group and enable
   sudo for that group. Install a network connection first.
2. Clone this repository and enter it:

   ```bash
   git clone https://github.com/maciej3j/dotfiles2.git
   cd dotfiles2
   ```

3. Run the bootstrap command:

   ```bash
   ./1_install_first.sh
   ```

The script installs chezmoi and bootstrap dependencies, then runs
`chezmoi init --apply maciej3j/dotfiles2`. Chezmoi installs the desktop and
development packages, applies all user configuration, installs yay, Oh My Zsh
and TPM, and enables NetworkManager, Bluetooth, Docker, PipeWire and greetd.
The greetd login screen starts Hyprland through UWSM after the next reboot.

Reboot after the installation so the new default Zsh shell, Docker group
membership and greetd login screen take effect. Log in through greetd to start
Hyprland.

## Updating

Run the same command at any time to pull and apply the source state:

```bash
chezmoi update
```

The bootstrap command is safe to run repeatedly. Pacman uses `--needed`, yay
and TPM are cloned only when missing, and systemd services can be enabled
repeatedly.
