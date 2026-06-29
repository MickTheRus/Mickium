{pkgs, ...}:
# Qt theming with qt5ct/qt6ct.
{
  home.packages = with pkgs; [
    libsForQt5.qt5ct
    qt6Packages.qt6ct
  ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "fusion";
  };

  xdg.configFile = {
    "electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform-hint=auto
      --ozone-platform=wayland
    '';

    "qt5ct/colors/catppuccin-mocha-maroon.conf".text = ''
      [ColorScheme]
      active_colors=  #ffcdd6f4,     #ff45475a, #ff585b70, #ff313244, #ff11111b, #ff181825, #ffcdd6f4,     #ffcdd6f4,  #ffcdd6f4,     #ff1e1e2e, #ff181825, #ff11111b, #ffeba0ac, #ff11111b,    #ff89b4fa,     #ffb4befe,   #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086
      inactive_colors=#ff7f849c, #ff1e1e2e,     #ff45475a, #ff313244, #ff11111b, #ff181825, #ff7f849c, #ffcdd6f4,  #ff7f849c, #ff1e1e2e, #ff181825, #ff11111b, #ff313244,              #ff7f849c, #ff7f849c, #ff7f849c,   #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086
      disabled_colors=#ff6c7086, #ff313244, #ff45475a, #ff313244, #ff11111b, #ff181825, #ff6c7086, #ffcdd6f4,  #ff6c7086, #ff1e1e2e, #ff181825, #ff11111b, #ff181825,                #ff6c7086, #ffa9bcdb,   #ffc7cceb, #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086
    '';

    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      color_scheme_path=/home/mick/.config/qt5ct/colors/catppuccin-mocha-maroon.conf
      custom_palette=true
      standard_dialogs=xdgdesktopportal
      style=Fusion

      [Fonts]
      fixed="Iosevka Nerd Font Mono,12,-1,5,50,0,0,0,0,0,Regular"
      general="Iosevka Nerd Font,12,-1,5,50,0,0,0,0,0,Regular"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\a\x80\0\0\0\0\0\0\v.\0\0\x4\x6\0\0\0\0\0\0\0\0\0\0\x3\xae\0\0\x4\x6\0\0\0\0\x2\0\0\0\a\x80\0\0\a\x80\0\0\0\0\0\0\v.\0\0\x4\x6)

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';

    "qt6ct/colors/catppuccin-mocha-maroon.conf".text = ''
      [ColorScheme]
      active_colors=  #ffcdd6f4,     #ff45475a, #ff585b70, #ff313244, #ff11111b, #ff181825, #ffcdd6f4,     #ffcdd6f4,  #ffcdd6f4,     #ff1e1e2e, #ff181825, #ff11111b, #ffeba0ac, #ff11111b,    #ff89b4fa,     #ffb4befe,   #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086
      inactive_colors=#ff7f849c, #ff1e1e2e,     #ff45475a, #ff313244, #ff11111b, #ff181825, #ff7f849c, #ffcdd6f4,  #ff7f849c, #ff1e1e2e, #ff181825, #ff11111b, #ff313244,              #ff7f849c, #ff7f849c, #ff7f849c,   #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086
      disabled_colors=#ff6c7086, #ff313244, #ff45475a, #ff313244, #ff11111b, #ff181825, #ff6c7086, #ffcdd6f4,  #ff6c7086, #ff1e1e2e, #ff181825, #ff11111b, #ff181825,                #ff6c7086, #ffa9bcdb,   #ffc7cceb, #ff181825, #ffffffff, #ff1e1e2e, #ffcdd6f4, #806c7086
    '';

    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      color_scheme_path=/home/mick/.config/qt6ct/colors/catppuccin-mocha-maroon.conf
      custom_palette=true
      standard_dialogs=default
      style=Fusion

      [Fonts]
      fixed="Iosevka Nerd Font Mono,12,-1,5,50,0,0,0,0,0,Regular"
      general="Iosevka Nerd Font,12,-1,5,50,0,0,0,0,0,Regular"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\a\x80\0\0\0\0\0\0\v.\0\0\x4\x6\0\0\a\x80\0\0\0\0\0\0\v.\0\0\x4\x6\0\0\0\0\x2\0\0\0\a\x80\0\0\a\x80\0\0\0\0\0\0\v.\0\0\x4\x6)

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';
  };

  services.kdeconnect.enable = true;
}
