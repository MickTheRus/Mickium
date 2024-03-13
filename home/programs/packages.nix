{pkgs, ...}: {
  home.packages = with pkgs; [
    # misc
    libnotify
    # xdg-utils

    pcmanfm
    libreoffice
    # pandoc
    groff mupdf
    keepassxc

  ];
}
