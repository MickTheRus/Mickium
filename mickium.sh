#bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo dnf install zypper
echo "Adding External Repos"
sudo zypper ar https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo zypper ar https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo zypper ar https://copr.fedorainfracloud.org/coprs/agriffis/neovim-nightly/repo/fedora-36/agriffis-neovim-nightly-fedora-36.repo 
sudo zypper ar https://gist.githubusercontent.com/MickTheRus/5ddc553c2e4917fb3d5dec8e53d30066/raw/22551dd7906fb9708a6e32ca933137c38a40252c/google-chrome.repo
sudo zypper ar https://gist.githubusercontent.com/MickTheRus/0b198cef5461a63c160d2939f3a2dfc3/raw/a82469a6da050071bc83d1a9962c51b6cd17df2a/fedora-cisco-openh264.repo 

sudo zypper ar /etc/yum.repos.d/fedora.repo
sudo zypper ar /etc/yum.repos.d/fedora-updates.repo

sudo zypper refresh -f

ln -sf $SCRIPT_DIR/misc/configs/* ~/.config/

echo -ne "#!/bin/bash \n export _JAVA_AWT_WM_NONREPARENTING=1" >>



# [net]
# git-fetch-with-cli = true



