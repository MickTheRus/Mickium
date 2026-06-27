{
  pkgs,
  config,
  ...
}: {
  # cursor theme
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-maroon-standard+default";
      package = pkgs.catppuccin-gtk;
    };

    gtk4.theme = config.gtk.theme;

    iconTheme = {
      name = "candy-icons";
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
