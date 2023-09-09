{
  lib,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    jaq
    sway-contrib.grimshot
    swayidle
  ];

  # the thing is you won't get xdg-portal-hyprland
  # refer: https://github.com/nix-community/home-manager/issues/1167
  # # enable hyprland
  # wayland.windowManager.hyprland = {
  #   enable = true;
  # };

  xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/hyprland.conf";
}
