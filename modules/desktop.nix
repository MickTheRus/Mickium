{
  config,
  pkgs,
  lib,
  ...
}: let
  wrapHyprlandNoAmbientCaps = package:
    (pkgs.symlinkJoin {
      name = "${package.name}-no-ambient-caps";
      paths = [package];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        rm -rf "$out/share/systemd"

        wrapProgram "$out/bin/Hyprland" \
          --run 'if [ -z "''${HYPRLAND_CAPS_CLEARED:-}" ]; then export HYPRLAND_CAPS_CLEARED=1; exec ${pkgs.libcap}/bin/capsh --noamb -- -c '"'"'exec "$@"'"'"' Hyprland "$0" "$@"; fi'
      '';
    })
    // {
      inherit (package) passthru providedSessions version;
      meta =
        (package.meta or {})
        // {
          outputsToInstall = ["out"];
        };
      override = args: wrapHyprlandNoAmbientCaps package;
    };
  hyprlandNoAmbientCaps = wrapHyprlandNoAmbientCaps pkgs.hyprland;
in {
  programs = {
    dconf.enable = true;
    kdeconnect.enable = true;
    steam.enable = true;
    hyprland.package = hyprlandNoAmbientCaps;
  };

  # Bubblewrap/pressure-vessel need user namespaces and reject inherited ambient
  # capabilities. Ly grants the session CAP_SYS_NICE, so Hyprland is wrapped
  # above to clear capabilities before it starts user apps.
  security.unprivilegedUsernsClone = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    dbus = {
      packages = with pkgs; [dconf gcr udisks2];
      enable = true;
    };
    udev.packages = [];

    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';

    # To mount drives with udiskctl command
    udisks2.enable = true;
    printing.enable = true;

    fprintd = {
      enable = true;
      package = pkgs.fprintd;
    };

    # power management
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

        USB_AUTOSUSPEND = 1;
        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 70;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 30;
      };
    };

    # Lock before sleeping; hypridle handles loginctl lock-session before suspend.
    logind = {
      settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend-then-hibernate";
        HandleLidSwitchDocked = "suspend-then-hibernate";
        HandlePowerKey = "suspend-then-hibernate";
        HibernateDelaySec = "3600";
      };
    };

    atd.enable = true;
    fstrim.enable = true;
    upower.enable = true;

    # For android file transfer via usb, or better check on KDE connect
    gvfs.enable = true;

    tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
      extraUpFlags = [
        "--accept-dns"
        "--accept-routes"
      ];
    };

    # Pipewire setup, just these lines enough to make sane default for it
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    pulseaudio.enable = lib.mkForce false;
  };

  services.displayManager.ly.enable = true;

  programs.hyprland.enable = true;

  systemd.services = {
    tailscaled-login = {
      description = "Start Tailscale login flow when unauthenticated";
      after = [
        "network-online.target"
        "tailscaled.service"
      ];
      wants = [
        "network-online.target"
        "tailscaled.service"
      ];
      wantedBy = ["multi-user.target"];
      path = [
        config.services.tailscale.package
        pkgs.jq
      ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "30s";
      };
      script = ''
        state="$(tailscale status --json --peers=false | jq -r '.BackendState // empty' 2>/dev/null || true)"

        if [ "$state" = "Running" ]; then
          echo "Tailscale is already running"
          exit 0
        fi

        echo "Starting Tailscale. Complete the sign-in URL shown below if this device is not authenticated yet."
        exec tailscale up --accept-dns --accept-routes --operator=mick --timeout=0s
      '';
    };

    seatd = {
      enable = true;
      description = "Seat management daemon";
      script = "${pkgs.seatd}/bin/seatd -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
      };
      wantedBy = ["multi-user.target"];
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [pkgs.libGL pkgs.mesa pkgs.freeglut pkgs.libGLU pkgs.libglibutil];
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      unifont
      # symbola # this font is unfree
      noto-fonts-color-emoji
      julia-mono

      nerd-fonts.iosevka
      nerd-fonts.symbols-only
    ];

    enableDefaultPackages = true;

    # this fixes emoji stuff
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Iosevka Nerd Font Mono"
          "Noto Color Emoji"
        ];
        sansSerif = ["Iosevka Nerd Font" "Noto Sans" "Noto Serif"];
        serif = ["Iosevka Nerd Font" "Noto Serif" "Noto Sans"];
        emoji = ["Noto Color Emoji" "Symbola" "Noto Sans"];
      };
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
