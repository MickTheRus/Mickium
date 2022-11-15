#!/bin/bash
while IFS= read -r line; do
    echo "Installing $line"
    sudo zypper in --no-recommends --no-confirm --auto-agree-with-licenses $line
done <"$HOME/Mickium/pkg-files/basic_stuff.txt"

os=$(grep -E "^NAME=" /usr/lib/os-release <<<cat)

case $os in
    *Tumbleweed*)
        sudo zypper ar -g -r https://pkgs.tailscale.com/stable/opensuse/tumbleweed/tailscale.repo
        ;;
    *Leap*)
        sudo zypper ar -g -r https://pkgs.tailscale.com/stable/opensuse/leap/$releasever/tailscale.repo
        ;;
esac

sudo groupadd libvirt
sudo groupadd lightdb
sudo usermod -a -G tty,polkitd,rpc,mail,lp,audio $USER

opi dotnet
opi lazygit
opi procps-ng
opi brave

mkdir $HOME/.config
mkdir $HOME/.local/{bin,share}
rm -rf $HOME/.config/{bspwm,fish,gtk-2.0,gtk-3.0,mpd,ncmpcpp,neofetch,nvim,qt5ct,starship}
ln -sf $HOME/Mickium/dot.config/* ~/.config/
sudo cp -r $HOME/Mickium/misc/Iosevka /usr/share/fonts/

sudo zypper in tailscale
sudo systemctl enable --now tailscaled
sudo cp -r $HOME/Mickium/misc/themes/* /usr/share/themes/
sudo cp -r $HOME/Mickium/misc/icons/* /usr/share/icons/
chsh -s /usr/bin/fish
mkdir -p ~/.local/share/{mpd,cargo}
sudo zypper rm -rf icewm xterm
cargo instal fnm
