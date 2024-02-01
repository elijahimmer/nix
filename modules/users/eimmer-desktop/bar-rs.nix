{
  inputs,
  lib,
  system,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [pw-volume];
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
