{
  pkgs,
  config,
  ...
}:
# media - control and enjoy audio/video
{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music";
      network = {
        listenAddress = "127.0.0.1";
        port = 6600;
        startWhenNeeded = true;
      };
      extraConfig = ''
        audio_output {
          type            "pipewire"
          name            "PipeWire Sound Server"
        }
        auto_update "yes"
      '';
    };

    playerctld.enable = true;
  };

  home.packages = with pkgs; [
    # audio control
    bluetuith
    pavucontrol
    playerctl
    pulsemixer
    pamixer
    mpc
    equibop
    qpwgraph
    rmpc
  ];

  programs = {
    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [mpris];

      bindings = {
        l = "seek  5";
        h = "seek -5";
        k = "seek  30";
        j = "seek -30";
        J = "cycle sub";
        K = "cycle sub down";
      };

      config = {
        force-window = true;
        osc = true;
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
        gpu-context = "wayland";
        sub-border-size = 4.0;
        sub-shadow-color = "0.0/0.0/0.0";
        sub-shadow-offset = 1;
        sub-auto = "fuzzy";
        msg-level = "all=error";
        # ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
        ytdl-format = "best";
        save-position-on-quit = true;
        slang = "eng,en,Eng,English";
        alang = "jp,jpn,en,eng";
        sub-font = "Impress BT";
        autofit = "50%";
        sub-font-size = "48";
        speed = "1.5";
      };
    };

    imv = {
      enable = true;
      settings = {
        # check man imv(5))
        options.background = "050505";
        aliases.x = "close";
        binds = {
          p = "prev";
          n = "next";
          "Shift+d" = "exec rm \"$imv_current_file\"; close";
          r = "exec mogrify -rotate 90 \"$imv_current_file\"";
        };
      };
    };

    yt-dlp = {
      enable = true;
      settings = {
        embed-thumbnail = true;
        embed-metadata = true;
        embed-subs = true;
        sub-langs = "all";
      };
    };
  };

  xdg.configFile."ytfzf/conf.sh".text = ''
    #video_pref="248+bestaudio/best"
    video_pref="[height<=1080]"
    sub_link_count=1
    show_thumbnails=0
    invidious_instance="https://vid.puffyan.us"
    external_menu () {
         #bemenu -W 0.98 -l 24 -p '  Play '
         rofi -dmenu -i -config ~/.config/rofi/list.rasi -p '󰑈  Play'
    }

    thumbnail_quality=high
    scrape=youtube
    #is_sort=1
    #search_sort_by=upload_date

  '';
  home.sessionVariables.MPD_HOST = config.services.mpd.network.listenAddress;
}
