{pkgs, ...}: {
  programs.fish = {
    enable = true;

    shellAliases = {
      docker = "podman";
      docker-compose = "podman-compose";
      e = "emacs -nw";
      nvim = "emacs -nw";
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

      # Home Manager adds Tide's functions but does not run its Fisher install
      # hook, so apply Tide's own Classic preset once. Bump the version below to
      # re-apply after changing the options. Tide stores the result in universal
      # variables, so `tide configure` can still be run by hand; that will be
      # overwritten the next time this version changes.
      set --universal VIRTUAL_ENV_DISABLE_PROMPT true
      if test "$_mickium_tide_config" != 1
        tide configure --auto \
          --style=Classic \
          --prompt_colors='True color' \
          --show_time=No \
          --classic_prompt_color=Dark \
          --classic_prompt_separators=Angled \
          --powerline_prompt_heads=Sharp \
          --powerline_prompt_tails=Flat \
          --powerline_prompt_style='Two lines, character' \
          --powerline_right_prompt_frame=No \
          --prompt_connection=Disconnected \
          --prompt_connection_andor_frame_color=Dark \
          --prompt_spacing=Sparse \
          --icons='Many icons' \
          --transient=No \
          >/dev/null
        and set --universal _mickium_tide_config 1
      end
    '';
  };
}
