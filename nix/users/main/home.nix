{ config, pkgs, lib, ... }:
let
  username = "mick";
in
{
  imports = [
  ./dotfiles.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  home.shellAliases = {
      home-switch = "home-manager switch --flake ~/Mickium#mick";
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  # Overlays/Overrides
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
  ];
  
  # Packages
  home.packages = with pkgs; [
    brave
    (discord.override {withOpenASAR = true; })
    gimp
    go
    grim globc
    neofetch
    neovim
    pavucontrol
    rofi-wayland
    slurp
    swaybg
    swaylock-effects
    swayidle
    waybar
    (nerdfonts.override { fonts = [ "Iosevka" ];})

    # Language Servers:
    csharp-ls
    lua-language-server
    nil
    gopls
    rust-analyzer
    # python311Packages.
    nodePackages_latest.vscode-langservers-extracted
    nodePackages_latest.grammarly-languageserver
    nodePackages_latest.typescript-language-server
    nodePackages_latest.bash-language-server
    nodePackages_latest.dockerfile-language-server-nodejs
    nodePackages_latest.yaml-language-server
  ];
  home.stateVersion = "23.05";
}
