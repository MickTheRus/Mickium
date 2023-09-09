{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    kitty
  ];

  home.file.".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/programs/kitty.conf";
}
