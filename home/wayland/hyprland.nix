{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ninja
    cmake
    cpio
    jaq
    grimblast
    swaybg
    hyprwayland-scanner
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
     #  inputs.hyprland-plugins.packages.${pkgs.system}.hyprland-plugins
    ];
  };
  #wayland.windowManager.hyprland.plugins = [ inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces];
  wayland.windowManager.hyprland.extraConfig = ''${builtins.readFile ./hypr/hyprland.conf}'';

  # naming it main.conf becuase HM writes hyprland.conf, so just as an import
  # xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/hypr/hyprland.conf";
}
