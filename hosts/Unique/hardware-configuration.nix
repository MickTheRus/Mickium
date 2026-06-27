# Replace this file with hardware config generated on the Unique target drive:
#
#   sudo nixos-generate-config --root /mnt
#   cp /mnt/etc/nixos/hardware-configuration.nix \
#     /mnt/home/mick/Mickium/hosts/Unique/hardware-configuration.nix
#
# The placeholder keeps the flake evaluable before the machine-specific disk
# UUIDs, filesystems, and kernel modules are generated.
{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = lib.mkDefault [];

  fileSystems = {
    "/" = {
      device = lib.mkDefault "/dev/disk/by-label/NIXOS";
      fsType = lib.mkDefault "ext4";
    };

    "/boot" = {
      device = lib.mkDefault "/dev/disk/by-label/ESP";
      fsType = lib.mkDefault "vfat";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
