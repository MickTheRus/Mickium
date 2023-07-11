{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      # username = "mick";
      pkgs = import nixpkgs {
        inherit system;
        config = { 
          allowUnfree = true; 
        };
      };
    in 
    {
      homeConfigurations = {
        mick = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit nixpkgs system; };
          modules = [ ./nix/users/main/home.nix ];
        };
      };

      nixosConfigurations = {
        japtop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./nix/systems/laptop/configuration.nix ];
        };
        jesktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./nix/systems/desktop/configuration.nix ];
        };
      };
    };
}
