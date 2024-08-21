{pkgs, ...}:
# Qt theming with Kvantum
{

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "gtk3";
  };

  services.kdeconnect.enable = true;

}
