{
  config,
  lib,
  inputs,
  ...
}: {
  environment = {
    # set channels (backwards compatibility)
    etc = {
      "gitconfig".text = ''
        [safe]
          directory = /home/mick/Mickium
      '';
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.home-manager;
    };
  };

  nixpkgs = {
    config = {
      permittedInsecurePackages = [
        "ventoy-1.1.12"
      ];
      allowUnfree = true;
      allowBroken = false;
    };
    overlays = [
      (_final: prev: let
        hyprlandPkgs = import inputs.nixpkgs-hyprland {
          system = prev.stdenv.hostPlatform.system;
          config = {
            allowUnfree = true;
            allowBroken = false;
          };
        };
      in {
        hyprland = hyprlandPkgs.hyprland;
        hyprlandPlugins = hyprlandPkgs.hyprlandPlugins;
        hyprland-protocols = hyprlandPkgs.hyprland-protocols;
        hyprwayland-scanner = hyprlandPkgs.hyprwayland-scanner;
        xdg-desktop-portal-hyprland = hyprlandPkgs.xdg-desktop-portal-hyprland;
      })
    ];
  };

  # TODOTHIS: Got some error on docbook,
  # see-> https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/misc/documentation.nix

  # faster rebuilding
  documentation = {
    enable = true;
    nixos.enable = true;
    doc.enable = true;
    info.enable = true;
    man = {
      enable = true;
      cache.enable = true; # will take little time
    };
    dev.enable = true;
  };

  # Collect garbage and delete generation every 6 day. Will help to get some storage space.
  # Better to atleast keep it for few days, as you do major update (unstable), if something breaks you can roll back.
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Make builds run with low priority so my system stays responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      flake-registry = "/etc/nix/registry.json";
      auto-optimise-store = true;
      builders-use-substitutes = true;
      # allow sudo users to mark the following values as trusted
      allowed-users = ["@wheel"];
      # only allow sudo users to manage the nix store
      trusted-users = ["@wheel" "root"];
      keep-outputs = true;
      warn-dirty = false;
      keep-derivations = true;
      sandbox = true;
      max-jobs = "auto";
      # continue building derivations if one fails
      keep-going = true;
      log-lines = 20;
      experimental-features = ["flakes" "nix-command"];

      # use binary cache, its not gentoo
      # substituters = [
      #   "https://nix-community.cachix.org"
      # ];
      #
      # trusted-public-keys = [
      #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # ];
    };
  };
  system.autoUpgrade.enable = true;
}
