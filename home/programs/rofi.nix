{pkgs, ...}: {
  home.packages = with pkgs; [
    rofi
  ];

  xdg.configFile = {
    "rofi/colors.rasi".text = ''
      * {
          font: "Iosevka Nerd Font 14";
          background:     rgba(1,2,4, 0.8);
          background-alt: rgba(11,19,25, 0.15);
          foreground:     rgba(202,230,230, 1);
          selected:       rgba(20,39,46, 0.7);
          active:         rgba(64,149,150, 1);
          urgent:         rgba(20,39,46, 1);
      }
    '';

    "rofi/menus/clipboard.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        clipboard=$(cliphist list)

        selected=$(printf '%s\n' "$clipboard" | rofi -dmenu -theme "$HOME/.config/rofi/styles/clipboard.rasi" -p "󱘢" -display-columns 2)

        if [[ $selected != "" ]]; then
            printf '%s\n' "$selected" | cliphist decode | wl-copy
        fi
      '';
    };

    "rofi/menus/drun.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        rofi -show drun -theme "$HOME/.config/rofi/styles/drun.rasi"
      '';
    };

    "rofi/menus/emoji.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        rofi -modi emoji -show emoji -theme "$HOME/.config/rofi/styles/emoji.rasi" -emoji-format '<span size="large">{emoji}</span> <span weight="bold">{name}</span> [<span size="small">({keywords})</span>]'
      '';
    };

    "rofi/menus/swww.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        set -u

        wallpaper_path="$HOME/.config/hypr/Wallpaper.jpeg"
        mkdir -p "$HOME/.cache"

        if ! awww query >/dev/null 2>&1; then
            awww-daemon &
            sleep 0.2
        fi

        if [[ -f "$wallpaper_path" ]]; then
            awww img "$wallpaper_path" --transition-type center --transition-fps 60 --transition-step 100 &&
            ln -sf "$wallpaper_path" ~/.cache/current-wallpaper &&
            ~/.config/hypr/scripts/generate-wallpaper-variants.sh
        fi
      '';
    };

    "rofi/styles/clipboard.rasi".text = ''
      configuration {
      	modi:                       "dmenu";

          kb-remove-to-eol: "";
          kb-mode-complete: "";

          kb-accept-entry: "Tab,Return";
          kb-element-next: "Control+j";
          kb-element-prev: "Control+k";
          /*kb-row-left: "Control+h";*/
          kb-row-right: "Control+l";
      }

      /*****----- Global Properties -----*****/
      @import                          "../colors.rasi"

      /*****----- Main Window -----*****/
      window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       500px;
          x-offset:                    0px;
          y-offset:                    0px;

          enabled:                     true;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          cursor:                      "default";
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     10px;
          padding:                     10px 20px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                @selected;
          background-color:            transparent;
          children:                    [ "inputbar", "listview" ];
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          spacing:                     10px;
          padding:                     15px 10px;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          children:                    [ "prompt", "entry" ];
      }

      prompt {
          font: "Iosevka Nerd Font 17";
          enabled:                     true;
          padding:                     10px 18px 10px 15px;
          border-radius:               10px;
          background-color:            @background;
          text-color:                  inherit;
      }
      textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "::";
          background-color:            inherit;
          text-color:                  inherit;
      }
      entry {
          enabled:                     true;
          border-radius:               10px;
          padding:                     13px;
          background-color:            @background;
          text-color:                  inherit;
          cursor:                      text;
          placeholder:                 "Search...";
          placeholder-color:           inherit;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     1;
          lines:                       8;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                false;
          fixed-columns:               true;

          spacing:                     5px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          cursor:                      "default";
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          spacing:                     0px;
          padding:                     12px;
          border:                      0px solid;
          border-radius:               12px;
          border-color:                @selected;
          text-color:                  @foreground;
          cursor:                      pointer;
      }
      element.alternate.normal {
          background-color: transparent;
          text-color: @foreground;
      }
      element normal.normal {
          background-color:            transparent;
          text-color:                  @foreground;
      }
      element selected.normal {
          background-color:            @selected;
          text-color:                  @foreground;
      }
      element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        62px;
          cursor:                      inherit;
      }
      element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.0;
      }

      /*****----- Message -----*****/
      error-message {
          padding:                     15px;
          border:                      2px solid;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          text-color:                  @foreground;
      }
      textbox {
          background-color:            @background;
          text-color:                  @foreground;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
      }
    '';

    "rofi/styles/drun.rasi".text = ''
      /*****----- Configuration -----*****/
      configuration {
      	modi:                       "drun,run,window";
          show-icons:                 true;
          display-drun:               " ";
          display-run:                " ";
          display-window:             " ";
      	drun-display-format:        "{name}";

          kb-remove-to-eol: "";
          kb-mode-complete: "";

          kb-accept-entry: "Tab,Return";
          kb-element-next: "Control+j";
          kb-element-prev: "Control+k";
          /*kb-row-left: "Control+h";*/
          kb-row-right: "Control+l";
      }

      /*****----- Global Properties -----*****/
      @import                          "../colors.rasi"

      /*****----- Main Window -----*****/
      window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       550px;
          x-offset:                    0px;
          y-offset:                    0px;

          enabled:                     true;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          cursor:                      "default";
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     15px;
          padding:                     20px;
          border-color:                @selected;
          background-color:            transparent;
          children:                    [ "inputbar", "listview" ]; /*, "mode-switcher"]; */
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          spacing:                     10px;
          padding:                     35px 25px 100px 25px;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            transparent;
          background-image:            url("~/.cache/current-wallpaper", width);
          text-color:                  @foreground;
          children:                    [ "prompt", "entry" ];
      }

      prompt {
          enabled:                     true;
          border-radius:               10px;
          padding:                     15px;
          background-color:            @background;
          text-color:                  inherit;
      }
      textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "::";
          background-color:            inherit;
          text-color:                  inherit;
      }
      entry {
          enabled:                     true;
          padding:                     15px;
          border-radius:               10px;
          background-color:            @background;
          text-color:                  inherit;
          cursor:                      text;
          placeholder:                 "Search...";
          placeholder-color:           inherit;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     1;
          lines:                       8;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                false;
          fixed-columns:               true;

          spacing:                     7px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          cursor:                      "pointer";
      }
      scrollbar {
          handle-width:                7px ;
          handle-color:                @selected;
          border-radius:               50%;
          background-color:            @background;
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          spacing:                     10px;
          padding:                     7px 7px 7px 10px;
          border:                      0px solid;
          border-radius:               12px;
          border-color:                @selected;
          text-color:                  @foreground;
          cursor:                      pointer;
      }
      element.alternate.normal {
          background-color: transparent;
          text-color: @foreground;
      }
      element normal.normal {
          background-color:            transparent;
          text-color:                  @foreground;
      }
      element selected.normal {
          background-color:            @selected;
          text-color:                  @foreground;
      }
      element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        32px;
          cursor:                      inherit;
      }
      element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.0;
      }

      /*****----- Mode Switcher -----*****/
      mode-switcher{
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          background-color:            transparent;
          text-color:                  @foreground;
      }
      button {
          padding:                     8px;
          border:                      0px solid;
          border-radius:               12px;
          background-color:            @background-alt;
          text-color:                  inherit;
          cursor:                      pointer;
      }
      button selected {
          background-color:            @selected;
      }

      /*****----- Message -----*****/
      error-message {
          padding:                     15px;
          border:                      2px solid;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          text-color:                  @foreground;
      }
      textbox {
          background-color:            @background;
          text-color:                  @foreground;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
      }
    '';

    "rofi/styles/emoji.rasi".text = ''
      configuration {
          modi:                       "emoji";
          display-emoji:              "󰞅";
          show-icons:                 false;

          kb-remove-to-eol: "";
          kb-mode-complete: "";

          kb-accept-entry: "Tab,Return";
          kb-element-next: "Control+j";
          kb-element-prev: "Control+k";
          /*kb-row-left: "Control+h";*/
          kb-row-right: "Control+l";
      }

      /*****----- Global Properties -----*****/
      @import                          "../colors.rasi"

      /*****----- Main Window -----*****/
      window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       500px;

          enabled:                     true;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          cursor:                      "default";
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     10px;
          padding:                     10px 20px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                @selected;
          background-color:            transparent;
          children:                    [ "inputbar", "listview" ];
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          spacing:                     10px;
          padding:                     15px 10px;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          children:                    [ "prompt", "entry" ];
      }

      prompt {
          font: "Iosevka Nerd Font 18";
          enabled:                     true;
          padding:                     10px 20px 10px 15px;
          border-radius:               10px;
          background-color:            @background;
          text-color:                  inherit;
      }
      textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "::";
          background-color:            inherit;
          text-color:                  inherit;
      }
      entry {
          enabled:                     true;
          border-radius:               10px;
          padding:                     13px;
          background-color:            @background;
          text-color:                  inherit;
          cursor:                      text;
          placeholder:                 "Search...";
          placeholder-color:           inherit;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     1;
          lines:                       8;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                false;
          fixed-columns:               true;

          spacing:                     5px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          cursor:                      "default";
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          spacing:                     0px;
          padding:                     12px;
          border:                      0px solid;
          border-radius:               12px;
          border-color:                @selected;
          text-color:                  @foreground;
          cursor:                      pointer;
      }
      element.alternate.normal {
          background-color: transparent;
          text-color: @foreground;
      }
      element normal.normal {
          background-color:            transparent;
          text-color:                  @foreground;
      }
      element selected.normal {
          background-color:            @selected;
          text-color:                  @foreground;
      }
      element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        62px;
          cursor:                      inherit;
      }
      element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.0;
      }

      /*****----- Message -----*****/
      error-message {
          padding:                     15px;
          border:                      2px solid;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          text-color:                  @foreground;
      }
      textbox {
          background-color:            @background;
          text-color:                  @foreground;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
      }
    '';

    "rofi/styles/swww.rasi".text = ''
      /*****----- Configuration -----*****/
      configuration {
      	modi:                       "dmenu";
          show-icons:                 true;

          kb-remove-to-eol: "";
          kb-mode-complete: "";

          kb-accept-entry: "Tab,Return";
          kb-element-next: "Control+j";
          kb-element-prev: "Control+k";
          /*kb-row-left: "Control+h";*/
          kb-row-right: "Control+l";
      }

      /*****----- Global Properties -----*****/
      @import                          "../colors.rasi"

      /*****----- Main Window -----*****/
      window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       500px;
          x-offset:                    0px;
          y-offset:                    0px;

          enabled:                     true;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          cursor:                      "default";
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     10px;
          padding:                     20px;
          border-color:                @selected;
          background-color:            transparent;
          children:                    [ "inputbar", "listview" ];
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     35px 25px 100px 25px;
          border:                      0px solid;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            transparent;
          background-image:            url("~/.cache/current-wallpaper", width);
          text-color:                  @foreground;
          children:                    [ "prompt", "entry" ];
      }

      prompt {
          enabled:                     true;
          padding:                     15px;
          border-radius:               10px;
          background-color:            @background;
          text-color:                  inherit;
      }
      textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "::";
          background-color:            inherit;
          text-color:                  inherit;
      }
      entry {
          enabled:                     true;
          border-radius:               10px;
          padding:                     15px;
          background-color:            @background;
          text-color:                  inherit;
          cursor:                      text;
          placeholder:                 "Search...";
          placeholder-color:           inherit;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     1;
          lines:                       6;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                false;
          fixed-columns:               true;

          spacing:                     5px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          cursor:                      "pointer";
      }
      scrollbar {
          handle-width:                5px ;
          handle-color:                @selected;
          background-color:            @background-alt;
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          spacing:                     10px;
          padding:                     0px 10px;
          border-radius:               12px;
          border-color:                @selected;
          text-color:                  @foreground;
          cursor:                      pointer;
      }
      element.alternate.normal {
          background-color: transparent;
          text-color: @foreground;
      }
      element normal.normal {
          background-color:            transparent;
          text-color:                  @foreground;
      }
      element selected.normal {
          background-color:            @selected;
          text-color:                  @foreground;
      }
      element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        62px;
          cursor:                      inherit;
      }
      element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.0;
      }

      /*****----- Message -----*****/
      error-message {
          padding:                     15px;
          border:                      2px solid;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          text-color:                  @foreground;
      }
      textbox {
          background-color:            @background;
          text-color:                  @foreground;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
      }
    '';

    "rofi/styles/window.rasi".text = ''
      /*****----- Configuration -----*****/
      configuration {
      	modi:                       "window";
          show-icons:                 true;
          display-window:               " ";
      	drun-display-format:        "{name}";
      }

      /*****----- Global Properties -----*****/
      @import                          "../colors.rasi"

      /*****----- Main Window -----*****/
      window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       500px;
          x-offset:                    0px;
          y-offset:                    0px;

          enabled:                     true;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               20px;
          border-color:                @selected;
          background-color:            @background;
          cursor:                      "default";
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     20px;
          margin:                      0px;
          padding:                     20px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                @selected;
          background-color:            transparent;
          children:                    [ "inputbar", "listview" ];
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @selected;
          background-color:            @background;
          text-color:                  @foreground;
          children:                    [ "entry" ];
      }

      prompt {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  inherit;
      }
      textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "::";
          background-color:            inherit;
          text-color:                  inherit;
      }
      entry {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  inherit;
          cursor:                      text;
          placeholder:                 "Search...";
          placeholder-color:           inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     2;
          lines:                       1;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;

          spacing:                     10px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          cursor:                      "default";
      }
      scrollbar {
          handle-width:                5px ;
          handle-color:                @selected;
          border-radius:               0px;
          background-color:            @background-alt;
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          spacing:                     15px;
          margin:                      0px;
          padding:                     20px 10px;
          border:                      0px solid;
          border-radius:               20px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          orientation:                 vertical;
          cursor:                      pointer;
      }
      element normal.normal {
          background-color:            transparent;
          text-color:                  @foreground;
      }
      element selected.normal {
          background-color:            @background-alt;
          text-color:                  @foreground;
      }
      element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        128px;
          cursor:                      inherit;
      }
      element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }

      /*****----- Message -----*****/
      error-message {
          padding:                     20px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @selected;
          background-color:            black / 10%;
          text-color:                  @foreground;
      }
      textbox {
          background-color:            transparent;
          text-color:                  @foreground;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
      }
    '';
  };
}
