# Mickium Arch

Mickium Arch is my personal Arch Linux dotfiles branch. It owns the user-facing
desktop configuration for Hyprland, Waybar, Rofi, Fish, Kitty, Doom Emacs,
GTK/Qt theming, wallpaper handling, notifications, and a handful of small helper
scripts.

This checkout is meant to be the live Arch dotfiles tree. The related NixOS
Mickium checkout can be used as reference material, but Arch changes belong in
this repository.

## What This Repo Configures

The repo is centered on a Wayland desktop:

- Hyprland for the compositor and keybinds.
- Waybar for status, quick links, workspace state, MPD, tray, and hardware UI.
- Rofi for app launch, clipboard, emoji, and wallpaper menus.
- Fish as the primary shell.
- Kitty as the terminal.
- SwayNC for notifications.
- Hyprlock and Hypridle for lock/idle behavior.
- Doom Emacs for editor configuration.
- GTK, Qt5, Qt6, and Electron flags for desktop theming.

## Top-Level Map

```text
DESCRIPTION.MD  Project rules, backport notes, and validation commands.
README.MD       This overview.
dot.config/     Files intended to map into ~/.config.
misc/           Extra themes, qBittorrent styling, profile image, env helper.
scripts/        One-off install/maintenance helpers.
```

## Desktop Stack

Hyprland config lives in `dot.config/hypr/`.

```text
dot.config/hypr/hyprland.conf       Main Hyprland entrypoint.
dot.config/hypr/conf/autostart.conf Startup services.
dot.config/hypr/conf/env.conf       Wayland/session environment.
dot.config/hypr/conf/keybinds.conf  Keyboard and mouse bindings.
dot.config/hypr/conf/rules.conf     Layer and window rules.
dot.config/hypr/hyprlock.conf       Lock screen config.
dot.config/hypr/hypridle.conf       Idle behavior.
dot.config/hypr/scripts/            Helper scripts used by binds and services.
```

Important defaults:

- Terminal: Kitty.
- File manager: Dolphin.
- Browser: Brave.
- Main modifier: Super.
- Lock binding: `SUPER+CTRL+L`.
- Wallpaper switching goes through the Rofi wallpaper menu and refreshes the
  current wallpaper cache/variants.

## Waybar

Waybar lives in `dot.config/waybar/`.

```text
dot.config/waybar/config.jsonc  Module layout and behavior.
dot.config/waybar/style.css     Bar styling.
dot.config/waybar/colors.css    Generated/current color values.
```

The Arch Waybar config tracks the useful behavior from the Nix Mickium Waybar
setup where it makes sense. Current workspace behavior uses persistent
workspaces and Hyprland split workspace scroll commands.

The MPD, tray, and optional battery modules should share the same rounded
background treatment as the other right-side status modules.

Validate Waybar changes with:

```sh
timeout 3s waybar -c dot.config/waybar/config.jsonc -s dot.config/waybar/style.css -l warning
```

## Rofi

Rofi config lives in `dot.config/rofi/`.

```text
dot.config/rofi/config.rasi      Main Rofi config.
dot.config/rofi/colors.rasi      Current/generated colors.
dot.config/rofi/styles/          Menu-specific themes.
dot.config/rofi/menus/           Launcher, emoji, clipboard, wallpaper scripts.
```

The menu scripts keep `.sh` filenames because Hyprland and Waybar already call
those paths, but they are Bash scripts now and do not require another shell.
The wallpaper menu is `awww.sh`; it drives the `awww` wallpaper daemon.

## Shell And Terminal

Fish is the primary shell.

```text
dot.config/fish/config.fish       Fish entrypoint.
dot.config/fish/fish_plugins      Fisher plugin list.
dot.config/fish/conf.d/           Plugin and startup snippets.
dot.config/fish/functions/        Tide, fzf, sponge, and helper functions.
dot.config/kitty/kitty.conf       Kitty terminal config.
```

Installed Fish plugins:

- `jorgebucaran/fisher`
- `ilancosman/tide@v6`
- `patrickf1/fzf.fish`
- `meaningful-ooo/sponge`

Per-machine Fish state, generated completions, and history should stay out of
Git.

## Theming

The desktop theme is Catppuccin flavored with Iosevka Nerd Font.

```text
dot.config/gtk-3.0/settings.ini       GTK 3 settings.
dot.config/gtk-4.0/settings.ini       GTK 4 settings.
dot.config/qt5ct/                     Qt5 theme config.
dot.config/qt6ct/                     Qt6 theme config.
dot.config/electron-flags.conf        Electron Wayland flags.
dot.config/wlogout/                   Logout menu layout and styling.
dot.config/swaync/                    Notification styling and config.
```

Wallpaper changes should update the current wallpaper cache and generated
lock/logout background assets.

## Editor

Doom Emacs config lives in `dot.config/doom/`.

```text
dot.config/doom/init.el      Enabled Doom modules.
dot.config/doom/config.el    User config.
dot.config/doom/packages.el  Extra package declarations.
```

The helper script `scripts/install-doom-dev-tools.sh` installs language server
packages used by the Doom setup on Arch.

## Miscellaneous Assets

```text
misc/catppuccin-mocha.qbtheme     qBittorrent theme.
misc/catppuccin-mocha.theme.css   Related theme CSS.
misc/qbt/                         qBittorrent stylesheet resources.
misc/99-set-env-vars.sh           XDG/env helper.
misc/pfp.jpg                      Profile image asset.
```

## Maintenance

Check Git state before editing:

```sh
git status --short --branch
```

Validate Bash scripts:

```sh
bash -n dot.config/rofi/menus/*.sh dot.config/hypr/scripts/*.sh misc/99-set-env-vars.sh scripts/install-doom-dev-tools.sh
```

Validate Fish config:

```sh
fish --no-config -n dot.config/fish/config.fish dot.config/fish/conf.d/*.fish dot.config/fish/functions/*.fish
```

Validate parseable JSON and TOML files when touched.

## Post-Install Script

Run the Arch post-install helper as the target user, not with `sudo`:

```sh
./scripts/post-install-arch.sh
```

The script installs `paru-git`, installs the desktop/app stack used by these
configs, writes a passwordless sudoers entry for the current user, sets Fish as
the user's login shell, installs `misc/99-set-env-vars.sh` into
`/etc/profile.d/`, creates the XDG/Cargo/GnuPG folders it defines, installs
Rust/Cargo, installs `fnm` through Cargo, enables `BottomUp` in
`/etc/paru.conf`, configures Podman, enables Tailscale, configures MPD for
`~/Music` with `ympd`, and symlinks each entry from `dot.config/` into
`~/.config/`. Existing targets in `~/.config/` are removed before the symlinks
are created. `GNUPGHOME` is forced to `0700` so GnuPG does not reject it as
world-readable.
