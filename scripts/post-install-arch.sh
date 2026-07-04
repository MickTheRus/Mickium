#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
config_src="$repo_root/dot.config"
env_script_src="$repo_root/misc/99-set-env-vars.sh"
pacman_packages=(
  base-devel
  git
  rust
  fish
  emacs
  hyprland
  hypridle
  hyprlock
  hyprpicker
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
  playerctl
  mpd
  mpc
  yazi
  lazygit
  qt5ct
  qt6ct
  xdg-desktop-portal-hyprland
  polkit-kde-agent
)
aur_packages=(
  brave-bin
  awww-git
  hyprshot
  pyprland
  wlogout
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

install_paru_git() {
  sudo pacman -S --needed --noconfirm base-devel git

  if pacman -Q paru-git >/dev/null 2>&1; then
    echo "paru-git is already installed."
    return
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
  sudo pacman -S --needed --noconfirm "${pacman_packages[@]}"
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
install_env_profile_script
setup_env_paths
install_paru_git
install_config_packages
install_fnm_via_cargo
set_fish_as_default_shell
enable_paru_bottom_up
link_dot_config

echo "post-install setup complete for $target_user."
