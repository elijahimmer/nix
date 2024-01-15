{
  inputs,
  lib,
  system,
  ...
}: {
  systemd = {
    user = {
      services.bar-rs = {
        wantedBy = ["hyprland-session.target"];
        script = lib.getExe inputs.bar-rs.packages.${system}.default;
        reloadIfChanged = true;
      };
    };
  };
}
