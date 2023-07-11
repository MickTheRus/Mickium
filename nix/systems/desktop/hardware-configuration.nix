# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9c3f89cf-f24b-45a1-b256-618896c1d1d0";
    fsType = "btrfs";
    options = [ "compress=zstd:1" "noatime" "subvol=root" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/9c3f89cf-f24b-45a1-b256-618896c1d1d0";
    fsType = "btrfs";
    options = [ "compress=zstd:1" "noatime" "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/9c3f89cf-f24b-45a1-b256-618896c1d1d0";
    fsType = "btrfs";
    options = [ "compress=zstd:1" "noatime" "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FC74-CDE4";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
