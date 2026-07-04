#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
config_src="$repo_root/dot.config"
env_script_src="$repo_root/misc/99-set-env-vars.sh"
pacman_packages=(
  base-devel
  git
  nix
  direnv
  age
  sops
  rust
  fish
  emacs-wayland
  hyprland
  hypridle
  hyprlock
  hyprpicker
  hyprshot
  hyprcursor
  kitty
  waybar
  rofi
  swaync
  wl-clipboard
  cliphist
  imagemagick
  ydotool
  dolphin
  pavucontrol
  pipewire
  pipewire-pulse
  wireplumber
  podman
  podman-docker
  podman-compose
  tailscale
  steam
  steam-devices
  playerctl
  mpd
  mpc
  prismlauncher
  qbittorrent
  kdeconnect
  lutris
  openrgb
  yazi
  lazygit
  jre-openjdk
  thunar
  rpi-imager
  qpwgraph
  picard
  libreoffice-fresh
  btop
  inkscape
  krita
  qt5ct
  qt6ct
  xdg-desktop-portal-hyprland
  polkit-kde-agent
)
aur_packages=(
  brave-bin
  awww-git
  pyprland
  wlogout
  equibop-bin
  meshtastic-python
  meshcore-cli-git
  bolt-launcher
  irony-mod-manager-bin
  rider
  claude-desktop-bin
  codex-desktop-linux
  yubico-authenticator
  ympd
  vintagestory
  vs-launcher
  ventoy-bin
  telegram-desktop-bin
  ktailctl
  joplin-desktop
)
nix_profile_packages=(
  nixpkgs#home-manager
  nixpkgs#nh
  nixpkgs#alejandra
  nixpkgs#deadnix
  nixpkgs#statix
  nixpkgs#nil
  nixpkgs#nixfmt-rfc-style
  nixpkgs#nix-output-monitor
  nixpkgs#nix-tree
)

if (( EUID == 0 )); then
  echo "error: run this as the target user, not through sudo or as root." >&2
  exit 1
fi

target_user=${USER:?}
target_home=$(getent passwd "$target_user" | cut -d: -f6)
target_group=$(id -gn "$target_user")

if [[ $target_user == root ]]; then
  echo "error: run this as the user who should own the dotfiles, not as root." >&2
  exit 1
fi

if [[ -z $target_home || ! -d $target_home ]]; then
  echo "error: could not find home directory for user $target_user." >&2
  exit 1
fi

xdg_data_home="$target_home/.local/share"
xdg_config_home="$target_home/.config"
xdg_state_home="$target_home/.local/state"
xdg_cache_home="$target_home/.cache"
cargo_home="$xdg_data_home/cargo"
gnupg_home="$xdg_data_home/gnupg"
inputrc_path="$xdg_config_home/readline/inputrc"
cargo_bin="$cargo_home/bin"
music_dir="$target_home/Music"
mpd_config_dir="$xdg_config_home/mpd"
mpd_data_dir="$xdg_data_home/mpd"
mpd_state_dir="$xdg_state_home/mpd"
mpd_cache_dir="$xdg_cache_home/mpd"

install_paru_git() {
  sudo pacman -S --needed --noconfirm base-devel git

  if pacman -Q paru-git >/dev/null 2>&1; then
    echo "paru-git is already installed."
    return
  fi

  local old_paru_packages=()
  for package in paru paru-debug; do
    if pacman -Q "$package" >/dev/null 2>&1; then
      old_paru_packages+=("$package")
    fi
  done

  if ((${#old_paru_packages[@]})); then
    sudo pacman -R --noconfirm "${old_paru_packages[@]}"
  fi

  local build_dir
  build_dir=$(mktemp -d)

  git clone https://aur.archlinux.org/paru-git.git "$build_dir/paru-git"
  if ! (
    cd "$build_dir/paru-git"
    makepkg -si --needed --noconfirm
  ); then
    rm -rf "$build_dir"
    return 1
  fi

  rm -rf "$build_dir"
}

install_config_packages() {
  sudo pacman -Syu --needed --noconfirm "${pacman_packages[@]}"
  paru -S --needed --noconfirm "${aur_packages[@]}"
}

install_env_profile_script() {
  sudo install -o root -g root -m 0644 "$env_script_src" /etc/profile.d/99-set-env-vars.sh
}

setup_env_paths() {
  sudo install -d -o "$target_user" -g "$target_group" -m 0700 "$xdg_data_home"
  sudo install -d -o "$target_user" -g "$target_group" -m 0700 "$xdg_config_home"
  sudo install -d -o "$target_user" -g "$target_group" -m 0700 "$xdg_state_home"
  sudo install -d -o "$target_user" -g "$target_group" -m 0700 "$xdg_cache_home"
  sudo install -d -o "$target_user" -g "$target_group" -m 0700 "$cargo_home"
  sudo install -d -o "$target_user" -g "$target_group" -m 0755 "$cargo_bin"
  sudo install -d -o "$target_user" -g "$target_group" -m 0700 "$gnupg_home"
  sudo install -d -o "$target_user" -g "$target_group" -m 0755 "$(dirname "$inputrc_path")"

  sudo chown -R "$target_user:$target_group" "$gnupg_home"
  sudo chmod 0700 "$gnupg_home"
}

install_fnm_via_cargo() {
  command -v rustc >/dev/null
  command -v cargo >/dev/null

  if [[ -x $cargo_bin/fnm ]]; then
    echo "fnm is already installed at $cargo_bin/fnm."
    return
  fi

  sudo -u "$target_user" env \
    CARGO_HOME="$cargo_home" \
    XDG_DATA_HOME="$xdg_data_home" \
    XDG_CONFIG_HOME="$xdg_config_home" \
    XDG_STATE_HOME="$xdg_state_home" \
    XDG_CACHE_HOME="$xdg_cache_home" \
    PATH="$cargo_bin:$PATH" \
    cargo install fnm --locked
}

set_fish_as_default_shell() {
  local fish_path
  fish_path=$(command -v fish)

  if ! grep -Fxq "$fish_path" /etc/shells; then
    printf '%s\n' "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ $(getent passwd "$target_user" | cut -d: -f7) != "$fish_path" ]]; then
    sudo chsh -s "$fish_path" "$target_user"
  fi
}

enable_passwordless_sudo() {
  local sudoers_file="/etc/sudoers.d/99-${target_user}-nopasswd"
  local temp_file
  temp_file=$(mktemp)

  printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$target_user" > "$temp_file"
  sudo visudo -cf "$temp_file" >/dev/null
  sudo install -o root -g root -m 0440 "$temp_file" "$sudoers_file"
  rm -f "$temp_file"
}

enable_multilib() {
  local pacman_conf=/etc/pacman.conf

  if ! grep -Eq '^\[multilib\]' "$pacman_conf"; then
    sudo sed -i '/^#\[multilib\]/{s/^#//;n;s/^#//;}' "$pacman_conf"
  fi

  sudo pacman -Sy --noconfirm
}

enable_paru_bottom_up() {
  local paru_conf=/etc/paru.conf

  if [[ ! -f $paru_conf ]]; then
    sudo install -o root -g root -m 0644 /dev/null "$paru_conf"
  fi

  if grep -Eq '^[[:space:]#]*BottomUp[[:space:]]*$' "$paru_conf"; then
    sudo sed -i -E 's/^[[:space:]#]*BottomUp[[:space:]]*$/BottomUp/' "$paru_conf"
  elif grep -Eq '^\[options\]' "$paru_conf"; then
    sudo sed -i '/^\[options\]/a BottomUp' "$paru_conf"
  else
    printf '\n[options]\nBottomUp\n' | sudo tee -a "$paru_conf" >/dev/null
  fi
}

configure_nix_admin_tooling() {
  local nix_conf=/etc/nix/nix.conf

  sudo install -d -o root -g root -m 0755 /etc/nix
  if [[ ! -f $nix_conf ]]; then
    sudo install -o root -g root -m 0644 /dev/null "$nix_conf"
  fi

  if grep -Eq '^[[:space:]]*experimental-features[[:space:]]*=' "$nix_conf"; then
    sudo sed -i -E 's/^[[:space:]]*experimental-features[[:space:]]*=.*/experimental-features = nix-command flakes/' "$nix_conf"
  else
    printf '\nexperimental-features = nix-command flakes\n' | sudo tee -a "$nix_conf" >/dev/null
  fi

  if grep -Eq '^[[:space:]]*trusted-users[[:space:]]*=' "$nix_conf"; then
    sudo sed -i -E "s/^[[:space:]]*trusted-users[[:space:]]*=.*/trusted-users = root $target_user @wheel/" "$nix_conf"
  else
    printf 'trusted-users = root %s @wheel\n' "$target_user" | sudo tee -a "$nix_conf" >/dev/null
  fi

  sudo systemctl enable --now nix-daemon.service

  sudo -u "$target_user" env \
    HOME="$target_home" \
    NIX_CONFIG='experimental-features = nix-command flakes' \
    nix profile install --accept-flake-config "${nix_profile_packages[@]}"
}

configure_podman() {
  sudo install -d -o root -g root -m 0755 /etc/containers/registries.conf.d
  sudo tee /etc/containers/registries.conf.d/10-mickium.conf >/dev/null <<'EOF'
unqualified-search-registries = ["docker.io"]
EOF

  sudo install -d -o root -g root -m 0755 /etc/containers/containers.conf.d
  sudo tee /etc/containers/containers.conf.d/10-mickium-compose.conf >/dev/null <<'EOF'
[engine]
compose_warning_logs = false
compose_providers = ["/usr/bin/podman-compose"]
EOF

  sudo systemctl enable --now podman.socket
  systemctl --user enable --now podman.socket || true
}

enable_tailscale() {
  sudo systemctl enable --now tailscaled
}

configure_mpd_and_ympd() {
  sudo loginctl enable-linger "$target_user" || true

  sudo -u "$target_user" mkdir -p \
    "$music_dir" \
    "$mpd_config_dir" \
    "$mpd_data_dir/playlists" \
    "$mpd_state_dir" \
    "$mpd_cache_dir" \
    "$xdg_config_home/systemd/user"

  sudo -u "$target_user" tee "$mpd_config_dir/mpd.conf" >/dev/null <<EOF
music_directory     "$music_dir"
playlist_directory  "$mpd_data_dir/playlists"
db_file             "$mpd_data_dir/database"
log_file            "$mpd_state_dir/log"
pid_file            "$mpd_state_dir/pid"
state_file          "$mpd_state_dir/state"
sticker_file        "$mpd_data_dir/sticker.sql"

bind_to_address     "127.0.0.1"
port                "6600"
auto_update         "yes"

audio_output {
    type            "pipewire"
    name            "PipeWire"
}
EOF

  sudo -u "$target_user" tee "$xdg_config_home/systemd/user/ympd.service" >/dev/null <<'EOF'
[Unit]
Description=ympd MPD web client
After=mpd.service
Wants=mpd.service

[Service]
ExecStart=/usr/bin/ympd --host 127.0.0.1 --port 6600 --webport 8080
Restart=on-failure

[Install]
WantedBy=default.target
EOF

  systemctl --user daemon-reload
  systemctl --user enable --now mpd.service
  systemctl --user enable --now ympd.service
}

link_dot_config() {
  local config_home="$target_home/.config"
  sudo -u "$target_user" mkdir -p "$config_home"

  while IFS= read -r -d '' source_path; do
    local name target_path
    name=$(basename "$source_path")
    target_path="$config_home/$name"

    if [[ -e $target_path || -L $target_path ]]; then
      sudo rm -rf -- "$target_path"
    fi

    sudo -u "$target_user" ln -s "$source_path" "$target_path"
    echo "linked $target_path -> $source_path"
  done < <(find "$config_src" -mindepth 1 -maxdepth 1 -print0 | sort -z)
}

enable_passwordless_sudo
enable_multilib
install_env_profile_script
setup_env_paths
install_paru_git
install_config_packages
configure_nix_admin_tooling
install_fnm_via_cargo
set_fish_as_default_shell
enable_paru_bottom_up
configure_podman
enable_tailscale
link_dot_config
configure_mpd_and_ympd

echo "post-install setup complete for $target_user."
