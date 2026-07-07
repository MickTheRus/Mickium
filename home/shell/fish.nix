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

      # Home Manager adds Tide's functions, but does not run Tide's Fisher
      # first-run hook. Configure it here so fish_prompt is not empty.
      set --universal VIRTUAL_ENV_DISABLE_PROMPT true
      set --universal tide_left_prompt_items pwd git newline character
      set --universal tide_right_prompt_items status cmd_duration jobs direnv nix_shell

      set --universal tide_left_prompt_frame_enabled false
      set --universal tide_right_prompt_frame_enabled false
      set --universal tide_left_prompt_prefix ""
      set --universal tide_left_prompt_separator_diff_color " "
      set --universal tide_left_prompt_separator_same_color " "
      set --universal tide_left_prompt_suffix " "
      set --universal tide_right_prompt_prefix " "
      set --universal tide_right_prompt_separator_diff_color " "
      set --universal tide_right_prompt_separator_same_color " "
      set --universal tide_right_prompt_suffix ""

      set --universal tide_prompt_add_newline_before true
      set --universal tide_prompt_color_frame_and_connection 6C6C6C
      set --universal tide_prompt_color_separator_same_color 949494
      set --universal tide_prompt_icon_connection " "
      set --universal tide_prompt_min_cols 34
      set --universal tide_prompt_pad_items false
      set --universal tide_prompt_transient_enabled false

      set --universal tide_character_icon ">"
      set --universal tide_character_vi_icon_default "<"
      set --universal tide_character_vi_icon_replace ">"
      set --universal tide_character_vi_icon_visual "V"
      set --universal tide_character_color 5FD700
      set --universal tide_character_color_failure FF0000

      set --universal tide_pwd_bg_color normal
      set --universal tide_pwd_color_anchors 00AFFF
      set --universal tide_pwd_color_dirs 0087AF
      set --universal tide_pwd_color_truncated_dirs 8787AF
      set --universal tide_pwd_icon ""
      set --universal tide_pwd_icon_home ""
      set --universal tide_pwd_icon_unwritable "!"
      set --universal tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform bun.lockb Cargo.toml composer.json CVS go.mod package.json build.zig

      set --universal tide_git_bg_color normal
      set --universal tide_git_bg_color_unstable normal
      set --universal tide_git_bg_color_urgent normal
      set --universal tide_git_color_branch 5FD700
      set --universal tide_git_color_conflicted FF0000
      set --universal tide_git_color_dirty D7AF00
      set --universal tide_git_color_operation FF0000
      set --universal tide_git_color_staged D7AF00
      set --universal tide_git_color_stash 5FD700
      set --universal tide_git_color_untracked 00AFFF
      set --universal tide_git_color_upstream 5FD700
      set --universal tide_git_icon ""
      set --universal tide_git_truncation_length 24
      set --universal tide_git_truncation_strategy ""

      set --universal tide_status_bg_color normal
      set --universal tide_status_bg_color_failure normal
      set --universal tide_status_color 5FAF00
      set --universal tide_status_color_failure D70000
      set --universal tide_status_icon "ok"
      set --universal tide_status_icon_failure "err"

      set --universal tide_cmd_duration_bg_color normal
      set --universal tide_cmd_duration_color 87875F
      set --universal tide_cmd_duration_decimals 0
      set --universal tide_cmd_duration_icon ""
      set --universal tide_cmd_duration_threshold 3000

      set --universal tide_jobs_bg_color normal
      set --universal tide_jobs_color 5FAF00
      set --universal tide_jobs_icon "jobs"
      set --universal tide_jobs_number_threshold 1000

      set --universal tide_direnv_bg_color normal
      set --universal tide_direnv_bg_color_denied normal
      set --universal tide_direnv_color D7AF00
      set --universal tide_direnv_color_denied FF0000
      set --universal tide_direnv_icon "env"

      set --universal tide_nix_shell_bg_color normal
      set --universal tide_nix_shell_color 7EBAE4
      set --universal tide_nix_shell_icon "nix"
    '';
  };
}
