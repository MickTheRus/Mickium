{pkgs, ...}: {
  home.packages = with pkgs; [
    # misc
    libnotify
    xdg-utils
   
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })



    keepassxc
  ];
}
