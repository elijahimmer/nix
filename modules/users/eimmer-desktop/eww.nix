{...}: {
  home-manager.users.eimmer = {pkgs, ...}: {
    programs.eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./eww;
    };
  };
}
