{
  pkgs,
  config,
  ...
}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  # We will tangle config files from git repo to home dir (Let nix manage the magics)

  home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/waybar";
}
