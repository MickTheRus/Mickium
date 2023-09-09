{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withPython3 = true;

    extraPackages = with pkgs; [gcc ripgrep fd];
  };
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/Mickium/home/shell/nvim";
}
