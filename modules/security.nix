{pkgs, ...}:
# this makes our system more secure
# note that it might break some stuff, eg webcam
{
  environment.systemPackages = with pkgs; [
    pam_u2f
    yubico-pam
    yubikey-manager
    yubioath-flutter
  ];

  services = {
    dnscrypt-proxy = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };
    };

    fail2ban = {
      enable = true;
      bantime = "1h";
      maxretry = 5;
      bantime-increment = {
        enable = true;
        maxtime = "1w";
        rndtime = "10m";
      };
    };

    pcscd.enable = true;
  };

  programs.ssh.startAgent = true;

  security = {
    protectKernelImage = true;
    lockKernelModules = false;
    rtkit.enable = true;
    polkit.enable = true;

    # required for lockscreens
    pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        settings = {
          authfile = "/home/mick/.config/Yubico/u2f_keys";
          cue = true;
        };
      };

      services.gtklock = {
        text = "auth include login";
      };
      services.hyprlock = {
        text = "auth include login";
      };
    };

    doas = {
      enable = true;
      extraRules = [
        {
          groups = ["wheel"];
          keepEnv = true;
          noPass = true;
        }
      ];
    };

    sudo.enable = false;
  };
}
