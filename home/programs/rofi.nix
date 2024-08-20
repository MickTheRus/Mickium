{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    rofi-wayland
  ];
  xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/programs/the-rofi";
}
