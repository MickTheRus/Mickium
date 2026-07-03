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
      enableFishIntegration = true;
      enableZshIntegration = false;
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
