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
in {
  xdg.configFile = {
    "hypr/main.conf".source = ./hypr-config/hyprland.conf;
    "hypr/colors.conf".source = ./hypr-config/colors.conf;
    "hypr/conf/autostart.conf".source = ./hypr-config/conf/autostart.conf;
    "hypr/conf/env.conf".source = ./hypr-config/conf/env.conf;
    "hypr/conf/keybinds.conf" = { source = ./hypr-config/conf/keybinds.conf; force = true; };
    "hypr/conf/monitors.conf".source = monitorConfig;
    "hypr/conf/rules.conf".source = ./hypr-config/conf/rules.conf;
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
