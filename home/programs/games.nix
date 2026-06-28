{pkgs, ...}:
# games
{
  home.packages = with pkgs; [
    wineWow64Packages.stableFull
    winetricks
  ];
}
