{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    openjdk11
    google-java-format
    imv
    xdg-utils
    noisetorch
  ];

  home-manager.users.eimmer = {pkgs, ...}: {
    home.packages = with pkgs; [
      notify-desktop
    ];

    programs.zathura.enable = true;
  };
}
