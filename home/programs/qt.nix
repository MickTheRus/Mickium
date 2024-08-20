{pkgs, ...}:
# Qt theming with Kvantum
{

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style.name = "gtk2";
  };

  services.kdeconnect.enable = true;

}
