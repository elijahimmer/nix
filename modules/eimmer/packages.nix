{...}: {
  home-manager.users.eimmer = {pkgs, ...}: {
    home.packages = with pkgs; [
      notify-desktop
      evince
    ];
  };
}
