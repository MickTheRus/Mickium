# Mickium

Mickium is a personal, standalone NixOS flake for Mick's machines. It manages
the base operating system, desktop environment, Home Manager setup, shell tools,
application config, theming, networking, containers, media tools, and hardware
specific host definitions.

The repo is meant to be useful both as a live machine config and as a readable
example for anyone who finds it later. Everything required by the flake should
live in this repository rather than in an external dotfiles checkout.

## What This Repo Builds

The flake exposes two NixOS hosts:

- `maxwell`: desktop system, formerly named `Chasm`.
- `altar`: laptop system, formerly named `Void`.

Switch a machine with:

```sh
sudo nixos-rebuild switch --flake /home/mick/Documents/Mickium#maxwell
sudo nixos-rebuild switch --flake /home/mick/Documents/Mickium#altar
```

When cloning somewhere else, replace `/home/mick/Documents/Mickium` with the
path to the checkout.

## Top-Level Map

```text
flake.nix       Flake inputs, dev shell, formatter, and host entrypoint.
flake.lock      Pinned input revisions for reproducible rebuilds.
hosts/          Per-machine NixOS systems and hardware configuration.
modules/        Shared system-level NixOS modules.
home/           Home Manager configuration for user mick.
docs/           Maintenance notes and cleanup rationale.
```

## Hosts

`hosts/default.nix` wires the host names to the shared modules and Home Manager.
Each host directory contains the hardware config generated for that specific
machine.

```text
hosts/Maxwell/  Desktop hardware config.
hosts/Altar/    Laptop hardware config.
```

The public flake names are lowercase:

```text
nixosConfigurations.maxwell
nixosConfigurations.altar
```

## System Modules

Shared NixOS behavior lives in `modules/`.

```text
modules/core.nix        User account, shell, locale, console, base packages.
modules/bootloader.nix  Bootloader, Linux Zen kernel, DKMS, xpadneo.
modules/desktop.nix     PipeWire, Ly, Steam, KDE Connect, Tailscale service.
modules/containers.nix  Podman, Docker-compatible aliases and socket.
modules/network.nix     NetworkManager, DNS, firewall, Avahi, SSH.
modules/nix.nix         Nix settings, flakes, substituters, allowed packages.
modules/security.nix    doas, PAM U2F, Yubico/security-key login behavior.
modules/bluetooth.nix   Bluetooth stack and related service setup.
```

Important system choices:

- Kernel: Linux Zen through `pkgs.linuxPackages_zen`.
- Controller support: `xpadneo` is built against the Zen kernel package set.
- Login shell: fish for user `mick`.
- Display manager: Ly.
- Audio: PipeWire with ALSA, PulseAudio compatibility, and JACK.
- Networking: Tailscale starts automatically and accepts routes and DNS.
- Containers: Podman is the container engine, with Docker-compatible aliases.
- Security keys: PAM U2F is enabled through `~/.config/Yubico/u2f_keys`.

## Home Manager

User-level config lives in `home/`.

```text
home/default.nix      Main Home Manager entrypoint.
home/programs/        Desktop apps, media tools, browsers, theming, launchers.
home/shell/           Fish, zsh, git, CLI packages, terminal, prompt, editor.
home/wayland/         Hyprland, Waybar, Hyprlock, Hypridle, scripts.
```

## Desktop Stack

This is a Hyprland desktop with Waybar, Rofi, Kitty, Catppuccin-style theming,
Iosevka Nerd Font, Candy icons, GTK/Qt setup, and Wayland-first application
defaults.

```text
home/wayland/hyprland.nix       Home Manager wrapper for Hyprland.
home/wayland/hypr-config/       Native Hyprland, Hyprlock, Hypridle config.
home/wayland/waybar.nix         Home Manager wrapper for Waybar.
home/wayland/waybar/            Native Waybar JSONC/CSS config.
home/programs/rofi.nix          Home Manager wrapper for Rofi.
home/programs/rofi-config/      Native Rofi Rasi config and menu scripts.
home/programs/qt.nix            Qt environment and qt5ct/qt6ct install config.
home/programs/qt-config/        Native Qt theme config.
home/programs/gtk.nix           GTK theme, icon, cursor, and font config.
home/shell/terminal.nix         Kitty and Foot terminal config.
```

Some desktop tools stay in native config languages because they are clearer
that way. They are still managed by Nix through `xdg.configFile`.

## Applications

The config installs a workstation-style mix of daily desktop tools, creative
apps, media tools, game tools, and device utilities.

Notable packages and services include:

- Browsers/apps: Brave, Equibop for Discord, OpenAI Codex CLI package.
- Creative tools: Inkscape, Krita, Blender.
- Files and launchers: Thunar, Yazi, Rofi, Kitty.
- Gaming/tools: Steam, Bolt Launcher.
- Audio/tools: PipeWire, qpwgraph, pavucontrol, bluetuith.
- Networking/devices: Tailscale, KDE Connect, Ventoy, Yubico Authenticator.
- Mesh tools: Meshtastic CLI and MeshCore CLI.
- Containers: Podman and podman-compose.

## Shell And CLI

Fish is the primary shell and login shell. Zsh is still configured for
compatibility and shared shell behavior.

```text
home/shell/fish.nix      Fish shell, aliases, and plugins.
home/shell/zsh.nix       Zsh compatibility config.
home/shell/git.nix       Git config and ignored per-device state.
home/shell/cli.nix       General CLI packages.
home/shell/nix.nix       Nix tooling: alejandra, deadnix, statix, direnv.
home/shell/starship.nix  Prompt config.
```

Per-device state such as shell history, cache folders, build outputs, and
secrets should stay out of Git.

## Media And Music

MPD is managed through Home Manager and reads music from:

```text
/home/mick/Music
```

The intended TUI MPD client is `rmpc`. `ncmpcpp` has intentionally been removed.

Media config also includes mpv, imv, yt-dlp, playerctl/playerctld, qpwgraph,
pavucontrol, pulsemixer, and pamixer.

## Development And Maintenance

The development shell includes:

```text
alejandra  Nix formatter.
deadnix    Unused Nix declaration checker.
statix     Nix linter.
nil        Nix language server.
git        Version control.
```

Format the repo with:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' develop -c alejandra .
```

Check it with:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' develop -c deadnix .
sudo nix --extra-experimental-features 'nix-command flakes' develop -c statix check .
sudo nix --extra-experimental-features 'nix-command flakes' flake check --show-trace
```

More notes live in `docs/MAINTENANCE.md`.

## Fresh Install Notes

1. Clone this repo.
2. Confirm the target host hardware config is correct.
3. Run `nixos-rebuild switch --flake <repo>#maxwell` or `#altar`.
4. Complete the Tailscale sign-in URL from:

```sh
journalctl -u tailscaled-login -b
```

5. Pair security keys and write `~/.config/Yubico/u2f_keys` before relying on
   full security-key login.

## Repo Rules

- Keep required config inside this repo.
- Commit `flake.lock`.
- Keep secrets, local shell history, caches, and build outputs out of Git.
- Prefer Home Manager/Nix modules when they are clean and readable.
- Keep native config files when translating them to Nix would make them worse.
