{
  pkgs,
  config,
  ...
}: {

  # cursor theme
  home.pointerCursor = {
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    size = 12;
    gtk.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Mocha-Standard-Lavender-dark";
      package = pkgs.catppuccin-gtk.override { variant="mocha"; accents=["lavender"]; };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    font = {
      name = "Iosevka Nerd Font";
      size = 12;
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
