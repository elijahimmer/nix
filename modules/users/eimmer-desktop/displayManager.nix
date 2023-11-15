{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
        #command = "Hyprland";
      };
    };
  };
  services.getty = {
    autologinUser = "eimmer";
  };
}
