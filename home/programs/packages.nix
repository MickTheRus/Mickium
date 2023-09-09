{pkgs, ...}: {
  home.packages = with pkgs; [
    # misc
    libnotify
    xdg-utils
    prismlauncher-qt5
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    keepassxc
  ];
}
