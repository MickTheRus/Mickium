{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    podman-compose
  ];

  virtualisation = {
    containers = {
      enable = true;
      registries.search = ["docker.io"];
    };

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
