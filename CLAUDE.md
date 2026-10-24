# CLAUDE.md

Guidance for AI agents working in Mickium, Mick's standalone NixOS flake. It
builds three hosts plus the Home Manager environment for user `mick`.

- `README.MD`: the human-facing overview.
- `DESCRIPTION.MD`: the detailed handoff map. It covers every module, why the
  odd bits are odd, and the recovery procedures. Read the relevant section
  before changing an area.
- `docs/MAINTENANCE.md`: the standalone-repo rules and the pre-push
  checklist.

## Layout

```text
flake.nix          inputs, dev shell, formatter, nixosConfigurations
hosts/default.nix  host wiring (maxwell, altar, wortox) + per-host extras
hosts/<Host>/      hardware-configuration.nix per machine
modules/           shared NixOS modules (nix.nix holds the overlay + autoUpgrade)
home/              Home Manager for mick (wayland/, programs/, shell/, security/)
```

Hyprland config is native hyprlang in `home/wayland/hypr-config/`, installed
by Home Manager. Edit the repo copy, never `~/.config/hypr`.

## Hosts and Naming

| Output | hostName | Machine |
| --- | --- | --- |
| `altar` | `Altar` | HP Envy x360 laptop, AMD Barcelo iGPU. The actively used NixOS box. |
| `maxwell` | `Maxwell` | Desktop. The live Maxwell may be running Arch, so confirm first. |
| `wortox` | `Wortox` | Portable drive beside Ventoy. Must not touch EFI vars. |

Outputs are lowercase and hostnames are capitalised, so always pass `#altar`
explicitly.

## Commands

```sh
# Evaluate all hosts. Do this after any shared-module change.
for h in altar maxwell wortox; do nix eval --raw .#nixosConfigurations.$h.config.system.build.toplevel.drvPath; echo; done

# Update inputs. Run as mick, never as root.
nix flake update

# Apply changes when working locally on the machine.
doas nixos-rebuild switch --flake ~/Mickium#altar

# Over SSH, stage for next boot instead (see rule 2).
doas nixos-rebuild boot --flake ~/Mickium#altar

# Validate Hyprland config with the built Hyprland. Ignore "Invalid dispatcher split-…".
Hyprland --verify-config -c ~/.config/hypr/hyprland.conf

nix fmt                          # alejandra
nix develop -c statix check .
nix develop -c deadnix .
```

## Hard Rules

These all come from real breakage. See "Known Sharp Edges" in
`DESCRIPTION.MD`.

1. **Always use `--flake ~/Mickium#<host>`.** Plain `nixos-rebuild` builds
   `/etc/nixos/configuration.nix`, which is only the installer stub.
   Activating it deletes user `mick` and drops SSH and Tailscale.
2. **Use `switch` locally, `boot` over SSH.** On the machine itself, suggest
   `nixos-rebuild switch`. Over SSH, suggest `boot`: a switch can restart sshd
   or Tailscale and cut its own connection mid-activation. If you must switch
   remotely, do it inside `tmux`.
3. **Never run Nix as root with mick's `HOME`.** It leaves root-owned files in
   `~/.local/cache/nix` and breaks `nix flake update` for mick.
4. **Hyprland must come from main nixpkgs.** A separate Hyprland pin brings an
   older `libgbm` than the system Mesa driver, and Hyprland aborts with "Couldn't
   open a GBM device", which drops back to Ly.
5. **Keep the plugin pinned to the right Hyprland.** split-monitor-workspaces
   (`modules/nix.nix` overlay) must use the plugin commit that its
   `hyprpm.toml` lists for the nixpkgs Hyprland version (the second hash of
   the pair). Bump it whenever Hyprland moves.
6. **Ask before activating anything on a machine.** Building and evaluating
   is fine. Switching, booting a new default, or rebooting is Mick's call.
7. **Keep the docs current.** Any functional change updates `DESCRIPTION.MD`
   in the same commit, and this file too if it changes a rule or command.

## Environment Quirks

- `sudo` is a wrapper around `doas`. `sudo -i` and other sudo-only flags fail,
  so use `doas -n`.
- Mick's login shell is fish, even for non-interactive `ssh Altar '…'`. Use
  `ssh Altar bash -s <<'EOF' … EOF` for bash syntax.
- SSH listens on port 2764, not 22. Hosts are reachable over Tailscale
  (`ssh Altar`).
- `users.mutableUsers = true` with `initialPassword` in `modules/core.nix`.
  If `mick` ever gets recreated, the password resets to the initial one.
- `system.autoUpgrade` rebuilds daily from the local checkout with
  `operation = "boot"` and the committed `flake.lock`. It does not update
  inputs.

## Working Style

- Run `git status --short` first. Mick often has uncommitted work, so don't
  revert unrelated changes.
- When nixpkgs removes or renames an option or package, migrate to the
  replacement the error message names, and note it in `DESCRIPTION.MD`.
- When a package fails to build upstream and there's no easy fix, comment it
  out with a dated note saying why. Don't delete it.
- Commit messages are short and imperative ("Update flake inputs", "Fix X").
- No AI attribution in commits or PRs: no `Co-Authored-By` trailer and no
  "Generated with Claude Code" line.
