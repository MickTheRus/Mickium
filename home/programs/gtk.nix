{
  pkgs,
  config,
  ...
}: let
  gtkThemeName = "catppuccin-mocha-maroon-standard";
  gtkTheme = pkgs.catppuccin-gtk.override {
    accents = ["maroon"];
    size = "standard";
    variant = "mocha";
  };
  iconThemeName = "candy-icons";
  cursorThemeName = "Adwaita";
in {
  # cursor theme
  home.pointerCursor = {
    name = cursorThemeName;
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  home.sessionVariables.GTK_THEME = gtkThemeName;

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-theme = cursorThemeName;
    font-name = "Iosevka Nerd Font 11";
    gtk-theme = gtkThemeName;
    icon-theme = iconThemeName;
  };

  gtk = {
    enable = true;
    theme = {
      name = gtkThemeName;
      package = gtkTheme;
    };

    gtk4.theme = config.gtk.theme;

    iconTheme = {
      name = iconThemeName;
      package = pkgs.candy-icons;
    };

    font = {
      name = "Iosevka Nerd Font";
      size = 11;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
  };
}
