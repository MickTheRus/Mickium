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
