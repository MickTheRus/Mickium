{
  pkgs,
  config,
  lib,
  ...
}: {
  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
        vaapiVdpau
        libvdpau-va-gl
        vaapiIntel
      ];
      driSupport = true;
    };
  };
}
