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


  # the thing is you won't get xdg-portal-hyprland
  # refer: https://github.com/nix-community/home-manager/issues/1167
  # # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    extraConfig = ''
    source					= ~/.config/hypr/main.conf
    '';

    settings = {

    };
  };

  # naming it main.conf becuase HM writes hyprland.conf, so just as an import
  xdg.configFile."hypr/main.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/hyprland.conf";



}
