{
  self,
  nixpkgs,
  ...
}: let
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
}
