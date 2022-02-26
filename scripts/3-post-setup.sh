#!/usr/bin/env bash
echo -ne "
--------------------------------------------------------------------
███╗░░░███╗██╗░█████╗░██╗░░██╗████████╗██╗████████╗██╗░░░██╗░██████╗
████╗░████║██║██╔══██╗██║░██╔╝╚══██╔══╝██║╚══██╔══╝██║░░░██║██╔════╝
██╔████╔██║██║██║░░╚═╝█████═╝░░░░██║░░░██║░░░██║░░░██║░░░██║╚█████╗░
██║╚██╔╝██║██║██║░░██╗██╔═██╗░░░░██║░░░██║░░░██║░░░██║░░░██║░╚═══██╗
██║░╚═╝░██║██║╚█████╔╝██║░╚██╗░░░██║░░░██║░░░██║░░░╚██████╔╝██████╔╝
╚═╝░░░░░╚═╝╚═╝░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░╚═╝░░░░╚═════╝░╚═════╝░
--------------------------------------------------------------------  
                    Automated Arch Linux Installer
                        SCRIPTHOME: Mickium
--------------------------------------------------------------------

Final Setup and Configurations
GRUB EFI Bootloader Install & Check
"
source /root/Mickium/setup.conf
genfstab -U / >> /etc/fstab
if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK}
fi
# set kernel parameter for decrypting the drive
if [[ "${FS}" == "luks" ]]; then
sed -i "s%GRUB_CMDLINE_LINUX_DEFAULT=\"%GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=${encryped_partition_uuid}:ROOT root=/dev/mapper/ROOT %g" /etc/default/grub
fi

echo -e "Installing Dracula Grub theme..."
THEME_DIR="/usr/share/grub/themes"
THEME_NAME=dracula
echo -e "Setting dracula theme as the default..."
grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
echo -e "Updating grub"
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "Setting qt5 theme"
echo "XDG_CURRENT_DESKTOP=Dracula" >> /etc/environment
echo -e "All set!"
echo -ne "
-------------------------------------------------------------------------
                    Enabling Login Display Manager
-------------------------------------------------------------------------
"
systemctl enable lightdm.service
echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"
systemctl enable cups.service
ntpd -qg
systemctl enable ntpd.service
systemctl disable dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth
echo -ne "
-------------------------------------------------------------------------
                    Cleaning 
-------------------------------------------------------------------------
"
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

rm -r /root/Mickium
rm ~/Mickium/setup.conf
# I rely in this folder so no
# rm -r /home/$USERNAME/Mickium

# Replace in the same state
cd $pwd
