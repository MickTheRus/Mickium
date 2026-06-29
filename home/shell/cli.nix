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

  home.file.".ssh/config".text = ''
    Host github.com
      HostName github.com
      Port 22

    Host montanamesh
      HostName 100.68.161.20
      IdentityFile ~/.ssh/montanamesh
      PreferredAuthentications publickey
      User mick
      Port 2764
      WarnWeakCrypto no-pq-kex

    Host Wormhole
      HostName 192.168.1.60
      PreferredAuthentications publickey
      IdentityFile ~/.ssh/Wormhole
      User mick
      Port 2764

    Host Maxwell
      HostName 100.87.24.100
      PreferredAuthentications publickey
      IdentityFile ~/.ssh/Personal_Computers
      User mick
      Port 2764

    Host Altar
      HostName 100.119.129.119
      PreferredAuthentications publickey
      IdentityFile ~/.ssh/Personal/Computers
      User mick
      Port 2764
  '';
}
