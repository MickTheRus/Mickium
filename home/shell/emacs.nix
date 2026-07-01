{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  doomSourceVersion =
    inputs.doom-emacs.rev
    or inputs.doom-emacs.lastModifiedDate
    or "unknown";
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs:
      with epkgs; [
        treesit-grammars.with-all-grammars
        vterm
      ];
  };

  services.emacs = {
    enable = true;
    package = config.programs.emacs.finalPackage;
    client.enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
  };

  home.activation.installDoomEmacs = lib.hm.dag.entryAfter ["linkGeneration"] ''
    doom_dir="${config.xdg.configHome}/emacs"
    source_version="${doomSourceVersion}"
    marker="$doom_dir/.mickium-doom-source"

    if [ -L "$doom_dir" ] || [ ! -e "$marker" ] || [ "$(cat "$marker" 2>/dev/null || true)" != "$source_version" ]; then
      rm -rf "$doom_dir.tmp"
      mkdir -p "$(dirname "$doom_dir")"
      cp -R "${inputs.doom-emacs}" "$doom_dir.tmp"
      chmod -R u+rwX "$doom_dir.tmp"
      printf '%s\n' "$source_version" > "$doom_dir.tmp/.mickium-doom-source"
      rm -rf "$doom_dir"
      mv "$doom_dir.tmp" "$doom_dir"
    fi
  '';

  home.activation.doomSync = lib.hm.dag.entryAfter ["installDoomEmacs"] ''
    doom_bin="${config.xdg.configHome}/emacs/bin/doom"

    if [ -x "$doom_bin" ]; then
      export DOOMDIR="${config.xdg.configHome}/doom"
      export PATH="${lib.makeBinPath [
      config.programs.emacs.finalPackage
      pkgs.coreutils
      pkgs.fd
      pkgs.findutils
      pkgs.git
      pkgs.gnutar
      pkgs.gzip
      pkgs.ripgrep
    ]}:$PATH"

      "$doom_bin" profile sync --all || echo "warning: doom profile sync failed; continuing Home Manager activation" >&2
      "$doom_bin" sync || echo "warning: doom sync failed; continuing Home Manager activation" >&2
    fi
  '';

  home.packages = with pkgs; [
    csharpier
    dockfmt
    fd
    multimarkdown
    nerd-fonts.symbols-only
    nixfmt
    ripgrep
    shellcheck
    shfmt
    (writeShellApplication {
      name = "doom";
      runtimeInputs = [
        config.programs.emacs.finalPackage
        fd
        git
        less
        ripgrep
      ];
      text = ''
        exec "${config.xdg.configHome}/emacs/bin/doom" "$@"
      '';
    })
  ];

  # Doom itself is copied from the pinned flake input during activation because
  # Doom writes mutable state under ~/.config/emacs/.local.
  xdg.configFile = {
    "doom".source = ./doom;
  };
}
