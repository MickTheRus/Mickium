#!/usr/bin/env bash
echo -ne "
-----------------------------------------------------
███╗░░░███╗██╗░█████╗░██╗░░██╗██╗██╗░░░██╗███╗░░░███╗
████╗░████║██║██╔══██╗██║░██╔╝██║██║░░░██║████╗░████║
██╔████╔██║██║██║░░╚═╝█████═╝░██║██║░░░██║██╔████╔██║
██║╚██╔╝██║██║██║░░██╗██╔═██╗░██║██║░░░██║██║╚██╔╝██║
██║░╚═╝░██║██║╚█████╔╝██║░╚██╗██║╚██████╔╝██║░╚═╝░██║
╚═╝░░░░░╚═╝╚═╝░╚════╝░╚═╝░░╚═╝╚═╝░╚═════╝░╚═╝░░░░░╚═╝
-----------------------------------------------------
            Automated Arch Linux Installer
                   SCRIPTHOME: Mickium
-----------------------------------------------------
Installing AUR Softwares"
source $HOME/Mickium/setup.conf

cd $HOME
git clone "https://aur.archlinux.org/paru.git"
cd $HOME/paru
makepkg -si --noconfirm
cd $HOME
mkdir -p $HOME/.config/rofi
ln -sf "$HOME/Mickium/misc/configs/{awesome,nvim,kitty}" "$HOME/.config/"
cp $HOME/.config/awesome/theme/config.rasi $HOME/.config/rofi/config.rasi
sed -i '/@theme/c\@theme "'$HOME'/.config/awesome/theme/sidebar.rasi"' ~/.config/rofi/config.rasi

mkdir $HOME/.ssh/
chmod 700 $HOME/.ssh
echo -ne "Host *
Host github.com
  PreferredAuthentications publickey
  HostName github.com
  User git
  IdentityFile ~/.ssh/github" >> $HOME/.ssh/config

echo -ne "
export ZDOTDIR=$HOME/Mickium/misc/configs/zsh
source '$ZDOTDIR'/.zshrc" > $HOME/.zshrc

echo -ne "
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Exec=/$HOME/Mickium/misc/macros/rofi-bluetooth
Name=Rofi Bluetooth
Icon=/usr/share/icons/candy-icons/apps/scalable/org.kde.plasma.bluetooth.svg" > $HOME/.local/share/applications/rofiBT.desktop

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
source $HOME/.zshrc

paru -S --noconfirm --needed - < ~/Mickium/pkg-files/aur-pkgs.txt
pip install black isort pynvim
npm install i -g neovim
echo -ne "
-------------------- --------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
----------------------------------------------------------------------"
exit
