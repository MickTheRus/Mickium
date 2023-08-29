{pkgs, ...}:
# Qt theming with Kvantum
{
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    (catppuccin-kvantum.override {
      accent = "Lavender";
      variant = "Mocha";
    })
  ];
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
    General.Theme = "Catppuccin-Mocha-Lavender";
  };
}
