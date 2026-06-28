{pkgs, ...}: {
  home.packages = with pkgs; [
    # better to manage it via development shell

    # shell
    bash-language-server

    # basic stack
    vscode-langservers-extracted
    hugo
    monolith

    ### python
    # python3Packages.python-lsp-server
    # pyright
    (python3.withPackages (ps:
      with ps; [
        python-lsp-server
        python-lsp-black
        python-lsp-ruff
      ]))

    # core comp
    gcc
    gnumake
    tree-sitter
    parallel

    # science
    # blast
    julia

    # R
    (rWrapper.override {
      packages = with rPackages; [
        ggplot2
        # dplyr
        # tidyverse # set of 9 packages
        languageserver
        lintr
        # stringr
        # httr
        # ggvis
        # shiny
        # rio
        # rmarkdown
      ];
    })

    # nix
    nil
    nixd

    # json/lua/yaml/markdown
    lua-language-server
    marksman
    yaml-language-server

    # alltex
    # texlive.combined.scheme-full
    texliveSmall
  ];

  programs = {
    gpg.enable = true;
    man.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };
  };
}
