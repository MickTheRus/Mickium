{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  # Same blocklist as networking.stevenBlackHosts, minus upstream's
  # `fe80::1%lo0 localhost` line: it is a BSD interface name that libvirt's
  # dnsmasq rejects as a "bad address" when it reads /etc/hosts.
  blocklist = let
    cfg = config.networking.stevenBlackHosts;
    alternates = lib.concatStringsSep "-" (
      lib.optional cfg.blockFakenews "fakenews"
      ++ lib.optional cfg.blockGambling "gambling"
      ++ lib.optional cfg.blockPorn "porn"
      ++ lib.optional cfg.blockSocial "social"
    );
    orig = builtins.replaceStrings ["fe80::1%lo0 localhost\n"] [""] (
      builtins.readFile "${inputs.hosts}/alternates/${alternates}/hosts"
    );
    ipv6 = builtins.replaceStrings ["0.0.0.0"] ["::"] orig;
  in
    orig + lib.optionalString cfg.enableIPv6 ("\n" + ipv6);
in {
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

    extraHosts = lib.mkForce blocklist;

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
      # NetworkManager still leaves the DHCP-provided DNS on the Wi-Fi/Ethernet
      # link in resolved after each (re)connect. Clear it so every lookup goes
      # through dnscrypt-proxy. Tailscale and virtual links are left alone.
      dispatcherScripts = [
        {
          type = "basic";
          source = pkgs.writeShellScript "clear-link-dns" ''
            case "$1" in
              wl*|en*|eth*)
                case "$2" in
                  up|dhcp4-change|dhcp6-change|reapply|connectivity-change)
                    ${pkgs.systemd}/bin/resolvectl revert "$1"
                    ;;
                esac
                ;;
            esac
          '';
        }
      ];
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
        UseDns = false;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # DNS resolver
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "false";
        # LLMNR is spoofable, and Avahi already answers mDNS.
        LLMNR = "false";
        MulticastDNS = "false";
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
