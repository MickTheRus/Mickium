{
  self,
  nixpkgs,
  ...
}: let
  lib = nixpkgs.lib;
  inherit (self) inputs;
  bootloader = ../modules/bootloader.nix;
  core = ../modules;
  hmModule = inputs.home-manager.nixosModules.home-manager;
  blockhost = inputs.hosts.nixosModule;

  shared = [core];
  altarGpuCompute = {pkgs, ...}: {
    hardware.graphics.extraPackages = [
      pkgs.mesa.opencl
    ];

    # Altar's current GPU is AMD Barcelo/Renoir-class integrated graphics.
    # Use Mesa Rusticl rather than Intel OpenCL or the heavier ROCm stack.
    environment.sessionVariables.RUSTICL_ENABLE = "radeonsi";
  };
  # Hibernate target for suspend-then-hibernate. Root is btrfs, so the swapfile
  # lives in its own nested subvolume (`btrfs subvolume create /swap`), which
  # keeps it out of snapshots and NoCoW. resume_offset comes from
  # `btrfs inspect-internal map-swapfile -r /swap/swapfile` and must be redone
  # if the swapfile is ever recreated or resized.
  altarSwap = {lib, ...}: {
    # protectKernelImage adds `nohibernate` (and blocks kexec), which makes
    # hibernate impossible. Altar needs hibernate, so override it here.
    security.protectKernelImage = lib.mkForce false;

    boot = {
      resumeDevice = "/dev/disk/by-uuid/ad31b8e7-def5-4b96-89f8-0a52465dffc0";
      kernelParams = ["resume_offset=33056037"];
    };

    swapDevices = [
      {
        device = "/swap/swapfile";
        size = 16 * 1024;
      }
    ];
  };
  maxwellGpuCompute = {...}: {
    # Maxwell has a Ryzen 5800X3D and Radeon 9070-class GPU, so use AMD's
    # ROCm OpenCL runtime rather than the Mesa fallback used on Altar.
    hardware.amdgpu.opencl.enable = true;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.mick = ../home;
  };
in {
  # desktop
  maxwell = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "Maxwell";}
        ./Maxwell/hardware-configuration.nix
        maxwellGpuCompute
        bootloader
        hmModule
        {inherit home-manager;}
        blockhost
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # lenovo laptop
  altar = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "Altar";}
        ./Altar/hardware-configuration.nix
        altarGpuCompute
        altarSwap
        bootloader
        hmModule
        {inherit home-manager;}
        blockhost
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # Ventoy-adjacent portable system drive
  wortox = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "Wortox";}
        ./Wortox/hardware-configuration.nix
        bootloader
        {
          boot.loader = {
            systemd-boot.enable = true;
            efi = {
              canTouchEfiVariables = lib.mkForce false;
              efiSysMountPoint = "/boot";
            };
          };
        }
        hmModule
        {inherit home-manager;}
        blockhost
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };
}
