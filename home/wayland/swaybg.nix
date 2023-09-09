{
  pkgs,
  lib,
  default,
  ...
}: {
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = ["default.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i /home/mick/Mickium/extra/wallpaper.jpg -m fill";

      Restart = "on-failure";
    };
    Install.WantedBy = ["default.target"];
  };
}
