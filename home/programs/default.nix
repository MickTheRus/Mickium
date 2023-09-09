{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./xdg.nix
    ./qt.nix
    ./gtk.nix
    ./dunst.nix
    ./packages.nix
    ./media.nix
    ./kitty.nix
  ];

  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark-reader
        {id = "lljedihjnnjjefafchaljkhbpfhfkdic";} # jiffy reader
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
      ];
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      pinentryFlavor = "gnome3";
    };
  };
}
