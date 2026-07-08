{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
    settings = {
      General = {
        Class = "0x000100";
        Experimental = false;
        FastConnectable = true;
        JustWorksRepairing = "always";
        Privacy = "device";
      };
      LE = {
        ConnectionLatency = 0;
        MaxConnectionInterval = 9;
        MinConnectionInterval = 7;
      };
    };
    input = {
      General = {
        UserspaceHID = true;
      };
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
