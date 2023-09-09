{
  pkgs,
  lib,
  default,
  ...
}: {
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      PartOf = ["default.target"];
    };
    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &";
      Restart = "on-failure";
    };

    Install.WantedBy = ["default.target"];
  };
}
