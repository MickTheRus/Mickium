{
  pkgs,
  lib,
  ...
}:
# configuration shared by all hosts
{
  # enable zsh autocompletion for system packages (systemd, etc)
  environment = {
    pathsToLink = ["/share/zsh"];
    variables = {
      EDITOR = "nvim";
      BROWSER = "brave";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      gitFull
      (writeScriptBin "sudo" ''exec doas "$@"'')
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  console = {
    earlySetup = true;
    keyMap = "us";
  };

  hardware.opengl.enable = true;

  # enable programs
  programs = {
    less.enable = true;
    # allow users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;

    # help manage android devices via command line
    adb.enable = true;

    bash.promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';

    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting = {
        enable = true;
        patterns = {"rm -rf *" = "fg=black,bg=red";};
        styles = {"alias" = "fg=magenta";};
        highlighters = ["main" "brackets" "pattern"];
      };
    };
  };

  # obviously your timezone here. Have a nice day or good night sleep ;)
  # Don't waste more time on nixos lol, be healthy and have some sleep. Stay healthy!
  time = {
    timeZone = "America/Denver";
    hardwareClockInLocalTime = true;
  };

  users.users.mick = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["adbusers" "input" "libvirtd" "networkmanager" "plugdev" "transmission" "video" "wheel"];
  };

  # compresses half the ram for use as swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  # NEVER EVER TOUCH THIS ⚠️
  system.stateVersion = lib.mkDefault "23.05"; # OR CRY WITH BROKE SYS
}
