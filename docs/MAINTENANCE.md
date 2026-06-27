# Maintenance Notes

This document explains the intent behind the repo shape so future cleanup does
not accidentally reintroduce external dotfile dependencies.

## Standalone Requirement

The flake must evaluate and build from its own checkout. A quick smoke test is:

```sh
rg 'mkOutOfStoreSymlink|external dotfiles checkout' home modules hosts flake.nix
```

That search should return no required config references. Runtime paths under
`~/.config`, `~/.cache`, `/home`, and `/dev/disk/by-uuid` are allowed when they
describe paths on the target system rather than files from another repo.

## Native Config Directories

Some applications are easier to maintain in their native config languages:

- `home/wayland/hypr-config`: Hyprland, Hyprlock, Hypridle, Pyprland, scripts.
- `home/wayland/waybar`: Waybar JSONC and CSS.
- `home/programs/rofi-config`: Rofi Rasi files and launcher scripts.
- `home/programs/qt-config`: qt5ct, qt6ct, and Electron Wayland flags.

These directories are still Nix-managed because Home Manager installs them with
`xdg.configFile`. They are not external state.

## Nixified Config

Use Home Manager modules directly where they are compact and clear:

- Kitty: `home/shell/terminal.nix`.
- MPD, mpv, imv, yt-dlp: `home/programs/media.nix`.
- GTK theming: `home/programs/gtk.nix`.
- Fish plugins and aliases: `home/shell/fish.nix`.
- Git, direnv, CLI tools: `home/shell`.

Avoid translating layout-heavy JSONC/Rasi/Hyprlang files into enormous Nix
attrsets unless there is a practical benefit.

## Removed Debris

The following old paths were intentionally removed:

- `home/programs/the-rofi`: replaced by `home/programs/rofi-config`.
- `home/wayland/hypr`: replaced by `home/wayland/hypr-config`.
- `home/wayland/waybar/config` and `home/wayland/waybar/scripts`: old Waybar
  config path and scripts not used by the current `config.jsonc`.
- `home/wayland/swaybg.nix` and `home/wayland/swayidle.nix`: not imported.
- `lib/`: old personal lib/theme assets not imported by the flake.

## Known Intentional Choices

- `flake.lock` is tracked on purpose for reproducible rebuilds.
- `ventoy` is permitted as an insecure package because nixpkgs marks it that
  way. The exception is scoped to the exact package version.
- `codex` from nixpkgs is the terminal package. Codex Desktop may still be
  installed outside Nix until a reliable Nix package exists.
- `neovim.nix` is retained because the shell still uses `nvim` as a fallback
  editor/manpager and Kitty editor.
- `rmpc` is the intended MPD TUI client. `ncmpcpp` is intentionally absent.

## Pre-Push Checklist

```sh
sudo nix --extra-experimental-features 'nix-command flakes' flake check --show-trace
rg 'mkOutOfStoreSymlink|wallust|ncmpcpp|maple-mono' home modules hosts flake.nix || true
git status --short
```
