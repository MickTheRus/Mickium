{pkgs, ...}: {
  home.packages = with pkgs; [
    # misc
    xfce.thunar
    xfce.thunar-volman
    libnotify
    xdg-utils
    # pandoc
    mupdf
    keepassxc

  ];
}
