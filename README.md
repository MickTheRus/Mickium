# Mickium

Mickium is Mick's standalone NixOS flake. The repository is intended to be
cloned on a fresh machine and used directly; every config file required by the
flake lives in this repository.

## Hosts

The flake currently exposes two NixOS systems:

- `maxwell`: desktop system, renamed from `Chasm`.
- `altar`: laptop system, renamed from `Void`.

Build or switch a host with:

```sh
sudo nixos-rebuild switch --flake /home/mick/Documents/Mickium#maxwell
sudo nixos-rebuild switch --flake /home/mick/Documents/Mickium#altar
```

For a first clone, replace `/home/mick/Documents/Mickium` with the checkout
path.

## Repository Rules

- Required config must live in this repo.
- Do not point Home Manager at any external dotfiles checkout.
- Prefer Nix modules for application settings when Home Manager has a good
  option surface.
- Keep native app config files in the repo when that format is clearer than
  translating the whole thing to Nix, such as Waybar JSONC, Rofi Rasi, and
  Hyprland Hyprlang.
- Do not commit machine-local state such as shell history, build results, cache
  folders, or secrets.

## Layout

```text
flake.nix              Flake inputs, formatter, dev shell, host entrypoint.
flake.lock             Locked input revisions. Commit this for reproducibility.
hosts/                 Per-machine NixOS entrypoints and hardware config.
modules/               Shared system-level NixOS modules.
home/                  Home Manager configuration for user mick.
home/programs/         User applications and desktop program config.
home/shell/            Shells, CLI tools, terminal config, git, direnv, editor tools.
home/wayland/          Hyprland, Waybar, and Wayland-session config.
docs/                  Longer maintenance notes for future edits.
```

## Important System Behavior

- Kernel: Linux Zen through `pkgs.linuxPackages_zen`.
- Controller driver: `xpadneo` is declared as a Zen kernel module.
- Shell: fish is the login shell for user `mick`; zsh remains configured for
  compatibility.
- Display manager: Ly is enabled.
- Audio: PipeWire is enabled for ALSA, PulseAudio compatibility, and JACK.
- Networking: Tailscale starts at boot. On a fresh install it runs
  `tailscale up --accept-dns --accept-routes --operator=mick` and waits for
  normal browser sign-in.
- Containers: Podman is enabled with Docker-compatible socket and aliases.
- Security keys: PAM U2F is enabled with the key file at
  `~/.config/Yubico/u2f_keys`.

## Desktop Config

The desktop is Hyprland-based.

- Hyprland native config lives in `home/wayland/hypr-config`.
- Home Manager writes `~/.config/hypr/hyprland.conf`, which sources
  `~/.config/hypr/main.conf`.
- `main.conf` is generated from `home/wayland/hypr-config/hyprland.conf`.
- Waybar native config lives in `home/wayland/waybar`.
- Rofi native config lives in `home/programs/rofi-config`.
- Qt native config lives in `home/programs/qt-config`.
- Kitty is fully declared through `programs.kitty.settings` in
  `home/shell/terminal.nix`.

## Music

MPD is enabled through Home Manager and reads music from:

```text
/home/mick/Music
```

The intended TUI MPD client is `rmpc`. `ncmpcpp` has intentionally been removed.

## Verification

Run this before committing or pushing:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' flake check --show-trace
```

Format Nix files with:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' develop -c alejandra .
```

## Fresh Install Notes

1. Clone this repo.
2. Copy or generate the correct host hardware config if the hardware changed.
3. Run `nixos-rebuild switch --flake <repo>#maxwell` or `#altar`.
4. Complete Tailscale sign-in from the URL printed by:

```sh
journalctl -u tailscaled-login -b
```

5. Pair security keys and write `~/.config/Yubico/u2f_keys` before relying on
   U2F login.
