# Mickium Arch Branch Description

This is the Arch version of Mick's Mickium dotfiles. The checkout lives at
`/home/mick/Mickium` and is separate from the NixOS Mickium checkout at
`/home/mick/Documents/Mickium`.

## Working Rules

- Treat `/home/mick/Mickium` as the Arch Mickium checkout.
- Treat `/home/mick/Documents/Mickium` as read-only reference material unless
  Mick explicitly asks for changes in the Nix checkout.
- Do not alter files in `/home/mick/Documents/Mickium` when the task is to
  backport or adapt Nix behavior onto the Arch branch.
- When comparing Arch and Nix Mickium, use the Nix checkout as a reference and
  apply requested changes only to the Arch checkout.
- Always check Git status before editing. Preserve dirty user changes and do
  not revert unrelated work.
- Keep this file current when adding project-specific rules or functional
  Arch-branch behavior notes.

## Backport Notes

- Waybar parity is checked by comparing Nix
  `/home/mick/Documents/Mickium/home/wayland/waybar.nix` with Arch
  `/home/mick/Mickium/dot.config/waybar/config.jsonc` and
  `/home/mick/Mickium/dot.config/waybar/style.css`.
- The known Waybar background fix is that `#battery`, `#mpd`, and `#tray`
  belong in the same shared rounded background CSS block as `#clock`,
  `#hardware`, `#network`, `#pulseaudio`, `#taskbar`, and quicklinks.
- Current workspace behavior follows the Nix config: persistent workspaces are
  `"*": 10`, and workspace scroll commands use
  `hyprctl dispatch split:workspace m-1` and
  `hyprctl dispatch split:workspace m+1`.
- The Arch Waybar config may keep a `battery` module definition without adding
  it to `modules-right` on desktop machines.
- The wallpaper daemon/tool is `awww`. Use that name in Arch config paths,
  scripts, and docs.

## Path Rules

- Do not copy stale user-specific paths such as `/home/hrigved` into this repo.
- Prefer `$HOME` inside shell scripts when the path should follow the current
  user.
- Prefer absolute paths in Hyprland-style config files when the parser may not
  expand `~`.
- Prefer known system paths for system assets, such as Arch logos, when they
  are more portable than copied home-directory assets.

## Validation

- Validate Waybar config/style changes with:

```sh
timeout 3s waybar -c dot.config/waybar/config.jsonc -s dot.config/waybar/style.css -l warning
```

- Validate Bash scripts with:

```sh
bash -n dot.config/rofi/menus/*.sh dot.config/hypr/scripts/*.sh misc/99-set-env-vars.sh scripts/install-doom-dev-tools.sh
```

- Validate Fish config with:

```sh
fish --no-config -n dot.config/fish/config.fish dot.config/fish/conf.d/*.fish dot.config/fish/functions/*.fish
```

- Validate parseable JSON/TOML files before finishing when those files are
  touched.
- After a cross-repo comparison task, report both Git states so it is clear
  that only the intended checkout changed.

## Post-Install

- The Arch post-install helper is `scripts/post-install-arch.sh`.
- Run it as the target user, not with `sudo`.
- It installs `paru-git`, installs the core packages used by the configs,
  configures passwordless sudo for the current user, sets Fish as the login
  shell, installs `misc/99-set-env-vars.sh` into `/etc/profile.d/`, creates
  the XDG/Cargo/GnuPG directories defined by that file, installs Rust/Cargo,
  installs `fnm` through Cargo, enables `BottomUp` in `/etc/paru.conf`,
  configures Podman/Tailscale, configures Nix admin tooling, configures MPD for
  `~/Music` with `ympd`, and replaces existing `~/.config` targets with
  symlinks to this repo's `dot.config/` entries.
- `GNUPGHOME` must be owned by the user and mode `0700`; GnuPG complains when
  that directory is group/world readable.
