{ config, pkgs, lib, ... }:
let
  font = "Iosevka Nerd Font";
  fontsize = "12";

in 
{
  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    font.name = "${font} ${fontsize}";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Lavander-dark";
      package = pkgs.catppuccin-gtk.override { variant="mocha"; };
    };
    gtk3.extraconfig = {
      Settings = ''
      gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraconfig = {
      Settings = ''
      gtk-application-prefer-dark-theme=1
      '';
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "gtk2";
  };
  programs = {
    git = {
        enable = true;
        userName = "MickTheRus";
        userEmail = "nikolai.romanchenko@outlook.com";
    };
  };
  
   home.file.".config" = {
    source = "$HOME/Mickium/dot.config/.";
    target = "$HOME/.config/";
    symlink = true;
  };

}
