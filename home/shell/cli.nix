{lib, pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip
    rar
    fzf
    # wonderful spells
    aspell
    aspellDicts.en-science
    aspellDicts.en
    hunspell
    hunspellDicts.en-us

    ffmpeg-full
    sdcv
    nq
    # utils
    cabextract
    file
    dust
    fd
    picocom
    usbutils
    wget
  ];

  programs = {
    nix-index.enable = true;
    eza = {
      enable = true;
      extraOptions = ["--group-directories-first" "--header"];
      icons = "auto";
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
        "--ignore-case"
      ];
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
        vim_keys = true;
        shown_boxes = "proc cpu";
        rounded_corners = true;
        graph_symbol = "block";
        proc_sorting = "memory";
        proc_reversed = false;
        proc_gradient = true;
      };
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batman batgrep batwatch];
      config = {
        pager = "less -FR";
        theme = "TwoDark";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "Altar" = lib.hm.dag.entryBefore ["*"] {
          HostName = "100.119.129.119";
          PreferredAuthentications = "publickey";
          IdentityFile = "~/.ssh/Personal/Computers";
          User = "mick";
          Port = 2764;
        };
        "github.com" = lib.hm.dag.entryBefore ["*"] {
          HostName = "github.com";
          Port = 22;
        };
        "*" = {
          Port = 2764;
        };
      };
    };

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'eza --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };
  };
}
