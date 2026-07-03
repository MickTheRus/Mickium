{inputs, ...}:
# glue all configs together
{
  config.home.stateVersion = "26.05";

  imports = [
    inputs.nix-index-db.homeModules.nix-index
    inputs.codex-desktop-linux.homeManagerModules.default
    ./security
    ./shell
    ./programs
    ./wayland
  ];
}
