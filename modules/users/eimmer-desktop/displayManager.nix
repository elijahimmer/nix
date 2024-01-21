{pkgs, ...}: let
  command = "Hyprland";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd \"${command}\"";
      };
      initial_session = {
        command = command;
        user = "eimmer";
      };
    };
  };
}
