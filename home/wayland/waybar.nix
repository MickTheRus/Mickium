_: {
  programs.waybar.enable = true;

  # Waybar loads config.jsonc and style.css from this directory. Keeping these
  # files as native Waybar config preserves JSONC comments and avoids a long
  # Nix attrset for layout-heavy UI config.
  xdg.configFile."waybar".source = ./waybar;
}
