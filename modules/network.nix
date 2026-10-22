{lib, ...}: {
  networking = {
    # Killer feature, Its a must these days.
    # Adblocker!! It uses steven black hosts.
    stevenBlackHosts = {
      enable = true;
      blockFakenews = true;
      blockGambling = true;
      blockPorn = true;
      blockSocial = false;
    };

    # dns
    # All lookups go through the local dnscrypt-proxy (modules/security.nix).
    nameservers = ["127.0.0.1"];
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };

    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0" "interface-name:ve-*"];
      wifi.macAddress = "random";
      # Don't push DHCP-provided DNS into resolved; dnscrypt-proxy handles it.
      dns = lib.mkForce "none";
      wifi.powersave = true;
    };

    # UFW-style default deny inbound policy with explicit service openings.
    firewall = {
      enable = true;
      allowedTCPPorts = [2764];
      # KDE Connect, reachable over Tailscale only.
      interfaces.tailscale0 = rec {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
      allowPing = false;
      logRefusedConnections = true;
      logReversePathDrops = true;
    };

    nat = {
      # for container or vm
      enable = false;
      internalInterfaces = ["ve-+"];
      externalInterface = "wlp1s0";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
  };

  services = {
    # network discovery, mDNS
    avahi = {
      enable = true;
      nssmdns4 = true;
      settings.publish = {
        disable-publishing = false;
        publish-domain = true;
        disable-user-service-publishing = false;
        publish-addresses = true;
      };
    };

    openssh = {
      enable = true;
      ports = [2764];
      settings = {
        UseDns = true;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # DNS resolver
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "false";
        # Mullvad plain DNS is only used if dnscrypt-proxy is down.
        FallbackDNS = ["194.242.2.5" "194.242.2.9"];
      };
    };
  };

  # Don't wait for network startup
  systemd = {
    services = {
      # speed up boot
      NetworkManager-wait-online.enable = false;
    };
  };
}
