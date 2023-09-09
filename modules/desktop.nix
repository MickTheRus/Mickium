{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    noisetorch.enable = true;
  };

  services = {
    dbus = {
      packages = with pkgs; [dconf gcr udisks2];
      enable = true;
    };
    udev.packages = with pkgs; [android-udev-rules];

    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';

    # To mount drives with udiskctl command
    udisks2.enable = true;

    # tlp.enable = true;     # TLP and auto-cpufreq for power management
    auto-cpufreq.enable = true;

    # For Laptop, make lid close and power buttom click to suspend
    logind = {
      lidSwitch = "suspend";
      extraConfig = ''
        HandlePowerKey = suspend
      '';
    };

    atd.enable = true;
    fstrim.enable = true;
    upower.enable = true;

    # For android file transfer via usb, or better check on KDE connect
    gvfs.enable = true;

    # Pipewire setup, just these lines enought to make sane default for it
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
  };

  systemd.services = {
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

  fonts = {
    packages = with pkgs; [
      noto-fonts
      unifont
      noto-fonts-emoji
      maple-mono
      (nerdfonts.override {fonts = ["Iosevka"];})
    ];

    enableDefaultPackages = true;

    # this fixes emoji stuff
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Iosevka Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = ["Noto Sans" "Noto Serif"];
        serif = ["Noto Sans" "Noto Serif"];
        emoji = ["Noto Color Emoji" "Symbola" "Noto Sans"];
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-hyprland];
  };
}
