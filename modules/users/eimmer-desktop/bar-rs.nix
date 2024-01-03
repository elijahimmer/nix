{
  inputs,
  lib,
  ...
}: {
  systemd = {
    user = {
      services.bar-rs = {
        wantedBy = ["hyprland-session.target"];
        script = lib.getExe inputs.bar-rs.packages.x86_64-linux.default;
        reloadIfChanged = true;
      };
    };
  };
}
