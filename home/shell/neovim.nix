{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [kitty gcc ripgrep fd];
  };
}
