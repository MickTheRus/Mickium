{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    podman-compose
    qemu_kvm
    virt-manager
    virt-viewer
    virtiofsd
  ];

  virtualisation = {
    containers = {
      enable = true;
      registries.settings.unqualified-search-registries = ["docker.io"];
    };

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        # Run guests as the unprivileged qemu-libvirtd user, not root.
        runAsRoot = false;
        vhostUserPackages = [pkgs.virtiofsd];
      };
    };

    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;
}
