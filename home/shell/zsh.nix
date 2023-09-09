{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".config/shell/sources.sh".source = config.lib.file.mkOutOfStoreSymlink "/home/mick/home/shell/sources.sh";

  programs.zsh = {
    enable = true;
    dotDir = ".config/shell";
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history.extended = true;

    dirHashes = {
      dl = "$HOME/Downloads";
      docs = "$HOME/Documents";
      code = "$HOME/Mickium/codes";
      dots = "$HOME/Mickium/";
      pics = "$HOME/Pictures";
      vids = "$HOME/Videos";
      nixpkgs = "$HOME/Mickium/forks/nixpkgs";
    };

    envExtra = ''
       export PATH="$PATH:/home/mick/Mickium/bin:$HOME/.local/bin"
      export EITOR="nvim"
       export VISUAL=$EDITOR
       export STARDICT_DATA_DIR="$HOME/.local/share/stardict"
       export GRIM_DEFAULT_DIR="$HOME/Pictures/"

       	if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
           exec Hyprland
        	fi
    '';

    initExtra = ''
      source ~/Mickium/home/shell/sources.sh

      source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      source "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
      source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      source "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh"
      source "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh"
      source "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh"

    '';

    history = {
      save = 10000;
      size = 10000;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      path = "${config.xdg.configHome}/shell/zsh_history";
    };
  };
}