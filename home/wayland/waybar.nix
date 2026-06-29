_: {
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      font = "Iosevka Nerd Font";
      reload_style_on_change = true;
      width = 1920;
      spacing = 7;

      modules-left = [
        "group/quicklinks-left"
        "wlr/taskbar"
        "hyprland/window"
      ];
      modules-center = ["hyprland/workspaces"];
      modules-right = [
        "mpd"
        "network"
        "pulseaudio"
        "group/hardware"
        "tray"
        "clock"
        "group/quicklinks-right"
      ];

      "wlr/taskbar" = {
        format = "{icon}";
        icon-size = "20";
        on-click = "activate";
        on-click-right = "close";
        tooltip-format = "Go to {title}";
        ignore-list = ["kitty" "kitty-scratchpad"];
      };

      "hyprland/workspaces" = {
        sort-by = "number";
        all-outputs = false;
        warp-on-scroll = false;
        format = "{icon}";
        format-icons = {
          urgent = "";
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "10";
          "11" = "1";
          "12" = "2";
          "13" = "3";
          "14" = "4";
          "15" = "5";
          "16" = "6";
          "17" = "7";
          "18" = "8";
          "19" = "9";
          "20" = "10";
          "21" = "1";
          "22" = "2";
          "23" = "3";
          "24" = "4";
          "25" = "5";
          "26" = "6";
          "27" = "7";
          "28" = "8";
          "29" = "9";
          "30" = "10";
          default = "";
        };
        on-scroll-up = "hyprctl dispatch split:workspace m-1";
        on-scroll-down = "hyprctl dispatch split:workspace m+1";
      };

      "hyprland/window" = {
        format = "{title}";
        icon = true;
        icon-size = 20;
        max-length = 30;
        separate-outputs = true;
        rewrite."(.*) - Brave" = "$1";
      };

      tray = {
        icon-size = 21;
        spacing = 10;
      };

      "group/quicklinks-left" = {
        orientation = "horizontal";
        modules = [
          "custom/chatgpt"
          "custom/settings"
          "custom/clipboard"
        ];
      };
      "custom/chatgpt" = {
        format = " ";
        tooltip = true;
        tooltip-format = "Open ChatGPT!";
        on-click = "brave --app=https://chatgpt.com";
      };
      "custom/settings" = {
        format = " ";
        tooltip = true;
        tooltip-format = "Open Settings!";
        on-click = "systemsettings";
      };
      "custom/clipboard" = {
        format = "󱘢 ";
        tooltip = true;
        tooltip-format = "Open Clipboard Manager!";
        on-click = "~/.config/rofi/menus/clipboard.sh";
      };

      "group/quicklinks-right" = {
        orientation = "horizontal";
        modules = [
          "idle_inhibitor"
          "custom/wallpaper"
          "custom/notification"
          "custom/power-menu"
        ];
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = " ";
          deactivated = " ";
        };
      };
      "custom/power-menu" = {
        format = " ";
        tooltip = true;
        tooltip-format = " Open Wlogout!";
        on-click = "~/.config/hypr/scripts/power-menu.sh";
      };
      "custom/wallpaper" = {
        format = " ";
        tooltip = true;
        tooltip-format = " Change Wallpaper!";
        on-click = "~/.config/rofi/menus/swww.sh";
      };
      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };

      "group/settings" = {
        orientation = "horizontal";
        modules = [];
      };

      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/nvme/nvme0/hwmon1/temp1_input";
        format-icons = ["" "" ""];
      };

      pulseaudio = {
        format = "{volume}% {icon}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = "󰝟 {format_source}";
        format-source = "{volume}%";
        format-source-muted = "";
        format-icons.default = ["" " " " "];
        max-volume = 150;
        on-click = "pavucontrol";
      };

      network = {
        format = "{ifname}";
        format-wifi = "{essid} {bandwidthDownBytes}  ";
        format-ethernet = "{bandwidthDownBytes}  ";
        format-disconnected = "󱍢 No Internet";
        tooltip-format = "{ifname} via {gwaddr} 󰊗";
        tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
        tooltip-format-ethernet = "{ifname}  ";
        max-length = 50;
        interval = 2;
      };

      "group/hardware" = {
        orientation = "horizontal";
        modules = ["disk" "cpu" "memory"];
      };
      disk = {
        format = "{percentage_used}%  ";
        path = "/home";
      };
      cpu = {
        format = " {usage}%  ";
        tooltip = false;
      };
      memory.format = " {}%  ";

      clock = {
        format = "󱑂 {:%R %a}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "󰨳 {:%d %b %Y}";
      };
    };

    style = ''
      @define-color foreground #f5e0dc;
      @define-color background rgba(30,30,46,0.50);
      @define-color cursor #FAF0EE;

      @define-color color0 #090605;
      @define-color color1 #241914;
      @define-color color2 #482D26;
      @define-color color3 #514542;
      @define-color color4 #714E49;
      @define-color color5 #957573;
      @define-color color6 #B6A09B;
      @define-color color7 #F0E2DE;
      @define-color color8 #A89E9B;
      @define-color color9 #31221B;
      @define-color color10 #613C33;
      @define-color color11 #6D5C59;
      @define-color color12 #976862;
      @define-color color13 #C79D9A;
      @define-color color14 #F3D6CF;
      @define-color color15 #F0E2DE;

      * {
        all: unset;
        font-family: "Iosevka Nerd Font";
        font-size: 15px;
        font-weight: normal;
        color: @foreground;
      }

      tooltip {
        background: @background;
        border: 1.5px solid @color5;
        border-radius: 8px;
        padding: 2px 100px;
      }

      #image,
      #mpd *,
      #taskbar *,
      #quicklinks-right *,
      #quicklinks-left * {
        border-radius: 8px;
        color: @foreground;
      }

      #clock,
      #hardware,
      #network,
      #pulseaudio,
      #taskbar,
      #quicklinks-right,
      #quicklinks-left {
        border-radius: 12px;
        background: @background;
        padding: 3px 7px;
        margin: 4px;
        opacity: 0.9;
      }

      #workspaces {
        background: @color1;
        margin: 4px 0px;
        padding: 1px 0px;
        border-radius: 15px;
        opacity: 0.9;
      }
      #workspaces button {
        background: @color3;
        min-width: 25px;
        min-height: 25px;
        margin: 2px 4px;
        border-radius: 12px;
        transition: all 0.2s ease-in-out;
        padding: 0px;
        opacity: 0.6;
      }
      #workspaces button label {
        min-width: 25px;
        padding: 0px;
        margin: 0px;
        font-size: 13px;
      }
      #workspaces button:first-child {
        margin-left: 3px;
      }
      #workspaces button:last-child {
        margin-right: 3px;
      }
      #workspaces button:hover {
        opacity: 0.8;
        background: @color11;
      }
      #workspaces button.active {
        background: @color11;
        min-width: 50px;
        border-radius: 12px;
        opacity: 0.9;
      }
      #workspaces button.active label {
        min-width: 50px;
      }
      #workspaces button.urgent {
        color: @foreground;
        transition: all 0.2s ease-in-out;
      }

      #quicklinks-right,
      #quicklinks-left {
        background: @color1;
      }
      #quicklinks-right {
        padding-right: 0px;
        margin-right: 7px;
      }
      #quicklinks-left {
        margin-left: 7px;
      }
      #quicklinks-right *,
      #quicklinks-left * {
        padding: 0px 3px;
        margin: 0px 2px;
        transition: all 0.2s ease-in-out;
      }
      #quicklinks-left * {
        padding: 0px 0px 0px 5px;
        font-size: 16px;
      }
      #quicklinks-right *:hover,
      #quicklinks-left *:hover {
        background: @color11;
      }

      #taskbar {
        margin-left: 0px;
        padding: 0px;
      }
      #taskbar * {
        transition: all 0.2s ease-in-out;
        margin: 2px 3px;
      }
      #taskbar *:hover {
        background: @color11;
      }

      #custom-power-menu {
        color: #f7768e;
        padding-right: 2px;
        padding-left: 5px;
      }

      #custom-notification {
        padding: 0px 7px 0px 2px;
      }

      #custom-wallpaper {
        padding-right: 2px;
      }

      #image {
        margin: 0px;
        padding: 0px;
      }

      #window {
        margin-left: 10px;
      }
    '';
  };
}
