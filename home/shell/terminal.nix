_: {
  programs = {
    kitty = {
      enable = true;

      keybindings = {
        "f1" = "new_tab_with_cwd";
      };

      settings = {
        enabled_layouts = "tall:bias=50;full_size=1;mirrored=false";
        window_padding_width = 10;
        editor = "nvim";
        font_size = 12;
        font_family = "Iosevka Nerd Font";
        open_url_with = "default";
        detect_urls = true;
        copy_on_select = true;
        background_opacity = "0.85";
        background_image_layout = "scaled";
        dynamic_background_opacity = true;
        hide_window_decorations = true;
        disable_ligatures = "never";

        foreground = "#cdd6f4";
        background = "#1e1e2e";
        selection_foreground = "#1e1e2e";
        selection_background = "#f5e0dc";
        cursor = "#f5e0dc";
        cursor_text_color = "#1e1e2e";
        url_color = "#f5e0dc";
        active_border_color = "#b4befe";
        inactive_border_color = "#6c7086";
        bell_border_color = "#f9e2af";
        wayland_titlebar_color = "system";
        macos_titlebar_color = "system";
        active_tab_foreground = "#11111b";
        active_tab_background = "#cba6f7";
        inactive_tab_foreground = "#cdd6f4";
        inactive_tab_background = "#181825";
        tab_bar_background = "#11111b";
        mark1_foreground = "#1e1e2e";
        mark1_background = "#b4befe";
        mark2_foreground = "#1e1e2e";
        mark2_background = "#cba6f7";
        mark3_foreground = "#1e1e2e";
        mark3_background = "#74c7ec";
        color0 = "#45475a";
        color8 = "#585b70";
        color1 = "#f38ba8";
        color9 = "#f38ba8";
        color2 = "#a6e3a1";
        color10 = "#a6e3a1";
        color3 = "#f9e2af";
        color11 = "#f9e2af";
        color4 = "#89b4fa";
        color12 = "#89b4fa";
        color5 = "#f5c2e7";
        color13 = "#f5c2e7";
        color6 = "#94e2d5";
        color14 = "#94e2d5";
        color7 = "#bac2de";
        color15 = "#a6adc8";
      };
    };

    foot = {
      enable = true;

      # doesnt work properly; Enable it in hyprland or sway config
      server.enable = false;

      settings = {
        main = {
          term = "xterm-256color";
          font = "Iosevka Nerd Font:size=10, Noto Color Emoji:size=10";
          font-bold = "Iosevka Nerd Font:size=10, Noto Color Emoji:size=10";
          letter-spacing = "1";
          box-drawings-uses-font-glyphs = "no";
          pad = "0x0center";
          notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
          selection-target = "clipboard";
          dpi-aware = "true";
        };

        scrollback = {
          lines = 10000;
          multiplier = 3;
        };

        url = {
          launch = "d-stuff \${url}";
          label-letters = "sadfjklewcmpgh";
          osc8-underline = "url-mode";
          protocols = "http, https, ftp, ftps, file";
          uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
        };

        key-bindings = {
          clipboard-copy = "Control+Shift+c";
          clipboard-paste = "Control+Shift+v Control+y";
          primary-paste = "Shift+Insert";
        };

        colors = {
          background = "050505";
          foreground = "ffffff";
          regular0 = "030303";
          regular1 = "ff8059";
          regular2 = "44bc44";
          regular3 = "d0bc00";
          regular4 = "2fafff";
          regular5 = "feacd0";
          regular6 = "00d3d0";
          regular7 = "bfbfbf";
          bright0 = "595959";
          bright1 = "ef8b50";
          bright2 = "70b900";
          bright3 = "c0c530";
          bright4 = "79a8ff";
          bright5 = "b6a0ff";
          bright6 = "6ae4b9";
          bright7 = "ffffff";
          alpha = "0.9";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };

    zellij = {
      enable = true;
      settings = {
      };
    };
  };
}
