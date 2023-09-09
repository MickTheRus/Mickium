{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    rofi-wayland
  ];

  # We will tangle config files from git repo to home dir (Let nix manage the magics)

  home.file.".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/rofi";
}
