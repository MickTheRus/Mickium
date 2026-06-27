_: {
  services.swaync = {
    enable = true;

    settings = {
      "$schema" = "/etc/xdg/swaync/configSchema.json";
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "overlay";
      layer-shell = true;
      cssPriority = "user";
      control-center-margin-top = 1;
      control-center-margin-bottom = 0;
      control-center-margin-right = 8;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 48;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 6;
      timeout-low = 3;
      timeout-critical = 0;
      fit-to-screen = false;
      control-center-width = 400;
      control-center-height = 920;
      notification-window-width = 400;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      widgets = [
        "buttons-grid"
        "mpris"
        "volume"
        "title"
        "notifications"
      ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear";
        };
        dnd.text = "Do Not Disturb";
        mpris = {
          image-size = 100;
          image-radius = 0;
        };
        volume = {
          label = " ";
          show-per-app = true;
          show-per-app-icon = true;
          show-per-app-label = true;
        };
        buttons-grid.actions = [
          {
            label = "󰐥";
            command = "bash -c $HOME/.config/hypr/scripts/power-menu.sh";
          }
          {
            label = "󰌾";
            command = "loginctl lock-session";
          }
          {
            label = "󰍃";
            command = "hyprctl dispatch exit";
          }
          {
            active = false;
            command = "swaync-client -d";
            label = "";
            type = "toggle";
          }
        ];
      };
    };

    style = ''
      @define-color background rgba(9,6,5, 0.8);
      @define-color foreground #FAF0EE;

      @define-color color0 #090605;
      @define-color noti-bg rgba(36,25,20, 0.6);
      @define-color color2 #482D26;
      @define-color color3 #514542;
      @define-color color4 #714E49;
      @define-color noti-border-dark rgba(149,117,115, 1);
      @define-color noti-border-light rgba(149,117,115, 0.6);
      @define-color color6 #B6A09B;
      @define-color color7 #F0E2DE;
      @define-color color8 #A89E9B;
      @define-color noti-bg-alt rgba(49,34,27, 0.6);
      @define-color color10 #613C33;
      @define-color color11 #6D5C59;
      @define-color color12 #976862;
      @define-color color13 #C79D9A;
      @define-color color14 #F3D6CF;
      @define-color color15 #F0E2DE;

      * {
        font-family: Iosevka Nerd Font;
        font-size: 15px;
        color: @foreground;
        transition: 200ms;
      }

      .notification {
        border: none;
        border-radius: 15px;
      }

      .summary {
        font-size: 16px;
      }

      .floating-notifications {
        background: transparent;
      }

      .notification-background {
        background: transparent;
      }

      .notification-content {
        background: transparent;
        border-radius: 0px;
        padding: 10px;
      }

      .image,
      .body-image {
        margin: 0px 5px 0px 0px;
      }

      .notification-default-action {
        background: @background;
        border: 2px solid @noti-bg;
        border-radius: 15px;
        transition: all .2s ease-in-out;
      }

      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 7px;
        border-bottom-right-radius: 7px;
      }

      .notification-default-action:hover {
        border: 2px solid @noti-border-dark;
      }

      .notification-action {
        border: none;
        border-radius: 5px;
        background: @noti-bg;
      }

      .notification-action:hover {
        background: @noti-bg-alt;
        border: 2px solid @noti-border-light;
      }

      .notification-action:first-child {
        border-bottom-left-radius: 15px;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 15px;
      }

      .close-button {
        padding: 0px;
        margin: 5px;
      }

      .close-button:hover {
        box-shadow: none;
        background: rgba(247, 118, 142, 0.5);
        transition: all .2s ease-in-out;
      }

      .control-center {
        background: @background;
        border-radius: 15px;
      }

      .notification-row {
        background: transparent;
        outline: none;
      }

      .time {
        color: gray;
        margin: 3px 37px 0px 0px;
      }

      .widget-buttons-grid {
        margin-top: 15px;
        background: @background;
      }

      .widget-volume {
        background: @background;
      }

      .widget-mpris {
        margin: 8px;
        padding: 0px;
        border-radius: 12px;
        background: @background;
      }

      .control-center-list {
        background: transparent;
      }
    '';
  };
}
