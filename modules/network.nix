_: {
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
    # mullvad dns
    nameservers = ["194.242.2.5" "194.242.2.9"];
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };

    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0" "interface-name:ve-*"];
      wifi.macAddress = "random";
      dns = "systemd-resolved";
      wifi.powersave = true;
    };

    # UFW-style default deny inbound policy with explicit service openings.
    firewall = rec {
      enable = true;
      # For KDE Connect.
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
      allowedTCPPorts = [2764];
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
      publish = {
        enable = true;
        domain = true;
        userServices = true;
      };
    };

    openssh = {
      enable = true;
      ports = [2764];
      settings.UseDns = true;
    };

    # DNS resolver
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "false";
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
