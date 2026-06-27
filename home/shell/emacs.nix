{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs:
      with epkgs; [
        treesit-grammars.with-all-grammars
        vterm
      ];
  };

  services.emacs = {
    enable = true;
    package = config.programs.emacs.finalPackage;
    client.enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
  };

  home.activation.doomSync = lib.hm.dag.entryAfter ["writeBoundary"] ''
    doom_bin="${config.xdg.configHome}/emacs/bin/doom"

    if [ -x "$doom_bin" ]; then
      PATH="${lib.makeBinPath [
      config.programs.emacs.finalPackage
      pkgs.coreutils
      pkgs.fd
      pkgs.findutils
      pkgs.git
      pkgs.gnutar
      pkgs.gzip
      pkgs.ripgrep
    ]}:$PATH" "$doom_bin" sync
    fi
  '';

  home.packages = with pkgs; [
    csharpier
    dockfmt
    fd
    multimarkdown
    nerd-fonts.symbols-only
    nixfmt
    ripgrep
    shellcheck
    shfmt
    (writeShellApplication {
      name = "doom";
      runtimeInputs = [
        config.programs.emacs.finalPackage
        fd
        git
        less
        ripgrep
      ];
      text = ''
        exec "${config.xdg.configHome}/emacs/bin/doom" "$@"
      '';
    })
  ];

  # Doom itself is pinned by flake.lock; the user's Doom modules/packages/config
  # are kept in this repo so a fresh clone has the full editor setup.
  xdg.configFile = {
    "emacs".source = inputs.doom-emacs;
    "doom".source = ./doom;
  };
}
