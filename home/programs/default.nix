{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./xdg.nix
    ./qt.nix
    ./browser.nix
    ./gtk.nix
    ./aria2.nix
    ./swaync.nix
    ./games.nix
    ./packages.nix
    ./media.nix
    ./rofi.nix
    ./codex-desktop.nix
  ];

  programs = {
    man = {
      enable = true;
      generateCaches = true; # will take little time
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
      enableFishIntegration = true;
      enableZshIntegration = false;
      pinentry.package = pkgs.pinentry-qt;
    };
  };
}
