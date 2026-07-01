{inputs, ...}:
# glue all configs together
{
  # NEVER EVER TOUCH IT ⚠️
  config.home.stateVersion = "24.05"; # OR CRY WITH BROKE SYS

  imports = [
    inputs.nix-index-db.homeModules.nix-index
    inputs.codex-desktop-linux.homeManagerModules.default
    ./security
    ./shell
    ./programs
    ./wayland
  ];
}
