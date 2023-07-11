{ pkgs , ... }:
{
  # All packages installed in system profile
  enviroment = {
    systemPackages = with pkgs; [
      cargo
      compsize
      curl
      dconf
      docker-compose
      gcc 
      git
      home-manager
      htop
      lua
      neovim
      nodejs
      powertop
      pipewire
      python3Full
      tree-sitter
      unzip
      virt-manager
      wget
      wl-clipboard
      xdg-desktop-portal-hyprland
      xorg.xprop
      zip
    ];
    variables = { EDITOR = "nvim"; };
  };

  programs = {
    light.enable = true;
    dconf.enable = true;
    hyprland.enable = true;
    thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          xconf
          thunar-volman
        ];
    };
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      setOptions = ["PROMPT_SUBST" "appendhistory"];
      nix-switch = "sudo nixos-rebuild switch --flake /home/justinlime/Mickium#desktop";
    };
  };
}
