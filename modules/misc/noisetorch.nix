{pkgs, lib, ...}: {
  systemd.user.services.noisetorch = {
    wantedBy = ["hyprland-session.target"];
    script = "${lib.getExe pkgs.noisetorch} -i";
  };
}
