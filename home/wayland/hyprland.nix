{
  lib,
  pkgs,
  config,
  ...
}: {
  xdg.configFile = {
    "hypr/main.conf".source = ./hypr-config/hyprland.conf;
    "hypr/colors.conf".source = ./hypr-config/colors.conf;
    "hypr/conf".source = ./hypr-config/conf;
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
    swaybg
    hyprwayland-scanner
    (writeShellScriptBin "vesktop" ''
      exec ${lib.getExe pkgs.equibop} "$@"
    '')
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = ''
      source = ${config.xdg.configHome}/hypr/main.conf
    '';
  };

  # Home Manager owns hyprland.conf, so the real config is kept as main.conf and
  # imported above.
}
