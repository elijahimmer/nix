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
        inherit command;
        user = "eimmer";
      };
     # initial_session = {
     #   inherit command;
     #   user = "eimmer";
     # };
    };
  };
}
