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
            systemd-boot = {
              enable = true;
              # Kernels/entries go to XBOOTLDR (/boot = sda4),
              # only the EFI binary goes to the ESP (/efi = sda2/Ventoy EFI)
              xbootldrMountPoint = "/boot";
            };
            efi = {
              canTouchEfiVariables = lib.mkForce false;
              efiSysMountPoint = "/efi";
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
