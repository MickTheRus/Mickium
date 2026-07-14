{pkgs, ...}:
# games
{
  home.packages = with pkgs; [
    heroic
    evtest
    jstest-gtk
    wineWow64Packages.stableFull
    winetricks
  ];

  # Keep each JDK in its own stable path instead of merging both into
  # home.packages, where their identically named binaries would collide.
  # Select the required bin/java per instance in Prism's Java settings.
  xdg.dataFile = {
    "java/jdk17".source = pkgs.jdk17;
    "java/jdk21".source = pkgs.jdk21;
  };
}
