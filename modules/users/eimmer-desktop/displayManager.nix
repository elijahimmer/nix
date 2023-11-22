{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        #         command = "Hyprland";

        command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
        #user = "greetd";
      };
      #initial_session = {
      #command = "Hyprland";
      # user = "eimmer";
      #};
    };
  };
  services.getty = {
    #autologinUser = "eimmer";
  };
}
