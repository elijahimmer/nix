{...}: {
  home-manager.users.eimmer = {pkgs, ...}: {
    home.packages = [pkgs.notify-desktop];
  };
}
