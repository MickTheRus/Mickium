{pkgs, config, ...}:

{

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

  };

  # We will tangle config files from git repo to home dir (Let nix manage the magics)

  home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/style.css";
  home.file.".config/waybar/config".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/config";
}
