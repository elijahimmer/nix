{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.mein.eimmer.headFull.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "Hyprland";
          user = "eimmer";
        };
      };
    };
  };
}
