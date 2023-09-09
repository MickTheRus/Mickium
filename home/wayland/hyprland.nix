{
  config,
  ...
}: {

  wayland.windowManager.hyprland = {
    enable = true;
  };

  xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/wayland/hyprland.conf";
}
