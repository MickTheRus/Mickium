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
    # Let the kernel HID stack/xpadneo own Bluetooth controllers. BlueZ
    # userspace HID can expose only a partial controller profile to games.
    input = {
      General = {
        UserspaceHID = false;
      };
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
