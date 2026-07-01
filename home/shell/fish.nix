{pkgs, ...}: {
  programs.fish = {
    enable = true;

    shellAliases = {
      docker = "podman";
      docker-compose = "podman-compose";
      e = "emacs -nw";
      nvim = "emacs -nw";
      sudo = "doas";
      v = "emacs -nw";
      vi = "emacs -nw";
      vim = "emacs -nw";
    };

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];

    interactiveShellInit = ''
      set --global sponge_delay 2
      set --global sponge_purge_only_on_exit false
      set --global sponge_allow_previously_successful true
      set --global sponge_successful_exit_codes 0
    '';
  };
}
