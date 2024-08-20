{pkgs, ...}: {
  home.packages = with pkgs; [
    # misc
    libnotify
    xdg-utils
    # pandoc
    mupdf
    keepassxc

  ];
}
