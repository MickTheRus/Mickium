{
  pkgs,
  ...
}:
# games
{
  home.packages = with pkgs; [
    openttd
    superTux
    # superTuxkart
  ];
}
