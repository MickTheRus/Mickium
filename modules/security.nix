{
...
}:

# this makes our system more secure
# note that it might break some stuff, eg webcam

{
  services = {
    dnscrypt-proxy2 = {
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
  };

  programs.ssh.startAgent = true;

  security = {
    protectKernelImage = true;
    lockKernelModules = false;
    rtkit.enable = true;
    polkit.enable = true;

    # required for lockscreens
    pam = {
      services.gtklock = {
        text = "auth include login";
      };
    };

    doas = {
      enable = true;
      extraRules = [{
        users = [ "mick" ];
        keepEnv = true;
        persist = true;
      }];
    };

    sudo.enable = false;
  };

}
