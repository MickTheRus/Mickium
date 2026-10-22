{
  pkgs,
  lib,
  ...
}:
# configuration shared by all hosts
{
  environment = {
    variables = {
      EDITOR = "emacsclient -nw -a emacs";
      VISUAL = "emacsclient -c -a emacs";
      BROWSER = "brave";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      android-tools
      gitFull
      nh
      (writeScriptBin "sudo" ''exec doas "$@"'')
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # saves space
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  # Sets big font for bootloader, as I have small laptop.
  # You can remove font and packages line to have default font kernel chooses.
  console = {
    earlySetup = true;
    keyMap = "us";
  };

  # enable programs
  programs = {
    less.enable = true;
    pay-respects.enable = true;
    fish.enable = true;

    # allow users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;
  };

  time = {
    timeZone = "America/Denver";
    hardwareClockInLocalTime = true;
  };

  users.users = {
    mick = {
      isNormalUser = true;
      initialPassword = "123";
      shell = pkgs.fish;
      extraGroups = ["adbusers" "dialout" "input" "libvirtd" "networkmanager" "plugdev" "transmission" "video" "wheel"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFV9Ci8nsG9Cv2SLq8ypLQCgs3fIoz06WLMAxCBYOaT mick@Maxwell"
      ];
    };
  };

  # compresses half the ram for use as swap
  zramSwap = {
    enable = false;
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspendThenHibernate = "yes";
    HibernateDelaySec = "3600";
  };

  systemd.services.home-manager-mick.serviceConfig.TimeoutStartSec = lib.mkForce "30m";

  system.stateVersion = lib.mkDefault "26.05";
}
