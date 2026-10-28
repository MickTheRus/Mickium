{pkgs, ...}: let
  # The weather module runs this. It needs Python with `requests`, GeoClue's
  # demo `where-am-i` tool for the location, and `nmcli` to notice a change of
  # Wi-Fi network.
  weather = pkgs.writeShellApplication {
    name = "waybar-weather";
    runtimeInputs = [
      (pkgs.python3.withPackages (ps: [ps.requests]))
      pkgs.networkmanager
    ];
    text = ''
      export WHERE_AM_I=${pkgs.geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/where-am-i
      exec python3 "$HOME/.config/waybar/Scripts/weather/script.py" "$@"
    '';
  };
in {
  # Waybar is configured by the BlackNode-based files in ./waybar-config
  # (github.com/zhaleff/BlackNode, MIT). They are installed file by file into
  # ~/.config/waybar, so Waybar reads config.jsonc, style.css and the includes
  # from there. Restart Waybar after changing them (Super+Shift+R).
  programs.waybar.enable = true;
  xdg.configFile."waybar" = {
    source = ./waybar-config;
    recursive = true;
  };

  # Makes MPD show up as a normal media player (MPRIS) for the media block and
  # its play/pause/next buttons.
  services.mpd-mpris.enable = true;

  home.packages =
    [weather]
    ++ (with pkgs; [
      jq # scripts build their JSON with it
      psmisc # fuser, used by the camera indicator
      wlogout # the power menu (~/.config/hypr/scripts/power-menu.sh)
    ]);
}
