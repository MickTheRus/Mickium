{
  description = "Dumbass' lil config";

  inputs = {
    # Change it to stable, if you want stable channel (23.05)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # For Adblocking and making internet usable
    hosts.url = "github:StevenBlack/hosts";

    # nix index to locate package/path
    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home to manage all user configs
    # You can you use normal config files,
    # just use an org heading and create block and tangle it directly to ~/.config/tool/file path.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    meshcore-cli = {
      url = "github:meshcore-dev/meshcore-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        alejandra
        deadnix
        git
        nil
        statix
      ];
      name = "Mickium";
      DIRENV_LOG_FORMAT = "";
    };

    formatter.${system} = pkgs.writeShellApplication {
      name = "format-nix";
      runtimeInputs = [pkgs.alejandra];
      text = ''
        if [ "$#" -eq 0 ]; then
          alejandra .
        else
          alejandra "$@"
        fi
      '';
    };

    nixosConfigurations = import ./hosts inputs;
  };
}
