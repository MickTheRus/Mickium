# Mickium Repo Description

Mickium is Mick's personal, standalone NixOS flake. It builds complete NixOS
systems for Mick's machines and also owns the Home Manager user environment for
`mick`.

This file is meant as a handoff map for future sessions. The README is the
short overview; this file explains what the pieces do, what is intentionally
weird, and what problems have already been solved.

## Maintenance Contract

Keep this file current with the repo. Any functional config change should
update `DESCRIPTION.MD` in the same change, even if the edit is only a short
note confirming that an existing section is still accurate.

If a future checkout is missing this file, recreate it before making further
config changes. It should summarize the host model, shared modules, Home
Manager layout, intentional weirdness, and operational gotchas.

## Mental Model

The repo is split into three main layers:

- `flake.nix` wires inputs, formatter/dev shell, and host outputs. The
  nixpkgs overlay lives in `modules/nix.nix`.
- `hosts/` declares concrete machines and their hardware configs.
- `modules/` defines shared NixOS system behavior.
- `home/` defines the `mick` Home Manager environment.

Most changes should happen in `modules/` or `home/`. Avoid editing generated
files in `~/.config` directly unless you are debugging; Home Manager will
usually replace them.

## Flake Inputs

`flake.nix` uses unstable `nixpkgs` as the main package set.

Important inputs:

- `nixpkgs`: main unstable package set. Hyprland comes from here too; there
  is no separate Hyprland pin (see "Hyprland Version and Plugin" below).
- `home-manager`: Home Manager integrated as a NixOS module.
- `hosts`: StevenBlack hosts blocklist module.
- `doom-emacs`: Doom Emacs source with submodules enabled.
- `nix-index-db`: command-not-found/index integration.
- `claude-desktop`, `meshcore-cli`, `codex-desktop-linux`: app/package inputs
  used by the user profile.

The dev shell includes useful Nix maintenance tools such as `alejandra`,
`deadnix`, `nil`, `statix`, and `git`.

## Hosts

Hosts are exposed through `hosts/default.nix` as lowercase flake outputs:

- `maxwell`: desktop profile. The real live Maxwell may be Arch-based, so do
  not assume the running Maxwell machine is currently this NixOS config. Its
  NixOS profile assumes a Ryzen 5800X3D plus Radeon 9070-class GPU and enables
  AMD ROCm OpenCL.
- `altar`: Lenovo laptop profile. This is the actively installed laptop target.
  Its current GPU path is AMD Barcelo/Renoir-class integrated graphics, so it
  uses Mesa OpenCL/Rusticl with `RUSTICL_ENABLE=radeonsi` instead of Intel
  OpenCL or the heavier ROCm stack.
- `wortox`: Ventoy-adjacent portable system drive. It has extra bootloader
  handling so entries/kernels go to XBOOTLDR and EFI variables are not touched.

All hosts share the common module set and the same Home Manager user
configuration for `mick`.

Flake outputs are lowercase (`altar`) but `networking.hostName` is
capitalised (`Altar`), so `nixos-rebuild --flake ~/Mickium` without an
explicit `#altar` will not find the output. Always name it.

Rebuild when working locally on the machine (activates immediately):

```sh
doas nixos-rebuild switch --flake ~/Mickium#altar
```

Over SSH, stage the generation for next boot instead (no live switch):

```sh
doas nixos-rebuild boot --flake ~/Mickium#altar
```

Never run plain `nixos-rebuild` without `--flake`. It falls back to
`/etc/nixos/configuration.nix`, which on these machines is only the
installer stub (see "Known Sharp Edges").

## Shared System Modules

`modules/default.nix` imports the shared NixOS modules.

### `modules/core.nix`

Core user/system defaults:

- Creates `mick` as the main normal user.
- Sets `initialPassword` for `mick` (root has none and is locked). NixOS only applies this when
  the user is created, so it normally has no effect. But if a generation that
  does not declare `mick` is ever activated, NixOS deletes the user, and the
  next good generation recreates it with the initial password. Run `passwd`
  afterwards. Same uid (1000), so home ownership survives.
- Adds `mick` to groups needed for admin, input, virtualization, ADB, serial,
  video, and similar workflows.
- Installs system-level essentials including `android-tools`, `gitFull`, and
  `nh`.
- Replaces `sudo` with a small wrapper pointing to `doas`.
- Sets locale, console keyboard, editor/browser environment variables, and
  base shell support.
- Sets the shared NixOS `system.stateVersion` default to `26.05`.

### `modules/bootloader.nix`

Boot and kernel behavior:

- Uses the Linux Zen kernel.
- Enables `systemd-boot`.
- Limits visible systemd-boot generation entries to 5.
- Lets nixpkgs choose the correct bootloader kernel image name for the selected
  kernel package.
- Includes xpadneo support.

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
- Permits the exact insecure `ventoy` version nixpkgs currently ships. Bump the
  version string when nixpkgs bumps ventoy, or evaluation fails.
- One overlay: adds `hyprlandPlugins.split-monitor-workspaces`, which is not
  in nixpkgs (see "Hyprland Version and Plugin").
- `system.autoUpgrade` rebuilds daily from the local checkout
  (`/home/mick/Mickium#<lowercased hostName>`) with `upgrade = false` and
  `operation = "boot"`. It honours the committed `flake.lock` and does not
  update inputs, because a root-run input update would leave root-owned files
  and lock commits in Mick's repo. Updating inputs stays a manual
  `nix flake update`.

That safe-directory bit exists because `sudo nixos-rebuild --flake` evaluates
the Git repo as root, and libgit2 rejects repos not owned by the evaluating
user unless marked safe.

### `modules/network.nix`

Networking:

- Enables NetworkManager.
- Uses randomized Wi-Fi MACs.
- Uses systemd-resolved, which forwards all lookups to the local
  `dnscrypt-proxy` (`DNS=127.0.0.1`). NetworkManager runs with `dns = "none"`
  (forced, since the resolved module sets it) so DHCP/router DNS is not pushed
  into resolved. Mullvad plain DNS is only `FallbackDNS`, used if
  dnscrypt-proxy is down. Tailscale MagicDNS still registers itself with
  resolved directly. DNSSEC validation is done by dnscrypt-proxy
  (`require_dnssec`), so resolved's own `DNSSEC` stays off.
- Enables StevenBlack host blocking through the flake input.
- Enables Avahi/mDNS.
- Enables OpenSSH on port `2764`, key-only (`PasswordAuthentication` and
  `KbdInteractiveAuthentication` are off). Keep a working key in
  `authorizedKeys` before activating.
- Opens firewall port `2764`.
- Opens KDE Connect TCP/UDP range `1714-1764` on `tailscale0` only. LAN
  discovery no longer works; add devices by their Tailscale IP in KDE Connect.
  The daemon comes from Home Manager (`services.kdeconnect`). Do not enable
  NixOS `programs.kdeconnect`: it opens the ports on every interface.

SSH should not be expected on port 22 for these NixOS hosts.

### `modules/security.nix`

Security/authentication:

- Enables `doas` with passwordless `wheel`.
- Disables sudo.
- Enables `pcscd` and YubiKey/U2F packages.
- Enables GNOME Keyring as the desktop Secret Service (`org.freedesktop.secrets`).
  The NixOS module adds unlocking/startup to the `login` PAM stack, which Ly
  delegates to. Use the login password as the login keyring password for
  automatic unlocking; fingerprint/U2F-only login cannot supply that password
  and may require unlocking the keyring manually in Seahorse. The existing
  GPG/SSH agent configuration is unchanged: `services.gnome.gcr-ssh-agent`
  is explicitly disabled because its default follows GNOME Keyring and
  conflicts with `programs.ssh.startAgent`.
- Enables PAM U2F with auth file:

```text
/home/mick/.config/Yubico/u2f_keys
```

- Wires `gtklock` and `hyprlock` into the normal login PAM stack.
- Enables fail2ban and dnscrypt-proxy (with caching; see the network section).

Security keys are accepted through PAM U2F. The configured key file is managed
under the user home; if login behavior changes, check that file and `pcscd`.

### `modules/desktop.nix`

Desktop services and hardware:

- Enables Ly as the display manager.
- Enables `programs.nix-ld` for generic Linux binaries downloaded at runtime
  by Claude Desktop (notably its Claude Code executable). Without the standard
  ELF loader compatibility, those binaries exit with code 127 and the NixOS
  "Could not start dynamically linked executable" message.
- Enables Hyprland through a wrapper that clears inherited ambient
  capabilities before the compositor starts user apps. The NixOS Hyprland
  module gives `Hyprland` a `cap_sys_nice` security wrapper, and NixOS now
  refuses wrapper targets that are scripts, so the wrapper must be built with
  `makeBinaryWrapper` (an ELF). It runs
  `capsh --noamb -- -c 'exec "$0" "$@"' <real Hyprland>`.
- Enables dconf, Steam, PipeWire, portals, printing,
  fingerprint support, power services, GVFS, upower, fstrim, atd, and seatd.
- Unprivileged user namespaces (needed by Steam pressure-vessel, Heroic,
  DaVinci Resolve and other Bubblewrap/FHS runtimes) are on by default on the
  Zen kernel. `security.unprivilegedUsernsClone` was removed upstream, so do
  not re-add it.
- Caps journald disk usage via `services.journald.settings.Journal`
  (`extraConfig` was removed upstream) and enables udisks2 for user-drive
  mounting. The D-Bus keyring prompter comes from `gcr_4`; plain `gcr` was
  removed from nixpkgs.
- Enables Tailscale and starts a login helper service that runs:

```sh
tailscale up --accept-dns --accept-routes --operator=mick --timeout=0s
```

- Configures lid/power handling through logind for suspend-then-hibernate.
- Sets CPU governor policy to `performance` while charging/AC-powered and
  `powersave` on battery through auto-cpufreq/TLP.
- Leaves Bluetooth available on battery and startup; TLP should not rfkill it.
- Enables graphics/32-bit graphics support and the shared font set.
- Host-specific GPU compute is layered in `hosts/default.nix`: Altar uses
  Mesa OpenCL/Rusticl for its AMD integrated GPU, while Maxwell enables AMD
  ROCm OpenCL for the Radeon 9070-class desktop GPU.

### `modules/bluetooth.nix`

Bluetooth:

- Enables BlueZ.
- Sets FastConnectable, JustWorksRepairing, device privacy, a controller class,
  and BLE connection interval hints for xpadneo/Xbox controller stability.
- Leaves BlueZ userspace HID disabled so Bluetooth controllers are handled by
  the kernel HID stack/xpadneo. If only D-pad input works in games, confirm
  this setting has not been flipped back on.
- Leaves BlueZ experimental profiles disabled; they were causing noisy RAP/BAP
  failures around Xbox controller connection attempts.
- Disables the user `telephony_client` service as a workaround for the known
  nixpkgs/Bluetooth telephony issue.

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

`home/default.nix` sets the shared Home Manager `home.stateVersion` to `26.05`.
It imports nix-index integration, the Codex Desktop Linux Home Manager module,
and the repo-owned `home/security`, `home/shell`, `home/programs`, and
`home/wayland` trees.

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

### Hyprland Version and Plugin

Hyprland comes straight from main `nixpkgs` (0.56.2 as of the 2026-10-20
lock). Per-monitor workspaces use the C++ build of
[split-monitor-workspaces](https://github.com/zjeffer/split-monitor-workspaces),
packaged in the `modules/nix.nix` overlay with
`hyprlandPlugins.mkHyprlandPlugin` (meson + ninja, `lua5_5`). It was
switched from `hyprsplit` on 2026-10-21 because hyprsplit stopped at Hyprland
0.54.3/0.55.4 and does not build on 0.56.

Pinning rule: the plugin `rev` must be the plugin commit that the repo's
`hyprpm.toml` lists for the Hyprland version nixpkgs ships. Entries are
`[hyprland_commit, plugin_commit]`, and the *second* hash is the one to use.
After a `nix flake update` that bumps Hyprland, look up the new pin, update
`rev`/`hash`/`version`, and rebuild. If a newer Hyprland has no pin yet, hold
nixpkgs back rather than reintroducing a separate Hyprland pin (see the Mesa
sharp edge below).

Upstream deprecated the C++ plugin in favour of a Lua package. The Lua
package does not support Home Manager config yet (issue #293), and this repo
still uses hyprlang (`configType = "hyprlang"`), so stay on the C++ plugin.

Config in `home/wayland/hypr-config/hyprland.conf`:

```text
plugin {
    split-monitor-workspaces {
        count = 10
        enable_persistent_workspaces = 1
    }
}
```

Keybinds (`conf/keybinds.conf`) use `split-workspace` and
`split-movetoworkspace`. Waybar scroll uses `split-cycleworkspaces`.

Validate config changes against the built Hyprland before rebooting:

```sh
Hyprland --verify-config -c ~/.config/hypr/hyprland.conf
```

The validator does not load plugins, so "Invalid dispatcher split-…" errors
are expected. Anything else is real. Hyprland 0.56 removed
`dwindle:pseudotile`, and `layerrule = ignore_alpha` takes a number.

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
The battery, MPD, and system tray modules use the same rounded background
treatment as the other right-side status modules.

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
- Home Manager shell integrations should target Fish; stale Zsh integrations
  are intentionally disabled.
- Common aliases also exist for other shell contexts.
- `v`, `vi`, `vim`, `nvim`, and `e` alias to:

```sh
emacs -nw
```

SSH client config is generated from Nix. The desired hosts include:

- `github.com` on port 22.
- `montanamesh` on port 2764 with `~/.ssh/montanamesh`.
- `Wormhole` on port 2764 with `~/.ssh/Wormhole`.
- `Maxwell` on port 2764 with `~/.ssh/Personal_Computers`.
- `Altar` on port 2764 with `~/.ssh/Personal_Computers`.
- `Wortox` on port 2764 with `~/.ssh/Personal_Computers`.

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
Home Manager activation. The generated `home-manager-mick.service` has an
extended 30 minute start timeout because a fresh Doom package sync can take
longer than systemd's default 5 minute oneshot timeout.

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

If sync reports a missing `.local/straight/repos/straight.el/straight.el`,
inspect that checkout first. An interrupted bootstrap can leave only `.git`
with no commits; Doom sees the directory and skips downloading it again.
Move that incomplete checkout aside as a backup, then run `doom sync` as
`mick` to retry the bootstrap. After a successful sync, recover a daemon that
hit systemd's restart limit with `systemctl --user reset-failed emacs` and
`systemctl --user restart emacs`. Home Manager deliberately warns rather than
aborting activation when sync fails, so successful activation alone does not
confirm Doom initialized successfully.

On Altar, Doom was verified to load with dired and dashboard available after
the previous fixes.

## User Packages and Tools

Package groups are mostly under:

- `home/programs/packages.nix`
- `home/programs/games.nix`
- `home/programs/media.nix`
- `home/shell/cli.nix`

Notable tools:

- Android/phone: `android-tools`, `scrcpy`, KDE Connect.
- Git: `gitFull`, `gh`, `lazygit`.
- Virtualization: QEMU/KVM/libvirt, OVMF, swtpm, `virtiofsd`.
- Minecraft: Prism Launcher, plus `jdk17`/`jdk21` in `games.nix` for
  per-instance Java selection. The JDKs are linked separately at
  `~/.local/share/java/jdk17` and `~/.local/share/java/jdk21` to avoid binary
  collisions in the Home Manager package environment. `jdk22` was requested
  but nixpkgs dropped it upstream (short-lived non-LTS release, no longer built
  or available as a Temurin binary); `jdk21` (current LTS) stands in for it.
- JetBrains: Rider.
- Gaming/Wine: Steam, Heroic Games Launcher, Bolt Launcher,
  `wineWow64Packages.stableFull`, `winetricks`, and controller diagnostics
  through `evtest`/`jstest-gtk`.
- Media/audio: MPD with `rmpc`/`mpc`, mpv, imv, yt-dlp, `playerctl`,
  `playerctld`, qpwgraph, pavucontrol, pamixer, pulsemixer, and PulseAudio
  client tools for `pactl`. The system audio server is still PipeWire with
  PulseAudio compatibility, not the PulseAudio daemon. DaVinci Resolve is
  wrapped with `QT_QPA_PLATFORM=xcb` because the bundled Qt build does not
  include a Wayland platform plugin; `clinfo` is installed for checking GPU
  compute/OpenCL availability.
- Creative/media apps: Blender, Inkscape, Krita, DaVinci Resolve, Equibop.
- Electronics/PCB design: KiCad, including the standard library set provided
  by the nixpkgs `kicad` package.
- Credentials: Seahorse manages GNOME Keyring. Claude Desktop is launched
  with `CLAUDE_PASSWORD_STORE=gnome-libsecret` so Electron selects the Secret
  Service backend under Hyprland. Brave gets the equivalent
  `--password-store=gnome-libsecret` via `commandLineArgs` in
  `home/programs/browser.nix`. Missing keyring support previously produced
  `safeStorage` errors and prevented session persistence. These changes require
  activating the new system generation and a fresh login before testing.
- Radio/APRS/serial/mesh: `direwolf`, YAAC, `gpsbabel`, MeshCore CLI,
  Meshtastic tools, and serial helpers such as `cutecom`. `ax25-tools` is
  commented out in `home/programs/packages.nix`: it fails to build in nixpkgs
  2026-10-20 because `linux/hdlcdrv.h` is gone from the kernel headers.
  Re-enable it when nixpkgs fixes it.
- MeshCore: `meshcore-cli` comes from its flake input, while the `meshcore`
  Python library is packaged locally from PyPI in `packages.nix`. When the CLI
  input moves, its `meshcore>=` requirement can outrun the local library
  (`pythonRuntimeDepsCheck` fails). Bump `meshcore` (version + hash) to match.
- Browser: Brave through the Chromium Home Manager module.

YAAC is packaged from its upstream zip with a small wrapper around Java. If it
fails during unpack, keep the derivation's `dontUnpack`/manual unzip behavior.

## Codex Desktop for Linux

`home/programs/codex-desktop.nix` enables `programs.codexDesktopLinux` from
the `codex-desktop-linux` flake input
(https://github.com/ilysenko/codex-desktop-linux), an unofficial Linux build
of OpenAI's Codex Desktop. The Home Manager module is imported at the top
level in `home/default.nix` (same pattern as `nix-index-db`), and the config
file sets `cliPackage = pkgs.codex;` so the Desktop launcher is wrapped with
an explicit `CODEX_CLI_PATH` pointing at the `codex` CLI already installed via
`home/programs/packages.nix`, instead of depending on session `PATH`.

Only the base package variant is enabled. `computerUseUi.enable`,
`remoteMobileControl.enable`, and `remoteControl.enable` are left off; they
pull in extra runtime deps (`ydotool`, AT-SPI, an app-server exposed over a
listener) and are opt-in on purpose. Turn them on in
`home/programs/codex-desktop.nix` if needed later.

This package builds a Rust binary and repackages an upstream `Codex.dmg`
(fixed-output derivation), so first build/switch after adding it will take a
while and needs network access. If the upstream DMG hash goes stale, wait for
the input's daily hash-refresh bot and re-run `nix flake update
codex-desktop-linux`.

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
that config exists on a fresh install, a manual workaround may be needed
(for example `git config --global --add safe.directory '*'` as root on the
live USB).

After installing, rename `/etc/nixos/configuration.nix` to
`configuration.nix.installer-stub` so a stray non-flake `nixos-rebuild`
cannot build it.

## Known Sharp Edges

- Hyprland plugin compatibility is fragile. The split-monitor-workspaces
  `rev` must match the Hyprland version in nixpkgs (see "Hyprland Version and
  Plugin").
- Do not pin Hyprland to a different nixpkgs than the system. Hyprland links
  `libgbm` from its own nixpkgs while the GPU driver (`/run/opengl-driver`)
  comes from main nixpkgs. When they drift too far apart (e.g. libgbm 25.1 vs
  Mesa 26.2), Hyprland aborts at startup with `Couldn't open a GBM device` /
  `CBackend::create() failed` and Ly drops straight back to the login screen.
  The crash report is in `~/.local/cache/hyprland/hyprlandCrashReport*.txt`.
- `/etc/nixos/configuration.nix` was the bare installer stub (no users, no
  SSH, no hostname). Any `nixos-rebuild` without `--flake`, including the old
  channel-based `system.autoUpgrade`, built that stub. Activating it deleted
  `mick`, dropped SSH and Tailscale, and left the machine unloginable
  (generation 33 on Altar, 2026-10-21). On Altar the stub is now renamed to
  `configuration.nix.installer-stub` so such a rebuild fails instead. Do the
  same on any new install.
- Never let root run Nix commands with `HOME=/home/mick`. That leaves
  root-owned files in `~/.local/cache/nix`, and `nix flake update` as mick then
  fails with "repository path … is not owned by current user". Fix it with
  `doas chown -R mick:users ~/.local/cache/nix`.
- `nixos-rebuild switch` over SSH can cut its own connection by restarting
  sshd/Tailscale mid-activation. Over SSH use `boot` and reboot, or run the
  switch inside `tmux`. Locally, `switch` is the normal command.
- On these hosts `sudo` is a wrapper around `doas`, so `sudo -i` and other
  sudo-only flags fail. Use `doas` directly.
- Mick's login shell is fish, including for non-interactive SSH commands. Wrap
  bash syntax (`$(...)`, `VAR=...`, `${PIPESTATUS}`) in `bash -c '…'` or
  `ssh host bash -s <<'EOF'`.
- Home Manager owns many files in `~/.config`; deleting stale unmanaged files
  may be needed if activation says a file is in the way.
- OpenSSH uses port 2764, not 22.
- Maxwell can refer to both a NixOS host config and a live Arch-based system.
  Confirm which one is being discussed before changing assumptions.
- Systemd-boot entry limiting is separate from Nix garbage collection.
- Android udev rules package was removed upstream; newer systemd uaccess rules
  supersede it, so do not re-add the removed package blindly.
- If Bubblewrap-based apps fail with `Unexpected capabilities but not setuid`,
  check that the Hyprland session is using the no-ambient-caps wrapper and that
  child processes no longer inherit `CAP_SYS_NICE`.

## Useful Maintenance Commands

Format Nix files:

```sh
nix fmt
```

Evaluate every host (cheap; catches removed options):

```sh
for h in altar maxwell wortox; do
  nix eval --raw .#nixosConfigurations.$h.config.system.build.toplevel.drvPath
done
```

Build a host without installing it:

```sh
nix build .#nixosConfigurations.altar.config.system.build.toplevel
```

Update inputs and apply the result (locally):

```sh
cd ~/Mickium
nix flake update                                 # as mick, never as root
doas nixos-rebuild switch --flake ~/Mickium#altar
```

Update Altar remotely over Tailscale (same thing; `boot` survives a dropped
connection):

```sh
ssh Altar
cd ~/Mickium
git pull --rebase
doas nixos-rebuild boot --flake ~/Mickium#altar
```

Roll back: pick an older generation in the systemd-boot menu, or make the
previous one the default again:

```sh
doas nixos-rebuild boot --rollback
```

### Recovering an Unbootable or Unloginable Machine

From a NixOS live USB (Altar layout: BTRFS on `nvme0n1p2` with subvolumes
`@`, `@nix`, `@home`, `@log`, `@persist`; ESP on `nvme0n1p1`):

```sh
D=/dev/nvme0n1p2
mount -o subvol=@ $D /mnt
mount -o subvol=@nix $D /mnt/nix
mount -o subvol=@home $D /mnt/home
mount -o subvol=@log $D /mnt/var/log
mount -o subvol=@persist $D /mnt/persist
mount /dev/nvme0n1p1 /mnt/boot

# Point the system profile at a known-good generation and rewrite the bootloader
nixos-enter --root /mnt -c "nix-env -p /nix/var/nix/profiles/system --set /nix/var/nix/profiles/system-NN-link \
  && NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot"

# Or build and install the flake directly onto the disk
TMPDIR=/mnt/var/tmp/nixbuild nixos-install --root /mnt \
  --flake /mnt/home/mick/Mickium#altar --no-root-passwd --no-channel-copy
```

The live USB keeps its Nix store in RAM. Long builds can OOM-kill `nix`, so run
`nix-collect-garbage` on the live system (never with `--store /mnt`) between
attempts. Keep `TMPDIR` on the disk. Run `nix flake update` as the live
`nixos` user (uid 1000, the repo owner), not root.

If `git pull --rebase` reports local hardware/config changes, inspect them
first. Host hardware config changes are often legitimate machine-local updates.

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
- Keep `DESCRIPTION.MD` present and current whenever functional config changes
  are made.
- If Mick asks to commit everything, include both assistant-made changes and
  existing user-made dirty changes after reviewing the diff.
- Prefer editing repo sources over generated Home Manager targets.
- For docs-only changes, commit only the docs file and avoid pulling in dirty
  config files.
- For Hyprland plugin build failures, suspect version drift first.
- `CLAUDE.md` holds the short agent-facing rules. Keep it consistent with this
  file.
- For Doom failures, inspect the activation copy/sync behavior before changing
  Doom modules.
- For SSH issues, remember both client and server are intended to use port 2764.
