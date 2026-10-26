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
        cache = true;

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
    # Provides org.freedesktop.secrets; also unlocks the login keyring via PAM.
    # Ly delegates to the login PAM stack, so it inherits this integration.
    gnome.gnome-keyring.enable = true;
    # Keep the existing SSH agent; only use GNOME Keyring for secrets.
    gnome.gcr-ssh-agent.enable = false;
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
          # Fixed origin/appid so one registration works on every host; the
          # default is pam://<hostname>, which ties a key to a single machine.
          origin = "pam://mickium";
          appid = "pam://mickium";
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
