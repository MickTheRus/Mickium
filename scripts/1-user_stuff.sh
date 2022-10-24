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

sudo systemctl enable display-manager
sudo systemctl enable docker

sudo groupadd docker
sudo groupadd libvirt
sudo groupadd lightdb
sudo usermod -a -G docker,tty,polkitd,rpc,mail,lp,audio $USER

opi dotnet
opi lazygit
opi procps-ng
opi brave

mkdir $HOME/.config
mkdir $HOME/.local/bin
mkdir $HOME/.local/share
rm -rf $HOME/.config/{bspwm,fish,gtk-2.0,gtk-3.0,mpd,ncmpcpp,neofetch,nvim,qt5ct,starship}
ln -sf $HOME/Mickium/misc/configs/* ~/.config/
sudo cp -r $HOME/Mickium/misc/Iosevka /usr/share/fonts/
sudo fc-cache -fv

sudo zypper ref
sudo zypper in tailscale
sudo systemctl enable --now tailscaled
sudo cp -r $HOME/Mickium/misc/Dracula-theme /usr/share/themes/Dracula
sudo cp -r $HOME/Mickium/misc/Dracula-icons /usr/share/icons/Dracula
chsh -s /usr/bin/fish
mkdir -p ~/.local/share/mpd
sudo zypper rm -rf icewm
cargo instal nu ripgrep bat fnm
