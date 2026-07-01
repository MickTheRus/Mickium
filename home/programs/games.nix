{pkgs, ...}:
# games
{
  home.packages = with pkgs; [
    wineWow64Packages.stableFull
    winetricks

    # Java runtimes for Prism Launcher; different Minecraft versions/mod
    # loaders need different JDKs, set per-instance in Settings > Java.
    # jdk22 was requested but nixpkgs dropped it upstream (short-lived
    # non-LTS release); jdk21 is the current LTS and covers modern
    # Minecraft/mod requirements instead.
    jdk17
    jdk21
  ];
}
