{
  lib,
  pkgs,
  config,
  ...
}: {

  home.packages = with pkgs; [
    jaq
    grimblast
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
  };

  # naming it main.conf becuase HM writes hyprland.conf, so just as an import
  xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/hyprland";



}
