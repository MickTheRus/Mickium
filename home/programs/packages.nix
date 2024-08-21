{pkgs, ...}: {
  home.packages = with pkgs; [
    # misc
    kitty
    xfce.thunar
    xfce.thunar-volman
    libnotify
    xdg-utils
    # pandoc
    mupdf
    keepassxc

  ];
}
