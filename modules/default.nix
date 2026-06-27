{...}: {
  imports = [
    ./core.nix
    ./bootloader.nix
    ./desktop.nix
    ./containers.nix
    ./network.nix
    ./nix.nix
    ./security.nix
    ./bluetooth.nix
  ];
}
