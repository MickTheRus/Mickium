{pkgs, ...}:
# Qt theming with Kvantum
{
  home.packages = with pkgs; [
    libsForQt5.qt5ct
    qt6Packages.qt6ct
  ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "fusion";
  };

  xdg.configFile = {
    "electron-flags.conf".source = ./qt-config/electron-flags.conf;
    "qt5ct".source = ./qt-config/qt5ct;
    "qt6ct".source = ./qt-config/qt6ct;
  };

  services.kdeconnect.enable = true;
}
