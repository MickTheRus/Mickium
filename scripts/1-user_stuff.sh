#!/usr/bin/env bash
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

sudo usermod -a -G tty,polkitd,rpc,mail,lp,audio "$USER"

mkdir -p "$HOME"/.local/{bin,share,mpd,cargo}
ln -sf "$HOME"/Mickium/dot.config/* ~/.config/

zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
chsh -s /usr/bin/zsh


sudo zypper rm -rf icewm xterm
