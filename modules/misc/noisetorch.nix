{pkgs, lib, ...}: {
  systemd.services.noisetorch = {
    wants = ["hyprland-session.target"];
    script = "${lib.getExe pkgs.noisetorch} -i";
  };
}
