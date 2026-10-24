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

      # Home Manager adds Tide's functions, but does not run Tide's Fisher
      # first-run hook. Configure it here so fish_prompt is not empty. These are
      # global (set on every start) rather than universal, so they do not rewrite
      # fish_variables on each shell and always match this file.
      set --global VIRTUAL_ENV_DISABLE_PROMPT true
      set --global tide_left_prompt_items pwd git newline character
      set --global tide_right_prompt_items status cmd_duration jobs direnv nix_shell

      set --global tide_left_prompt_frame_enabled false
      set --global tide_right_prompt_frame_enabled false
      set --global tide_left_prompt_prefix ""
      set --global tide_left_prompt_separator_diff_color " "
      set --global tide_left_prompt_separator_same_color " "
      set --global tide_left_prompt_suffix " "
      set --global tide_right_prompt_prefix " "
      set --global tide_right_prompt_separator_diff_color " "
      set --global tide_right_prompt_separator_same_color " "
      set --global tide_right_prompt_suffix ""

      set --global tide_prompt_add_newline_before true
      set --global tide_prompt_color_frame_and_connection 6C6C6C
      set --global tide_prompt_color_separator_same_color 949494
      set --global tide_prompt_icon_connection " "
      set --global tide_prompt_min_cols 34
      set --global tide_prompt_pad_items false
      set --global tide_prompt_transient_enabled false

      set --global tide_character_icon ">"
      set --global tide_character_vi_icon_default "<"
      set --global tide_character_vi_icon_replace ">"
      set --global tide_character_vi_icon_visual "V"
      set --global tide_character_color 5FD700
      set --global tide_character_color_failure FF0000

      set --global tide_pwd_bg_color normal
      set --global tide_pwd_color_anchors 00AFFF
      set --global tide_pwd_color_dirs 0087AF
      set --global tide_pwd_color_truncated_dirs 8787AF
      set --global tide_pwd_icon ""
      set --global tide_pwd_icon_home ""
      set --global tide_pwd_icon_unwritable "!"
      set --global tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform bun.lockb Cargo.toml composer.json CVS go.mod package.json build.zig

      set --global tide_git_bg_color normal
      set --global tide_git_bg_color_unstable normal
      set --global tide_git_bg_color_urgent normal
      set --global tide_git_color_branch 5FD700
      set --global tide_git_color_conflicted FF0000
      set --global tide_git_color_dirty D7AF00
      set --global tide_git_color_operation FF0000
      set --global tide_git_color_staged D7AF00
      set --global tide_git_color_stash 5FD700
      set --global tide_git_color_untracked 00AFFF
      set --global tide_git_color_upstream 5FD700
      set --global tide_git_icon ""
      set --global tide_git_truncation_length 24
      set --global tide_git_truncation_strategy ""

      set --global tide_status_bg_color normal
      set --global tide_status_bg_color_failure normal
      set --global tide_status_color 5FAF00
      set --global tide_status_color_failure D70000
      set --global tide_status_icon "ok"
      set --global tide_status_icon_failure "err"

      set --global tide_cmd_duration_bg_color normal
      set --global tide_cmd_duration_color 87875F
      set --global tide_cmd_duration_decimals 0
      set --global tide_cmd_duration_icon ""
      set --global tide_cmd_duration_threshold 3000

      set --global tide_jobs_bg_color normal
      set --global tide_jobs_color 5FAF00
      set --global tide_jobs_icon "jobs"
      set --global tide_jobs_number_threshold 1000

      set --global tide_direnv_bg_color normal
      set --global tide_direnv_bg_color_denied normal
      set --global tide_direnv_color D7AF00
      set --global tide_direnv_color_denied FF0000
      set --global tide_direnv_icon "env"

      set --global tide_nix_shell_bg_color normal
      set --global tide_nix_shell_color 7EBAE4
      set --global tide_nix_shell_icon "nix"
    '';
  };
}
