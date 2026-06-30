{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  hostName = osConfig.networking.hostName or "";
  monitorConfig =
    if hostName == "Altar"
    then ./hypr-config/monitors/Altar.conf
    else if hostName == "Maxwell"
    then ./hypr-config/monitors/Maxwell.conf
    else ./hypr-config/monitors/default.conf;
  confDir = pkgs.runCommand "hypr-conf-${hostName}" {} ''
    mkdir -p "$out"
    ln -s ${./hypr-config/conf/autostart.conf} "$out/autostart.conf"
    ln -s ${./hypr-config/conf/env.conf} "$out/env.conf"
    ln -s ${./hypr-config/conf/keybinds.conf} "$out/keybinds.conf"
    ln -s ${monitorConfig} "$out/monitors.conf"
    ln -s ${./hypr-config/conf/rules.conf} "$out/rules.conf"
  '';
in {
  xdg.configFile = {
    "hypr/main.conf".source = ./hypr-config/hyprland.conf;
    "hypr/Wallpaper.jpeg".source = ./hypr-config/Wallpaper.jpeg;
    "hypr/colors.conf".source = ./hypr-config/colors.conf;
    "hypr/conf".source = confDir;
    "hypr/hypridle.conf".source = ./hypr-config/hypridle.conf;
    "hypr/hyprlock.conf".source = ./hypr-config/hyprlock.conf;
    "hypr/pyprland.json".source = ./hypr-config/pyprland.json;
    "hypr/scripts".source = ./hypr-config/scripts;
  };

  home.packages = with pkgs; [
    ninja
    cmake
    cpio
    jaq
    grimblast
    hyprmon
    hyprmoncfg
    swaybg
    hyprwayland-scanner
    (writeShellScriptBin "vesktop" ''
      exec ${lib.getExe pkgs.equibop} "$@"
    '')
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    plugins = [
      pkgs.hyprlandPlugins.hyprsplit
    ];
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = ''
      source = ${config.xdg.configHome}/hypr/main.conf
    '';
  };

  # Home Manager owns hyprland.conf, so the real config is kept as main.conf and
  # imported above.
}
