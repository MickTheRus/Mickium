{
  config,
  pkgs,
  lib,
  ...
}: {
  networking = {

    # Killer feature, Its a must these days.
    # Adblocker!! It uses steven black hosts.
    stevenBlackHosts = {
      enable = true;
      blockFakenews = false;
      blockGambling = false;
      blockPorn = false;
      blockSocial = false;
    };

    # dns
    # mullvad dns
    nameservers = [ "194.242.2.5" "194.242.2.9" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
      wifi.macAddress = "random";
      dns = "systemd-resolved";
      wifi.powersave = true;
    };

    # Firewall uses iptables underthehood
    firewall = {
      enable = true;
      # For syncthing
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      allowPing = false;
      logReversePathDrops = true;
    };
  };

  services = {
    # network discovery, mDNS
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        domain = true;
        userServices = true;
      };
    };

    openssh = {
      enable = true;
      settings.UseDns = true;
    };

    # DNS resolver
    resolved = {
      enable = true;
      fallbackDns = [ "194.242.2.5" "194.242.2.9" ];
    };
  };


  # Don't wait for network startup
  #systemd.services.NetworkManager-wait-online.enable = false;
}
