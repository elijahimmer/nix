{
  pkgs,
  lib,
  ...
}: let
  command = "Hyprland";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe' pkgs.greetd.greetd "agetty"} --cmd \"${command}\"";
      };
      initial_session = {
        inherit command;
        user = "eimmer";
      };
    };
  };
}
