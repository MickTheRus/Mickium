# Mickium Repo Description

Mickium is Mick's personal, standalone NixOS flake. It builds complete NixOS
systems for Mick's machines and also owns the Home Manager user environment for
`mick`.

This file is meant as a handoff map for future sessions. The README is the
short overview; this file explains what the pieces do, what is intentionally
weird, and what problems have already been solved.

## Mental Model

The repo is split into three main layers:

- `flake.nix` wires inputs, overlays, formatter/dev shell, and host outputs.
- `hosts/` declares concrete machines and their hardware configs.
- `modules/` defines shared NixOS system behavior.
- `home/` defines the `mick` Home Manager environment.

Most changes should happen in `modules/` or `home/`. Avoid editing generated
files in `~/.config` directly unless you are debugging; Home Manager will
usually replace them.

## Flake Inputs

`flake.nix` uses unstable `nixpkgs` as the main package set.

Important inputs:

- `nixpkgs`: main unstable package set.
- `nixpkgs-hyprland`: pinned nixpkgs snapshot used by the overlay for Hyprland
  and Hyprland plugins. This exists because `hyprsplit` can break against newer
  Hyprland APIs.
- `home-manager`: Home Manager integrated as a NixOS module.
- `hosts`: StevenBlack hosts blocklist module.
- `doom-emacs`: Doom Emacs source with submodules enabled.
- `nix-index-db`: command-not-found/index integration.
- `claude-desktop`, `meshcore-cli`: app/package inputs used by the user profile.

The dev shell includes useful Nix maintenance tools such as `alejandra`,
`deadnix`, `nil`, `statix`, and `git`.

## Hosts

Hosts are exposed through `hosts/default.nix` as lowercase flake outputs:

- `maxwell`: desktop profile. The real live Maxwell may be Arch-based, so do
  not assume the running Maxwell machine is currently this NixOS config.
- `altar`: Lenovo laptop profile. This is the actively installed laptop target.
- `wortox`: Ventoy-adjacent portable system drive. It has extra bootloader
  handling so entries/kernels go to XBOOTLDR and EFI variables are not touched.

All hosts share the common module set and the same Home Manager user
configuration for `mick`.

Common build commands:

```sh
nix build .#nixosConfigurations.altar.config.system.build.toplevel
sudo ./result/bin/switch-to-configuration switch
```

or, when Git ownership/safe-directory is happy:

```sh
sudo nixos-rebuild switch --flake .#altar
```

## Shared System Modules

`modules/default.nix` imports the shared NixOS modules.

### `modules/core.nix`

Core user/system defaults:

- Creates `mick` as the main normal user.
- Sets initial passwords for `root` and `mick`.
- Adds `mick` to groups needed for admin, input, virtualization, ADB, serial,
  video, and similar workflows.
- Installs system-level essentials including `android-tools`, `gitFull`, and
  `nh`.
- Replaces `sudo` with a small wrapper pointing to `doas`.
- Sets locale, console keyboard, editor/browser environment variables, and
  base shell support.

### `modules/bootloader.nix`

Boot and kernel behavior:

- Uses the Linux Zen kernel.
- Enables `systemd-boot`.
- Limits visible systemd-boot generation entries to 5.
- Uses `system.boot.loader.kernelFile = "vmlinuz"` for newer nixpkgs kernel
  naming behavior.
- Includes xpadneo support.
- Enables aarch64 binfmt support.

The systemd-boot generation limit only controls boot menu entries. It does not
delete old Nix store paths by itself.

### `modules/nix.nix`

Nix daemon and flake settings:

- Enables flakes and `nix-command`.
- Sets trusted users.
- Keeps derivations and outputs.
- Enables weekly garbage collection for store paths older than 7 days.
- Pins registry/nixPath entries to the flake inputs.
- Adds `/home/mick/Mickium` as a Git safe directory in system config so
  root-driven rebuilds can evaluate the flake.
- Overlays Hyprland and Hyprland plugins from the pinned `nixpkgs-hyprland`
  input.

That safe-directory bit exists because `sudo nixos-rebuild --flake` evaluates
the Git repo as root, and libgit2 rejects repos not owned by the evaluating
user unless marked safe.

### `modules/network.nix`

Networking:

- Enables NetworkManager.
- Uses randomized Wi-Fi MACs.
- Uses systemd-resolved with Mullvad fallback DNS.
- Enables StevenBlack host blocking through the flake input.
- Enables Avahi/mDNS.
- Enables OpenSSH on port `2764`.
- Opens firewall port `2764`.
- Opens KDE Connect TCP/UDP range `1714-1764`.

SSH should not be expected on port 22 for these NixOS hosts.

### `modules/security.nix`

Security/authentication:

- Enables `doas` with passwordless `wheel`.
- Disables sudo.
- Enables `pcscd` and YubiKey/U2F packages.
- Enables PAM U2F with auth file:

```text
/home/mick/.config/Yubico/u2f_keys
```

- Wires `gtklock` and `hyprlock` into the normal login PAM stack.
- Enables fail2ban and dnscrypt-proxy.

Security keys are accepted through PAM U2F. The configured key file is managed
under the user home; if login behavior changes, check that file and `pcscd`.

### `modules/desktop.nix`

Desktop services and hardware:

- Enables Ly as the display manager.
- Enables Hyprland.
- Enables KDE Connect, Steam, NoiseTorch, PipeWire, portals, printing,
  fingerprint support, power services, GVFS, upower, fstrim, and seatd.
- Enables Tailscale and starts a login helper service that runs:

```sh
tailscale up --accept-dns --accept-routes --operator=mick --timeout=0s
```

- Configures lid/power handling through logind for suspend-then-hibernate.

### `modules/containers.nix`

Containers and virtualization:

- Enables Podman with Docker compatibility and Docker socket compatibility.
- Enables libvirt/QEMU/KVM.
- Includes OVMF and swtpm support.
- Installs/uses `virtiofsd`.
- Enables SPICE USB redirection.

## Home Manager

`home/default.nix` is the Home Manager entrypoint for user `mick`.

The Home Manager tree owns desktop config, shell config, editor config, apps,
themes, SSH client config, Wayland config, and user packages.

## Wayland, Hyprland, and Waybar

Main files:

- `home/wayland/default.nix`: shared Wayland packages and session variables.
- `home/wayland/hyprland.nix`: generates and links Hyprland config.
- `home/wayland/hypr-config/`: source Hyprland config tree.
- `home/wayland/waybar.nix`: Waybar config.

Hyprland config is generated into a host-specific store-built directory, then
linked into `~/.config/hypr`. Edit the repo source, not the generated target.

Host-specific monitor layouts live here:

- `home/wayland/hypr-config/monitors/Altar.conf`
- `home/wayland/hypr-config/monitors/Maxwell.conf`
- `home/wayland/hypr-config/monitors/default.conf`

### Hyprsplit

The repo uses the `hyprsplit` Hyprland plugin for split/per-monitor workspaces.
Relevant config is in:

```text
home/wayland/hypr-config/hyprland.conf
```

It sets:

- `num_workspaces = 10`
- `persistent_workspaces = true`

Keybinds should use hyprsplit dispatchers such as `split:workspace`. If
hyprsplit fails to build after a flake update, check whether Hyprland moved
ahead of the plugin API. The pinned Hyprland package set exists to avoid that.

### Wallpaper

Wallpaper is set with `awww`.

The baked source wallpaper is:

```text
home/wayland/hypr-config/Wallpaper.jpeg
```

Home Manager links it to:

```text
~/.config/hypr/Wallpaper.jpeg
```

The wallpaper helper still has an old filename in the Rofi module, but it uses
`awww` internally. If wallpaper is blank, check that `awww-daemon` is running
and that `~/.config/hypr/Wallpaper.jpeg` exists.

### Lock and Lid Behavior

The config includes `hyprlock` and `hypridle`.

Expected behavior:

- Manual lock is bound in Hyprland config.
- Idle lock is handled by `hypridle`.
- Lid close is handled by systemd-logind and should suspend-then-hibernate.

### Waybar Laptop Differences

Waybar checks the NixOS host name. Battery UI is only enabled for `Altar`.

If a battery shows up on a desktop or disappears on the laptop, inspect:

```text
home/wayland/waybar.nix
```

## Theming

GTK and Qt theming are configured separately.

Relevant files:

- `home/programs/gtk.nix`
- `home/programs/qt.nix`

GTK uses a Catppuccin Mocha Maroon theme derivation and sets `GTK_THEME`,
GNOME interface dconf values, icons, cursors, and fonts.

Qt uses qtct/qt5ct/qt6ct-style configuration with Catppuccin colors.

If KDE Connect or GTK apps look wrong while Qt apps look correct, start with
`home/programs/gtk.nix`.

## Shell, Terminal, and SSH

The terminal setup is Kitty-only. Foot and Zellij were intentionally removed.

Shell/editor behavior:

- Fish is the main interactive shell.
- Common aliases also exist for other shell contexts.
- `v`, `vi`, `vim`, `nvim`, and `e` alias to:

```sh
emacs -nw
```

SSH client config is generated from Nix. The desired hosts include:

- `github.com` on port 22.
- `montanamesh` over Tailscale on port 2764.
- `Wormhole` over Tailscale on port 2764.
- `Maxwell` over Tailscale on port 2764.
- `Altar` over Tailscale on port 2764.

The NixOS OpenSSH server also listens on port 2764.

## Doom Emacs

Main files:

- `home/shell/emacs.nix`
- `home/shell/doom/init.el`
- `home/shell/doom/config.el`
- `home/shell/doom/packages.el`
- `home/shell/doom/snippets/.keep`

Doom is intentionally handled differently from a normal read-only Nix source.
The activation script copies the pinned Doom source into writable
`~/.config/emacs` because Doom writes state under its own tree. It also copies
the bundled Doom module tree when needed.

Activation then runs Doom sync. Sync failures are warnings and should not block
Home Manager activation.

Known fixes already applied:

- Doom input uses submodules.
- Doom module tree is copied into the writable config.
- The renamed dashboard module is `:ui dashboard`, not the older name.
- Snippets directory is present so modules expecting snippets do not crash.

If Doom breaks again, useful checks:

```sh
doom doctor
doom sync
emacs -nw
```

On Altar, Doom was verified to load with dired and dashboard available after
the previous fixes.

## User Packages and Tools

Package groups are mostly under:

- `home/programs/packages.nix`
- `home/programs/games.nix`
- `home/shell/cli.nix`

Notable tools:

- Android/phone: `android-tools`, `scrcpy`.
- Git: `gitFull`, `gh`, `lazygit`.
- Virtualization: QEMU/KVM/libvirt, OVMF, swtpm, `virtiofsd`.
- Minecraft: Prism Launcher.
- JetBrains: Rider.
- Wine: `wineWow64Packages.stableFull` and `winetricks`.
- Radio/APRS/serial/mesh: `direwolf`, YAAC, `gpsbabel`, AX.25 tools,
  `picocom`, MeshCore CLI, Meshtastic tools.
- Browser: Brave through the Chromium Home Manager module.

YAAC is packaged from its upstream zip with a small wrapper around Java. If it
fails during unpack, keep the derivation's `dontUnpack`/manual unzip behavior.

## Wine Prefix Note

There is a `d + "/wine"` expression in the Home Manager shell config. The `d`
is just a local variable for `config.xdg.dataHome`, so the resulting prefix is
under the XDG data directory. It is not a leftover user name.

## Tailscale

Tailscale is a system service and is configured to accept routes/DNS. The
helper service tries to keep it logged in for user `mick`.

For a fresh machine, the usual manual command is still useful:

```sh
sudo tailscale up --accept-dns --accept-routes --operator=mick
```

Subnet-router and exit-node flags are machine-role specific and should not be
blindly baked into every host. Mick's home server is the subnet router, not
Altar by default.

## Fresh Install Notes

The laptop install used BTRFS with normal subvolumes. Hardware config for a new
install may leave the tree dirty until committed.

Dirty Git tree warnings during Nix evaluation are warnings. They matter for
reproducibility but do not automatically make the build invalid.

If root cannot evaluate the flake because of Git ownership, the repo-level
system safe-directory config should fix it after a successful rebuild. Before
that config exists on a fresh install, a manual workaround may be needed.

## Known Sharp Edges

- Hyprland plugin compatibility is fragile. Keep the pinned Hyprland package
  set unless intentionally updating `hyprsplit`.
- Home Manager owns many files in `~/.config`; deleting stale unmanaged files
  may be needed if activation says a file is in the way.
- OpenSSH uses port 2764, not 22.
- Maxwell can refer to both a NixOS host config and a live Arch-based system.
  Confirm which one is being discussed before changing assumptions.
- Systemd-boot entry limiting is separate from Nix garbage collection.
- Android udev rules package was removed upstream; newer systemd uaccess rules
  supersede it, so do not re-add the removed package blindly.

## Useful Maintenance Commands

Format Nix files:

```sh
nix fmt
```

Build a host:

```sh
nix build .#nixosConfigurations.altar.config.system.build.toplevel
```

Switch using the built result:

```sh
sudo ./result/bin/switch-to-configuration switch
```

Rebuild directly:

```sh
sudo nixos-rebuild switch --flake .#altar
```

Check Git state:

```sh
git status --short
git log --oneline -n 12
```

Check failed Home Manager service:

```sh
systemctl status home-manager-mick.service --no-pager -l
journalctl -u home-manager-mick.service -b --no-pager -l
```

Check SSH port:

```sh
sudo ss -tlnp | grep sshd
```

## Future-Agent Rules

- Check `git status --short` before editing. There may be user changes.
- Do not revert unrelated dirty files.
- Prefer editing repo sources over generated Home Manager targets.
- For docs-only changes, commit only the docs file and avoid pulling in dirty
  config files.
- For Hyprland plugin build failures, suspect version drift first.
- For Doom failures, inspect the activation copy/sync behavior before changing
  Doom modules.
- For SSH issues, remember both client and server are intended to use port 2764.
