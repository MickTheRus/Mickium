{pkgs, ...}: {
  # Unofficial Linux build of OpenAI's Codex Desktop (Electron app converted
  # from the upstream macOS DMG). Provided by the codex-desktop-linux flake
  # input; see https://github.com/ilysenko/codex-desktop-linux
  programs.codexDesktopLinux = {
    enable = true;

    # Wraps the launcher so it always finds the Codex CLI (already installed
    # via home.packages in ./packages.nix) instead of relying on session PATH.
    cliPackage = pkgs.codex;
  };
}
